public with sharing class ERPCallout {

    public virtual class CalloutException extends Exception {}
    
    public static final String URL = 'https://64aa815a0c6d844abede843a.mockapi.io/api/v1/participants';
    public static final String METHOD = 'POST';

    public static String sendToERP(Participant__c participant){

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL);
        request.setMethod(METHOD);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String JSONBODY = JSON.serialize(participant);
        request.setBody(JSONBODY);
        HttpResponse response = http.send(request);
        System.debug(response.getBody());

        if(response == null){
            throw new CalloutException('Response not found Exception');
        }
        
        String foundId = parseIdFromJSON(response.getBody());
        return foundId;
     }

     private static String parseIdFromJSON(String jsonBody) {

        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);
        String erpId = (String) results.get('erpId');
        return erpId;
    }
}