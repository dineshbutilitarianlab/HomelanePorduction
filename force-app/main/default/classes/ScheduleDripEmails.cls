global class ScheduleDripEmails implements Schedulable{
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new DripEmailsSend(),50);
    }
}