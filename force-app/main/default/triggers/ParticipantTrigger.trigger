trigger ParticipantTrigger on Participant__c (after insert) {

    ParticipantTriggerHandler handler = new ParticipantTriggerHandler();

    if(Trigger.isInsert && Trigger.isAfter){
        
        handler.afterInsert(Trigger.newMap);
    }

    // Set<Id> ids = (new Map<Id, Participant__c>(Trigger.newMap)).keySet();
    // System.enqueueJob(new RegistrationConfirmationQueueable(ids));

}