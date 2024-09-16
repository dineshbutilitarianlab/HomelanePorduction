@isTest
public class OpportunityTriggerHandler_Test{
    Public static Lead ld;
    Public static Lead ld2;
    Public static Master__c showRoom;
    Public static Account acc;
    Public static Opportunity opp;
     Public static Opportunity opp2;
    Public static Opportunity opp3;
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
         
        Account acc= TestData_Factory.createPersonAccount(false);
        acc.PersonEmail = 'test123@teata.com';
        acc.Phone = '1234567890';
        insert acc;
        //Create Lead Record
        ld2 = TestData_Factory.CreateFreshLead(false);
        ld2.Account__c= acc.id;
        insert ld2;
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Main_Order__c = ld2.Id;
        ld.Account__c= acc.id;
        insert ld;
        //Create Account Record
        
        Opp2 = TestData_Factory.createOpportunity(acc.Id, false);
        opp2.Interior_Design_Partner__c = dummyDp.id;
        Opp2.Appointment_Venue_Square__c = showRoom.id;
        opp2.LeadId__c = ld2.Id;
        insert opp2;
        //Create Opportunity records
        Opp = TestData_Factory.createOpportunity(acc.Id, false);
        opp.Interior_Design_Partner__c = dummyDp.id;
        Opp.Appointment_Venue_Square__c = showRoom.id;
        opp.LeadId__c = ld.Id;
        opp.LeadSource='Facebook Ad';
        opp.StageName='Initial Quote Send';
        insert opp;
        Opp3 = TestData_Factory.createOpportunity(acc.Id, false);
        opp3.Interior_Design_Partner__c = dummyDp.id;
        Opp3.Appointment_Venue_Square__c = showRoom.id;
        opp3.LeadId__c = ld2.Id;
        opp3.LeadSource='Facebook Ad';
        opp3.StageName='Initial Quote Send';
        insert opp3;
        
        
        Channel_Partner__c channelPartner= TestData_Factory.createChannelPartner('test','1234567890','Broker/Channel Partner',false);
        insert channelPartner;
        
        //Create EBP_Showrooms__mdt record
        EBP_Showrooms__mdt EBPShowroom = new EBP_Showrooms__mdt();
        EBPShowroom.Label = '1';
        EBPShowroom.Showroom_Name__c = showRoom.Name;
        EBPShowroom.Showroom_SF_18_Digit_ID__c = showRoom.Id;
        EBPShowroom.Start_Date__c = System.today();
        EBPShowroom.End_Date__c = System.today().addDays(10);
    }
    
      public static testMethod void OpportunityPhoneUpdate(){
         Account objAccount = [Select id,Customer_ID__c  from Account limit 1];
         opportunity Opp1 = TestData_Factory.createOpportunity(objAccount.Id, true);
      }
      
      public static testMethod void OpportunityEmailChange(){
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         opportunity Opp1 =  [Select id,Customer_ID__c,Customer_Email__c  from Opportunity limit 1];
         Opp1.Customer_Email__c  ='abc@tyuiyuhhv.com';
         TEST.STARTTEST();
         Update Opp1;
         TEST.STOPTEST();
      } 
      
      public static testMethod void UpdateEmailForCommunication_1(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        opportunity Opp1 =  [Select id,Customer_ID__c,Customer_Email__c  from Opportunity limit 1];
        Opp1.Customer_Email__c  ='abc@tyuiyuhhv.com';
        TEST.STARTTEST();
        Update Opp1;
        TEST.STOPTEST();
      }   
      
      public static testMethod void UpdateEmailForCommunication_2(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        opportunity Opp1 =  [Select id,Customer_ID__c,Customer_Email__c  from Opportunity limit 1];
        Opp1.Customer_Email__c  ='duplicate_swfgsftgsguja2101@gmail.com';
        Opp1.Update_Email_Communication__c =true;
        TEST.STARTTEST();
        Update Opp1;
        TEST.STOPTEST();
      }
    public static testMethod void updateDPtest(){
        opportunity Opp1 =  [Select id,Customer_ID__c,Customer_Email__c  from Opportunity limit 1];
        dummyDp1 = [Select id from Interior_Designer__c where email__C = 'abc@abc.com' limit 1];
        Opp1.Interior_Design_Partner__c = dummyDp1.id;
        TEST.STARTTEST();
        Update Opp1;
        TEST.STOPTEST();
      }
    public static testMethod void uncheckRequestedCallBackTest1(){
        opportunity Opp1 =  [Select id,Customer_ID__c,Customer_Email__c  from Opportunity limit 1];
        Opp1.Requested_Call_Back__c = True;
        update Opp1;
        TEST.STARTTEST();
        Opp1.Sales_Description__c = 'Changed';
        Update Opp1;
        TEST.STOPTEST();
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
        insert Objsms;
        TEST.STARTTEST();
        update Opp1;
        TEST.STOPTEST();
      }
    public static testMethod void updateEBPApplicableCheckboxTest1(){
        opportunity Opp1 =  [Select id,Customer_ID__c,Customer_Email__c  from Opportunity limit 1];
        TEST.STARTTEST();
        Opp1.Order_Book_Date__c = System.today();
        update Opp1;
        TEST.STOPTEST();
      }
    public static testMethod void updateEBPApplicableCheckboxTest2(){
        opportunity Opp1 =  [Select id,Customer_ID__c,Customer_Email__c  from Opportunity limit 1];
        TEST.STARTTEST();
        Opp1.Order_Book_Date__c = System.today().addDays(20);
        update Opp1;
        TEST.STOPTEST();
      }
    public static testMethod void handleOpportunityRosterEmailsTest1(){
        opportunity Opp1 =  [Select id,Customer_ID__c,Customer_Email__c  from Opportunity limit 1];
        TEST.STARTTEST();
        Opp1.X40_Payment_Rec_Date__c = System.today().addDays(20);
        Channel_Partner__c objchannel = [Select id from Channel_Partner__c limit 1];
        Opp1.Channel_Partner__c = objchannel.id;
        Opp1.LeadSource = 'Broker/Channel Partner';
        update Opp1;
        TEST.STOPTEST();
      }
    public static testMethod void handleOpportunityFacebook(){
         Opp3 =  [Select id,Customer_ID__c,Customer_Email__c,LeadId__c  from Opportunity limit 1];
        TEST.STARTTEST();
        opp3.StageName='Payment Stage A Reached';
        update Opp3;
        TEST.STOPTEST();
      }
    
    public static testMethod void handleOpportunityFacebook2(){
         Opp3 =  [Select id,Customer_ID__c,Customer_Email__c,StageName,LeadSource,LeadId__c  from Opportunity limit 1];
        TEST.STARTTEST();
        Opp3.leadSource ='FB Lead Form';
        opp3.StageName='Payment Stage A Reached';
        update Opp3;
        TEST.STOPTEST();
      }
}