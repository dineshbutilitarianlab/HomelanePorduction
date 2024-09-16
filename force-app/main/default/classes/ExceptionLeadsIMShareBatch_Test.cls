@isTest
public class ExceptionLeadsIMShareBatch_Test {    
    @TestSetup static void data(){
        //Create Showroom Users records
        List<Showroom_User__c> listOfShowroomUsers = new List<Showroom_User__c>();
        Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.City__c = 'Bengaluru';
        objShowroom1.IsActive__c = true;
        objShowroom1.Monthly_Exception_Leads_Assigned__c = 10;
        listOfShowroomUsers.add(ObjShowroom1);
        
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
        objShowroom2.City__c = 'Bengaluru';
        objShowroom2.IsActive__c = true;
        objShowroom2.Monthly_Exception_Leads_Assigned__c = 9;
        listOfShowroomUsers.add(ObjShowroom2);
        
        Showroom_User__c objShowroom3= TestData_Factory.createShowroomUser(false);
        objShowroom3.City__c = 'Kolkata';
        objShowroom3.IsActive__c = true;
        objShowroom3.Monthly_Exception_Leads_Assigned__c = Null;
        listOfShowroomUsers.add(ObjShowroom3);
        
        insert listOfShowroomUsers;
        
        List<Territory__c> listOfTerritories = new List<Territory__c>();
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
        objTerr.Lat_Long__Latitude__s = 20.0936477440000;
        objTerr.Lat_Long__Longitude__s =  89.7849897840000;
        listOfTerritories.add(objTerr);
        
        Territory__c objTerr1 = TestData_Factory.createTerritory('Area b',ObjShowroom2.id,'Bengaluru','Cluster A','123457',False);
        objTerr1.Lat_Long__Latitude__s = 25.0936477440000;
        objTerr1.Lat_Long__Longitude__s =  88.7849897840000;
        listOfTerritories.add(objTerr1);           
        
        Territory__c objTerr2 = TestData_Factory.createTerritory('Area b',ObjShowroom3.id,'Kolkata','Cluster A','123458',False);
        objTerr2.Lat_Long__Latitude__s = 26.0936477440000;
        objTerr2.Lat_Long__Longitude__s =  87.7849897840000;
        listOfTerritories.add(objTerr2); 
        
        insert listOfTerritories;
        Account acc= new account();
        acc.name='test acc';
        insert acc;
        List<Lead> listOfLeads = new List<Lead>();
        lead objLead = new Lead();
        objlead = TestData_Factory.CreateFreshLead(false);
        objlead.Postalcode = '123400';
        objlead.City = 'Bengaluru';
        objLead.Account__c =acc.id;
        listOfLeads.add(objlead);
        
        lead objLead1 = new Lead();
        objlead1 = TestData_Factory.CreateFreshLead(false);
        objlead1.Postalcode = '123401';
        objlead1.City = 'Kolkata';
        objLead1.Account__c =acc.id;
        listOfLeads.add(objlead1); 
        
        insert listOfLeads;
    }
    public testMethod static void ExceptionLeadsIMShareBatchTest1(){
        Test.startTest();
        Database.executeBatch(new ExceptionLeadsIMShareBatch());
        test.stopTest();
    }
    public testMethod static void ExceptionLeadsIMShareBatchTest2(){
        Map<Id,Lead> mapOfLeads = new Map<Id,Lead>([Select id from lead]); 
        Test.startTest();
        Database.executeBatch(new ExceptionLeadsIMShareBatch(mapOfLeads.keySet()));
        test.stopTest();
    }
}