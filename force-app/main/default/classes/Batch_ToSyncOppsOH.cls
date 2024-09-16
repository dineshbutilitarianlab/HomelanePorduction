global class Batch_ToSyncOppsOH implements Database.Batchable<sObject>{

     global void execute(SchedulableContext sc) {
        Batch_ToSyncOppsOH batch = new Batch_ToSyncOppsOH();
        DataBase.executeBatch(batch, 20);
    }

    //batchable context
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String query = 'Select Id, Opportunity_Updated_OH__c  from Opportunity where Opportunity_Updated_OH__c = false order by lastModifiedDate desc';
        return Database.getQueryLocator(query);
    }

    //batchable execute
    global void execute(Database.BatchableContext bc, List<Opportunity> scope) {
     System.debug(scope);
        for(Opportunity op : scope){
            op.Opportunity_Updated_OH__c = true;
        }
        Database.update(scope,false);
        
    }

    //batchable finish
    global void finish(Database.BatchableContext bc) {

    }
}