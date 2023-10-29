@IsTest
public with sharing class ParticipantTriggerTest {

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
    }

    @IsTest
    public static void enqueueJob_UnitTest() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        Training__c training = [SELECT Id FROM Training__c LIMIT 1];

        Participant__c participant = new Participant__c();
        participant.Training__c = training.Id;
        participant.Contact_Name__c = contact.Id;

        Test.startTest();
        insert participant;
        Test.stopTest();

        AsyncApexJob job = [
            SELECT Id, Status, JobType, ApexClass.Name 
            FROM AsyncApexJob 
            WHERE ApexClass.Name = 'RegistrationConfirmationQueueable'
        ];

        Assert.areEqual('Completed', job.Status);
        Assert.areEqual('Queueable', job.JobType);    
    }
}