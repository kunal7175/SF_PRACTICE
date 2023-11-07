@istest
private class PaymentLinkCalloutTest{

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

        contacts.remove(0);
    }

    /*
    @TestSetup
    static void createData(){
        Test.setMock(HttpCalloutMock.class, new PaymentLinkCalloutMock());

        List<Contact> contacts = new List<Contact>();
        List<Participant__c> participants = new List<Participant__c>();

        Contact c = new Contact();
        C.firstName='Test';
        c.lastName='Trainer';
        c.Email='arorakunal850@gmail.com';
        insert c; 

        Training__c training = new Training__c();
        training.Name ='SF Queueable Apex';
        training.Trainer_Contact__c = c.id;
        training.Number_of_Participants__c = 10;
        insert training;

        for(Integer i=0; i<5; i++){
            Contact con = new Contact();
            con.firstName = 'Test';
            con.lastName = 'Student '+ i;
            con.Email = 'kunalarora96@hotmail.com';
            Participant__c p = new Participant__c();
            p.Contact_Name__c = con.id;
            p.Training__c = training.id;
            p.Status__c = 'In Queue';
            participants.add(p);
            contacts.add(con);
        }

        insert contacts;
        insert participants;
    }*/

    @isTest
    static void testRequestPaymentLinkCallout(){
        Test.setMock(HttpCalloutMock.class, new PaymentLinkCalloutMock());

        List<Participant__c> participants = new List<Participant__c>();

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

        // Queueable was placed

        for(Participant__c participant : participants) {
            Assert.notNull(participant.Payment_Link__c);
            Assert.areEqual(PaymentLinkCalloutMock.LINK, participant.Payment_Link__c);
        }

        // String paymentLink = PaymentLinkCallout.requestPaymentLink(participants.get(0));
        //System.debug(paymentLink);
     }

    @isTest
    static void testRequestLink() {
        Participant__c participant = new Participant__c();

        Test.startTest();
        String paymentLink = PaymentLinkCallout.requestPaymentLink(participant);
        Test.stopTest();
        
        Assert.areEqual(PaymentLinkCalloutMock.LINK, paymentLink);
    }

    
}