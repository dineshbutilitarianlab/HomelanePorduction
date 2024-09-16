@isTest
public Class Rest_SendOpportunitytoSpaceCraft_Test{

    public static testMethod void testSuccess() {
    
        List<Opportunity> lstOpp = new  List<Opportunity>();
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout('','ok',200)); 
        Integration_Setting__c intSetting = new Integration_Setting__c();
        intSetting.Name = 'Spacecraft Opportunity API';
        intSetting.End_Point__c = 'http://sc-backend-qa.homelane.com/';
        intSetting.Authorization__c= 'Authorization';
        insert intSetting;      
        
        Account a = new Account();
        a.name= 'Test User';
        a.Customer_ID__c = 'BenTest-09';
        insert a;
        
        Opportunity opp1 = new Opportunity();
        opp1.AccountId = a.id;
        opp1.name = 'first';
        opp1.StageName='Won';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.Opportunity_Status__c = '6.Won';
        // opp1.AccountId = a.id;
        opp1.Customer_Satisfaction__c = 5;
        opp1.CloseDate = Date.Today();
        // opp1.Interior_Design_Partner__c = inte.id;
        opp1.Order_Book_Date__c = Date.Today();
        opp1.Amount = 1000;
        opp1.Lead_Customer_Quote_Number__c = '10230';
        opp1.Order_Closed__c = true;
        opp1.Appointment_Type__c = 'Square Showroom Visit';
        opp1.Time_of_Actual_Appointment_Start__c = Date.Today().addmonths(-1);
        opp1.Order_Book_Date__c = Date.Today().addmonths(-1);
        //oppList.add(opp1);
        System.debug('****opp1  '+opp1);
        lstOpp.add(opp1);
        
        
        test.startTest();
                 Integer start = System.Now().millisecond();
        while(System.Now().millisecond()< start+40){ 
             

            //insert opp1;
             
            Rest_SendOpportunitytoSpaceCraft abc = new Rest_SendOpportunitytoSpaceCraft(lstOpp);
            ID jobID = System.enqueueJob(abc);
         }   
        test.stopTest();
    }
    
   /* public static testMethod void testFailure() {
    
        List<Opportunity> lstOpp = new  List<Opportunity>();
        Account a = new Account();
        a.name= 'Test User';
        a.Customer_ID__c = 'BenTest-09';
        insert a;
        
        Opportunity opp1 = new Opportunity();
        opp1.AccountId = a.id;
        opp1.name = 'first';
        opp1.StageName='Won';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.Opportunity_Status__c = '6.Won';
        // opp1.AccountId = a.id;
        opp1.Customer_Satisfaction__c = 5;
        opp1.CloseDate = Date.Today();
        // opp1.Interior_Design_Partner__c = inte.id;
        opp1.Order_Book_Date__c = Date.Today();
        opp1.Amount = 1000;
        opp1.Lead_Customer_Quote_Number__c = '10230';
        opp1.Order_Closed__c = true;
        opp1.Appointment_Type__c = 'Square Showroom Visit';
        opp1.Time_of_Actual_Appointment_Start__c = Date.Today().addmonths(-1);
        opp1.Order_Book_Date__c = Date.Today().addmonths(-1);
        //oppList.add(opp1);
        System.debug('****opp1  '+opp1);
        lstOpp.add(opp1);
        insert opp1;
        
        test.startTest();
         Integer start = System.Now().millisecond();
        while(System.Now().millisecond()< start+40){ 
                     Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout(NULL,'OK',200));
                     
            Rest_SendOpportunitytoSpaceCraft abc = new Rest_SendOpportunitytoSpaceCraft(lstOpp);
            ID jobID = System.enqueueJob(abc);
        }

            
        test.stopTest();
    }*/

}