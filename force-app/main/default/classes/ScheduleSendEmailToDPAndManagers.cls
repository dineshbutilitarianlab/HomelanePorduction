global class ScheduleSendEmailToDPAndManagers implements Schedulable {
    global void execute(SchedulableContext SC) {
        SendEmailToDPAndManagers sm = new SendEmailToDPAndManagers();
        Database.executeBatch(sm);
    }
}