@RestResource(urlMapping='/Getcustomerstatus/*')
global with sharing class Getcustomerstatus
{
  public Static String strBody{get;set;}
@HttpGet
  global static list<FinalWrapper>  getopprec() {
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        RestRequest req = RestContext.request; 
        String LeadOROpportunityOrderID = '';
        if(!Test.IsRunningTest())
          LeadOROpportunityOrderID = req.params.get('LeadOROpportunityOrderID');
        else
          LeadOROpportunityOrderID = strBody;  
        List<sObject> opplist = new List<sObject>();
        //List<sObject> leadlist = new List<sObject>(); 

        if(LeadOROpportunityOrderID!=''){
            system.debug('LeadOROpportunityOrderID ------------------->'+LeadOROpportunityOrderID);
            String oppoppquery = 'select id,StageName,name,Customer_Email__c,Customer_ID__c,account.Customer_ID__c from Opportunity where Customer_ID__c = \''+LeadOROpportunityOrderID+'\'';
            String leadoppquery = 'select id,Status,name,Email,Customer_ID__c from Lead where Customer_ID__c = \''+LeadOROpportunityOrderID+'\'';
            
            system.debug('oppoppquery -------------------->'+oppoppquery);
            system.debug('leadoppquery -------------------->'+leadoppquery);
            
            system.debug('leadoppquery -------------------->'+Database.query(leadoppquery));
            system.debug('leadoppquery -------------------->'+Database.query(oppoppquery ));
            
            if(Database.query(leadoppquery)!=null){
                opplist = Database.query(leadoppquery);
                List<Lead> listopp = (List<Lead>)(opplist);
                for(Lead ld : listopp){
                    FinalWrapper fin = new FinalWrapper();
                    fin.Id = ld.Id;
                    fin.name = ld.Name;
                    fin.Status = ld.Status;
                    fin.email = ld.Email;
                    fin.CID = ld.Customer_ID__c;
                    fin.RecordType = 'Lead';
                    finalList.add(fin);
                }
            } 
            if(Database.query(oppoppquery )!=null){
                opplist = Database.query(oppoppquery );
                List<Opportunity> listopp = (List<opportunity>)(opplist);
                for(Opportunity ld : listopp){
                    FinalWrapper fin = new FinalWrapper();
                    fin.Id = ld.Id;
                    fin.name = ld.Name;
                    fin.Status = ld.StageName;
                    fin.email = ld.Customer_Email__c;
                    fin.CID = ld.Customer_ID__c;
                    fin.RecordType = 'Opportunity';
                    finalList.add(fin);
                }
            }
          
        }
        return finalList;
        
        }
        global class FinalWrapper{
            public String RecordType{get;set;}
            public String Id{get;set;}
            public String name{get;set;}
            public String email{get;set;} 
            public String CID{get;set;}
            public String Status{get;set;}
        }
        
        
}