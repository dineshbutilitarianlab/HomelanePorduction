public class WorksContractEmailController{

public String strMessage{get;set;}
public Opportunity objOpp{get;set;}
public String oppId{get;set;}

Public WorksContractEmailController(){
    try{
    oppId = ApexPages.currentPage().getParameters().get('id'); 
    
    }catch(Exception exp){
      strMessage = exp.getMessage();
    }
}
public PageReference SendWorksContact(){
    try{
    objOpp = [Select Id,Account.PersonContactId,Works_Contract_Sign_Off_Date__c,Customer_Email__c From Opportunity Where Id = :oppId LIMIT 1];
    if(objOpp.Works_Contract_Sign_Off_Date__c != null){
        SendEmailWorksContact(objOpp.Customer_Email__c,objOpp.Account.PersonContactId);
        strMessage = 'Email Has been sent.';
    }else{
            strMessage = 'Please update Works Contract sign off date.';
        }
    }catch(Exception exp){
      strMessage = exp.getMessage();
    }   
    return null;
}

@future(callout=true)
public static void SendEmailWorksContact(String strCustomerEmail,String strAccountId){
    try{
            system.debug('inside send mail as PDF 222...');
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            EmailTemplate templateId = [Select Id from EmailTemplate where name = 'Works_Contract_Attached' Limit 1];
            email.setTemplateID(templateId.Id);
           // PageReference pdf = Page.WorksContractPDFVFPage;
            PageReference pdf = new PageReference(Label.Works_Contract_PDF);
            pdf.setRedirect(true);
            Blob body;
             if(!test.isRunningTest()){ 
                    system.debug('PDF::'+pdf);
                    body = pdf.getContent();
                }
                else{
                    body = blob.valueof('TEST');
                }
            system.debug('BODY:: '+EncodingUtil.base64Encode(body));
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('WorksContract.pdf');
            efa.setBody(body);
            efa.setInline(false);
            efa.setContentType('application/pdf');
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            email.setToAddresses(new String[] {strCustomerEmail});
            email.setTargetObjectId(strAccountId);
            email.setSaveAsActivity(false);
              email.setSenderDisplayName('Homelane Support');
                email.setReplyTo('care@homelane.com');
                email.setUseSignature(false);
            system.debug('------email----'+email);
            Messaging.SendEmailResult [] objResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email},false);
            if(objResult[0].isSuccess())
             system.debug('-----(objResult[0].isSuccess()----'+objResult[0].isSuccess());  
      system.debug('-----(objResult[0].isSuccess()----'+objResult);  
    }catch(Exception exp){
      //strMessage = exp.getMessage();
    }

 //return null;

}
}