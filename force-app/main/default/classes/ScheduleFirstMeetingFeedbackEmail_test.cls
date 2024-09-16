@isTest
public class ScheduleFirstMeetingFeedbackEmail_test {
    public static testmethod void test() {
    Test.startTest();
    ScheduleFirstMeetingFeedbackEmail sfmfe = new ScheduleFirstMeetingFeedbackEmail();
    String cron = '0 0 23 * * ?';
    System.schedule('Test First Meeting',cron,sfmfe);
    Test.stopTest();
    }
}