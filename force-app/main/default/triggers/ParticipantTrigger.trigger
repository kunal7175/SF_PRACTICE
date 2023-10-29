trigger ParticipantTrigger on Participant__c (after insert) {

    Set<Id> ids = (new Map<Id, Participant__c>(Trigger.newMap)).keySet();
    System.enqueueJob(new RegistrationConfirmationQueueable(ids));

}