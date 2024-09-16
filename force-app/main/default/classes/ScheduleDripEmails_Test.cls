@isTest
public class ScheduleDripEmails_Test {
    @isTest static void test() {
        ScheduleDripEmails s = new ScheduleDripEmails();
        String cron = '0 0 23 * * ?';
        System.schedule('Test', cron, s);
    }
}