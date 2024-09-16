@isTest
public class ScheduledAssignmentRemovalBatch_Test {
    Public static testMethod void testscheduledRoasterBatch(){
    Test.StartTest();
    ScheduledAssignmentRemovalBatch  sh1 = new ScheduledAssignmentRemovalBatch ();      
    String sch = '0 0 23 * * ?';
    system.schedule('Test check', sch, sh1);
    Test.stopTest();
    }   
        
}