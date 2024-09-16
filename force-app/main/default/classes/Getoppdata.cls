@RestResource(urlMapping='/Getoppdata/*')
global with sharing class Getoppdata
{
@HttpGet
  global static list<FinalWrapper>  getopprec() {
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        String OpportunityOrderID = RestContext.request.params.get('OpportunityOrderID');
        system.debug('testrun');
        system.debug('------------------>OpportunityOrderID'+OpportunityOrderID);    
        List<sObject> opplist = new List<sObject>();        
            String query = 'select id from Opportunity where Customer_ID__c = \''+OpportunityOrderID+'\'';        
        opplist = Database.query(query);
        system.debug('opplist---------------------->'+opplist);
        system.debug('opplist.size()---------------------->'+opplist.size());
        List<Opportunity> listopp = (List<Opportunity>)(opplist);
        for(Opportunity ld : listopp ){FinalWrapper fin = new FinalWrapper();fin.Id = ld.Id;finalList.add(fin);}
        return finalList;
     }
     global class FinalWrapper{ 
         public String Id{get;set;}
     }
}