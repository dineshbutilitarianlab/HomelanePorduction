@RestResource(urlMapping='/Getoppdetails/*')
global with sharing class Getoppdetails
{
@HttpGet
  global static list<FinalWrapper>  getopprec() {
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        RestRequest req = RestContext.request; 
        String opptynumber = req.params.get('opptynumber'); 
        String OpportunityOrderID = req.params.get('OpportunityOrderID');
        system.debug('------------------>opptynumber'+opptynumber ); 
        List<sObject> opplist = new List<sObject>(); 

        if(opptynumber!=''){
            String query = 'select id,StageName,name,Customer_ID__c,Artifact_ID__c,Interior_Design_Partner__r.Mobile__c,Square_Showroom_Agent__r.phone,Amount,Quote_Status__c,Customer_Email__c, Account.LastName,Account.FirstName,Account.PersonEmail,Account.Phone,Account.BillingCity,Customer_Phone_Number__c,CityfromLead__c,CreatedDate,Account.BillingCountry,Account.BillingState,Account.BillingStreet,Account.Customer_ID__c,Interior_Design_Partner__r.name,Interior_Design_Partner__r.Email__c,Square_Showroom_Manager__r.name,Square_Showroom_Manager__r.email,Square_Showroom_Agent__r.name,Square_Showroom_Agent__r.email from Opportunity where AutoNumber_For_Quote_Creation__c = \''+opptynumber+'\'';
            opplist = Database.query(query);
            system.debug('opplist---------------------->'+opplist);
            system.debug('opplist.size()---------------------->'+opplist.size());
            List<Opportunity> listopp = (List<Opportunity>)(opplist);
            for(Opportunity ld : listopp ){FinalWrapper fin = new FinalWrapper();fin.Id = ld.Id;fin.name = ld.Name;fin.Status = ld.StageName;fin.email = ld.Customer_Email__c;fin.amnt = ld.Amount;fin.phoneno = ld.Customer_Phone_Number__c;fin.recordcreateddate= ld.CreatedDate;fin.city= ld.CityfromLead__c;fin.ArtifactID = ld.Artifact_ID__c;fin.QuoteStatus = ld.Quote_Status__c;fin.CID = ld.Customer_ID__c;fin.SSAname = ld.Square_Showroom_Agent__r.name;fin.SSAemail = ld.Square_Showroom_Agent__r.email;fin.SSMname = ld.Square_Showroom_Manager__r.name;fin.SSMemail = ld.Square_Showroom_Manager__r.email;fin.DPname = ld.Interior_Design_Partner__r.name;fin.DPemail = ld.Interior_Design_Partner__r.Email__c;fin.SSAphone = ld.Square_Showroom_Agent__r.phone;fin.DPphone = ld.Interior_Design_Partner__r.Mobile__c;finalList.add(fin);
            }
        
        }

        if(OpportunityOrderID!=''){
            String query = 'select id,StageName,name,Customer_ID__c,Artifact_ID__c,Interior_Design_Partner__r.Mobile__c,Square_Showroom_Agent__r.phone,Amount,Quote_Status__c,Customer_Email__c, Account.LastName,Account.FirstName,Account.PersonEmail,Account.Phone,Account.BillingCity,Customer_Phone_Number__c,CityfromLead__c,CreatedDate,Account.BillingCountry,Account.BillingState,Account.BillingStreet,Account.Customer_ID__c,Interior_Design_Partner__r.name,Interior_Design_Partner__r.Email__c,Square_Showroom_Manager__r.name,Square_Showroom_Manager__r.email,Square_Showroom_Agent__r.name,Square_Showroom_Agent__r.email from Opportunity where Customer_Id__c = \''+OpportunityOrderID+'\'';
            opplist = Database.query(query);
            system.debug('opplist---------------------->'+opplist);
            system.debug('opplist.size()---------------------->'+opplist.size());
            List<Opportunity> listopp = (List<Opportunity>)(opplist);
            for(Opportunity ld : listopp ){FinalWrapper fin = new FinalWrapper();fin.Id = ld.Id;fin.name = ld.Name;fin.Status = ld.StageName;fin.email = ld.Customer_Email__c;fin.amnt = ld.Amount;fin.phoneno = ld.Customer_Phone_Number__c;fin.recordcreateddate= ld.CreatedDate;fin.city= ld.CityfromLead__c;fin.ArtifactID = ld.Artifact_ID__c;fin.QuoteStatus = ld.Quote_Status__c;fin.CID = ld.Customer_ID__c;fin.SSAname = ld.Square_Showroom_Agent__r.name;fin.SSAemail = ld.Square_Showroom_Agent__r.email;fin.SSMname = ld.Square_Showroom_Manager__r.name;fin.SSMemail = ld.Square_Showroom_Manager__r.email;fin.DPname = ld.Interior_Design_Partner__r.name;fin.DPemail = ld.Interior_Design_Partner__r.Email__c;fin.SSAphone = ld.Square_Showroom_Agent__r.phone;fin.DPphone = ld.Interior_Design_Partner__r.Mobile__c;finalList.add(fin);
            }
            
        }
        return finalList;
        
        }
        global class FinalWrapper{public String Id{get;set;} public String QuoteStatus{get;set;} public String ArtifactID{get;set;}public String name{get;set;}public String SSAname{get;set;}public String SSAemail{get;set;}public String DPphone{get;set;}public String SSAphone{get;set;}public String SSMname{get;set;}public String SSMemail{get;set;} public String DPname{get;set;} public String DPemail{get;set;}public String email{get;set;} public Decimal amnt{get;set;} public String city{get;set;} public String CID{get;set;} public Datetime recordcreateddate{get;set;} public String phoneno{get;set;}public String Status{get;set;}
        }
}