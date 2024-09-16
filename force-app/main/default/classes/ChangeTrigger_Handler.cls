/**
* @File Name          : ChangeTrigger_Handler.cls
* @Description        : 
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 10/15/2019, 12:18:52 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0    10/15/2019, 12:14:59 PM   Bharatesh Shetty     Initial Version
**/
Public class ChangeTrigger_Handler{
    
    /**
* @description | Method to handle lead related change events
* @author Bharatesh Shetty | 10/15/2019
* @param list<LeadChangeEvent> lstLeadChangeEvent
* @return void
*/
    public Static void leadchangeEvent(list<LeadChangeEvent> lstLeadChangeEvent){
        
        Set<String> lstEvent = new Set<String>();
        // Map of record Id and set of it's related WebEngageEvents.
        Map<String,Set<String>> mapWebEngageEvent = new Map<String,Set<String>>();  
        WebEngageDetailsWrapper objWrapper = new WebEngageDetailsWrapper(); 
        // Map of SF fields and the set of WebEngage Events the field can trigger.
        Map<String,Set<String>> mapFieldNameandSetofEvent = new Map<String,Set<String>>();
        
        if(!lstLeadChangeEvent.isEmpty()){
            
            objWrapper = ChangeTrigger_Handler.getEventDetails('Lead');
            
            mapFieldNameandSetofEvent = objWrapper.mapFieldNameandSetofEvent;
            
            // Loop through the leadChangeEvents
            for (LeadChangeEvent event : lstLeadChangeEvent) {
                EventBus.ChangeEventHeader header = event.ChangeEventHeader;
                system.debug('header*********'+header);
                // Logic to handle lead create scenario
                if(header !=null){
                    if(header.changetype =='CREATE'){
                        for(String leadId : header.getRecordIds()){
                            mapWebEngageEvent.put(leadId,new set<String>{'Lead Created'});
                        }
                    }
                    else{
                        // Get the list of changed fields from LeadChangeEvent's ChangeEventHeader.
                        list<String> lstChangedFields = header.getChangedFields();
                        // Loop through the changed fields.
                        for(String sfieldChange : lstChangedFields){
                            // lstEvent check is to prevent the processing of same Events related to the same field multiple times.
                            if(mapFieldNameandSetofEvent.containsKey(sfieldChange) && (!lstEvent.containsAll(mapFieldNameandSetofEvent.get(sfieldChange)))){
                                lstEvent.addall(mapFieldNameandSetofEvent.get(sfieldChange));
                                // Loop through the records ids from LeadChangeEvent's ChangeEventHeader.
                                for(String leadId : header.getRecordIds()){
                                    if(mapWebEngageEvent.containsKey(leadId)){
                                        //If the record id is already present add all the events to the map's value.
                                        mapWebEngageEvent.get(leadId).addall(mapFieldNameandSetofEvent.get(sfieldChange));     
                                    }else{
                                        //If the record id is not present put a new key value pair to the map.
                                        mapWebEngageEvent.put(leadId,mapFieldNameandSetofEvent.get(sfieldChange));
                                    }
                                }
                            }
                        }
                    }
                }
                
                lstEvent.clear();
                system.debug('lstEvent*********'+lstEvent);
                system.debug('mapWebEngageEvent*********'+mapWebEngageEvent);
            }
            
            if(!mapWebEngageEvent.isEmpty()){
                // Call removeDuplicateWebEngageTasks method prevent the creation of duplicate WebEngage Task object records.
                mapWebEngageEvent = removeDuplicateWebEngageTasks(mapWebEngageEvent,'Lead');
                if(!mapWebEngageEvent.isEmpty()){
                    //Call createNewWebEngage method to creat new WebEngage Task object records after duplicate check.
                    ChangeTrigger_Handler.createNewWebEngage('Lead',mapWebEngageEvent,objWrapper.mapEventNameandEventType);
                }
            }
        }       
    }
    
    /**
* @description | Method to handle Opportunity related change events
* @author Bharatesh Shetty | 10/15/2019
* @param list<OpportunityChangeEvent> lstOpportunityChangeEvent
* @return void
*/
    Public Static void OpportunitychangeEvent(list<OpportunityChangeEvent> lstOpportunityChangeEvent){
        
        Set<String> lstEvent = new Set<String>();
        // Map of record Id and set of it's related WebEngageEvents.
        Map<String,Set<String>> mapWebEngageEvent = new Map<String,Set<String>>();     
        WebEngageDetailsWrapper objWrapper = new WebEngageDetailsWrapper();
        // Map of SF fields and the set of WebEngage Events the field can trigger.
        Map<String,Set<String>> mapFieldNameandSetofEvent = new Map<String,Set<String>>();
        
        if(!lstOpportunityChangeEvent.isEmpty()){
            
            objWrapper = ChangeTrigger_Handler.getEventDetails('Opportunity');
            
            mapFieldNameandSetofEvent = objWrapper.mapFieldNameandSetofEvent;
            // Loop through the OpportunityChangeEvent
            for (OpportunityChangeEvent event : lstOpportunityChangeEvent) {
                EventBus.ChangeEventHeader header = event.ChangeEventHeader;
                system.debug('header*********'+header);
                // Logic to handle Opportunity create scenario
                if(header !=null){
                    if(header.changetype =='CREATE'){
                        for(String oppId : header.getRecordIds()){
                            mapWebEngageEvent.put(oppId,new set<String>{'New Opportunity is Created'});
                        }
                    }
                    else{
                        // Get the list of changed fields from OpportunityChangeEvent's ChangeEventHeader.
                        list<String> lstChangedFields = header.getChangedFields();
                        // Loop through the changed fields.
                        for(String sfieldChange : lstChangedFields){
                            // lstEvent check is to prevent the processing of same Events related to the same field multiple times.
                            if(mapFieldNameandSetofEvent.containsKey(sfieldChange) && (!lstEvent.containsAll(mapFieldNameandSetofEvent.get(sfieldChange)))){
                                lstEvent.addall(mapFieldNameandSetofEvent.get(sfieldChange));
                                // Loop through the records ids from LeadChangeEvent's ChangeEventHeader.
                                for(String oppId : header.getRecordIds()){
                                    if(mapWebEngageEvent.containsKey(oppId)){
                                        //If the record id is already present add all the events to the map's value.
                                        mapWebEngageEvent.get(oppId).addall(mapFieldNameandSetofEvent.get(sfieldChange));     
                                    }else{
                                        //If the record id is not present put a new key value pair to the map.
                                        mapWebEngageEvent.put(oppId,mapFieldNameandSetofEvent.get(sfieldChange));
                                    }
                                }
                            }
                        }
                    }
                }
                
                lstEvent.clear();
                system.debug('lstEvent*********'+lstEvent);
                system.debug('mapWebEngageEvent*********'+mapWebEngageEvent);
            }
            
            if(!mapWebEngageEvent.isEmpty()){
                // Call removeDuplicateWebEngageTasks method prevent the creation of duplicate WebEngage Task object records.
                mapWebEngageEvent = removeDuplicateWebEngageTasks(mapWebEngageEvent,'Opportunity');
                if(!mapWebEngageEvent.isEmpty()){
                    //Call createNewWebEngage method to creat new WebEngage Task object records after duplicate check.
                    ChangeTrigger_Handler.createNewWebEngage('Opportunity',mapWebEngageEvent,objWrapper.mapEventNameandEventType);
                }
            }
        }       
    }
    
    /**
* @description | Method to get the event relted details
* @author Bharatesh Shetty | 10/15/2019
* @param String objectName
* @return WebEngageDetailsWrapper
*/
    Public Static WebEngageDetailsWrapper getEventDetails(String objectName){
        // Map of SF fields and the set of WebEngage Events the field can trigger.
        Map<String,Set<String>> mapFieldNameandSetofEvent = new Map<String,Set<String>>();
        // Map of Name of the Event and it's type (User or Change).
        Map<String,String> mapEventNameandEventType = new Map<String,String>();
        
        if(String.isNotBlank(objectName)){
            // Query to fetch list of WebEngage_FieldTrigger__mdt metadata records filtered by SobjectName__c field value.
            list<WebEngage_FieldTrigger__mdt>  lstWebEngageTrigger = [Select id,Field_Api_Name__c,WebEngage_Event_Name__r.Event_Name__C,SobjectName__c,
                                                                      WebEngage_Event_Name__r.Type__c
                                                                      from WebEngage_FieldTrigger__mdt
                                                                      Where SobjectName__c =: objectName ];
            
            system.debug('------lstWebEngageTrigger------'+lstWebEngageTrigger);   
            // Loop through WebEngage_FieldTrigger__mdt records and construct mapEventNameandEventType and mapFieldNameandSetofEvent.
            for(WebEngage_FieldTrigger__mdt obj : lstWebEngageTrigger){
                mapEventNameandEventType.put(obj.WebEngage_Event_Name__r.Event_Name__C,obj.WebEngage_Event_Name__r.Type__c);
                if(mapFieldNameandSetofEvent.containsKey(obj.Field_Api_Name__c)){
                    mapFieldNameandSetofEvent.get(obj.Field_Api_Name__c).add(obj.WebEngage_Event_Name__r.Event_Name__C);
                }else{
                    mapFieldNameandSetofEvent.put(obj.Field_Api_Name__c,new Set<String>{obj.WebEngage_Event_Name__r.Event_Name__C});
                }
            }  
            
            if(!mapFieldNameandSetofEvent.isEmpty()){
                // Construct the WebEngageDetailsWrapper and return the same.
                WebEngageDetailsWrapper objWrapper = new WebEngageDetailsWrapper();  
                objWrapper.mapFieldNameandSetofEvent = mapFieldNameandSetofEvent; 
                objWrapper.mapEventNameandEventType = mapEventNameandEventType;
                return objWrapper;
                
            }
            system.debug('------mapFieldNameandListofEvent------'+mapFieldNameandSetofEvent);
            return null;                                                    
        }
        return null;
    }
    
    /**
* @description | Method to create new webEngageTask record.
* @author Bharatesh Shetty | 10/15/2019
* @param String sObjectName
* @param Map<String, Set<String>> mapWebEngageEvent
* @param Map<String, String> mapEventNameandEventType
* @return void
*/
    public Static void createNewWebEngage(String sObjectName,Map<String,Set<String>> mapWebEngageEvent,Map<String,String> mapEventNameandEventType){
        
        String sObjectFieldName;
        // List of WebEngageTask records to insert.
        list<WebEngage_Task__c> lstWebEngage = new list<WebEngage_Task__c>();
        List<Lead> ldList = new List<Lead>();
        List<Opportunity>  oppList=new List<Opportunity> ();
        Set<id> idSet = new Set<id>();
        if(String.isNotBlank(sObjectName) && !mapWebEngageEvent.isEmpty()){
            try{
                
                for(String objectId : mapWebEngageEvent.keySet()){
                    idSet.add(objectId);
                }
                if(sObjectName =='Lead'){
                     ldList = [select id ,Brand__c from Lead where id in:idSet];
                }else{
                     oppList=[select id ,Brand__c from Opportunity where id in:idSet];
                }
               map<String,String> mapOfLeadandBrand =new map<String,String>();
                map<String,String> mapOfOppandBrand= new map<String,String>();
                system.debug('ldList'+ldList);
                if(!ldList.isEmpty()){
                    for(lead ld:ldList){
                        mapOfLeadandBrand.put(ld.id,ld.Brand__c);
                    }
                    
                }
                if(!oppList.isEmpty()){
                    for(Opportunity opp:oppList){
                        mapOfOppandBrand.put(opp.id, opp.Brand__c);
                    }
                }
                System.debug('mapOfLeadandBrand');
                sObjectFieldName = sObjectName == 'Lead'?'Lead__c':'Opportunity__c';
                
                // Loop through all the reocord Ids in the mapWebEngageEvent's key set.
                for(String objectId : mapWebEngageEvent.keySet()){
                    // For each of the Events in the set of Events related to each record Id create a new WebEngageTask instance.
                    for(String sEventName : mapWebEngageEvent.get(objectId)){
                        WebEngage_Task__c objWebEngage = new WebEngage_Task__c();
                        objWebEngage.put(sObjectFieldName,objectId);
                        objWebEngage.put('Name',sEventName);
                        objWebEngage.put('Type__c',mapEventNameandEventType.containsKey(sEventName)?mapEventNameandEventType.get(sEventName):'');
                        if(objectId.startsWithIgnoreCase(genericConstants.OPPORTUNITY_ID)){
                            if(String.isNotBlank(mapOfOppandBrand.get(objectId))){
                              objWebEngage.Brand__c = mapOfOppandBrand.get(objectId); 
                            }else{
                               objWebEngage.Brand__c='HomeLane'; 
                            }
                        }
                        else if(objectId.startsWithIgnoreCase(genericConstants.LEAD_ID)){
                            if(String.isNotBlank(mapOfLeadandBrand.get(objectId))){
                            objWebEngage.Brand__c =mapOfLeadandBrand.get(objectId);
                        }else{
                            objWebEngage.Brand__c='HomeLane';
                        }
                        }
                        
                       
                        lstWebEngage.add(objWebEngage);
                    }
                }
                if(!lstWebEngage.isEmpty()){
                    // Insert the list of WebEngage Task records.
                    insert lstWebEngage;
                }
            }
            catch(Exception e){
                
            }
        }
    }
    /**
* @description | Method to handle and remove and prevent duplicate events from being created
* @author Bharatesh Shetty | 10/15/2019
* @param Map<String, Set<String>> mapFieldNameAndSetofEvent
* @param String objectName
* @return Map<String, Set<String>>
*/
    Public Static Map<String,Set<String>> removeDuplicateWebEngageTasks(Map<String,Set<String>> mapFieldNameAndSetofEvent, String objectName){
        // Map of SF fields and the set of WebEngage Events the field can trigger to return. 
        Map<String,Set<String>> resultMapFieldNameandSetofEvent = new Map<String,Set<String>>();
        try{
            if(!mapFieldNameAndSetofEvent.isEmpty() && !string.isBlank(objectName)){
                // Map of SF fields and the set of WebEngage Events the field can trigger to store existing records in DB.
                Map<String,Set<String>> existingMapFieldNameandSetofEvent = new Map<String,Set<String>>();
                // List of Existing WebEngageTasks in DB.
                List<WebEngage_Task__c> listOfExistingWebEngageTasks = new List<WebEngage_Task__c>();
                // Set of Record Ids (either Lead id or Opportunity Id).
                Set<String> setOfIds = mapFieldNameAndSetofEvent.keySet();
                // Construct the query string accordingly based on the object name.
                String queryString ='Select id,Name, Status__c,Lead__c,Opportunity__c,Type__c,CreatedDate from WebEngage_Task__c where Status__c!=\'Closed\'';
                if(objectName =='Lead'){
                    queryString += ' and Lead__c=:setOfIds';
                }
                else if(objectName =='Opportunity'){
                    queryString += ' and Opportunity__c=:setOfIds';
                }
                System.debug('queryString: '+queryString);
                // Query to fetch the WeBengage task records.
                listOfExistingWebEngageTasks = Database.query(queryString);
                if(!listOfExistingWebEngageTasks.isEmpty()){
                    // Loop through the Webenage Task records.
                    for(WebEngage_Task__c webEngTask : listOfExistingWebEngageTasks){
                        // Construct existingMapFieldNameandSetofEvent map for Lead. 
                        if(objectName =='Lead' && webEngTask.Lead__c!=null){
                            if(existingMapFieldNameandSetofEvent.containsKey(webEngTask.Lead__c)){
                                existingMapFieldNameandSetofEvent.get(webEngTask.Lead__c).add(webEngTask.Name);
                            }
                            else{
                                existingMapFieldNameandSetofEvent.put(webEngTask.Lead__c,new Set<String>{webEngTask.Name});
                            }
                        }
                        // Construct existingMapFieldNameandSetofEvent map for Opportunity. 
                        else if(objectName =='Opportunity' && webEngTask.Opportunity__c!=null){
                            if(existingMapFieldNameandSetofEvent.containsKey(webEngTask.Opportunity__c)){
                                existingMapFieldNameandSetofEvent.get(webEngTask.Opportunity__c).add(webEngTask.Name);
                            }
                            else{
                                existingMapFieldNameandSetofEvent.put(webEngTask.Opportunity__c,new Set<String>{webEngTask.Name});
                            }
                        }
                    }
                    if(!existingMapFieldNameandSetofEvent.isEmpty()){
                        // Loop through the existing records map.
                        for(String recordId :mapFieldNameAndSetofEvent.keySet()){
                            if(existingMapFieldNameandSetofEvent.containsKey(recordId)){
                                // Loop through all the events related to the record id if it already exists in the DB.
                                for(String eventName: mapFieldNameAndSetofEvent.get(recordId)){
                                    if(existingMapFieldNameandSetofEvent.get(recordId).contains(eventName)){
                                        // Skip the event if it is already exists in DB.
                                        continue; 
                                    }
                                    else{
                                        // Add the event related to the recordId if it not exists in the DB.
                                        if(resultMapFieldNameandSetofEvent.containsKey(recordId)){
                                            resultMapFieldNameandSetofEvent.get(recordId).add(eventName);
                                        }
                                        else{
                                            resultMapFieldNameandSetofEvent.put(recordId,new Set<String>{eventName});
                                        }
                                    }
                                }
                            }
                            else{
                                // Put the recordId and the set of all events related to the reocrd Id if the recordId doesn't exist
                                // in already existing records.
                                resultMapFieldNameandSetofEvent.put(recordId,mapFieldNameAndSetofEvent.get(recordId));
                            }
                        }
                    }
                }
                else{
                    // assign the input map to return map if there's no WebEngage records in DB meeting query condition.
                    resultMapFieldNameandSetofEvent = mapFieldNameAndSetofEvent;
                }
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception','ChangeTrigger_Handler class','removeDuplicateWebEngageTasks method',e.getMessage(),e.getStackTraceString(),null);
        }
        return resultMapFieldNameandSetofEvent;
    }
    public class WebEngageDetailsWrapper{
        Public Map<String,Set<String>> mapFieldNameandSetofEvent;
        Public Map<String,String> mapEventNameandEventType;
    } 
    Public Class EventWrapper{
        Public String userId;
        Public String eventName;
        Public String eventTime;
        Public Map<String,String> eventData;
    }
    Public class WebEngageEventWrapper{
        Public List<EventWrapper> events;
    }
}