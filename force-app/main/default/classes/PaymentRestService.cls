@RestResource(urlMapping='/payment/*')
global with sharing class PaymentRestService {

    @HttpPost
    global static void getPaymentStatusAndUpdateInvoice(){

        String requestBody = RestContext.request.requestBody.toString();
        System.debug(requestBody);


    }
  
}