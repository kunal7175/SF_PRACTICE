@isTest
private class ERPCalloutTest {

    @TestSetup
    static void setup(){

        List<Contact> contacts = new List<Contact>();
        List<Participant__c> participants = new List<Participant__c>();

        Contact trainer = new Contact();
        trainer.FirstName = 'Test';
        trainer.LastName = 'Trainer';
        trainer.Email = 'igor@mail.com';
        contacts.add(trainer);

        for(Integer i = 0; i < 5; i++){
            Contact contact = new Contact();
            contact.firstName = 'Test' + i;
            contact.lastName = 'Student '+ i;
            contact.Email = 'email@mail.com';
            contacts.add(contact);
        }

        insert contacts;

        Training__c training = new Training__c();
        training.Name ='SF Queueable Apex';
        training.Trainer_Contact__c = trainer.Id;
        training.Number_of_Participants__c = 10;
        insert training;
    }

    @isTest
    static void testSendToERP(){

        Test.setMock(HttpCalloutMock.class, new PaymentLinkCalloutMock());
        
        List<Participant__c> participants = new List<Participant__c>();
        List<Id> participantId = new List<Id>();

        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName != 'Trainer'];
        Training__c training = [SELECT Id FROM Training__c WHERE Name = 'SF Queueable Apex'];

        for(Contact contact : contacts) {
            Participant__c participant = new Participant__c();
            participant.Contact_Name__c = contact.Id;
            participant.Training__c = training.Id;
            participant.Status__c = 'In Queue';
            participants.add(participant);
        }

        Test.startTest();
        insert participants;
        Test.stopTest();

        Test.setMock(HttpCalloutMock.class, new ERPCalloutMock());

        participantId.add(participants.get(0).Id);
        List<String> erpIdList = ERPCallout.sendToERP(participantId);
        Assert.areEqual(ERPCalloutMock.ERPID, erpIdList.get(0));
}

}