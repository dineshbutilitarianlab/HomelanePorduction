global class WhatsAppHaptikAssignmentBatch  implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable
{
	Public Set<Id> setOfIds = new Set<Id>();
    // Constructor to excecute only set of records in the Batch which runs everyday.
    global WhatsAppHaptikAssignmentBatch(Set<Id> setOfIds)
    {
        this.setOfIds = setOfIds;
    }
    global WhatsAppHaptikAssignmentBatch()
    {
        
    }
    global void execute(SchedulableContext SC) 
    {
        database.executebatch(new WhatsAppHaptikAssignmentBatch(),1);
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
       	DateTime WhatsAppHaptikBeforeTime = System.now().addMinutes(-(Integer.valueOf(Label.WhatsAppHeptikBefore)));
        
        system.debug('now'+system.now());
        DateTime WhatsAppHaptikAfterTime = System.now().addMinutes(-(Integer.valueOf(Label.WhatsAppHaptikAfter)));
        String queryString = UtilityClass.getQueryString('Lead');
        
        queryString += ' From Lead where (Sign_Up_Source__c =\'WhatsAppHaptik\' or Sign_Up_Source__c =\'Single Input Lead\')'
        			+' and (Sub_Status__c =\'WhatsApp Fresh Lead\' or Sub_Status__c =\'New\')' 
                    +' and assigned_To_resi_Asm__c = False and Assigned_to_Central_Team__c = False and Assigned_To_Inside_Sales_Agent__c = False ' 
                    +' and Pushed_To_Ozonetel__c =false and createdDate <= :WhatsAppHaptikBeforeTime and CreatedDate >= :WhatsAppHaptikAfterTime ';
       
        if(!setOfIds.isEmpty())
        {
            queryString += ' and id=:setOfIds';
        }         
    
        if(Test.isRunningTest())
        {
            queryString = 'Select id,Brand__c,Sign_Up_Source__c,City,PostalCode from Lead limit 1';
        }
        return Database.getQueryLocator(queryString);
    }

    global void execute(Database.BatchableContext bc, List<Lead> listOfLeads) 
    { 
        System.debug('listOfLeads' +listOfLeads);
        system.debug('listOfLeads size'+ listOfLeads.size());
        try
        {
            
            if(!listOfLeads.isEmpty())
            {
                for(Lead leadrec : listOfLeads)
                {
                    if(leadrec.Sign_Up_Source__c == GenericConstants.Sign_Up_WhatsApp_Haptik)
                    {
                            if(leadrec.City == 'Others'|| leadrec.City == 'Other' || String.isBlank(leadrec.postalcode))
                            {
                                leadrec.Assignment_Initiate_Stage__c = GenericConstants.WhatsApp_Haptik_InsideSales_Assignment;
                                
                            }
                            else
                            { 
                                leadrec.Assignment_Initiate_Stage__c = GenericConstants.WhatsApp_Haptik_IM_Assignment;
                            }
                    }
                    
                    if(leadrec.Sign_Up_Source__c == GenericConstants.SINGLE_INPUT_FIELD)
                    {
                            if(leadrec.City == 'Others'|| leadrec.City == 'Other' || String.isBlank(leadrec.postalcode))
                            {
                                leadrec.Assignment_Initiate_Stage__c = GenericConstants.Single_Input_InsideSales_Assignment;
                            }
                    }
                    
                }
                update listOfLeads; 
            }
            
        }
        
        catch(Exception e)
        {
                system.debug('Exception : '+e.getStackTraceString());
                Logger.log('Exception','WhatsAppHaptikAssignmentBatch Class','execute method',e.getMessage(),e.getStackTraceString(),null);
        }
    }   
    
    global void finish(Database.BatchableContext bc)
    { 
        System.debug('finish method');   
    }
}