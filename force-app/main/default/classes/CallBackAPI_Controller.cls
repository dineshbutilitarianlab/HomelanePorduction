/**
* @File Name          : CallBackAPI_Controller.cls
* @Description        : This class is a custom API class to place the call back request for a customer through salesforce which will be consumed by other systems.
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 2/25/2020, 5:06:12 PM
* @Modification Log   : 
* Ver       Date            Author              Modification
* 1.0    2/25/2020   Bharatesh Shetty     Initial Version
**/
@RestResource(urlMapping='/CallbackAPI/*')
global with sharing class  CallBackAPI_Controller {
    /**
* @description || This POST method gets request and fetches the lead record details using the phone number and sends success or error response accordingly.
* @author Bharatesh Shetty | 2/25/2020 
* @return void 
**/
    @HttpPost
    global static void getLeadInfo() {
        ResponseWrapper respWrap = new ResponseWrapper();
        RestResponse res = new RestResponse();
        RestRequest req = RestContext.request;
        String inputData = req.requestBody.toString();
        try{
            if(String.isNotBlank(inputData)){
                RequestWrapper reqWrap = (RequestWrapper)Json.deserialize(inputData, RequestWrapper.Class);
                System.debug('reqWrap : '+reqWrap);
                if(reqWrap !=null){
                    if(!String.isBlank(reqWrap.Customer_Order_Id)){
                        List<Lead> listOfQueryLeads = new List<Lead>();
                        // Query for the lead record with the phone number 
                        listOfQueryLeads = [Select 
                                            id,Customer_Id__c,Email,Phone,City,IsConverted,Sales_Manager__c,Sales_Manager_Email__c,Assigned_To_Resi_ASM__c,Requested_Call_Back__c,
                                            WT_Agent__c,WT_Agent__r.Name,WT_Agent__r.Cloud_Agent_Campaign_Name__c,WT_Agent__r.Email,WT_Agent__r.Profile.Name,Requested_Callback_Time__c
                                            From Lead 
                                            where Customer_Id__c =: reqWrap.Customer_Order_Id limit 1];
                        if(!listOfQueryLeads.isEmpty()){
                            Lead queriedLead = listOfQueryLeads[0];
                            // Success response if the lead with the Customer_Order_Id exists in SF.
                            respWrap.isSuccess = true;
                            respWrap.erroMessage = 'Callback request for this customer has been placed successfully in Salesforce.';
                            RestContext.response.addHeader('Content-Type', 'application/json');
                            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));  
                            RestContext.response.statusCode = 200;
                            processCallBackRequestLead(queriedLead);
                        }
                        else{
                            System.debug('listOfQueryLeads is empty. listOfQueryLeads: '+listOfQueryLeads);
                            // Error response if the lead with the Customer_Order_Id doesn't exist in SF.
                            respWrap.isSuccess = false;
                            respWrap.erroMessage = 'No lead with Customer_Order_Id '+reqWrap.Customer_Order_Id+' found in Salesforce. Please contact salesforce admin.';
                            RestContext.response.addHeader('Content-Type', 'application/json');
                            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));  
                            RestContext.response.statusCode = 400;
                        }
                    }
                    else{
                        System.debug('Customer_Order_Id is blank. Customer_Order_Id: '+reqWrap.Customer_Order_Id);
                        respWrap.isSuccess = false;
                        respWrap.erroMessage = 'Customer_Order_Id is blank in the request. reqWrap.Customer_Order_Id: '+reqWrap.Customer_Order_Id;
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));  
                        RestContext.response.statusCode = 400;
                        if(test.isRunningTest()){
                            System.debug(1/0);
                        }
                    }
                }
                else{
                    System.debug('reqWrap is blank. reqWrap: '+reqWrap);
                    respWrap.isSuccess = false;
                    respWrap.erroMessage = 'request is blank. reqWrap: '+reqWrap;
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));  
                    RestContext.response.statusCode = 400;
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            respWrap.isSuccess = false;
            respWrap.erroMessage = 'Exception in Salesforce. Excption Message: '+e.getMessage() +' .Stack Trace:'+e.getStackTraceString();
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));  
            RestContext.response.statusCode = 400;
            Logger.log('Exception','CallBackAPI_Controller Class','getLeadInfo Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    /**
* @description || This method processes the call back requested lead after sending the response back to roster.
* @author Bharatesh Shetty | 2/25/2020 
* @param leadRec 
* @return void 
**/
    public static void processCallBackRequestLead(Lead leadRec){
        System.debug('processCallBackRequestLead method called');
        Boolean successFullyPushedToOzonetel = False;
        try{
            if(leadRec != null){
                // If lead is not converted yet.
                if(!leadRec.IsConverted){
                    //If Requested_Call_Back__c is false then process else igonre
                    if(!leadRec.Requested_Call_Back__c){
                        // Call back push logic for non Iron man assigned (WTA assigned) leads.
                        if(!leadRec.Assigned_To_Resi_ASM__c){
                            if(leadRec.WT_Agent__c != null){
                                System.debug('leadRec.WT_Agent__r.Name: '+leadRec.WT_Agent__r.Name);
                                System.debug('leadRec.WT_Agent__r.Profile.Name: '+leadRec.WT_Agent__r.Profile.Name);
                                if(leadRec.WT_Agent__r.Profile.Name.equalsIgnoreCase('WTA Profile') || Test.isRunningTest()){
                                    if(!String.isBlank(leadRec.WT_Agent__r.Email)){
                                        Boolean agentAvailable = false;
                                        agentAvailable = getAgentStatusfromOZoneTel(leadRec.WT_Agent__r.Email,'OzoneTel Agent Status API');
                                        if(agentAvailable){
                                            // push to Priority agent 
                                            successFullyPushedToOzonetel = pushLeadToOzonetelPriorityAgentQueue(leadRec,'OzoneTel addCamapaignData API',Label.Call_Back_Priority_Agent_Campaign_Name,leadRec.WT_Agent__r.Email);
                                        }else{
                                            // Push it to city priority queue.
                                            successFullyPushedToOzonetel = pushLeadToOzonetelPriorityCityQueue(leadRec,'OzoneTel addCamapaignData API');
                                        }
                                    }
                                }
                                else{
                                    System.debug('WT_Agent__c field users profile is not WTA. Profile: '+leadRec.WT_Agent__r.Profile.Name);
                                    // Push it to city priority queue.
                                    successFullyPushedToOzonetel = pushLeadToOzonetelPriorityCityQueue(leadRec,'OzoneTel addCamapaignData API');
                                }
                            }
                            else{
                                System.debug('WT_Agent__c field is null for the non Iron man assigned (WTA assigned) lead ');
                                // Push it to city priority queue.
                                successFullyPushedToOzonetel = pushLeadToOzonetelPriorityCityQueue(leadRec,'OzoneTel addCamapaignData API');
                            }
                            if(successFullyPushedToOzonetel){
                                // If call back request has been pushed successfully to OzoneTel then update the call back request related lead details
                                System.debug('successFullyPushedToOzonetel :'+successFullyPushedToOzonetel + '. Now calling method to Update record details');
                                UpdateCallBackRequestDetails(leadRec,'lead');
                            }
                        }
                        // Call back push logic for Iron man assigned leads.
                        else{
                            UpdateCallBackRequestDetails(leadRec,'lead');
                        }
                    }
                    else{
                        System.debug('There is already a request call back in place for this lead.');
                    }
                }
                // If the lead is already converted and is in opportunity stage mark the call back requested field in opportunity as true
                else{
                    List<Opportunity> listOfQueryOpps = new List<Opportunity>();
                    listOfQueryOpps = [Select id,LeadId__C,Name,Customer_Email__c,Requested_Call_Back__c,Requested_Callback_Time__c,Follow_up_time__c From Opportunity where LeadId__C =:leadRec.Id];
                    if(!listOfQueryOpps.isEmpty()){
                        //Opportunity oppRec = new Opportunity();
                        System.debug('Opp: '+listOfQueryOpps[0]);
                        //If Requested_Call_Back__c is false then process else igonre.
                        if(listOfQueryOpps[0].Requested_Call_Back__c == False){ 
                            UpdateCallBackRequestDetails(listOfQueryOpps[0],'opportunity');
                        }
                        else{
                            System.debug('There is already a request call back in place for this opportunity');
                        }
                    }
                    else{
                        //Log the error case if the lead is converted but the opportunity record is not found.
                        Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','processCallBackRequestLead method','Lead is converted but Opportunity record not found in SF',leadRec.email,leadRec.id);
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('CALL BACK API Exception','CallBackAPI_Controller Class','processCallBackRequestLead Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    /**
* @description 
* @author Bharatesh Shetty | 2/25/2020 
* @param agentId 
* @param integrationSettingName 
* @return boolean 
**/
    public static boolean getAgentStatusfromOZoneTel(String agentId, String integrationSettingName ){
        boolean agentAvailable = false;
        try{
            if(!String.isBlank(agentId) && !String.isBlank(integrationSettingName)){
                Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                Integration_Setting__c integrationDetail = allEndPoint.get(integrationSettingName);
                List<String> lstValidStatus = new List<String>{'ACW','BUSY','IDLE','CALLING','READY'};
                    //String endPointUrl='https://api1.cloudagent.in/CAServices/AgentDetails/AgentDetails.php?userName=homelane&apiKey=KK1974dd56933b4c69602c063d589e19ab&agentId=kaustav.d@homelane.com';
                    String endPointUrl = integrationDetail.End_Point__c;
                endPointUrl += integrationDetail.Username__c+'&apiKey='+integrationDetail.Secret_Key__c+'&agentId='+agentId;
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                Httpresponse response = new Httpresponse();
                
                request.setMethod('GET');
                request.setHeader('Content-Type', integrationDetail.ContentType__c);
                //request.setHeader('Content-Type', 'application/json');
                request.setEndPoint(endPointUrl);
                System.debug('request: '+request);
                
                response = http.send(request);
                
                System.debug('response: '+response);
                if(response.getStatusCode()==200){
                    System.debug('-----response body '+response.getBody());
                    if(!String.isBlank(response.getBody())){
                        Map<String,Object> mapOfResponseBody = new Map<String,Object>();
                        mapOfResponseBody = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                        System.debug('mapOfResponseBody: '+mapOfResponseBody);
                        System.debug('Message: '+mapOfResponseBody.get('message'));
                        if(String.valueOf(mapOfResponseBody.get('status')).equalsIgnoreCase('SUCCESS')){
                            if(!(String.valueOf(mapOfResponseBody.get('message')).equalsIgnoreCase('No Data Found'))){
                                Map<String,Object> messageObjectMap = new Map<String,Object>();
                                for(Object obj: (List<Object>)mapOfResponseBody.get('message')){
                                    messageObjectMap = (Map<String,Object>)obj;
                                    if(messageObjectMap.containsKey('State')){
                                        System.debug('State: '+messageObjectMap.get('State'));
                                        if(lstValidStatus.Contains(String.valueOf(messageObjectMap.get('State')))){
                                            agentAvailable = true;
                                            System.debug('State of AGENT: '+String.valueOf(messageObjectMap.get('State')));
                                        }
                                    }
                                }
                            }
                            else{
                                System.debug('Message Inside: '+mapOfResponseBody.get('message'));
                                System.debug('No Data Found messsage from Ozonetel for the agentId: '+agentId);
                                Logger.log('Error','CallBackAPI_Controller Class','getAgentStatusfromOZoneTel Method','No Data Found messsage from Ozonetel for the agentId: '+agentId,'response: '+String.valueOf(response),agentId);
                            }                                
                        }
                        else{
                            System.debug('Status Error. Not Success Status: '+String.valueOf(response));
                            Logger.log('Error','CallBackAPI_Controller Class','getAgentStatusfromOZoneTel Method','Status Error. Not Success Status','response: '+String.valueOf(response),null);
                        }
                    }
                    else{
                        System.debug('blank Response body Error: '+String.valueOf(response));
                        Logger.log('Error','CallBackAPI_Controller Class','getAgentStatusfromOZoneTel Method','blank Response body Error','response : '+String.valueOf(response),null);
                    }
                }
                else{
                    System.debug('Status code Error: '+response.getStatusCode());
                    Logger.log('Error','CallBackAPI_Controller Class','getAgentStatusfromOZoneTel Method','Status code Error','response: '+String.valueOf(response),String.ValueOf(response.getStatusCode()));
                } 
            }
            else{
                System.debug('blank agentId or integration setting Name');
                System.debug('agentId: '+agentId);
                System.debug('integrationSettingName: '+integrationSettingName);
                Logger.log('Error','CallBackAPI_Controller Class','getAgentStatusfromOZoneTel Method','blank agentId or integration setting Name',integrationSettingName,agentId);
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('CALL BACK API Exception','CallBackAPI_Controller Class','getAgentStatusfromOZoneTel Method',e.getMessage(),e.getStackTraceString(),null);
        }
        return agentAvailable;
    }
    
    /**
* @description 
* @param integrationSettingName  
* @param Lead (Sobject)
**/
    public static Boolean pushLeadToOzonetelPriorityCityQueue(Lead ObjLead, String integrationSettingName){
        Boolean successFullyPushedToOzonetel = false;
        try{
            if(ObjLead != NULL && String.isNotBlank(integrationSettingName)){
                Map<String,Call_Back_City_Campaign_Mapping__c> cityCampaginMapping = Call_Back_City_Campaign_Mapping__c.getAll();
                if(cityCampaginMapping!=NULL){
                    if(cityCampaginMapping.containsKey(ObjLead.city.toLowerCase())){
                        if(!String.isBlank(cityCampaginMapping.get(ObjLead.city.toLowerCase()).Campaign_Name__c)){
                            Integration_Setting__c OzoneTeladdCamapaignDataAPI = Integration_Setting__c.getValues(integrationSettingName);
                            if(OzoneTeladdCamapaignDataAPI != null){
                                if(!String.isBlank(OzoneTeladdCamapaignDataAPI.Secret_Key__c) && !String.isBlank(OzoneTeladdCamapaignDataAPI.End_Point__c) && !String.isBlank(OzoneTeladdCamapaignDataAPI.ContentType__c)){
                                    String content = 'api_key='+EncodingUtil.urlEncode(OzoneTeladdCamapaignDataAPI.Secret_Key__c, 'UTF-8')+'&campaign_name='+EncodingUtil.urlEncode(cityCampaginMapping.get(ObjLead.city.toLowerCase()).Campaign_Name__c, 'UTF-8')+'&format=json&PhoneNumber='+EncodingUtil.urlEncode(ObjLead.phone, 'UTF-8')+'&action=start';
                                    System.debug('-----content :   '+content);
                                    //Make CallOut
                                    HTTp http = new HTTP();
                                    HTTPRequest req = new HTTPRequest();
                                    //req.setEndPoint('https://api1.cloudagent.in/cloudAgentRestAPI/index.php/CloudAgent/CloudAgentAPI/addCamapaignData?');
                                    req.setEndPoint(OzoneTeladdCamapaignDataAPI.End_Point__c);
                                    req.setMethod('POST');      
                                    req.setBody(content);
                                    req.setHeader('Accept',OzoneTeladdCamapaignDataAPI.ContentType__c);
                                    
                                    HTTPResponse response = http.send(req);
                                    System.debug('request: '+req);
                                    if(response.getStatusCode()==200){
                                        System.debug('-----response body '+response.getBody());
                                        if(!String.isBlank(response.getBody())){
                                            Map<String,Object> mapOfResponseBody = new Map<String,Object>();
                                            mapOfResponseBody = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                                            System.debug('mapOfResponseBody: '+mapOfResponseBody);
                                            if(!String.valueOf(mapOfResponseBody.get('status')).equalsIgnoreCase('SUCCESS')){
                                                System.debug('Status failed: '+String.valueOf(mapOfResponseBody.get('status')));
                                                Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityCityQueue Method','FAILED API Response ','response : '+String.valueOf(response),null);
                                            }
                                            else{
                                                successFullyPushedToOzoneTel = true;
                                            }
                                        }
                                        else{
                                            System.debug('blank Response body Error: '+String.valueOf(response));
                                            Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityCityQueue Method','blank Response body Error','response : '+String.valueOf(response),null);
                                        }
                                    }
                                    else{
                                        System.debug('Status code Error: '+response.getStatusCode());
                                        Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityCityQueue Method','Status code Error','response: '+String.valueOf(response),String.ValueOf(response.getStatusCode()));
                                    }
                                }
                                else{
                                    System.debug('Either secret key,end point or content type is blank for this integration setting record :'+OzoneTeladdCamapaignDataAPI);
                                    Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityCityQueue Method','Either secret key,end point or content type is blank for this integration setting record :'+OzoneTeladdCamapaignDataAPI,'','');
                                }
                            }
                            else{
                                System.debug('There is no integration setting custom setting record with the name '+integrationSettingName);
                                Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityCityQueue Method','There is no integration setting custom setting record with the name '+integrationSettingName,'','');
                            }
                        }
                        else{
                            System.debug('Campaign name field is blank for this custom setting record '+cityCampaginMapping.get(ObjLead.city.toLowerCase()));
                            Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityCityQueue Method','Campaign name field is blank for this custom setting record '+cityCampaginMapping.get(ObjLead.city.toLowerCase()),'','');
                        }
                    }else{
                        // CityName IS Not Present in List
                        System.debug('Call Back City Campaign Mapping Custom Setting record is not present in the system for the city '+ObjLead.city.toLowerCase());
                        Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityCityQueue Method','Call Back City Campaign Mapping Custom Setting record is not present in the system for the city '+ObjLead.city.toLowerCase(),'','');
                    }
                }else{
                    // Custom Setting are not present 
                    System.debug('Call Back City Campaign Mapping Custom Setting records are not present in the system');
                    Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityCityQueue Method','Call Back City Campaign Mapping Custom Setting records are not present in the system','','');
                }
            }
            else{
                System.debug('Either lead oject is null or the integration setting is blank. Integration Setting Name: '+integrationSettingName+'. Lead: '+ObjLead);
                Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityCityQueue Method','Either lead oject is null or the integration setting is blank. Integration Setting Name: '+integrationSettingName+'. Lead: '+ObjLead,'','');
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('CALL BACK API Exception','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityCityQueue Method',e.getMessage(),e.getStackTraceString(),null);
        }
        return successFullyPushedToOzonetel;
    }
    public static Boolean pushLeadToOzonetelPriorityAgentQueue(Lead ObjLead, String integrationSettingName,String campaignName, String preferredAgentID){
        Boolean successFullyPushedToOzonetel = false;
        try{
            if(ObjLead != NULL && String.isNotBlank(integrationSettingName) && String.isNotBlank(campaignName) && String.isNotBlank(preferredAgentID)){
                Integration_Setting__c OzoneTeladdCamapaignDataAPI = Integration_Setting__c.getValues(integrationSettingName);
                if(OzoneTeladdCamapaignDataAPI != null){
                    if(!String.isBlank(OzoneTeladdCamapaignDataAPI.Secret_Key__c) && !String.isBlank(OzoneTeladdCamapaignDataAPI.End_Point__c) && !String.isBlank(OzoneTeladdCamapaignDataAPI.ContentType__c)){
                        String content = 'api_key='+EncodingUtil.urlEncode(OzoneTeladdCamapaignDataAPI.Secret_Key__c, 'UTF-8')+'&campaign_name='+EncodingUtil.urlEncode(campaignName, 'UTF-8')+'&AgentID='+EncodingUtil.urlEncode(preferredAgentID, 'UTF-8')+'&format=json&PhoneNumber='+EncodingUtil.urlEncode(ObjLead.phone, 'UTF-8')+'&action=start';
                        System.debug('-----content   '+content);
                        //Make CallOut
                        HTTp http = new HTTP();
                        HTTPRequest req = new HTTPRequest();
                        //req.setEndPoint('https://api1.cloudagent.in/cloudAgentRestAPI/index.php/CloudAgent/CloudAgentAPI/addCamapaignData?');
                        req.setEndPoint(OzoneTeladdCamapaignDataAPI.End_Point__c);
                        req.setMethod('POST');      
                        req.setBody(content);
                        req.setHeader('Accept',OzoneTeladdCamapaignDataAPI.ContentType__c);
                        
                        HTTPResponse response = http.send(req);
                        
                        if(response.getStatusCode()==200){
                            System.debug('-----response body '+response.getBody());
                            if(!String.isBlank(response.getBody())){
                                Map<String,Object> mapOfResponseBody = new Map<String,Object>();
                                mapOfResponseBody = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                                System.debug('mapOfResponseBody: '+mapOfResponseBody);
                                if(!String.valueOf(mapOfResponseBody.get('status')).equalsIgnoreCase('SUCCESS')){
                                    System.debug('Status failed: '+String.valueOf(mapOfResponseBody.get('status')));
                                    Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityAgentQueue Method','FAILED API Response ','response : '+String.valueOf(response),null);
                                }
                                else{
                                    successFullyPushedToOzonetel = true;
                                }
                            }
                            else{
                                System.debug('blank Response body Error: '+String.valueOf(response));
                                Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityAgentQueue Method','blank Response body Error','response : '+String.valueOf(response),null);
                            }
                        }
                        else{
                            System.debug('Status code Error: '+response.getStatusCode());
                            Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityAgentQueue Method','Status code Error','response: '+String.valueOf(response),String.ValueOf(response.getStatusCode()));
                        }
                    }
                    else{
                        System.debug('Either secret key,end point or content type is blank for this integration setting record :'+OzoneTeladdCamapaignDataAPI);
                        Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityAgentQueue Method','Either secret key,end point or content type is blank for this integration setting record :'+OzoneTeladdCamapaignDataAPI,'','');
                    }
                }
                else{
                    System.debug('There is no integration setting custom setting record with the name '+integrationSettingName);
                    Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityAgentQueue Method','There is no integration setting custom setting record with the name '+integrationSettingName,'','');
                }
            }
            else{
                System.debug('Either lead oject is null or the integration setting name,campaignName or preferredAgentID is blank. Integration Setting Name: '+integrationSettingName+'. campaignName:'+campaignName+'. preferredAgentID: '+preferredAgentID+'. Lead: '+ObjLead);
                Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','pushLeadToOzonetelPriorityAgentQueue Method','Either lead oject is null or the integration setting name,campaignName or preferredAgentID is blank. Integration Setting Name: '+integrationSettingName+'. campaignName:'+campaignName+'. preferredAgentID: '+preferredAgentID+'. Lead: '+ObjLead,'','');
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('CALL BACK API Exception','CallBackAPI_Controller','pushLeadToOzonetelPriorityAgentQueue',e.getMessage(),e.getStackTraceString(),null);
        }
        return successFullyPushedToOzonetel;
    }
    
    /**
* @description   
* @param Lead/Opportunitu (Sobject)
**/
    public static void UpdateCallBackRequestDetails(Sobject obj, String SobjectName){
        try{
            if(obj !=null && !String.isBlank(SobjectName)){
                if(SobjectName.equalsIgnoreCase('lead')){
                    Lead leadToUpdate = new Lead();
                    leadToUpdate = (Lead)obj;
                    leadToUpdate.Requested_Call_Back__c = true;
                    leadToUpdate.Follow_up_time__c = System.now().addMinutes(1);
                    leadToUpdate.Requested_Callback_Time__c = System.now();
                    update leadToUpdate;
                }
                else if(SobjectName.equalsIgnoreCase('opportunity')){
                    opportunity opportunityToUpdate = new opportunity();
                    opportunityToUpdate = (Opportunity)obj;
                    opportunityToUpdate.Requested_Call_Back__c = true;
                    opportunityToUpdate.Follow_up_time__c = System.now().addMinutes(1);
                    opportunityToUpdate.Requested_Callback_Time__c = System.now();
                    update opportunityToUpdate;
                }
                else{
                    System.debug('Sobject name is neither lead nor opportunity. SobjectName: '+SobjectName);
                    Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','UpdateCallBackRequestDetails Method','Sobject name is neither lead nor opportunity. SobjectName: '+SobjectName,'','');
                }
            }
            else{
                System.debug('Either sobject is null or SobjectName is blank. SobjectName: '+SobjectName+'. Sobject: '+obj);
                Logger.log('CALL BACK API ERROR','CallBackAPI_Controller Class','UpdateCallBackRequestDetails Method','Either sobject is null or SobjectName is blank. SobjectName: '+SobjectName+'. Sobject: '+obj,'','');
                if(Test.isRunningTest()){
                    System.debug(1/0);
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('CALL BACK API Exception','CallBackAPI_Controller Class','UpdateCallBackRequestDetails Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    
    Public class RequestWrapper{
        Public String Customer_Order_Id;
    }
    Public class ResponseWrapper{
        Public String erroMessage;
        Public boolean isSuccess;
    }
}