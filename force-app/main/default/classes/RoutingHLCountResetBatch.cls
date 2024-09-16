global class RoutingHLCountResetBatch  implements Database.Batchable<sObject>,Schedulable
{
    Public Set<Id> setOfIds = new Set<Id>();
    Id recTypeId = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Routing HL Leads').getRecordTypeId();
    // Constructor to excecute only set of records in the Batch.
    
    global RoutingHLCountResetBatch(){}
    
    global void execute(SchedulableContext SC) 
    {
        database.executebatch(new RoutingHLCountResetBatch(),1);
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String queryString = 'Select id,Budget_Counter__c,Budget_Counter_Limit__c, Purpose_Counter__c, Purpose_Counter_Limit__c,Property_Counter__c,Property_Counter_Limit__c,Red_Pincode_Counter__c,Red_Pincode_Counter_Limit__c,Counter_Limit__c,Total_Limit__c from Lead_Class_Scoring__c where RecordTypeId =:recTypeId ';
          
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead_Class_Scoring__c> listOfLeadClass) 
    { 
        List<Lead_Class_Scoring__c > updateCounter = new List<Lead_Class_Scoring__c >();
        try
        {
            if(!listOfLeadClass.isEmpty())
            {                
                for(Lead_Class_Scoring__c ldClass : listOfLeadClass)
                {                    
                    ldClass.Budget_Counter__c = 0;
                    ldClass.Purpose_Counter__c =0;                    
                    ldClass.Property_Counter__c=0;
                    ldClass.Red_Pincode_Counter__c=0;
                    
                    updateCounter.add(ldClass);                    
                }
                
                if(!updateCounter.isEmpty())
                {
                    update updateCounter;
                }
            }
        }
        catch(Exception e)
        {
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            Logger.log('Exception','RoutingHLCountResetBatch Class','execute method',e.getMessage(),e.getStackTraceString(),null);
        }
    }   
    
    global void finish(Database.BatchableContext bc)
    { 
        System.debug('finish method');   
    }

}