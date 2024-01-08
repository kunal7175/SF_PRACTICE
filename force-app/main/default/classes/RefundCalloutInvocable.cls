public with sharing class RefundCalloutInvocable {

    @InvocableMethod(label = 'Send participant for Refund')
    public static void getRefund(List<Id> participantId){

        Participant__c participant = [
            SELECT Id, (SELECT Id, invoice_id__c FROM Invoices__r), Training__r.price__c, Training__r.Name, invoice_p_id__c 
            FROM Participant__c 
            WHERE Id IN :participantId
        ];
        
        String body = ProcessRefund.applyForRefund(participant);
        RefundWrapper refundWrapper = (RefundWrapper) JSON.deserialize(
            body, 
            RefundWrapper.class
        );

        System.debug(refundWrapper);
        
        Refund__c refund = new Refund__c();
        refund.amount__c = refundWrapper.amount;
        refund.status__c =refundWrapper.status;
        refund.refund_id__c = refundWrapper.refund_id;
        insert refund;
        System.debug(refund);
        System.enqueueJob(new RefundStatusQueueable(refund.refund_id__c));
    

    }
}