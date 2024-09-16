global class DeleteCustomerProfilingsession  implements Database.Batchable<sObject>{
global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Name FROM Customer_Profiling_Session__c ';
        return Database.getQueryLocator(query);
    }
     global void execute( Database.BatchableContext bc , List<Customer_Profiling_Session__c> logList) {
         try{
             if(!logList.isEmpty()){
                 delete logList ;
             }
            
        }catch(Exception e){
            system.debug('-------exp finish-----------'+e.getmessage());
           // Logger.log('Exception','WebEngageTaskDelete_Batch Class','Execute Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }
}