@isTest
public class Channel_Partner_Assignment_Batch_test 
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
            ld.Channel_Partner__c = System.label.Any_Channel_Partner;
            ld.CP_Assignment_Date__c = System.now();
            insert ld;
            
        }
        
        public testMethod static void Channel_Partner_Assignment_Batch_test1()
        {
            Test.startTest();
            Database.executeBatch(new Channel_Partner_Assignment_Batch());
            test.stopTest();
        }
        
        public testMethod static void Channel_Partner_Assignment_Batch_test2()
        {
            Test.startTest();
            ld = [Select id,Status,Sub_Status__c,CP_Assignment_Date__c,Channel_Partner__c from Lead limit 1];
            Set<Id> setOfIds = new Set<Id>();
            setOfIds.add(ld.id);
            Database.executeBatch(new Channel_Partner_Assignment_Batch(setOfIds));
            test.stopTest();
        }
        
        @isTest
        static void testScheduledJob() {
            // Schedule the job
            Channel_Partner_Assignment_Batch scheduledJob = new Channel_Partner_Assignment_Batch();
            String jobId = System.schedule('Test Channel_Partner_Assignment_Batch', '0 0 * * * ?', scheduledJob);
    
            // Verify the job was scheduled successfully
            System.assertNotEquals(null, jobId, 'Job was not scheduled successfully');
        }
}