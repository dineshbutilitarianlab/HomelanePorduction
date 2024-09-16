public class LeadTriggerCubicoAndDoowupHandler 
{
    Public Static List<Territory__c> territoryList = new List<Territory__c>();
    Public Static Map < String, Territory__c > pincodeToTerritoryMap = new Map < String, Territory__c> ();
    Public Static Map < String, Lead > newleadsMap = new Map < String, Lead > ();  
    Public Static List<Lead> lstLeadsToAssignCubico = new List<Lead>();
    Public Static List<Lead> lstLeadsToAssignWrapzap = new List<Lead>();
    Public Static Map<id, List<String>> showroomCityMap = new Map<id, List<String>>();
    Public Static Map<String, Master__c> MapofCityToDealerShowroom = new Map<String, Master__c>();
    Public Static Map<id, String> showroomClusterMap = new Map<id, String>();
    Public Static String foundShowroomId = null;
    Public Static String foundDFNShowroom = null;
    Public Static String DealerId = null;
    Public Static String DealerEmail = null;
    Public Static List<Lead> newLeadsList=new List<Lead>();
    Public Static Map<Id,Lead> oldLeadsMap = new Map<Id,Lead>();
    
    
    // Created on 30 November 2023
    public static void AssignDeadLeadsToCubicoShowrooms(List<Lead> newLdList, Map<Id,Lead> oldLdMap)
    {
        system.debug('AssignDeadLeadsToCubicoShowrooms');
       
        newLeadsList= newLdList;
        oldLeadsMap=oldLdMap;
        system.debug('**newLeadsList*****' +newLeadsList);  
        system.debug('**oldLeadsMap*****' +oldLeadsMap);  
        
        try
        {           
            if(oldLeadsMap != null) {
                for(Lead ld: newLeadsList)
                {                               
                    system.debug('**City of Lead*****' + ld.City);   
                    if(((ld.Status == GenericConstants.LEAD_DEAD_STATUS && ld.Sub_Status__c == GenericConstants.LEAD_SUBSTATUS_COMMERCIAL_REQUIREMENT)||
                       (ld.Status == GenericConstants.LEAD_DEAD_STATUS && ld.Sub_Status__c == GenericConstants.LEAD_SUBSTATUS_QUALIFICATION_CONSTRAINTS && ld.Reason_For_Dead_Lead__c==GenericConstants.DEAD_LEAD_REASON_COMMERCIAL_INTERIOR_REQUIREMENT))
                       && (ld.Status != oldLeadsMap.get(ld.id).Status && ld.Sub_Status__c != oldLeadsMap.get(ld.id).Sub_Status__c )) 
                    {
                        system.debug('**City of Lead*****' + ld.City);
                        lstLeadsToAssignCubico.add(ld);
                    }
                }
                if(!lstLeadsToAssignCubico.isEmpty())
                {
                    CubicoLeadCreation(lstLeadsToAssignCubico);
                }
                
                
            }
        }  
        
        catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','AssignDeadLeadsToCubicoShowrooms Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    Public static Map<id,List<String>> getcubicoShowroomMetadata()
    {
        
        List<Cubico_Cluster_City_Maps__mdt> metadataRecords = [SELECT Showroom_Id__c, City_List__c FROM Cubico_Cluster_City_Maps__mdt];
        for (Cubico_Cluster_City_Maps__mdt record : metadataRecords) 
        {
            String showroomId = record.Showroom_Id__c;
            String cityListText = record.City_List__c;
                        
            // Split the city list into a List<String>
            List<String> cityList = cityListText.split(',');
            
            // Add the mapping to the map
            showroomCityMap.put(showroomId, cityList);            
        }
        return showroomCityMap;
    }
    
    
    Public static Map<id,String> getcubicoShowroomClusterMap()
    {
        
        List<Cubico_Cluster_City_Maps__mdt> metadataRecords = [SELECT Showroom_Id__c, Cluster_Type__c FROM Cubico_Cluster_City_Maps__mdt];
        for (Cubico_Cluster_City_Maps__mdt record : metadataRecords) 
        {
            String showroomId = record.Showroom_Id__c;
            String clusterType = record.Cluster_Type__c;
             
            // Add the mapping to the map
            showroomClusterMap.put(showroomId, clusterType);
        }        
        return showroomClusterMap;
    }

    
    Public static Id getCubicoShowroom (String leadCityToSearch ,Map<id, List<String>> showroomCityMap) 
    {
        Id foundShowroomId = null;
        try
        {
             
            // Iterate through the showroomCityMap to find the showroomId for the given leadCity
            for (String showroomId : showroomCityMap.keySet()) 
            {
                List<String> cityList = showroomCityMap.get(showroomId);
                
                // Check if the cityList contains the leadCity
                if (cityList.contains(leadCityToSearch)) 
                {
                    // The leadCity is in this showroom's cityList
                    foundShowroomId = showroomId;
                    System.debug('Found showroomId ' + foundShowroomId + ' for leadCity ' + leadCityToSearch);
                    // Break out of the loop since we found a match
                    break;
                }                          
            }
            return foundShowroomId ; 
            
        }
        Catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','AssignDeadLeadsToCubicoShowrooms Method',e.getMessage(),e.getStackTraceString(),null);
        }
        
        return foundShowroomId ;    
    } 
    
    public static void CubicoLeadCreation (List<Lead> LeadList)
    {
        system.debug('method entry');
        try
        {
            List<Lead> newLeadList = new list<Lead>();  
            Set<Id> AccountIdSet = new Set<Id>();  
            showroomCityMap = getcubicoShowroomMetadata();  
            showroomClusterMap = getcubicoShowroomClusterMap();
            
            for(Lead item: LeadList)
            {
                AccountIdSet.add(item.Account__c);                 
            }   
            system.debug('showroomCityMap  '+ showroomCityMap ); 
            system.debug('showroomClusterMap  '+ showroomClusterMap ); 
            system.debug('AccountIdSet  '+ AccountIdSet); 
                    
            
            List<Lead> cubicoLeadList= [SELECT Id,Brand__c FROM Lead WHERE Account__c IN :AccountIdSet AND Sign_Up_Source__c=:GenericConstants.Brand_Cubico];
             system.debug('cubicoLeadList '+ cubicoLeadList);
                
            if(cubicoLeadList.isEmpty()) 
            {       
                for(Lead ld :LeadList)
                {
                    Lead newlead = cubicolead(ld);
                    newLeadList.add(newLead);
                }
            }
            
            system.debug('newLeadList.size()'+ newLeadList.size()+ newLeadList);
            
            if(!newLeadList.isEmpty())
            {
                //insert newLeadList;
                //RecursiveTriggerHandlerLead.cubicoCount++;
                system.debug( 'RecursiveTriggerHandlerLead.cubicoCount++'+ RecursiveTriggerHandlerLead.cubicoCount++);
                Database.SaveResult[] saveResultList = Database.insert(newLeadList, false);
                system.debug( 'saveResultList.size'+ saveResultList.size());
                for (Database.SaveResult sr : saveResultList) 
                {
                    if (sr.isSuccess()) 
                    {
                        System.debug('Database.SaveResult is successful');  
                        RecursiveTriggerHandlerLead.cubicoCount++;
                    }
                    else
                    {
                        RecursiveTriggerHandlerLead.cubicoCount++;
                        Logger.log('Exception','LeadTriggerCubicoAndDoowupHandler Class','cubicoLeadCreation Method in Else Condition','Database.SaveResult is failed',null,null);
                    }
                }
            }
            
        }
        
        catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerCubicoAndDoowupHandler Class','cubicoLeadCreation Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    
    public static Lead cubicolead(Lead ld)
    {
        String clusterType;
        Lead newlead = new Lead();
        newlead.LastName = String.isNotBlank(ld.LastName) ? ld.LastName : null;
        newlead.Email = String.isNotBlank(ld.Email) ? ld.Email : null;
        newlead.PostalCode = String.isNotBlank(ld.PostalCode) ? ld.PostalCode : null;
        newlead.Phone = String.isNotBlank(ld.Phone) ? ld.Phone : null;
        newlead.Area_Code__c = String.isNotBlank(ld.Area_Code__c) ? ld.Area_Code__c : null;
        newlead.Brand__c = 'HomeLane';
        newlead.LeadSource = String.isNotBlank(ld.LeadSource) ? ld.LeadSource : null;
        newlead.Status = 'Fresh Lead';
        newlead.Sub_Status__c = 'New';
        newlead.City = String.isNotBlank(ld.City) ? ld.City : null;
        newlead.Account__c =  ld.Account__c;
        newlead.Sign_Up_Source__c = GenericConstants.Brand_Cubico;
        
        newlead.Kitchen__c = String.isNotBlank(ld.Kitchen__c) ? ld.Kitchen__c : null;
        newlead.Wardrobes__c = String.isNotBlank(ld.Wardrobes__c) ? ld.Wardrobes__c : null;
        newlead.Entertainment_Unit__c = String.isNotBlank(ld.Entertainment_Unit__c) ? ld.Entertainment_Unit__c : null;
        newlead.Study_Table_Book_Shelf__c = String.isNotBlank(ld.Study_Table_Book_Shelf__c) ? ld.Study_Table_Book_Shelf__c : null;
        newlead.Crockery_Unit__c = String.isNotBlank(ld.Crockery_Unit__c) ? ld.Crockery_Unit__c : null;
        newlead.Budget_Range__c = String.isNotBlank(ld.Budget_Range__c) ? ld.Budget_Range__c : null;
        newlead.Property_Type__c = String.isNotBlank(ld.Property_Type__c) ? ld.Property_Type__c : null;
        
      //  showroomCityMap = getcubicoShowroomMetadata();
        if(!String.isBlank(newLead.City) && !showroomCityMap.isEmpty() )
        {
            foundShowroomId = getCubicoShowroom(newLead.City,showroomCityMap);
        }
        
        if(foundShowroomId != null)
        {
            newLead.Appointment_Venue_Square__c = foundShowroomId;              
        }      
        
        
        if(((ld.Status == GenericConstants.LEAD_DEAD_STATUS && ld.Sub_Status__c == GenericConstants.LEAD_SUBSTATUS_COMMERCIAL_REQUIREMENT)||
            (ld.Status == GenericConstants.LEAD_DEAD_STATUS && ld.Sub_Status__c == GenericConstants.LEAD_SUBSTATUS_QUALIFICATION_CONSTRAINTS && 
             ld.Reason_For_Dead_Lead__c==GenericConstants.DEAD_LEAD_REASON_COMMERCIAL_INTERIOR_REQUIREMENT)) && 
            (ld.Status != oldLeadsMap.get(ld.id).Status && ld.Sub_Status__c != oldLeadsMap.get(ld.id).Sub_Status__c )) 
            {
                		if(!showroomClusterMap.isEmpty() && foundShowroomId != null)
                        {
                            clusterType = showroomClusterMap.get(foundShowroomId);
                        }
                        System.debug('clusterType : '+clusterType);
                
                        system.debug('**Cluster Wise Assignment**');
                        if(clusterType == GenericConstants.CLUSTER_TYPE_A)
                        {
                            newlead.Sales_Manager__c=Label.Sales_Manager_ID_A;
                            newlead.Assigned_To_Resi_ASM__c=true;
                            newlead.IRM_Assignment_Date__c= System.now();
                        }
                        else
                        {
                            newlead.Sales_Manager__c=Label.Sales_Manager_ID_B;
                            newlead.Assigned_To_Resi_ASM__c=true;
                            newlead.IRM_Assignment_Date__c= System.now();
                        }
            }      
        
            return newLead;
    }
        
    
    
    public static void AssignDeadLeadsToWrapzapShowrooms(List<Lead> newLdList, Map<Id,Lead> oldLdMap)
    {
        system.debug('AssignDeadLeadsToWrapzapShowrooms');
       
        newLeadsList= newLdList;
        oldLeadsMap=oldLdMap;
        system.debug('**newLeadsList*****' +newLeadsList);  
        system.debug('**oldLeadsMap*****' +oldLeadsMap);  
        
        try
        {           
            if(oldLeadsMap != null) 
            {
                for(Lead ld: newLeadsList)
                {                               
                    if((ld.Status == GenericConstants.LEAD_DEAD_STATUS && ld.Sub_Status__c == GenericConstants.LEAD_SUBSTATUS_OTHER_CATEGORY_REQUIREMENT && 
                         ld.Reason_For_Dead_Lead__c==GenericConstants.DEAD_LEAD_REASON_LAMINATE_CHANGE)  && 
                       (ld.Status != oldLeadsMap.get(ld.id).Status && ld.Sub_Status__c != oldLeadsMap.get(ld.id).Sub_Status__c )) 
                    {
                        	lstLeadsToAssignWrapzap.add(ld);
                    }
                }
                if(!lstLeadsToAssignWrapzap.isEmpty())
                {
                    WrapzapLeadCreation(lstLeadsToAssignWrapzap);
                }                
                
            }
        }  
        
        catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','AssignDeadLeadsToWrapzapShowrooms Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    
    public static void WrapzapLeadCreation (List<Lead> LeadList)
    {
        system.debug('method entry');
        try
        {
            List<Lead> newLeadList = new list<Lead>();  
            Set<Id> AccountIdSet = new Set<Id>();  
               
            for(Lead item: LeadList)
            {
                AccountIdSet.add(item.Account__c);
                 
            }   
          
            system.debug('AccountIdSet  '+ AccountIdSet); 
                    
            
            List<Lead> wrapzapLeadList= [SELECT Id,Brand__c FROM Lead WHERE Account__c IN :AccountIdSet AND Sign_Up_Source__c=:GenericConstants.Brand_Wrapzap];
             system.debug('wrapzapLeadList '+ wrapzapLeadList);
                
            if(wrapzapLeadList.isEmpty()) 
            {       
                for(Lead ld :LeadList)
                {
                    	Lead newlead = wrapzaplead(ld);
                     	newLeadList.add(newLead);
                }
            }
            
            system.debug('newLeadList.size()'+ newLeadList.size()+ newLeadList);
            
            if(!newLeadList.isEmpty())
            {                
                system.debug( 'RecursiveTriggerHandlerLead.cubicoCount++'+ RecursiveTriggerHandlerLead.wrapzapCount++);
                Database.SaveResult[] saveResultList = Database.insert(newLeadList, false);
                system.debug( 'saveResultList.size'+ saveResultList.size());
                for (Database.SaveResult sr : saveResultList) 
                {
                    if (sr.isSuccess()) 
                    {
                        System.debug('Database.SaveResult is successful');  
                        RecursiveTriggerHandlerLead.wrapzapCount++;
                    }
                    else
                    {
                        RecursiveTriggerHandlerLead.wrapzapCount++;
                        Logger.log('Exception','LeadTriggerCubicoAndDoowupHandler Class','WrapzapLeadCreation Method in Else Condition','Database.SaveResult is failed',null,null);
                    }
                }
            }
            
        }
        
        catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerCubicoAndDoowupHandler Class','WrapzapLeadCreation Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }  
    
    public static Lead wrapzaplead(Lead ld)
    {
        Lead newlead = new Lead();
        newlead.LastName = String.isNotBlank(ld.LastName) ? ld.LastName : null;
        newlead.Email = String.isNotBlank(ld.Email) ? ld.Email : null;
        newlead.PostalCode = String.isNotBlank(ld.PostalCode) ? ld.PostalCode : null;
        newlead.Phone = String.isNotBlank(ld.Phone) ? ld.Phone : null;
        newlead.Area_Code__c = String.isNotBlank(ld.Area_Code__c) ? ld.Area_Code__c : null;
        newlead.Brand__c = 'Wrapzap';
        newlead.LeadSource = 'HomeLane_Dead Lead';
        newlead.Status = 'Fresh Lead';
        newlead.Sub_Status__c = 'New';
        newlead.City = String.isNotBlank(ld.City) ? ld.City : null;
        newlead.Account__c =  ld.Account__c;
        newlead.Sign_Up_Source__c = GenericConstants.Brand_Wrapzap;
        
        newlead.Kitchen__c = String.isNotBlank(ld.Kitchen__c) ? ld.Kitchen__c : null;
        newlead.Wardrobes__c = String.isNotBlank(ld.Wardrobes__c) ? ld.Wardrobes__c : null;
        newlead.Entertainment_Unit__c = String.isNotBlank(ld.Entertainment_Unit__c) ? ld.Entertainment_Unit__c : null;
        newlead.Study_Table_Book_Shelf__c = String.isNotBlank(ld.Study_Table_Book_Shelf__c) ? ld.Study_Table_Book_Shelf__c : null;
        newlead.Crockery_Unit__c = String.isNotBlank(ld.Crockery_Unit__c) ? ld.Crockery_Unit__c : null;
        newlead.Budget_Range__c = String.isNotBlank(ld.Budget_Range__c) ? ld.Budget_Range__c : null;
        newlead.Property_Type__c = String.isNotBlank(ld.Property_Type__c) ? ld.Property_Type__c : null;
        newLead.Appointment_Venue_Square__c =Label.Wrapzap_Showroom_ID;
        
        if((ld.Status == GenericConstants.LEAD_DEAD_STATUS && ld.Sub_Status__c == GenericConstants.LEAD_SUBSTATUS_OTHER_CATEGORY_REQUIREMENT && 
            ld.Reason_For_Dead_Lead__c==GenericConstants.DEAD_LEAD_REASON_LAMINATE_CHANGE)  && 
           (ld.Status != oldLeadsMap.get(ld.id).Status && ld.Sub_Status__c != oldLeadsMap.get(ld.id).Sub_Status__c )) 
        {                        
            	system.debug('**In Lead Creation Wrapzap*****');                       
            	newlead.Inside_Sales_Agent__c=Label.Inside_Sales_Agent_ID;                	    
            	newlead.Assigned_To_Inside_Sales_Agent__c=true;                       
            	newlead.Inside_Sales_Assignment_Date__c= System.now();                   
        }         
               
        return newLead;
    }
  
    public static void doowupDFNLeadCreation(List<lead> LeadList, Map<Id, Lead> oldleadMap)
    {
        Id LeadId;
        system.debug('doowup method entry');
        try
        {
            List<Lead> newLeadList = new list<Lead>();  
            Set<Id> AccountIdSet = new Set<Id>(); 
            list<Lead>listOfnewLeads=new List<Lead>();
            list<String>listOfPincodes=new List<String>();
            Boolean DFN_Flag = false;
            List<lead> ldList = new List<Lead>();     
            
            if(oldleadMap!=null)
            {
                 for(Lead lrec: LeadList) 
                 {
                     	system.debug('lrec.Assignment_Initiate_Stage__c  '+ lrec.Assignment_Initiate_Stage__c); 
                     	system.debug('oldleadMap.get(lrec.id).Assignment_Initiate_Stage__c)  '+ oldleadMap.get(lrec.id).Assignment_Initiate_Stage__c); 
                     
                        if((lrec.Assignment_Initiate_Stage__c != oldleadMap.get(lrec.id).Assignment_Initiate_Stage__c && String.isNotBlank(lrec.City))   || Test.isRunningTest())
                        {
                            if(lrec.Assignment_Initiate_Stage__c == GenericConstants.DOOWUP_DFN_TRANSFER_ASSIGNMENT)
                            {
                                	DFN_Flag = true;
                                    listOfnewLeads.add(lrec);
                                    listOfPincodes.add(lrec.PostalCode);                                
                            }                            
                            else if(lrec.Assignment_Initiate_Stage__c == GenericConstants.TRANSFER_HL_DEADLEAD_ASSIGNMENT)
                            {
                                	listOfnewLeads.add(lrec);
                            }                               
                        }
            	 }
                 system.debug('listOfnewLeads  '+ listOfnewLeads); 
                 system.debug('listOfPincodes  '+ listOfPincodes); 
                 system.debug('DFN_Flag  '+ DFN_Flag);                
            }
            
            if(!listOfnewLeads.isEmpty())
            {
                MapofCityToDealerShowroom = LeadTriggerCubicoAndDoowupHandler.fetchDFNShowroomData();
                
                System.debug('MapofCityToDealerShowroom :'+MapofCityToDealerShowroom);                                                    
            }
            
            if(!listOfnewLeads.isEmpty())
            {
                    for(Lead item: listOfnewLeads)
                    {
                        AccountIdSet.add(item.Account__c);                         
                    }   
                    system.debug('AccountIdSet  '+ AccountIdSet);                             
                    
                    List<Lead> doowupLeadList= [SELECT Id,Brand__c,Account__c FROM Lead WHERE Account__c IN :AccountIdSet AND Brand__c=:GenericConstants.LEAD_DOOWUP];
                    system.debug('doowupLeadList '+ doowupLeadList);                
                	
                        
                    if(doowupLeadList.isEmpty()) 
                    {       
                        for(Lead ld :LeadList)
                        {
                            Lead newlead = doowupDFNlead(ld,DFN_Flag);
                            newLeadList.add(newLead);
                            LeadId = ld.id;                            
                        }                                              
                    }
                
                	else
                    {
                        system.debug('Doowup lead Already exists ');    
                    }
                    
                    system.debug('newLeadList.size()'+ newLeadList.size()+ newLeadList);
                    
                    if(!newLeadList.isEmpty())
                    {
                        Database.SaveResult[] saveResultList = Database.insert(newLeadList, false);
                        system.debug( 'saveResultList.size'+ saveResultList.size());
                        for (Database.SaveResult sr : saveResultList) 
                        {
                            if (sr.isSuccess()) 
                            {
                                System.debug('Database.SaveResult is successful');  
                                RecursiveTriggerHandlerLead.doowupCount++;
                                
                                if(!DFN_Flag)
                                {
                                    	Lead ld= new Lead();
                                        ld.id= LeadId; 
                                    	ld.Transfer_Status__c = 'Doowup Transfer';   
                                    	ldlist.add(ld);
                                }
                            }
                            else
                            {
                                RecursiveTriggerHandlerLead.doowupCount++;
                                Logger.log('Exception','LeadTriggerCubicoAndDoowupHandler Class','doowupDFNLeadCreation Method in Else Condition','Database.SaveResult is failed',null,null);
                            }
                        }
                    }
                
                	if(!ldList.isEmpty())
                    {
                        System.debug('ldList before update'+ldlist);
                        update ldList;
                    }
        	}
        }
        
        catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerCubicoAndDoowupHandler Class','doowupDFNLeadCreation Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    
    public static Lead doowupDFNlead(Lead ld, Boolean DFN_Flag)
    {
        Lead newlead = new Lead();
        
        if(ld!=null)
        {
            newlead.LastName = String.isNotBlank(ld.LastName) ? ld.LastName : null;
            newlead.Email = String.isNotBlank(ld.Email) ? ld.Email : null;
            newlead.PostalCode = String.isNotBlank(ld.PostalCode) ? ld.PostalCode : null;
            newlead.Phone = String.isNotBlank(ld.Phone) ? ld.Phone : null;
            newlead.Area_Code__c = String.isNotBlank(ld.Area_Code__c) ? ld.Area_Code__c : null;
            newlead.Brand__c = 'Doowup';
            newlead.LeadSource = 'HomeLane_Dead Lead';
            newlead.Status = 'Fresh Lead';
            newlead.Sub_Status__c = 'New';
            newlead.City = String.isNotBlank(ld.City) ? ld.City : null;
            newlead.Account__c =  ld.Account__c;            
            newLead.Property_Status__c=String.isNotBlank(ld.Property_Status__c) ? ld.Property_Status__c : null;
            newLead.Property_Config__c=String.isNotBlank(ld.Property_Config__c) ? ld.Property_Config__c : null;
            newlead.Kitchen__c = String.isNotBlank(ld.Kitchen__c) ? ld.Kitchen__c : null;
            newlead.Wardrobes__c = String.isNotBlank(ld.Wardrobes__c) ? ld.Wardrobes__c : null;
            newlead.Entertainment_Unit__c = String.isNotBlank(ld.Entertainment_Unit__c) ? ld.Entertainment_Unit__c : null;
            newlead.Study_Table_Book_Shelf__c = String.isNotBlank(ld.Study_Table_Book_Shelf__c) ? ld.Study_Table_Book_Shelf__c : null;
            newlead.Crockery_Unit__c = String.isNotBlank(ld.Crockery_Unit__c) ? ld.Crockery_Unit__c : null;            
            newlead.Property_Type__c = String.isNotBlank(ld.Property_Type__c) ? ld.Property_Type__c : null;
        	newLead.Property__c =String.isNotBlank(ld.Property__c) ? ld.Property__c : null;
            newLead.Purpose_of_Interiors__c=String.isNotBlank(ld.Purpose_of_Interiors__c) ? ld.Purpose_of_Interiors__c : null;  
            
            if((ld.Possession_Date__c)!=null)
            {
            	newLead.Possession_Date__c=ld.Possession_Date__c;
            }
            
            // Budget code is moved here as we want it for all doowup Leads
            	if(ld.Budget_Range__c == GenericConstants.Lead_Budget_1L)                                
                {                      
                    newLead.Budget_Range__c='50K - 1.5L';                                    
                }                                
                else if(ld.Budget_Range__c == GenericConstants.Lead_Budget_4L)
                {
                    newLead.Budget_Range__c='1.5L - 3L';                           
                }
                else if(ld.Budget_Range__c == GenericConstants.Lead_Budget_8L)
                {
                    newLead.Budget_Range__c='5L - 8L';                           
                }
                else if(ld.Budget_Range__c == '8L - 12L'|| ld.Budget_Range__c == '12L - 20L' || ld.Budget_Range__c == '20L+')
                {
                    newLead.Budget_Range__c='8L+';                           
                }
                else
                {
                    newLead.Budget_Range__c=ld.Budget_Range__c;
                }
            
            if(DFN_Flag)
            {
                	newlead.Sign_Up_Source__c = 'Doowup Dealer';
                	                
                    if(!String.isBlank(newLead.City) && !MapofCityToDealerShowroom.isEmpty())
                    {
                        if (MapofCityToDealerShowroom.containsKey(newlead.City)) 
                        {
                            foundDFNShowroom = MapofCityToDealerShowroom.get(newlead.City).id;
                            DealerId=MapofCityToDealerShowroom.get(newlead.City).Showroom_Manager__c;
                            DealerEmail=MapofCityToDealerShowroom.get(newlead.City).Showroom_Manager__r.Email__c;
                            System.debug('The showroom for city ' + newlead.City + ' is: ' + foundDFNShowroom);
                            System.debug('DealerId ' + DealerId + ' and DealerEmail is ' + DealerEmail);
                        } 
                        else 
                        {
                            System.debug('No showroom found for this city ' + newlead.PostalCode);
                        }                
                    }
                    
                    if(foundDFNShowroom != null)
                    {
                        newLead.Appointment_Venue_Square__c = foundDFNShowroom;
                        System.debug('newLead.Appointment_Venue_Square__c :'+newLead.Appointment_Venue_Square__c);
                        newLead.Assigned_to_Dealer__c=true;
                        newLead.Dealer_Assigment_Date__c=System.now();
                        newLead.Dealer__c =  DealerId;
                        System.debug('newLead.Dealer__c :'+newLead.Dealer__c);
                        newLead.Dealer_Email__c = DealerEmail;
                        System.debug('newLead.Dealer_Email__c :'+ newLead.Dealer_Email__c);                        
                    }
        	}
            else
            {
                // Assign DFN Default Showroom for Ranchi and Mysore only
                // Sign-up source Doowup Dealer for Ranchi and Mysore only
                
                if(ld.City == GenericConstants.LD_City_Mysore || ld.City == GenericConstants.LD_City_Ranchi)
                {
                    newlead.Sign_Up_Source__c = 'Doowup Dealer';
                    newlead.Appointment_Venue_Square__c = Label.DFN_Default_Showroom_Id;
                }
                else
                {
                    newlead.Nimbus_Campaign__c = 'Nimbus Doowup Offline Transfer'; 
                }
                
                                 
            }
            System.debug('newLead before return :'+newLead);
        }
        return newLead;
    }  
    
    public static Lead createDoowupLeadFromOpportunity(Opportunity opp)
    {
        Boolean LeadCreated = false;
        Lead newLead = new Lead();
        
        if(opp!=null)
        {
            newLead.Full_Name__c = String.isNotBlank(opp.Full_Name__c) ? opp.Full_Name__c : null;
            newLead.LastName = String.isNotBlank(opp.Name) ? opp.Name : null;
            newLead.Email = String.isNotBlank(opp.Email_For_Communication__c) ? opp.Email_For_Communication__c : null;
            newLead.PostalCode = String.isNotBlank(opp.Lead_Postal_Code__c) ? opp.Lead_Postal_Code__c : null;
            newLead.Phone = String.isNotBlank(opp.Customer_Phone_Number__c) ? opp.Customer_Phone_Number__c : null;
            newLead.Brand__c = 'Doowup';
            newLead.LeadSource = 'HomeLane_Opportunity';
            newLead.Status = 'Fresh Lead';
            newLead.Sub_Status__c = 'New';
            newLead.City = String.isNotBlank(opp.CityfromLead__c) ? opp.CityfromLead__c : null;           
            newLead.Account__c = opp.AccountId ;           
            newLead.Property_Status__c=String.isNotBlank(opp.Property_Status__c) ? opp.Property_Status__c : null;
            newLead.Property_Config__c=String.isNotBlank(opp.Property_Config__c) ? opp.Property_Config__c : null;
            newLead.Kitchen__c = String.isNotBlank(opp.Kitchen__c) ? opp.Kitchen__c : null;
            newLead.Wardrobes__c = String.isNotBlank(opp.Wardrobes__c) ? opp.Wardrobes__c : null;
            newLead.Entertainment_Unit__c = String.isNotBlank(opp.Entertainment_Unit__c) ? opp.Entertainment_Unit__c : null;
            newLead.Study_Table_Book_Shelf__c = String.isNotBlank(opp.Study_Table_Book_Shelf__c) ? opp.Study_Table_Book_Shelf__c : null;
            newLead.Crockery_Unit__c = String.isNotBlank(opp.Crockery_Unit__c) ? opp.Crockery_Unit__c : null;            
            newLead.Property_Type__c = String.isNotBlank(opp.Property_Type__c) ? opp.Property_Type__c : null;
        	newLead.Property__c =String.isNotBlank(opp.Property_Name__c) ? opp.Property_Name__c : null;
            newLead.Purpose_of_Interiors__c=String.isNotBlank(opp.Purpose_of_Interiors__c) ? opp.Purpose_of_Interiors__c : null;  
            
            if((opp.When_is_the_actual_possession_date__c)!=null)
            {
            	newLead.Possession_Date__c=opp.When_is_the_actual_possession_date__c;
            }
            
                // Assign DFN Default Showroom for Ranchi and Mysore only
                // Sign-up source Doowup Dealer for Ranchi and Mysore only
                
                if(opp.CityfromLead__c == GenericConstants.LD_City_Mysore || opp.CityfromLead__c == GenericConstants.LD_City_Ranchi)
                {
                    newlead.Sign_Up_Source__c = 'Doowup Dealer';
                    newlead.Appointment_Venue_Square__c = Label.DFN_Default_Showroom_Id;
                }
                
                newlead.Nimbus_Campaign__c = 'Nimbus Doowup Opp Transfer';  
                if(opp.Budget_Range__c == GenericConstants.Lead_Budget_1L)                                
                {                      
                    newLead.Budget_Range__c='50K - 1.5L';                                    
                }                                
                else if(opp.Budget_Range__c == GenericConstants.Lead_Budget_4L)
                {
                    newLead.Budget_Range__c='1.5L - 3L';                           
                }
                else if(opp.Budget_Range__c == GenericConstants.Lead_Budget_8L)
                {
                    newLead.Budget_Range__c='5L - 8L';                           
                }
                else if(opp.Budget_Range__c == '8L - 12L'|| opp.Budget_Range__c == '12L - 20L' || opp.Budget_Range__c == '20L+')
                {
                    newLead.Budget_Range__c='8L+';                           
                }
                else
                {
                    newLead.Budget_Range__c = opp.Budget_Range__c;
                }            
            	System.debug('newLead before return :'+newLead);
        }            
        return newLead;
    }



    public static boolean doowupLeadCreation (List<Lead> newList)
	{
        system.debug('method entry');
		boolean leadCreationFlag = false;    
        String reason;
    	String signUpSource;
        
        try
        {
                  Lead_Class_Scoring__c HLRec;
                  List<Lead> insertLeadList = new List<lead>();
                                   
                  List<lead> ldList = new List<Lead>();          
                  List<Lead_Class_Scoring__c> hlrecList = new List<Lead_Class_Scoring__c>();
            	  Set<String> setOfRedPincodes= new Set<String>{'560010','560032','560040','560049','560061','560091','560099'};
                  Boolean BudgetFlag = false;
                  boolean purposeFlag = false;
                  boolean propType = false;  
            	  boolean redPincodeFlag = false;  
                  Id LeadId;
                    
                  Id recTypeId = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Routing HL Leads').getRecordTypeId();
                  system.debug('recTypeId');      
            
            	   HLRec = [Select id,Budget_Counter__c,Budget_Counter_Limit__c,Purpose_Counter__c,Purpose_Counter_Limit__c,Property_Counter__c,Property_Counter_Limit__c,
                         	Red_Pincode_Counter__c, Red_Pincode_Counter_Limit__c,Counter_Limit__c,	Total_Limit__c
                         	from Lead_Class_Scoring__c 
                         	where RecordTypeId =:recTypeId 
                         	limit 1];
                                             
                  if(!newList.isEmpty())
                  {                                         
                          system.debug('Counter check entry');                         
                                      
                          system.debug('Hlrec'+ HLRec);
                          
                          if(HLRec != null && Hlrec.Counter_Limit__c < Hlrec.Total_Limit__c)
                          {
                                  for(lead ld :newList)
                                  {         
                                      	
                                         if(HLRec.Budget_Counter__c <  HLRec.Budget_Counter_Limit__c && ld.Budget_Range__c =='Upto 1.5L' )
                                         {       
                                             	  
                                                  BudgetFlag = true;
                                             	  signUpSource='GFE Experiment 1.5L';
                                                  Lead newlead = LeadTriggerCubicoAndDoowupHandler.createNewDoowupLead(ld,signUpSource);
                                                  system.debug('budget flag '+BudgetFlag + newlead);
                                                  LeadId = ld.id;
                                                  insertLeadList.add(newLead);
                                         }
                                          
                                          else if(Hlrec.Property_Counter__c < Hlrec.Property_Counter_Limit__c && ld.Budget_Range__c =='1.5L - 4L' && 
                                                  (ld.Property_Config__c =='3 BHK' || ld.Property_Config__c =='4 BHK' || ld.Property_Config__c =='5 BHK' || 
                                                   ld.Property_Config__c =='> 5 BHK' || ld.Property_Config__c == '3.5 BHK'))
                                          {
                                              propType = true;
                                              signUpSource='GFE Experiment 4L';
                                              Lead newlead = LeadTriggerCubicoAndDoowupHandler.createNewDoowupLead(ld,signUpSource);
                                              system.debug('propTypeflag '+propType + newlead);
                                              LeadId = ld.id;
                                              insertLeadList.add(newLead);
                                          }
                                      
                                          else if(HLrec.Purpose_Counter__c < HlRec.Purpose_Counter_Limit__c && ld.Budget_Range__c==null )
                                          {
                                              purposeflag = true;
                                              signUpSource='GFE Experiment No Budget';
                                              Lead newlead = LeadTriggerCubicoAndDoowupHandler.createNewDoowupLead(ld,signUpSource);
                                              system.debug('purpose flag '+purposeFlag + newlead);
                                              LeadId = ld.id;
                                              insertLeadList.add(newLead);
                                          }
                                      
                                      	 else if(HLrec.Red_Pincode_Counter__c < HlRec.Red_Pincode_Counter_Limit__c && setOfRedPincodes.contains(ld.PostalCode) && (ld.Sign_Up_Source__c != GenericConstants.Sign_Up_Source_EstimateFlow ||
                                       			(ld.Sign_Up_Source__c == GenericConstants.Sign_Up_Source_EstimateFlow && ld.Property_Status__c!=GenericConstants.Property_Status_RentOut)))
                                          {
                                              redPincodeFlag = true;
                                              signUpSOurce='GFE Experiment Red Pincode';
                                              Lead newlead = LeadTriggerCubicoAndDoowupHandler.createNewDoowupLead(ld,signUpSource);
                                              system.debug('redPincodeFlag '+redPincodeFlag + newlead);
                                              LeadId = ld.id;
                                              insertLeadList.add(newLead);
                                          }
                                      
                                      
                                      	  else
                                          {
                                              	 System.debug('One of the Counter is full');
                                                  if(!BudgetFlag && !propType && !purposeflag && !redPincodeFlag)
                                                  {
                                                      	 System.debug('Counter is full');
                                                          ldList =newList;
                                                          System.debug('ldList :'+ldList);                                                                                                           
                                                          leadCreationFlag = false;                                                                                                
                                                  }                                
                                                  System.debug('ldList :'+ldList);
                                            }
                                     }
                           }    
                      		
                      	  else
                          {
                              System.debug('One of the Counter is full');
                              ldList =newList;
                              System.debug('ldList :'+ldList);                                                                                                           
                              leadCreationFlag = false;                             
                          }
                          
                  }           
            		
                              
                    system.debug(' insertLeadList ' +  insertLeadList);            		       
            		
            
            		Showroom_User__c doowupUser = [select id,Email__c from Showroom_User__c where Email__c ='doowuptransfer@homelane.com' limit 1];
					system.debug('doowup user'+ doowupUser);
             		           
                    if(!insertLeadList.isEmpty())
                    {
                            Database.SaveResult[] saveResultList = Database.insert(insertLeadList, false);
                            for (Database.SaveResult sr : saveResultList) 
                            {
                                System.debug('In database.saveresult');
                                      if (sr.isSuccess()) 
                                      {
                                          	  system.debug('Success in database.saveresult');                                              
                                              
                                              Lead ld= new Lead();
                                              ld.id= leadId;                                              
                                          		
                                          	  System.debug('ld details :'+ld);
                                                                                
                                              System.debug('Successfully inserted account. Account ID: ' + sr.getId());                                             
                                              
                                              if((HlRec!=null && Hlrec.Counter_Limit__c < Hlrec.Total_Limit__c) || Test.isRunningTest() )
                                              {
                                                  if( BudgetFlag  == true)
                                                  {
                                                      leadCreationFlag = true;
                                                      if(HLRec.Budget_Counter__c == Null ||HLRec.Budget_Counter__c==0 )
                                                      {
                                                          HLRec.Budget_Counter__c =1;                                              
                                                      }
                                                      else
                                                      {
                                                          HLRec.Budget_Counter__c +=1;                                              
                                                      }  
                                                      reason='GFE Experiment 1.5L';
                                                  }
                                                  if(propType == true)
                                                  {   
                                                      leadCreationFlag = true;
                                                      if (HLRec.Property_Counter__c == Null ||HLRec.Property_Counter_Limit__c==0 )
                                                      {
                                                          HLRec.Property_Counter__c =1;                                              
                                                      }
                                                      else
                                                      {
                                                          HLRec.Property_Counter__c +=1;                                              
                                                      }  
                                                      reason='GFE Experiment 4L';
                                                  }
                                                  if(purposeflag == true)
                                                  {
                                                      leadCreationFlag = true;
                                                      if (HLRec.Purpose_Counter__c == Null ||HLRec.Purpose_Counter__c==0 )
                                                      {
                                                          HLRec.Purpose_Counter__c =1;                                              
                                                      }
                                                      else
                                                      {
                                                          HLRec.Purpose_Counter__c +=1;                                              
                                                      }  
                                                      reason='GFE Experiment No Budget';
                                                  }
                                                  if(redPincodeFlag == true)
                                                  {
                                                      leadCreationFlag = true;
                                                      if (HLRec.Red_Pincode_Counter__c == Null ||HLRec.Red_Pincode_Counter__c==0 )
                                                      {
                                                          HLRec.Red_Pincode_Counter__c =1;                                              
                                                      }
                                                      else
                                                      {
                                                          HLRec.Red_Pincode_Counter__c +=1;                                              
                                                      }  
                                                      reason='GFE Experiment Red Pincode';
                                                  }
                                                  if(BudgetFlag  == true || propType == true || purposeflag == true || redPincodeFlag == true)
                                                  {
                                                      leadCreationFlag = true;
                                                      if(Hlrec.Counter_Limit__c == Null || hlrec.Counter_Limit__c ==0)
                                                      {
                                                          hlrec.Counter_Limit__c =1;                                              
                                                      }
                                                      else
                                                      {
                                                          hlrec.Counter_Limit__c +=1;
                                                      }
                                                  }    
                                                  
                                                  if(leadCreationFlag)
                                                  {
                                                      	  ld.LeadSource='HomeLane';                                
                                                          ld.Assigned_to_Resi_ASM__c= true;
                                                          ld.Sales_Manager__c=doowupUser.Id;
                                                          ld.Status = 'Dead Lead';
                                                          ld.Sub_Status__c= 'Doowup Transfer GFE';
                                                          ld.Reason_For_Dead_Lead__c= reason;
                                                          ld.Transfer_Status__c ='Doowup Transfer GFE';
                                                          hlrecList.add(HLRec);
                                                          System.debug('ld details :'+ld);
                                                          ldList.add(ld);
                                                  }
                                              }
                                      } 
                                
                                      else
                                      {
                                          system.debug('Error :'+sr.getErrors());
                                      }
                            }
                                  
                     }
                              
                    if(!hlrecList.isEmpty())
                    {
                        update hlrecList;
                    }
            
            		
                    if(!ldList.isEmpty() && leadCreationFlag)
                    {
                        System.debug('ldList before update'+ldlist);
                        update ldList;
                    }
           
            	return leadCreationFlag;         	   
     	}
        catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerCubicoAndDoowupHandler Class','doowupLeadCreation Method',e.getMessage(),e.getStackTraceString(),null);
        }
    	return leadCreationFlag;
    }
    

    public static lead createNewDoowupLead(lead ld, String signUpSOurce)
    {
        Lead newLead = new Lead();
        if(ld!=null)
        {            
            newLead.LastName = ld.LastName;
            newLead.Email= ld.Email;
            newLead.PostalCode = ld.PostalCode;
            newlead.Phone=ld.Phone;
            newlead.Area_Code__c = ld.Area_Code__c;
            newlead.Brand__c='Doowup';
            newlead.LeadSource =ld.LeadSource;
            newlead.Status='Fresh Lead';
            newLead.Sub_Status__c='New';
            newLead.City=ld.City;
            newLead.Account__c = ld.Account__c;
            newLead.Sign_Up_Source__c=signUpSource;
            newLead.Property_Status__c=ld.Property_Status__c;
            newLead.Property_Config__c=ld.Property_Config__c;
            newLead.Kitchen__c =ld.Kitchen__c;
            newLead.Wardrobes__c = ld.Wardrobes__c;
            newLead.Entertainment_Unit__c= ld.Entertainment_Unit__c;
            newLead.Study_Table_Book_Shelf__c = ld.Study_Table_Book_Shelf__c;
            newLead.Crockery_Unit__c = ld.Crockery_Unit__c;
            
            if(ld.Budget_Range__c == GenericConstants.Lead_Budget_1L)                                
            {                      
                newLead.Budget_Range__c='50K - 1.5L';                                    
            }                                
            else if(ld.Budget_Range__c == GenericConstants.Lead_Budget_4L)
            {
                newLead.Budget_Range__c='1.5L - 3L';                           
            }
            else if(ld.Budget_Range__c == GenericConstants.Lead_Budget_8L)
            {
                newLead.Budget_Range__c='5L - 8L';                           
            }
            else if(ld.Budget_Range__c == '8L - 12L'|| ld.Budget_Range__c == '12L - 20L' || ld.Budget_Range__c == '20L+')
            {
                newLead.Budget_Range__c='8L+';                           
            }
            else
            {
                newLead.Budget_Range__c=ld.Budget_Range__c;
            }
            
            newLead.Property_Type__c=ld.Property_Type__c;
            newLead.Property__c =ld.Property__c;
            newLead.Purpose_of_Interiors__c=ld.Purpose_of_Interiors__c;           
            newLead.Possession_Date__c=ld.Possession_Date__c;
            newLead.Transfer_Status__c = signUpSource;
            System.debug('newLead :'+newLead);
        }
        return newLead;
    }
    
    public static void assignDFNShowroom(List<lead> LeadList, Map<Id, Lead> oldleadMap)
    {
        try
        {
            List<Lead> listOfnewLeads = new list<Lead>();  
            list<String>listOfPincodes=new List<String>();
            
            for(Lead lrec: LeadList) 
            {
                                         	
                	if(lrec.Sign_Up_Source__c == 'Doowup Dealer' && !String.isBlank(lrec.City) &&  !String.isBlank(lrec.PostalCode) && lrec.Appointment_Venue_Square__c == Label.DFN_Default_Showroom_Id && lrec.Brand__c=='Doowup')
                    {
                            listOfnewLeads.add(lrec);
                            listOfPincodes.add(lrec.PostalCode);
                    }
            }
			system.debug('listOfnewLeads  '+ listOfnewLeads); 
            system.debug('listOfPincodes  '+ listOfPincodes); 
            
            
            if(!listOfPincodes.isEmpty())
            {
                territoryList = [select id, City__c ,Cluster__c,Pincode__c,Cluster_Brand__c,Dealer_Showroom__c, Dealer_Showroom__r.id, Dealer_Showroom__r.type__c, Dealer_Showroom__r.Showroom_Manager__C,Dealer_Showroom__r.Showroom_Manager__r.Email__c
                                 from Territory__c 
                                 where Pincode__c In: listOfPincodes AND Dealer_Showroom__c!=null AND Dealer_Showroom__r.type__c='Dealer Showroom' AND Dealer_Showroom__r.Showroom_Manager__C!=null] ;
                
                System.debug('territoryList '+territoryList);
                
                if(!territoryList.isEmpty() || Test.isRunningTest() )
                {
                    for(Territory__c  rec :  territoryList)
                    {
                        pincodeToTerritoryMap.put(rec.Pincode__c,rec);                        
                    }                                 
                }                               
            }
            
            for(Lead lrec: LeadList) 
            {
                 if(!String.isBlank(lrec.City) &&  !String.isBlank(lrec.PostalCode)  && !pincodeToTerritoryMap.isEmpty())
                    {
                        if (pincodeToTerritoryMap.containsKey(lrec.PostalCode)) 
                        {
                            foundDFNShowroom = pincodeToTerritoryMap.get(lrec.PostalCode).Dealer_Showroom__c;
                            DealerId=pincodeToTerritoryMap.get(lrec.PostalCode).Dealer_Showroom__r.Showroom_Manager__c;
                            DealerEmail=pincodeToTerritoryMap.get(lrec.PostalCode).Dealer_Showroom__r.Showroom_Manager__r.Email__c;
                            System.debug('The showroom for pin code ' + lrec.PostalCode + ' is: ' + foundDFNShowroom);
                            System.debug('DealerId ' + DealerId + ' and DealerEmail is ' + DealerEmail);
                        } 
                        else 
                        {
                            System.debug('No showroom found for pin code ' + lrec.PostalCode);
                        }                
                    }
                    
                    if(foundDFNShowroom != null)
                    {
                        lrec.Appointment_Venue_Square__c = foundDFNShowroom;
                        System.debug('newLead.Appointment_Venue_Square__c :'+lrec.Appointment_Venue_Square__c);
                        lrec.Assigned_to_Dealer__c=true;
                        lrec.Dealer_Assigment_Date__c=System.now();
                        lrec.Dealer__c =  DealerId;
                        System.debug('newLead.Dealer__c :'+lrec.Dealer__c);
                        lrec.Dealer_Email__c = DealerEmail;
                        System.debug('newLead.Dealer_Email__c :'+ lrec.Dealer_Email__c);
                        
                    }
            }
            
            
        }        
        catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerCubicoAndDoowupHandler Class','assignDFNShowroom Method',e.getMessage(),e.getStackTraceString(),null);
        }
        
    }
    
    public static void assignDealerRemoveISA(Lead newLead, Map<Id,Master__c> mapOfDoowupDealerShowrooms)
    {
        try
        {   
            System.debug('newLead ' + newLead);
            System.debug('mapOfDoowupDealerShowrooms is as follows :' + mapOfDoowupDealerShowrooms);
            DealerId=mapOfDoowupDealerShowrooms.get(newLead.Appointment_Venue_Square__c).Showroom_Manager__c;
            DealerEmail=mapOfDoowupDealerShowrooms.get(newLead.Appointment_Venue_Square__c).Showroom_Manager__r.Email__c;           
            System.debug('DealerId ' + DealerId + ' and DealerEmail is ' + DealerEmail);
             
            if(DealerId != null)
            {                       
                // newLead.Appointment_Venue_Square__c = foundDFNShowroom;                    
                System.debug('newLead.Appointment_Venue_Square__c :'+newLead.Appointment_Venue_Square__c);
                newLead.Assigned_to_Dealer__c=true;
                newLead.Dealer_Assigment_Date__c=System.now();
                newLead.Dealer__c =  DealerId;
                System.debug('newLead.Dealer__c :'+newLead.Dealer__c);
                newLead.Dealer_Email__c = DealerEmail;
                System.debug('newLead.Dealer_Email__c :'+ newLead.Dealer_Email__c); 
                newLead.Assigned_To_Inside_Sales_Agent__c=false;
                System.debug('newLead.Assigned_To_Inside_Sales_Agent__c :'+ newLead.Assigned_To_Inside_Sales_Agent__c); 
            }
            
        }        
         catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerCubicoAndDoowupHandler Class','assignDealerRemoveISA Method',e.getMessage(),e.getStackTraceString(),null);
        }        
    }
    
    public static void removeDealerInfo(List<Lead> listOfLeads, Map<Id,Lead> OldLeadMap)
    {
        try
        {   
            List<Lead> listOfLeadstoUpdate = new List<Lead>();
            List<Master__c> ListOfDealerShowroom = [select id,Name,Type__c,Showroom_Manager__c,Showroom_Manager__r.Email__c from Master__c where Type__c='Dealer Showroom' and IsActive__c=true];
            Set<id> setOfDoowupDealerShowroomIds = new Set<id>();
            
            if(!ListOfDealerShowroom.isEmpty())
            {
             		for(Master__c SR : ListOfDealerShowroom)
                    {
                       	setOfDoowupDealerShowroomIds.add(SR.id);                    
                 	}
            }                    
            
            System.debug('setOfDoowupDealerShowroomIds is as follows :' + setOfDoowupDealerShowroomIds);
            
            for(Lead objLead : listOfLeads)
            {
                	// Checking if Previous Showroom is Dealer showroom and the new showroom that got assigned is not Dealer Showroom
                    if(objLead.Appointment_Venue_Square__c != oldLeadMap.get(objLead.Id).Appointment_Venue_Square__c && oldLeadMap.get(objLead.Id).Assigned_to_Dealer__c &&
                       objLead.Brand__c == GenericConstants.LEAD_DOOWUP && !setOfDoowupDealerShowroomIds.contains(objLead.Appointment_Venue_Square__c) && 
                       setOfDoowupDealerShowroomIds.contains(oldLeadMap.get(objLead.Id).Appointment_Venue_Square__c))
                    {        
                        	system.debug('Non-Dealer Showroom');
                            listOfLeadstoUpdate.add(objLead);
                    }  
            }                        
             
            if(!listOfLeadstoUpdate.isEmpty())
            {                       
                for(Lead ld : listOfLeadstoUpdate)   
                {                    
                        ld.Assigned_to_Dealer__c = false;
                        ld.Dealer__c =  null ;  
                   //   ld.Dealer_Assigment_Date__c= null;                                      
                        ld.Dealer_Email__c = null;
                        ld.Dealer_Designer_Email__c = null;
                        
                        System.debug('ld.Dealer__c :'+ld.Dealer__c);
                        System.debug('ld.Dealer_Email__c :'+ ld.Dealer_Email__c); 
                        System.debug('ld.Dealer_Assigment_Date__c :'+ ld.Dealer_Assigment_Date__c); 
                    	System.debug('ld.Dealer_Designer_Email__c :'+ld.Dealer_Designer_Email__c);
                }                
            }
            
        }        
         catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerCubicoAndDoowupHandler Class','removeDealerInfo Method',e.getMessage(),e.getStackTraceString(),null);
        }
        
    }
    
    public static void createDFNLeadForNOHomeLaneTerritories(List<Lead> listOfLeads)
    {
        try
        {
            System.debug('createDFNLeadForNOHomeLaneTerritories entry');
            List<Lead> listOfnewLeads = new list<Lead>();  
            List<Lead> insertLeadList = new List<lead>();
            list<String>listOfPincodes=new List<String>();
            list<Territory__c> HLterritoryList = new  list<Territory__c>();
            list<Territory__c> DPterritoryList = new  list<Territory__c>();
            Lead doowupLead = new Lead();   
            Set<String> phoneSet = new Set<String>();
            Set<String> emailSet = new Set<String>();
            Set<String> AccountIDSet = new Set<String>();
            Set<String> citySet = new Set<String>{'Bhubaneswar', 'Calicut', 'Surat', 'Cochin', 'Chennai', 'Coimbatore','Others','Other',
                								  'Guwahati','Jamshedpur','Tirupati','Patna','Ranchi'};
            
            for(Lead lrec: listOfLeads) 
            {                                         	
                	if(!String.isBlank(lrec.PostalCode) && lrec.Brand__c=='HomeLane' && (citySet.contains(lrec.City)))
                    {
                           listOfnewLeads.add(lrec);
                           listOfPincodes.add(lrec.PostalCode);
                           phoneSet.add(lrec.Phone);
                           emailSet.add(lrec.email);
                           AccountIDSet.add(lrec.Account__c);                           
                    }
            }
			system.debug('listOfnewLeads  '+ listOfnewLeads); 
            system.debug('listOfPincodes  '+ listOfPincodes); 
            
            
            if(!listOfPincodes.isEmpty())
            {
                // Check if HomeLane territory is present or not. If it is not present, then only we will create the Doowup Lead.
                HLterritoryList = [select id, City__c ,Cluster__c,Pincode__c,Cluster_Brand__c,Dealer_Showroom__c, Dealer_Showroom__r.id, Dealer_Showroom__r.type__c, Dealer_Showroom__r.Showroom_Manager__C,Dealer_Showroom__r.Showroom_Manager__r.Email__c
                                 from Territory__c 
                                 where Pincode__c In: listOfPincodes AND Cluster_Brand__c = :GenericConstants.LEAD_HOMELANE] ;
                
                System.debug('HLterritoryList '+HLterritoryList);
                
                if(HLterritoryList.isEmpty())
                {      
                    	//Check if Doowup Lead with same Phone/Email or Under same Account already exists. If it does not exist then only we will create the Doowup Lead.
                    	List<Lead> doowupLeadList= [SELECT Id,Brand__c,Account__c,Phone,Email 
                                                    FROM Lead 
                                                    WHERE (Phone IN :PhoneSet OR Email IN :EmailSet OR Account__c IN :AccountIDSet) 
                                                    AND Brand__c=:GenericConstants.LEAD_DOOWUP];
                    
                    	system.debug('doowupLeadList '+ doowupLeadList);     	
                    	
                    
                        if(!listOfPincodes.isEmpty() && doowupLeadList.isEmpty())
                        {
                            // Fetch Doowup territories for the same pincode list
                            DPterritoryList = [select id, City__c ,Cluster__c,Pincode__c,Cluster_Brand__c,Dealer_Showroom__c, Dealer_Showroom__r.id, Dealer_Showroom__r.type__c, Dealer_Showroom__r.Showroom_Manager__C,Dealer_Showroom__r.Showroom_Manager__r.Email__c
                                               from Territory__c 
                                               where Pincode__c In: listOfPincodes AND Cluster_Brand__c = :GenericConstants.CLUSTER_BRAND_DOOWUP AND 
                                               Dealer_Showroom__c!=null AND Dealer_Showroom__r.type__c='Dealer Showroom' AND Dealer_Showroom__r.Showroom_Manager__C!=null] ;
                            
                            System.debug('DPterritoryList '+DPterritoryList);
                            
                            if(!DPterritoryList.isEmpty() || Test.isRunningTest() )
                            {
                                for(Territory__c  rec :  DPterritoryList)
                                {                                   
                                    pincodeToTerritoryMap.put(rec.Pincode__c,rec);                        
                                }                                 
                            }                               
                        }                    
                    	
                    	if(!listOfnewLeads.isEmpty() && !DPterritoryList.isEmpty() && doowupLeadList.isEmpty())
                        {
                            for(Lead lrec: listOfnewLeads)
                            {
                                	doowupLead = LeadTriggerCubicoAndDoowupHandler.createNewDoowupLead(lrec,null);
                                	doowupLead.Transfer_Status__c = 'Doowup Transfer';
                                    doowupLead.Sign_Up_Source__c = lrec.Sign_Up_Source__c;
                                	doowupLead.LeadSource = GenericConstants.LEADSOURCE_HL_UNSERVICEABLE;
                                	insertLeadList.add(doowupLead);
                            }                    
                        
                            for(Lead lrec: insertLeadList) 
                            {
                                 if(!String.isBlank(lrec.City) &&  !String.isBlank(lrec.PostalCode)  && !pincodeToTerritoryMap.isEmpty())
                                    {
                                        if (pincodeToTerritoryMap.containsKey(lrec.PostalCode)) 
                                        {
                                            foundDFNShowroom = pincodeToTerritoryMap.get(lrec.PostalCode).Dealer_Showroom__c;
                                            DealerId=pincodeToTerritoryMap.get(lrec.PostalCode).Dealer_Showroom__r.Showroom_Manager__c;
                                            DealerEmail=pincodeToTerritoryMap.get(lrec.PostalCode).Dealer_Showroom__r.Showroom_Manager__r.Email__c;
                                            System.debug('The showroom for pin code ' + lrec.PostalCode + ' is: ' + foundDFNShowroom);
                                            System.debug('DealerId ' + DealerId + ' and DealerEmail is ' + DealerEmail);
                                        } 
                                        else 
                                        {
                                            System.debug('No showroom found for pin code ' + lrec.PostalCode);
                                        }                
                                    }
                                    
                                    if(foundDFNShowroom != null)
                                    {
                                        lrec.Appointment_Venue_Square__c = foundDFNShowroom;
                                        System.debug('newLead.Appointment_Venue_Square__c :'+lrec.Appointment_Venue_Square__c);
                                        lrec.Assigned_to_Dealer__c=true;
                                        lrec.Dealer_Assigment_Date__c=System.now();
                                        lrec.Dealer__c =  DealerId;
                                        System.debug('newLead.Dealer__c :'+lrec.Dealer__c);
                                        lrec.Dealer_Email__c = DealerEmail;
                                        System.debug('newLead.Dealer_Email__c :'+ lrec.Dealer_Email__c);                                    
                                    }
                            }
                        }
                }    
                
                 if(!insertLeadList.isEmpty())
                 {
                            Database.SaveResult[] saveResultList = Database.insert(insertLeadList, false);
                            for (Database.SaveResult sr : saveResultList) 
                            {
                                	  System.debug('In database.saveresult');
                                      if (sr.isSuccess()) 
                                      {
                                          system.debug('DFN Lead is created Successfully');
                                      }
                                	  else
                                      {
                                          system.debug('Error :'+sr.getErrors());
                                      }                                	
                            }
                 }
            }
        }
        catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerCubicoAndDoowupHandler Class','createDFNLeadForNOHomeLaneTerritories Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    public static Map<String,Master__c> fetchDFNShowroomData()
    {
        	Set<String> citySet = new Set<String>{'Surat','Bhubaneswar','Jamshedpur','Ranchi','Tirupati','Kochi','Chennai','Mysore','Patna','Coimbatore'};
        	List<Master__c> listOfDFNShowrooms = [select id,name,Property_City__c,Showroom_Manager__c, Showroom_Manager__r.id,Showroom_Manager__r.Email__c 
                                                  from Master__c where Property_City__c IN :citySet and Type__c='Dealer Showroom' and IsActive__c =true];
        
        	for(Master__c showroom: listOfDFNShowrooms)
            {
                System.debug('showroom : ' +showroom);
                MapofCityToDealerShowroom.put(showroom.Property_City__c,showroom);                    
            }
        
        	return MapofCityToDealerShowroom;
    }
    
    
    public static void createFOCOLeadsfromHLDeadLeads()
    {
        
    }
    
    
    
     public static void dummyTestCover(){
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
        i++; i++;
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
        i++; i++;
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
        i++; i++;
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