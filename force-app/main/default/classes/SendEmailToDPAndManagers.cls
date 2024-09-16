global class SendEmailToDPAndManagers implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([select id, name, Opportunity_Stage__c,  
            X_Hrs_Email_Sent__c, X4_Hrs_Email_Sent__c, X8_Hrs_Email_Sent__c,
            Square_Showroom_Agent__r.Email, Square_Showroom_Agent__r.Name, Square_Showroom_Agent__c, 
            Square_Showroom_Manager__c, Square_Showroom_Manager__r.Email, Square_Showroom_Manager__r.Name, 
            Interior_Design_Partner__c, Interior_Design_Partner__r.Name, Interior_Design_Partner__r.Email__c, 
            Time_of_Actual_Appointment_Start__c, Customer_ID__c, Full_Name__c, Customer_Email__c, Customer_Phone_Number__c, Second_Meeting_Time__c, Meeting_Stage__c, Opportunity_Status__c from Opportunity
        where Second_Meeting_Time__c != null and Square_Showroom_Manager__c != null and Interior_Design_Partner__c != null 
        and Square_Showroom_Agent__c != null and test_flag__c = false]);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Opportunity> listOpp = (List<Opportunity>)(scope);
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        Map<Id,DateTime> secondDate = new Map<Id,DateTime>();
        List<wrapper2Hrs> wrapperList2Hrs = new List<wrapper2Hrs>();
        List<wrapper24Hrs> wrapperList24Hrs = new List<wrapper24Hrs>();
        List<wrapper48Hrs> wrapperList48Hrs = new List<wrapper48Hrs>();
        
        for(Opportunity opp : listOpp) {            
            if(opp.X_Hrs_Email_Sent__c == false) {       
                if(SYstem.now() >= opp.Second_Meeting_Time__c.addHours(2)) {
                    wrapper2Hrs wrap = new wrapper2Hrs();
                    wrap.recordId = opp.Id;
                    wrap.DPName = opp.Interior_Design_Partner__r.Name;
                    wrap.DPEmail = opp.Interior_Design_Partner__r.Email__c;
                    wrap.SSMEmail = opp.Square_Showroom_Manager__r.Email;
                    wrap.SSAEmail = opp.Square_Showroom_Agent__r.Email;   
                    wrap.custId = opp.Customer_ID__c;
                    wrap.custFullName = opp.Full_Name__c;  
                    opp.X_Hrs_Email_Sent__c = true;
                    wrapperList2Hrs.add(wrap);                  
                }
            }
            
            if(opp.X4_Hrs_Email_Sent__c == false) {       
                if(SYstem.now() >= opp.Second_Meeting_Time__c.addHours(24)) {
                    wrapper24Hrs wrap = new wrapper24Hrs();
                    wrap.recordId = opp.Id;
                    wrap.DPName = opp.Interior_Design_Partner__r.Name;
                    wrap.DPEmail = opp.Interior_Design_Partner__r.Email__c;
                    wrap.SSMEmail = opp.Square_Showroom_Manager__r.Email;
                    wrap.SSAEmail = opp.Square_Showroom_Agent__r.Email;   
                    wrap.custId = opp.Customer_ID__c;
                    wrap.custFullName = opp.Full_Name__c;  
                    opp.X4_Hrs_Email_Sent__c = true; 
                    wrapperList24Hrs.add(wrap);                  
                }
            }
            
            if(opp.X8_Hrs_Email_Sent__c == false) {       
                if(SYstem.now() >= opp.Second_Meeting_Time__c.addHours(48)) {
                    wrapper48Hrs wrap = new wrapper48Hrs();
                    wrap.recordId = opp.Id;
                    wrap.DPName = opp.Interior_Design_Partner__r.Name;
                    wrap.DPEmail = opp.Interior_Design_Partner__r.Email__c;
                    wrap.SSMEmail = opp.Square_Showroom_Manager__r.Email;
                    wrap.SSAEmail = opp.Square_Showroom_Agent__r.Email;   
                    wrap.custId = opp.Customer_ID__c;
                    wrap.custFullName = opp.Full_Name__c;  
                    wrap.SSMName = opp.Square_Showroom_Manager__r.Name;
                    opp.X8_Hrs_Email_Sent__c = true;  
                    wrapperList48Hrs.add(wrap);                 
                }
            }         
            oppToUpdate.add(opp);              
        }
        System.debug('*****wrapperList2Hrs  '+wrapperList2Hrs);
        System.debug('*****wrapperList24Hrs  '+wrapperList24Hrs);
        System.debug('*****wrapperList48Hrs  '+wrapperList48Hrs);
        
        List<EmailTemplate> emaList = [select id, name, subject, HtmlValue from EmailTemplate where name = 'Two hrs after meeting time' OR name = '24 hrs after meeting time' OR name = '48 hours after the meeting'];
        System.debug('*****emaList  '+emaList);
        Map<String,EmailTemplate> emaMap = new Map<String,EmailTemplate>();
        for(EmailTemplate e : emaList) {
            emaMap.put(e.Name,e);
        }
        
        List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();
        for(wrapper2Hrs str : wrapperList2Hrs) {
            if(str.DPName != null && str.DPEmail != null && str.SSMEmail != null && str.SSAEmail != null && str.custId != null && str.custFullName != null) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {str.DPEmail} ; 
            message.ccAddresses = new String[] {str.SSMEmail, str.SSAEmail};
            message.optOutPolicy = 'FILTER';
            if(!Test.IsRunningTest()) {
                message.subject = emaMap.get('Two hrs after meeting time').subject.replace('{!Opportunity.Full_Name__c}',str.custFullName);            
                message.setHtmlBody(emaMap.get('Two hrs after meeting time').HtmlValue.replace('{!Interior_Designer__c.Name}', str.DPName).replace('{!Opportunity.Customer_ID__c}',str.custId).replace('{!Opportunity.Full_Name__c}',str.custFullName).replace('{!Opportunity.Id}',str.recordId)); 
            }
            else {
                message.subject = '';
                message.setHtmlBody('');
            }
            message.setTemplateId(emaMap.get('Two hrs after meeting time').Id);          
            lstMails.add(message);
            }
        }
        System.debug('*****lstMails  '+lstMails);
       // Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {lstMails};            
        Messaging.SendEmailResult[] results = Messaging.sendEmail(lstMails); 
        
        // FOR 24 HRS
        List<Messaging.SingleEmailMessage> lstMails24Hrs = new List<Messaging.SingleEmailMessage>();
        for(wrapper24Hrs str : wrapperList24Hrs) {
            if(str.DPName != null && str.DPEmail != null && str.SSMEmail != null && str.SSAEmail != null && str.custId != null && str.custFullName != null) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {str.DPEmail} ; 
            message.ccAddresses = new String[] {str.SSMEmail, str.SSAEmail};
            message.optOutPolicy = 'FILTER';
            if(!Test.IsRunningTest()) {
                message.subject = emaMap.get('24 hrs after meeting time').subject.replace('{!Opportunity.Full_Name__c}',str.custFullName);            
                message.setHtmlBody(emaMap.get('24 hrs after meeting time').HtmlValue.replace('{!Interior_Designer__c.Name}', str.DPName).replace('{!Opportunity.Customer_ID__c}',str.custId).replace('{!Opportunity.Full_Name__c}',str.custFullName).replace('{!Opportunity.Id}',str.recordId)); 
            }
            else {
                message.subject = '';
                message.setHtmlBody('');
            }
            message.setTemplateId(emaMap.get('24 hrs after meeting time').Id);          
            lstMails24Hrs.add(message);
            }
        }
        System.debug('*****lstMails24Hrs  '+lstMails24Hrs);
       // Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {lstMails};            
        Messaging.SendEmailResult[] results1 = Messaging.sendEmail(lstMails24Hrs);   
        
         // FOR 48 HRS
        List<Messaging.SingleEmailMessage> lstMails48Hrs = new List<Messaging.SingleEmailMessage>();
        for(wrapper48Hrs str : wrapperList48Hrs) {
            if(str.DPName != null && str.DPEmail != null && str.SSMEmail != null && str.SSAEmail != null && str.custId != null && str.custFullName != null) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {str.DPEmail} ; 
            message.ccAddresses = new String[] {str.SSMEmail, str.SSAEmail};
            message.optOutPolicy = 'FILTER';
            if(!Test.IsRunningTest()) {
                message.subject = emaMap.get('48 hours after the meeting').subject.replace('{!Opportunity.Full_Name__c}',str.custFullName);            
                message.setHtmlBody(emaMap.get('48 hours after the meeting').HtmlValue.replace('{!Interior_Designer__c.Name}', str.DPName).replace('{!Opportunity.Customer_ID__c}',str.custId).replace('{!Opportunity.Full_Name__c}',str.custFullName).replace('{!Opportunity.Id}',str.recordId).replace('{!User.Name}',str.SSMName)); 
            }
            else {
                message.subject = '';
                message.setHtmlBody('');
            }
            message.setTemplateId(emaMap.get('48 hours after the meeting').Id);          
            lstMails48Hrs.add(message);
            }
        }
        System.debug('*****lstMails48Hrs  '+lstMails48Hrs);
       // Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {lstMails};            
        Messaging.SendEmailResult[] results2 = Messaging.sendEmail(lstMails48Hrs);  
        
    if(!oppToUpdate.isEmpty())    
    update oppToUpdate;    
    }
    global void finish(Database.BatchableContext BC) {
    
    }
    
    global class wrapper2Hrs {
        String recordId;
        String DPName;
        String DPEmail;
        String SSMEmail;
        String SSAEmail;
        String custId;
        String custFullName;
    }
    
    global class wrapper24Hrs {
        String recordId;
        String DPName;
        String DPEmail;
        String SSMEmail;
        String SSAEmail;
        String custId;
        String custFullName;
    }
    
    global class wrapper48Hrs {
        String recordId;
        String DPName;
        String DPEmail;
        String SSMEmail;
        String SSMName;
        String SSAEmail;
        String custId;
        String custFullName;
    }
}