@istest
public class NimbusBatchCallouttest 
{
     Public static User u;
     Public static Lead ld;
     Public static Lead_Square_Mapping__c leadSquareMap;
     Public static Integration_Setting__c intSetting;
     @TestSetup static void setupdata() 
     { 
        Account acc= new Account();
        acc.name='testacc';
        insert acc;
        //Create User record
        ld = TestData_Factory.CreateFreshLead(false);
          ld.Nimbus_Status__c='Not a Nimbus Lead';
        ld.Account__c= acc.id;
        
        insert ld;
       
    }
     public testMethod static void testscenario2(){
        //test.startTest();
          Lead ld =[select id from lead limit 1];
              
            
            ld.Nimbus_Status__c='Failed Sending to Nimbus';
            ld.Nimbus_Campaign__c =GenericConstants.Globiva_Digital_North_Transfer;
             ld.Bulk_Upload__c=true;
              update ld;            
        
         
          
        //Lead ld =[select id from lead limit 1];
       // ld.Nimbus_Status__c='Assigned to Nimbus';
        //ld.id='00QC4000002BdMfMAK';
        //ld.Bulk_Upload__c=true;
        //update ld;
        
        //ld.Nimbus_Status__c='Assigned to Nimbus';
        Integration_Setting__c intSetting = new Integration_Setting__c();
        intSetting.Name = 'Nimbus API';
        intSetting.End_Point__c ='http://49.249.134.31/ConVoxCCS/External/external_dialer.php' ;
        
        intSetting.ContentType__c = 'application/json';
        
        intsetting.access_token__c='PROD_MIAGCSqGSIb3DQEHAqCAMIACAQExC';
        insert intsetting ;
        //String jsonBody ='{"action": "DATAUPLOAD","process": "HomeLane_Nimbus_Process","data": [{"mobile":"8456165145","lead_id":'+ld.id+',"Property_Status__c":"New" "PostalCode":"560103", "contact_name":"divyansh", "email_id":"", "city”:"" }]}';
      test.startTest();
      Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
      NimbusBatchCallouts x = new  NimbusBatchCallouts();
       database.executeBatch(x);
    
        

         
        test.stopTest();
    }
    public testMethod static void nimbusBatchTest2(){
        Test.startTest();
        ld = [Select id from Lead limit 1];
        ld.Nimbus_Status__c='Failed Sending to Nimbus';
            ld.Nimbus_Campaign__c ='Nimbus Transfer';
             ld.Bulk_Upload__c=true;
              update ld; 
        Set<Id> setOfIds = new Set<Id>();
        setOfIds.add(ld.id);
        Database.executeBatch(new NimbusBatchCallouts(setOfIds));
        test.stopTest();
    }
}