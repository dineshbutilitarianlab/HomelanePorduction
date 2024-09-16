@isTest
public class Transfer_HL_DeadLead_Batch_test 
{

    Public static Lead ld;
    @TestSetup static void data() 
    { 
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
    
    public testMethod static void Transfer_HL_DeadLead_Batch_test1()
    {
        Test.startTest();
        Database.executeBatch(new Transfer_HL_DeadLead_Batch());
        test.stopTest();
    }
    
    public testMethod static void Transfer_HL_DeadLead_Batch_test2()
    {
        Test.startTest();
        ld = [Select id from Lead limit 1];
        Set<Id> setOfIds = new Set<Id>();
        setOfIds.add(ld.id);
        Database.executeBatch(new Transfer_HL_DeadLead_Batch(setOfIds));
        test.stopTest();
    }
    
    @isTest
    static void testScheduledJob() 
    {
        // Schedule the job
        Transfer_HL_DeadLead_Batch scheduledJob = new Transfer_HL_DeadLead_Batch();
        String jobId = System.schedule('Test Transfer_HL_DeadLead_Batch_test', '0 0 * * * ?', scheduledJob);

        // Verify the job was scheduled successfully
        System.assertNotEquals(null, jobId, 'Job was not scheduled successfully');
    }
}