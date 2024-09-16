global class Batch_ToSyncOppFormulaFieldsToWebHook implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts{

     global void execute(SchedulableContext sc) {
        Batch_ToSyncOppFormulaFieldsToWebHook batch = new Batch_ToSyncOppFormulaFieldsToWebHook();
        DataBase.executeBatch(batch, 1);
    }

    //batchable context
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Query');
        set<String> setOfStatus = new set<String>();
        setOfStatus.add('1.Active');
        setOfStatus.add('2.On-Hold');
        setOfStatus.add('3.Followup');
        setOfStatus.add('4.Overdue');
        setOfStatus.add('5.Pipeline');
        setOfStatus.add('8.AOB');
        Date yesterdayStartDate = System.today()-1;
        Date yesterdayEndDate = System.today();
        String query = 'Select Id, Follow_Up_Time__c ,New_Opportunity_Status__c  FROM Opportunity WHERE Follow_Up_Time__c >=: yesterdayStartDate and Follow_Up_Time__c <: yesterdayEndDate and New_Opportunity_Status__c in : setOfStatus';
        System.debug('Query'+query);
        return Database.getQueryLocator(query);
    }

    //batchable execute
    global void execute(Database.BatchableContext bc, List<Opportunity> scope) {
     
        
        System.debug('Query Records');
        System.debug('Query Records'+scope);
        update scope;
        
    }

    //batchable finish
    global void finish(Database.BatchableContext bc) {

    }
}