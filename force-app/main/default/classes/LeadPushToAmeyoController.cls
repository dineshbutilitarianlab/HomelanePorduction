global Class LeadPushToAmeyoController{
  
 /*@future(callout=true)
 webservice static void PushLeadToAmeyo(String recordId,String phoneNumber){
    try{
       Ameyo_Details__c objAmeyo = Ameyo_Details__c.getValues('Admin');
           String strUserName = objAmeyo.UserName__c;
           String strPassword = objAmeyo.Password__c;
           String SessionId = objAmeyo.SessionId__c;
           if(SessionId !='' && SessionId != null){
              if(checkSessionId(SessionId)){
                  pushToAmeyo(SessionId,phoneNumber,recordId);
              }else{
                SessionId = getAmeyoSessionId(strUserName,strPassword); 
                 pushToAmeyo(SessionId,phoneNumber,recordId);            
              }
           }
    }catch(Exception exp){
        SendEmailToManager('Salesforce - Please check the following error-'+exp.getMessage()+' at line- '+exp.getLineNumber()+', Stack Track- '+exp.getStackTraceString()+' and do the needful');
    }       
     
     
    }
 
     global static String getAmeyoSessionId(String username,String password){
         String strCommand='login';
         String strdata='{"userId":"'+username+'","password":"'+password+'"}';
         String SessionId = '';
        
         HttpResponse strResponse = callAmeyoAPI(strCommand,strData);
         Map<String,Object>  mapResponse = (Map<String,Object>) JSON.deserializeUntyped(strResponse.getBody());
         System.debug('-----getAmeyoSessionId---strResponse----'+strResponse.getBody());
         if(mapResponse.get('sessionId') != null)
             SessionId = (String) mapResponse.get('sessionId');
         else if(mapResponse.get('message')!= null){
             String strMessage = (String) mapResponse.get('message');
            if(strMessage.Contains('Incorrect Username or Password'))
                SendEmailToManager('Salesforce - This is to inform you that username ='+username+' and password = '+password+' is not exists in Ameyo,Because we got the following error-'+(String) mapResponse.get('message')+'. Please do the needful'); 
           }
            
         return SessionId;
     }
 
      global static Boolean checkSessionId(String strSessionId){
        String strCommand='ping-session';
        String strdata='{"sessionId":"'+strSessionId+'"}';
        boolean isAlive = false;
        HttpResponse strResponse = callAmeyoAPI(strCommand,strData);
        System.debug('-----checkSessionId---strResponse----'+strResponse.getBody());
        Map<String,Object>  mapResponse = (Map<String,Object>) JSON.deserializeUntyped(strResponse.getBody());
        if(mapResponse.get('alive') != null)
            isAlive = (boolean) mapResponse.get('alive'); 
        return isAlive;
     }



     global static String pushToAmeyo(String strSessionId,String strPhone,String strRecordId){
        String strCommand='uploadContacts';
        String strdata='{"campaignId":"3","leadId":3,"sessionId":"'+strSessionId+'" ,"properties":{"update.customer":"true","migrate.customer":"true"},"status" : "NOT_TRIED","customerRecords":[{"phone1":"'+strPhone+'","record_id":"'+strRecordId+'","lead_type":"priority"}]}';
        HttpResponse strResponse = callAmeyoAPI(strCommand,strData);
        system.debug('-----pushToAmeyo---strResponse----'+strResponse.getBody());
        Map<String,Object>  mapResponse = (Map<String,Object>) JSON.deserializeUntyped((String) strResponse.getBody());
        if(mapResponse.get('message') != null){
            String strMessage = (String) mapResponse.get('message');
            if(strMessage.Contains('Upload Contacts Failed. Reason: [\"SessionService.invalid.sessionid\"') || strMessage.Contains('SessionService.get.user.session.failed.null.sessionid'))
                PushLeadToAmeyo(strRecordId,strPhone);
            else
                SendEmailToManager('Salesforce - This is to inform you that Lead with the phone ='+strPhone+' and record Id = '+strRecordId+' is not pushed to Ameyo,Because we got the following error-'+(String) mapResponse.get('message')+'. Please do the needful');
        }else{
            if(mapResponse.get('beanResponse') != null){
            //String strBeanResponse = (List<Object>) mapResponse.get('beanResponse');
            //List<Object> lstBeanResponse = (List<Object>) mapResponse.get('beanResponse');
            //system.debug('-----lstBeanResponse-----'+lstBeanResponse);
                String strBean = (String) strResponse.getBody();
                strBean = strBean.ReplaceAll('exception','strexception');
                fromJSON wrapperJson = (fromJSON) System.JSON.deserialize(strBean, fromJSON.class);
                // Map<String,Object>  mapbeanResponse = (Map<String,Object>) JSON.deserializeUntyped(strBean);
                 system.debug('-----wrapperJson-----'+wrapperJson);
                 cls_beanResponse[] lstBeanResponse = wrapperJson.beanResponse;
                // if(mapbeanResponse.get('inserted') != null){
                    // boolean isInserted = (boolean) mapbeanResponse.get('inserted');
                    // system.debug('-----isInserted-----'+isInserted);
                     if(!lstBeanResponse[0].inserted)
                         SendEmailToManager('Salesforce - This is to inform you that Lead with the phone ='+strPhone+' and record Id = '+strRecordId+' is not pushed to Ameyo,Because we got the following error-'+lstBeanResponse[0].strexception+'. Please do the needful');
                    //}
            }
             Ameyo_Details__c objCSAmeyo = Ameyo_Details__c.getValues('Admin');
             objCSAmeyo.SessionId__c = strSessionId;
             update objCSAmeyo;
             
        }
        return null;
     }
 
 
     global static HttpResponse callAmeyoAPI(String strCommand,String strData){
         strData = EncodingUtil.URLENCODE(strData,'UTF-8');
         HttpRequest objReq = new HttpRequest();
         Http objHttp = new Http();
         //objReq.setEndPoint('https://ameyo.homelane.com:8443/ameyowebaccess/command/?command='+strCommand+'&data='+strData);
         objReq.setMethod('GET');
         objReq.setClientCertificateName('ameyoserver');
         objReq.setHeader('Content-Type', 'application/json');
         system.debug('--------objReq-----------'+objReq);
         HttpResponse objResponse = objHttp.send(objReq);
         system.debug('--------objResponse -----------'+objResponse );
         return objResponse;
       }
        global Static void SendEmailToManager(String errMsg){
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.toAddresses = new String[] {'sachin.k@kvpcorp.com','cameron.j@homelane.com','ravi.r@homelane.com','nitin.b@homelane.com'}; 
                            message.optOutPolicy = 'FILTER';
                            message.subject = 'Lead Push to Ameyo Issue';
                            message.plainTextBody = errMsg;
                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
        
    public class fromJSON{
        public cls_beanResponse[] beanResponse;
    }
    class cls_beanResponse {
        public boolean inserted;
        public String strexception; //["CustomerManager.Phone.number.does.not.match.with.regex","[0-9]+"]
        public String resultTypeString; //PREPROCESSING_REGEX_DOES_NOT_MATCH
        public boolean crmIntegrated;
        public boolean crmSuccess;
    }
    */


}