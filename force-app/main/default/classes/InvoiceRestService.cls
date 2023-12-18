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

            Participant__c foundParticipant = getParticipantById(invoice.Participant__c);
            EmailService.sendPaymentEmailToStudent(foundParticipant, invoice.payment_link__c);
         }

         if(invoiceWrapper.status == 'Paid'){
            Invoice__c foundInvoice = getInvoiceById(invoiceWrapper.invoice_id);
            invoice = foundInvoice;
            invoice.Status__c = invoiceWrapper.status;
            invoice.Payment_Date__c = Date.today();
            Participant__c foundParticipant = getParticipantById(invoice.Participant__c);
            foundParticipant.Status__c = 'Active';
            update foundParticipant;
         }

         if(invoiceWrapper.status == 'Failed'){
            Invoice__c foundInvoice = getInvoiceById(invoiceWrapper.invoice_id);
            invoice = foundInvoice;
            invoice.Status__c = invoiceWrapper.status;
            Participant__c foundParticipant = getParticipantById(foundInvoice.Participant__c);
            EmailService.paymentFailureEmail(foundParticipant);
         }

         upsert invoice;

         } 

         private static Participant__c getParticipantById(Id participantId){

            Participant__c foundParticipant = [
                SELECT Id, Status__c, Contact_Name__r.Name, Contact_Name__r.Email, Training__r.Name
                FROM Participant__c
                WHERE Id = :participantId
            ];

            return foundParticipant;
         }

         private static Invoice__c getInvoiceById(String invoiceId){

            Invoice__c foundInvoice = [
                SELECT Id, Status__c, invoice_id__c, Participant__c
                FROM Invoice__c
                WHERE invoice_id__c = :invoiceId
                LIMIT 1
            ];

            return foundInvoice;            
         }
 
}

