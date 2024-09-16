@isTest
public class LeadChangeTrigger_Test {
    Public static User u;
    Public static Lead ld;
    Public static Account acc;
    Public static Opportunity opp;
    @TestSetup static void data() { 
        
        acc = TestData_Factory.createAccount(True);
        
    }
    public testMethod static void LeadChangeTriggerTest1(){
        Test.enableChangeDataCapture();
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Lead_square_modified_date__c = Date.today();
        ld.Assigned_to_Resi_ASM__c = true;
        insert ld;
        
        Test.getEventBus().deliver();
        
        ld.Property_Config__c = '1 BHK';
        ld.LastName ='changed to some name';
        update ld;
        Test.getEventBus().deliver();
        //test.stopTest();
    }
}