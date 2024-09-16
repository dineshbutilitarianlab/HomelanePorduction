/*
* $Author: Bharatesh Shetty
* $Company: Warpdrive Tech works
* $Date: 15/08/2020 
*/

@RestResource(urlMapping='/SubOrderCreation/*')
global class SubOrderCreation{
    //private static String strErrorMsg = '';
    @HttpPost
    global static void subOrderCreation(){
        //Initialize the value for the response as an error response so that only once if it successully creates the records the success response values will be set.
        Response response =new Response();
        response.message = 'Some error occurred contact Salesforce Admin';
        response.success_code = '501';
        response.SFLeadId = '';
        response.LeadOrder_UniqueID = '';
        Boolean shouldCreateOppoortunity = False;
        List<Log__c> listOfLogsToInsert = new List<Log__c>();
        List<Lead> listOfLeadsToConvertToOpportunity = New List<Lead>();
        try{
            //creating instance to get request data 
            RestRequest req = RestContext.request;
            String requestBodyString = req.requestBody.toString();
            system.debug('******requestBodyString*******'+requestBodyString );
            if(!String.isBlank(requestBodyString)){
                Map<String, Object> mapOfJSONRequestConstructed = new Map<String, Object>();
                //Deserialized map of JSON request string body
                mapOfJSONRequestConstructed = (Map<String, Object>)JSON.deserializeUntyped(requestBodyString);
                system.debug('******mapOfJSONRequestConstructed *******'+mapOfJSONRequestConstructed );
                if(!mapOfJSONRequestConstructed.isEmpty()){
                    Map<String,Integration_Points_Sub_Order__c> mapOfLabelAndIntegrationPointCS = new Map<String,Integration_Points_Sub_Order__c>();
                    for(Integration_Points_Sub_Order__c intPoint: [select name, Object_Name__c, Field_Name__c, Field_Label__c, In_Use__c,Field_Data_Type__c  
                                                                         from Integration_Points_Sub_Order__c    
                                                                         where In_Use__c = TRUE]){
                                                                             if(!String.isBlank(intPoint.Field_Label__c)){
                                                                                 mapOfLabelAndIntegrationPointCS.put(intPoint.Field_Label__c,intPoint);
                                                                             } 
                                                                         }
                    if(!mapOfLabelAndIntegrationPointCS.isEmpty()){
                        if(mapOfJSONRequestConstructed.containskey(GenericConstants.SOBJECT_ACCOUNT) && mapOfJSONRequestConstructed.containskey(GenericConstants.MAIN_ORDER)){
                            if(mapOfJSONRequestConstructed.get(GenericConstants.SOBJECT_ACCOUNT) !=null && mapOfJSONRequestConstructed.get(GenericConstants.MAIN_ORDER)!=null){
                                Account parentAccount = new Account();
                                Lead parentLead = new Lead();
                                parentAccount = AccountSelector.getAccountById((String)mapOfJSONRequestConstructed.get(GenericConstants.SOBJECT_ACCOUNT));
                                if(parentAccount!=null){
                                    parentLead = LeadSelector.getLeadById((String)mapOfJSONRequestConstructed.get(GenericConstants.MAIN_ORDER));
                                    if(parentLead!=null){
                                        Lead subOrderLead = new Lead();
                                        //Copy values from parent Account
                                        subOrderLead.Account__c = parentAccount.Id;
                                        subOrderLead.LastName = parentAccount.LastName;
                                        subOrderLead.firstname = parentAccount.firstname;
                                        subOrderLead.Area_Code__c = parentAccount.Area_Code__c;
                                        subOrderLead.Alt_Phone_Number__c = parentAccount.Alt_Phone_Number__c;
                                        subOrderLead.Alt_Email_ID__c = parentAccount.Alt_Email__c;
                                        subOrderLead.Phone = parentAccount.Phone;
                                       
                                        subOrderLead.Email = parentAccount.personEmail;
                                        subOrderLead.Whatsapp_Opt_in__c = parentAccount.Whatsapp_Opt_in__c;
                                        subOrderLead.Found_On_TC__c = parentAccount.Found_On_TC__c;
                                        subOrderLead.Brand__c = (String)mapOfJSONRequestConstructed.get('Brand__c');
                                        system.debug('mapOfJSONRequestConstructed brand'+ mapOfJSONRequestConstructed.get('Brand__c'));
									    //Copy values from Parent Lead
                                        subOrderLead.Main_Order__c = parentLead.Id;
                                        subOrderLead.Property__c = parentLead.Property__c;
                                        subOrderLead.Property_Report_UDP_URL__c = parentLead.Property_Report_UDP_URL__c;
                                        subOrderLead.Appointment_Venue_Site_Residence_City__c = parentLead.Appointment_Venue_Site_Residence_City__c;
                                        subOrderLead.Appointment_Venue_Site_Resi_Landmark__c = parentLead.Appointment_Venue_Site_Resi_Landmark__c;
                                        subOrderLead.Appointment_Venue_Site_Resi_Locality__c = parentLead.Appointment_Venue_Site_Resi_Locality__c;
                                        subOrderLead.Appointment_Venue_Site_Resi_State__c = parentLead.Appointment_Venue_Site_Resi_State__c;
                                        subOrderLead.Appointment_Venue_Site_Residence_Add1__c=parentLead.Appointment_Venue_Site_Residence_Add1__c;
                                        subOrderLead.Street=parentLead.Street;
                                        subOrderLead.Cubico__c=parentLead.Cubico__c;
                                                  
                                        Boolean DPandIMUpdatedFromParentOpp = false;
                                        if(parentLead.isConverted)
                                        {
                                            Opportunity parentOpportunity = OpportunitySelector.getOpportunityByOpportunityOrderID(parentLead.Customer_Id__c);
                                            if(parentOpportunity != null)
                                            {
                                                subOrderLead.Sales_Manager__c = parentOpportunity.Sales_Manager__c;
                                                subOrderLead.Sales_Manager_Email__c = parentOpportunity.Sales_Manager_Email__c;
                                                subOrderLead.Assigned_To_Resi_ASM__c = parentOpportunity.Assigned_To_Resi_ASM__c;
                                                subOrderLead.Interior_Designer__c = parentOpportunity.Interior_Design_Partner__c;
                                                DPandIMUpdatedFromParentOpp = true;
                                                
                                                //Added 
                                                subOrderLead.Budget_Range__c = parentOpportunity.Budget_Range__c;
                                                
                                            }
                                        }
                                        if(!DPandIMUpdatedFromParentOpp){
                                            subOrderLead.Sales_Manager__c = parentLead.Sales_Manager__c;
                                            subOrderLead.Sales_Manager_Email__c = parentLead.Sales_Manager_Email__c;
                                            subOrderLead.Assigned_To_Resi_ASM__c = parentLead.Assigned_To_Resi_ASM__c;
                                            subOrderLead.Interior_Designer__c = parentLead.Interior_Designer__c;
                                        }
                                        subOrderLead.City = parentLead.city;
                                        
                                        
                                        subOrderLead.PostalCode = parentLead.PostalCode;
                                        subOrderLead.LeadSource = parentLead.LeadSource;

                                        subOrderLead.Status = GenericConstants.LEAD_FRESH_STATUS;
                                        subOrderLead.Sub_Status__c = GenericConstants.LEAD_NEW_SUBSTATUS;
                                        subOrderLead.Property_Status__c = parentLead.Property_Status__c;
                                        subOrderLead.Property_Type__c = parentLead.Property_Type__c;
                                        subOrderLead.Property_Config__c = parentLead.Property_Config__c;
                                        subOrderLead.Interior_Start_Date__c = parentLead.Interior_Start_Date__c;
                                        subOrderLead.Possession_Date__c = parentLead.Possession_Date__c;
                                        subOrderLead.Kitchen__c = parentLead.Kitchen__c;
                                        subOrderLead.Crockery_Unit__c = parentLead.Crockery_Unit__c;
                                        subOrderLead.Entertainment_Unit__c = parentLead.Entertainment_Unit__c;
                                        subOrderLead.Pooja__c = parentLead.Pooja__c;
                                        subOrderLead.Study_Table_Book_Shelf__c = parentLead.Study_Table_Book_Shelf__c;
                                        subOrderLead.Foyer_Shoe_Rack__c = parentLead.Foyer_Shoe_Rack__c;
                                        subOrderLead.Wardrobes__c = parentLead.Wardrobes__c;
                                        subOrderLead.First_home__c = parentLead.First_home__c;
                                        subOrderLead.Purpose_of_Interiors__c = parentLead.Purpose_of_Interiors__c;
                                        subOrderLead.Budget_Range__c = parentLead.Budget_Range__c;
                                        subOrderLead.Meeting_Source__c = parentLead.Meeting_Source__c;
                                        subOrderLead.Basic_Q_Completed__c = parentLead.Basic_Q_Completed__c;
                                        subOrderLead.Design_Q_Completed__c = parentLead.Design_Q_Completed__c;
                                        
                                        subOrderLead.Channel_Partner__C = parentLead.Channel_Partner__C;
                                        subOrderLead.HL_Referrer_Phone__c = parentLead.HL_Referrer_Phone__c;
                                        
                                        //subOrderLead.Appointment_Time__c = parentLead.Appointment_Time__c;
                                        subOrderLead.Appointment_Type__c = parentLead.Appointment_Type__c;
                                        subOrderLead.Appointment_Venue_Square__c = parentLead.Appointment_Venue_Square__c;
                                        //subOrderLead.put('Sales_Manager__c', parentLead.get('Sales_Manager__c'));
                                        subOrderLead.OwnerId = System.Label.HomeLaneAPIUserId ;
                                        subOrderLead.WT_Agent__c = parentLead.WT_Agent__c;
                                        subOrderLead.Lead_Created_By__c = GenericConstants.LEAD_CREATED_BY_WEBSITE;
                                        subOrderLead.Lead_Assingment__c = True;
                                        if(mapOfJSONRequestConstructed.containsKey(GenericConstants.LEAD_SIGNUP_SOURCE)){
                                            if(mapOfJSONRequestConstructed.get(GenericConstants.LEAD_SIGNUP_SOURCE) !=Null){
                                                subOrderLead.Sign_Up_Source__c = (String)mapOfJSONRequestConstructed.get(GenericConstants.LEAD_SIGNUP_SOURCE);
                                            }
                                        }
                                        //Added for sub orders (asked by Satya) and will be copied to the Scope_Of_Work__c field on opportunity on Lead conversion.
                                        if(mapOfJSONRequestConstructed.containsKey(GenericConstants.SCOPE_OF_WORK)){
                                            if(mapOfJSONRequestConstructed.get(GenericConstants.SCOPE_OF_WORK) !=Null){
                                                subOrderLead.Scope_Of_Work__c = (String)mapOfJSONRequestConstructed.get(GenericConstants.SCOPE_OF_WORK);
                                            }
                                        }
                                        //Check if it's a SF user created Leads. If yes and If it's a WTA or WTM then assign that user as the WT Agent
                                        if(mapOfJSONRequestConstructed.containsKey(GenericConstants.MANUAL_LEAD_CREATION) && mapOfJSONRequestConstructed.containsKey(GenericConstants.SF_USER_EMAIL)){
                                            System.debug('Manual Lead Creation:'+mapOfJSONRequestConstructed.get(GenericConstants.MANUAL_LEAD_CREATION));
                                             System.debug('SF_User_Email:'+mapOfJSONRequestConstructed.get(GenericConstants.SF_USER_EMAIL));
                                            if(mapOfJSONRequestConstructed.get(GenericConstants.MANUAL_LEAD_CREATION)!= Null && !Boolean.valueOf(mapOfJSONRequestConstructed.get(GenericConstants.MANUAL_LEAD_CREATION)) && mapOfJSONRequestConstructed.get('SF_User_Email')!= Null){
                                                User userQueried = UserSelector.getUserByEmail(String.valueOf(mapOfJSONRequestConstructed.get(GenericConstants.SF_USER_EMAIL)));
                                                if(userQueried !=Null){
                                                    subOrderLead.Lead_Assingment__c = False;
                                                    if(userQueried.Profile.Name.equalsIgnoreCase(GenericConstants.PROFILE_WTA) || userQueried.Profile.Name.equalsIgnoreCase(GenericConstants.PROFILE_WTM)){
                                                        subOrderLead.Lead_Created_By__c = GenericConstants.LEAD_CREATED_BY_SFWT_USER;
                                                        subOrderLead.WT_Agent__C = userQueried.Id;
                                                    }
                                                    else{
                                                        subOrderLead.Lead_Created_By__c =GenericConstants.LEAD_CREATED_BY_SF_OTHER ;
                                                    }
                                                }
                                            }
                                        }
                                        
                                        if(mapOfJSONRequestConstructed.containsKey(GenericConstants.SUBORDER_ISDESIGNREQUIRED)){
                                            if(mapOfJSONRequestConstructed.get(GenericConstants.SUBORDER_ISDESIGNREQUIRED)!=Null && !Boolean.valueOf(mapOfJSONRequestConstructed.get(GenericConstants.SUBORDER_ISDESIGNREQUIRED))){
                                                shouldCreateOppoortunity = True;
                                                subOrderLead.isDesignNotRequired__c = True;  
                                                subOrderLead.Luxe_customer__c=parentLead.Luxe_customer__c ; // Newly added on request of Riya on 16th August 2024
                                            }
                                        }
                                        
                                        //Insert the Lead record
                                        insert subOrderLead;
                                        // Query the lead related details LeadOrder_UniqueID values 
                                        subOrderLead = LeadSelector.getLeadById(subOrderLead.Id);
                                        if(subOrderLead != NULL){
                                            // Add the SF Lead Id and the queried from the Lead created to the response body. And also set the success_code as 201 as sucess.
                                            System.debug('The Sub Order Lead has been created successfully in Salesforce.');
                                            response.SFLeadId = subOrderLead.Id;
                                            response.LeadOrder_UniqueID = subOrderLead.Customer_Id__c;
                                            response.success_code = '201';
                                            response.message = 'The Sub Order Lead has been created successfully in Salesforce.';
                                            if(shouldCreateOppoortunity){
                                                response.message += ' The opportunity will be created in some time as the design is Not required';
                                                listOfLeadsToConvertToOpportunity.add(subOrderLead);
                                            }
                                        }
                                        else{
                                            System.debug('Lead not returned in the query after Lead creation in Sub order creation API');
                                            response.message = 'Lead not returned in the query after Lead creation in Sub order creation API. Contact Salesforce Admin.';
                                            //capture the log
                                            listOfLogsToInsert.add(Logger.returnLog('Sub order creation Error','subOrderCreation Class','subOrderCreation method','Lead not returned in the query after Lead creation in Sub order creation API',subOrderLead.Id,''));
                                        }
                                    }
                                    else{
                                        System.debug('No Lead record found in Salesforce with Main_Order__c: '+(String)mapOfJSONRequestConstructed.get(GenericConstants.MAIN_ORDER)+' as the ID.');
                                        response.message = 'No Lead record found in Salesforce with Main_Order__c: '+(String)mapOfJSONRequestConstructed.get(GenericConstants.MAIN_ORDER)+' as the ID.';
                                        //capture the log
                                        listOfLogsToInsert.add(Logger.returnLog('Sub order creation Error','subOrderCreation Class','subOrderCreation method','No Lead record found in Salesforce with Main_Order__c: '+(String)mapOfJSONRequestConstructed.get(GenericConstants.MAIN_ORDER)+' as the ID.',(String)mapOfJSONRequestConstructed.get(GenericConstants.MAIN_ORDER),''));
                                    }
                                }
                                else{
                                    System.debug('No Account record found in Salesforce with Account__c:'+(String)mapOfJSONRequestConstructed.get(GenericConstants.SOBJECT_ACCOUNT)+' as the ID.');
                                    response.message = 'No Account record found in Salesforce with '+(String)mapOfJSONRequestConstructed.get(GenericConstants.SOBJECT_ACCOUNT)+' as the ID.';
                                    //capture the log
                                    listOfLogsToInsert.add(Logger.returnLog('Sub order creation Error','subOrderCreation Class','subOrderCreation method','No Account record found in Salesforce with Account__c'+(String)mapOfJSONRequestConstructed.get(GenericConstants.SOBJECT_ACCOUNT)+' as the ID.',(String)mapOfJSONRequestConstructed.get(GenericConstants.SOBJECT_ACCOUNT),''));
                                }
                            }
                            else{
                                System.debug('either Account__c or Main_Order__c parameter value is null for sub order in the json request. Account__c: '+mapOfJSONRequestConstructed.get('Account__c')+' . Main_Order__c: '+mapOfJSONRequestConstructed.get(GenericConstants.MAIN_ORDER));
                                response.message = 'either Account__c or Main_Order__c parameter value is null for sub order in the json request. Account__c: '+mapOfJSONRequestConstructed.get('Account__c')+' . Main_Order__c: '+mapOfJSONRequestConstructed.get(GenericConstants.MAIN_ORDER);
                                //capture the log
                                listOfLogsToInsert.add(Logger.returnLog('Sub order creation Error','subOrderCreation Class','subOrderCreation method','either Account__c or Main_Order__c parameter value is null for sub order in the json request. Account__c: '+mapOfJSONRequestConstructed.get(GenericConstants.SOBJECT_ACCOUNT)+' . Main_Order__c: '+mapOfJSONRequestConstructed.get(GenericConstants.MAIN_ORDER),(String)mapOfJSONRequestConstructed.get(GenericConstants.MAIN_ORDER),(String)mapOfJSONRequestConstructed.get(GenericConstants.SOBJECT_ACCOUNT))); 
                            }
                        }
                        else{
                            System.debug('mapOfJSONRequest does not contain Account__c and Main_Order__c parameter for sub order');
                            response.message = 'mapOfJSONRequest does not contain Account__c and Main_Order__c parameter for sub order';
                            //capture the log
                            listOfLogsToInsert.add(Logger.returnLog('Sub order creation Error','subOrderCreation Class','subOrderCreation method','mapOfJSONRequest does not contain Account__c and Main_Order__c parameter for sub order','',''));
                        }
                    }
                }
                else{
                    System.debug('deserialized mapOfJSONRequest is Empty.');
                    response.message = 'deserialized mapOfJSONRequest is Empty. Contact Salesforce Admin.';
                    //capture the log
                    listOfLogsToInsert.add(Logger.returnLog('Sub order creation Error','subOrderCreation Class','subOrderCreation method','deserialized mapOfJSONRequest is Empty','',''));
                }
            }
            else{
                System.debug('requestBodyString is blank');
                response.message = 'requestBodyString is blank. Contact Salesforce Admin.';
                //capture the log
                listOfLogsToInsert.add(Logger.returnLog('Sub order creation Error','subOrderCreation Class','subOrderCreation method','requestBodyString is blank','',''));
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
            //Log the exception
            Logger.log('Exception','SubOrderCreation class','SubOrderCreation method',e.getMessage(),e.getStackTraceString(),null);
        }
        //serialize the response wrapper to a string and add it as the response body
        string json_data = json.serialize(response);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(json_data);
        
        if(!listOfLeadsToConvertToOpportunity.isEmpty()){
            System.debug('shouldCreateOppoortunity: '+shouldCreateOppoortunity);
            System.enqueueJob(new ConvertLeadQueueableForDesignNotRequired(listOfLeadsToConvertToOpportunity));
        }
    }
    
    Private class Response
    {
        String message;
        String success_code;
        String SFLeadId;
        String LeadOrder_UniqueID;
    }
}