public with sharing class PaymentLinkWebHookCallout {

    public static final String POST_METHOD = 'POST';
    public static final String AUTH_URL = 'https://leaflix-2-3e22d4a85a3a.herokuapp.com/auth';
    public static final String INVOICE_URL = 'https://leaflix-2-3e22d4a85a3a.herokuapp.com/invoices/';

    // /invoice

/*
    private static HttpResponse sendRequest(String url, String method, String body, Map<String, String> headers){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod(method);
        
        for(String key : headers.keySet()){
            request.setHeader(key, headers.get(key));
        }

        request.setBody(body);

        return http.send(request);
    } 
*/
    public static void requestPaymentLink(Participant__c participant){
        String token = getAccessToken();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(INVOICE_URL);
        request.setMethod(POST_METHOD);
        request.setHeader('Content-Type','application/json');
        request.setHeader('accept', 'application/json');

        String body = createInvoiceBody(
            participant.Id, 
            participant.Status__c, 
            participant.Training__r.price__c, 
            participant.Training__r.tax__c, 
            token);
        request.setBody(body);
        HttpResponse response = http.send(request);      
    }

    public static String getAccessToken(){ 

        AuthMetadata__mdt authMetadata = [
            SELECT client_id__c, client_secret__c, email__c, full_name__c, security_token__c
            FROM AuthMetadata__mdt
            LIMIT 1 
        ];
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:FastAPI/auth');
        request.setMethod(POST_METHOD);
        request.setHeader('Content-Type','application/json');
        request.setHeader('accept', 'application/json');
       
        String body = createAuthBody(
            '{!$Credential.Username}', 
            '{!$Credential.Password}',
            authMetadata.security_token__c,
            authMetadata.client_id__c,
            authMetadata.client_secret__c,
            authMetadata.email__c,
            authMetadata.full_name__c,
            true
             );

        request.setBody(body);
        HttpResponse response = http.send(request);
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        String token = (String) results.get('token');
        return token;
    }

    private static String createInvoiceBody(Id participantId, String status, Decimal price, Decimal tax, String token){
        InvoiceWrapper invoice = new InvoiceWrapper();

        invoice.participant_id = participantId;
        invoice.status = status;
        invoice.price = price;
        invoice.tax = tax;
        invoice.token = token;

        return JSON.serialize(invoice);
    }

    private static String createAuthBody(
    String username, 
    String password, 
    String security_token, 
    String client_id, 
    String client_secret, 
    String email, 
    String full_name, 
    Boolean disabled){

        Auth auth = new Auth();
        
        auth.username = username;
        auth.password = password;
        auth.security_token = security_token;
        auth.client_id = client_id;
        auth.client_secret = client_secret;
        auth.email = email;
        auth.full_name = full_name;
        auth.disabled =disabled;

        return JSON.serialize(auth);
    }

    class Auth{
        public String username;
        public String password;
        public String security_token;
        public String client_id;
        public String client_secret;
        public String email;
        public String full_name;
        public Boolean disabled; 
    }
  
}