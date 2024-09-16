public class DeleteSetupConfigurationBatch implements Database.Batchable<SObject>, Schedulable 
{    
    Public Integer Batch_LIMIT = Integer.valueOf(System.Label.DeleteSetupLImit);
    Public Set<Id> setOfIds = new Set<Id>();
    
    public DeleteSetupConfigurationBatch() 
    {      
        System.debug('DeleteSetupConfigurationBatch Constructor No code');
    }

    
    public DeleteSetupConfigurationBatch(Set<Id> setOfIds) 
    {
        this.setOfIds = setOfIds;        
        System.debug('DeleteSetupConfigurationBatch Constructor Entry');
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) 
    {
        Date cutoffDate = Date.today().addDays(-90);
        System.debug('cutoffDate : '+cutoffDate);
        
        return Database.getQueryLocator([
            SELECT Id 
            FROM Setup_Configuration__c 
            WHERE CreatedDate < :cutoffDate LIMIT :Batch_LIMIT  
        ]);
    }
    
    public void execute(Database.BatchableContext BC, List<Setup_Configuration__c> scope) 
    {
        System.debug('Total records in List '+scope.size());
        delete scope;
        Database.emptyRecycleBin(scope);
    }
    
    public void finish(Database.BatchableContext BC) 
    {
        System.debug('Finish Method');
    }
    
    public void execute(SchedulableContext SC) 
    {        
        DeleteSetupConfigurationBatch batch = new DeleteSetupConfigurationBatch();
        Database.executeBatch(batch, Batch_LIMIT);
    }
}