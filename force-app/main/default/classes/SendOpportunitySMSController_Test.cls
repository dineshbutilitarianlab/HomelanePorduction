@isTest
public class SendOpportunitySMSController_Test{
    Public static Lead ld;
    Public static Master__c showRoom;
    Public static Account acc;
    Public static Opportunity opp;
    Public static Interior_Designer__c dummyDp1;
    @TestSetup static void data() {
        Interior_Designer__c dummyDp = TestData_Factory.createInteriorDesigner(false);
        insert dummyDp;
        
        Interior_Designer__c dummyDp1 = TestData_Factory.createInteriorDesigner(false);
        dummyDp1.email__C = 'abc@abc.com';
        insert dummyDp1;
        
        //Create a Active ShowRoom Master record
        showRoom = TestData_Factory.CreateShowRoom(False);
        showRoom.Type__c ='Showroom';
        insert showRoom;
        
        //Create Lead Record
        ld = TestData_Factory.CreateFreshLead(true);
        
        //Create Account Record
        Account acc= TestData_Factory.createPersonAccount(false);
        acc.PersonEmail = 'test123@teata.com';
        acc.Phone = '1234567890';
        insert acc;
        
        //Create Opportunity records
        Opp = TestData_Factory.createOpportunity(acc.Id, false);
        opp.Interior_Design_Partner__c = dummyDp.id;
        insert opp;
        
        Channel_Partner__c channelPartner= TestData_Factory.createChannelPartner('test','1234567890','Broker/Channel Partner',false);
        channelPartner.RecordTypeid = [select Id from RecordType where (Name='Ambassador') and (SobjectType='Channel_Partner__c')].Id;
        insert channelPartner;
        
    }
    
    
    public static testMethod void sendOpportunityRelatedSMS(){
    
        opportunity Opp1 =  [Select id,Customer_ID__c,Customer_Email__c  from Opportunity limit 1];
        Channel_Partner__c objchannel = [Select id from Channel_Partner__c limit 1];
        Opp1.Requested_Call_Back__c = True;
        Opp1.Channel_Partner__c = objchannel.id;
        Opp1.Amount_Collected__c = 500000.00;
        
        SMS_Template__c Objsms = new SMS_Template__c(Name= 'Order Close' ,SMS_Content__c = 'Hello! The customer you referred {Full_Name}, has successfully placed an order with HomeLane for home interiors. Thank you for your referral. Have a great day!');
        insert Objsms;
        TEST.STARTTEST();
        update Opp1;
        TEST.STOPTEST();
      }  
      
    public static testMethod void sendOpportunityRelatedSMS1(){
    
        opportunity Opp1 =  [Select id,Customer_ID__c,Customer_Email__c  from Opportunity limit 1];
        Channel_Partner__c objchannel = [Select id from Channel_Partner__c limit 1];
        Opp1.Requested_Call_Back__c = True;
        Opp1.Channel_Partner__c = objchannel.id;
        Opp1.Amount_Collected__c = 500000.00;
        Opp1.Sales_Description__c = 'test';
        
        SMS_Template__c Objsms = new SMS_Template__c(Name= 'Order Close' ,SMS_Content__c = 'Hello! The customer you referred {Full_Name}, has successfully placed an order with HomeLane for home interiors. Thank you for your referral. Have a great day!');
        Objsms.Template_ID__c = 'someTesttemplateID';
        insert Objsms;
        Integration_Setting__c intSetting = TestData_Factory.createIntegrationSetting('MSG91_API','http://api.msg91.com/api/v2/sendsms?dev_mode=1','u$r132fe08ce31d4b4f','application/json','KK1974dd56933b4c69602c063d589e19ab');
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        TEST.STARTTEST();
        update Opp1;
        TEST.STOPTEST();
      }                 
}