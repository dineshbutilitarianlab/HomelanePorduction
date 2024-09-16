@RestResource(urlMapping='/DPTransferAPI/*')
Global class DPTransferAPI {
    @HttpPost
    global static void DPTransferUpdate() {
        RestResponse res = new RestResponse();
        RestRequest req = RestContext.request;
        ResponseWrapper respWrap = new ResponseWrapper();
        String inputData = req.requestBody.toString();
        System.debug('input data '+ inputData);
        try{
            if(!String.isBlank(inputData)){
                
                RequestWrapper reqWrap = (RequestWrapper)Json.deserialize(inputData, RequestWrapper.Class);
                system.debug('reqWrap' + reqWrap);
                
                if(reqWrap!=null){
                    if(!String.isBlank(reqWrap.old_DP_Email) && !String.isBlank(reqWrap.new_DP_Email) ){
                        
                       
                       List< Interior_Designer__c>oldEmailInteriorDesigner = [Select id ,Email__c from Interior_Designer__c where Email__c = :reqWrap.old_DP_Email];
                        
                        if(!oldEmailInteriorDesigner.isEmpty()){
                            List <Interior_Designer__c> newEmailInteriorDesigner = [Select id ,Email__c from Interior_Designer__c where Email__c = :reqWrap.new_DP_Email];
                            if(!newEmailInteriorDesigner.isEmpty()){
                                List<Lead> leadRcrdWithOldEmail = [Select id, Interior_Designer__c, Dp_Email__c from Lead where Dp_Email__c=:reqWrap.old_DP_Email];
                                List<Opportunity> oppRcrdWithOldEmail =[select id,Interior_Design_Partner__c,Design_Partner_Email__c from Opportunity where Design_Partner_Email__c=:reqWrap.old_DP_Email];
                                
                                system.debug('leadRcrdWithOldEmail '+leadRcrdWithOldEmail);
                            system.debug('oppRcrdWithOldEmail '+oppRcrdWithOldEmail);
                            
                            if(!leadRcrdWithOldEmail.isEmpty() || !oppRcrdWithOldEmail.isEmpty()){
                                system.debug('Initiate the batch');
                                
                                respWrap.Status = 'SUCCESS';
                                respWrap.Message ='Initiated the DP Transfer process with  '+ leadRcrdWithOldEmail.Size() +' Lead Records and '+ oppRcrdWithOldEmail.Size()+ ' Opportunity Records' ;
                                RestContext.response.addHeader('Content-Type', 'application/json');
                                RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));  
                                
                                    
                                }else{
                                    respWrap.Status = 'FAILURE';
                                    respWrap.Message = 'No Lead and Opportunity record is Present with Old Email Id ';
                                    RestContext.response.addHeader('Content-Type', 'application/json');
                                    RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));  
                                }
                            }else{
                                 
                            respWrap.Status = 'FAILURE';
                            respWrap.Message = 'No Interior designer record is present with  new email Id ';
                            RestContext.response.addHeader('Content-Type', 'application/json');
                            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
                            }
                            
                        }
                        else{
                            
                            respWrap.Status = 'FAILURE';
                            respWrap.Message = 'No Interior designer record is present with old email Id ';
                            RestContext.response.addHeader('Content-Type', 'application/json');
                            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));  
                        }
                    }else{
                        respWrap.Status = 'FAILURE';
                        respWrap.Message = 'Either Old DP Email or New DP Email is Blank ';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
                    }
                    
                    if(respWrap.Status == 'SUCCESS'){
                        DPTransferBatch batchable = new DPTransferBatch(reqWrap.old_DP_Email ,reqWrap.new_DP_Email, Lead.sObjectType);
                        database.executeBatch(batchable,1);
                    }  
                }
                else{
                    System.debug('reqWrap is null.');
                    // responseMessage = 'request Wrapper is null after deserializing.';
                    respWrap.Status = 'FAILURE';
                    respWrap.Message = 'request Wrapper is null after deserializing.';
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
                }
                
                
            }else{
                System.debug('InputData is blank or empty.');
                respWrap.Status = 'FAILURE';
                respWrap.Message = 'InputData string in the request is blank or empty.';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
            }
            
                      
        }catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            respWrap.Status = 'FAILURE';
            respWrap.Message = 'Exception in Salesforce. Excption Message: '+e.getMessage() +' .Stack Trace:'+e.getStackTraceString();
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
            //isResponseSent = true;
            Logger.log('Exception','DPTransferAPI Class','DPTransferUpdate Method',e.getMessage(),e.getStackTraceString(),null);

    }
    }
    Public class RequestWrapper{
        Public String old_DP_Email;
        Public String new_DP_Email;
       
        
    }
    Public class ResponseWrapper{
        Public String Message;
        Public String Status;
        
    }
}