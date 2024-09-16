@isTest
public class ScheduleN2toN10CalcBatchBatch_Test {
    Public static testMethod void testscheduledBatch(){
    Test.StartTest();
    ScheduleN2toN10CalcBatchBatch sh1 = new ScheduleN2toN10CalcBatchBatch();      
    String sch = '0 0 23 * * ?';
 system.schedule('Test check', sch, sh1);
    Test.stopTest();
    }   
  

}