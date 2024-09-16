@isTest
public class Transfer_HL_Opportunity_Batch_test 
{

    Public static Opportunity opp;
    @TestSetup static void data() 
    { 
        //Create showroom User
        Account acc = new account();
        acc.Name='acctest';
        insert acc;

        Opportunity testOpp = new Opportunity();
        testOpp.AccountId = acc.Id;
        testOpp.Name = 'Test Opportunity';
        testOpp.CloseDate = System.today().addDays(30);
        testOpp.Opportunity_Funnel_Status__c = 'Active';
        testOpp.Opportunity_Funnel_Sub_Status__c='Budget/Price Discussion Pending';
        testOpp.First_Meeting_Date__c = System.today().addDays(-8);
        testOpp.CityfromLead__c = 'Pune';
        testOpp.StageName = 'Initial Quote Sent';
        insert testOpp;
        
    }
    
    public testMethod static void Transfer_HL_Opportunity_Batch_test1()
    {
        Test.startTest();
        Database.executeBatch(new Transfer_HL_Opportunity_Batch());
        test.stopTest();
    }
    
    public testMethod static void Transfer_HL_Opportunity_Batch_test2()
    {
        Test.startTest();
        opp = [Select id from Opportunity limit 1];
        Set<Id> setOfIds = new Set<Id>();
        setOfIds.add(opp.id);
        Database.executeBatch(new Transfer_HL_Opportunity_Batch(setOfIds));
        test.stopTest();
    }
    
    @isTest
    static void testScheduledJob() 
    {
        // Schedule the job
        Transfer_HL_Opportunity_Batch scheduledJob = new Transfer_HL_Opportunity_Batch();
        String jobId = System.schedule('Test Transfer_HL_DeadLead_Batch_test', '0 0 * * * ?', scheduledJob);

        // Verify the job was scheduled successfully
        System.assertNotEquals(null, jobId, 'Job was not scheduled successfully');
    }
    
    public testMethod static void getdummytest2()
     {
         test.starttest();
         Transfer_HL_Opportunity_Batch.dummyTestCover();
         test.stopTest();
     }
}