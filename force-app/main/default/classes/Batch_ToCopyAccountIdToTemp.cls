global class Batch_ToCopyAccountIdToTemp implements Database.Batchable<sObject>{

     global void execute(SchedulableContext sc) {
        Batch_ToCopyAccountIdToTemp batch = new Batch_ToCopyAccountIdToTemp();
        DataBase.executeBatch(batch, 200);
    }

    //batchable context
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String query = 'Select Id,Customer_ID__c,Temp_Customer_Id__c  FROM Account WHERE Customer_ID__c!=null and Temp_Customer_Id__c=null';
        return Database.getQueryLocator(query);
    }

    //batchable execute
    global void execute(Database.BatchableContext bc, List<Account> scope) {
     
        for(Account acc : scope){
            acc.Temp_Customer_Id__c  = acc.Customer_ID__c;
        }
        Database.update(scope,false);
        
    }

    //batchable finish
    global void finish(Database.BatchableContext bc) {

    }
}