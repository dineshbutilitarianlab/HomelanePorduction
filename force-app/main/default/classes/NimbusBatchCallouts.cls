/**
* @File Name          : NimbusBatchCallouts.cls
* @Description        : Batch to query all lead which are in status Assigned to nimbus and fail sending to nimbus and retry sending them again
* @Author             : Soniya Kocher
* @Group              : 
* @Last Modified By   : 
* @Last Modified On   : 20/12/2022, 10:51:43 AM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author      		      Modification
*==============================================================================
* 1.0    28/12/2023, 10:51:43 AM Soniya Kocher  Initial Version
**/
global class NimbusBatchCallouts implements Database.Batchable<sObject>,Database.AllowsCallouts,Schedulable 
{
    public boolean isSuccessfullyPushedToNimbus=false;
    Public Set<Id> setOfIds = new Set<Id>();
    global NimbusBatchCallouts()
    {
        
    }
    
    global NimbusBatchCallouts(Set<Id> setOfIds)
    {
        this.setOfIds = setOfIds;
    }
    
    global void execute(SchedulableContext SC) 
    {
        database.executebatch(new NimbusBatchCallouts(),1);
    }
    
    Set<String> nimbusStatus = new Set<String>{GenericConstants.FAILED_SENDING_TO_NIMBUS,GenericConstants.ASSIGNED_TO_NIMBUS};
        
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
            String query = 'Select Id,PostalCode,Property_Status__c,Phone,City,Email,Nimbus_Status__c,Full_Name__c,Nimbus_Campaign__c,Account__c,Customer_ID__c,LastName,LeadSource from Lead where Nimbus_Status__c IN:nimbusStatus';
            if(!setOfIds.isEmpty())
            {
                query += ' and id=:setOfIds';
            }
            return Database.getQueryLocator(query);
     }
    
    global void execute(Database.BatchableContext BC, List<Lead>leadList) 
    {      
        List<lead> leadUpdateSuccessList = new List<lead>();
        List<lead> leadUpdateFailList = new List<lead>();
        system.debug('leadList '+ leadList);
        system.debug('size'+ leadList.size());
        boolean callNimbus = false;
        String Nimbus_Campaign ;
        Boolean isGlobiva = false;
        
        Set<String> NimbusTransferSet = new Set<string>{GenericConstants.NIMBUS_TRANSFER,GenericConstants.Nimbus_Relanded_Transfer, GenericConstants.Nimbus_Telugu_Transfer};
        if(!leadList.isEmpty())
        {
                String process='';
                
                String jsonBody='';
                for(lead nimbusLead :leadList)
                {  
                    Nimbus_Campaign = nimbusLead.Nimbus_Campaign__c;
                    if(Nimbus_Campaign.contains(GenericConstants.GLOBIVA))
                    {
                           isGlobiva = true;
                    }
                    
                    if(isGlobiva)
                    {
                        jsonBody = LeadTriggerHandler.CreateGlobivaJSON(nimbusLead);
                        callNimbus=true;
                    }
                    else
                    {
                        jsonBody = LeadTriggerHandler.CreateCubeJSON(nimbusLead);
                        jsonBody = '1;CLC@QuickCall;' + jsonBody;                    
                        callNimbus=true;
                    }
                }
                
            	if(callNimbus)
                {
                    PushLeadToNimbusQueuable objLPA = new PushLeadToNimbusQueuable(jsonBody ,leadList[0].id,isGlobiva);
                    ID jobID = System.enqueueJob(objLPA);
                    //          system.debug('jobID '+jobID);
                }
            }
        	else
            {
                system.debug('listis empty');
            }
    }
    
    global void finish(Database.BatchableContext BC){ }
    
}