global class HL_Doowup_GFE_Experiment_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable
{
            Public Set<Id> setOfIds = new Set<Id>();
    		Public Map<String, List<String>> cityPincodeMap = new Map<String, List<String>>();
    		Public boolean eligibleForLeadCreation = false;
    		Public boolean doowupLeadCreated =false;
    
            // Constructor to excecute only set of records in the Batch which runs everyday.
            
            global HL_Doowup_GFE_Experiment_Batch(Set<Id> setOfIds)
            {
                this.setOfIds = setOfIds;
                System.debug('HL_Doowup_GFE_Experiment_Batch Entry');
            }
    
            global HL_Doowup_GFE_Experiment_Batch()
            {
                System.debug('HL_Doowup_GFE_Experiment_Batch No code');
            }
           
    
            global void execute(SchedulableContext SC) 
            {
                database.executebatch(new HL_Doowup_GFE_Experiment_Batch(),1);
                System.debug('HL_Doowup_GFE_Experiment_Batch Entry 1');
            }
    
    
            global Database.QueryLocator start(Database.BatchableContext bc) 
            {
                System.debug('HL_Doowup_GFE_Experiment_Batch Entry 2');
                system.debug('now'+system.now());                
                
                //DateTime InsideSalesAssignBeforeTime = System.now().addMinutes(-(Integer.valueOf(Label.UnverifiedLeadsPickTimeForAssignment)));
                 //DateTime InsideSalesAssignAfterTime = System.now().addMinutes(-(Integer.valueOf(Label.UnverifiedLeadsPickTimeForAssignmentAfterTime)));
                DateTime HLLeadBeforeTime = System.now().addMinutes(-(Integer.valueOf(Label.HLLeadBeforeTimeLabel)));
                system.debug('HLLeadBeforeTime '+HLLeadBeforeTime);    
                DateTime HLLeadAfterTime = System.now().addMinutes(-(Integer.valueOf(Label.HLLeadAfterTimeLabel)));
                system.debug('HLLeadAfterTime '+HLLeadAfterTime);  
                
                String queryString = UtilityClass.getQueryString('Lead');
                queryString += ' From Lead where Brand__c != \'Doowup\'and (City = \'Bengaluru\')and (Assignment_Initiate_Stage__c = \'HL Doowup GFE Experiment\') and createdDate <=: HLLeadBeforeTime AND createdDate >=: HLLeadAfterTime ';
           
            //   (Assigned_To_Inside_Sales_Agent__c == False  AND  Assigned_to_Resi_ASM__c == False ) and
                
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
                System.debug('HL_Doowup_GFE_Experiment_Batch Entry 3');
                System.debug('listOfLeads' +listOfLeads);
                try
                {
                        System.debug('listOfLeads: '+listOfLeads);
                    
                    	if(!listOfLeads.isEmpty())
                        {                         
                            List<Lead> LeadsForDoowupCreation = new List<Lead>();
                            List<Lead> LeadsForAssignment = new List<Lead>();
                             
                            for(Lead ld : listOfLeads)                            
                            {    
                                LeadsForDoowupCreation.add(ld);
                                
                                if(ld.Status == 'Fresh Lead' && (ld.Sub_Status__c == 'New' || ld.Sub_Status__c == 'Unverified') && (ld.Assigned_To_Inside_Sales_Agent__c == False  &&  ld.Assigned_to_Resi_ASM__c == False ))
                                {
                                    doowupLeadCreated = LeadTriggerCubicoAndDoowupHandler.doowupLeadCreation(LeadsForDoowupCreation);                                     
                                }
                               
                                System.debug('doowupLeadCreated: '+doowupLeadCreated);
                                
                                if(!doowupLeadCreated)
                                {
                                      ld.Assignment_Initiate_Stage__c = '';
                                    
                                    if(ld.Assigned_To_Inside_Sales_Agent__c == False  &&  ld.Assigned_to_Resi_ASM__c == False )
                                    {
                                        System.debug('Nobody is assigned');
                                      	LeadsForAssignment.add(ld); 
                                    }
                                }								
                                System.debug('ld.Assignment_Initiate_Stage__c: '+ld.Assignment_Initiate_Stage__c);
                                System.debug('doowupLeadCreated: '+doowupLeadCreated);
								LeadsForDoowupCreation.clear();                                   
                            }
                            
                            System.debug('LeadsForAssignment: '+LeadsForAssignment);
                            if(!LeadsForAssignment.isEmpty())
                            {
                                update LeadsForAssignment;
                            }
                            
                            LeadTriggerhandler.checkPincode(LeadsForAssignment, true, false);                            
                                                 
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