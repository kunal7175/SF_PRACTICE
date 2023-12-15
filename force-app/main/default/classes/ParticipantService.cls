public with sharing class ParticipantService {

    public void enqueuePaymentLinkQueueable(Map<Id, Participant__c> foundMap){
        Set<Id> ids = (new Map<Id, Participant__c>(foundMap)).keySet();
        System.enqueueJob(new PaymentLinkQueueable(ids));
    }
   
}