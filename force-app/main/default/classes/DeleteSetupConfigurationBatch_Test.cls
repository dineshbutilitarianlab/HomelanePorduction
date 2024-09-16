@isTest
public class DeleteSetupConfigurationBatch_Test 
{  

    	public testMethod static void testDeleteSetupConfigurationBatch1()
        {
            Test.startTest();
            Database.executeBatch(new DeleteSetupConfigurationBatch());
            test.stopTest();
        }
        
        public testMethod static void testDeleteSetupConfigurationBatch2()
        {
            Test.startTest();
            
            // Insert test data
            List<Setup_Configuration__c> testRecords = new List<Setup_Configuration__c>();
            for (Integer i = 0; i < 100; i++) 
            {
                testRecords.add(new Setup_Configuration__c(
                    Type_Of_Transfer__c = 'IM Transfer',
                    CreatedDate = Date.today().addDays(-91) // Set date to be older than cutoff date
                ));
            }
            insert testRecords;
            
            Set<id> setofIDs = new Set<id>();
            for (Setup_Configuration__c rec: testRecords) 
            {
                setofIDs.add(rec.id);
            }
            Database.executeBatch(new DeleteSetupConfigurationBatch(setOfIds));
            test.stopTest();
        }
        
        @isTest
        static void testScheduledJob() 
        {
            // Schedule the job
            DeleteSetupConfigurationBatch scheduledJob = new DeleteSetupConfigurationBatch();
            String jobId = System.schedule('Test DeleteSetupConfigurationBatch', '0 0 * * * ?', scheduledJob);
    
            // Verify the job was scheduled successfully
            System.assertNotEquals(null, jobId, 'Job was not scheduled successfully');
        }
}