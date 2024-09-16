public without sharing class ViewCheckListD2Controller{
    public list<SC_User_Response__c> scUserList{get;set;}
     public string emailOpp;
    public ViewCheckListD2Controller(ApexPages.StandardController Controller){
      String opportunityID = ApexPages.currentPage().getParameters().get('Id');
      if(opportunityID!=''){
          scUserList = [SELECT  Opportunity__r.Name,Opportunity__c,CreatedDate,Opportunity__r.Customer_Email__c,Stage__c,item__r.item__c,User_Response__c,Opportunity__r.Sub_Status__c from SC_User_Response__c 
                        WHERE Opportunity__c =: opportunityID AND Stage__c='Design Presentation Confirmed' limit 50000];  
       } 
       if(scUserList.size()==0 || Test.IsRunningTest()){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Checklist for D2 Initiated is not yet generated'));   
      }
      
    }
    public PageReference sendEmail(){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        //PageReference pageRef = page.ViewCheckListPDF;
        PageReference pageRef= new PageReference('/ViewD2CheckListPDF?id='+scUserList[0].Opportunity__r.id);
        pageRef.setRedirect(true);
        Blob content;
        if (Test.IsRunningTest())
        {
            content=Blob.valueOf('UNIT.TEST');
        }
        else
        {
            content=pageRef.getContent();
        }
        //Blob b = pageRef.getContent();
        emailOpp= scUserList.get(0).Opportunity__r.Customer_Email__c;
        system.debug('===emailOpp==='+emailOpp);
        system.debug('==scUserList.get(0).Opportunity__r.Customer_Email__c=='+scUserList.get(0).Opportunity__r.Customer_Email__c);
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('attachment.pdf');
        efa.setBody(content);
        email.setSubject('Feedback');
        email.setToAddresses(new String[] { emailOpp});
        String messageBody = '<html><body>Hi ' + scUserList.get(0).Opportunity__r.Name + ',<br/><br/>The requested checklist for D2 Initated has been attached below. <br><br>Thanks&Regards<br>HomeLane Team</body></html>';
        email.setHtmlBody( messageBody );
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        email.setSaveAsActivity(true);
        Messaging.SendEmailResult [] res = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
         
        return pageRef;
    
    }
}