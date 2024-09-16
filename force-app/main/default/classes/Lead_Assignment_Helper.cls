public class Lead_Assignment_Helper  {

    public static void checkWTAStatus(Lead sobjectLead,Map<String,WTA_Assignment__c> MapAssignment,String campaignName){   
        try{
            Lead objLead = sobjectLead;
            Map<String,WTA_Assignment__c> mapWTA_Assignment = MapAssignment;
            String sCampaignName = campaignName;
            Boolean bReadyMatch = false;
            Boolean bAWC = false;
            list<lead> lstLeadToUpdate = new list<lead>();
            WTA_Assignment__c objAssignment = new WTA_Assignment__c();
            Map<Id,Lead> mapLeadMap = new Map<Id,Lead>();

            Integration_Setting__c objIntegrationdetails = Integration_Setting__c.getValues('OzoneTel Active Agent');
            if(objIntegrationdetails != NULL){
                Http h = new Http();
                HttpRequest request = new HttpRequest();
                String sEndPoint = objIntegrationdetails.End_Point__c+'username=HomeLane&apikey='+objIntegrationdetails.Authorization__c+'&campaignName='+sCampaignName;
                request.setMethod('GET');
                request.setEndpoint(sEndPoint); 
                system.debug('++++++request++++++'+request);

                // Sending Request 
                HttpResponse response= h.send(request); 
                System.debug('----response--'+response);

                //If Success
                if(response.getStatusCode() == 200){
                    system.debug('++++++response++++++'+response.getBody());
                    responseWrapper objWrapper = new responseWrapper();
                    objWrapper = (responseWrapper) Json.deserialize(response.getBody(),responseWrapper.class);
                    system.debug('++++++objWrapper++++++'+objWrapper);

                    //If Ozonetel sends success response
                    if(objWrapper.code == '200'){
                        
                        if(objWrapper.response != NULL && !objWrapper.response.isEmpty()){
                            system.debug('---objWrapper----'+objWrapper.response);
                            //Find the Agent Who are Ready 
                            for(AgentDetails objAgentDetails : objWrapper.response){
                                if(!String.isEmpty(objAgentDetails.AgentId)){
                                    if(objAgentDetails.State.containsIgnoreCase('Ready')){
                                        if(mapWTA_Assignment.containsKey(objAgentDetails.AgentId)){
                                            objAssignment = mapWTA_Assignment.get(objAgentDetails.AgentId);
                                            bReadyMatch = true;
                                            //Change Owner and WTA agent  Creating new instanse.Since it is after insert
                                            lead ObjectLead = new lead();
                                            ObjectLead.id = objLead.id;
                                            ObjectLead.ownerID = mapWTA_Assignment.get(objAgentDetails.AgentId).User__c;
                                            ObjectLead.WT_Agent__c = mapWTA_Assignment.get(objAgentDetails.AgentId).User__c;
                                            //ObjectLead.Pushed_To_Ozone_1st_Time__c = true;
                                            lstLeadToUpdate.add(ObjectLead);
                        
                                            break;
                                        }
                                    }
                                }
                            }



                            //Find the Agent Who are AWC 
                            if(!bReadyMatch){
                                for(AgentDetails objAgentDetails : objWrapper.response){
                                    if(!String.isEmpty(objAgentDetails.AgentId)){
                                        if(objAgentDetails.State.containsIgnoreCase('AWC')){
                                            if(mapWTA_Assignment.containsKey(objAgentDetails.AgentId)){
                                                bAWC = true;
                                                objAssignment = mapWTA_Assignment.get(objAgentDetails.AgentId);
                                                //Change Owner and WTA agent  Creating new instanse.Since it is after insert
                                                lead ObjectLead = new lead();
                                                ObjectLead.id = objLead.id;                                                
                                                ObjectLead.ownerID = mapWTA_Assignment.get(objAgentDetails.AgentId).User__c;
                                                ObjectLead.WT_Agent__c = mapWTA_Assignment.get(objAgentDetails.AgentId).User__c;
                                                //ObjectLead.Pushed_To_Ozone_1st_Time__c = true;
                                                lstLeadToUpdate.add(ObjectLead);
                                                break;
                                            }
                                        }
                                    }
                                }

                                if(!bAWC){
                                    //Assign to any WTA                                 
                                    for(AgentDetails objAgentDetails : objWrapper.response){
                                        if(!String.isEmpty(objAgentDetails.AgentId)){                                      
                                            if(mapWTA_Assignment.containsKey(objAgentDetails.AgentId)){
                                                
                                                objAssignment = mapWTA_Assignment.get(objAgentDetails.AgentId);
                                                //Change Owner and WTA agent  Creating new instanse.Since it is after insert
                                                lead ObjectLead = new lead();
                                                ObjectLead.id = objLead.id;   
                                                ObjectLead.ownerID = mapWTA_Assignment.get(objAgentDetails.AgentId).User__c;
                                                ObjectLead.WT_Agent__c = mapWTA_Assignment.get(objAgentDetails.AgentId).User__c;
                                                //ObjectLead.Pushed_To_Ozone_1st_Time__c = true;
                                                lstLeadToUpdate.add(ObjectLead);
                                                break;
                                            }                                       
                                        }
                                    }
                                }
                            }

                            if(lstLeadToUpdate != NULL && !lstLeadToUpdate.isEmpty()){
                                Update lstLeadToUpdate;
                            }else{
                                if(RecursiveTriggerHandlerLead.bCallOutGroupB){
                                    // If all the agent quota is filled and any agent is on leave assign it to group B
                                    AssignLeadToWTAGroup.asssigntoGroupB(objLead);
                                    RecursiveTriggerHandlerLead.bCallOutGroupB = false;
                                    
                                    
                                }
                            }

                            if(objAssignment != NULL && lstLeadToUpdate != NULL && !lstLeadToUpdate.isEmpty()){
                                objAssignment.Monthly_Assignments__c = objAssignment.Monthly_Assignments__c + 1;
                                objAssignment.Daily_Assignment__c = objAssignment.Daily_Assignment__c + 1;
                                objAssignment.Weekly_Assignment__c = objAssignment.Weekly_Assignment__c + 1;
                                
                                Update objAssignment;
                                system.debug('lstLeadToUpdate[0].Phone'+lstLeadToUpdate[0].Phone);
                                LeadPushToOzonetelQueueable.callOzonetelAPI(objAssignment.Agent_Campaign_Name__c, objLead.Phone, objLead.id);
                            }
                        }    
                        else{
                            // IF No Agent has Logged in assign it to any WTA
                                //Change Owner and WTA agent  Creating new instanse.Since it is after insert
                                lead ObjectLead = new lead();
                                ObjectLead.id = objLead.id;  
                                ObjectLead.ownerID = mapWTA_Assignment.Values()[0].User__c;
                                ObjectLead.WT_Agent__c = mapWTA_Assignment.Values()[0].User__c;
                                //ObjectLead.Pushed_To_Ozone_1st_Time__c = true;
                                update ObjectLead;
                               
                                mapWTA_Assignment.Values()[0].Monthly_Assignments__c = mapWTA_Assignment.Values()[0].Monthly_Assignments__c + 1;
                                mapWTA_Assignment.Values()[0].Daily_Assignment__c = mapWTA_Assignment.Values()[0].Daily_Assignment__c + 1;
                                mapWTA_Assignment.Values()[0].Weekly_Assignment__c = mapWTA_Assignment.Values()[0].Weekly_Assignment__c + 1;
                                Update mapWTA_Assignment.Values()[0];

                                Logger.log('No Agent Avaliable ','Lead_Assignment_Helper','execute','No Agent are Avaliable so assigned to default agent'+mapWTA_Assignment.Values()[0].Agent_Campaign_Name__c,'lead ID'+objLead.id,NULL);
                                LeadPushToOzonetelQueueable.callOzonetelAPI( mapWTA_Assignment.Values()[0].Agent_Campaign_Name__c, objLead.Phone, objLead.id);
                        }
                    }
                    else{
                        // where code != 200 error condtion logger + retry
                        Logger.log('No Agent Avaliable ','Lead_Assignment_Helper','execute','400 from Ozonetel','lead ID'+objLead.id,NULL);
                    }

                }else{
                    //Integration Details are not Present 
                    Logger.log('Custom Setting Error  ','Lead_Assignment_Helper','execute','Check Custom Setting Details','lead ID'+objLead.id,NULL);
                }
            }
        }
        catch(Exception e){
            system.debug('+++exception+++'+e.getmessage());
        }    
    }  

    public class responseWrapper{
        public String code; 
        public String status;   
        public String message;
        public list<AgentDetails> response;
    }

    public class AgentDetails {
        public String AgentId;  
        public String AgentName;    
        public String State;
        public String PhoneNumber;  
        public String Mode; 
        public String Skill;    
    }   
}