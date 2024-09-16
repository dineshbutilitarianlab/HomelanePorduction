@RestResource(urlMapping='/UpdateNPS/*')
global with sharing class UpdateNPS
{
  public Static String strBody{get;set;}
@HttpGet
  global static void  getopprec() {
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        RestRequest req = RestContext.request; 
        String phone = '';
        if(!Test.IsRunningTest())
          phone = req.params.get('phone');
        else
          phone = strBody;  
        List<sObject> opplist = new List<sObject>();
        //List<sObject> leadlist = new List<sObject>(); 
        String phoneCode = '+91'+phone;
        List<Opportunity> lstNewOpp = new List<Opportunity>();
        system.debug('phoneCode ------------------->'+phoneCode);
           
            for(Opportunity ld : [Select Id,NPS_Email_Count__c,Customer_Email__c,Customer_Phone_Number__c from Opportunity where Customer_Phone_Number__c = : phone OR  Customer_Phone_Number__c = : phoneCode]){
                if(ld.NPS_Email_Count__c != null)
                    ld.NPS_Email_Count__c = ld.NPS_Email_Count__c+1;
                else
                    ld.NPS_Email_Count__c =1;
                   lstNewOpp.add(ld);
                }
        FinalWrapper objFinalWrapper = new FinalWrapper(); 
           if(!lstNewOpp.isEmpty()){
               try{            
                update lstNewOpp;
                objFinalWrapper.resMessage = 'NPS Email Sent.';
                objFinalWrapper.lstOpportunity = lstNewOpp;
               }catch(Exception exp){
                objFinalWrapper.resMessage = exp.getMessage();   
               }
           }
           else{
                       
             objFinalWrapper.resMessage = 'No Customer Found with this Phone Number.';
           }            
          
         if(!Test.isRunningTest()){
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(json.serialize(objFinalWrapper));
                    }    
        
        
        }
        global class FinalWrapper{
            public String resMessage{get;set;}
            public List<Opportunity> lstOpportunity{get;set;}
        }
        
        
}