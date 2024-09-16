Public class DeleteQuoteBatch implements Database.Batchable<sObject> ,Schedulable
{
    	Public Integer Batch_LIMIT = Integer.valueOf(System.Label.DeleteQuoteLimit);	
        Public Set<Id> setOfIds = new Set<Id>();
    
    
    	Public DeleteQuoteBatch() 
        {      
            System.debug('DeleteQuoteBatch Constructor No code');
        }
    
        
        Public DeleteQuoteBatch(Set<Id> setOfIds) 
        {
            this.setOfIds = setOfIds;        
            System.debug('DeleteQuoteBatch Constructor Entry');
        }
    
        Public Database.QueryLocator start(Database.BatchableContext bc) 
        {       
            Date cutoffDate = Date.today().addYears(-1);
			System.debug('cutoffDate : ' + cutoffDate);
            
            return Database.getQueryLocator([SELECT Id FROM Quote WHERE IsSyncing = false and X10_Quote__c=false and 
                                     	     X40_Quote__c=false and X50_Quote__c=false AND CreatedDate < :cutoffDate LIMIT :Batch_LIMIT ]);
            
    	}
         
    	Public void execute( Database.BatchableContext bc , List<Quote> QuoteList) 
        {
              System.debug('Total records in List '+QuoteList.size());
              delete QuoteList ;
              Database.emptyRecycleBin(QuoteList);               
        }
        
        Public void finish(Database.BatchableContext bc) 
        {
            system.debug('-------Finish method-----------');
        }
    
        Public void execute(SchedulableContext sc) 
        {
            DeleteQuoteBatch batch = new DeleteQuoteBatch();
        	Database.executeBatch(batch, Batch_LIMIT);
        }
}