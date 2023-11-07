public with sharing class ERPCallout {

    public virtual class CalloutException extends Exception {}
    public class ParticipantNotFoundException extends Exception {}

    public static final String URL = 'https://64aa815a0c6d844abede843a.mockapi.io/api/v1/participants';
    public static final String METHOD = 'POST';

    @InvocableMethod(label = 'Get ERP Id')
    public static List<String> sendToERP(List<Id> participantId){

        List<String> foundERPId = new List<String>();

        Participant__c participant = [
            SELECT Id, Status__c
            FROM Participant__c
            WHERE Id = :participantId
        ];
        
        if(participant == null){
            throw new ParticipantNotFoundException('Participant not found Exception');
        }

        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL);
        request.setMethod(METHOD);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String JSONBODY = JSON.serialize(participant);
        request.setBody(JSONBODY);
        HttpResponse response = http.send(request);

        if(response == null){
            throw new CalloutException('Response not found Exception');
        }
        
        String foundId = parseIdFromJSON(response.getBody());
        foundERPId.add(foundId);
        return foundERPId;
     }

     private static String parseIdFromJSON(String jsonBody) {

        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);
        String erpId = (String) results.get('erpId');
        return erpId;
    }
}