@isTest
public class ChangeDPRestAPI_Test1{
    Public static Lead ld;
    Public static Master__c showRoom;
    Public static Account acc;
    Public static Opportunity opp;
    @TestSetup static void data() {

       //Create Lead Record
       ld = TestData_Factory.CreateFreshLead(true);
        
        //Create Account Record
        Account acc= TestData_Factory.createPersonAccount(false);
        acc.PersonEmail = 'test123@teata.com';
        acc.Phone = '1234567890';
        insert acc;
        
        //Create DP
        Interior_Designer__c dummyDp = TestData_Factory.createInteriorDesigner(false);
        insert dummyDp;
        
        Interior_Designer__c dummyDp1 = TestData_Factory.createInteriorDesigner(false);
        dummyDp1.email__C = 'abc@abc.com';
        insert dummyDp1;
        
        //Create Opportunity records
        Opp = TestData_Factory.createOpportunity(acc.Id, false);
        Opp.Interior_Design_Partner__c = dummyDp.id;
        insert Opp;
        
        ld.Interior_Designer__c = dummyDp.id;
        update ld;
    }
    
    public static testMethod void testSuccessOpportunity() {
   
        Integration_Setting__c intSetting = new Integration_Setting__c();
        intSetting.Name = 'SpaceCraft DPChange API';
        intSetting.End_Point__c = 'https://stage-iqapi.homelane.com/assign';
        intSetting.ContentType__c = 'application/json';
        insert intSetting;  
       
         
         Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());

         TEST.STARTTEST();
            
            opportunity Opp1 =  [Select id,Customer_ID__c,Customer_Email__c,Design_Partner_Email__c,Interior_Design_Partner__c  from Opportunity limit 1];
            system.debug('adsfasdfas'+Opp1.Design_Partner_Email__c);
            Opp1.Interior_Design_Partner__c  =[Select id from Interior_Designer__c where email__c = 'abc@abc.com' ].id;
            
             System.enqueueJob(new ChangeDPRestAPI(opp1,null,'abc@abc.com'));
             //Update Opp1;
            
        TEST.STOPTEST();
    }
    public static testMethod void testSuccessLead() {
   
        Integration_Setting__c intSetting = new Integration_Setting__c();
        intSetting.Name = 'SpaceCraft DPChange API';
        intSetting.End_Point__c = 'https://stage-iqapi.homelane.com/assign';
        intSetting.ContentType__c = 'application/json';
        insert intSetting;  
       
         
         Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());

         TEST.STARTTEST();
            
            ld =  [Select id,Customer_ID__c,email,DP_Email__c,Interior_Designer__c  from Lead limit 1];
            ld.Interior_Designer__c  =[Select id from Interior_Designer__c where email__c = 'abc@abc.com' ].id;
            
             System.enqueueJob(new ChangeDPRestAPI(null,ld,'abc@abc.com'));
            
        TEST.STOPTEST();
    }
    public static testMethod void test1() {
        TEST.STARTTEST();
        System.enqueueJob(new ChangeDPRestAPI(null,null,'abc@abc.com'));
        System.enqueueJob(new ChangeDPRestAPI(null,null,null));
        TEST.STOPTEST();
    }
    
    public static testMethod void testError() {
    
        Integration_Setting__c intSetting = new Integration_Setting__c();
        intSetting.Name = 'SpaceCraft DPChange API';
        intSetting.End_Point__c = 'https://stage-iqapi.homelane.com/assign/Error';
        intSetting.ContentType__c = 'application/json';
        insert intSetting;  
        TEST.starttest();
            
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
            
            opportunity Opp1 =  [Select id,Customer_ID__c,Customer_Email__c,Design_Partner_Email__c  from Opportunity limit 1];
            Opp1.Interior_Design_Partner__c  =[Select id from Interior_Designer__c where email__c = 'abc@abc.com' ].id;
            
             //System.enqueueJob(new ChangeDPRestAPI(opp1,null,'abc@abc.com'));
             //update opp1;
            
        TEST.STOPTest();
    }
}