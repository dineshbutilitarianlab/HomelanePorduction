global class Batch_ToSyncLeadsOH implements Database.Batchable<sObject>{

     global void execute(SchedulableContext sc) {
        Batch_ToSyncLeadsOH batch = new Batch_ToSyncLeadsOH();
        DataBase.executeBatch(batch, 50);
    }

    //batchable context
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String query = 'Select Id,Lead_Updated_OH__c from Lead where Lead_Updated_OH__c = false and isconverted = false order by lastModifiedDate desc';
        return Database.getQueryLocator(query);
    }

    //batchable execute
    global void execute(Database.BatchableContext bc, List<Lead> scope) {
        System.debug(scope);
        for(Lead l : scope){
            l.Lead_Updated_OH__c  = true;
        }
        Database.update(scope,false);
        
    }

    //batchable finish
    global void finish(Database.BatchableContext bc) {

    }
}