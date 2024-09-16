global class DeadHomelaneLead_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable
{
            Public Set<Id> setOfIds = new Set<Id>();
    		Public Map<String, List<String>> cityPincodeMap = new Map<String, List<String>>();
    		Public boolean foundDFNPincode = false;
    
            // Constructor to excecute only set of records in the Batch which runs everyday.
            
            global DeadHomelaneLead_Batch(Set<Id> setOfIds)
            {
                this.setOfIds = setOfIds;
                System.debug('DeadHomelaneLead_Batch Entry');
            }
    
            global DeadHomelaneLead_Batch()
            {
                System.debug('DeadHomelaneLead_Batch No code');
              //  this.setOfIds = setOfIds;
            }
           
    
            global void execute(SchedulableContext SC) 
            {
                database.executebatch(new DeadHomelaneLead_Batch(),1);
                System.debug('DeadHomelaneLead_Batch Entry 1');
            }
    
    
            global Database.QueryLocator start(Database.BatchableContext bc) 
            {
                System.debug('DeadHomelaneLead_Batch Entry 2');
                system.debug('now'+system.now());                
                
                //DateTime InsideSalesAssignBeforeTime = System.now().addMinutes(-(Integer.valueOf(Label.UnverifiedLeadsPickTimeForAssignment)));
                 //DateTime InsideSalesAssignAfterTime = System.now().addMinutes(-(Integer.valueOf(Label.UnverifiedLeadsPickTimeForAssignmentAfterTime)));
                DateTime DeadLeadBeforeTime = System.now().addHours(-(Integer.valueOf(Label.DeadLeadBeforeTimeLabel)));
                system.debug('DeadLeadBeforeTime '+DeadLeadBeforeTime);    
                DateTime DeadLeadAfterTime = System.now().addHours(-(Integer.valueOf(Label.DeadLeadAfterTimeLabel)));
                system.debug('DeadLeadAfterTime '+DeadLeadAfterTime);  
                
                String queryString = UtilityClass.getQueryString('Lead');
                queryString += ' From Lead where (Status =\'Dead Lead\') and (Sub_Status__c=\'Qualification Constraints(Budget/Requirements)\' or Sub_Status__c=\'Dropped the interiors plan\' or Sub_Status__c=\'Other Category Requirements\' or Sub_Status__c=\'Browsing for Designs and Quotes\') AND Brand__c != \'Doowup\'and (City = \'Surat\' OR City = \'Ranchi\' OR City = \'Coimbatore\' )  and Lead_Dead_Time__c <=: DeadLeadBeforeTime AND Lead_Dead_Time__c >=: DeadLeadAfterTime ';
           
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
                System.debug('DeadHomelaneLead_Batch Entry 3');
                System.debug('listOfLeads' +listOfLeads);
                try
                {
                        System.debug('listOfLeads: '+listOfLeads);
                    	
                    	List<DFN_Pincodes__mdt > metadataRecords = [SELECT City_Name__c, Pincode_List__c FROM DFN_Pincodes__mdt ];
                        for (DFN_Pincodes__mdt  record : metadataRecords) 
                        {
                            String cityName = record.City_Name__c;
                            String pincodeListText = record.Pincode_List__c;
                            
                            // Split the pincode list into a List<String>
                            List<String> pincodeList = pincodeListText.split(',');
                            
                            // Add the mapping to the map
                            cityPincodeMap.put(cityName, pincodeList);
                        }         
                    	
						if(!listOfLeads.isEmpty())
                        {
                            for(Lead leadrec : listOfLeads)
                            {
                                Boolean foundDFNPincode = false;
                                System.debug('leadrec.PostalCode  & cityPincodeMap '+ leadrec.PostalCode + cityPincodeMap );
                                if(leadrec.PostalCode != null && cityPincodeMap != null)
                                {
                                    for (String cityName : cityPincodeMap.keySet()) 
                                    {
                                        List<String> allPincodeList = cityPincodeMap.get(cityName);
                                   		System.debug('allPincodeList: '+allPincodeList);
                                        // Check if the pincodeList contains the lead pincode
                                        if (allPincodeList.contains(leadrec.PostalCode)) 
                                        {
                                            // The leadPincode is in this pincodes List
                                            foundDFNPincode = true;
                                            // Break out of the loop since we found a match
                                            break;
                                        }       
                                    }
                                    System.debug('foundDFNPincode: '+foundDFNPincode);
                                    if(foundDFNPincode==true)
                                    {
                                          leadrec.Assignment_Initiate_Stage__c = GenericConstants.DEAD_LEAD_DFN_ASSIGNMENT;
                                    }
                                }
                                
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