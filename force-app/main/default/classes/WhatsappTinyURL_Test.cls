@isTest 
global class WhatsappTinyURL_Test{

        Public static Account personAcc ;
        Public static Opportunity perOpp;
        
     @isTest 
      public static void testSucess() 
      {
      try{
  
            Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test()); 
                         Account personAcc =  TestData_Factory.createAccount(false);
            insert personAcc;
            
                        Opportunity perOpp= TestData_Factory.createOpportunity(personAcc.Id,false);
            perOpp.Whatsapp_Opt_in__c = true;
            perOpp.Lead_Customer_Quote_Number__c = '10230';
            insert perOpp;
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
                                                                    
            Integration_Setting__c  intSetting2 = TestData_Factory.createIntegrationSetting('Spacecraft Opportunity API',
                                                                    'https://sc-backend-qa.homelane.com/project/',
                                                                    'u$r132fe08ce31d4b4f',
                                                                    'application/json',
                                                                    '2e388d2e3c98');                                                                       
                                                                    
                                                                    
                                                                                                                                           
            test.startTest();
            
            System.enqueueJob(new WhatsappTinyURL('1234576890','test','test','test',perOpp.id ));
             test.stopTest();
             }
             catch(Exception e){
             }
        
       }
}