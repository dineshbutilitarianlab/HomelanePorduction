global class ScheduleFirstMeetingFeedbackEmail implements Schedulable {
    global void execute(SchedulableContext SC) {
        FirstMeetingFeedbackEmail fmfe = new FirstMeetingFeedbackEmail();
        database.executeBatch(fmfe);
    }
}