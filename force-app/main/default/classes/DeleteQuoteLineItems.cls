Public class DeleteQuoteLineItems implements Database.Batchable<sObject> ,Schedulable
{
    	Public Integer Batch_LIMIT = Integer.valueOf(System.Label.DeleteQuoteLimit);	
        Public Set<Id> setOfIds = new Set<Id>();
    
    
    	Public DeleteQuoteLineItems() 
        {      
            System.debug('DeleteQuoteLineItems Constructor No code');
        }
    
        
        Public DeleteQuoteLineItems(Set<Id> setOfIds) 
        {
            this.setOfIds = setOfIds;        
            System.debug('DeleteQuoteLineItems Constructor Entry');
        }
    
        Public Database.QueryLocator start(Database.BatchableContext bc) 
        {       
            Date cutoffDate = Date.today().addYears(-1);
			System.debug('cutoffDate : ' + cutoffDate);
            
            return Database.getQueryLocator([SELECT Id FROM QuoteLineItem WHERE QuoteId IN (SELECT Id FROM Quote WHERE IsSyncing = false and X10_Quote__c=false and 
                                     			X40_Quote__c=false and X50_Quote__c=false) AND CreatedDate < :cutoffDate LIMIT :Batch_LIMIT ]);
            
    	}
         
    	Public void execute( Database.BatchableContext bc , List<QuoteLineItem> QuoteLineItemList) 
        {
              System.debug('Total records in List '+QuoteLineItemList.size());
              delete QuoteLineItemList ;
              Database.emptyRecycleBin(QuoteLineItemList);               
        }
        
        Public void finish(Database.BatchableContext bc) 
        {
            system.debug('-------Finish method-----------');
        }
    
        Public void execute(SchedulableContext sc) 
        {
            DeleteQuoteLineItems batch = new DeleteQuoteLineItems();
        	Database.executeBatch(batch, Batch_LIMIT);
        }
}