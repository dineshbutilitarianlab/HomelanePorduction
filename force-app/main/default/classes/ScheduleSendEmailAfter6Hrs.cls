global class ScheduleSendEmailAfter6Hrs implements Schedulable {
    global void execute(SchedulableContext SC) {
        SendEmailAfter6Hrs send = new SendEmailAfter6Hrs();
        Database.executebatch(send);
    }
}