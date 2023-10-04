public with sharing class TrainingReminderScheduled implements Schedulable {

    public void execute(SchedulableContext sc){

        sendEmailToTrainers();
        sendEmailToStudents();
    }

    public void sendEmailToTrainers(){
        List<Training__c> trainings = [SELECT Id, Name, Start_Date__c, End_Date__c, Number_of_Participants__c, Trainer_Contact__r.Name, Trainer_Contact__r.Email, 
                                      (SELECT Id, Name, Contact_Name__r.Name  from Participants__r)
                                       FROM Training__c
                                      ];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        for(Training__c training : trainings){
            if(System.today().daysbetween(training.Start_Date__c.date()) == 3){
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    List<String> sendTo = new List<String>();
                    sendTo.add(training.Trainer_Contact__r.Email);
                    email.setToAddresses(sendTo);
                    email.setSubject('Training Reminder: '+ training.Name);
                    String body = 'Dear '+ training.Trainer_Contact__r.Name + ',' + '<br/>';
                    body += 'This is an automatic reminder for the upcoming training ' + training.Name  + ' that will take';
                    body += 'place from ' + training.Start_Date__c +' until '+ training.End_Date__c + '<br/>';
                    body += 'There are in total '+ training.Number_of_Participants__c + ' participants:' + '<br/>';
                    List<Participant__c> participants = training.Participants__r;
                    
                    for(Participant__c participant : participants ){
                        body += participant.Contact_Name__r.Name +'<br/>';
                    }
                    
                    body += 'Best regards,' + '<br/>';
                    body +='Cloud Prism';
                    email.setHtmlBody(body);
                    mails.add(email);

            }

        }

        if(mails.size() > 0){
            Messaging.sendEmail(mails);
        }


    }

    public void sendEmailToStudents(){
        List<Participant__c> participants = [SELECT Id, Name, Contact_Name__r.Email, Contact_Name__r.Name, Training__r.Start_Date__c,Training__r.End_Date__c, Training__r.Name
                                            FROM Participant__c
                                            ];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        for(Participant__c participant : participants ){
               if(System.today().daysbetween(participant.Training__r.Start_Date__c.date()) == 3){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();
                sendTo.add(participant.Contact_Name__r.Email);
                email.setToAddresses(sendTo);
                email.setSubject('Training Reminder: '+ participant.Contact_Name__r.Name);
                String body = 'Dear '+ participant.Name + ',' + '<br/>';
                body += 'This is an automatic reminder for the upcoming training '+ participant.Training__r.Name;
                body += 'that will take place from '+ participant.Training__r.Start_Date__c + ' ' + 'until ' +  participant.Training__r.End_Date__c + '<br/>';
                body += 'Best regards,'+ '<br/>';
                body += 'Cloud Prism';
                email.setHtmlBody(body);
                mails.add(email);
        }
        }

        if(mails.size() > 0){
            Messaging.sendEmail(mails);
        }  
}
}



