@isTest
public class GreenChannelLeadAssignmentBatchTest {
 Public static Lead ld;
    @TestSetup static void data() { 
        //Create showroom User
         Account acc = new account();
        acc.Name='acctest';
        insert acc;

        ld = TestData_Factory.CreateFreshLead(false);
        ld.Status = 'Fresh Lead';
        ld.Sub_Status__c = 'Unverified';
        ld.Account__c =acc.id;
        insert ld;
        
    }
    public testMethod static void GreenChannelLeadAssignmentBatchTest1(){
        Test.startTest();
        Database.executeBatch(new GreenChannelLeadAssignmentInitiateBatch());
        test.stopTest();
    }
    public testMethod static void GreenChannelLeadAssignmentBatchTest2(){
        Test.startTest();
        ld = [Select id from Lead limit 1];
        Set<Id> setOfIds = new Set<Id>();
        setOfIds.add(ld.id);
        Database.executeBatch(new GreenChannelLeadAssignmentInitiateBatch(setOfIds));
        test.stopTest();
    }
    public testMethod static void GreenChannelLeadAssignmentBatchTest(){
        Test.startTest();
        String sch = '0 0 23 * * ?';
        //System.schedule('IronmenDailyAssignmentResetBatch',sch, new IronmenDailyAssignmentResetBatch());
        test.stopTest();
    }
}