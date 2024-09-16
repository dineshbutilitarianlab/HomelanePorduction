global class OppPipelineNewCloseDateDelete_Batch implements Database.Batchable<sObject>,Database.AllowsCallouts,Schedulable
{
    Public Set<Id> setOfIds = new Set<Id>();
    
    // Constructor to excecute only set of records in the Batch.
    global OppPipelineNewCloseDateDelete_Batch(Set<Id> setOfIds)
    {
        this.setOfIds = setOfIds;
    }
    
    
    global OppPipelineNewCloseDateDelete_Batch(){}
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        if(setOfIds.isEmpty())
        {    
            return Database.getQueryLocator([select id, Opportunity_Funnel_Status__c,Opportunity_Funnel_Sub_Status__c,Follow_up_time__c,New_Opportunity_Status__c,New_Close_Date__c  
                                             from Opportunity 
                                             where New_Close_Date__c < TODAY  AND Opportunity_Funnel_Status__c = 'Pipeline' ]);
        }
        
        else
        {
            return Database.getQueryLocator([select id, Opportunity_Funnel_Status__c,Opportunity_Funnel_Sub_Status__c,Follow_up_time__c,New_Opportunity_Status__c,New_Close_Date__c   
                                             from Opportunity 
                                             where New_Close_Date__c < TODAY  AND Opportunity_Funnel_Status__c = 'Pipeline' AND
                                             id=: setOfIds]);
        }
        
    }
  
    global void execute(Database.BatchableContext bc,List<Opportunity> scope)
    {
        list<Opportunity> listOfOppsToUpdate  = new list<Opportunity>();
        try
        {
            System.debug('scope :'+scope);
            for(Opportunity objOpportunity : scope)
            {
                objOpportunity.New_Close_Date__c= null;
                objOpportunity.Follow_up_time__c = System.now().addHours(7);
                objOpportunity.Opportunity_Funnel_Status__c='Active';
                System.debug('objOpportunity.New_Close_Date__c :'+objOpportunity.New_Close_Date__c);
                System.debug('objOpportunity.Follow_up_time__c :'+objOpportunity.Follow_up_time__c);
                System.debug('objOpportunity.Opportunity_Funnel_Status__c :'+objOpportunity.Opportunity_Funnel_Status__c);
                listOfOppsToUpdate.add(objOpportunity);
            }
            if(!listOfOppsToUpdate.isempty() && listOfOppsToUpdate != NULL)
            {
                update listOfOppsToUpdate;
            }
        }
        catch(Exception e)
        {
            Logger.log('Exception','OppPipelineNewCloseDateDelete_Batch ','execute',e.getMessage(),e.getStackTraceString(),NULL);
        }
    }
    
    global void finish(Database.BatchableContext bc){}

    
    global void execute(SchedulableContext sc) 
    {
        Database.executeBatch(new OppPipelineNewCloseDateDelete_Batch(),1);
    }
}