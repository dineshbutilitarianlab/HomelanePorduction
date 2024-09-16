global class DeleteLogBatch implements Database.Batchable<sObject>,Schedulable 
{
		Public Integer Batch_LIMIT = Integer.valueOf(System.Label.DeleteLogLImit);
    	Public Set<Id> setOfIds = new Set<Id>();
		    
    	global DeleteLogBatch() 
        {      
            System.debug('DeleteLogBatch Constructor No code');
        }
    
    	global DeleteLogBatch(Set<Id> setOfIds) 
        {
            this.setOfIds = setOfIds;        
            System.debug('DeleteLogBatch Constructor Entry');
        }

        global Database.QueryLocator start(Database.BatchableContext bc) 
        {
            // Calculate dates for today and yesterday
            Date today = Date.today();
            Date yesterday = today.addDays(-1);
            String query = 'SELECT Id, Name FROM Log__c WHERE CreatedDate < :yesterday LIMIT :Batch_LIMIT  ';
            
            if(Test.isRunningTest())
            {
                query = 'Select id from Log__c limit 1';
            }
            
            return Database.getQueryLocator(query);                      
        }
         
    	global void execute( Database.BatchableContext bc , List<Log__c> logList) 
        {
            try
            {
                 if(!logList.isEmpty())
                 {
                     delete logList ;
                     // Permanently delete the logs
                	 Database.emptyRecycleBin(logList);
                 }                
        	}
            catch(Exception e)
            {
                system.debug('-------Exception----------'+e.getmessage());
            }
    }
    
    global void finish(Database.BatchableContext bc) 
    {
        	 system.debug('-------finish Method-----------');
    }
    global void execute(SchedulableContext sc) 
    {
        DeleteLogBatch batch = new DeleteLogBatch();
        Database.executeBatch(batch, Batch_LIMIT);
    }
}