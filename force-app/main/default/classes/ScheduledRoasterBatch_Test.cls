@isTest
public class ScheduledRoasterBatch_Test {
    Public static testMethod void testscheduledRoasterBatch(){
    Test.StartTest();
    ScheduledRoasterBatch sh1 = new ScheduledRoasterBatch();      
    String sch = '0 0 23 * * ?';
    system.schedule('Test check', sch, sh1);
    Test.stopTest();
    }   
        
}