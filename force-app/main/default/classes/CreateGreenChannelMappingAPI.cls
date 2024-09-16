@RestResource(urlMapping='/CreateGreenChannelMappingAPI/*')
Global class CreateGreenChannelMappingAPI 
{
    @HttpPost
    global static void CreateGreenChannelMapping() 
    {
        RestResponse res = new RestResponse();
        RestRequest req = RestContext.request;
        ResponseWrapper respWrap = new ResponseWrapper();        
        String inputData = req.requestBody.toString();
        Map< String, String> MapOfCitytoClassification1 = new Map< String, String>();
        
  //     List<ResponseWrapperResult> listOfResponseWrapperResult = new List<ResponseWrapperResult>();
        
        // For Gold Records
        Map<String, List<String>> MapOfPaidSearch_OTPVerified_LeadSources_GOLD = new Map<String, List<String>>();
        Map<String, List<String>> MapOfPaidSearch_OTPNotVerified_LeadSources_GOLD = new Map<String, List<String>>();
        Map<String, List<String>> MapOfFaceBookAd_OTPVerified_LeadSources_GOLD = new Map<String, List<String>>();
        Map<String, List<String>> MapOfFaceBookAd_OTPNotVerified_LeadSources_GOLD = new Map<String, List<String>>();
        Map<String, List<String>> MapOfdiscovery_OTPVerified_LeadSources_GOLD = new Map<String, List<String>>();
        Map<String, List<String>> MapOfdiscovery_OTPNotVerified_LeadSources_GOLD = new Map<String, List<String>>();
                
        // For Silver Records
        Map<String, List<String>> MapOfPaidSearch_OTPVerified_LeadSources_SILVER = new Map<String, List<String>>();
        Map<String, List<String>> MapOfPaidSearch_OTPNotVerified_LeadSources_SILVER = new Map<String, List<String>>();
        Map<String, List<String>> MapOfFaceBookAd_OTPVerified_LeadSources_SILVER = new Map<String, List<String>>();
        Map<String, List<String>> MapOfFaceBookAd_OTPNotVerified_LeadSources_SILVER = new Map<String, List<String>>();
        Map<String, List<String>> MapOfdiscovery_OTPVerified_LeadSources_SILVER = new Map<String, List<String>>();
        Map<String, List<String>> MapOfdiscovery_OTPNotVerified_LeadSources_SILVER = new Map<String, List<String>>();
        
        Set<String> setofCity = new Set<String>();
        Set<String> setofCityClassification = new Set<String>();
        
        try
        {
            if(String.isNotBlank(inputData))
            {
                System.debug('inputdata'+ inputData);
                List<RequestWrapper> reqWrap = (List<RequestWrapper>)Json.deserialize(inputData, List<RequestWrapper>.Class);                
                
                if(!reqWrap.isEmpty())
                {      
                        for(RequestWrapper requestItem : reqWrap)
                        {
                            system.debug('requestItem '+ requestItem);
                            if(!String.isBlank(requestItem.city_name) && !String.isBlank(requestItem.classification))
                            {
                                    setofCity.add(requestItem.city_name);
                                	MapOfCitytoClassification1.put((requestItem.city_name+';'+requestItem.classification),(requestItem.classification));                                	
                            }
                            else
                            {
                                    System.debug('Either city_name or classification is Empty') ;  
                                    respWrap.Status = 'FAILURE';
                                    respWrap.Message = 'Either city_name or classification is Empty!';
                                    RestContext.response.addHeader('Content-Type', 'application/json');
                                    RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));                
                             }
                            
                        }
                        
                        system.debug('setofCity :'+ setofCity);
                        System.debug('MapOfCitytoClassification1: '+MapOfCitytoClassification1);
                        
                        for(RequestWrapper requestItem : reqWrap)
                        {		
                                    system.debug('requestItem '+ requestItem);
                                    if(!String.isBlank(requestItem.city_name) && !String.isBlank(requestItem.classification))
                                    {
                                            if(requestItem.Classification == 'Gold')                            
                                            {
                                                    // Mapping of city to Campaign List
                                                    MapOfPaidSearch_OTPVerified_LeadSources_GOLD.put(requestItem.city_name, requestItem.paid_search_otp);
                                                    MapOfPaidSearch_OTPNotVerified_LeadSources_GOLD.put(requestItem.city_name,  requestItem.paid_search);
                                                    MapOfFaceBookAd_OTPVerified_LeadSources_GOLD.put(requestItem.city_name,  requestItem.facebook_ad_otp);
                                                    MapOfFaceBookAd_OTPNotVerified_LeadSources_GOLD.put(requestItem.city_name,  requestItem.facebook_ad);
                                                    MapOfdiscovery_OTPVerified_LeadSources_GOLD.put(requestItem.city_name,  requestItem.discovery_otp);
                                                    MapOfdiscovery_OTPNotVerified_LeadSources_GOLD.put(requestItem.city_name,  requestItem.discovery);                                                                            
                                            }
                                        
                                            else if(requestItem.Classification == 'Silver')                            
                                            {
                                                    // Mapping of city to Campaign List
                                                    MapOfPaidSearch_OTPVerified_LeadSources_SILVER.put(requestItem.city_name,  requestItem.paid_search_otp);
                                                    MapOfPaidSearch_OTPNotVerified_LeadSources_SILVER.put(requestItem.city_name,  requestItem.paid_search);
                                                    MapOfFaceBookAd_OTPVerified_LeadSources_SILVER.put(requestItem.city_name,   requestItem.facebook_ad_otp);
                                                    MapOfFaceBookAd_OTPNotVerified_LeadSources_SILVER.put(requestItem.city_name,  requestItem.facebook_ad);
                                                    MapOfdiscovery_OTPVerified_LeadSources_SILVER.put(requestItem.city_name,  requestItem.discovery_otp);
                                                    MapOfdiscovery_OTPNotVerified_LeadSources_SILVER.put(requestItem.city_name,  requestItem.discovery);  
                                            }                                    
                                    }     
                            		else
                                    {
                                            System.debug('Either city_name or classification is Empty') ;  
                                            respWrap.Status = 'FAILURE';
                                            respWrap.Message = 'Either city_name or classification is Empty!';
                                            RestContext.response.addHeader('Content-Type', 'application/json');
                                            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));                
                                     }
                            }                               
                    
                }
                else
                {
         				System.debug('reqWrap is Empty') ;  
                    	respWrap.Status = 'FAILURE';
                        respWrap.Message = 'reqWrap is Empty.';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));                
                 }
            }
            
            else
            {
                System.debug('InputData is blank or empty.');
                respWrap.Status = 'FAILURE';
                respWrap.Message = 'InputData string in the request is blank or empty.';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));                
            }
            
            system.debug('setofCity :'+ setofCity);
            System.debug('MapOfPaidSearch_OTPVerified_LeadSources_GOLD: ' + MapOfPaidSearch_OTPVerified_LeadSources_GOLD);
            System.debug('MapOfPaidSearch_OTPNotVerified_LeadSources_GOLD: ' + MapOfPaidSearch_OTPNotVerified_LeadSources_GOLD);
            System.debug('MapOfFaceBookAd_OTPVerified_LeadSources_GOLD: ' + MapOfFaceBookAd_OTPVerified_LeadSources_GOLD);
            System.debug('MapOfFaceBookAd_OTPNotVerified_LeadSources_GOLD: ' + MapOfFaceBookAd_OTPNotVerified_LeadSources_GOLD);
            System.debug('MapOfdiscovery_OTPVerified_LeadSources_GOLD: ' + MapOfdiscovery_OTPVerified_LeadSources_GOLD);
            System.debug('MapOfdiscovery_OTPNotVerified_LeadSources_GOLD: ' + MapOfdiscovery_OTPNotVerified_LeadSources_GOLD);
            
            System.debug('MapOfPaidSearch_OTPVerified_LeadSources_SILVER: ' + MapOfPaidSearch_OTPVerified_LeadSources_SILVER);
            System.debug('MapOfPaidSearch_OTPNotVerified_LeadSources_SILVER: ' + MapOfPaidSearch_OTPNotVerified_LeadSources_SILVER);
            System.debug('MapOfFaceBookAd_OTPVerified_LeadSources_SILVER: ' + MapOfFaceBookAd_OTPVerified_LeadSources_SILVER);
            System.debug('MapOfFaceBookAd_OTPNotVerified_LeadSources_SILVER: ' + MapOfFaceBookAd_OTPNotVerified_LeadSources_SILVER);
            System.debug('MapOfdiscovery_OTPVerified_LeadSources_SILVER: ' + MapOfdiscovery_OTPVerified_LeadSources_SILVER);
            System.debug('MapOfdiscovery_OTPNotVerified_LeadSources_SILVER: ' + MapOfdiscovery_OTPNotVerified_LeadSources_SILVER);

            
           	// We need to delete the previous values in records in order to add new values
           	Id GoldCLID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Gold_RECID).getRecordTypeId();
        	Id SilverCLID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Silver_RECID).getRecordTypeId();
            List<Lead_Class_Scoring__c>  leadClassificationList = new List<Lead_Class_Scoring__c>();
            Map< String, String> MapOfCitytoClassification2 = new Map< String, String>();
            
            leadClassificationList = [ Select id,Paid_Search_OTP_Campaign_List__c, Paid_Search_Campaign_List__c, Facebook_Ad_OTP_Campaign_List__c,Facebook_Ad_Campaign_List__c, 
                                       discovery_OTP_Campaign_List__c, discovery_Campaign_List__c,RecordTypeId,City__c,RecordType.DeveloperName from Lead_Class_Scoring__c 
                                       where (recordTypeId=:GoldCLID OR recordTypeId=:SilverCLID) AND City__c IN :setofCity];
            
            // If all the Maps have values in it then only we will empty the lists
            if(!leadClassificationList.isEmpty())
            {       	
                
                	for(Lead_Class_Scoring__c record:leadClassificationList)
                    {
                        	if((MapOfCitytoClassification1.containsKey(record.City__c+';'+'Gold') && MapOfCitytoClassification1.get(record.City__c+';'+'Gold')== 'Gold' && record.RecordTypeId == GoldCLID))
                        	{
                                	System.debug('Criteria Pass GOLD');
                                	if(!(MapOfPaidSearch_OTPVerified_LeadSources_GOLD.get(record.City__c)).isEmpty())
                                    {
                                    	record.Paid_Search_OTP_Campaign_List__c = null;
                                    }
                                	if(!(MapOfPaidSearch_OTPNotVerified_LeadSources_GOLD.get(record.City__c)).isEmpty())
                                    {
                                    	record.Paid_Search_Campaign_List__c = null;
                                    }                               
                                    if(!(MapOfFaceBookAd_OTPVerified_LeadSources_GOLD.get(record.City__c)).isEmpty())
                                    {
                                        record.Facebook_Ad_OTP_Campaign_List__c = null;
                                    }
                                	if(!(MapOfFaceBookAd_OTPNotVerified_LeadSources_GOLD.get(record.City__c)).isEmpty())
                                    {
                                        record.Facebook_Ad_Campaign_List__c = null;
                                    }
                                    if(!(MapOfdiscovery_OTPVerified_LeadSources_GOLD.get(record.City__c)).isEmpty())
                                    {
                                    	record.discovery_OTP_Campaign_List__c = null;
                                    }
                                	if(!(MapOfdiscovery_OTPNotVerified_LeadSources_GOLD.get(record.City__c)).isEmpty())
                                    {
                                    	record.discovery_Campaign_List__c = null;
                                    }                                    
                    		}
                        
                        	if((MapOfCitytoClassification1.containsKey(record.City__c+';'+'Silver') && MapOfCitytoClassification1.get(record.City__c+';'+'Silver')=='Silver' && record.RecordTypeId == SilverCLID))
                        	{
                                	System.debug('Criteria Pass SILVER');
                                	if(!(MapOfPaidSearch_OTPVerified_LeadSources_SILVER.get(record.City__c)).isEmpty())
                                    {
                                    	record.Paid_Search_OTP_Campaign_List__c = null;
                                    }
                                	if(!(MapOfPaidSearch_OTPNotVerified_LeadSources_SILVER.get(record.City__c)).isEmpty())
                                    {
                                    	record.Paid_Search_Campaign_List__c = null;
                                    }                               
                                    if(!(MapOfFaceBookAd_OTPVerified_LeadSources_SILVER.get(record.City__c)).isEmpty())
                                    {
                                        record.Facebook_Ad_OTP_Campaign_List__c = null;
                                    }
                                	if(!(MapOfFaceBookAd_OTPNotVerified_LeadSources_SILVER.get(record.City__c)).isEmpty())
                                    {
                                        record.Facebook_Ad_Campaign_List__c = null;
                                    }
                                    if(!(MapOfdiscovery_OTPVerified_LeadSources_SILVER.get(record.City__c)).isEmpty())
                                    {
                                    	record.discovery_OTP_Campaign_List__c = null;
                                    }
                                	if(!(MapOfdiscovery_OTPNotVerified_LeadSources_SILVER.get(record.City__c)).isEmpty())
                                    {
                                    	record.discovery_Campaign_List__c = null;
                                    }                                    
                    		}
                    }
                   
            }
            
            if(!leadClassificationList.isEmpty())
            {
                update leadClassificationList;
            }
            
           
			            
            // We will create the records now
            if(!leadClassificationList.isEmpty())
            {                	             
                	       	for(Lead_Class_Scoring__c record:leadClassificationList)
                            {
                                		System.debug('record: '+record);
                                	    if(MapOfCitytoClassification1.containsKey(record.City__c+';'+'Gold') && MapOfCitytoClassification1.get(record.City__c+';'+'Gold')== 'Gold' && 
                                            record.RecordTypeId == GoldCLID)
                                        {
                                                if(!(MapOfPaidSearch_OTPVerified_LeadSources_GOLD.get(record.City__c)).isEmpty())
                                    			{
                                                    record.Paid_Search_OTP_Campaign_List__c = addMapValuesWithSemicolon(MapOfPaidSearch_OTPVerified_LeadSources_GOLD,record.City__c);
                                                }
                                            	if(!(MapOfPaidSearch_OTPNotVerified_LeadSources_GOLD.get(record.City__c)).isEmpty())
                                                {
                                                    record.Paid_Search_Campaign_List__c = addMapValuesWithSemicolon(MapOfPaidSearch_OTPNotVerified_LeadSources_GOLD, record.City__c);
                                                }                               
                                                if(!(MapOfFaceBookAd_OTPVerified_LeadSources_GOLD.get(record.City__c)).isEmpty())
                                                {
                                                    record.Facebook_Ad_OTP_Campaign_List__c = addMapValuesWithSemicolon(MapOfFaceBookAd_OTPVerified_LeadSources_GOLD, record.City__c);
                                                }
                                                if(!(MapOfFaceBookAd_OTPNotVerified_LeadSources_GOLD.get(record.City__c)).isEmpty())
                                                {
                                                    record.Facebook_Ad_Campaign_List__c = addMapValuesWithSemicolon(MapOfFaceBookAd_OTPNotVerified_LeadSources_GOLD, record.City__c);
                                                }
                                                if(!(MapOfdiscovery_OTPVerified_LeadSources_GOLD.get(record.City__c)).isEmpty())
                                                {
                                                      record.discovery_OTP_Campaign_List__c = addMapValuesWithSemicolon(MapOfdiscovery_OTPVerified_LeadSources_GOLD, record.City__c);
                                                }
                                                if(!(MapOfdiscovery_OTPNotVerified_LeadSources_GOLD.get(record.City__c)).isEmpty())
                                                {
                                                      record.discovery_Campaign_List__c = addMapValuesWithSemicolon(MapOfdiscovery_OTPNotVerified_LeadSources_GOLD, record.City__c);   
                                                }       
 
                                                MapOfCitytoClassification2.put((record.City__c+';Gold'),'Gold');
                                        }
                                
                                		else if(MapOfCitytoClassification1.containsKey(record.City__c+';'+'Silver') && MapOfCitytoClassification1.get(record.City__c+';'+'Silver')=='Silver' && 
                                                record.RecordTypeId == SilverCLID)
                                        {
                                                if(!(MapOfPaidSearch_OTPVerified_LeadSources_SILVER.get(record.City__c)).isEmpty())
                                                {
                                                    record.Paid_Search_OTP_Campaign_List__c = addMapValuesWithSemicolon(MapOfPaidSearch_OTPVerified_LeadSources_SILVER,record.City__c);
                                                }
                                                if(!(MapOfPaidSearch_OTPNotVerified_LeadSources_SILVER.get(record.City__c)).isEmpty())
                                                {
                                                    record.Paid_Search_Campaign_List__c = addMapValuesWithSemicolon(MapOfPaidSearch_OTPNotVerified_LeadSources_SILVER, record.City__c);
                                                }
                                                if(!(MapOfFaceBookAd_OTPVerified_LeadSources_SILVER.get(record.City__c)).isEmpty())
                                                {
                                                    record.Facebook_Ad_OTP_Campaign_List__c = addMapValuesWithSemicolon(MapOfFaceBookAd_OTPVerified_LeadSources_SILVER, record.City__c);
                                                }
                                                if(!(MapOfFaceBookAd_OTPNotVerified_LeadSources_SILVER.get(record.City__c)).isEmpty())
                                                {
                                                    record.Facebook_Ad_Campaign_List__c = addMapValuesWithSemicolon(MapOfFaceBookAd_OTPNotVerified_LeadSources_SILVER, record.City__c);
                                                }
                                                if(!(MapOfdiscovery_OTPVerified_LeadSources_SILVER.get(record.City__c)).isEmpty())
                                                {
                                                    record.discovery_OTP_Campaign_List__c = addMapValuesWithSemicolon(MapOfdiscovery_OTPVerified_LeadSources_SILVER, record.City__c);
                                                }
                                                if(!(MapOfdiscovery_OTPNotVerified_LeadSources_SILVER.get(record.City__c)).isEmpty())
                                                {
                                                    record.discovery_Campaign_List__c = addMapValuesWithSemicolon(MapOfdiscovery_OTPNotVerified_LeadSources_SILVER, record.City__c);   
                                                }
                                            
                                                MapOfCitytoClassification2.put((record.City__c+';Silver'),'Silver');
                                        }
                            
                    }
                 	System.debug('MapOfCitytoClassification2: '+MapOfCitytoClassification2);
                
                	if(!leadClassificationList.isEmpty())
                    {
                        update leadClassificationList;
                        System.debug('Successfully Updated the records.');
                        ResponseWrapper respresult = new ResponseWrapper();
                        respWrap.Status = 'SUCCESS';
                        respWrap.Message = 'Successfully Updated the records.';
                        respresult.Status = 'SUCCESS';
            			respresult.Message = 'Successfully Updated the records.';
                   //     listOfResponseWrapperResult.add(respresult); 
                   //     respWrap.result = listOfResponseWrapperResult;
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
                    }
            }
        }
        catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            respWrap.Status = 'FAILURE';
            ResponseWrapper respresult = new ResponseWrapper();
            respresult.Status = 'FAILURE';
            respresult.Message = e.getMessage();
       //     listOfResponseWrapperResult.add(respresult); 
      //      respWrap.result = listOfResponseWrapperResult;
            respWrap.Message = 'Exception in Salesforce. Excption Message: '+e.getMessage() +' .Stack Trace:'+e.getStackTraceString();
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
            Logger.log('Exception','CreateGreenChannelMappingAPI Class','CreateGreenChannelMapping Method',e.getMessage(),e.getStackTraceString(),null);           
        }
    }
    
    
    	public static String addMapValuesWithSemicolon(Map<String, List<String>> mapOfCitytoCampaignList, String City) 
        {
            	List<String> CampaignList = new List<String>();
            	String AllCampaignsList;
            	if(mapOfCitytoCampaignList.containsKey(City))
                {
                     CampaignList = mapOfCitytoCampaignList.get(City);
                     AllCampaignsList = String.join(CampaignList, ';');
                }
            	System.debug('City : '+City);
                System.debug('CampaignList : '+CampaignList);
                System.debug('AllCampaignsList : '+AllCampaignsList);
           		return AllCampaignsList;
        }

    
    Public class RequestWrapper
    {
            public String city_name;
            public String classification;
            public List<String> paid_search_otp = new  List<String>();
            public List<String> paid_search= new  List<String>();
            public List<String> facebook_ad_otp= new  List<String>();
            public List<String> facebook_ad= new  List<String>();
            public List<String> discovery_otp= new  List<String>();
            public List<String> discovery= new  List<String>();               
    }
    
    Public class ResponseWrapper
    {
        Public String Message;
        Public String Status;
    //    Public List<ResponseWrapperResult> result;
    }
    
  /*  Public class ResponseWrapperResult 
    {
        Public String Message;
        Public String Status;        
    }  */ 
        
}