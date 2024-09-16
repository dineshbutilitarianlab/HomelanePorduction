@isTest
public class DeleteLog_Test {
    
    
    @TestSetup static void data() 
    {
        log__c lg = new log__c();
        lg.Name ='webEngageBatchHandler class';
        insert lg;            
    }
    
    public testMethod static void DeleteLogTest1()
    {        
        Test.startTest();               
        DeleteLogBatch webTask = new DeleteLogBatch();
        database.executeBatch(webTask);
        Test.stopTest();
    }
    
    public testMethod static void DeleteLogTest2()
    {
            Test.startTest();
            // Schedule the job
            DeleteLogBatch scheduledJob = new DeleteLogBatch();
            String jobId = System.schedule('Test DeleteLogBatch', '0 0 * * * ?', scheduledJob);
    
            // Verify the job was scheduled successfully
            System.assertNotEquals(null, jobId, 'Job was not scheduled successfully');
            test.stopTest();
    }
    
    public testMethod static void DeleteLogTest3()
    {
            Test.startTest();
            Database.executeBatch(new DeleteLogBatch());
            test.stopTest();
    }
    
    public testMethod static void DeleteLogTest4()
    {
            Test.startTest();
        	list<log__c> listofLogs = [select id from log__c limit 1];
        	Set<id> setofIDs = new Set<id>();
        	setofIDs.add(listofLogs[0].id);
            Database.executeBatch(new DeleteLogBatch(setofIDs));
            test.stopTest();
    }
}