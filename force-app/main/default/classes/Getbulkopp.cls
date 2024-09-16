@RestResource(urlMapping='/Getbulkopp/*')
global with sharing class Getbulkopp{
    public static String strBody{get;set;}
@HttpPost
  global static list<FinalWrapper>  getopprec() {
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        String orderUniqueIDInput = '';
        if(Test.isRunningTest()){
         orderUniqueIDInput = strBody;
        }else{
            RestRequest req = RestContext.request; 
            orderUniqueIDInput = req.requestBody.toString();
        }
        system.debug('orderUniqueIDInput---------------------->'+orderUniqueIDInput);
        List<sObject> opplist = new List<sObject>();
        try{
        Map<String, Object> JSON_Input = (Map<String, Object>)JSON.deserializeUntyped(orderUniqueIDInput);
        system.debug('JSON_Input---------------------->'+JSON_Input);
        String OpportunityOrderID = (String) JSON_Input.get('OpportunityOrderIDs');
        system.debug('OpportunityOrderID---------------------->'+OpportunityOrderID);
        String[] OpportunityOrderIDSet = OpportunityOrderID.split(',');
        system.debug('OpportunityOrderIDSet---------------------->'+OpportunityOrderIDSet);       
        
        if(OpportunityOrderIDSet.size() != 0){
            
            opplist = [Select id,Customer_ID__c,StageName,name,X10_Payment_Date__c,Opportunity_Stage__c,Artifact_ID__c,Amount,Quote_Status__c,Customer_Email__c, Account.LastName,Account.FirstName,Account.PersonEmail,Account.Phone,Account.BillingCity,Customer_Phone_Number__c,CityfromLead__c,CreatedDate,Account.BillingCountry,Account.BillingState,Account.BillingStreet,Account.Customer_ID__c from Opportunity where Customer_ID__C IN : OpportunityOrderIDSet];
            system.debug('opplist---------------------->'+opplist);
            system.debug('opplist.size()---------------------->'+opplist.size());
            List<Opportunity> listopp = (List<Opportunity>)(opplist);
            
            
            for(Opportunity ld : listopp ){
                FinalWrapper fin = new FinalWrapper();
                if(ld.Opportunity_Stage__c == 'Won'){
                    fin.x10Payment = 'Yes';                 
                }else{
                 fin.x10Payment = 'No';
                }
                fin.Id = ld.Id;
                fin.name = ld.Name;
                fin.Status = ld.StageName;
                fin.email = ld.Customer_Email__c;
                fin.amnt = ld.Amount;
                fin.phoneno = ld.Customer_Phone_Number__c;
                fin.recordcreateddate= ld.CreatedDate;
                fin.city= ld.CityfromLead__c;
                fin.CID = ld.Customer_ID__c;
                finalList.add(fin);
            }
            
        }
        }catch(Exception exp){
                system.debug('Error Meassage in Getbulkopp---------------------->'+exp.getMessage());
            }
        return finalList;
        
        }
        global class FinalWrapper{
            public String Id{get;set;}
            public String name{get;set;}
            public String email{get;set;} 
            public Decimal amnt{get;set;}
            public String city{get;set;}
            public String CID{get;set;}
            public Datetime recordcreateddate{get;set;}
            public String x10Payment{get;set;}
            public String phoneno{get;set;}
            public String Status{get;set;}
        }
}