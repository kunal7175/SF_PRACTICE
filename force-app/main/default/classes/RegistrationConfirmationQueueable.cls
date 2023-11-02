public with sharing class RegistrationConfirmationQueueable implements Queueable, Database.AllowsCallouts{

    private Set<Id> participantIds;

    public RegistrationConfirmationQueueable(Set<Id> participantIds){
        this.participantIds = participantIds;
    }

    public void execute(QueueableContext context){
        List<Participant__c> participants = queryParticipantsByIds(participantIds);

        for(Participant__c participant : participants){
            String paymentLink = PaymentLinkCallout.requestPaymentLink(participant);

            if(paymentLink != null){
                participant.PaymentLink__c = paymentLink;
            }
        }

        sendEmailToStudents(participants);
        update participants;
    }

    public void sendEmailToStudents(List<Participant__c> participants){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        for(Participant__c participant : participants ){
            System.debug('Sending email to: ' + participant.Contact_Name__r.Email);
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Course Enrollment Confirmation');
            email.setToAddresses(new List<String> {participant.Contact_Name__r.Email});
            String body = 'Dear '+ participant.Contact_Name__r.Name + ',' + '<br/>';
            body += 'This email is a confirmation that you are successfully registered for course ' + participant.Training__r.Name;
            body += '. Please use the following link to pay for the course: ' + participant.PaymentLink__c;
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

    public List<Participant__c> queryParticipantsByIds(Set<Id> participantIds){
        return [
            SELECT Id, Name, Contact_Name__r.Name, Contact_Name__r.Email, Training__r.Name 
            FROM Participant__c
            WHERE Id IN :participantIds
        ];
    }
}