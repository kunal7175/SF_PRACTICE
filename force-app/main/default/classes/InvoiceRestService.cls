@RestResource(urlMapping='/invoices/*')
global with sharing class InvoiceRestService {

    @HttpPost
    global static void createInvoiceAndEmail(){

        String requestBody = RestContext.request.requestBody.toString();
        InvoiceWrapper invoiceWrapper = (InvoiceWrapper) JSON.deserialize(
            requestBody, 
            InvoiceWrapper.class
        );

        Invoice__c invoice = new Invoice__c();

         if(invoiceWrapper.status == 'Created'){
            invoice.invoice_id__c = invoiceWrapper.invoice_id;
            invoice.Participant__c = invoiceWrapper.participant_id;
            invoice.payment_id__c = invoiceWrapper.payment_id;
            invoice.payment_link__c = invoiceWrapper.payment_link;
            invoice.Status__c = invoiceWrapper.status;
            invoice.item_name__c = invoiceWrapper.item_name;
            invoice.description__c = invoiceWrapper.description;
            invoice.price__c = invoiceWrapper.price;
            invoice.tax__c = invoiceWrapper.tax;
            invoice.token__c = invoiceWrapper.token;

            Participant__c participant = [
                SELECT Id, Contact_Name__r.Email, Contact_Name__r.Name, Training__r.Name
                FROM Participant__c
                WHERE Id = :invoice.Participant__c
                LIMIT 1
         ];

         sendEmailToStudent(participant, invoice.payment_link__c);

         }

         if(invoiceWrapper.status == 'Paid'){
            Invoice__c foundInvoice = [
                SELECT Id, Status__c, invoice_id__c, Participant__c
                FROM Invoice__c
                WHERE invoice_id__c = :invoiceWrapper.invoice_id
                LIMIT 1
            ];

            invoice = foundInvoice;
            invoice.Status__c = invoiceWrapper.status;
            invoice.Payment_Date__c = Date.today();

            Participant__c foundParticipant = [
                SELECT Id, Status__c
                FROM Participant__c
                WHERE Id = :foundInvoice.Participant__c
            ];

            foundParticipant.Status__c = 'Active';
            update foundParticipant;
         }

         if(invoiceWrapper.status == 'Failed'){
            Invoice__c foundInvoice = [
                SELECT Id, Status__c, invoice_id__c, Participant__c
                FROM Invoice__c
                WHERE invoice_id__c = :invoiceWrapper.invoice_id
                LIMIT 1
            ];

            invoice = foundInvoice;
            invoice.Status__c = invoiceWrapper.status;
         }

         upsert invoice;
         
         } 

    public static void sendEmailToStudent(Participant__c participant, String payment_link){
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
   

}

