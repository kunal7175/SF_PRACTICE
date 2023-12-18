public with sharing class EmailService {

    public static void sendPaymentEmailToStudent(Participant__c participant, String payment_link){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>(); 
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        email.setSubject('Course Enrollment Confirmation');
        email.setToAddresses(new List<String> {participant.Contact_Name__r.Email});
        String body = 'Dear '+ participant.Contact_Name__r.Name + ',' + '<br/>';
        body += 'This email is a confirmation that you are successfully registered for course ' + participant.Training__r.Name;
        body += '. Please use the following link to pay for the course: ' + payment_link;
        body += '. We look forward to seeing you in the course!' + '<br/>';
        body += 'Best regards,'+ '<br/>';
        body += 'Cloud Prism';
        email.setHtmlBody(body);
        mails.add(email);

        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }

    public static void paymentFailureEmail(Participant__c participant){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>(); 
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        email.setSubject('Payment Failure');
        email.setToAddresses(new List<String> {participant.Contact_Name__r.Email});
        String body = 'Dear '+ participant.Contact_Name__r.Name + ',' + '<br/>';
        body += 'Check the payment details or try a different payment method' + '<br/>';
        body += 'Best regards,'+ '<br/>';
        body += 'Cloud Prism';
        email.setHtmlBody(body);
        mails.add(email);

        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }
  
}