public with sharing class TrainingService {
    Set<Id> completedTrainingIds = new Set<Id>();

    public void SetEndDate(List<Training__c> trainings, Map<ID, Training__c> foundMap){
               for(Training__c newTraining : trainings) {
                Training__c oldTraining = foundMap.get(newTraining.Id);
                if(oldTraining.Status__c != 'Finished' && newTraining.Status__c == 'Finished') {
                newTraining.End_Date__c = Date.today();
                completedTrainingIds.add(newTraining.Id);
            }
        }

    }

    public void ChangeStatus(){
        List<Training__c> completedTrainingParticipants = [
                Select Name, Id, Status__c, (Select Name, Status__c, Id from Participants__r)
                FROM Training__c
                Where Id IN :completedTrainingIds
                ];

            for(Training__c training : completedTrainingParticipants ) {
                List<Participant__c> participants = training.Participants__r;
                for(Participant__c part : participants){
                    part.Status__c = 'Participated';

                }
            }
    }

    public void CreateTask(List<Training__c> trainings){
        List<Task> tasks = new List<Task>();
        
        for(Training__c training : trainings) {

            Task task=new Task();
            task.ActivityDate=System.today();
            task.Status='Not Started';
            task.Priority='Normal';
            task.Description='This task is just a reminder that a new course is about to start.';
            task.Subject='Reminder '+ training.Name;
            task.WhoId=training.Trainer_Contact__c;
            task.WhatId=training.id;
            tasks.add(task);
        }

        if(!tasks.isEmpty()){
            insert tasks;
        }

    }

    public void calculateRestaurantCommission(List<Training__c> trainings){
        Set<Id> restaurantIds = new Set<Id>();

        for(Training__c training : trainings){    
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

        for(Training__c training : trainings){

            if(training.Number_of_Participants__c==0){
                training.Number_of_Participants__c=1;
            }
            Restaurant__c restaurant = restaurantIdToRecord.get(training.Restaurant__c);
            training.Restaurant_Commission_Forecast__c = training.Number_of_Participants__c * training.Training_Length__c * 
                                                         restaurant.Comission_Rate__c * commissionMetadata.ProbabilityToBuyPerParticipant__c *
                                                         restaurant.Average_Meal_Cost__c;
                                   
        }       

    }

}