@isTest
global class ScheduleSendEmailAfter6Hrs_test {
    public static testMethod void testBatch() {
        Test.startTest();
        ScheduleSendEmailAfter6Hrs sch = new ScheduleSendEmailAfter6Hrs();
        String cron = '0 0 20 * * ?';
        System.schedule('Test',cron,sch);
        Test.stopTest();
    }
}