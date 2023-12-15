public with sharing class PaymentLinkQueueable implements Queueable, Database.AllowsCallouts {

    private Set<Id> participantIds;

    public PaymentLinkQueueable(Set<Id> participantIds) {
        this.participantIds = participantIds;
    }

    public void execute(QueueableContext context){
        List<Participant__c> participants = queryParticipantsByIds(participantIds);

        for(Participant__c participant : participants){
            PaymentLinkWebHookCallout.requestPaymentLink(participant);
        }
    }

    public List<Participant__c> queryParticipantsByIds(Set<Id> participantIds){
        return [
            SELECT Id, Status__c, Name, Contact_Name__r.Name, Contact_Name__r.Email, 
            Training__r.Name, Training__r.tax__c, Training__r.price__c  
            FROM Participant__c
            WHERE Id IN :participantIds
        ];
    }
}