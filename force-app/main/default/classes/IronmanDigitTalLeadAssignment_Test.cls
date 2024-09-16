@isTest
public class IronmanDigitTalLeadAssignment_Test {
    
    public static lead objLead ;
    public static Showroom_User__c objShowroom;
    public static Territory__c objTerr;
    public static Lead_and_IM_class_Mapping__mdt leadIMMap;
  @isTest
  static void testGetIMShowroomUser() {
    // Create a test lead and set its Green_Lead_Class__c to 'Green Lead Gold'
    Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Gold';
        
        insert ObjShowroom1;
     
         objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
        objTerr.Lat_Long__Latitude__s = 20.0936477440000;
        objTerr.Lat_Long__Longitude__s =  89.7849897840000;
        objTerr.Cluster_Brand__c ='Homelane';
        objTerr.Sales_Campaign__c ='Green Channel';
        
        
        Insert objTerr ;  
      
      
      Account ac = new account();
        ac.Name='testacc';
      insert ac;
      objLead = new Lead();
      objlead = TestData_Factory.CreateFreshLead(false);
      objlead.Postalcode = '123457';
      objLead.Brand__c ='Homelane';
      objLead.City='Bengaluru';
      objLead.IM_Assignment_Stage__c ='Lead Creation';
      objLead.Account__c= ac.id;
      objLead.leadSource ='Walk-In';
      
      Insert objlead;

  } // Create a test Showroom_User__c record
    
      public static testMethod void greenLeadAssign1(){
          Test.startTest();
          
           Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Gold';
        
        insert ObjShowroom1;
          
          objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
          objTerr.Lat_Long__Latitude__s = 20.0936477440000;
          objTerr.Lat_Long__Longitude__s =  89.7849897840000;
          objTerr.Cluster_Brand__c ='Homelane';
          objTerr.Sales_Campaign__c ='Green Channel';
          
          
          Insert objTerr ;  
          Id leadSourceScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Gold Plus Score Leads').getRecordTypeId();
          Id leadSignUpSourceScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Gold Score Leads').getRecordTypeId();
          Id leadPostalCodeScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Silver Score Leads').getRecordTypeId();
          Lead_Class_Scoring__c lcs1 = new Lead_Class_Scoring__c();
        lcs1.Lead_Source_List__c ='Walk-In';
        lcs1.RecordTypeId=leadSourceScoreRTID;
        insert lcs1;
          objTerr  = [select id from Territory__c limit 1];
          objShowroom =[select id from Showroom_User__c limit 1];
          
          leadIMMap = new Lead_and_IM_class_Mapping__mdt();
          leadIMMap.IM_Class__c ='Gold';
          LeadImMap.Lead_Green_class__c ='Gold+';
          //insert leadImMap;
          // List<Lead_and_IM_class_Mapping__mdt> mappingList = [SELECT IM_Class__c, Lead_Green_class__c FROM Lead_and_IM_class_Mapping__mdt];
          
          
          Account ac = new account();
          ac.Name='testacc';
          insert ac;
          objLead = new Lead();
          objlead = TestData_Factory.CreateFreshLead(false);
          objlead.Postalcode = '123457';
          objLead.Brand__c ='Homelane';
          objLead.City='Bengaluru';
          objLead.IM_Assignment_Stage__c ='Lead Creation';
          objLead.Account__c= ac.id;
          objLead.leadSource ='Walk-In';
          
      Insert objlead;
          test.stopTest();
          
      }
    public static testMethod void getIMShowroomUsertest(){
        
          Test.startTest();
          
           Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Gold';
        
        insert ObjShowroom1;
         objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
          objTerr.Lat_Long__Latitude__s = 20.0936477440000;
          objTerr.Lat_Long__Longitude__s =  89.7849897840000;
          objTerr.Cluster_Brand__c ='Homelane';
          objTerr.Sales_Campaign__c ='Green Channel';
        
          
        
        Insert objTerr ;  
        Account ac = new account();
        ac.Name='testacc';
        insert ac;
        objLead = new Lead();
        objlead = TestData_Factory.CreateFreshLead(false);
        objlead.Postalcode = '123457';
        objLead.Brand__c ='Homelane';
        objLead.City='Bengaluru';
        objLead.IM_Assignment_Stage__c ='Lead Creation';
        objLead.Account__c= ac.id;
        objLead.leadSource ='Walk-In';
        
        Insert objlead;
        objLead.Lead_Score_for_Assignment__c =8;
        update objlead;
        
        IronmanDigitalLeadAssignment.getIMShowroomUser('Cluster A',objLead,true);
        test.stopTest();
    }
  public testMethod static void dummyTestCover() {
        
        Test.StartTest();
     IronmanDigitalLeadAssignment.dummyTestCover();
        
        Test.StopTest();
    }
}