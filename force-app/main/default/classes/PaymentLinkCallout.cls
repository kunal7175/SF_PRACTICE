public with sharing class PaymentLinkCallout {

    public static final String URL = 'https://735ef563-176d-431c-85ce-2cc07056ef03.mock.pstmn.io/payments/link';
    public static final String GET_METHOD = 'GET';

    public static String requestPaymentLink(Participant__c participant) {
        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL);
        request.setMethod(GET_METHOD);
        HttpResponse response = http.send(request);

        String paymentLink = parseLinkFromJSON(response.getBody());
        
        return paymentLink;
    }

    private static String parseLinkFromJSON(String jsonBody) {
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);
        Map<String, Object> payer = (Map<String, Object>) results.get('payer');

        String paymentLink = (String) payer.get('link');
        return paymentLink;
    }

    /*
    public static HttpResponse requestPaymentLink(Set<Id> participantIds){

        List<Participant__c> participants = [
            SELECT Id, Name, Contact_Name__r.Name, Contact_Name__r.Email, PaymentLink__c
            FROM Participant__c
            WHERE Id IN :participantIds
        ];

        List<Participant__c> updatedParticipants = new List<Participant__c>();
        HttpResponse response;

        for(Participant__c participant : participants){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://735ef563-176d-431c-85ce-2cc07056ef03.mock.pstmn.io/payments/link');
            request.setMethod('GET');
            response = http.send(request);
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> payer = (Map<String, Object>) results.get('payer');
            String paymentLink= (String) payer.get('link');
            participant.PaymentLink__c=paymentLink;
            updatedParticipants.add(participant);
        }

        update updatedParticipants;
        //sendPaymentEmail(updatedParticipants);
        return response;
    } 

    public static void sendPaymentEmail(List<Participant__c> participants){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        for(Participant__c participant : participants){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String> {participant.Contact_Name__r.Email});
            String body = 'Dear '+ participant.Contact_Name__r.Name + ',' + '<br/>';
            body += 'To complete your registration, please make a payment by clicking on the link below:'+ '<br/>';
            body += participant.PaymentLink__c + '<br/>';
            body += 'Best regards,'+ '<br/>';
            body += 'Cloud Prism';
            email.setHtmlBody(body);
            mails.add(email);
        }

        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }

    }*/
}
    
