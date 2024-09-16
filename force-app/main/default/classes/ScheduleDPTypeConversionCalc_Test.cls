@isTest
public class ScheduleDPTypeConversionCalc_Test {
    Public static testMethod void testscheduledBatch(){
    Test.StartTest();
    ScheduleDPTypeConversionCalc sh1 = new ScheduleDPTypeConversionCalc();      
    String sch = '0 0 23 * * ?';
 system.schedule('Test check', sch, sh1);
    Test.stopTest();
    }   
  

}