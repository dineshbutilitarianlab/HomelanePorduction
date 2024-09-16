@RestResource(urlMapping='/AdditionalMainOrder/*')
global class LeadAdditionalOrderCreation{
    //private static String strErrorMsg = '';
    @HttpPost
    global static void LeadAdditionalOrderCreation(){
        
        Response response =new Response();
        response.message = 'Some error occurred contact Salesforce Admin';
        response.success_code = '501';
        response.SFAccountId = '';
        response.CustomerID = '';
        response.SFLeadId = '';
        response.LeadOrder_UniqueID = '';
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
                if(!mapOfJSONRequest.isEmpty()){
                    for(String jsonReqParam : mapOfJSONRequest.keySet()){
                        if(jsonReqParam == 'querystring'){
                            Map<String, Object> queryStringListMap = new Map<String, Object>();
                            queryStringListMap = (Map<String, Object>)mapOfJSONRequest.get('querystring');
                            for(String queryStringParam : queryStringListMap.keySet()){
                                mapOfJSONRequestConstructed.put(queryStringParam,queryStringListMap.get(queryStringParam));
                            }
                        }
                            mapOfJSONRequestConstructed.put(jsonReqParam,mapOfJSONRequest.get(jsonReqParam));
                    }
                    //For loop ends
                    if(!mapOfJSONRequestConstructed.isEmpty()){
                        
                        Map<String,Integration_Point_Additional_Order__c> mapOfLabelAndIntegrationPointCS = new Map<String,Integration_Point_Additional_Order__c>();
                 
                        for(Integration_Point_Additional_Order__c intPoint: [select name, Object_Name__c, Field_Name__c, Field_Label__c, In_Use__c,Is_QueryString_Element__c,Field_Data_Type__c  
                                                            from Integration_Point_Additional_Order__c	 
                                                            where In_Use__c = TRUE]){
                                                                if(!String.isBlank(intPoint.Field_Label__c)){
                                                                    mapOfLabelAndIntegrationPointCS.put(intPoint.Field_Label__c,intPoint);
                                                                } 
                                                            }
                        System.debug('mapOfJSONRequestConstructed'+mapOfJSONRequestConstructed);
                        System.debug('mapOfLabelAndIntegrationPointCS'+mapOfLabelAndIntegrationPointCS);
                        if(!mapOfLabelAndIntegrationPointCS.isEmpty()){
                            
                            Account accRecord = new Account();
                            Lead leadRecord = new Lead();
                            for(String intPointParam : mapOfLabelAndIntegrationPointCS.keySet()){
                                if(mapOfJSONRequestConstructed.containsKey(intPointParam)){
                                    if(mapOfJSONRequestConstructed.get(intPointParam) != null){
                                      
                                        if(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Data_Type__c.EqualsIgnoreCase('text')||
                                           mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Data_Type__c.EqualsIgnoreCase('lookup')){
                                               //String stringVal = (String)mapOfJSONRequestConstructed.get(intPointParam);
                                               if(!String.isBlank((String)mapOfJSONRequestConstructed.get(intPointParam))){
                                                   
                                                   if(mapOfLabelAndIntegrationPointCS.get(intPointParam).object_Name__C.EqualsIgnoreCase('lead')){
                                                       leadRecord.put(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Name__c, (String)mapOfJSONRequestConstructed.get(intPointParam));
                                                   }
                                                   
                                               }
                                           }
                                        // If the data type is checkbox then parse the value as a Boolean value.
                                        else if(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Data_Type__c.EqualsIgnoreCase('checkbox')){
                                            if(mapOfLabelAndIntegrationPointCS.get(intPointParam).object_Name__C.EqualsIgnoreCase('lead')){
                                                leadRecord.put(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Name__c, Boolean.valueOf(mapOfJSONRequestConstructed.get(intPointParam)));
                                            }
                                            
                                        }
                                        // If the data type is date then parse the value as a date value
                                        else if(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Data_Type__c.EqualsIgnoreCase('date')){
                                            if(!String.isBlank((String)mapOfJSONRequestConstructed.get(intPointParam))){
                                                if(mapOfLabelAndIntegrationPointCS.get(intPointParam).object_Name__C.EqualsIgnoreCase('lead')){
                                                    System.debug('sss'+mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Name__c +'--'+Date.parse((String)mapOfJSONRequestConstructed.get(intPointParam)));
                                                    leadRecord.put(mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Name__c, Date.parse((String)mapOfJSONRequestConstructed.get(intPointParam)));
                                                }
                                               
                                            }
                                        }
                                        else{
                                            System.debug('A different data type found than the expected ones. Data type: '+mapOfLabelAndIntegrationPointCS.get(intPointParam).Field_Data_Type__c);
                                            //capture log but add to the list and insert later because it's inside for loop.
                                        }
                                    }
                                    else{
                                        System.debug('mapOfJSONRequestConstructed value is null: '+mapOfJSONRequestConstructed.get(intPointParam));
                                    }
                                }
                                else{
                                    System.debug('mapOfJSONRequestConstructed does not contain Integration point Param :'+intPointParam);
                                    //capture log but add to the list and insert later because it's inside for loop.
                                }
                            
                            }
                            System.debug('Acc'+(String)mapOfJSONRequestConstructed.get(GenericConstants.SF_ACCOUNT_ID));
                            accRecord = AccountSelector.getAccountById((String)mapOfJSONRequestConstructed.get(GenericConstants.SF_ACCOUNT_ID));
                            if(accRecord != NULL){
                                //Add the SF Account Id and Customer Id values queried from the Account created to the response body
                                response.SFAccountId = accRecord.Id;
                                response.CustomerID = accRecord.Customer_ID__c;
                                response.message = 'Account Mapped to Additional Lead in Salesforce';
                                //Insert the Lead record and tagging it to the account record created before.
                                if(mapOfJSONRequestConstructed.containsKey(GenericConstants.Property_JSON)){
                                    if(mapOfJSONRequestConstructed.get(GenericConstants.Property_JSON)!= null){
                                        string obj= json.serialize(mapOfJSONRequestConstructed.get(GenericConstants.Property_JSON));
                                        system.debug('obj '+ obj);
                                        //system.debug('obj.city'+ obj.City);
                                        leadProperty = LeadGenerationHelper.LeadPropertyCreation(obj);
                                        
                                        if(leadProperty!=null){
                                            leadRecord.Property__c=leadProperty.id; 
                                            leadRecord.Property_Added_at_Lead_Creation__c=true;
                                            LeadAdditionalOrderCreation.CreateLeadForAcc(accRecord,mapOfJSONRequestConstructed,leadRecord,response,leadProperty); 
                                        }else{
                                            if(mapOfJSONRequestConstructed.containsKey(GenericConstants.Lead_Requested_By)){
                                                if(mapOfJSONRequestConstructed.get(GenericConstants.Lead_Requested_By)== GenericConstants.Roster){
                                                    System.debug('Lead Cannot be created as the property is not tagged successfully. Contact Salesforce Admin.');
                                                    response.message = 'Lead Cannot be created as the property is not tagged successfully. Contact Salesforce Admin.';
                                                }  
                                                else{
                                                    LeadAdditionalOrderCreation.CreateLeadForAcc(accRecord,mapOfJSONRequestConstructed,leadRecord,response,null);    
                                                }
                                            }
                                        }
                                    
                                    }else{
                                      LeadAdditionalOrderCreation.CreateLeadForAcc(accRecord,mapOfJSONRequestConstructed,leadRecord,response,null);    
                                    }
                                }else{
                                    LeadAdditionalOrderCreation.CreateLeadForAcc(accRecord,mapOfJSONRequestConstructed,leadRecord,response,null);  
                                }
                            }
                            else{
                                System.debug('Account not returned in the query after Account creation in LeadAdditionalOrder API');
                                response.message = 'Account not returned in the query after Account creation in LeadAdditionalOrder API. Contact Salesforce Admin.';
                                //capture the log
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
                }
            }
            else{
                System.debug('requestBodyString is blank');
                response.message = 'requestBodyString is blank. Contact Salesforce Admin.';
                //capture the log
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            response.message = 'Exception Message: '+e.getMessage() + ' . Exception StackTraceString: '+e.getStackTraceString();
            Logger.log('Exception','Additional order Api','Add Order Api',e.getMessage(),e.getStackTraceString(),null);
        }
        //serialize the response wrapper to a string and add it as the response body
        string json_data = json.serialize(response);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(json_data);
    }
    
    public Static void CreateLeadForAcc(account accRecord,Map<String,object>mapOfJSONRequestConstructed ,lead leadRecord,Response response,Master__c leadProperty ){
        leadRecord.Account__c = accRecord.Id;
        leadRecord.Phone = accRecord.Phone;
        leadRecord.LastName = accRecord.Name;
        leadRecord.Lead_Created_By__c = GenericConstants.LEAD_CREATED_BY_WEBSITE;
        leadRecord.Email_For_Communication__c = accRecord.PersonEmail;
        leadRecord.Email = accRecord.PersonEmail;
        leadRecord.Alt_Email_ID__c = accRecord.Alt_Email__c;
        leadRecord.Alt_Phone_Number__c = accRecord.Alt_Phone_Number__c;
        leadRecord.Area_Code__c = accRecord.Area_Code__c;
        leadRecord.Whatsapp_Opt_in__c = accRecord.Whatsapp_Opt_in__c;
        leadRecord.Found_On_TC__c = accRecord.Found_On_TC__c;
       
        if(mapOfJSONRequestConstructed.containsKey(GenericConstants.MANUAL_LEAD_CREATION) && mapOfJSONRequestConstructed.containsKey(GenericConstants.SF_USER_EMAIL)){
            if(mapOfJSONRequestConstructed.get(GenericConstants.MANUAL_LEAD_CREATION)!= Null && !Boolean.valueOf(mapOfJSONRequestConstructed.get(GenericConstants.MANUAL_LEAD_CREATION)) && mapOfJSONRequestConstructed.get(GenericConstants.SF_USER_EMAIL)!= Null){
                User userQueried = UserSelector.getUserByEmail(String.valueOf(mapOfJSONRequestConstructed.get(GenericConstants.SF_USER_EMAIL)));
                if(userQueried !=Null){
                    if(userQueried.Profile.Name.equalsIgnoreCase(GenericConstants.PROFILE_WTA) || userQueried.Profile.Name.equalsIgnoreCase(GenericConstants.PROFILE_WTM)){
                        leadRecord.Lead_Created_By__c = GenericConstants.LEAD_CREATED_BY_SFWT_USER;
                        leadRecord.OwnerId = userQueried.Id;
                        leadRecord.WT_Agent__C = userQueried.Id;
                    }
                    else{
                        leadRecord.Lead_Created_By__c = GenericConstants.LEAD_CREATED_BY_SF_OTHER;
                    }
                }
            }
        }
        insert leadRecord;
        // Query the lead related details LeadOrder_UniqueID values 
        leadRecord = LeadSelector.getLeadById(leadRecord.Id);
        if(leadRecord != NULL){
            
            System.debug('Lead have been created successfully in Salesforce.');
            response.SFLeadId = leadRecord.Id;
            response.LeadOrder_UniqueID = leadRecord.Customer_Id__c;
            response.success_code = '201';
            response.message = 'Lead has created successfully in Salesforce.';
        }
        else{
            System.debug('Lead not returned in the query after Lead creation in LeadAdditionalOrder API');
            response.message = 'Account created. Lead not returned in the query after Lead creation in LeadAdditionalOrder API. Contact Salesforce Admin.';
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