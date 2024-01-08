public with sharing class ProcessRefund {

    public static final String POST_METHOD = 'POST';
    public static final String REFUND_URL  ='https://leaflix-2-3e22d4a85a3a.herokuapp.com/refunds/';

    public static String applyForRefund(Participant__c participant){
        Http http = new http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(REFUND_URL);
        request.setMethod(POST_METHOD);
        request.setHeader('Content-Type','application/json');
        request.setHeader('accept', 'application/json');
        String token = PaymentLinkWebHookCallout.getAccessToken();
        String body = createRefundBody(participant.Training__r.price__c, participant.invoice_p_id__c, token, participant.Id);
        request.setBody(body);
        HttpResponse response = http.send(request);
        return response.getBody();
    }

    private static String createRefundBody(Decimal amount, String invoiceId, String token, Id participantId){
        RefundWrapper refund = new RefundWrapper();

        refund.amount = amount;
        refund.invoice_id = invoiceId;
        refund.token = token;
        refund.participant_id = participantId;

        return JSON.serialize(refund);
    }
    
}