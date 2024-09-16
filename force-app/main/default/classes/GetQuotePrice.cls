@RestResource(urlMapping='/GetQuotePrice/*')
global with sharing class GetQuotePrice
{
  public Static String strBody{get;set;}
@HttpGet
  global static list<FinalWrapper>  GetQuotePrice() {
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        RestRequest req = RestContext.request; 
        String customerID = '';
        if(!Test.IsRunningTest())
          customerID = req.params.get('customerID');
        else
          customerID = strBody;  
        if(customerID !=''){
            system.debug('customerID ------------------->'+customerID);
        try{
              List<sObject> opplist = new List<sObject>(); 
             String query = 'select Amount,Opportunity.Property_Name__r.name,Opportunity.Property_Name__r.Property_State__c,Opportunity.Property_Name__r.Property_Postal_Code__c,Opportunity.Property_Name__r.Property_City__c,Opportunity.Property_Name__r.Property_Landmark__c,Opportunity.Property_Name__r.Property_Locality__c,Opportunity.Property_Name__r.Street__c,Opportunity.account.BillingCity,Opportunity.account.BillingCountry,Opportunity.account.BillingPostalCode,Opportunity.account.BillingState,Opportunity.account.BillingStreet,Customer_Email__c,CreatedDate,CityfromLead__c,Customer_ID__c,Customer_Phone_Number__c,Id,Name,SyncedQuoteId from Opportunity where Customer_ID__c = \''+customerID+'\' Limit 1';        
        opplist = Database.query(query);
        system.debug('opplist---------------------->'+opplist);
        system.debug('opplist.size()---------------------->'+opplist.size());
        List<Opportunity> listopp = (List<Opportunity>)(opplist);
        Opportunity objOpp = new Opportunity();
        FinalWrapper fin = new FinalWrapper();
        for(Opportunity ld : listopp ){fin.Id = ld.Id;fin.name = ld.Name;fin.email = ld.Customer_Email__c;fin.amnt = ld.Amount;fin.customeraddress = ld.account.BillingStreet+','+ld.account.BillingState+','+ld.account.BillingCity+','+ld.account.BillingCountry+','+ld.account.BillingPostalCode;fin.CID = ld.Customer_ID__c;fin.phoneno = ld.Customer_Phone_Number__c;fin.recordcreateddate= ld.CreatedDate;fin.city= ld.CityfromLead__c;fin.propertyaddress = ld.Property_Name__r.Street__c+','+ld.Property_Name__r.Property_Locality__c+','+ld.Property_Name__r.Property_Landmark__c+','+ld.Property_Name__r.Property_City__c+','+ld.Property_Name__r.Property_State__c+','+ld.Property_Name__r.Property_Postal_Code__c;
        objOpp = ld;
        }
         
               Decimal WoodWorkPrice = 0.0;
               Decimal AppliancesPrice = 0.0;
               Decimal AccessoriesPrice = 0.0;
               Decimal HdsPrice = 0.0;
               Decimal OtherServicesPrice = 0.0;
               Decimal SalesPrice = 0.0;
               Decimal FunrniturePrice = 0.0;
               
                    
            if(objOpp.SyncedQuoteId !=null){  
            for(QuoteLineItem objItem :  [Select Id,Woodworks_Price__c,Appliances_Price__c,Accessories_Price__c,hds_price__c,Other_Services_Price__c,UnitPrice,Furniture_Price__c from QuoteLineItem Where QuoteId = :objOpp.SyncedQuoteId]){
                   WoodWorkPrice = WoodWorkPrice+objItem.Woodworks_Price__c;
                   AppliancesPrice = AppliancesPrice+objItem.Appliances_Price__c;
                   AccessoriesPrice = AccessoriesPrice+objItem.Accessories_Price__c;
                   HdsPrice = HdsPrice+objItem.hds_price__c;
                   OtherServicesPrice = OtherServicesPrice+objItem.Other_Services_Price__c;
                   SalesPrice = SalesPrice+objItem.UnitPrice;
                   FunrniturePrice = FunrniturePrice+objItem.Furniture_Price__c;
                  
                }
           }
            fin.WoodWorkPrice = WoodWorkPrice;
            fin.AppliancesPrice = AppliancesPrice;
            fin.AccessoriesPrice = AccessoriesPrice;
            fin.HdsPrice = HdsPrice;
            fin.OtherServicesPrice = OtherServicesPrice;
            fin.SalesPrice = SalesPrice;
            fin.FunrniturePrice = FunrniturePrice;
            fin.errorMsg = '';          
            finalList.add(fin);
           
        } catch(Exception exp){
              FinalWrapper fin = new FinalWrapper();
              fin.errorMsg = exp.getMessage();
              finalList.add(fin);
          }
           system.debug('finalList------------------->'+finalList); 
        }
        if(finalList.isEmpty()){
            FinalWrapper fin = new FinalWrapper();
           fin.errorMsg = 'Customer is not existes.';
           finalList.add(fin);
            
        }
        return finalList;
           
        }
        global class FinalWrapper{
           public String Id{get;set;}public String name{get;set;}public String email{get;set;}public Decimal amnt{get;set;}public String customeraddress{get;set;}public String propertyaddress{get;set;}public String city{get;set;}public String CID{get;set;}public Datetime recordcreateddate{get;set;}public String phoneno{get;set;}
            public String errorMsg{get;set;}
            public Decimal WoodWorkPrice{get;set;}
            public Decimal AppliancesPrice{get;set;}
            public Decimal AccessoriesPrice{get;set;}
            public Decimal HdsPrice{get;set;}
            public Decimal OtherServicesPrice{get;set;}
            public Decimal SalesPrice{get;set;}
            public Decimal FunrniturePrice{get;set;}
        }
        
        
}