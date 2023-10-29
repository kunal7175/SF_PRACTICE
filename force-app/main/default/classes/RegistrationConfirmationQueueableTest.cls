@IsTest
public with sharing class RegistrationConfirmationQueueableTest {
    @TestSetup
    static void setup() {
        Contact contact = new Contact();
        contact.FirstName = 'Test';
        contact.LastName = 'Contact';
        contact.Email = 'test@email.com';
        insert contact;

        Training__c training = new Training__c();
        training.Name = 'Test Training';
        insert training;

        Participant__c participant = new Participant__c();
        participant.Training__c = training.Id;
        participant.Contact_Name__c = contact.Id;
        insert participant;
    }

    @IsTest
    public static void enqueueJob_UnitTest() {
        List<Participant__c> participants = [SELECT Id FROM Participant__c];
        Set<Id> participantIds = (new Map<Id, Participant__c>(participants)).keySet();

        Test.startTest();
        Id jobId = System.enqueueJob(new RegistrationConfirmationQueueable(participantIds));
        Test.stopTest();

        AsyncApexJob job = [SELECT Id, Status, JobType, ApexClass.Name FROM AsyncApexJob WHERE Id = :jobId];

        Assert.areEqual('Completed', job.Status);
        Assert.areEqual('Queueable', job.JobType);    
        Assert.areEqual('RegistrationConfirmationQueueable', job.ApexClass.Name);
    }
}