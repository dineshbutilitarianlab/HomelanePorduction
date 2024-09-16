@isTest
public class WTACounterUpdateBatch_Test {
    Public static User u;
    Public static WTA_Assignment__c WTAAssignment;
    @TestSetup static void data() { 
        u = TestData_Factory.inserWTAUser('bhara@test.in', 'testUser', true);
        WTAAssignment = TestData_Factory.inserWTAAssignment(u,'Group A', false);
        WTAAssignment.Daily_Assignment__c = 1;
        WTAAssignment.Weekly_Assignment__c = 1;
        WTAAssignment.Monthly_Assignments__c = 1;
        insert WTAAssignment;
    }
    public testMethod static void testWTACounterUpdateBatch1() {
        Test.StartTest();
        String CRON_EXP = '0 0 12 * * ?';
        WTACounterUpdateBatch b =new WTACounterUpdateBatch();
        system.schedule('Hour run - SAPQuoteService', CRON_EXP, b);
        test.stoptest();  
    }
    public testMethod static void testWTACounterUpdateHandler1() {
        try{
            Test.StartTest();
            String ContextToRUNLogic = 'MONTHLY';
            //ContextToRUNLogic = 'WEEKLY';
            //ContextToRUNLogic = 'DAILY';
            List<WTA_Assignment__c> listOfWTAAssignment = [Select id,IsActive__c,Daily_Assignment__c,Weekly_Assignment__c,Monthly_Assignments__c from WTA_Assignment__c];
            WTACounterUpdateHandler.refreshWTAAssignmentCounter(listOfWTAAssignment,ContextToRUNLogic);
            
            ContextToRUNLogic = 'WEEKLY';
            WTACounterUpdateHandler.refreshWTAAssignmentCounter(listOfWTAAssignment,ContextToRUNLogic);
            
            ContextToRUNLogic = 'WEEKLY';
            WTACounterUpdateHandler.refreshWTAAssignmentCounter(listOfWTAAssignment,ContextToRUNLogic);
            
            WTACounterUpdateHandler.refreshWTAAssignmentCounter(null,null);
            
        }
        Catch(Exception e){
            
        }
        test.stoptest();  
    }
}