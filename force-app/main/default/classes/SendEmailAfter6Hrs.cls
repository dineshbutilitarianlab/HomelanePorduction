global class SendEmailAfter6Hrs implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([select id, name, Square_Showroom_Agent__r.Email, Square_Showroom_Agent__r.Name, Square_Showroom_Agent__c, Time_of_Actual_Appointment_Start__c, Customer_ID__c, Full_Name__c, Customer_Email__c, Customer_Phone_Number__c from Opportunity
        where stageName = 'Quote Required' and Square_Showroom_Agent__r.Email != null
        and (CityfromLead__c = 'New Delhi' or CityfromLead__c = 'Noida' or CityfromLead__c = 'Gurgaon' or CityfromLead__c = 'Ghaziabad')
        and Time_of_Actual_Appointment_Start__c != null]);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('******scope  '+scope);
        List<Opportunity> oppList = (List<Opportunity>)(scope);
        List<Wrapper> wrapperList = new List<Wrapper>();
        for(Opportunity opp : oppList) {
            if(System.now() >= opp.Time_of_Actual_Appointment_Start__c.addHours(6)) {
                Wrapper wrap = new Wrapper();
                wrap.recordId = opp.Square_Showroom_Agent__c;
                wrap.usernamee = opp.Square_Showroom_Agent__r.Name;
                wrap.emaill = opp.Square_Showroom_Agent__r.Email;
                wrap.custId = opp.Customer_ID__c;
                wrap.custFullName = opp.Full_Name__c;
                wrap.custEmail = opp.Customer_Email__c;
                wrap.custPhone = opp.Customer_Phone_Number__c;
                wrapperList.add(wrap);
            }
        }
        System.debug('******wrapperList  '+wrapperList);
        
        EmailTemplate ema = [select id, name, subject, HtmlValue from EmailTemplate where name = 'Quote not sent for 6 hours' limit 1];
        System.debug('*****ema  '+ema);
        
        List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();
        for(Wrapper str : wrapperList) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {str.emaill} ; 
            message.optOutPolicy = 'FILTER';
            if(!Test.IsRunningTest()) {
            message.subject = ema.subject.replace('{!Opportunity.Customer_ID__c}',str.custId).replace('{!Opportunity.Full_Name__c}',str.custFullName);
           // String body = (String)ema;
            
            message.setHtmlBody(ema.HtmlValue.replace('{!User.Name}', str.usernamee).replace('{!Opportunity.Customer_ID__c}',str.custId).replace('{!Opportunity.Full_Name__c}',str.custFullName).replace('{!Opportunity.Customer_Email__c}',str.custEmail).replace('{!Opportunity.Customer_Phone_Number__c}',str.custPhone)); 
            }
            else {
                message.subject = '';
            message.setHtmlBody('');
            }
            message.setTemplateId(str.recordId);          
            lstMails.add(message);
        }
        System.debug('*****lstMails  '+lstMails);
       // Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {lstMails};  
       if(!Test.IsRunningTest()) {          
        Messaging.SendEmailResult[] results = Messaging.sendEmail(lstMails);  
       }
    }
 
    global void finish(Database.BatchableContext BC) {
    
    }
    
    global class wrapper {
        String recordId;
        String usernamee;
        String emaill;
        String custId;
        String custFullName;
        String custEmail;
        String custPhone;
    }
}