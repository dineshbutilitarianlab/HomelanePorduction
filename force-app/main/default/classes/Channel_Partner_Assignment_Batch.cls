global class Channel_Partner_Assignment_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable
{
            Public Set<Id> setOfIds = new Set<Id>();
            Public Map<String, List<String>> cityPincodeMap = new Map<String, List<String>>();
            Public boolean eligibleForLeadCreation = false;
            Public boolean doowupLeadCreated =false;    
            Public String HL_Referrer_Phone = System.Label.HomeLane_Offline_Channel_Partner_Phone;
            Public String HomeLane_Offline_Channel_Partner = System.Label.HomeLane_Offline_Channel_Partner;
            Public Integer Batch_LIMIT = Integer.valueOf(System.Label.CP_Batch_LIMIT);
    
            // Constructor to excecute only set of records in the Batch which runs everyday.
            
            global Channel_Partner_Assignment_Batch(Set<Id> setOfIds)
            {
                this.setOfIds = setOfIds;
                System.debug('Channel_Partner_Assignment_Batch Entry');
            }
    
            global Channel_Partner_Assignment_Batch()
            {
                System.debug('Channel_Partner_Assignment_Batch No code');
            }
           
    
            global void execute(SchedulableContext SC) 
            {
                database.executebatch(new Channel_Partner_Assignment_Batch(),1);
                System.debug('Channel_Partner_Assignment_Batch Entry 1');
            }
    
    
            global Database.QueryLocator start(Database.BatchableContext bc) 
            {
                System.debug('Channel_Partner_Assignment_Batch Entry 2');
                system.debug('now'+system.now());                
                
                DateTime BeforeSixMonths =  Date.today().addDays(-180);
                DateTime startDate = DateTime.newInstance(2022, 1, 1, 0, 0, 0);
                DateTime endDate = DateTime.newInstance(2023, 11, 30, 23, 59, 59);
                system.debug('BeforeSixMonths '+BeforeSixMonths);  
                system.debug('startDate '+startDate);   
                system.debug('endDate '+endDate);   
                
                String queryString = UtilityClass.getQueryString('Lead');
                queryString += ' From Lead where (Status !=\'Appointment Successful\' AND Status!= \'Appointment Fixed\' AND Status != \'WhatsApp Pre-Appointment\' AND Status != \'Pre-Appointment\' AND Status != \'Fresh Lead\' ) AND Channel_Partner__c!=null and Channel_Partner__c != :HomeLane_Offline_Channel_Partner AND CreatedDate <= :BeforeSixMonths AND CreatedDate > :startDate ';
             // queryString += ' From Lead where (Status !=\'Appointment Successful\') AND Channel_Partner__c!=null AND Channel_Partner__c != :HomeLane_Offline_Channel_Partner AND Updated_by_CP_Assignment_Batch__c = False AND CreatedDate > :startDate AND CreatedDate < :endDate ';
                             
                if(!setOfIds.isEmpty())
                {
                    queryString += ' and id=:setOfIds';
                } 
                if (!Test.isRunningTest() && setOfIds.isEmpty()) 
                {
                    queryString += ' Order by CreatedDate DESC LIMIT :Batch_LIMIT';
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
                System.debug('Channel_Partner_Assignment_Batch Entry 3');
                System.debug('listOfLeads' +listOfLeads);
               
                try
                {
                        if(!listOfLeads.isEmpty())
                        {                         
                            List<Lead> LeadsForCPAssignment = new List<Lead>();
                             
                            for(Lead ld : listOfLeads)                            
                            {                                                           
                                ld.HL_Referrer_Phone__c = HL_Referrer_Phone ;
                                ld.Channel_Partner__c = HomeLane_Offline_Channel_Partner ;
                                ld.CP_Assignment_Date__c = System.now();
                                ld.Updated_by_CP_Assignment_Batch__c = true;
                                LeadsForCPAssignment.add(ld);                                                                                                                   
                            }                          
                                                      
                            System.debug('LeadsForCPAssignment: '+LeadsForCPAssignment);                       
                                                       
                            if(!LeadsForCPAssignment.isEmpty())
                            {
                                update LeadsForCPAssignment;
                            }                                                                                                                 
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