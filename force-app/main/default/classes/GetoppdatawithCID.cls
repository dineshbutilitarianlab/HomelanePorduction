/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Author: Aditya Saini
* Created Date : 25th April 2017
* Description : This class will generate json file that will contain name,email,add,quote value  wrt customerID filed in the Sobject passed
*               through API - https://homelane--hmldevop.cs6.my.salesforce.com/services/apexrest/GetoppdatawithCID?customerID=customerID.
* ─────────────────────────────────────────────────────────────────────────────────────────────────
**/
@RestResource(urlMapping='/GetoppdatawithCID/*')
global with sharing class GetoppdatawithCID
{
@HttpGet
  global static list<FinalWrapper>  getopprec() {
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        String customerID = RestContext.request.params.get('customerID');
        system.debug('testrun');
        system.debug('------------------>customerID'+customerID );    
        List<sObject> opplist = new List<sObject>();        
        String query = 'select Amount,Opportunity.Property_Name__r.name,Opportunity.Property_Name__r.Property_State__c,Opportunity.Property_Name__r.Property_Postal_Code__c,Opportunity.Property_Name__r.Property_City__c,Opportunity.Property_Name__r.Property_Landmark__c,Opportunity.Property_Name__r.Property_Locality__c,Opportunity.Property_Name__r.Street__c,Opportunity.account.BillingCity,Opportunity.account.BillingCountry,Opportunity.account.BillingPostalCode,Opportunity.account.BillingState,Opportunity.account.BillingStreet,Customer_Email__c,CreatedDate,CityfromLead__c,Customer_ID__c,Customer_Phone_Number__c,Id,Name from Opportunity where Customer_ID__c = \''+customerID+'\'';        
        opplist = Database.query(query);
        system.debug('opplist---------------------->'+opplist);
        system.debug('opplist.size()---------------------->'+opplist.size());
        List<Opportunity> listopp = (List<Opportunity>)(opplist);
        for(Opportunity ld : listopp ){FinalWrapper fin = new FinalWrapper();fin.Id = ld.Id;fin.name = ld.Name;fin.email = ld.Customer_Email__c;fin.amnt = ld.Amount;fin.customeraddress = ld.account.BillingStreet+','+ld.account.BillingState+','+ld.account.BillingCity+','+ld.account.BillingCountry+','+ld.account.BillingPostalCode;fin.CID = ld.Customer_ID__c;fin.phoneno = ld.Customer_Phone_Number__c;fin.recordcreateddate= ld.CreatedDate;fin.city= ld.CityfromLead__c;fin.propertyaddress = ld.Property_Name__r.Street__c+','+ld.Property_Name__r.Property_Locality__c+','+ld.Property_Name__r.Property_Landmark__c+','+ld.Property_Name__r.Property_City__c+','+ld.Property_Name__r.Property_State__c+','+ld.Property_Name__r.Property_Postal_Code__c;finalList.add(fin);}
        return finalList;}global class FinalWrapper{public String Id{get;set;}public String name{get;set;}public String email{get;set;}public Decimal amnt{get;set;}public String customeraddress{get;set;}public String propertyaddress{get;set;}public String city{get;set;}public String CID{get;set;}public Datetime recordcreateddate{get;set;}public String phoneno{get;set;}}
}