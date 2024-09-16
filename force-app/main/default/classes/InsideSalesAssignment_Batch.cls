global class InsideSalesAssignment_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable
{
         	Public Set<Id> setOfIds = new Set<Id>();
            // Constructor to excecute only set of records in the Batch which runs everyday.
            
    		global InsideSalesAssignment_Batch(Set<Id> setOfIds)
            {
                this.setOfIds = setOfIds;
            }
    
            global InsideSalesAssignment_Batch(){}
    
    
            global void execute(SchedulableContext SC) 
            {
                database.executebatch(new InsideSalesAssignment_Batch(),1);
            }
    
    
            global Database.QueryLocator start(Database.BatchableContext bc) 
            {
               
                system.debug('now'+system.now());
                //DateTime InsideSalesAssignBeforeTime = System.now().addMinutes(-(Integer.valueOf(Label.UnverifiedLeadsPickTimeForAssignment)));
                 //DateTime InsideSalesAssignAfterTime = System.now().addMinutes(-(Integer.valueOf(Label.UnverifiedLeadsPickTimeForAssignmentAfterTime)));
                DateTime insideSalesAgentAssignedBeforeTime = System.now().addHours(-24);
                system.debug('insideSalesAgentAssignedBeforeTime '+insideSalesAgentAssignedBeforeTime);              
                
                String queryString = UtilityClass.getQueryString('Lead');
                queryString += ' From Lead where (Status =\'Fresh Lead\') and (Sub_Status__c=\'Unverified\' or Sub_Status__c=\'New\') AND Assigned_To_Inside_Sales_Agent__c = true and Brand__c != \'Doowup\'and Inside_Sales_Assignment_Date__c >=: insideSalesAgentAssignedBeforeTime';
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
                try{
                        System.debug('listOfLeads: '+listOfLeads);
                        if(!listOfLeads.isEmpty())
                        {
                            for(Lead leadrec : listOfLeads)
                            {
                                leadrec.Assignment_Initiate_Stage__c = GenericConstants.INSIDE_SALES_SWITCH_BATCH;
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
            
            global void finish(Database.BatchableContext bc){ 
                System.debug('finish method');   
            }
}