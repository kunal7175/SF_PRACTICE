@RestResource(urlMapping='/ /*')
global with sharing class TrainingRestService {

    @HttpGet
    global static Training__c getTrainingById(){

        RestRequest request = RestContext.request;
        String trainingId = request.requestURI.substring(request.requestURI.lastIndexof('/')+1);

        Training__c training = [
            SELECT Training_Length__c, Status__c, Start_Date__c, Number_of_Participants__c, Trainer_Contact__r.Name
            FROM Training__c
            WHERE Id = :trainingId
            LIMIT 1
        ];

        return training;
    }

    @HttpPost
    global static ID createTraining(
        String name, 
        String status, 
        String startDate, 
        String endDate, 
        String numberOfParticipants){

      Training__c training = new Training__c();

      training.Name = name;
      training.Status__c = status;
      training.Start_Date__c = DateTime.Valueof(startDate.replace('T', ' '));
      training.End_Date__c = DateTime.Valueof(endDate.replace('T', ' '));
      training.Number_of_Participants__c = Integer.valueOf(numberOfParticipants);
      insert training;

      return training.Id;

}

   

}