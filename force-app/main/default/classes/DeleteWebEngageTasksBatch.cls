public class DeleteWebEngageTasksBatch implements Database.Batchable<SObject>, Schedulable 
{    
    Public Integer Batch_LIMIT = Integer.valueOf(System.Label.DeleteTaskLImit);
    Public Set<Id> setOfIds = new Set<Id>();
    
    public DeleteWebEngageTasksBatch() 
    {      
        System.debug('DeleteWebEngageTasksBatch Constructor No code');
    }

    
    public DeleteWebEngageTasksBatch(Set<Id> setOfIds) 
    {
        this.setOfIds = setOfIds;        
        System.debug('DeleteWebEngageTasksBatch Constructor Entry');
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) 
    {
        Date cutoffDate = Date.today().addDays(-15);
        System.debug('cutoffDate : '+cutoffDate);
        
        return Database.getQueryLocator([
            SELECT Id 
            FROM WebEngage_Task__c 
            WHERE Status__c ='Closed' AND CreatedDate < :cutoffDate LIMIT :Batch_LIMIT  
        ]);
    }
    
    public void execute(Database.BatchableContext BC, List<WebEngage_Task__c> taskList) 
    {
        System.debug('Total records in List '+taskList.size());
        delete taskList;
        Database.emptyRecycleBin(taskList);
    }
    
    public void finish(Database.BatchableContext BC) 
    {
        System.debug('Finish Method');
    }
    
    public void execute(SchedulableContext SC) 
    {        
        DeleteWebEngageTasksBatch batch = new DeleteWebEngageTasksBatch();
        Database.executeBatch(batch, Batch_LIMIT);
    }
}