@RestResource(urlMapping='/GetcustomerData/*')
global with sharing class GetcustomerData
{
  public Static String strBody{get;set;}
@HttpGet
  global static void getopprec() {
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        RestRequest req = RestContext.request; 
        String LeadOROpportunityOrderID = '';
        if(!Test.IsRunningTest())
          LeadOROpportunityOrderID = req.params.get('LeadOROpportunityOrderID');
        else
          LeadOROpportunityOrderID = strBody;  
        List<sObject> opplist = new List<sObject>();
        //List<sObject> leadlist = new List<sObject>(); 
        try{
        if(LeadOROpportunityOrderID!=''){
            system.debug('LeadOROpportunityOrderID ------------------->'+LeadOROpportunityOrderID);
            String oppoppquery = 'select id,name,Customer_Email__c,Interior_Design_Partner__r.Name from Opportunity where Customer_ID__c = \''+LeadOROpportunityOrderID+'\'';
            String leadoppquery = 'select id,name,Email,Interior_Designer__r.Name from Lead where Customer_ID__C = \''+LeadOROpportunityOrderID+'\' AND IsConverted = false';
            
            system.debug('oppoppquery -------------------->'+oppoppquery);
            system.debug('leadoppquery -------------------->'+leadoppquery);
            
            system.debug('leadoppquery -------------------->'+Database.query(leadoppquery));
            system.debug('leadoppquery -------------------->'+Database.query(oppoppquery ));
            
            if(Database.query(leadoppquery)!=null && (!Database.query(leadoppquery).isEmpty())){
                opplist = Database.query(leadoppquery);
                List<Lead> listopp = (List<Lead>)(opplist);
                for(Lead ld : listopp){
                    FinalWrapper fin = new FinalWrapper();
                    fin.Id = ld.Id;
                    fin.name = ld.Name;
                    fin.email = ld.Email;
                    fin.dpName = ld.Interior_Designer__r.Name;
                    fin.errorMsg = '';
                    fin.RecordType = 'Lead';
                    finalList.add(fin);
                    system.debug('leadoppquery -------------------->'+finalList);
                }
            } 
            if(Database.query(oppoppquery )!=null && (!Database.query(oppoppquery).isEmpty())){
                opplist = Database.query(oppoppquery );
                List<Opportunity> listopp = (List<opportunity>)(opplist);
                for(Opportunity ld : listopp){
                    FinalWrapper fin = new FinalWrapper();
                    fin.Id = ld.Id;
                    fin.name = ld.Name;
                    fin.email = ld.Customer_Email__c;
                    fin.dpName = ld.Interior_Design_Partner__r.Name;
                    fin.errorMsg = '';
                    fin.RecordType = 'Opportunity';
                    finalList.add(fin);
                    system.debug('oppoppquery -------------------->'+finalList);
                }
            }
            else{
                SendEmailToManager(LeadOROpportunityOrderID);
            }
          
        }
       }catch(Exception ex){
            FinalWrapper fin = new FinalWrapper();
                    fin.errorMsg = ex.getMessage();
                    SendEmailToManager(LeadOROpportunityOrderID);
                    finalList.add(fin);
                system.debug('oppoppquery Error-------------------->');
                    }
         if(!Test.isRunningTest()){
              string json_data = json.serialize(finalList);
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(json_data);
                    }    
       }
        global Static void SendEmailToManager(String LeadOROpportunityOrderID ){
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.toAddresses = new String[] { 'nitin.b@homelane.com','ravi.r@homelane.com' }; 
                           // message.toAddresses = new String[] {'sachin.k@kvpcorp.com','sachin.k@kvpcorp.com'}; 
                            message.optOutPolicy = 'FILTER';
                            message.subject = 'Customer Not Found';
                            message.plainTextBody = 'Salesforce - This is to inform you that Customer with Lead Order Unique ID ='+LeadOROpportunityOrderID+'is not present in SF, Please do the needful';
                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
        
        
        global class FinalWrapper{
            public String RecordType{get;set;}
            public String Id{get;set;}
            public String name{get;set;}
            public String email{get;set;} 
            public String dpName{get;set;}
            public String errorMsg{get;set;}
            
        }
        
        
}