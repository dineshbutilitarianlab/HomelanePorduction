@isTest
public class LeadOppPushToFBCAPI_Test{
    Public static Lead ld;
    Public static Integration_Setting__c intSetting;
    Public static Master__c showRoom;
    Public static Master__c m;
   
    @TestSetup static void data() { 
        
        showRoom = TestData_Factory.CreateShowRoom(False);
        showRoom.Type__c ='Showroom';
        insert showRoom;
        
        Master__c m = new Master__c();
        m.isActive__c = true;
        m.Type__c = 'Property';
        m.Name = 'Test Property';
        insert m;
        //Create User record
        ld = TestData_Factory.CreateFreshLead(false);
       //ld.Order_not_registered__c =true;
        //ld.Bulk_Upload__c= true;
        ld.LeadSource='FaceBook Ad';
        ld.Appointment_Venue_Square__c =showRoom.id;
        ld.Budget_Range__c ='6L - 8L';
        ld.Crockery_Unit__c='Yes';
        ld.Entertainment_Unit__c='Yes';
        ld.Kitchen__c='Yes';
        ld.Pooja__c='Yes';
        ld.Foyer_Shoe_Rack__c='Yes';
        ld.Appointment_Time__c =system.today()+15;
         ld.Interior_Start_Date__c = system.today();
       // ld.Square_Showroom_Manager__c ='0059D000001qF4TQAU';
        ld.Study_Table_Book_Shelf__c='Yes';
        ld.Possession_Date__c = system.today()+10;
        ld.Property_Type__c='Apartment';
        ld.Property_Config__c='2 BHK';
        ld.Property__c=m.id;
        ld.PostalCode='560068';
         ld.Primary_Language__c='Hindi';
        ld.Secondary_Language__c='English';
         ld.Appointment_Type__c ='Virtual Meeting';
            
        insert ld;

         
        // Create integration Setting record for Lead square
        //intSetting = TestData_Factory.createIntegrationSetting('Facebook CAPI API','https://graph.facebook.com/v15.0/1474943816139936/events',null,'application/json',null);
        
        
    }
    public   testMethod static void PushToCAPITest1(){
        ld =[Select id from lead];
        ld.Status ='Appointment Fixed';
        ld.Sub_Status__c ='Appointment Fixed';
        update ld;
        Test.startTest(); 
        Integration_Setting__c intSet= new Integration_Setting__c();
        intSet.Name = 'Facebook CAPI';
        intSet.End_Point__c = 'https://graph.facebook.com/v15.0/1474943816139936/events?access_token=EAAE87nqgdSEBAMpvhZAP8X8dnqzHhswEYXLLKeopzlFZCIo42prYFDHPgofpTxEPlEDxG6uyW8ZCNtJgxRKDaJIQc5DLKqjSfN5sZAshhZCVXfpOdrL1Fup5GRj5ZCx3G2oAg7GrguAoiWHefdr1QIwBZBiOJ4n6J0VyMBbjtpdFI6df5NImdiT';
        intSet.ContentType__c='application/json';
        
        insert intSet;
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
    }
    public   testMethod static void PushToCAPITest2(){
        ld =[Select id from lead];
        ld.Status ='Appointment Fixed';
        ld.Sub_Status__c ='Appointment Fixed';
        update ld;
        Test.startTest(); 
        Integration_Setting__c intSet= new Integration_Setting__c();
        intSet.Name = 'Facebook CAPI API';
        intSet.End_Point__c = 'https://graph.facebook.com/v15.0/1474943816139936/events?access_token=EAAE87nqgdSEBAMpvhZAP8X8dnqzHhswEYXLLKeopzlFZCIo42prYFDHPgofpTxEPlEDxG6uyW8ZCNtJgxRKDaJIQc5DLKqjSfN5sZAshhZCVXfpOdrL1Fup5GRj5ZCx3G2oAg7GrguAoiWHefdr1QIwBZBiOJ4n6J0VyMBbjtpdFI6df5NImdiT';
        intSet.ContentType__c='application/json';
        
        insert intSet;
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
    }
    public   testMethod static void PushToCAPITest3(){
       
        Test.startTest(); 
        Integration_Setting__c intSet= new Integration_Setting__c();
        intSet.Name = 'Facebook CAPI';
        intSet.End_Point__c = 'https://graph.facebook.com/v15.0/1474943816139936/events?access_token=EAAE87nqgdSEBAMpvhZAP8X8dnqzHhswEYXLLKeopzlFZCIo42prYFDHPgofpTxEPlEDxG6uyW8ZCNtJgxRKDaJIQc5DLKqjSfN5sZAshhZCVXfpOdrL1Fup5GRj5ZCx3G2oAg7GrguAoiWHefdr1QIwBZBiOJ4n6J0VyMBbjtpdFI6df5NImdiT';
        intSet.ContentType__c='application/json';
        insert intSet;
        
        List<String> jsonList = new List<String>{'"data" : [ { "event_name" : "Appointment Fixed", "event_time" : 1681729694, "action_source" : "system_generated","user_data" : {"em" : "c746156e98ed7aae9de48669f41fba4e8ac635e770d2eef872e7cde62aaad822","ph" : "ad962fa99dc7af64cbabcb3e84cb83b71e56f03c7089078ab9bfe80e7e5f8b45"}}]'};
        LeadOppPushToFBCAPI updater = new LeadOppPushToFBCAPI(jsonList);
        System.enqueueJob(updater);
        test.stopTest();
        
        //insert intSet;
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
    }
}