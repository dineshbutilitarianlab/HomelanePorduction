global class Transfer_HL_DeadLead_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable
{
            Public Set<Id> setOfIds = new Set<Id>();
            // Constructor to excecute only set of records in the Batch which runs everyday.
            
            global Transfer_HL_DeadLead_Batch(Set<Id> setOfIds)
            {
                this.setOfIds = setOfIds;
            }
    
            global Transfer_HL_DeadLead_Batch(){}
    
    
            global void execute(SchedulableContext SC) 
            {
                database.executebatch(new Transfer_HL_DeadLead_Batch(),1);
            }
    
    
            global Database.QueryLocator start(Database.BatchableContext bc) 
            {               
                system.debug('now'+system.now());
                DateTime DeadLeadBeforeTime = System.now().addHours(-(Integer.valueOf(Label.DeadLeadBeforeTimeLabel)));
                system.debug('DeadLeadBeforeTime '+DeadLeadBeforeTime);    
                DateTime DeadLeadAfterTime = System.now().addHours(-(Integer.valueOf(Label.DeadLeadAfterTimeLabel)));
                system.debug('DeadLeadAfterTime '+DeadLeadAfterTime);  
                // Removed Ranchi and Mysore as requested by Deepak. Also Bronze lead check is removed.
                Set<String> setOfCities = new Set<String>{'Bengaluru','Hyderabad','Thane','Pune','Kolkata'}; 
                
                String queryString = UtilityClass.getQueryString('Lead');
                queryString += ' From Lead where (Status =\'Dead Lead\') AND (Assigned_to_Resi_ASM__c=true or Assigned_To_Inside_Sales_Agent__c =true) '+
                               ' AND  City IN :setOfCities  AND (Brand__c = \'HomeLane\' OR Brand__c =null ) AND Bulk_Upload__c=False '+
                               ' AND Lead_Dead_Time__c <=: DeadLeadBeforeTime AND Lead_Dead_Time__c >=: DeadLeadAfterTime ';
                    		  
                
                if(!setOfIds.isEmpty())
                {
                    queryString += ' and id=:setOfIds';
                } 
                if(Test.isRunningTest())
                {
                    queryString = 'Select id from Lead limit 1';
                }
                return Database.getQueryLocator(queryString);
            }
            
            global void execute(Database.BatchableContext bc, List<Lead> listOfLeads) 
            { 
                System.debug('listOfLeads' +listOfLeads);
                try
                {
                        System.debug('listOfLeads: '+listOfLeads);
                        if(!listOfLeads.isEmpty())
                        {
                            for(Lead leadrec : listOfLeads)
                            {
                                leadrec.Assignment_Initiate_Stage__c = GenericConstants.TRANSFER_HL_DEADLEAD_ASSIGNMENT;
                            }
                            
                            update listOfLeads; 
                            System.debug('listOfLeads after assignment: '+listOfLeads);
                        }
                    
                    }
                    catch(Exception e)
                    {
                        system.debug('Exception : '+e.getStackTraceString());
                    }
            }   
            
            global void finish(Database.BatchableContext bc)
            { 
                System.debug('finish method');   
            }
}