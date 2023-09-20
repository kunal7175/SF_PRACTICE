trigger TrainingTrigger on Training__c (after insert, before insert, before update, after update) {

    Set<Id> completedTrainingIds = new Set<Id>();
    List<String> trainingNames=new List<String>();

    if(Trigger.isUpdate && Trigger.isBefore) {
        for(Training__c newTraining : Trigger.New) {
            Training__c oldTraining = Trigger.oldMap.get(newTraining.Id);

            if(oldTraining.Status__c != 'Finished' && newTraining.Status__c == 'Finished') {
                newTraining.End_Date__c = Date.today();
                completedTrainingIds.add(newTraining.Id);
            }
        }

        List<Training__c> completedTrainingParticipants = [
            SELECT Name, Id, Status__c, (SEELCT Name, Status__c, Id FROM Participants__r)
            FROM Training__c
            WHERE Id IN :completedTrainingIds
        ];

        for(Training__c training : completedTrainingParticipants ) {
            List<Participant__c> participants = training.Participants__r;
            for(Participant__c part : participants){
                part.Status__c = 'Participated';
            }
        }
    }

    if(Trigger.isInsert && Trigger.isAfter) {
        List<Task> tasks = new List<Task>();
        
        for(Training__c training : Trigger.New) {
            Task task = new Task();
            task.ActivityDate = System.today();
            task.Status = 'Not Started';
            task.Priority = 'Normal';
            task.Description = 'This task is just a reminder that a new course is about to start.';
            task.Subject = 'Reminder '+ training.Name;
            task.WhoId = training.Trainer_Contact__c;
            task.WhatId = training.id;
            tasks.add(task);
        }

        if(!tasks.isEmpty()){
            insert tasks;
        }
    }

    if(Trigger.isInsert && Trigger.isBefore) {
        Set<Id> restaurantIds = new Set<Id>();

        for(Training__c training : Trigger.New){    
            restaurantIds.add(training.Restaurant__c);
        }

        Map<Id, Restaurant__c> restaurantIdToRecord = new Map<Id, Restaurant__c>([
            SELECT Id, Comission_Rate__c, Average_Meal_Cost__c
            FROM Restaurant__c
            WHERE Id IN :restaurantIds
        ]);

        RestaurantCommissionMetadata__mdt commissionMetadata = [
            SELECT ProbabilityToBuyPerParticipant__c
            FROM RestaurantCommissionMetadata__mdt  
            LIMIT 1
        ];

        for(Training__c training : Trigger.New){
            Restaurant__c restaurant = restaurantIdToRecord.get(training.Restaurant__c);
            training.Restaurant_Commission_Forecast__c = training.Number_of_Participants__c * training.Training_Length__c * 
                                                         restaurant.Comission_Rate__c * commissionMetadata.ProbabilityToBuyPerParticipant__c *
                                                         restaurant.Average_Meal_Cost__c;
                                   
        }       
    }
}