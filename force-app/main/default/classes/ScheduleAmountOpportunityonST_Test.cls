@isTest
public class ScheduleAmountOpportunityonST_Test {
    public testMethod static void setup() {
        Test.StartTest();
        ScheduleAmountOpportunityonST s = new ScheduleAmountOpportunityonST();
        String cron = '0 0 23 * * ?';
        System.schedule('Test', cron, s);
        Test.stopTest();
    }
}