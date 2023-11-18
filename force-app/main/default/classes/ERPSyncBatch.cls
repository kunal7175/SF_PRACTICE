public with sharing class ERPSyncBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{

    public Integer recordsProcessed = 0;

    public Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator(
            'SELECT Id, Name, Status__c FROM Participant__c' 
        );
    }

    public void execute(Database.BatchableContext bc, List<Participant__c> participants){

        List<Participant__c> participantsWithERPId = new List<Participant__C>();

        for(Participant__c participant : participants){

            String ERPId = ''; 
            
            try {
                ERPId = ERPCallout.sendToERP(participant);
            } catch(Exception e) {
                
            }
            participant.erpId__c = ERPId;
            participantsWithERPId.add(participant);
            recordsProcessed++;
        }
        
        update participantsWithERPId;
    }
    public void finish(Database.BatchableContext bc){
        
    }
  
}