@isTest
public class DeleteWebEngageTasksBatch_Test 
{  

    	public testMethod static void testDeleteWebEngageTasksBatch1()
        {
            Test.startTest();
            Database.executeBatch(new DeleteWebEngageTasksBatch());
            test.stopTest();
        }
        
        public testMethod static void DeleteWebEngageTasksBatch()
        {
            Test.startTest();
            
            // Insert test data
            List<WebEngage_Task__c> testRecords = new List<WebEngage_Task__c>();
            for (Integer i = 0; i < 100; i++) 
            {
                testRecords.add(new WebEngage_Task__c(
                    Name = 'Task ' + i,
                    CreatedDate = Date.today().addDays(-91) // Set date to be older than cutoff date
                ));
            }
            insert testRecords;
            
            Set<id> setofIDs = new Set<id>();
            for (WebEngage_Task__c rec: testRecords) 
            {
                setofIDs.add(rec.id);
            }
            Database.executeBatch(new DeleteWebEngageTasksBatch(setOfIds));
            test.stopTest();
        }
        
        @isTest
        static void testScheduledJob() 
        {
            // Schedule the job
            DeleteWebEngageTasksBatch scheduledJob = new DeleteWebEngageTasksBatch();
            String jobId = System.schedule('Test DeleteWebEngageTasksBatch', '0 0 * * * ?', scheduledJob);
    
            // Verify the job was scheduled successfully
            System.assertNotEquals(null, jobId, 'Job was not scheduled successfully');
        }
}