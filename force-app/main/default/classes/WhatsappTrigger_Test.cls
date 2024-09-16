@isTest 
global class WhatsappTrigger_Test{
     
  @isTest static void UnableToContactSuccess() {
        
        try{
            Lead objLead =  TestData_Factory.CreateFreshLead(false);
            insert objLead;
            
            Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test()); 
            Integration_Setting__c  intSetting = TestData_Factory.createIntegrationSetting('Verloop API',
                                                                    'https://homelane.verloop.io/api/v1/Campaign/SendMessage/V2',
                                                                    'u$r132fe08ce31d4b4f',
                                                                    'application/json',
                                                                    '2e388d2e3c98');
            
            standerdTaskTriggerHandler.sendWhatsapp(objLead);
        }
        catch(Exception e){
        }
    }
    
    @isTest static void UnableToContactFailure() {
        
        try{
            Lead objLead =  TestData_Factory.CreateFreshLead(false);
            insert objLead;
            
            Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test()); 
            Integration_Setting__c  intSetting = TestData_Factory.createIntegrationSetting('Verloop API',
                                                                    'https://homelane.verloop.io/api/v1/Campaign/SendMessage/V1',
                                                                    'u$r132fe08ce31d4b4f',
                                                                    'application/json',
                                                                    '2e388d2e3c98');
            
            standerdTaskTriggerHandler.sendWhatsapp(objLead);
            }
                    catch(Exception e){
        }
    }   
    
   @isTest static void sendWhatsappWithNullParameter() {
        
        Lead objLead =  TestData_Factory.CreateFreshLead(false);
        insert objLead;
        
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test()); 
        Integration_Setting__c  intSetting = TestData_Factory.createIntegrationSetting('Verloop API',
                                                                'https://homelane.verloop.io/api/v1/Campaign/SendMessage/V1',
                                                                'u$r132fe08ce31d4b4f',
                                                                'application/json',
                                                                '2e388d2e3c98');
        
        WhatsappTrigger.sendWhatsapp(NULL,NULL,NULL,NULL,NULL,NULL);
    } 
    
   @isTest static void sendNps() {
          
        Account personAcc =  TestData_Factory.createAccount(false);
         personAcc.Phone= '1234567890';
        insert personAcc;
        
        Opportunity perOpp= TestData_Factory.createOpportunity(personAcc.Id,false);
        perOpp.Whatsapp_Opt_in__c = true;
       
        insert perOpp;
        
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test()); 
        Integration_Setting__c  intSetting = TestData_Factory.createIntegrationSetting('Verloop API',
                                            'https://homelane.verloop.io/api/v1/Campaign/SendMessage/V1',
                                            'u$r132fe08ce31d4b4f',
                                            'application/json',
                                            '2e388d2e3c98');   
                                            
       WhatsappTrigger.SendNPS(perOpp.id);                                     
     
    }     
    
      @isTest 
      public static void testSucess() 
      {
      try{
  
            Account personAcc =  TestData_Factory.createAccount(false);
            insert personAcc;
            
            Opportunity perOpp= TestData_Factory.createOpportunity(personAcc.Id,false);
            perOpp.Whatsapp_Opt_in__c = true;
            insert perOpp;
            
            Quote quote = new Quote();
            quote.Name = 'testQuote';
            quote.OpportunityId = perOpp.id;
            quote.Status = 'Draft';
            insert quote;
            
            Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test()); 
            Integration_Setting__c  intSetting = TestData_Factory.createIntegrationSetting('Verloop API',
                                                                    'https://homelane.verloop.io/api/v1/Campaign/SendMessage/V1',
                                                                    'u$r132fe08ce31d4b4f',
                                                                    'application/json',
                                                                    '2e388d2e3c98');      
                                                                    
            Integration_Setting__c  intSetting1 = TestData_Factory.createIntegrationSetting('Tiny URL API',
                                                                    'https://www.homelane.com/apis/quotes/generateTinyUrl?/V1',
                                                                    'u$r132fe08ce31d4b4f',
                                                                    'application/json',
                                                                    '2e388d2e3c98');                                                                          
            test.startTest();
            
            quote.Published__c= 'Yes';
            update quote;
             test.stopTest();
             }
             catch(Exception e){
             }
        
       }
    
    
    
    
    
    
    
     
}