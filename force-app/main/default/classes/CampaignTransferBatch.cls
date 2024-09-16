global class CampaignTransferBatch implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable, Database.Stateful
{
    		global Set<Id> setOfIds = new Set<Id>();
            global List<Lead> ListOfLeads = new List<Lead>();
    		global String CampaignName;
    		global Id CampaignId;
    	    global Integer LeadSetSize;
    		global DateTime StartTime;
    		global Decimal TotalLeads;
    		global String Description;
    		global Custom_Campaign__c ccRecord;
    		public Integer batchCounter=0;
    
            // Constructor to excecute only set of records in the Batch which runs everyday.
            
    		global CampaignTransferBatch(Set<Id> setOfIds,String CampaignName,Id CampaignId,Decimal TotalLeads, String Description,Custom_Campaign__c ccRecord)
            {
                //batchCounter=0;
                this.setOfIds = setOfIds;
                this.CampaignName = CampaignName;
                this.CampaignId = CampaignId;
                this.LeadSetSize = setOfIds.size();
                this.StartTime = System.now();
                this.TotalLeads = TotalLeads;
                this.Description = Description;
                this.ccRecord = ccRecord;
                System.debug('CampaignTransferBatch Constructor with Parameter Entry');   
                system.debug('this.setOfIds '+this.setOfIds); 
                system.debug('this.CampaignName '+this.CampaignName);     
                system.debug('this.CampaignId '+this.CampaignId);   
                system.debug('this.LeadSetSize '+this.LeadSetSize);   
                system.debug('this.Description '+ this.Description);   
                system.debug('this.ccRecord '+  this.ccRecord);  
            }
    
            global CampaignTransferBatch()
            {
                System.debug('CampaignTransferBatch Constructor Entry');
            }
           
    
            global void execute(SchedulableContext SC) 
            {
                database.executebatch(new CampaignTransferBatch(),1);
                System.debug('CampaignTransferBatch Entry 1');
            }
    
    
            global Database.QueryLocator start(Database.BatchableContext bc) 
            {
                System.debug('CampaignTransferBatch Entry 2');                
                
                String queryString = UtilityClass.getQueryString('Lead');
                queryString += ' From Lead where Offline_Priority_Lead__c!=null ';
                           
                if(!setOfIds.isEmpty())
                {
                    queryString += ' and id=:setOfIds Limit 5000';
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
                    System.debug('CampaignTransferBatch Entry 3');
                    System.debug('listOfLeads' +listOfLeads);               	
                	
                	System.debug('this.LeadSetSize : ' +this.LeadSetSize);
                
                    try
                    {
                      	for(Lead ld : listOfLeads)
                        {
                            ld.Nimbus_Campaign__c = this.CampaignName;
                            ld.Nimbus_Status__c = GenericConstants.ASSIGNED_TO_NIMBUS;
                            batchCounter = batchCounter + 1 ;
   				
                			System.debug('batchCounter : ' +batchCounter);
                        }
                        if(!listOfLeads.isEmpty())
                        {
                            update listOfLeads;                                                                  
                        }
                        if(batchCounter == this.LeadSetSize)
                        {
                             DateTime newDateTime = DateTime.now().addHours(5);
                             newDateTime = newDateTime.addMinutes(30);
                             System.debug('New DateTime: ' + newDateTime);
                            
                             ccRecord.Batch_Process_Description__c = ccRecord.Batch_Process_Description__c + '\n'+ LeadSetSize+' Leads are transfered. Batch is finished at ' + newDateTime ;
                            
                             ccRecord.Total_Leads_Processed__c = ccRecord.Total_Leads_Processed__c + LeadSetSize;                                    
                             System.debug('ccRecord :'+ccRecord);
                             System.debug('ccRecord.Batch_Process_Description__c :'+ccRecord.Batch_Process_Description__c);                                                    
                                        
                             update ccRecord;
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