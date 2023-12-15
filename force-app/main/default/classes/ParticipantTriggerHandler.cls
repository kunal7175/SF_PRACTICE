public with sharing class ParticipantTriggerHandler {
    
    public void afterInsert(Map<Id, Participant__c> foundMap){
        ParticipantService service = new ParticipantService();
        service.enqueuePaymentLinkQueueable(foundMap);
    }
}