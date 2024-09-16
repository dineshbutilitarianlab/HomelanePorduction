public without sharing class WalkinLeadController{
@AuraEnabled

    public static String saveLead (Lead led) {
       Master__c master = new Master__c();
        
        if(!Test.isRunningTest()){
            String ii = led.Appointment_Venue_Square__c;
            led.Creation_Date__c = system.now();
            system.debug('ii  ---------------------------->'+ii);
            master = [select SSM__c,WalkIn_SSA__c,Showroom_Manager__c,id from Master__c where id =:ii]; 
            system.debug('master  ---------------------------->'+master);
            system.debug('master.SSM__C ---------------------------->'+master.SSM__C);
            led.Square_Showroom_Manager__c = master.SSM__c;
            led.Showroom_Manager__c = master.Showroom_Manager__c;
            System.debug('led.Showroom_Manager__c: '+led.Showroom_Manager__c);
            System.debug('led.Square_Showroom_Manager__c: '+led.Square_Showroom_Manager__c);
            //led.Square_Showroom_Agent__c = master.WalkIn_SSA__c!=null?master.WalkIn_SSA__c:Userinfo.getUserId();
            system.debug('data coming in -2222--------------------------->'+led);
        }
       
        try{
          /*List<Lead> objLead = [Select Id,LeadSource,Email From Lead Where (Email =: led.Email OR Phone =: led.Phone) AND Redundant_Duplicate__c = false Limit 1];
           // if(objLead.size() >0){
               led.Id = objLead[0].Id;
               led.LeadSource = objLead[0].LeadSource;
               Upsert led;
           }*/
           System.debug('led.channel_Partner__c: '+led.channel_Partner__c);
            led.Channel_Partner__r = null;
           Upsert led;
            System.debug('led.channel_Partner__c: '+led.channel_Partner__c);
          return null;  
        }
        catch(Exception exp){
            System.debug('Exception :'+exp.getStackTraceString());
            SendEmailToManager('Salesforce - This is to inform you that Lead with the phone ='+led.Phone+' and Email = '+led.Email+' is not inserted or updated,Because we got the following error-'+exp.getMessage()+'.Please do the needful');
            return ChangeErrorMessage(exp.getMessage());
        }            
    }
    public static String ChangeErrorMessage(String errorMsg){
      if(errorMsg.ContainsIgnoreCase('_EXCEPTION')){
        Integer index = errorMsg.indexOf('_EXCEPTION');
        String msg = errorMsg.substring(index+11, errorMsg.length());
        return msg;

      }else{
        return errorMsg;
      }
    }
   
@AuraEnabled
    public static Lead checkExistingLead(Lead leadObj){
    String err;
    System.debug('leadObj--checkExistingLead------------------------->'+leadObj);
        try{
            List<Lead> objLead = [Select Id,City,LeadSource,Email,Status From Lead Where (Email =: leadObj.Email OR Phone =: leadObj.Phone) AND Redundant_Duplicate__c = false];
            System.debug('objLead--------------------------->'+objLead);
             if(objLead.size() == 0){
                Lead obj = new Lead();
                obj.FirstName = leadObj.FirstName;
                obj.LastName = leadObj.LastName;
                obj.Email = leadObj.Email;
                obj.Phone = leadObj.Phone;
                obj.City =  leadObj.City;
                obj.Status = 'Fresh Lead';
                obj.Sub_Status__c = 'New';
               // obj.LeadSource = 'Walk-In';
                obj.LeadSource = leadObj.LeadSource;
                obj.Whatsapp_Opt_in__c = leadObj.Whatsapp_Opt_in__c;
                insert obj; 
                return obj; 
             }
             else{                 
                 return null;
             }
                
       return null;     
                  
        }
        catch(Exception exp){
            System.debug('exp--------------------------->'+exp.getMessage());
            return null;
        }
        
    }
    
@AuraEnabled
    public static Lead checkExistingLeadUnqualified(Lead leadObj){
    System.debug('leadObj--checkExistingLead------------------------->'+leadObj);
        try{
            List<Lead> objLead = [Select Id,City,LeadSource,Email,Appointment_Venue_Square__r.Property_City__c,Customer_ID__c,Status From Lead Where (Email =: leadObj.Email OR Phone =: leadObj.Phone) AND Redundant_Duplicate__c = false];
            Master__c mas = [select id, name, Property_City__c from Master__c where id=:leadObj.Appointment_Venue_Square__c limit 1];
            System.debug('objLead--------------------------->'+objLead);
             if(objLead.size() == 0){
                Lead obj = new Lead();
                obj.FirstName = leadObj.FirstName;
                obj.LastName = leadObj.LastName;                
                obj.Phone = leadObj.Phone;
                if(leadObj.Email == null || leadObj.Email == '')
                obj.Email = 'walkin'+leadObj.Phone+'@dummywalkin.com';
                else 
                obj.Email = leadObj.Email;
                obj.City =  mas.Property_City__c;
               // obj.Status = 'Fresh Lead';
              //  obj.Sub_Status__c = 'New';
                obj.LeadSource = 'Unqualified Walk-in';
                if(leadObj.Appointment_Venue_Square__c != null)
                obj.Appointment_Venue_Square__c = leadObj.Appointment_Venue_Square__c;
                obj.Why_we_didn_t_offer_design_discussion__c = leadObj.Why_we_didn_t_offer_design_discussion__c;
                if(obj.Why_we_didn_t_offer_design_discussion__c == 'Budget less than Rs. 1.5Lakh') {
                    obj.Status = 'Dead Lead';
                    obj.Sub_Status__c = 'Qualification Constraints(Budget/Requirements)';
                }
                else if(obj.Why_we_didn_t_offer_design_discussion__c == 'Possession > 4 months') {
                    obj.Status = 'Not actively pursued';
                    obj.Sub_Status__c = 'Possession beyond 6 months';
                    obj.Possession_Date__c = system.today().addMonths(4);
                }
                else if(obj.Why_we_didn_t_offer_design_discussion__c == 'Move-in > 6 months') {
                    obj.Status = 'Not actively pursued';
                    obj.Sub_Status__c = 'Possession beyond 6 months';
                    obj.Possession_Date__c = system.today().addMonths(4);
                }
                else if(obj.Why_we_didn_t_offer_design_discussion__c == 'Requirements not in HL Scope') {
                    obj.Status = 'Dead Lead';
                    obj.Sub_Status__c = 'Non Serviceable Product/Service';
                }
                else if(obj.Why_we_didn_t_offer_design_discussion__c == 'Not within city limits') {
                    obj.Status = 'Dead Lead';
                    obj.Sub_Status__c = 'Non serviceable city';
                }
                else if(obj.Why_we_didn_t_offer_design_discussion__c == 'Customer didn\'t have enough time') {
                    obj.Status = 'Fresh Lead';
                    obj.Sub_Status__c = 'Visited Showroom';
                }
                else if(obj.Why_we_didn_t_offer_design_discussion__c == 'Designer not available') {
                    obj.Status = 'Fresh Lead';
                    obj.Sub_Status__c = 'Visited Showroom';
                }
                System.debug('obj--------------------------->'+obj);
                insert obj; 
                updateLeadUnqualified(obj);
                return obj; 
             }else{
                return objLead[0];  
             }                 
        }
        catch(Exception exp){
            System.debug('exp--------------------------->'+exp.getMessage());
            return null;
        }
        
    }
    
 public static Lead updateLeadUnqualified(Lead leadObj){
     System.debug('leadObj--checkExistingLead------------------------->'+leadObj);
          UserIds__c userId = [select name, Id__c from UserIds__c where Name = 'Fazil Ahmed'];
          System.debug('******userId  '+userId);
          leadObj.OwnerId = userId.Id__c;
          leadObj.WT_Agent__c = userId.Id__c;
          if(leadObj.Status == 'Not Actively Pursued' && leadObj.Sub_Status__c == 'Possession Beyond 6 Months') {            
              leadObj.Follow_up_time__c = date.today().addMonths(4);
          } 
          if(leadObj.Status == 'Fresh Lead' && leadObj.Sub_Status__c == 'Visited Showroom') {            
              leadObj.Push_lead_to_Ameyo_Time__c = System.now().addHours(3);
          } 
          update leadObj;         
          return leadObj;
     }   
     
@AuraEnabled
    public static String updateExistigLead(Lead newLead){
       System.debug('newLead----upper----------------------->'+newLead);
        try{
            System.debug('newLead--------------------------->'+newLead);
            if(newLead.Id != null)
                update newLead; 
            return null;
        }
        catch(Exception exp){
            return ChangeErrorMessage(exp.getMessage());
        }
        
    }   
@AuraEnabled
 public Static void SendEmailToManager(String errMsg){
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.toAddresses = new String[] {'balasubramanian.r@kvpcorp.com','qa@homelane.com','cameron.j@homelane.com','nitin.b@homelane.com'}; 
                            message.optOutPolicy = 'FILTER';
                            message.subject = 'Walk In Lead Issue';
                            message.plainTextBody = errMsg;
                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }   
}