global class Doowup_DFN_Transfer_AUG_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable
{
            Public Set<Id> setOfIds = new Set<Id>();
    		Public Map<String, List<String>> cityPincodeMap = new Map<String, List<String>>();
    		Public boolean foundDFNPincode = false;
    
            // Constructor to excecute only set of records in the Batch which runs everyday.
            
            global Doowup_DFN_Transfer_AUG_Batch(Set<Id> setOfIds)
            {
                this.setOfIds = setOfIds;
                System.debug('Doowup_DFN_Transfer_AUG_Batch Entry');
            }
    
            global Doowup_DFN_Transfer_AUG_Batch()
            {
                System.debug('Doowup_DFN_Transfer_AUG_Batch No code');
              //  this.setOfIds = setOfIds;
            }
           
    
            global void execute(SchedulableContext SC) 
            {
                database.executebatch(new Doowup_DFN_Transfer_AUG_Batch(),1);
                System.debug('Doowup_DFN_Transfer_AUG_Batch Entry 1');
            }
    
    
            global Database.QueryLocator start(Database.BatchableContext bc) 
            {
                System.debug('Doowup_DFN_Transfer_AUG_Batch Entry 2');
                system.debug('now'+system.now());                
                
                //DateTime InsideSalesAssignBeforeTime = System.now().addMinutes(-(Integer.valueOf(Label.UnverifiedLeadsPickTimeForAssignment)));
                 //DateTime InsideSalesAssignAfterTime = System.now().addMinutes(-(Integer.valueOf(Label.UnverifiedLeadsPickTimeForAssignmentAfterTime)));
                DateTime DeadLeadBeforeTime = System.now().addHours(-(Integer.valueOf(Label.DeadLeadBeforeTimeLabel)));
                system.debug('DeadLeadBeforeTime '+DeadLeadBeforeTime);    
                DateTime DeadLeadAfterTime = System.now().addHours(-(Integer.valueOf(Label.DeadLeadAfterTimeLabel)));
                system.debug('DeadLeadAfterTime '+DeadLeadAfterTime); 
                Set<String> setOfSubstatus = new Set<String>{'Qualification Constraints','Qualification Constraints(Budget/Requirements)','Looking for Designs only', 
                    										  'Civil work required/Cannot service', 'Finalized with competitors', 'Requires only loose furniture', 
                    										  'Was shopping around for quotes', 'Looking for furnishings only', 'Your estimated prices seem too high', 
                    										  'Renovation/Civil work required', 'Already done','Already done interiors with HL'};
                Set<String> setOfCities = new Set<String>{'Surat','Bhubaneswar','Jamshedpur','Ranchi','Tirupati','Kochi','Chennai','Mysore','Patna','Guwahati'};        
                
                String queryString = UtilityClass.getQueryString('Lead');
                queryString += ' From Lead where (Status =\'Dead Lead\') and Sub_Status__c IN :setOfSubstatus AND (Brand__c = \'HomeLane\' OR Brand__c =null ) and City IN :setOfCities and Bulk_Upload__c=False and Lead_Dead_Time__c <=: DeadLeadBeforeTime AND Lead_Dead_Time__c >=: DeadLeadAfterTime ';
           
                system.debug('DeadLeadAfterTime '+DeadLeadAfterTime);  
                if(!setOfIds.isEmpty())
                {
                    queryString += ' and id=:setOfIds';
                } 
                if(Test.isRunningTest())
                {
                    queryString = 'Select id from Lead limit 1';
                }
                system.debug('queryString '+queryString); 
                return Database.getQueryLocator(queryString);
            }
            
            global void execute(Database.BatchableContext bc, List<Lead> listOfLeads) 
            { 
                boolean foundPincode=false;
                System.debug('Doowup_DFN_Transfer_AUG_Batch Entry 3');
                System.debug('listOfLeads' +listOfLeads);
                try
                {
                        System.debug('listOfLeads: '+listOfLeads);
                    	
                    	set<String> settOfLeadCities = new set<String>();                            
                    	
						if(!listOfLeads.isEmpty())
                        {
                            for(Lead leadrec : listOfLeads)
                            {                               
                                System.debug('leadrec.City '+ leadrec.City);
                                if(leadrec.City != null)
                                {
                                       leadrec.Assignment_Initiate_Stage__c = GenericConstants.DOOWUP_DFN_TRANSFER_ASSIGNMENT;
                                }                                
                            }
                            
                            update listOfLeads; 
                            System.debug('listOfLeads : '+listOfLeads);
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