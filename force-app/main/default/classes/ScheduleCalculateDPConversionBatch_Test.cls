@isTest
public class ScheduleCalculateDPConversionBatch_Test {
    Public static testMethod void testscheduledBatch(){
    Test.StartTest();
    ScheduleCalculateDPConversionBatch sh1 = new ScheduleCalculateDPConversionBatch();      
    String sch = '0 0 23 * * ?';
 system.schedule('Test check', sch, sh1);
    Test.stopTest();
    }   
  

}