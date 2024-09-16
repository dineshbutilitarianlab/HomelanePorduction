/*
* $Author: Bharatesh Shetty
* $Company: Warpdrive Tech works
* $Date: 15/08/2020 
*/

@RestResource(urlMapping='/leadGeneration/*')
global class LeadGeneration{
    //private static String strErrorMsg = '';
    @HttpPost
    global static void leadGeneration(){
        //Initialize the value for the response as an error response so that only once if it successully creates the records the success response values will be set.
        Response response =new Response();
        response.message = 'Some error occurred contact Salesforce Admin';
        response.success_code = '501';
        response.SFAccountId = '';
        response.CustomerID = '';
        response.SFLeadId = '';
        response.LeadOrder_UniqueID = '';
        
        List<Log__c> listOfLogsToInsert = new List<Log__c>();
        Master__c leadProperty = new Master__c();
        
        try{
            //creating instance to get request data 
            RestRequest req = RestContext.request;
            String requestBodyString = req.requestBody.toString();
            system.debug('******requestBodyString*******'+requestBodyString );
            if(!String.isBlank(requestBodyString)){
                Map<String, Object> mapOfJSONRequestConstructed = new Map<String, Object>();
                //Deserialized map of JSON request string body
                Map<String, Object> mapOfJSONRequest = new Map<String, Object>();
                mapOfJSONRequest = (Map<String, Object>)JSON.deserializeUntyped(requestBodyString);
                system.debug('******mapOfJSONRequest *******'+mapOfJSONRequest );
                system.debug('******mapOfJSONRequest *******'+ mapOfJSONRequest.get('PropertyJson'));
                String Result;
                if(!mapOfJSONRequest.isEmpty()){
                    //If the mapOfJSONRequest is not empty then iterate over it to construct mapOfJSONRequestConstructed map.
                    //This is done because the in the json request querystring param is sent as an object
                    //For loop starts
                    for(String jsonReqParam : mapOfJSONRequest.keySet()){
                        // If the param is querystring then get the map and iterate over the parameters inside it and use it to construct mapOfJSONRequestConstructed map.
                        if(jsonReqParam == 'querystring'){
                            Map<String, Object> queryStringListMap = new Map<String, Object>();
                            queryStringListMap = (Map<String, Object>)mapOfJSONRequest.get('querystring');
                            for(String queryStringParam : queryStringListMap.keySet()){
                                mapOfJSONRequestConstructed.put(queryStringParam,queryStringListMap.get(queryStringParam));
                            }
                        }
                        //Else just put the param and corresponding object value to mapOfJSONRequestConstructed map.
                        else{
                            mapOfJSONRequestConstructed.put(jsonReqParam,mapOfJSONRequest.get(jsonReqParam));
                        }
                    }
                  
                    //For loop ends
                    if(!mapOfJSONRequestConstructed.isEmpty()){
                        //This is a map of Integration points with the label (same as the json parameter) as key and custom setting record as value.
                        Map<String,IntegrationPoints__c> mapOfLabelAndIntegrationPointCS = new Map<String,IntegrationPoints__c>();
                        
                        //Query the active IntegrationPoints__C custom settings records which acts like a mapping file from website to SF.
                        //Construct the Map of the same.
                        for(IntegrationPoints__c intPoint: [select name, Object_Name__c, Field_Name__c, Field_Label__c, In_Use__c,Is_QueryString_Element__c,Field_Data_Type__c  
                                                            from IntegrationPoints__c 
                                                            where In_Use__c = TRUE]){
                                                                if(!String.isBlank(intPoint.Field_Label__c)){
                                                                    mapOfLabelAndIntegrationPointCS.put(intPoint.Field_Label__c,intPoint);
                                                                } 
                                                            }
                        if(!mapOfLabelAndIntegrationPointCS.isEmpty()){
                            //Construct a new Account and Lead instances and add the values to the necessary fields from the JSON request.
                            Account accRecord = new Account();
                            Lead leadRecord = new Lead();
                            // If the mapOfLabelAndIntegrationPointCS is not empty and mapOfJSONRequestConstructed are not empty then iterate over the 
                            // mapOfJSONRequestConstructed map and mapOfLabelAndIntegrationPointCS  to process the JSON request data
                            // For loop starts
                            system.debug('mapOfJSONRequestConstructed'+mapOfJSONRequestConstructed);
                            System.debug('mapOfLabelAndIntegrationPointCS'+mapOfLabelAndIntegrationPointCS);
                            for(String intPointParam : mapOfLabelAndIntegrationPointCS.keySet()){
                                System.debug('intPointParam'+intPointParam);
                                if(mapOfJSONRequestConstructed.containsKey(intPointParam)){
                                    if(mapOfJSONRequestConstructed.get(intPointParam) != null){
                                        // If the Object name value in the integration point is Account then sync to both Account and the lead record or else if it it's lead then sync only to lead. Else ignore.
                                        // If the data type is text or lookup then parse the value as a string
                                        if(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Data_Type__c.EqualsIgnoreCase('text')||
                                           mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Data_Type__c.EqualsIgnoreCase('lookup')){
                                               //String stringVal = (String)mapOfJSONRequestConstructed.get(intPointParam);
                                               System.debug('intPointParam'+intPointParam);
                                               if(!String.isBlank((String)mapOfJSONRequestConstructed.get(intPointParam))){
                                                   if(mapOfLabelAndIntegrationPointCS.get(intPointParam).object_Name__C.EqualsIgnoreCase('account')){
                                                       //Hardcoded because the standard email field's api name is different in Account and Lead.
                                                       if(intPointParam == 'email'){
                                                           accRecord.put('personEmail', (String)mapOfJSONRequestConstructed.get(intPointParam));
                                                       }
                                                       else{
                                                           accRecord.put(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Name__c, (String)mapOfJSONRequestConstructed.get(intPointParam));
                                                       }
                                                       leadRecord.put(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Name__c, (String)mapOfJSONRequestConstructed.get(intPointParam));
                                                   }
                                                   else if(mapOfLabelAndIntegrationPointCS.get(intPointParam).object_Name__C.EqualsIgnoreCase('lead')){
                                                       System.debug('intPointParam'+intPointParam);
                                                       leadRecord.put(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Name__c, (String)mapOfJSONRequestConstructed.get(intPointParam));
                                                   }
                                                   else{
                                                       
                                                   }
                                               }
                                           }
                                        // If the data type is checkbox then parse the value as a Boolean value.
                                        else if(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Data_Type__c.EqualsIgnoreCase('checkbox')){
                                            if(mapOfLabelAndIntegrationPointCS.get(intPointParam).object_Name__C.EqualsIgnoreCase('account')){
                                                accRecord.put(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Name__c, Boolean.valueOf(mapOfJSONRequestConstructed.get(intPointParam)));
                                                leadRecord.put(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Name__c, Boolean.valueOf(mapOfJSONRequestConstructed.get(intPointParam)));
                                            }
                                            else if(mapOfLabelAndIntegrationPointCS.get(intPointParam).object_Name__C.EqualsIgnoreCase('lead')){
                                                leadRecord.put(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Name__c, Boolean.valueOf(mapOfJSONRequestConstructed.get(intPointParam)));
                                            }
                                            else{
                                                
                                            }
                                        }
                                        // If the data type is date then parse the value as a date value
                                        else if(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Data_Type__c.EqualsIgnoreCase('date')){
                                            if(!String.isBlank((String)mapOfJSONRequestConstructed.get(intPointParam))){
                                                if(mapOfLabelAndIntegrationPointCS.get(intPointParam).object_Name__C.EqualsIgnoreCase('account')){
                                                    accRecord.put(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Name__c, Date.Parse((String)mapOfJSONRequestConstructed.get(intPointParam)));
                                                    leadRecord.put(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Name__c, Date.Parse((String)mapOfJSONRequestConstructed.get(intPointParam)));
                                                }
                                                else if(mapOfLabelAndIntegrationPointCS.get(intPointParam).object_Name__C.EqualsIgnoreCase('lead')){
                                                    leadRecord.put(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Name__c, Date.Parse((String)mapOfJSONRequestConstructed.get(intPointParam)));
                                                }
                                                else{
                                                    
                                                }
                                            }
                                        }
                                        else{
                                            System.debug('A different data type found than the expected ones. Data type: '+mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Data_Type__c);
                                            //capture log but add to the list and insert later because it's inside for loop.
                                            listOfLogsToInsert.add(Logger.returnLog('Lead Generation Error','LeadGeneration Class','LeadGeneration method','A different data type found than the expected ones. Data type: '+mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Data_Type__c,'',''));
                                        }
                                    }
                                    else{
                                        System.debug('mapOfJSONRequestConstructed value is null: '+mapOfJSONRequestConstructed.get(intPointParam));
                                    }
                                }
                                else{
                                    System.debug('mapOfJSONRequestConstructed does not contain Integration point Param :'+intPointParam);
                                    //capture log but add to the list and insert later because it's inside for loop.
                                    //listOfLogsToInsert.add(Logger.returnLog('Lead Generation Error','LeadGeneration Class','LeadGeneration method','mapOfJSONRequestConstructed does not contain Integration point Param :'+intPointParam,'',''));
                                }
                            
                            }
                            system.debug('mapOfJSONRequestConstructed '+ mapOfJSONRequestConstructed.get('PropertyJson'));
                            //For loop ends
                            //Insert the Account record first.
                            if(!mapOfJSONRequestConstructed.isEmpty()){
                                if(mapOfJSONRequestConstructed.containsKey(GenericConstants.Property_JSON) ){
                                    if(mapOfJSONRequestConstructed.get(GenericConstants.Property_JSON)!=null){
                                        String obj= json.serialize(mapOfJSONRequestConstructed.get(GenericConstants.Property_JSON));
                                        system.debug('obj '+ obj);
                                        //system.debug('obj.city'+ obj.City);
                                        leadProperty = LeadGenerationHelper.LeadPropertyCreation(obj);
                                        if(leadProperty!=null ){
                                            insert accRecord;
                                            // Query the account related details
                                            accRecord = AccountSelector.getAccountById(accRecord.Id);
                                            
                                            if(accRecord != NULL){
                                                //Add the SF Account Id and Customer Id values queried from the Account created to the response body
                                                leadRecord.Property__c=leadProperty.id;
                                                leadRecord.Property_Added_at_Lead_Creation__c=true;
                                                LeadGeneration.createLeadForAccount(mapOfJSONRequestConstructed,accRecord,leadRecord,response);
                                            }
                                            else{
                                                System.debug('Account not returned in the query after Account creation in leadGeneration API');
                                                response.message = 'Accout not returned in the query after Account creation in leadGeneration API. Contact Salesforce Admin.';
                                                //capture the log
                                            }   
                                        }
                                        else{
                                            if(mapOfJSONRequestConstructed.containsKey(GenericConstants.Lead_Requested_By)){
                                                if(mapOfJSONRequestConstructed.get(GenericConstants.Lead_Requested_By)== GenericConstants.Roster){
                                                    System.debug('Lead Cannot be created as the property is not tagged successfully. Contact Salesforce Admin.');
                                                    response.message = 'Lead Cannot be created as the property is not tagged successfully. Contact Salesforce Admin.';
                                                }   
                                            }else{
                                                insert accRecord; 
                                                // Query the account related details
                                                accRecord = AccountSelector.getAccountById(accRecord.Id);
                                                
                                                if(accRecord != NULL){
                                                    //Add the SF Account Id and Customer Id values queried from the Account created to the response body
                                                    LeadGeneration.createLeadForAccount(mapOfJSONRequestConstructed,accRecord,leadRecord,response);
                                                }
                                                else{
                                                    System.debug('Account not returned in the query after Account creation in leadGeneration API');
                                                    response.message = 'Accout not returned in the query after Account creation in leadGeneration API. Contact Salesforce Admin.';
                                                    //capture the log
                                                }  
                                            } 
                                        }
                                    }else{
                                        insert accRecord;
                                        
                                    // Query the account related details
                                    accRecord = AccountSelector.getAccountById(accRecord.Id);
                                    if(accRecord != NULL){
                                        //Add the SF Account Id and Customer Id values queried from the Account created to the response body
                                        LeadGeneration.createLeadForAccount(mapOfJSONRequestConstructed,accRecord,leadRecord,response);
                                    }
                                    else{
                                        System.debug('Account not returned in the query after Account creation in leadGeneration API');
                                        response.message = 'Accout not returned in the query after Account creation in leadGeneration API. Contact Salesforce Admin.';
                                        //capture the log
                                    }  
                                    }
                                    
                                }
                                else{
                                    insert accRecord;
                                    
                                    // Query the account related details
                                    accRecord = AccountSelector.getAccountById(accRecord.Id);
                                    if(accRecord != NULL){
                                        //Add the SF Account Id and Customer Id values queried from the Account created to the response body
                                        LeadGeneration.createLeadForAccount(mapOfJSONRequestConstructed,accRecord,leadRecord,response);
                                    }
                                    else{
                                        System.debug('Account not returned in the query after Account creation in leadGeneration API');
                                        response.message = 'Accout not returned in the query after Account creation in leadGeneration API. Contact Salesforce Admin.';
                                        //capture the log
                                    }  
                                }
                            }
                            else{
                                
                            }
                        }
                        else{
                            System.debug('mapOfLabelAndIntegrationPointCS is empty');
                            response.message = 'mapOfLabelAndIntegrationPointCS is Empty. Contact Salesforce Admin.';
                            //capture the log
                        }
                    }
                    else{
                        System.debug('mapOfJSONRequestConstructed is empty');
                        response.message = 'mapOfJSONRequestConstructed is Empty. Contact Salesforce Admin.';
                        //capture the log
                    }
                }
                else{
                    System.debug('deserialized mapOfJSONRequest is Empty.');
                    response.message = 'deserialized mapOfJSONRequest is Empty. Contact Salesforce Admin.';
                    //capture the log
                    listOfLogsToInsert.add(Logger.returnLog('Lead Generation Error','LeadGeneration Class','LeadGeneration method','deserialized mapOfJSONRequest is Empty','',''));
                }
            }
            else{
                System.debug('requestBodyString is blank');
                response.message = 'requestBodyString is blank. Contact Salesforce Admin.';
                //capture the log
                listOfLogsToInsert.add(Logger.returnLog('Lead Generation Error','LeadGeneration Class','LeadGeneration method','requestBodyString is blank','',''));
            }
            if(!listOfLogsToInsert.isEmpty()){
                //Insert log records.
                insert listOfLogsToInsert;
            }
        }
        
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            response.message = 'Exception Message: '+e.getMessage() + ' . Exception StackTraceString: '+e.getStackTraceString();
            if(response.message.containsIgnoreCase('DUPLICATES_DETECTED, Account already exists with this phone no or email')){
                //If it's a duplicate account exception then send a different success code (500)
                response.success_code = '500';
            }
            //Log the exception
            Logger.log('Exception','LeadGeneration class','leadGeneration method',e.getMessage(),e.getStackTraceString(),null);
        }
        //serialize the response wrapper to a string and add it as the response body
        string json_data = json.serialize(response);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(json_data);
    }
    
    public static void createLeadForAccount(Map<String, Object> mapOfJSONRequestConstructed, Account accRecord,Lead leadRecord,Response response){
        response.SFAccountId = accRecord.Id;
        response.CustomerID = accRecord.Customer_ID__c;
        response.message = 'Account has been created in Salesforce but lead has not been created';
        leadRecord.Lead_Created_By__c = 'Website';
        //Check if it's a SF user created Leads. If yes and If it's a WTA or WTM then assign that user as the owner and the WT Agent
        if(mapOfJSONRequestConstructed.containsKey('Manual Lead Creation') && mapOfJSONRequestConstructed.containsKey('SF_User_Email')){
            if(mapOfJSONRequestConstructed.get('Manual Lead Creation')!= Null && !Boolean.valueOf(mapOfJSONRequestConstructed.get('Manual Lead Creation')) && mapOfJSONRequestConstructed.get('SF_User_Email')!= Null){
                User userQueried = UserSelector.getUserByEmail(String.valueOf(mapOfJSONRequestConstructed.get('SF_User_Email')));
                if(userQueried !=Null){
                    if(userQueried.Profile.Name.equalsIgnoreCase('WTA Profile') || userQueried.Profile.Name.equalsIgnoreCase('WTM Profile')){
                        leadRecord.Lead_Created_By__c = 'SF-WT Users';
                        leadRecord.OwnerId = userQueried.Id;
                        leadRecord.WT_Agent__C = userQueried.Id;
                    }
                    else{
                        leadRecord.Lead_Created_By__c = 'SF-Other Users';
                    }
                }
            }
        }
        //Insert the Lead record and tagging it to the account record created before.
        leadRecord.Account__c = accRecord.Id;
        
        
        insert leadRecord;
        // Query the lead related details LeadOrder_UniqueID values 
        leadRecord = LeadSelector.getLeadById(leadRecord.Id);
        if(leadRecord != NULL){
            // Add the SF Lead Id and the queried from the Lead created to the response body. And also set the success_code as 201 as sucess.
            System.debug('Both Account and Lead have been created successfully in Salesforce.');
            response.SFLeadId = leadRecord.Id;
            response.LeadOrder_UniqueID = leadRecord.Customer_Id__c;
            response.success_code = '201';
            response.message = 'Both Account and Lead have created successfully in Salesforce.';
        }
        else{
            System.debug('Lead not returned in the query after Lead creation in leadGeneration API');
            response.message = 'Account created. Lead not returned in the query after Lead creation in leadGeneration API. Contact Salesforce Admin.';
            //capture the log
        }
    }
    
    Private class Response
    {
        String message;
        String success_code;
        String SFLeadId;
        String SFAccountId;
        String CustomerID;
        String LeadOrder_UniqueID;
    }
}