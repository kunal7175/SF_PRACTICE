public with sharing class RefundStatusQueueable implements Queueable, Database.AllowsCallouts {

    public static final String GET_METHOD = 'GET';
    public static final String REFUND_URL  ='https://leaflix-2-3e22d4a85a3a.herokuapp.com/refunds/';

    public String externalRefundId;

    public static Integer RETRY_DELAY;

    public RefundStatusQueueable(String externalRefundId) {
        this.externalRefundId = externalRefundId;
        System.debug('inside contructor');
    }

    public void execute(QueueableContext context){
        String token = PaymentLinkWebHookCallout.getAccessToken();

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(REFUND_URL + this.externalRefundId + '/?token='+token);
        request.setMethod(GET_METHOD);
        request.setHeader('Content-Type','application/json');
        request.setHeader('accept', 'application/json');
        HttpResponse response = http.send(request);
        
        String body = response.getBody();
        RefundWrapper refundWrapper = (RefundWrapper) JSON.deserialize(
            body, 
            RefundWrapper.class
        );

        System.debug(refundWrapper);

        if(refundWrapper.status == 'refunded') {
            System.debug('refunded');
            
        } else if(refundWrapper.status != 'refunded') {
            System.debug('inside else if');
            RETRY_DELAY = RETRY_DELAY + 2;
            System.enqueueJob(new RefundStatusQueueable(refundWrapper.refund_id), RETRY_DELAY);
            System.debug('inside delay');
        } else {
            System.debug('Refund status not updated');
        }
    }


    

    
}