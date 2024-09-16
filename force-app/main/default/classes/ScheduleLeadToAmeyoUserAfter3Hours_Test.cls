@isTest
public class ScheduleLeadToAmeyoUserAfter3Hours_Test {
    Public static testMethod void testscheduledBatch(){
    Test.StartTest();
    ScheduleLeadToAmeyoUserAfter3Hours  sh1 = new ScheduleLeadToAmeyoUserAfter3Hours();      
    String sch = '0 0 23 * * ?';
 system.schedule('Test check', sch, sh1);
    Test.stopTest();
    }   
  

}