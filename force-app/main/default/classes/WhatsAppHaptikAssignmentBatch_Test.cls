@isTest
public class WhatsAppHaptikAssignmentBatch_Test 
{
    Public static Lead ld;
 	Public static Lead ld1;
    Public static Lead ld2;
    
    @TestSetup static void data() 
    { 
        //Create showroom User
        Account acc = new account();
        acc.Name='acctest';
        insert acc;
        
        Account acc1 = new account();
        acc1.Name='acctest1';
        insert acc1;

        ld1 = TestData_Factory.CreateFreshLead(false);
        ld1.Status = 'Fresh Lead';
        ld1.Sub_Status__c = 'WhatsApp Fresh Lead';        
        ld1.Brand__c='HomeLane';
        ld1.Sign_Up_Source__c= 'WhatsAppHaptik';
        ld1.Account__c =acc.id;
        ld1.City = 'Others';
        ld1.PostalCode = '';
        insert ld1;
        
        ld2 = TestData_Factory.CreateFreshLead(false);
        ld2.Status = 'Fresh Lead';
        ld2.Sub_Status__c = 'New';
        ld2.Brand__c='Doowup';
        ld2.Sign_Up_Source__c= 'Single Input Lead';
        ld2.Account__c =acc1.id; 
        ld2.City = 'Others';
        ld2.PostalCode = '';
        insert ld2;
   }
    
    public testMethod static void WhatsAppHaptikAssignmentBatchTest1(){
        Test.startTest();
        Database.executeBatch(new WhatsAppHaptikAssignmentBatch());
        test.stopTest();
    }
    public testMethod static void WhatsAppHaptikAssignmentBatchTest2(){
        Test.startTest();
        ld2 = [Select id,Brand__c,Sign_Up_Source__c,City,PostalCode from Lead where Brand__c='Doowup' limit 1];
        ld2.City = 'Others';
        ld2.PostalCode = '';
		update ld2;
        Set<Id> setOfIds = new Set<Id>();
        setOfIds.add(ld2.id);
        Database.executeBatch(new WhatsAppHaptikAssignmentBatch(setOfIds));
        test.stopTest();
    }
    
    public testMethod static void WhatsAppHaptikAssignmentBatchTest3(){
        Test.startTest();
        ld1 = [Select id,Brand__c,Sign_Up_Source__c,City,PostalCode from Lead where Brand__c='HomeLane' limit 1];
        ld1.City = 'Others';
        ld1.PostalCode = '';
		update ld1;
        Set<Id> setOfIds = new Set<Id>();
        setOfIds.add(ld1.id);
        Database.executeBatch(new WhatsAppHaptikAssignmentBatch(setOfIds));
        test.stopTest();
    }
    public testMethod static void WhatsAppHaptikAssignmentBatchTest(){
        Test.startTest();
        String sch = '0 0 23 * * ?';
        //System.schedule('IronmenDailyAssignmentResetBatch',sch, new IronmenDailyAssignmentResetBatch());
        test.stopTest();
    }
}