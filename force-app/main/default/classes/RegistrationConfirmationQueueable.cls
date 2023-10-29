public with sharing class RegistrationConfirmationQueueable implements Queueable{

    private Set<Id> participantIds;

    public RegistrationConfirmationQueueable(Set<Id> participantIds){
        this.participantIds = participantIds;
    }

    public void execute(QueueableContext context){
        PaymentLinkCallout.requestPaymentLink(participantIds);

        List<Participant__c> participants = [
            SELECT Id, Name, Contact_Name__r.Name, Contact_Name__r.Email, Training__r.Name 
            FROM Participant__c
            WHERE Id IN :participantIds
        ];

        sendEmailToStudents(participants);
    }

    public void sendEmailToStudents(List<Participant__c> participants){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        for(Participant__c participant : participants ){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Course Enrollment Confirmation');
            email.setToAddresses(new List<String> {participant.Contact_Name__r.Email});
            String body = 'Dear '+ participant.Contact_Name__r.Name + ',' + '<br/>';
            body += 'This email is a confirmation that you are successfully registered for course ' + participant.Training__r.Name;
            body += '. We look forward to seeing you in the course!' + '<br/>';
            body += 'Best regards,'+ '<br/>';
            body += 'Cloud Prism';
            email.setHtmlBody(body);
            mails.add(email);
        }

        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }
}