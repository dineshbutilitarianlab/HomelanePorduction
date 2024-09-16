global class WebEngageTaskDelete_Batch  implements Database.Batchable<sObject>,Schedulable {
  global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Name FROM WebEngage_Task__c where Status__c=\'Closed\'';
        return Database.getQueryLocator(query);
    }
     global void execute( Database.BatchableContext bc , List<WebEngage_Task__c> webengageList) {
         try{
             if(!webengageList.isEmpty()){
                 delete webengageList ;
             }
            
        }catch(Exception e){
            system.debug('-------exp finish-----------'+e.getmessage());
            Logger.log('Exception','WebEngageTaskDelete_Batch Class','Execute Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new WebEngageTaskDelete_Batch ());
    }
 
}