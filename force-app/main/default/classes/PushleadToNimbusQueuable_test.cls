@istest
public class PushleadToNimbusQueuable_test  {
    Public static User u;
    Public static Lead ld;
    Public static Lead_Square_Mapping__c leadSquareMap;
    Public static Integration_Setting__c intSetting;
    Public static Account ac;
    @TestSetup static void data() { 
        //Create User record
        ac= new account();
        ac.Name ='ac';
        insert ac;
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Nimbus_Status__c='Not a Nimbus Lead';
        ld.Account__c= ac.id;
        
        insert ld;            
    }
   /* public testMethod static void dummyTestCover() {
        
        Test.StartTest();
        PushLeadToNimbusQueuable.dummyTestCover();
        
        Test.StopTest();
    }*/
    
    public testMethod static void testscenario1()
    {
        test.startTest();
        Lead ld =[select id from lead limit 1];
        ld.Nimbus_Status__c='Assigned to Nimbus';
        //ld.id='00QC4000002BdMfMAK';
        ld.Bulk_Upload__c=true;
        ld.Nimbus_Campaign__c ='Nimbus Transfer';
        update ld;
        
        Integration_Setting__c intSetting = new Integration_Setting__c();
        intSetting.Name = 'Cube Dialer';
        intSetting.End_Point__c ='https://home.nimbusbpo.com/QuickCall/UploadLead.php' ;
        
        insert intsetting ;
        String jsonBody ='{"action": "DATAUPLOAD","process": "HomeLane_Nimbus_Process","data": [{"mobile":"8456165145","lead_id":'+ld.id+',"Property_Status__c":"New" "PostalCode":"560103", "contact_name":"divyansh", "email_id":"", "city”:"" }]}';
        PushLeadToNimbusQueuable nim = new PushLeadToNimbusQueuable(jsonBody, ld.id, false);
        

        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        test.stopTest();
    }
    
    public testMethod static void testscenario2()
    {
        test.startTest();
        Lead ld =[select id,Account__c from lead limit 1];
        ld.Nimbus_Status__c='Assigned to Nimbus';
        //ld.id='00QC4000002BdMfMAK';
        ld.Bulk_Upload__c=true;
        ld.Nimbus_Campaign__c ='Globiva Offline PB Transfer';
        update ld;
        
        Integration_Setting__c intSetting = new Integration_Setting__c();
        intSetting.Name = 'Globiva';
        intSetting.End_Point__c ='https://homelane-api.globiva.com/routes/send-lead' ;
        intSetting.ContentType__c = 'application/json';
        intSetting.Authorization__c = 'S8HITymX3IYJF0Tgfr21uJIzrbE14ZPEOMnD';
        
        insert intsetting ;
        String jsonBody ='{ "Campaign_Id": "Globiva Offline PB Transfer", "Full_Name": "Harshit Rastogi", "Email": "xyz@gmail.com", "Customer_Id": "Ben-pP-3001253900", "City": "Bangalore", "Phone_Number": "9999999999", "Lead_Source": "HomeLane", "Lead_Id":'+ld.id+', "Account_Id":'+ld.Account__c+'}';
        PushLeadToNimbusQueuable nim = new PushLeadToNimbusQueuable(jsonBody, ld.id, true);
        

        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        test.stopTest();
    }
    
    public testMethod static void testscenario3()
    {
        test.startTest();
        Lead ld =[select id,Account__c from lead limit 1];
        ld.Nimbus_Status__c='Assigned to Nimbus';
        //ld.id='00QC4000002BdMfMAK';
        ld.Bulk_Upload__c=true;
        ld.Nimbus_Campaign__c ='Globiva Offline PB Transfer';
        update ld;
        
        Integration_Setting__c intSetting = new Integration_Setting__c();
        intSetting.Name = 'Globiva';
        intSetting.End_Point__c ='https://homelane-api.globiva.com/routes/send-lead' ;
                
        insert intsetting ;
        String jsonBody ='{ "Campaign_Id": "Globiva Offline PB Transfer", "Full_Name": "Harshit Rastogi", "Email": "xyz@gmail.com", "Customer_Id": "Ben-pP-3001253900", "City": "Bangalore", "Phone_Number": "9999999999", "Lead_Source": "HomeLane", "Lead_Id":'+ld.id+', "Account_Id":'+ld.Account__c+'}';
        PushLeadToNimbusQueuable nim = new PushLeadToNimbusQueuable(jsonBody, ld.id, true);
        

        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        test.stopTest();
    }

}