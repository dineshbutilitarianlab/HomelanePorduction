global class SetUpConfigDeleteBatch implements Database.Batchable<sObject>,Schedulable { 
    
    Set<String> TypeOfTransfer = new Set<String>{'IM Transfer','Freelancer Transfer'};
   
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'Select Id,Operation_Status__c from Setup_Configuration__c where Operation_Status__c=\'Closed\' AND Type_Of_Transfer__c IN:TypeOfTransfer';
        return Database.getQueryLocator(query);
    }
 
    
    global void execute( Database.BatchableContext bc , List<Setup_Configuration__c> setUpConfigList) {
         try{
            delete  setUpConfigList;
        }catch(Exception e){
            system.debug('-------exp finish-----------'+e.getmessage());
        }
    }
    
    
    global void finish(Database.BatchableContext bc) {
        
    }
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new SetUpConfigDeleteBatch());
    }
}