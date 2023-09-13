trigger Participated on Training__c (after update) {
    if(Trigger.isUpdate && Trigger.isAfter){
        List<Participant__c> participants=new List<Participant__c>();

        for(Training__c newTraining: Trigger.New){

            Training__c oldTraining=Trigger.oldMap.get(newTraining.id);

            if(newTraining.Status__c=='Finished' && oldTraining.status__c!='Finished'){

                Training__c foundTraining = [
                    SELECT Name, Id, Status__c, (SELECT Id, Name, Status__c FROM Participants__r) 
                    FROM Training__c 
                    WHERE Id = :newTraining.Id
                ];

               for(Participant__C participant:foundTraining.Participants__r){

                participant.status__c='Participated';
                participants.add(participant);

               }

                }

            }

            update participants;



        }


        }






    


