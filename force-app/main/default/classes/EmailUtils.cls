Public class EmailUtils {

    Public static String toEmailIds =  null;


 // the following is a SingleEmail Method which is used 
         Public static void sendLeadDuplicationEmailNotification(String mailsubject, String mailContent, String  Emailfrom){
           system.debug('ENTERED IN TO EMAIL HANDLER');
            try{
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[]{Emailfrom});
                mail.setSubject(mailsubject);
                mail.setPlainTextBody(mailContent);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }, false);
             }catch(Exception ex){
                System.debug(''+ex);
            }
        }
}