@isTest
public class No_Leads_Alert_Batch_test
{

    Public static Lead ld;
    @TestSetup static void data() 
    { 
        //Create showroom User
         Account acc = new account();
        acc.Name='acctest';
        insert acc;      
        
    }
    
    public testMethod static void No_Leads_Alert_Batch_test1()
    {
        Test.startTest();
        Database.executeBatch(new No_Leads_Alert_Batch());
        test.stopTest();
    }
    
    public testMethod static void No_Leads_Alert_Batch_test2()
    {
        Test.startTest();
        Set<Id> setOfIds = new Set<Id>();
        Database.executeBatch(new No_Leads_Alert_Batch(setOfIds));
        test.stopTest();
    }
    
    @isTest
    static void testScheduledJob() 
    {
        // Schedule the job
        No_Leads_Alert_Batch scheduledJob = new No_Leads_Alert_Batch();
        String jobId = System.schedule('Test Transfer_HL_DeadLead_Batch_test', '0 0 * * * ?', scheduledJob);

        // Verify the job was scheduled successfully
        System.assertNotEquals(null, jobId, 'Job was not scheduled successfully');
    }
}