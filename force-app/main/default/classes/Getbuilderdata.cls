/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Author: Aditya Saini
* Created Date : 8th May 2017
* Description : This class will generate json file that will contain builder name and ID 
*               Through API - /services/apexrest/Getbuilderdata.
* ─────────────────────────────────────────────────────────────────────────────────────────────────
**/

@RestResource(urlMapping='/Getbuilderdata/*')
global with sharing class Getbuilderdata{
@HttpGet
  global static list<FinalWrapper>  getbuilderrec() {
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        //String Oppemail = RestContext.request.params.get('Oppemail');
        //system.debug('testrun');
        //system.debug('------------------>Oppemail'+Oppemail); 
        String type = 'Property'; 
        List<Master__c > buildrlist = new List<Master__c >();        
        String query = 'select id,Name,Type__c,Property_City__c,Builder_Name__c,Builder_Name__r.name from Master__c where Type__c = \''+type+'\'';        
        buildrlist = Database.query(query);
        system.debug('buildrlist ---------------------->'+buildrlist );
        system.debug('buildrlist.size()---------------------->'+buildrlist.size());
        List<Master__c> listbuild = (List<Master__c>)(buildrlist);
        for(Master__c ld : listbuild ){FinalWrapper fin = new FinalWrapper();fin.ProjectID= ld.Id;fin.Projectcity = ld.Property_City__c;fin.BuilderID = ld.Builder_Name__c;fin.BuilderName = ld.Builder_Name__r.name;fin.ProjectName= ld.Name;finalList.add(fin);}
        return finalList;
     }
     global class FinalWrapper{ 
         public String ProjectID{get;set;}public String ProjectName{get;set;}public String Projectcity{get;set;}public String BuilderID{get;set;}public String BuilderName{get;set;}
     }
}