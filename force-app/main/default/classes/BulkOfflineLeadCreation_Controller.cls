/**
* @File Name          : BulkOfflineLeadCreation_Controller.cls
* @Description        : 
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Soniya Kocher
* @Last Modified On   : 11/10/2022, 5:06:12 PM
* @Modification Log   : 
* Ver       Date            Author              Modification
* 1.0    2/25/2020   Bharatesh Shetty     Initial Version
**/
@RestResource(urlMapping='/BulkOfflineLeadCreationAPI/*')
global class BulkOfflineLeadCreation_Controller 
{
    /**
* @description ||
* @author Bharatesh Shetty | 2/25/2020 
* @return void 
**/
    
    Public Static Boolean CP_assigned_recently;   
    Public Static Boolean deadInLastMonth; 
    Public Static Boolean leadCreatedRecently; 
    Public Static String OriginalLeadSource;
    Public Static Boolean Reland_the_Lead; 
    Public Static Id reactivateLeadId;
    Public Static String Lead_Status ; 
    Public Static String Lead_Source ; 
    Public Static String Lead_Brand ; 
    Public Static Boolean Lead_Bulk_Upload_Flag;
    Public Static DateTime CP_Assignment_Date;
    
    
    @HttpPost
    global static void bulkOfflineLeadCreation() 
    {
        RestResponse res = new RestResponse();
        RestRequest req = RestContext.request;
        ResponseWrapper respWrap = new ResponseWrapper();
        String inputData = req.requestBody.toString();
        Boolean isResponseSent = false;
        Boolean isRunPCAssignment=false;
        String logErrorMessage = '';         
        CP_assigned_recently=false;
        set<id> idSet = new Set<id>();
        try
        {
            if(String.isNotBlank(inputData))
            {
                Map<String,Object> mapOfLeadFieldsAndValues = new Map<String,Object>();
                mapOfLeadFieldsAndValues = (Map<String,Object>)Json.deserializeUntyped(inputData);
                String brandOfLead = String.valueOf(mapOfLeadFieldsAndValues.get('Brand__c'));
                String verified = String.valueOf(mapOfLeadFieldsAndValues.get('verification'));
                String LeadSource = String.valueOf(mapOfLeadFieldsAndValues.get('LeadSource'));
                String HL_Referrer_Phone = String.valueOf(mapOfLeadFieldsAndValues.get('HL_Referrer_Phone__c'));
                system.debug('verified'+ verified);
                system.debug('LeadSource'+ LeadSource);
                
                if(String.isBlank(brandOfLead))
                {
                    brandOfLead= 'Homelane';
                }
                system.debug('brandOfLead '+ brandOfLead);
                brandOfLead = brandOfLead.trim();
                system.debug('brandOfLead after trim '+ brandOfLead);
                if(!mapOfLeadFieldsAndValues.isEmpty())
                {
                    System.debug('mapOfLeadFieldsAndValues: '+mapOfLeadFieldsAndValues);
                    if(mapOfLeadFieldsAndValues.containskey('Email') && mapOfLeadFieldsAndValues.containskey('Phone'))
                    {
                        if(!String.isBlank(String.valueOf(mapOfLeadFieldsAndValues.get('Email'))) && !String.isBlank(String.valueOf(mapOfLeadFieldsAndValues.get('Phone'))))
                        {
                            	Set<String> setOfInactiveStatus = new Set<String>{GenericConstants.LEAD_DEAD_STATUS,GenericConstants.LEAD_NOT_ACTIVELY_PURSUED_STATUS};
                                Set<String> setOfInactiveSubStatus = new Set<String>{'Renovation/Civil work required','Exceeded Max Attempts'};
                                Map<String,Bulk_Offline_Lead_Creation_Fields__c> mapOfFieldNameAndMappingsRecord = new Map<String,Bulk_Offline_Lead_Creation_Fields__c>();
                            	for(Bulk_Offline_Lead_Creation_Fields__c mapRec : [Select Id,Name,Field_API_Name__c,Field_Data_Type__c,Field_Label_Name__c,In_Use__c,OverRide_InCase_Of_Duplication__c,UseInAccount__c
                                                                               From Bulk_Offline_Lead_Creation_Fields__c
                                                                              ])
                            	{
                                    	mapOfFieldNameAndMappingsRecord.put(mapRec.Field_API_Name__c,mapRec);
                                }
                            
                            	//--------------------------------Fetching all accounts related to given Email/Phone---------------------------------------------//
                            	
                            	List<Account> ListOfAccountsQueried = AccountSelector.getListOfAccountsByEmailOrPhone(String.valueOf(mapOfLeadFieldsAndValues.get('Email')), String.valueOf(mapOfLeadFieldsAndValues.get('Phone')));
                            	Account parentAccountRecord;
                            	System.debug('ListOfAccountsQueried'+ListOfAccountsQueried);
                            
                            	//-------------------------------- No Account found related to given Email/Phone then Create a new Account------------------------//
                                if(ListOfAccountsQueried.isEmpty())
                                {
                                    //No duplicate Accounts which means a fresh customer 
                                    
                                    if(String.isNotBlank(verified) && verified =='True')
                                    {
                                        respWrap.Status = 'SUCCESS';
                                        respWrap.Message = 'New Account and a new Lead can be Created';
                                        RestContext.response.addHeader('Content-Type', 'application/json');
                                        RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
                                        isResponseSent = true;
                                	}
                                	else
                                	{
                                            parentAccountRecord = createAccountRecord(mapOfFieldNameAndMappingsRecord,mapOfLeadFieldsAndValues);
                                            if(parentAccountRecord != null)
                                            {
                                                //By default it will be false and will be set to true for all the Blitz offline leads while creation via BulkOfflineLeadCreationAPI.
                                                parentAccountRecord.Customer_Not_Registered__c = true;
                                                insert parentAccountRecord;
                                                System.debug('mapOfFieldNameAndMappingsRecord'+mapOfFieldNameAndMappingsRecord);
                                                System.debug('mapOfLeadFieldsAndValues'+mapOfLeadFieldsAndValues);
                                                
                                                //Create a New Lead under the account
                                                Lead leadToInsert = createLeadRecord(mapOfFieldNameAndMappingsRecord,mapOfLeadFieldsAndValues,'INSERT',parentAccountRecord.Id);
                                                //Insert the lead
                                                if(leadToInsert != null)
                                                {
                                                    //By default it will be false and will be set to true for all the Blitz offline leads while creation via BulkOfflineLeadCreationAPI.
                                                     if(leadToInsert.Brand__c == GenericConstants.LEAD_DOOWUP)
                                                     {
                                                         leadToInsert.Order_not_Registered__c = False;
                                                     }
                                                    else
                                                    {
                                                          leadToInsert.Order_not_Registered__c= True;
                                                    }
                                                    //leadToInsert.Order_not_Registered__c = True;
                                                    leadToInsert.Account__c = parentAccountRecord.Id;
                                                    leadToInsert.Email = parentAccountRecord.PersonEmail;
                                                    if(brandOfLead == GenericConstants.Brand_Cubico)
                                                    {
                                                        id foundShowroomId = null;
                                                        system.debug('leadToInsert.City '+ leadToInsert.City);
                                                        LeadTriggerCubicoAndDoowupHandler.showroomCityMap = LeadTriggerCubicoAndDoowupHandler.getcubicoShowroomMetadata();
                                                        foundShowroomId = LeadTriggerCubicoAndDoowupHandler.getCubicoShowroom(leadToInsert.City, LeadTriggerCubicoAndDoowupHandler.showroomCityMap);
                                                        
                                                        if(foundShowroomId != null)
                                                        {                                                      
                                                            leadToInsert.Appointment_Venue_Square__c = foundShowroomId;
                                                            leadToInsert.Sign_Up_Source__c= GenericConstants.Brand_Cubico;
                                                            leadToInsert.Brand__c=GenericConstants.LEAD_HOMELANE;  
                                                        }  
                                                    }
                                                    
                                                    if(brandOfLead == GenericConstants.Brand_Wrapzap)
                                                    {
                                                            System.debug('LeadSource '+String.valueOf(mapOfLeadFieldsAndValues.get('LeadSource')));
                                                            leadToInsert.Appointment_Venue_Square__c = Label.Wrapzap_Showroom_ID;
                                                            leadToInsert.Sign_Up_Source__c= GenericConstants.Brand_Wrapzap;
                                                            leadToInsert.Brand__c=GenericConstants.Brand_Wrapzap;
                                                            leadToInsert.LeadSource = String.valueOf(mapOfLeadFieldsAndValues.get('LeadSource'));
                                                    }
                                                    
                                                    insert leadToInsert;
                                                    
                                                    respWrap.Status = 'SUCCESS';
                                                    respWrap.Message = 'New Account and a new Lead Created. SF Lead ID: '+leadToInsert.Id;
                                                    RestContext.response.addHeader('Content-Type', 'application/json');
                                                    RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
                                                    isResponseSent = true;
                                                    //isRunPCAssignment=true;
                                                    system.debug('leadToInsert.Id'+leadToInsert.Id);
                                                 
                                                 	//idSet.add(leadToInsert.Id);
                                                    //BulkOfflineLeadCreation_Controller.assignPC(leadToInsert.Id);
                                                    
                                                }
                                                else
                                                {
                                                    System.debug('createLeadRecord method has returned null value');
                                                    logErrorMessage = 'createLeadRecord method has returned null value';
                                                }
                                            }
                                            else
                                            {
                                                System.debug('parentAccountRecord is null. parentAccountRecord: '+parentAccountRecord);
                                            }
                                        }
                                
                            	}
                            
                            	//If only one matching account found then it will be considered to check the next conditions
                                //If multiple matching accounts found the precedence/Priority is given to the account with phone number match
                                else
                                {                                    
                                    for(Account matchedAccount : ListOfAccountsQueried)
                                    {
                                        if(matchedAccount.Phone == String.valueOf(mapOfLeadFieldsAndValues.get('Phone')))
                                        {
                                            parentAccountRecord = matchedAccount;
                                            break;
                                        }
                                        else
                                        {
                                            parentAccountRecord = matchedAccount;                                            
                                        }
                                    }
                                    if(parentAccountRecord !=null)
                                    {
                                        System.debug('88888888');
                                        List<Lead> listOfQueriedLeads = new List <Lead>();
                                        Lead leadToReactivate;
                                        
                                        //Query for only the leads (non converted)                                       
                                        if(brandOfLead == GenericConstants.Brand_Cubico)
                                        {
                                            system.debug('GenericConstants.Brand_Cubico '+ GenericConstants.Brand_Cubico+ 'brandOfLead'+ brandOfLead);
                                            listOfQueriedLeads= [SELECT id,Email,Phone,Status,Sub_Status__c,Sales_Manager__c,Assigned_to_Resi_ASM__c,Sales_Manager_Email__c,Bulk_Upload__c,
                                                                 Tele_caller__c,Telecaller_Email__c,Assigned_To_TLC__c,Brand__c,createdDate,Assignment_Initiate_Stage__c,LeadSource,CP_Assignment_Date__c
                                                                 From Lead
                                                                 WHERE Account__c =: parentAccountRecord.Id AND Sign_Up_Source__c=:GenericConstants.Brand_Cubico
                                                                ];
                                        }
                                        else if(brandOfLead == GenericConstants.Brand_Wrapzap)
                                        {
                                            system.debug('GenericConstants.Brand_Wrapzap '+ GenericConstants.Brand_Wrapzap+ 'brandOfLead'+ brandOfLead);
                                            listOfQueriedLeads= [SELECT id,Email,Phone,Status,Sub_Status__c,Sales_Manager__c,Assigned_to_Resi_ASM__c,Sales_Manager_Email__c,Bulk_Upload__c,
                                                                 Tele_caller__c,Telecaller_Email__c,Assigned_To_TLC__c,Brand__c,createdDate,Assignment_Initiate_Stage__c,LeadSource,CP_Assignment_Date__c
                                                                 From Lead
                                                                 WHERE Account__c =: parentAccountRecord.Id AND (Sign_Up_Source__c= :GenericConstants.Brand_Wrapzap  OR  Brand__c = :GenericConstants.Brand_Wrapzap)
                                                                 order by CreatedDate asc
                                                                ];                                       
                                        }
                                        else if(brandOfLead == GenericConstants.LEAD_DOOWUP)
                                        {
                                            system.debug('GenericConstants.LEAD_DOOWUP '+ GenericConstants.LEAD_DOOWUP+ 'brandOfLead'+ brandOfLead);
                                            listOfQueriedLeads = [Select id,Email,Phone,Status,Sub_Status__c,Sales_Manager__c,Assigned_to_Resi_ASM__c,Sales_Manager_Email__c,Bulk_Upload__c,
                                                                  Tele_caller__c,Telecaller_Email__c,Assigned_To_TLC__c,Brand__c,createdDate,Assignment_Initiate_Stage__c,LeadSource,CP_Assignment_Date__c
                                                                  From Lead
                                                                  Where Account__c =: parentAccountRecord.Id and IsConverted = False and Brand__c =:brandOfLead and 
                                                                  Sign_Up_Source__c !=:GenericConstants.Brand_Cubico AND Sign_Up_Source__c !=:GenericConstants.Brand_Wrapzap
                                                                  order by CreatedDate asc
                                                                 ];
                                        }
                                        else
                                        {
                                            system.debug('brandOfLead'+ brandOfLead);
                                            listOfQueriedLeads = [Select id,Email,Phone,Status,Sub_Status__c,Sales_Manager__c,Assigned_to_Resi_ASM__c,Sales_Manager_Email__c,Bulk_Upload__c,
                                                                  Tele_caller__c,Telecaller_Email__c,Assigned_To_TLC__c,Brand__c,createdDate,Assignment_Initiate_Stage__c,LeadSource,CP_Assignment_Date__c
                                                                  From Lead
                                                                  Where Account__c =: parentAccountRecord.Id and IsConverted = False and (Brand__c =:brandOfLead or Brand__c=null) and 
                                                                  Sign_Up_Source__c !=:GenericConstants.Brand_Cubico AND Sign_Up_Source__c !=:GenericConstants.Brand_Wrapzap
                                                                  order by CreatedDate asc
                                                                 ];
                                        }
                                        Reland_the_Lead = false;
                                        System.debug('listOfQueriedLeads'+listOfQueriedLeads);
                                        
                                        //--------------------------------If no lead found under the existing Account----------------------------------------//
                                        
                                        if(listOfQueriedLeads.isEmpty())
                                        {
                                                    System.debug('listOfQueriedLeads is empty under the account');
                                                    //This logic has been commented out and changed after the change of requirement from Arun on 15th Jan 2021.
                                                    //3.If there is no lead (inactive / active) in the system and only opportunities, then a new lead via Bulk Upload will be created with the flag Order not registered? set as True.
                                                    //Create a New Lead under the account
                                                    /*Lead leadToInsert = createLeadRecord(mapOfFieldNameAndMappingsRecord,mapOfLeadFieldsAndValues,'INSERT',parentAccountRecord.Id);
                                                    System.debug('leadToInsert'+leadToInsert);
                                                    //Insert the lead
                                                    if(leadToInsert != null){
                                                    //By default it will be false and will be set to true for all the Blitz offline leads while creation via BulkOfflineLeadCreationAPI.
                                                    leadToInsert.Order_not_Registered__c = True;
                                                    leadToInsert.Account__c = parentAccountRecord.Id;
                                                    insert leadToInsert;
                                                    respWrap.Status = 'SUCCESS';
                                                    respWrap.Message = 'New Lead Created as there was no lead (inactive / active) or only opportunities under the Account: '+ parentAccountRecord.Id+' . SF Lead ID: '+leadToInsert.Id;
                                                    RestContext.response.addHeader('Content-Type', 'application/json');
                                                    RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
                                                    isResponseSent = true;
                                                    }
                                                    else{
                                                    System.debug('createLeadRecord method has returned null value');
                                                    logErrorMessage = 'createLeadRecord method has returned null value';
                                                    }*/
                                                    
                                                    //Logic has been changed as below.
                                                    //If there is no order in lead stage means that atleast one order in opportunity stage. So throw error and do not create a new lead in this case.
                                                    
                                                    List<Opportunity> listOfQueriedOpps = new List <Opportunity>();
                                                    if(brandOfLead == GenericConstants.Brand_Cubico)
                                                    {
                                                        system.debug('GenericConstants.Brand_Cubico '+ GenericConstants.Brand_Cubico+ 'brandOfLead'+ brandOfLead);
                                                        listOfQueriedOpps= [Select id from Opportunity where AccountId =: parentAccountRecord.Id  and Sign_Up_Source__c=:GenericConstants.Brand_Cubico];
                                                    }
                                                    else if(brandOfLead == GenericConstants.Brand_Wrapzap)
                                                    {
                                                        system.debug('GenericConstants.Brand_Wrapzap '+ GenericConstants.Brand_Wrapzap+ 'brandOfLead'+ brandOfLead);
                                                        listOfQueriedOpps= [Select id from Opportunity where AccountId =: parentAccountRecord.Id  and (Sign_Up_Source__c=:GenericConstants.Brand_Wrapzap OR Brand__c = :GenericConstants.Brand_Wrapzap)];
                                                    }
                                                    else if(brandOfLead == GenericConstants.LEAD_DOOWUP )
                                                    {
                                                         system.debug('GenericConstants.Brand_Cubico '+ GenericConstants.Brand_Cubico+ 'brandOfLead'+ brandOfLead);
                                                        listOfQueriedOpps = [Select id from Opportunity where AccountId =: parentAccountRecord.Id  and Brand__c =:brandOfLead and 
                                                                             Sign_Up_Source__c !=:GenericConstants.Brand_Cubico AND Sign_Up_Source__c !=:GenericConstants.Brand_Wrapzap ];
                                                    }
                                                    else
                                                    {
                                                        system.debug('GenericConstants.Brand_Cubico '+ GenericConstants.Brand_Cubico+ 'brandOfLead'+ brandOfLead);
                                                        listOfQueriedOpps = [Select id from Opportunity where AccountId =: parentAccountRecord.Id  and (Brand__c =:brandOfLead OR Brand__c =null) and 
                                                                             Sign_Up_Source__c !=:GenericConstants.Brand_Cubico AND Sign_Up_Source__c !=:GenericConstants.Brand_Wrapzap];
                                                    }
                                                    system.debug('listOfQueriedOpps'+ listOfQueriedOpps);
                                                    if(!listOfQueriedOpps.isEmpty())
                                                    {
                                                        respWrap.Status = 'FAILURE 1';
                                                        respWrap.Message = 'Lead Cannot be created';
                                                        RestContext.response.addHeader('Content-Type', 'application/json');
                                                        RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
                                                        isResponseSent = true;
                                                    }
                                                    else
                                                    {
                                                        //Create a New Lead under the account because there was no lead and no opportunity under the Account(Very rare scenario).
                                                        Lead leadToInsert = createLeadRecord(mapOfFieldNameAndMappingsRecord,mapOfLeadFieldsAndValues,'INSERT',parentAccountRecord.Id);
                                                        System.debug('leadToInsert'+leadToInsert);
                                                        //Insert the lead
                                                        if(leadToInsert != null )
                                                        {
                                                            if(String.isNotBlank(verified)&& verified =='True' )
                                                            {
                                                                respWrap.Status = 'SUCCESS';
                                                                respWrap.Message = 'New Lead can be Created as there was no lead and no opportunities under the Account';
                                                                RestContext.response.addHeader('Content-Type', 'application/json');
                                                                RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
                                                                isResponseSent = true;
                                                            }
                                                            else
                                                            {
                                                                
                                                                if(leadToInsert.Brand__c == GenericConstants.LEAD_DOOWUP)
                                                                {                                                            
                                                                    leadToInsert.Order_not_Registered__c = False;
                                                                }
                                                                else
                                                                {                                                            
                                                                    leadToInsert.Order_not_Registered__c= true;
                                                                }
                                                                if(brandOfLead == GenericConstants.Brand_Cubico)
                                                                {
                                                                    id foundShowroomId = null;
                                                                    system.debug('leadToInsert.City '+ leadToInsert.City);
                                                                    LeadTriggerCubicoAndDoowupHandler.showroomCityMap = LeadTriggerCubicoAndDoowupHandler.getcubicoShowroomMetadata();
                                                                    foundShowroomId = LeadTriggerCubicoAndDoowupHandler.getCubicoShowroom(leadToInsert.City, LeadTriggerCubicoAndDoowupHandler.showroomCityMap);
                                                                    
                                                                    if(foundShowroomId != null)
                                                                    {
                                                                        
                                                                        leadToInsert.Appointment_Venue_Square__c = foundShowroomId;
                                                                        leadToInsert.Sign_Up_Source__c= GenericConstants.Brand_Cubico;
                                                                        leadToInsert.Brand__c=GenericConstants.LEAD_HOMELANE;
                                                                    }  
                                                                }
                                                                
                                                                if(brandOfLead == GenericConstants.Brand_Wrapzap)
                                                                {
                                                                        System.debug('LeadSource '+String.valueOf(mapOfLeadFieldsAndValues.get('LeadSource')));
                                                                        leadToInsert.Appointment_Venue_Square__c = Label.Wrapzap_Showroom_ID;
                                                                        leadToInsert.Sign_Up_Source__c= GenericConstants.Brand_Wrapzap;
                                                                        leadToInsert.Brand__c=GenericConstants.Brand_Wrapzap;  
                                                                        leadToInsert.LeadSource = String.valueOf(mapOfLeadFieldsAndValues.get('LeadSource'));
                                                                }
                                                                
                                                                leadToInsert.Account__c = parentAccountRecord.Id;
                                                                leadToInsert.Email = parentAccountRecord.PersonEmail;
                                                                
                                                                insert leadToInsert;
                                                                respWrap.Status = 'SUCCESS';
                                                                respWrap.Message = 'New Lead Created as there was no lead and no opportunities under the Account: '+ parentAccountRecord.Id+' . SF Lead ID: '+leadToInsert.Id;
                                                                RestContext.response.addHeader('Content-Type', 'application/json');
                                                                RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
                                                                isResponseSent = true;
                                                               // idSet.add(leadToInsert.Id);
                                                                //BulkOfflineLeadCreation_Controller.assignPC(leadToInsert.Id);
                                                            }
                                                            //By default it will be false and will be set to true for all the Blitz offline leads while creation via BulkOfflineLeadCreationAPI.
                                                            
                                                        }
                                                        else
                                                        {
                                                            System.debug('createLeadRecord method has returned null value');
                                                            logErrorMessage = 'createLeadRecord method has returned null value';
                                                        }
                                                    }
                                        }
                                        
                                        //--------------------------------If 1 lead found under the existing Account----------------------------------------//                                        
                                       
                                        else if(listOfQueriedLeads.size() == 1 )
                                        {
                                                    System.debug('listOfQueriedLeads is not empty under the account'+listOfQueriedLeads[0].status+listOfQueriedLeads[0].email);
                                                    // There is one non converted lead under the account
                                                    // Check if the duplicate lead is inactive(Dead/NAP)                                           
                                                    
                                                   // According to new changes, leads cannot be reactivated/transferred to other CP.
                                                   if(String.isNotBlank(verified)&& verified =='True')
                                                   {
                                                            respWrap.Status = 'FAILURE 2';
                                                            respWrap.Message = 'Lead cannot be created';
                                                            RestContext.response.addHeader('Content-Type', 'application/json');
                                                            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
                                                            isResponseSent = true;                                                              
                                                   }
                                                   else
                                                   {                                                       
                                                       		reactivateLeadId = listOfQueriedLeads[0].id;    
                                                       		Lead_Status = listOfQueriedLeads[0].Status;
                                                            Lead_Bulk_Upload_Flag = listOfQueriedLeads[0].Bulk_Upload__c;
                                                       		Lead_Source = listOfQueriedLeads[0].LeadSource;
                                                       		Lead_Brand = listOfQueriedLeads[0].Brand__c;
                                                       		CP_Assignment_Date = listOfQueriedLeads[0].CP_Assignment_Date__c;
                                                   }                                                                                                     
                                        }
                                        
                                        //--------------------------------If more than 1 lead found under the existing Account----------------------------------------//
                                                                              
                                        else
                                        {
                                            
                                            		// According to new changes, leads cannot be reactivated/transferred to other CP.
                                                   if(String.isNotBlank(verified)&& verified =='True')
                                                   {
                                                            respWrap.Status = 'FAILURE 3';
                                                            respWrap.Message = 'Lead cannot be created';
                                                            RestContext.response.addHeader('Content-Type', 'application/json');
                                                            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
                                                            isResponseSent = true;                                                              
                                                   }
                                            	   else
                                                   {
                                                            // There are more than one non converted lead under the account 
                                                            //4.If there are more than 1 lead in the system and all the leads are active, then if a new lead is tried to be created via Bulk Upload the lead creation will fail.
                                                            //Set the boolean to false by default and set it true if there is an inactiveLead so that it would indicate that all the leads are not active and atleast one lead is inactive
                                                            Boolean isThereAtleastOneInactiveLead = False;                                              
                                                                                                            
                                                            //5.If there is more than 1 lead in the system and one of the leads is inactive, then if a new lead is tried to be created via Bulk Upload, this inactive lead will be marked as Re-landed and updated like the way it is implemented currently.
                                                            //6.If there is more than 1 lead in the system and more than 1 lead is inactive, then if a new lead is tried to be created via Bulk Upload, the latest created lead which is inactive will be marked as Re-landed and updated like the way it is implemented currently.
                                                            //To get the latest created lead the lead has been queried in the CreatedDate ascending order where the last created lead will be in the last while looping in the queried leads.
                                                            for(Lead duplicateLead : listOfQueriedLeads)
                                                            {
                                                                if(setOfInactiveStatus.contains(duplicateLead.Status))
                                                                {
                                                                        isThereAtleastOneInactiveLead = True;
                                                                        //This will contain the id of the latest created inactive lead and will get replaced in the loop everytime there is a inactive lead.
                                                                        reactivateLeadId = duplicateLead.Id;
                                                                        Lead_Status = duplicateLead.Status;
                                                                        Lead_Bulk_Upload_Flag = duplicateLead.Bulk_Upload__c;
                                                                        Lead_Source = duplicateLead.LeadSource;
                                                                    	Lead_Brand = duplicateLead.Brand__c;
                                                                    	CP_Assignment_Date = duplicateLead.CP_Assignment_Date__c;
                                                                }
                                                                else
                                                                {
                                                                     isThereAtleastOneInactiveLead =false;
                                                                     Reland_the_lead = false;
                                                                     reactivateLeadId = null;
                                                                     break;
                                                                }
                                                            }
                                                            if(!isThereAtleastOneInactiveLead && reactivateLeadId == Null)
                                                            {
                                                                system.debug('One of the lead is active');
                                                                // There is no inactive lead and all are active so error message response
                                                                isResponseSent = true;
                                                                respWrap.Status = 'FAILURE 4';
                                                                respWrap.Message = 'Lead cannot be created';
                                                                RestContext.response.addHeader('Content-Type', 'application/json');
                                                                RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));                                                  
                                                            }
                                               	   }                                                                                        
                                        }
                                        
                                        
                                        
                                        //------------------------- Here we are doing further checks after fetching the Lead Id------------------------//
                                                if(reactivateLeadId !=null)
                                                {
                                            				// Check last CP assignment Date
                                                            CP_assigned_recently = utilityClass.isCP_AssignedRecently( reactivateLeadId, HL_Referrer_Phone);
                                                            OriginalLeadSource = Lead_Source;
                                                            system.debug('CP_assigned_recently '+CP_assigned_recently);
                                                    		system.debug('listOfQueriedLeads[0] '+listOfQueriedLeads[0]);
                                                                       
                                                       		
                                                            // Offline Leads
                                                            if(Lead_Bulk_Upload_Flag == true && Lead_Source == GenericConstants.OFFLINE_LEAD_SOURCE)
                                                            {
                                                                	system.debug('Offline Leads ');
                                                                	// If Lead is created in Last 6 months and Status is Dead Lead, then assign to HomeLane Offline CP
                                                                	// If Lead is created before 6 months and Status is Active/Dead/NAP, then assign to HomeLane Offline CP
                                                                
                                                                	if((CP_assigned_recently && Lead_Status == GenericConstants.LEAD_DEAD_STATUS) || (!CP_assigned_recently))
                                                                    {
	                                                                        Reland_the_Lead = true;                                                                                                                                                                                                                                          
                                                                    }                                                                 	
                                                            } 
                                                                   
                                                            // Digital Leads : Check if Lead is Dead Lead
                                                            else if(Lead_Bulk_Upload_Flag == false && Lead_Status == GenericConstants.LEAD_DEAD_STATUS)                                       
                                                            {
                                                                	  system.debug('Digital Leads ');
                                                                	  // Check if lead is created before 2 months and Dead before 30 days
                                                                	  deadInLastMonth = utilityClass.getLeadHistory(reactivateLeadId);
                                                                	  leadCreatedRecently = utilityClass.isLeadCreatedINLast2Months(reactivateLeadId);
                                                                	  if(!deadInLastMonth && !leadCreatedRecently)
                                                                      {
                                                                          Reland_the_Lead = true;
                                                                      }                                                                      
                                                            }
                                                    		else
                                                            {
                                                                    respWrap.Status = 'FAILURE 5';
                                                                    respWrap.Message = 'Lead cannot be created';
                                                                    RestContext.response.addHeader('Content-Type', 'application/json');
                                                                    RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
                                                                    isResponseSent = true;                                                              
                                                            }
                                        		                                        
                                                            System.debug('parentAccountRecord.Id : '+parentAccountRecord.Id);
                                                            if(Reland_the_Lead)
                                                            {
                                                                        leadToReactivate = createLeadRecord(mapOfFieldNameAndMappingsRecord,mapOfLeadFieldsAndValues,'UPDATE',parentAccountRecord.Id);
            
                                                                        system.debug('leadToReactivate '+leadToReactivate);
                                                                        if(leadToReactivate != null)
                                                                        {                                                                	
                                                                                leadToReactivate.id =reactivateLeadId;
                                                                            
                                                                                if(Lead_Brand !='Doowup')
                                                                                {
                                                                                        leadToReactivate.Assigned_to_Resi_ASM__c =false;
                                                                                        leadToReactivate.Assigned_To_TLC__c= false;
                                                                                        leadToReactivate.Assigned_To_Inside_Sales_Agent__c=false;
                                                                                    	leadToReactivate.Assigned_to_Central_Team__c= false;
                                                                                    	leadToReactivate.Pushed_To_Ozonetel__c=false;
                                                                                   /*   leadToReactivate.Sales_Manager__c = null;
                                                                                        leadToReactivate.Sales_Manager_Email__c=null;
                                                                                        leadToReactivate.Tele_caller__c=null;
                                                                                        leadToReactivate.Telecaller_Email__c= null;
                                                                                        leadToReactivate.Inside_Sales_Agent__c = null;
                                                                                        leadToReactivate.Inside_Sales_Agent_Email__c =null;
                                                                                        leadToReactivate.Central_Team_Agent__c = null;                                                                                        
                                                                                        leadToReactivate.Central_Team_Agent_Email__c=null;*/
                                                                                        
                                                                                  
                                                                                        //This is to fire the assignment rule explicitly which will assign the reactivated leads to the City wise bulk offline leads.
                                                                                        Database.DMLOptions dmo = new Database.DMLOptions();
                                                                                        dmo.assignmentRuleHeader.useDefaultRule= true;
                                                                                        leadToReactivate.setOptions(dmo);                                                                
                                                                                }
                                                                                else
                                                                                {
                                                                                        system.debug('doowup assignment');                                                                                       
                                                                                    	
                                                                                        leadToReactivate.Assigned_To_Inside_Sales_Agent__c=false;	//Added on 22nd July 2024 
                                                                                    	leadToReactivate.Assigned_to_Resi_ASM__c =false;
                                                                                    	leadToReactivate.Assigned_to_Doowup_Presales__c=false;
                                                                                        leadToReactivate.Assigned_To_TLC__c= false;
                                                                                        leadToReactivate.Pushed_To_Ozonetel__c=false;
                                                                                        leadToReactivate.Transfer_Status__c= Null;
                                                                                    
                                                                                   /* 	leadToReactivate.Sales_Manager__c = null;
                                                                                        leadToReactivate.Sales_Manager_Email__c=null;                                                                                        
                                                                                        leadToReactivate.Doowup_Presales__c= null;
                                                                                        leadToReactivate.Doowup_Presales_Email__c= null;                                                                                        
                                                                                        leadToReactivate.Tele_caller__c=null;
                                                                                        leadToReactivate.Telecaller_Email__c= null;*/
                                                                                        //isRunPCAssignment=true;
                                                                                        //idSet.add(reactivatedLeadId);                                                            
                                                                                }                                                     
                      
                                                                                // Update the duplicate inactive lead for reactivation
                                                                                update leadToReactivate;
                                                                                system.debug('leadToReactivate '+leadToReactivate);
                                                                                respWrap.Status = 'Failure';
                                                                                respWrap.Message = 'Lead cannot be created.';
                                                                                RestContext.response.addHeader('Content-Type', 'application/json');
                                                                                RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
                                                                                isResponseSent = true;
                                                                        }
                                                                
                                                                        else
                                                                        {
                                                                                system.debug('createLeadRecord method returned null');
                                                                                isResponseSent = true;
                                                                                respWrap.Status = 'FAILURE 6';
                                                                                respWrap.Message = 'Some internal error occurred';
                                                                                RestContext.response.addHeader('Content-Type', 'application/json');
                                                                                RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));  
                                                                        }
                                                            }
                                                            else
                                                            {
                                                                	if(!isResponseSent)
                                                                    {
                                                                        respWrap.Status = 'FAILURE 7';
                                                                        respWrap.Message = 'Lead cannot be created';
                                                                        RestContext.response.addHeader('Content-Type', 'application/json');
                                                                        RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
                                                                        isResponseSent = true;
                                                                    }
                                                            }
                                          		}
                                    }
                                    else
                                    {
                                        System.debug('parentAccountRecord is null. parentAccountRecord: '+parentAccountRecord);
                                    }
                                }
                        }
                        else
                        {
                            System.debug('Either phone or email is blank for this lead. PHONE: '+String.valueOf(mapOfLeadFieldsAndValues.get('Email'))+' . EMAIL: '+String.valueOf(mapOfLeadFieldsAndValues.get('Phone')));
                            logErrorMessage = 'Either phone or email is blank for this lead. PHONE: '+String.valueOf(mapOfLeadFieldsAndValues.get('Email'))+' . EMAIL: '+String.valueOf(mapOfLeadFieldsAndValues.get('Phone'));
                        }
                    }
                    else
                    {
                        System.debug('Either phone or email parameter key not found in the request.');
                        logErrorMessage = 'Either phone or email parameter key not found in the request.';
                    }
                }
                else
                {
                    System.debug('mapOfLeadFieldsAndValues (deserialized map) is Empty. mapOfLeadFieldsAndValues:'+mapOfLeadFieldsAndValues);
                    logErrorMessage = 'mapOfLeadFieldsAndValues (deserialized map) is Empty.';
                }
            }
            else
            {
                System.debug('input String is blank');
                logErrorMessage = 'input String is blank';
            }
          /* if(!idSet.isEmpty()){
                BulkOfflineLeadCreation_Controller.assignPC(idSet);
            }*/
        }
        catch(Exception e)
        {
            
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            respWrap.Status = 'EXCEPTION';
            respWrap.Message = 'Exception in Salesforce. Excption Message: '+e.getMessage() +' .Stack Trace:'+e.getStackTraceString();
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
            isResponseSent = true;
            Logger.log('Exception','BulkOfflineLeadCreation_Controller Class','bulkOfflineLeadCreation Method',e.getMessage(),e.getStackTraceString(),null);
        }
        system.Debug('isResponseSent '+isResponseSent);
        if(!isResponseSent)
        {
            respWrap.Status = 'FAILURE 8';
            respWrap.Message = 'Some error in Salesforce. Record not processed. Please contact Salesforce admin';
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
            Logger.log('Error','BulkOfflineLeadCreation_Controller Class','bulkOfflineLeadCreation Method',logErrorMessage,'isResponseSent value false','');
        }
    }
    /**
* @description || This method creates an instance of Lead record filling the values and return the same.
* @author Bharatesh Shetty | 2/25/2020 
* @param Map<String,Object> mapOfLeadFieldsAndValues, String action 
* @return Lead 
**/
    Public static Lead createLeadRecord(Map<String,Bulk_Offline_Lead_Creation_Fields__c> mapOfFieldNameAndMappingsRecord,Map<String,Object> mapOfLeadFieldsAndValues, String action,Id parentAccountId)
    {
        try
        {
            String HomeLane_Offline = System.Label.HomeLane_Offline_Channel_Partner_Phone;
            if(!mapOfFieldNameAndMappingsRecord.isEmpty())
            {   
                Lead returnLeadRec = new Lead();
                for(String fieldName : mapOfLeadFieldsAndValues.keySet())
                {
                    if(mapOfFieldNameAndMappingsRecord.containsKey(fieldName))
                    {
                        if(action.equalsIgnoreCase('INSERT'))
                        {
                            if(mapOfFieldNameAndMappingsRecord.get(fieldName).In_Use__c)
                            {
                                // If the field data type is Checkbox
                                if(mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Checkbox'))
                                {
                                    returnLeadRec.put(fieldName,Boolean.ValueOf(mapOfLeadFieldsAndValues.get(fieldName)));
                                }
                                // If the field data type is string
                                else if(mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Picklist') ||
                                        mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Text')||
                                        mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Email')||
                                        mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Phone'))
                                {
                                            // If field value is not null then get the string value
                                            if(mapOfLeadFieldsAndValues.get(fieldName) != null)
                                            {                                                
                                                returnLeadRec.put(fieldName,String.ValueOf(mapOfLeadFieldsAndValues.get(fieldName)));
                                            }
                                            else
                                            {
                                                // Ignore if the String value if it's blank or null
                                                System.debug('field String value is null');
                                            }
                                }
                                else
                                {
                                    System.debug('Data type is neither checkbox nor String');
                                }
                            }
                        }
                        else if(action.equalsIgnoreCase('UPDATE'))
                        {
                            // These values are updated in case of reactivation of the duplicate inactive lead
                            returnLeadRec.Status = GenericConstants.LEAD_FRESH_STATUS;
                            returnLeadRec.Sub_Status__c = GenericConstants.LEAD_RELANDED_SUBSTATUS;
                            returnLeadRec.WT_Agent__c = Label.HomeLaneAPIUserId;
                            returnLeadRec.Relanded_Date__c = System.now();
                            returnLeadRec.Relanded_Source__c = String.valueOf(mapOfLeadFieldsAndValues.get(GenericConstants.LEAD_RELANDED_SOURCE));
                            returnLeadRec.Interior_Designer__c = NULL;
                            returnLeadRec.Appointment_Venue_Square__c = NULL;
                            returnLeadRec.Showroom_Manager__c = NULL;
                            returnLeadRec.Showroom_Manager_Email__c = NULL;
                            returnLeadRec.Square_Showroom__c = NULL;
                                                        
                            if(mapOfFieldNameAndMappingsRecord.get(fieldName).In_Use__c && mapOfFieldNameAndMappingsRecord.get(fieldName).OverRide_InCase_Of_Duplication__c)
                            {
                                // If the field data type is Checkbox
                                if(mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Checkbox'))
                                {
                                    returnLeadRec.put(fieldName,Boolean.ValueOf(mapOfLeadFieldsAndValues.get(fieldName)));
                                }
                                // If the field data type is string
                                else if(mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Picklist') ||
                                        mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Text')||
                                        mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Email')||
                                        mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Phone'))
                                {
                                            // If field value is not null then get the string value
                                            if(mapOfLeadFieldsAndValues.get(fieldName) != null)
                                            {                                                
                                                if( Reland_the_Lead )
                                                {
                                                        // Update HL_Referrer_Phone__c to HomeLane Offline if CP is assigned in last 6 months or CP is getting changed
                                                        if(fieldName == 'HL_Referrer_Phone__c')
                                                        {
                                                            System.debug('Change HL_Referrer_Phone__c to HomeLane_Offline');
                                                            returnLeadRec.put('HL_Referrer_Phone__c', HomeLane_Offline);
                                                        }  
                                                    	else
                                                        {
                                                            returnLeadRec.put(fieldName,String.ValueOf(mapOfLeadFieldsAndValues.get(fieldName)));
                                                        }
                                                }                                                
                                            }
                                            else
                                            {
                                                // Ignore if the String value if it's blank or null
                                                System.debug('field String value is null');
                                            }
                                }
                                else
                                {
                                    System.debug('Data type is neither checkbox nor String');
                                }
                            }
                        }
                        else
                        {
                            System.debug('Action is neither INSERT nor UPDATE. Action: '+action); 
                        }
                    }
                }
                if(Test.isRunningTest())
                {
                    
                }
                return returnLeadRec;
            }
            else
            {
                Logger.log('Error','BulkOfflineLeadCreation_Controller Class','createLeadRecord Method','mapOfFieldNameAndMappingsRecord(Bulk_Offline_Lead_Creation_Fields__c custom settings map) is empty','','');
                return null;
            }
            
        }
        catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','BulkOfflineLeadCreation_Controller Class','createLeadRecord Method',e.getMessage(),e.getStackTraceString(),null);
            return NULL;
        }
    }
    
    
    Public static Account createAccountRecord(Map<String,Bulk_Offline_Lead_Creation_Fields__c> mapOfFieldNameAndMappingsRecord,Map<String,Object> mapOfLeadFieldsAndValues)
    {
        try
        {
            System.debug('mapOfFieldNameAndMappingsRecord'+mapOfFieldNameAndMappingsRecord);
            System.debug('mapOfLeadFieldsAndValues'+mapOfLeadFieldsAndValues);
            if(!mapOfFieldNameAndMappingsRecord.isEmpty())
            {   
                Account returnAccountRec = new Account();
                for(String fieldName : mapOfLeadFieldsAndValues.keySet())
                {
                    System.debug('FL Name'+fieldName);
                    if(mapOfFieldNameAndMappingsRecord.containsKey(fieldName))
                    {
                        System.debug('Contains'+mapOfFieldNameAndMappingsRecord.containsKey(fieldName));
                        if(mapOfFieldNameAndMappingsRecord.get(fieldName).In_Use__c && mapOfFieldNameAndMappingsRecord.get(fieldName).UseInAccount__c )
                        {
                            System.debug('In use');
                            // If the field data type is Checkbox
                            System.debug('Type'+mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c);
                            if(mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Checkbox'))
                            {
                                returnAccountRec.put(fieldName,Boolean.ValueOf(mapOfLeadFieldsAndValues.get(fieldName)));
                            }
                            // If the field data type is string
                            else if(mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Picklist') ||
                                    mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Text')||
                                    mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Email')||
                                    mapOfFieldNameAndMappingsRecord.get(fieldName).Field_Data_Type__c.equalsIgnoreCase('Phone'))
                            {
                                        // If field value is not null then get the string value
                                        if(mapOfLeadFieldsAndValues.get(fieldName) != null)
                                        {
                                            System.debug('fieldName'+fieldName);
                                            System.debug('mapOfLeadFieldsAndValues.get(fieldName)'+mapOfLeadFieldsAndValues.get(fieldName));
                                            if(fieldName.equalsIgnoreCase('Email'))
                                            {
                                                returnAccountRec.put('PersonEmail',String.ValueOf(mapOfLeadFieldsAndValues.get(fieldName)));
                                            }
                                            else
                                            {
                                                returnAccountRec.put(fieldName,String.ValueOf(mapOfLeadFieldsAndValues.get(fieldName)));
                                            }
                                        }
                                        else
                                        {
                                            // Ignore if the String value if it's blank or null
                                            System.debug('field String value is null');
                                        }
                            }
                            else
                            {
                                System.debug('Data type is neither checkbox nor String');
                            }
                        }
                    }
                }
                return returnAccountRec;
            }
            else
            {
                Logger.log('Error','BulkOfflineLeadCreation_Controller Class','createAccountRecord Method','mapOfFieldNameAndMappingsRecord(Bulk_Offline_Lead_Creation_Fields__c custom settings map) is empty','','');
                return null;
            }
            
        }
        catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','BulkOfflineLeadCreation_Controller Class','createAccountRecord Method',e.getMessage(),e.getStackTraceString(),null);
            return NULL;
        }
    }
 
    
    Public class ResponseWrapper
    {
        Public String Message;
        Public String Status;
    }
    
    
    
    
    
}