public with sharing class BillEmailer {
    
    public static void sendEmails(Map<String, Blob> emailsWithBills) {
        // Instantiate a list of Messaging.SingleEmailMessage objects
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        // Iterate over the keyset of the emailsWithBills map and instantiate a single Messaging.SingleEmailMessage
        // object. Set the bccAddress to the email from the iteration, set a PlainTextBody, and set a Subject for the
        // Messaging.SingleEmailMessage object.
        for (String email : emailsWithBills.keySet()) {
            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            emailMessage.setBccAddresses(new List<String>{email});
            emailMessage.setSubject('Your Bill');
            emailMessage.setPlainTextBody('Please find your bill attached.');

            // Use the following to attach the PDF blob to the email:
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setBody(emailsWithBills.get(email));
            attach.setFileName('Bill-' + Date.Today().Month() + '-' + Date.Today().Day() + '-' + Date.Today().Year() + '.pdf');
            attach.setContentType('application/pdf');

            emailMessage.setFileAttachments(new List<Messaging.EmailFileAttachment>{attach});

            // Add the Messaging.SingleEmailMessage object to the list inside of the loop
            emailList.add(emailMessage);
        }

        // Send the email outside of the loop
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);

        // Call a helper method to inspect the returned results
        inspectResults(results);
    }

    // This is a method that will allow you to check to see if your code works.
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;

        // SendEmail returns an array of result objects.
        // Iterate through the list to inspect results.
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            } else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());
            }
        }

        return sendResult;
    }
}