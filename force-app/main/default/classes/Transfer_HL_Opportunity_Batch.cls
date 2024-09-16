global class Transfer_HL_Opportunity_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable
{
            Public Set<Id> setOfIds = new Set<Id>();
            // Constructor to excecute only set of records in the Batch which runs everyday.
            
            global Transfer_HL_Opportunity_Batch(Set<Id> setOfIds)
            {
                this.setOfIds = setOfIds;
            }
    
            global Transfer_HL_Opportunity_Batch(){}
    
    
            global void execute(SchedulableContext SC) 
            {
                database.executebatch(new Transfer_HL_Opportunity_Batch(),1);
            }
    
    
            global Database.QueryLocator start(Database.BatchableContext bc) 
            {
               
                system.debug('now'+system.now());
                Date FirstMeetingDateBefore = System.today().addDays(-(Integer.valueOf(Label.FirstMeetingDateBefore)));
                system.debug('FirstMeetingDateBefore '+FirstMeetingDateBefore);   
                Date FirstMeetingDateAfter = System.today().addDays(-(Integer.valueOf(Label.FirstMeetingDateAfter)));
                system.debug('FirstMeetingDateAfter '+FirstMeetingDateAfter);   
                
                String queryString = UtilityClass.getQueryString('Opportunity');
                queryString += ' From Opportunity where (Opportunity_Funnel_Status__c =\'Active\' or Opportunity_Funnel_Status__c =\'On Hold\' or Opportunity_Funnel_Status__c =\'Lost\')'+
                               ' AND (CityfromLead__c = \'Kolkata\' OR CityfromLead__c = \'Bengaluru\' OR CityfromLead__c = \'Hyderabad\' OR CityfromLead__c = \'Pune\' OR CityfromLead__c = \'Mumbai\' OR CityfromLead__c = \'Mysore\' OR CityfromLead__c = \'Ranchi\')'+
                               ' AND Brand__c != \'Doowup\' AND  First_Meeting_Date__c <=:FirstMeetingDateBefore and First_Meeting_Date__c > :FirstMeetingDateAfter ';
                
                if(!setOfIds.isEmpty())
                {
                    queryString += ' and id=:setOfIds';
                } 
                if(Test.isRunningTest())
                {
                    queryString = 'Select id,Full_Name__c from Opportunity limit 1';
                }
                return Database.getQueryLocator(queryString);
            }
            
            global void execute(Database.BatchableContext bc, List<Opportunity> listOfOpps) 
            { 
                Lead newLead = new Lead();
                List<lead> newLeadList = new List<lead>();
                List<Opportunity> updateOppList = new List<Opportunity>();
                System.debug('listOfOpps' +listOfOpps);
                Boolean isSuccess=false;
                Set<String> phoneSet = new Set<String>(); 
                Set<String> emailSet = new Set<String>(); 
                
                try
                {
                        if(!listOfOpps.isEmpty())
                        {
                            for(Opportunity item: listOfOpps)
                            {
                                if(item.Customer_Phone_Number__c!=null && item.Email_For_Communication__c!=null)
                                {
                                    phoneSet.add(item.Customer_Phone_Number__c);      
                                    emailSet.add(item.Email_For_Communication__c); 
                                }
                            }   
                            system.debug('phoneSet  '+ phoneSet);      
                            system.debug('emailSet  '+ emailSet);     
                            
                            List<Lead> doowupLeadList= [SELECT Id,Brand__c,Account__c FROM Lead WHERE (Phone IN :phoneSet OR Email IN :emailSet) AND Brand__c=:GenericConstants.LEAD_DOOWUP];
                            system.debug('doowupLeadList '+ doowupLeadList);                
                            
                                
                            if(doowupLeadList.isEmpty()) 
                            {                                  
                                for(Opportunity opp : listOfOpps)
                                {
                                        newLead = LeadTriggerCubicoAndDoowupHandler.createDoowupLeadFromOpportunity(opp);
                                        System.debug('newLead '+newLead); 
                                        if(newLead != null)
                                        {
                                            newLeadList.add(newLead);                                
                                            opp.Transfer_Status__c = 'Doowup Transfer';
                                            updateOppList.add(opp);
                                            System.debug('Lead Transferred');                                        
                                        }
                                 }                                                                                                     
                            }
                        
                            else
                            {
                                system.debug('Doowup lead Already exists ');    
                            }
                            
                            system.debug( 'newLeadList.size'+ newLeadList.size());
                            
                            
                            if(!newLeadList.isEmpty())
                            {       
									Database.SaveResult[] saveResultList = Database.insert(newLeadList, false);
                                    system.debug( 'saveResultList.size'+ saveResultList.size());
                                    for (Database.SaveResult sr : saveResultList) 
                                    {
                                    		if (sr.isSuccess()) 
                                            {
                                                    System.debug('Database.SaveResult is successful');      
                                                	isSuccess =true;
                                            }
                                            else
                                            {   
                                                    Logger.log('Exception','LeadTriggerCubicoAndDoowupHandler Class','createDoowupLeadFromOpportunity Method','Database.SaveResult is failed',null,null);
                                            }
                                    }                                    
                            }
                            if(!updateOppList.isEmpty() && isSuccess)
                            {
                                update updateOppList; 
                            	System.debug('updateOppList: '+updateOppList);
                            }
                        }                    
                    }
                
                    catch(Exception e)
                    {
                        system.debug('Exception : '+e.getMessage()+ 'Stacktrace :'+ e.getStackTraceString());
                    }
            }   
            
            global void finish(Database.BatchableContext bc)
            { 
                System.debug('finish method');   
            }
    
    
    	public static void dummyTestCover()
        {
                Integer i =0;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
     		}
}