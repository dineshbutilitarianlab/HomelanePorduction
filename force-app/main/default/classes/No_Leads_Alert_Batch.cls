global class No_Leads_Alert_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable
{
            Public Set<Id> setOfIds = new Set<Id>();
            Public static Boolean rosterEmailsSent = false;
            Public static Integer SizeOfList;
            Public static List<Lead> listOfLeads;
            // Constructor to excecute only set of records in the Batch which runs everyday.
            
            global No_Leads_Alert_Batch(Set<Id> setOfIds)
            {
                this.setOfIds = setOfIds;
            }
    
            global No_Leads_Alert_Batch(){}
    
    
            global void execute(SchedulableContext SC) 
            {                
                database.executebatch(new No_Leads_Alert_Batch(),1);
            }
    
    
            global Database.QueryLocator start(Database.BatchableContext bc) 
            {
               
                system.debug('now'+system.now());
                DateTime LeadCreatedAfterTime = System.now().addHours(-(Integer.valueOf(Label.LeadCreatedAfterTime)));
                DateTime LeadCreatedBeforeTime = System.now().addHours(-(Integer.valueOf(Label.LeadCreatedBeforeTime)));
                system.debug('LeadCreatedAfterTime '+LeadCreatedAfterTime);        
                system.debug('LeadCreatedBeforeTime '+LeadCreatedBeforeTime);  
                
                String queryString = UtilityClass.getQueryString('Lead');
                queryString += ' From Lead where Bulk_Upload__c = False AND CreatedDate >= :LeadCreatedAfterTime AND CreatedDate < :LeadCreatedBeforeTime ';
                
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
                        system.debug('Leads are created in Last hour ');
                    }
                    catch(Exception e)
                    {
                        system.debug('Exception : '+e.getStackTraceString());
                    }
            }   
            
            global void finish(Database.BatchableContext bc)
            { 
                        System.debug('finish method'); 
                        List<String> listOfJSON = new List<String>();                        
                        DateTime lastLeadCreatedDate;
                        String lastLeadCreatedDateString ;
                        DateTime LeadCreatedAfterTime = System.now().addHours(-(Integer.valueOf(Label.LeadCreatedAfterTime)));
                        DateTime LeadCreatedBeforeTime = System.now().addHours(-(Integer.valueOf(Label.LeadCreatedBeforeTime)));
                        system.debug('LeadCreatedAfterTime '+LeadCreatedAfterTime);        
                        system.debug('LeadCreatedBeforeTime '+LeadCreatedBeforeTime);  
                        
                        listOfLeads = [Select id From Lead where Bulk_Upload__c = False AND CreatedDate >= :LeadCreatedAfterTime AND CreatedDate < :LeadCreatedBeforeTime];
                        SizeOfList = listOfLeads.size();
                        System.debug('SizeOfList: '+SizeOfList);
                        if(SizeOfList == 0)
                        {                           
                            System.debug('No digital leads got created in last one hour');
                            Map<String,String> toEmailMap = new Map<String,String>();  
                            
                            List<Lead> lastLead = [SELECT Id, Name, CreatedDate FROM Lead where Bulk_Upload__c = False ORDER BY CreatedDate DESC LIMIT 1];
                            
                            if(!lastLead.isEmpty()) 
                            {
                                 lastLeadCreatedDate = lastLead[0].CreatedDate;
                                 lastLeadCreatedDateString = lastLeadCreatedDate.format('yyyy-MM-dd HH:mm:ss');
                            }
                            
                            String subject = 'No Leads Alert SalesForce';
                            
                            String HL_Tech_Email = System.label.Email;
                                        
                            toEmailMap.put('email',HL_Tech_Email);                                        
                            toEmailMap.put('name','HomeLane Tech');                                    
                                        
                            List<Map<String,String>> template_contentList = new List<Map<String,String>>();                                        
                            List<String> ccEmailList =new List<String>();                                       
                                        
                            Map<String,String> template_contentMap1 = new Map<String,String>();                                        
                            template_contentMap1.put('name','start_datetime');                                        
                            template_contentMap1.put('content',lastLeadCreatedDateString);                                        
                            template_contentList.add(template_contentMap1); 
                                        
                            String jsonbody = MandrilEmailViaRosterQueueabble.rosterEmailWrapperJsonCreator('No_Leads_Alert', subject, toEmailMap, template_contentList,ccEmailList);
                                        
                            System.debug('jsonbody: '+jsonbody);
                                        
                            if(!String.isBlank(jsonbody))                                        
                            {                                            
                                listOfJSON.add(jsonbody);                                        
                            }
                            
                             if(!listOfJSON.isEmpty() && !rosterEmailsSent)
                             {
                                    System.debug('listOfJSON is not empty: '+listOfJSON);
                                    if(System.isBatch()||System.isFuture())
                                    {
                                        MandrilEmailViaRosterQueueabble emailQueable = new MandrilEmailViaRosterQueueabble(listOfJSON);
                                        ID jobID = System.enqueueJob(emailQueable);
                                        rosterEmailsSent = True;
                                        System.debug('jobID: '+jobID);
                                    }
                                    else
                                    {
                                        System.debug('non batch non future context');
                                        MandrilEmailViaRosterQueueabble.callRosterEmailAPI(listOfJSON);
                                        rosterEmailsSent = True;
                                    } 
                             }
                        }
            }
}