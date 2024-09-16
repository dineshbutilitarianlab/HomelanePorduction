global class ScheduleAmountOpportunityonST implements Schedulable {
    global void execute(SchedulableContext SC) {
        AmountOpportunityonST a = new AmountOpportunityonST();
        if(!Test.isRunningTest())
        Database.executeBatch(a,100);
        else
        Database.executeBatch(a);
    }
}