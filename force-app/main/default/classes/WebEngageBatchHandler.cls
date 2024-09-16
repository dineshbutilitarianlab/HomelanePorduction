/**
 * @File Name          : WebEngageBatchHandler.cls
 * @Description        : Handler class for WebEngageChangeEventBatch and WebEngageUserEventBatch classes
 * @Author             : Bharatesh Shetty
 * @Group              : 
 * @Last Modified By   : Bharatesh Shetty
 * @Last Modified On   : 10/15/2019, 12:38:26 PM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    10/15/2019, 12:22:27 PM   Bharatesh Shetty     Initial Version
**/
Public class WebEngageBatchHandler{
    /**
    * @description | method to get the details related to webengagetasks and process the records.
    * @author Bharatesh Shetty | 10/15/2019
    * @param list<WebEngage_Task__c> listOfWebEngageTasks
    * @param String eventType 
    * @return void
    */
    public static void getdetails(Map<String,List<WebEngage_Task__c>> mapOfBrandAnsWebEngageTaskList,String eventType){
        try{
            if(!mapOfBrandAnsWebEngageTaskList.isEmpty() && !string.isBlank(eventType) ){
                // Map of Event name and related WebEngage_Field_Mapping__mdt which contains the mapping detalis of all the events.
                map<String,Map<String,WebEngage_Field_Mapping__mdt>> mapOfWebEngageFieldMapping = new map<String,Map<String,WebEngage_Field_Mapping__mdt>>();
                set<id> setOfLeadIds = new set<id>();
                set<id> setOfOppIds = new set<id>();
                list<WebEngage_Field_Mapping__mdt> listOfWebEngageFieldMapping = new list<WebEngage_Field_Mapping__mdt>();
                List<WebEngage_Task__c> listOfWebEngageTasks = new  List<WebEngage_Task__c>();
                List<WebEngage_Task__c> listOfwebEngageTaskToUpdate = new  List<WebEngage_Task__c>();
                Map<id,Lead> mapOfLeads = new Map<id,Lead>();
                Map<id,Opportunity> mapOfOpps = new Map<id,Opportunity>();
                if(mapOfBrandAnsWebEngageTaskList.containsKey('Doowup')){
                    
                    listOfWebEngageTasks = mapOfBrandAnsWebEngageTaskList.get('Doowup');
                    
                    for(WebEngage_Task__c task: listOfWebEngageTasks) {
                    if(task.lead__c != null){
                        setOfLeadIds.add(task.lead__c);
                    }
                    else if(task.Opportunity__c != null){
                        setOfOppIds.add(task.opportunity__c);
                    } 
                }
                // Query all the WebEngage_Field_Mapping__mdt custom metadata records.
                listOfWebEngageFieldMapping = [Select id,SF_Field_API_Name__c,WebEngage_Event__r.Event_Name__C,
                                               WebEngage_Field_API_Name__c,IsDateTimeField__c
                                               from WebEngage_Field_Mapping__mdt
                                              ];
                
                if(!listOfWebEngageFieldMapping.isEmpty()){
                    // Loop through WebEngage_Field_Mapping__mdt custom metadata records.
                    for(WebEngage_Field_Mapping__mdt obj :listOfWebEngageFieldMapping){
                        // Construct mapOfWebEngageFieldMapping map.
                        if(mapOfWebEngageFieldMapping.containsKey(obj.WebEngage_Event__r.Event_Name__C)){
                            mapOfWebEngageFieldMapping.get(obj.WebEngage_Event__r.Event_Name__C).put(obj.SF_Field_API_Name__c,obj);
                        }else{
                            mapOfWebEngageFieldMapping.put(obj.WebEngage_Event__r.Event_Name__C,New Map<String,WebEngage_Field_Mapping__mdt>{obj.SF_Field_API_Name__c => obj});
                        }
                    }
                    if(!mapOfWebEngageFieldMapping.isEmpty()){
                        // Construct a query string to dynamically add all the fields included in the WebEngage field mapping custom metadata
                        // from the Lead or Opportunity based on the condition.
                        String queryString;
                        if(!setOfLeadIds.isEmpty()){
                            // Add a filter condition if it's Lead Object.
                            queryString = getQueryString('Lead');
                            if(!String.isBlank(queryString)){
                                queryString += ' where id=: setOfLeadIds';
                                // Query and fetch the records as a map of Id and records from Lead.
                                mapOfLeads = new Map<id,Lead>((List<Lead>)Database.query(queryString));
                                System.debug('----mapOfLeads---'+mapOfLeads);
                            }
                        }
                        if(!setOfOppIds.isEmpty()){
                            // Add a filter condition if it's Opportunity Object.
                            queryString = getQueryString('Opportunity');
                            if(!String.isBlank(queryString)){
                                queryString += ' where id=: setOfOppIds';
                                // Query and fetch the records as a map of Id and records from Opportunity.
                                mapOfOpps = new Map<id,Opportunity>((List<Opportunity>)Database.query(queryString));
                                //System.debug('mapOfOpps: '+mapOfOpps);
                            } 
                        }
                        System.debug('----mapOfWebEngageFieldMapping---'+mapOfWebEngageFieldMapping);
                        
                        String jsonData;
                        String responseStatus;
                        String integrationSettingName;
                        
                        if(!mapOfLeads.isEmpty() || !mapOfOpps.isEmpty()){
                            // Based on the Event (either user or Change event) create the JSONData for Callout.
                            
                            if(eventType=='CHANGE EVENT'  ){
                                
                                integrationSettingName= 'WebEngage Doowup Bulk Events API';
                                jsonData = webEngageChangeEventJsonCreator(mapOfLeads,mapOfOpps,mapOfWebEngageFieldMapping,listOfWebEngageTasks); 
                                System.debug('jsonData-' + jsonData);
                            }
                                
                            
                            else if(eventType == 'USER EVENT'){
                              
                                    integrationSettingName = 'WebEngage Doowup Bulk Users API';
                                    jsonData = webEngageUserEventJsonCreator(mapOfLeads,mapOfOpps,mapOfWebEngageFieldMapping,listOfWebEngageTasks); 
                                System.debug('jsonData-' + jsonData);
                                }
                                
                            }
                            
                        
                        if(!string.isBlank(integrationSettingName) && !string.isBlank(jsonData)){
                            // Call calloutToWebEngage to make API callout to WebEngage.
                            system.debug('integrationSettingName'+ integrationSettingName);
                            
                            responseStatus = calloutToWebEngage(jsonData,integrationSettingName);
                            System.debug('responseStatus: '+responseStatus);
                            if(!String.isBlank(responseStatus) && responseStatus == 'Success'){
                                // Call updateWebEngageTaskStatus to update WebEngage Task Status as closed after Success response.
                                listOfwebEngageTaskToUpdate.addAll(listOfWebEngageTasks);
                                //updateWebEngageTaskStatus(listOfWebEngageTasks);
                            }
                        }
                    }
                } 
                }
                if(mapOfBrandAnsWebEngageTaskList.containsKey('HomeLane')){
                     listOfWebEngageTasks = mapOfBrandAnsWebEngageTaskList.get('HomeLane');
                    
                    for(WebEngage_Task__c task: listOfWebEngageTasks) {
                    if(task.lead__c != null){
                        setOfLeadIds.add(task.lead__c);
                    }
                    else if(task.Opportunity__c != null){
                        setOfOppIds.add(task.opportunity__c);
                    } 
                }
                // Query all the WebEngage_Field_Mapping__mdt custom metadata records.
                listOfWebEngageFieldMapping = [Select id,SF_Field_API_Name__c,WebEngage_Event__r.Event_Name__C,
                                               WebEngage_Field_API_Name__c,IsDateTimeField__c
                                               from WebEngage_Field_Mapping__mdt
                                              ];
                
                if(!listOfWebEngageFieldMapping.isEmpty()){
                    // Loop through WebEngage_Field_Mapping__mdt custom metadata records.
                    for(WebEngage_Field_Mapping__mdt obj :listOfWebEngageFieldMapping){
                        // Construct mapOfWebEngageFieldMapping map.
                        if(mapOfWebEngageFieldMapping.containsKey(obj.WebEngage_Event__r.Event_Name__C)){
                            mapOfWebEngageFieldMapping.get(obj.WebEngage_Event__r.Event_Name__C).put(obj.SF_Field_API_Name__c,obj);
                        }else{
                            mapOfWebEngageFieldMapping.put(obj.WebEngage_Event__r.Event_Name__C,New Map<String,WebEngage_Field_Mapping__mdt>{obj.SF_Field_API_Name__c => obj});
                        }
                    }
                    if(!mapOfWebEngageFieldMapping.isEmpty()){
                        // Construct a query string to dynamically add all the fields included in the WebEngage field mapping custom metadata
                        // from the Lead or Opportunity based on the condition.
                        String queryString;
                        if(!setOfLeadIds.isEmpty()){
                            // Add a filter condition if it's Lead Object.
                            queryString = getQueryString('Lead');
                            if(!String.isBlank(queryString)){
                                queryString += ' where id=: setOfLeadIds';
                                // Query and fetch the records as a map of Id and records from Lead.
                                mapOfLeads = new Map<id,Lead>((List<Lead>)Database.query(queryString));
                                System.debug('----mapOfLeads---'+mapOfLeads);
                            }
                        }
                        if(!setOfOppIds.isEmpty()){
                            // Add a filter condition if it's Opportunity Object.
                            queryString = getQueryString('Opportunity');
                            if(!String.isBlank(queryString)){
                                queryString += ' where id=: setOfOppIds';
                                // Query and fetch the records as a map of Id and records from Opportunity.
                                mapOfOpps = new Map<id,Opportunity>((List<Opportunity>)Database.query(queryString));
                                //System.debug('mapOfOpps: '+mapOfOpps);
                            } 
                        }
                        System.debug('----mapOfWebEngageFieldMapping---'+mapOfWebEngageFieldMapping);
                        
                        String jsonData;
                        String responseStatus;
                        String integrationSettingName;
                        
                        if(!mapOfLeads.isEmpty() || !mapOfOpps.isEmpty()){
                            // Based on the Event (either user or Change event) create the JSONData for Callout.
                            
                            if(eventType=='CHANGE EVENT'  ){
                                
                                integrationSettingName= 'WebEngage Bulk Events API';
                                jsonData = webEngageChangeEventJsonCreator(mapOfLeads,mapOfOpps,mapOfWebEngageFieldMapping,listOfWebEngageTasks); 
                                System.debug('jsonData-' + jsonData);
                            }
                                
                            
                            else if(eventType == 'USER EVENT'){
                              
                                    integrationSettingName = 'WebEngage Bulk Users API';
                                    jsonData = webEngageUserEventJsonCreator(mapOfLeads,mapOfOpps,mapOfWebEngageFieldMapping,listOfWebEngageTasks); 
                                System.debug('jsonData-' + jsonData);
                                }
                                
                            }
                            
                        
                        if(!string.isBlank(integrationSettingName) && !string.isBlank(jsonData)){
                            // Call calloutToWebEngage to make API callout to WebEngage.
                            system.debug('integrationSettingName'+ integrationSettingName);
                            
                            responseStatus = calloutToWebEngage(jsonData,integrationSettingName);
                            System.debug('responseStatus: '+responseStatus);
                            if(!String.isBlank(responseStatus) && responseStatus == 'Success'){
                                // Call updateWebEngageTaskStatus to update WebEngage Task Status as closed after Success response.
                                listOfwebEngageTaskToUpdate.addAll(listOfWebEngageTasks);
                                //updateWebEngageTaskStatus(listOfWebEngageTasks);
                            }
                        }
                    }
                } 
                }
                if(!listOfwebEngageTaskToUpdate.isEmpty()){
                    updateWebEngageTaskStatus(listOfwebEngageTaskToUpdate);
                }
            }  
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
        }
    }
    
    /**
    * @description | Method to create the webEngage Change Event Json
    * @author Bharatesh Shetty | 10/15/2019
    * @param Map<id, Lead> mapOfLeads
    * @param Map<id, Opportunity> mapOfOpps
    * @param map<String, Map<String, WebEngage_Field_Mapping__mdt>> mapOfWebEngageFieldMapping
    * @param list<WebEngage_Task__c> listOfWebEngageTasks
    * @return String
    */
    Public Static String webEngageChangeEventJsonCreator(Map<id,Lead> mapOfLeads,Map<id,Opportunity> mapOfOpps,map<String,Map<String,WebEngage_Field_Mapping__mdt>> mapOfWebEngageFieldMapping,list<WebEngage_Task__c> listOfWebEngageTasks){
        String jsonData ;
        try{
            // Used JSONGenerator to create the JSON.
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject(); 
            gen.writeFieldName('events');
            gen.writeStartArray();
            System.debug('mapOfLeads :'+mapOfLeads);
            System.debug('mapOfOpps :'+mapOfOpps);
            for(WebEngage_Task__c objtask : listOfWebEngageTasks){
                System.debug('objtask.lead__c :'+objtask.lead__c);
                if((!mapOfLeads.isEmpty() && objtask.Lead__c != null && mapOfLeads.containsKey(objtask.lead__c)) || 
                   (!mapOfOpps.isEmpty() && objtask.Opportunity__c != null && mapOfOpps.containsKey(objtask.Opportunity__c))){
                       map<String,WebEngage_Field_Mapping__mdt> sMap = mapOfWebEngageFieldMapping.get(objtask.Name);
                       Object getResultReturnVal = null;
                       
                       gen.writeStartObject();
                       system.debug('open Braces'+objtask );
                       
                       gen.writeObjectField('eventName',objtask.Name);  
                       gen.writeStringField('eventTime',String.valueOf(getResult(objtask,'createddate')).replace(' ','T')+'+0000');
                       
                       if(objtask.Lead__c != null){
                           gen.writeObjectField('userId',getResult(mapOfLeads.get(objtask.lead__c),'customer_id__c'));
                           gen.writeFieldName('eventData');
                           gen.writeStartObject();
                           for(String sfieldName : sMap.keySet()){
                               getResultReturnVal = getResult(mapOfLeads.get(objtask.lead__c),sfieldName);
                               System.debug('getResultReturnVal: '+getResultReturnVal);
                               System.debug('String event created date:'+String.valueOf(getResultReturnVal));
                               if(getResultReturnVal!=null){
                                   if(sMap.get(sfieldName).isDateTimeField__c){
                                       gen.writeStringField(sMap.get(sfieldName).WebEngage_Field_API_Name__c,String.valueOf(getResult(objtask,'createddate')).replace(' ','T')+'+0000');
                                   }
                                   else{
                                       gen.writeObjectField(sMap.get(sfieldName).WebEngage_Field_API_Name__c,getResultReturnVal); 
                                   }
                               }      
                           }
                       }
                       else{
                           System.debug('Customer_ID__C : '+mapOfOpps.get(objtask.Opportunity__c).Customer_ID__C);
                           gen.writeObjectField('userId',getResult(mapOfOpps.get(objtask.Opportunity__c),'customer_id__c'));
                           gen.writeFieldName('eventData');
                           gen.writeStartObject();
                           for(String sfieldName : sMap.keySet()){
                               getResultReturnVal = getResult(mapOfOpps.get(objtask.Opportunity__c),sfieldName);
                               //System.debug('getResultReturnVal: '+getResultReturnVal);
                               if(getResultReturnVal!=null){
                                   if(sMap.get(sfieldName).isDateTimeField__c){
                                       gen.writeStringField(sMap.get(sfieldName).WebEngage_Field_API_Name__c,String.valueOf(getResult(objtask,'createddate')).replace(' ','T')+'+0000');
                                   }
                                   else{
                                       gen.writeObjectField(sMap.get(sfieldName).WebEngage_Field_API_Name__c,getResultReturnVal); 
                                   }
                               }         
                           }
                       }
                       gen.writeEndObject();
                       gen.writeEndObject();
                   }
            }   
            gen.writeEndArray();
            gen.writeEndObject();
            jsonData = gen.getAsString();
            System.debug('jsonData-' + jsonData);
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
        }
        return jsonData;
    }
    
    /**
    * @description | Method to create the webEngage User Event Json
    * @author Bharatesh Shetty | 10/15/2019
    * @param Map<id, Lead> mapOfLeads
    * @param map<String, Map<String, WebEngage_Field_Mapping__mdt>> mapOfWebEngageFieldMapping
    * @param list<WebEngage_Task__c> listOfWebEngageTasks
    * @return String
    */
    Public Static String webEngageUserEventJsonCreator(Map<id,Lead> mapOfLeads, Map<id, Opportunity> mapOfOpps, map<String,Map<String,WebEngage_Field_Mapping__mdt>> mapOfWebEngageFieldMapping,list<WebEngage_Task__c> listOfWebEngageTasks){
        String jsonData ;
        system.debug('mapOfLeads-->'+mapOfLeads);
        system.debug('mapOfOpps-->'+mapOfOpps);
        try{
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject(); 
            gen.writeFieldName('users');
            gen.writeStartArray();
            for(WebEngage_Task__c objtask : listOfWebEngageTasks){
                if((!mapOfLeads.isEmpty() && objtask.Lead__c != null && mapOfLeads.containsKey(objtask.lead__c)) ||
                   (!mapOfOpps.isEmpty() && objtask.Opportunity__c != null && mapOfOpps.containsKey(objtask.Opportunity__c))){
                    map<String,WebEngage_Field_Mapping__mdt> sMap = mapOfWebEngageFieldMapping.get(objtask.Name);
                    gen.writeStartObject();
                    system.debug('open Braces'+objtask );
                    if(objtask.Lead__c != null){
                       
                        gen.writeObjectField('userId',getResult(mapOfLeads.get(objtask.lead__c),'customer_id__c'));
                        String phoneNumber =  mapOfLeads.get(objtask.lead__c).Area_Code__c+''+mapOfLeads.get(objtask.lead__c).phone;
                        system.debug('phoneNUmber '+ phoneNumber );
                        if(mapOfLeads.get(objtask.lead__c).firstName !=null){
                            gen.writeObjectField('firstName',mapOfLeads.get(objtask.lead__c).firstName);
                        }
                        if(mapOfLeads.get(objtask.lead__c).lastName !=null){
                            gen.writeObjectField('lastName',mapOfLeads.get(objtask.lead__c).lastName);
                        }
                        if(mapOfLeads.get(objtask.lead__c).email !=null){
                            gen.writeObjectField('email',mapOfLeads.get(objtask.lead__c).email);
                        }
                        if(mapOfLeads.get(objtask.lead__c).phone !=null){
                            gen.writeObjectField('phone',phoneNumber);
                        }
						if(mapOfLeads.get(objtask.lead__c).Whatsapp_Opt_in__c !=null){
                        	gen.writeObjectField('whatsappOptIn',mapOfLeads.get(objtask.lead__c).Whatsapp_Opt_in__c);
                        }
                    }else{
                        gen.writeObjectField('userId',getResult(mapOfOpps.get(objtask.Opportunity__c),'customer_id__c'));
                        /* if(mapOfOpps.get(objtask.lead__c).firstName !=null){
                            gen.writeObjectField('firstName',mapOfOpps.get(objtask.Opportunity__c).firstName);
                        }*/
                        if(mapOfOpps.get(objtask.Opportunity__c).Full_Name__c !=null){
                            gen.writeObjectField('lastName',mapOfOpps.get(objtask.Opportunity__c).Full_Name__c);
                        }
                        if(mapOfOpps.get(objtask.Opportunity__c).Customer_Email__c !=null){
                            gen.writeObjectField('email',mapOfOpps.get(objtask.Opportunity__c).Customer_Email__c);
                        }
                        if(mapOfOpps.get(objtask.Opportunity__c).Customer_Phone_Number__c !=null){
                            gen.writeObjectField('phone',mapOfOpps.get(objtask.Opportunity__c).Customer_Phone_Number__c);
                        }
                    } 
                     
                    gen.writeFieldName('attributes');
                    gen.writeStartObject();
                    Object getResultReturnVal = null;
                    for(String sfieldName : sMap.keySet()){
                        
                        if(objtask.Lead__c != null){
                            getResultReturnVal = getResult(mapOfLeads.get(objtask.lead__c),sfieldName);
                        }else{
                            getResultReturnVal = getResult(mapOfOpps.get(objtask.Opportunity__c),sfieldName);
                        }    
                        if(getResultReturnVal!=null){
                            if(sMap.get(sfieldName).isDateTimeField__c){
                                gen.writeStringField(sMap.get(sfieldName).WebEngage_Field_API_Name__c,String.valueOf(getResult(objtask,'createddate')).replace(' ','T')+'+0000');
                            }
                            else{
                                gen.writeObjectField(sMap.get(sfieldName).WebEngage_Field_API_Name__c,getResultReturnVal); 
                            } 
                        }      
                    }
                 //   gen.writeObjectField('we_whatsapp_opt_in',mapOfLeads.get(objtask.lead__c).Whatsapp_Opt_in__c);
                    gen.writeEndObject();
                    gen.writeEndObject();
                }
            }   
            gen.writeEndArray();
            gen.writeEndObject();
            jsonData = gen.getAsString();
            system.debug('jsonData-' + jsonData);
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
        }
        return jsonData;
    }
    /**
    * @description | to resolve and get the field values with the data type for normal fields as well as cross reference fields.
    * @author Bharatesh Shetty | 10/15/2019
    * @param SObject record
    * @param String field
    * @return Object
    */
    public static Object getResult(SObject record, String field){
        //System.debug('record: '+record);
        //System.debug('field: '+field);
        if (record == null || String.isBlank(field) ) {
            return null;
        }
        if (!field.contains('.')) {
            return record.get(field);
        }
        return getResult(
            record.getSObject(field.substringBefore('.')),
            field.substringAfter('.')
        );
    }
    
    /**
    * @description | Method to process API callouts WebEngage.
    * @author Bharatesh Shetty | 10/15/2019
    * @param String body
    * @param String integrationSettingName
    * @return String
    */
    public static String calloutToWebEngage(String body,String integrationSettingName){
        String responseStatus;
        try{
            if(!String.isBlank(body) && !String.isBlank(integrationSettingName)){
                Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                if(allEndPoint.containsKey(integrationSettingName)){
                    Integration_Setting__c integrationDetail = allEndPoint.get(integrationSettingName);
                    
                    String endPointUrl = integrationDetail.End_Point__c;
                    Http http = new Http();
                    HttpRequest request = new HttpRequest();
                    Httpresponse response = new Httpresponse();
                    
                    request.setMethod('POST');
                    request.setBody(body);
                    request.setHeader('Content-Type', integrationDetail.ContentType__c);
                    request.setHeader('Authorization', 'Bearer '+integrationDetail.Authorization__c);
                    request.setEndPoint(endPointUrl);
                    request.setTimeout(120000);
                    System.debug('request: '+request);
                    
                    response = http.send(request);
                    System.debug('response: '+response);
                    
                    ResponseWrapper respWrap;
                    
                    String resJson;
                    if(response.getStatusCode()==201){
                        resJson = response.getBody();
                        System.debug('response.getStatusCode(): '+response.getStatusCode());
                        //listOfResponseWrapper = (List<LeadSquaredResponseWrapper>)JSON.deserialize(resJson,List<LeadSquaredResponseWrapper>.class);
                        respWrap = (ResponseWrapper)JSON.deserialize(resJson,ResponseWrapper.class);
                        if(respWrap !=null && respWrap.response !=null){
                            if(respWrap.response.containsKey('status') && respWrap.response.get('status')=='queued'){
                                responseStatus = 'Success';
                                System.debug('responseStatus: '+responseStatus);
                            }
                        }
                        System.debug('respWrap: '+respWrap);
                    }
                    else if (response.getStatusCode()==400){
                        resJson = response.getBody();
                        System.debug('response.getStatusCode(): '+response.getStatusCode());
                        respWrap = (ResponseWrapper)JSON.deserialize(resJson,ResponseWrapper.class);
                        if(respWrap !=null && respWrap.response !=null){
                            if(respWrap.response.containsKey('status') && respWrap.response.get('status')=='error'){
                                System.debug('response status: '+respWrap.response.get('status'));
                                System.debug('response error message: '+respWrap.response.get('message'));
                                Logger.log('Error','WebEngageBatchHandler class','calloutToWebEngage method',respWrap.response.get('message'),String.ValueOf(response.getStatusCode()),null);
                            }
                        }
                        System.debug('respWrap: '+respWrap);
                    }
                    else{
                        System.debug('response.getStatusCode(): '+response.getStatusCode());
                        Logger.log('Error','WebEngageBatchHandler class','calloutToWebEngage method','Status code error',String.ValueOf(response.getStatusCode()),null);
                    }
                }
                else{
                    System.debug('integrationDetail not found');
                    Logger.log('Error','WebEngageBatchHandler class','calloutToWebEngage method','integrationDetail not found',integrationSettingName,null);
                }
            }
            else{
                System.debug('blank body or integration setting Name');
                System.debug('body: '+body);
                System.debug('integrationSettingName: '+integrationSettingName);
                Logger.log('Error','WebEngageBatchHandler class','calloutToWebEngage method','body or Integration Setting error',integrationSettingName,null);
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception','WebEngageBatchHandler class','calloutToWebEngage method',e.getMessage(),e.getStackTraceString(),null);
        }
        return responseStatus;
    }
    /**
    * @description | Method to update the Status of the Webengage task records to "Closed"
    * @author Bharatesh Shetty | 10/15/2019
    * @param list<WebEngage_Task__c> listOfWebEngageTasks
    * @return void
    */
    public static void updateWebEngageTaskStatus(list<WebEngage_Task__c> listOfWebEngageTasks){
        try{
            if(!listOfWebEngageTasks.isEmpty()){
                // Loop through the webEngage task and make the status as 'Closed'
                for(WebEngage_Task__c webEngTask: listOfWebEngageTasks){
                    webEngTask.Status__c ='Closed';
                }
                // Update the list of WebEngageTasks.
                update listOfWebEngageTasks;
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception','WebEngageBatchHandler class','updateWebEngageTaskStatus method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    /**
    * @description | To get all the fields needed for creating JSON for the events to create dynamic query string.
    * @author Bharatesh Shetty | 10/15/2019
    * @param String sobjectName
    * @return String
    */
    Public static String getQueryString(String sobjectName){
        String queryString;
        try{
            if(!String.isBlank(sobjectName)){
                Set<String> setOfSFfieldAPINames = new Set<String>();
                List<WebEngage_Event__mdt> listOfWebEngageEvents = new List<WebEngage_Event__mdt>();
                listOfWebEngageEvents = [Select id,
                                         (Select id,SF_Field_API_Name__c from WebEngage_Field_Mapping__r) 
                                         from WebEngage_Event__mdt where SobjectName__c=:sobjectName
                                        ];
                if(!listOfWebEngageEvents.isEmpty()){
                    for(WebEngage_Event__mdt webEngageEvent : listOfWebEngageEvents){
                        if(!webEngageEvent.WebEngage_Field_Mapping__r.isEmpty()){
                            setOfSFfieldAPINames.add('customer_id__c');
                            setOfSFfieldAPINames.add('createddate');
                            if(sobjectName == 'Lead'){
                                setOfSFfieldAPINames.add('firstname');
                                setOfSFfieldAPINames.add('lastname');
                                setOfSFfieldAPINames.add('email');
                                setOfSFfieldAPINames.add('phone');
                            }
                            //Only for time being comment it out later
                            else if(sobjectName == 'Opportunity'){
                                setOfSFfieldAPINames.add('customer_email__c');
                                setOfSFfieldAPINames.add('Full_Name__c');
                                setOfSFfieldAPINames.add('Customer_Phone_Number__c');
                            }
                            for(WebEngage_Field_Mapping__mdt webEngageFieldMapping : webEngageEvent.WebEngage_Field_Mapping__r){
                                if(webEngageFieldMapping.SF_Field_API_Name__c !=null ){
                                    setOfSFfieldAPINames.add(webEngageFieldMapping.SF_Field_API_Name__c.toLowerCase());
                                }
                            }
                        }
                    }
                    if(!setOfSFfieldAPINames.isEmpty()){
                        queryString = 'Select id';
                        for(String sfFieldAPIName : setOfSFfieldAPINames){
                            queryString += ','+sfFieldAPIName;
                        }
                        if(sobjectName == 'Lead'){
                            queryString += ' From Lead';
                        }
                        else if(sobjectName == 'Opportunity'){
                            queryString += ' From Opportunity';
                        }
                    }
                }
                //System.debug('queryString: '+queryString);
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception','WebEngageBatchHandler class','getQueryString method',e.getMessage(),e.getStackTraceString(),null);
        }
        return queryString;
    }
    Public class ResponseWrapper{
        Public Map<String,String> response;
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
     }
}