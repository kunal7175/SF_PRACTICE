trigger TrainingTrigger on Training__c (after insert, before insert, before update, after update) {

    TrainingTriggerHandler handler=new TrainingTriggerHandler();

    if(Trigger.isUpdate && Trigger.isBefore) {
        handler.beforeUpdate(Trigger.New,Trigger.oldMap, Trigger.newMap, Trigger.old);
    }

    if(Trigger.isInsert && Trigger.isAfter) {
       handler.afterInsert(Trigger.New, Trigger.oldMap, Trigger.newMap, Trigger.old);
    }

    if(Trigger.isInsert && Trigger.isBefore) {
        handler.beforeInsert(Trigger.New, Trigger.newMap);
    }
}