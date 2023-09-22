public with sharing class TrainingTriggerHandler {
    TrainingService service =new TrainingService();

    public void beforeUpdate(List<Training__c> trainings, Map<ID, Training__c> foundMap, Map<ID, Training__c> newMap, List<Training__c> old){
    service.SetEndDate(trainings, foundMap);
    service.ChangeStatus();   
    }

    public void afterInsert(List<Training__c> trainings, Map<ID, Training__c> oldMap, Map<ID, Training__c> newMap,List<Training__c> old ){
    service.CreateTask(trainings);
    }

    public void beforeInsert(List<Training__c> trainings, Map<ID, Training__c> newmap){
    service.calculateRestaurantCommission(trainings);
    }

    
}