public with sharing class ERPCalloutInvocable {
    
    public class ParticipantNotFoundException extends Exception {}
  
    @InvocableMethod(label = 'Get ERP Id')
    public static List<String> sendToERP(List<Id> participantId){
        Participant__c participant = [
            SELECT Id, Name, Status__c
            FROM Participant__c
            WHERE Id IN :participantId
            LIMIT 1
        ];
        
        if(participant == null){
            throw new ParticipantNotFoundException('Participant not found Exception');
        }

       String ERPId = ERPCallout.sendToERP(participant);
       return new List<String>() {ERPId};
    }
}