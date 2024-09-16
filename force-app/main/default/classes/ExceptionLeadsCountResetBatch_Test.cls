@isTest
public class ExceptionLeadsCountResetBatch_Test {    
    @TestSetup static void data(){
        //Create Showroom Users records
        List<Showroom_User__c> listOfShowroomUsers = new List<Showroom_User__c>();
        Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.City__c = 'Bengaluru';
        objShowroom1.IsActive__c = true;
        objShowroom1.Monthly_Exception_Leads_Assigned__c = 10;
        listOfShowroomUsers.add(ObjShowroom1);
        
        insert listOfShowroomUsers;
        System.debug('listOfShowroomUsers: '+listOfShowroomUsers);
    }
    public testMethod static void ExceptionLeadsCountResetBatchTest1(){
        Test.startTest();
        Database.executeBatch(new ExceptionLeadsCountResetBatch());
        test.stopTest();
    }
    public testMethod static void ExceptionLeadsCountResetBatchTest2(){
        Map<Id,Showroom_User__c> mapOfShowroomUsers = new Map<Id,Showroom_User__c>([Select id from Showroom_User__c]); 
        Test.startTest();
        Database.executeBatch(new ExceptionLeadsCountResetBatch(mapOfShowroomUsers.keySet()));
        test.stopTest();
    }
}