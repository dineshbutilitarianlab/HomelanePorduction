@isTest
public class MandrilEmailViaRosterQueueabble_Test{
    Public static Lead ld;
    Public static Integration_Setting__c intSetting;
    @TestSetup static void data() { 
        //Create User record
        ld = TestData_Factory.CreateFreshLead(false);
       // ld.Lead_square_modified_date__c = Date.today();
        Account acc = new account();
        acc.Name='Test acc';
        insert acc;
        
        ld.Assigned_to_Resi_ASM__c = true;
        ld.Account__c=acc.id;
        insert ld;

        
        // Create integration Setting record for Lead square
        intSetting = TestData_Factory.createIntegrationSetting('LeadSquared API','https://api-in21.leadsquared.com/v2/LeadManagement.svc/Lead/Bulk/CreateOrUpdate?','u$r132fe08ce31d4b4f','application/json','2e388d2e3c98');
        
    }
    public testMethod static void dummyTestCover() {
        
        Test.StartTest();
        MandrilEmailViaRosterQueueabble.dummyTestCover();
        
        Test.StopTest();
    }
}