@isTest
public class GetQuotePrice_test{
    static testMethod void testGetQuotePriceMethod(){
        String userEmail = '@HlxxTest.com';
         SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
       
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','SMM Profile','Square Sales Profile','Square Profile','Factory Coordinator Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti',Phone = '1234567892') ;
        insert ac; 
        
        User pm_user=leadUtil_Test.inserUser('pmOu1'+userEmail,'PM1',ac.Id,profileData.get('PM Profile')); 
        insert pm_user;
        User smm_user=leadUtil_Test.inserUser('Smmou1'+userEmail,'SMM1',ac.Id,profileData.get('SMM Profile')); 
        insert smm_user;
        User fac_coordinator=leadUtil_Test.inserUser('FCou1'+userEmail,'SMM1',ac.Id,profileData.get('Factory Coordinator Profile')); 
        insert fac_coordinator;
        User agent_user=leadUtil_Test.inserUser('SSPou1'+userEmail,'eSSP1',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('SPou1'+userEmail,'USP1',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('UDou1'+userEmail,'UDP1',ac.Id,profileData.get('Design Partner Profile'));
        insert dp_prof;
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Person Account'];
        Account personAcc=new Account(LastName='prathap',recordTypeId=recType.Id,PersonEmail='testOpxp1@gmail.com',phone='045612541',Customer_Id__c = 'cust1200');
        insert personAcc;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity',CloseDate  = System.Today(),Amount = 10000,stageName='Initial Quote Sent',NextStep = 'test step',AccountId = personAcc.Id);
        //Opportunity opp = SC_MI_TestHandler.insertOpportunity('Test Opportunity',System.Today(),'Initial Quote Sent',100,System.Today()+1); 
        opp.SMM__c=smm_user.id;
        opp.PM__c=pm_user.id;
        opp.Square_Showroom_Agent__c=agent_user.Id;
        opp.Square_Showroom_Manager__c=managerUser.Id;
        opp.Factory_Co_ordinator__c=fac_coordinator.id;
        opp.Customer_Email__c = 'testOpxp1@gmail.com';
        opp.design_partner__c=dp_prof.id;
        insert opp;
        
        Product2 prod = new Product2(Name = 'applinces', Family = 'Hardware');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
       PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 5000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 5000, IsActive = true);
        insert customPrice;
        
        Project_Name__c proj=new Project_Name__c();
        proj.Name='jp builders';
        proj.Start_Date__c=system.today();
        insert proj;
        string projid=proj.id;
        system.debug('------opp---------'+opp);
        Quote quoteId=new Quote();
        quoteId.Name='oppquote';
        quoteId.projectId__c=proj.id;
        quoteId.Pricebook2Id = customPB.Id;
        quoteId.OpportunityId=opp.id;
        insert quoteId;
        opp.SyncedQuoteId = quoteId.Id;
        update opp;
        system.debug('------quoteId---------'+quoteId);
        system.debug('------opp updated---------'+opp);
        QuoteLineItem objQLI = new QuoteLineItem(Woodworks_Price__c=5000.00,Appliances_Price__c=5000.00,Accessories_Price__c=5000.00,hds_price__c=5000.00,Other_Services_Price__c=5000.00,PricebookEntryId=customPrice.Id,UnitPrice=500.00,Furniture_Price__c=5000.00,Product2Id=prod.Id,QuoteId=quoteId.Id,Quantity=1);
        insert objQLI;
        system.debug('------objQLI---------'+objQLI);
        Test.StartTest();
        GetQuotePrice.strBody = personAcc.Customer_Id__c;
        GetQuotePrice.GetQuotePrice();
        
        Test.StopTest();
        
    }
    
    static testMethod void testGetQuotePriceMethod2(){
          
        
     Test.StartTest(); 
        
        GetQuotePrice.strBody = 'cust-100';
        GetQuotePrice.GetQuotePrice();
        Test.StopTest(); 
    }
}