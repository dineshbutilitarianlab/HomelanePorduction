@IsTest
public class OfflineAdsLeadImShareBatch_Test {
    Public static Lead ld;
    public static Lead_Class_Scoring__c  lcs;
    
    @TestSetup static void data() { 
    
      lcs = new Lead_Class_Scoring__c();
        lcs.Offline_Ads_Included_Cities__c ='Coimbatore';
        lcs.Offline_Assignment_Enable__c=true;
        RecordType recType1= [SELECT Id FROM RecordType WHERE Name='Offline Ads' limit 1];
        lcs.RecordTypeId =recType1.id;
        insert lcs;    
    
    
    Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.Email__c = 'TestSHowRoomasdUSer@test.com';
        objShowroom1.Threashold__c = 10;
        objShowroom1.Backlogs__c = 2;
        objShowroom1.Daily_Assignment__c = 4;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true;
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.City__c='Coimbatore';
        insert objShowroom1;
    Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
        objShowroom2.Email__c = 'TestSHowRoomasdU2Ser@test.com';
        objShowroom2.Threashold__c = 10;
        objShowroom2.Backlogs__c = 2;
        objShowroom2.Daily_Assignment__c = 4;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true;
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.City__c='Coimbatore';
        insert objShowroom2;
        
        Territory__c objTerr1 = TestData_Factory.createTerritory('Area b',ObjShowroom1.id,'Coimbatore','Cluster A','560103',False);
        objTerr1.Lat_Long__Latitude__s = 25.0936477440000;
        objTerr1.Lat_Long__Longitude__s =  88.7849897840000;
        objTerr1.Cluster_Brand__c ='Homelane';
        //objTerr1.Ironman__c
        Insert objTerr1; 
        
        Territory__c objTerr2 = TestData_Factory.createTerritory('Area b',ObjShowroom2.id,'Coimbatore','Cluster A','560104',False);
        objTerr2.Lat_Long__Latitude__s = 25.0936477440000;
        objTerr2.Lat_Long__Longitude__s =  88.7849897840000;
        objTerr2.Cluster_Brand__c ='Homelane';
        //objTerr1.Ironman__c
        Insert objTerr2; 
        
        
        ld = TestData_Factory.CreateFreshLead(false);
        ld.LeadSource ='Offline Ads';
        ld.Brand__c='HomeLane';
        ld.City='Coimbatore';
        insert ld;
    }
    
    public testMethod static void LeadTriggerDoowupTest1() {
        Test.startTest();
        ld=[select id,City from Lead limit 1];
        OfflineAdsLeadIMShareBatch  batchable = new OfflineAdsLeadIMShareBatch ();
        database.executeBatch(batchable);
        Test.stopTest();
    }
    
    public testMethod static void UnverifiedLeadsAssignmentInitiateBatch(){
        Test.startTest();
        String sch = '0 0 23 * * ?';
       System.schedule('OfflineAdsLeadIMShareBatch',sch, new OfflineAdsLeadIMShareBatch());
        test.stopTest();
    }
}