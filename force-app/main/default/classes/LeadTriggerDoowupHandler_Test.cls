@IsTest
public class LeadTriggerDoowupHandler_Test {
    Public static Lead ld;
    public static Lead_Class_Scoring__c  lcs;
    
    @TestSetup static void data() { 
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
        objShowroom2.Email__c = 'TestSHowRoomasdUSer@test.com';
        objShowroom2.Threashold__c = 10;
        objShowroom2.Backlogs__c = 2;
        objShowroom2.Daily_Assignment__c = 4;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true;
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        insert objShowroom2;
        
         Showroom_User__c objShowroom3= TestData_Factory.createShowroomUser(false);
        objShowroom3.Email__c = 'doowuptransfer@homelane.com';
        
        insert objShowroom3;
        
        Territory__c objTerr1 = TestData_Factory.createTerritory('Area b',ObjShowroom2.id,'Bengaluru','Cluster A','560103',False);
        objTerr1.Lat_Long__Latitude__s = 25.0936477440000;
        objTerr1.Lat_Long__Longitude__s =  88.7849897840000;
        objTerr1.Cluster_Brand__c ='Doow up';
        //objTerr1.Ironman__c
        Insert objTerr1;  
        
        lcs = new Lead_Class_Scoring__c();
        lcs.Budget_Counter__c = 0;
        lcs.Budget_Counter_Limit__c=25;
        lcs.Counter_Limit__c=0;
        lcs.Property_Counter__c=0;
        lcs.Property_Counter_Limit__c=25;
        lcs.Purpose_Counter__c=0;
        lcs.Purpose_Counter_Limit__c=25;
        lcs.Total_Limit__c=100;
        RecordType recType1= [SELECT Id FROM RecordType WHERE Name='Routing HL Leads' limit 1];
        lcs.RecordTypeId =recType1.id;
        insert lcs;
        
        
    }
    
    public testMethod static void LeadTriggerDoowupTest1() {
        Test.StartTest();
        id recTypeId  =Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Routing HL Leads').getRecordTypeId();
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Property_Config__c ='1 BHK';
        ld.leadSource ='Website';
        ld.PostalCode ='560103';
        ld.Brand__c ='HomeLane';
        ld.Sub_Status__c='Unverified';
        insert ld;
       Showroom_User__c sh = [select id,Email__c from Showroom_User__c where Email__c ='doowuptransfer@homelane.com' limit 1];
       
        list<Territory__c > lst = [Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Is_Active__c,Cluster_Brand__c from Territory__c];
        lcs =[Select id,Budget_Counter__c,Budget_Counter_Limit__c,Purpose_Counter__c,Purpose_Counter_Limit__c,Property_Counter__c,Property_Counter_Limit__c,Counter_Limit__c,	Total_Limit__c
              from Lead_Class_Scoring__c 
              
              limit 1];
        
        Test.StopTest();
        
    } 
    
public testMethod static void LeadTriggerDoowupTest2() {
        Test.StartTest();
        id recTypeId  =Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Routing HL Leads').getRecordTypeId();
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Budget_Range__c ='Upto 1.5L';
        ld.leadSource ='Website';
        ld.PostalCode ='560103';
        ld.Brand__c ='HomeLane';
        ld.Sub_Status__c='Unverified';
        insert ld;
        //Showroom_User__c sh = [select id,Email__c from Showroom_User__c where Email__c ='doowuptransfer@homelane.com' limit 1];
        list<Territory__c > lst = [Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Is_Active__c,Cluster_Brand__c from Territory__c];
        lcs =[Select id,Budget_Counter__c,Budget_Counter_Limit__c,Purpose_Counter__c,Purpose_Counter_Limit__c,Property_Counter__c,Property_Counter_Limit__c,Counter_Limit__c,	Total_Limit__c
              from Lead_Class_Scoring__c 
              
              limit 1];
        
        Test.StopTest();
        
    } 
    public testMethod static void LeadTriggerDoowupTest3() {
        Test.StartTest();
        id recTypeId  =Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Routing HL Leads').getRecordTypeId();
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Property_Status__c ='Rent Out';
        ld.leadSource ='Website';
        ld.PostalCode ='560103';
        ld.Brand__c ='HomeLane';
        ld.Sub_Status__c='Unverified';
        insert ld;

        list<Territory__c > lst = [Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Is_Active__c,Cluster_Brand__c from Territory__c];
        lcs =[Select id,Budget_Counter__c,Budget_Counter_Limit__c,Purpose_Counter__c,Purpose_Counter_Limit__c,Property_Counter__c,Property_Counter_Limit__c,Counter_Limit__c,	Total_Limit__c
              from Lead_Class_Scoring__c 
              
              limit 1];
        
        Test.StopTest();
        
    } 
        
}