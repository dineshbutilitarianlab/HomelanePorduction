global class PushLeadToNimbusQueuable implements Queueable
{
    public String jsonBody;
    private String LeadID;
    public Boolean isGlobiva;    
     
    global PushLeadToNimbusQueuable(String jsonBody, String LeadID, Boolean isGlobiva) 
    {
        this.jsonBody = jsonBody;
        this.LeadID = LeadID;    
        this.isGlobiva = isGlobiva;
    }
    
    global void execute(QueueableContext QC) 
    {
        if(String.isNotBlank(jsonBody) && String.isNotBlank(LeadID))
        {
          	callNimbusFuture(jsonBody,LeadID,isGlobiva);          
        }
    }
    
    @future(callout=true)
    public static void callNimbusFuture(String jsonBody,String LeadID,Boolean isGlobiva)
    {
        system.debug('qu+jsonBody'+ jsonBody);
        system.debug('qu+jsoLeadID'+ LeadID);
        if( String.isNotBlank(jsonBody) && String.isNotBlank(LeadID) )
        {
            boolean leadStatus = calloutToNimbusAPI(jsonBody,LeadID, isGlobiva);
            system.debug('leadStatus '+ leadStatus);
            Lead leadToUpdate = new Lead();
            leadToUpdate.id = LeadID;
            
            if(leadStatus)
            {
                system.debug('sent');
                leadToUpdate.Nimbus_Status__c =  GenericConstants.SENT_TO_NIMBUS;
                leadToUpdate.Nimbus_Assignment_Date__c=system.now();                
            }
            else
            {
                leadToUpdate.Nimbus_Status__c = GenericConstants.FAILED_SENDING_TO_NIMBUS;                
            }
            
            update leadToUpdate;
            System.debug('leadToUpdate: '+leadToUpdate);
        }
    }
    
    Public Static boolean calloutToNimbusAPI(String jsonBody ,String LeadID,Boolean isGlobiva)
    {
        Boolean isSuccessfullyPushedToNimbus = false;		 
        
        try
        {
            if(String.isNotBlank(jsonBody) && String.isNotBlank(LeadID))
            {
                    Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                    Integration_Setting__c integrationDetail  = null;
                   
                	if(isGlobiva)
                    {
                        	integrationDetail = allEndPoint.get('Globiva');
                    }
                	else
                    {
                        	integrationDetail = allEndPoint.get('Cube Dialer');
                    }
                      
                          
                    system.debug('integrationDetail endpoint ' + integrationDetail );
                    Http http = new Http();
                    HttpRequest request = new HttpRequest();
                    Httpresponse response = new Httpresponse();
                    request.setMethod('POST');
                    request.setBody(jsonBody);                                 
                    request.setEndPoint(integrationDetail.End_Point__c);
                
                	if(isGlobiva)
                    {
                        request.setHeader('Authorization',integrationDetail.Authorization__c);
                    	request.setHeader('Content-Type',integrationDetail.ContentType__c);
                    }               	
                
                    request.setTimeout(120000);
                    System.debug('request: '+request);
                    System.debug('request body: '+jsonBody);
                    System.debug('Authorization'+integrationDetail.Authorization__c);
                    System.debug('endpoint '+ integrationDetail.End_Point__c);
                
                    response = http.send(request);
                    System.debug('response: '+response);
                    String resJson;
                    
                    if(response.getStatusCode()==200)
                    {
                          isSuccessfullyPushedToNimbus = true;                           
                    }               
             }
             else
             {
                   // System.debug('response.getStatusCode(): '+response.getStatusCode());
                    Logger.log('Error','PushLeadsToNimbusQueuable class','calloutToNimbusAPI method','Status code error',null,LeadID);
             }
            
        }
        catch(Exception e)
        {
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception','PushLeadsToNimbusQueuable class','calloutToNimbusAPI method',e.getMessage(),e.getStackTraceString(),LeadID);
        }
        
        return isSuccessfullyPushedToNimbus;
    }
    
   
    
    
}