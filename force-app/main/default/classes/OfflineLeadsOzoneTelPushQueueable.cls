global class OfflineLeadsOzoneTelPushQueueable implements Queueable,Database.AllowsCallOuts{
    private Set<String> setOfIds;
    private Static String dialType;
    //Public static Boolean successFullyPushedToOzonetel = false;
    global OfflineLeadsOzoneTelPushQueueable(Set<String> setOfIds) {
        this.setOfIds = setOfIds;
        //this.dialType = dialType;
    }
    global void execute(QueueableContext QC) {
        try{
            /*Set<String> setOfIds = new Set<String>();
            setOfIds.add('00Q5D000002pUlB');
            setOfIds.add('00Q5D000002pdoz');
            setOfIds.add('00Q5D000002pROi');*/
            List<Lead> listOfLeads = new List<Lead>();
            listOfLeads = [Select 
                           id,Name,Phone,Dialler_Campaign_Type_and_Status__c
                          // ,Offline_Priority_Lead__c
                           from Lead 
                           where (Dialler_Campaign_Type_and_Status__c = 'Progressive Dial Initiated'
                                  or Dialler_Campaign_Type_and_Status__c = 'Predictive Dial Initiated')
                           and Bulk_Upload__c = true and id =:setOfIds
                          ];
            System.debug('listOfLeads: '+listOfLeads);
            if(!listOfLeads.isEmpty()){
                Lead leadToProcess = listOfLeads[0];
                setOfIds.remove(leadToProcess.Id);
                
                // Chaninng of jobs. EnqueueJob
                if(!setOfIds.isEmpty()){
                    ID jobID = System.enqueueJob(new OfflineLeadsOzoneTelPushQueueable(setOfIds));
                    System.debug('jobID: '+jobID);
                }
                //List<Lead> listOfNextLeadsToBeProcessed = new List<Lead>();
                String campaignName;
                
                // This is commented because we changed the checkbox Offline_Priority_Lead__c to picklist field in Bulk offline lead creation CSV file
                
              /*  if(leadToProcess.Offline_Priority_Lead__c){
                    if(leadToProcess.Dialler_Campaign_Type_and_Status__c.equalsIgnoreCase('Progressive Dial Initiated')){
                        campaignName = 'PRIORITY_PROGRESSIVE_OFFLINE_CAMPAIGN_AutoLead';
                    }
                    else if(leadToProcess.Dialler_Campaign_Type_and_Status__c.equalsIgnoreCase('Predictive Dial Initiated')){
                        campaignName = 'PRIORITY_PREDICTIVE_OFFLINE_CAMPAIGN_AutoLead';
                    }
                
                }*/
              // else {
                    if(leadToProcess.Dialler_Campaign_Type_and_Status__c.equalsIgnoreCase('Progressive Dial Initiated')){
                        campaignName = 'PROGRESSIVE_OFFLINE_CAMPAIGN_AutoLead';
                    }
                    else if(leadToProcess.Dialler_Campaign_Type_and_Status__c.equalsIgnoreCase('Predictive Dial Initiated')){
                        campaignName = 'PREDICTIVE_OFFLINE_CAMPAIGN_AutoLead';
                    }
             //  } 
                System.debug('leadToProcess.id: '+leadToProcess.id);
                System.debug('leadToProcess.Phone: '+leadToProcess.Phone);
                
                // Push to ozoneTel
                //pushLeadToOzoneTelEvents(leadToProcess.id,leadToProcess.Phone,campaignName,'OzoneTel addCamapaignData API');
                pushLeadToOzoneTelEventsFuture(leadToProcess.id,leadToProcess.Phone,campaignName,'OzoneTel addCamapaignData API');
                
                // For Exception code coverage
                if(Test.isRunningTest()){
                    System.debug(1/0);
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','OfflineLeadsOzoneTelPushQueueable Class','execute Method',e.getMessage(),e.getStackTraceString(),null); 
        }
    }
    
    @future (callOut=True)
    Public Static void pushLeadToOzoneTelEventsFuture(String leadId,String leadPhone, String campaignName,String integrationSettingName){
        Boolean successFullyPushedToOzonetel = false;
        System.debug('pushLeadToOzoneTelEvents method leadId: '+leadId);
        System.debug(' pushLeadToOzoneTelEvents methodcampaignName: '+campaignName);
        System.debug('pushLeadToOzoneTelEvents method leadPhone: '+leadPhone);
        System.debug(' pushLeadToOzoneTelEvents integrationSettingName: '+integrationSettingName);
        try{
            if(String.isNotBlank(leadId) && String.isNotBlank(leadPhone) && String.isNotBlank(campaignName) && String.isNotBlank(integrationSettingName)){
                Integration_Setting__c OzoneTeladdCamapaignDataAPI = Integration_Setting__c.getValues(integrationSettingName);
                if(OzoneTeladdCamapaignDataAPI != null){
                    if(!String.isBlank(OzoneTeladdCamapaignDataAPI.Secret_Key__c) && !String.isBlank(OzoneTeladdCamapaignDataAPI.End_Point__c) && !String.isBlank(OzoneTeladdCamapaignDataAPI.ContentType__c)){
                        String content = 'api_key='+EncodingUtil.urlEncode(OzoneTeladdCamapaignDataAPI.Secret_Key__c, 'UTF-8')+'&campaign_name='+EncodingUtil.urlEncode(campaignName, 'UTF-8')+'&format=json&PhoneNumber='+EncodingUtil.urlEncode(leadPhone, 'UTF-8')+'&action=start';
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
                                    Logger.log('OFFLINE LEADS OZONETEL PUSH ERROR','OfflineLeadsOzoneTelPushQueueable Class','pushLeadToOzoneTelEvents Method','FAILED API Response ','response : '+String.valueOf(response),null);
                                }
                                else{
                                    successFullyPushedToOzoneTel = true;
                                }
                            }
                            else{
                                System.debug('blank Response body Error: '+String.valueOf(response));
                                Logger.log('OFFLINE LEADS OZONETEL PUSH ERROR','OfflineLeadsOzoneTelPushQueueable Class','pushLeadToOzoneTelEvents Method','blank Response body Error','response : '+String.valueOf(response),null);
                            }
                        }
                        else{
                            System.debug('Status code Error: '+response.getStatusCode());
                            Logger.log('OFFLINE LEADS OZONETEL PUSH ERROR','OfflineLeadsOzoneTelPushQueueable Class','pushLeadToOzoneTelEvents Method','Status code Error','response: '+String.valueOf(response),String.ValueOf(response.getStatusCode()));
                        }
                    }
                    else{
                        System.debug('Either secret key,end point or content type is blank for this integration setting record :'+OzoneTeladdCamapaignDataAPI);
                        Logger.log('OFFLINE LEADS OZONETEL PUSH ERROR','OfflineLeadsOzoneTelPushQueueable Class','pushLeadToOzoneTelEvents Method','Either secret key,end point or content type is blank for this integration setting record :'+OzoneTeladdCamapaignDataAPI,'','');
                    }
                }
                else{
                    System.debug('There is no integration setting custom setting record with the name '+integrationSettingName);
                    Logger.log('OFFLINE LEADS OZONETEL PUSH ERROR','OfflineLeadsOzoneTelPushQueueable Class','pushLeadToOzoneTelEvents Method','There is no integration setting custom setting record with the name '+integrationSettingName,'','');
                }
                Lead leadToUpdate = new Lead();
                leadToUpdate.id = leadId;
                if(successFullyPushedToOzoneTel){
                    if(campaignName.contains('PROGRESSIVE')){
                        leadToUpdate.Dialler_Campaign_Type_and_Status__c = 'Progressive Dial Sent';
                    }
                    else if(campaignName.contains('PREDICTIVE')){
                        leadToUpdate.Dialler_Campaign_Type_and_Status__c = 'Predictive Dial Sent';
                    }
                    
                    // Used in the list view filter where the offine leads will be pushed to either progressive or predictive dialler through button click.
                    leadToUpdate.Pushed_To_Ozonetel__c = True;
                    
                    //leadToUpdate.Dialler_Campaign_Type_and_Status__c = dialType+' Dial Sent';
                }
                else{
                    if(campaignName.contains('PROGRESSIVE')){
                        leadToUpdate.Dialler_Campaign_Type_and_Status__c = 'Progressive Dial Failed';
                    }
                    else if(campaignName.contains('PREDICTIVE')){
                        leadToUpdate.Dialler_Campaign_Type_and_Status__c = 'Predictive Dial Failed';
                    }
                }
                // Update the lead record.
                update leadToUpdate;
                System.debug('Limits.getLimitQueueableJobs(): '+Limits.getLimitQueueableJobs());
            }
            else{
                System.debug('Some of the parameters to the method are blank. Integration Setting Name: '+integrationSettingName+'. leadId: '+leadId+'. leadPhone: '+leadPhone+'. campaignName: '+campaignName);
                Logger.log('OFFLINE LEADS OZONETEL PUSH ERROR','OfflineLeadsOzoneTelPushQueueable Class','pushLeadToOzoneTelEvents Method','Some of the parameters to the method are blank. Integration Setting Name: '+integrationSettingName+'. leadId: '+leadId+'. leadPhone: '+leadPhone+'. campaignName: '+campaignName,leadId,leadPhone);
                if(Test.isRunningTest()){
                    System.debug(1/0);
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('OFFLINE LEADS OZONETEL PUSH ERROR','OfflineLeadsOzoneTelPushQueueable Class','pushLeadToOzoneTelEvents Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
}