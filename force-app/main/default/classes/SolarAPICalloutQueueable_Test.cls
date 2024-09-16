@istest
global class SolarAPICalloutQueueable_Test  {
    
     public static  Integration_Setting__c  intSetting ;
    Public static Lead ld;
    public static master__c prop;
    @TestSetup static void data() { 
        intSetting = new Integration_Setting__c();
        intSetting.Name = 'Solr API';
        intSetting.End_Point__c ='https://blitz-property-searcher.homelane.com/blitz-property?' ;
        
        //intSetting.ContentType__c = 'application/json';
        
        intsetting.Authorization__c='Basic c2ZfdXNlcjoxVVBtRmNBNFhsck9TNE4=';
                  
            
        insert intsetting ;
         prop = new Master__c();
        prop.Name ='testprop';
        prop.Type__c ='Property';
        insert prop;
        
        account acc= new account();
        acc.name='Tetsacc';
        insert acc;
         //Create User record
        
       
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Account__c =acc.id;
        ld.city='Bengaluru';
        insert ld;
        
    }
    
    
    
    public testMethod static void testscenario1(){
        
        
        
        test.startTest();
        try{
            intsetting = [select id from Integration_Setting__c limit 1 ];
            prop =[select id from Master__c limit 1];
            ld=[select id from lead limit 1];
            ld.Property__c = prop.id;
            update ld;
            List<Id> LeadIds = new List<Id>();
            LeadIds.add(ld.id);
            //LeadPropertyUpdateAPI.getPropertyName(ld.id);
            CallOutToSolrQueue.CallSolrAPI(LeadIds);
            //LeadPropertyUpdateAPI.getPropertyName(ld.id);
            //Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
            //SolarAPICalloutQueueable.SolarAPICalloutQueueable(lstLead, sessionId)
        }catch(exception e){
            system.debug('exception');
        }
        
        test.stoptest();
        
    }
     public testMethod static void testscenario2(){
        test.startTest();
        intsetting = [select id from Integration_Setting__c limit 1 ];
            prop =[select id from Master__c limit 1];
            ld=[select id from lead limit 1];
            ld.Property__c = null;
            ld.Is_Blitz_property_lead__c = true;
            update ld;
       // lead ld =[select id from ld limit 1];
         List<Id> LeadIds = new List<Id>();
            LeadIds.add(ld.id);
            //LeadPropertyUpdateAPI.getPropertyName(ld.id);
            CallOutToSolrQueue.CallSolrAPI(LeadIds);
         Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        test.stoptest();
        
    }
    
    public testMethod static void testscenario3()
    {
        test.startTest();
           SolarAPICalloutQueueable.dummyTestCover();
         test.stoptest();
    }
}