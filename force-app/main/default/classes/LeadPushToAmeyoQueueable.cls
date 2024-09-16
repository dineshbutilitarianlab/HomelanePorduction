global class LeadPushToAmeyoQueueable  {//implements Queueable
    
    /*private List<Lead> lstLead;
    private String userSessionId;
   // public static String strUserId;
    
    
    global LeadPushToAmeyoQueueable(List<Lead> leadList,String strSessionSFId) {
        this.lstLead = leadList;
        this.userSessionId = strSessionSFId;
       // strUserId = leadList.WT_Agent__c;
       
    }
    global void execute(QueueableContext context) {
        for (Lead objLead : lstLead) {
          //  strUserId = objLead.WT_Agent__c;
            if(objLead.LeadSource !='Walk-In' &&  objLead.LeadSource !='Test Source')
            PushLeadToAmeyo(objLead.Id,objLead.Phone,objLead.City,userSessionId);

         // account.parentId = parent;
          // perform other processing or callout
        }
        
    }
@future(callout=true)
     webservice static void PushLeadToAmeyo(String recordId,String phoneNumber, String leadCity,String sessionSFId){
    try{
       Ameyo_Details__c objAmeyo = Ameyo_Details__c.getValues('Admin');
           String strUserName = objAmeyo.UserName__c;
           String strPassword = objAmeyo.Password__c;
           String SessionId = objAmeyo.SessionId__c;
          // system.debug('---strUserId Test----'+strUserId);
           if(SessionId !='' && SessionId != null){
              if(checkSessionId(SessionId)){
                  pushToAmeyo(SessionId,phoneNumber,recordId,leadCity,sessionSFId);
              }else{
                SessionId = getAmeyoSessionId(strUserName,strPassword);
                if(SessionId !='' && SessionId != null) 
                   pushToAmeyo(SessionId,phoneNumber,recordId,leadCity,sessionSFId);            
              }
           }
    }catch(Exception exp){
        SendEmailToManager('Salesforce - Please check the following error-'+exp.getMessage()+' at line- '+exp.getLineNumber()+', Stack Track- '+exp.getStackTraceString()+' for Lead Id - '+recordId+' and Phone-'+phoneNumber+' and do the needful');
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



     global static String pushToAmeyo(String strSessionId,String strPhone,String strRecordId,String strCity,String strSFSessionId){
       // updateLeadData(strRecordId,strSFSessionId);
        String strCommand='uploadContacts';
        String strAMeyoLeadId='';
        Lead objUserId;
        boolean isQueueIdExists = false;
        Map<String,String> mapCity = new Map<String,String>();
        try{
         objUserId = [Select WT_Agent__c,WT_Agent__r.Ameyo_Queue_Id__c from Lead Where Id =: strRecordId LIMIT 1];
        }catch(Exception exp){
            system.debug('---exp catch lead WT----'+exp.getMessage());
            objUserId = new Lead(WT_Agent__c = '0050I000008bpXw');

        }
         system.debug('---objUserId----'+objUserId);
        if(!String.valueOf(objUserId.WT_Agent__c).containsIgnoreCase('0050I000008bpXw')){
            if(objUserId.WT_Agent__r.Ameyo_Queue_Id__c != null)
                strAMeyoLeadId = objUserId.WT_Agent__r.Ameyo_Queue_Id__c;
             else   
                isQueueIdExists = true;
           system.debug('---isQueueIdExists---'+isQueueIdExists);      
        }else{
            mapCity.put('Bengaluru','6');
            mapCity.put('Hyderabad','7');
            mapCity.put('hyderabad','7');
            mapCity.put('Mumbai','10');
            mapCity.put('mumbai','10');
            mapCity.put('Chennai','9');
            mapCity.put('chennai','9');
            mapCity.put('New Delhi','8');
            mapCity.put('Bangalore','6');
            mapCity.put('bangalore','6');
            mapCity.put('bengaluru','6');
            mapCity.put('Noida','8');
            mapCity.put('Ghaziabad','8');
            mapCity.put('Thane','10');
            mapCity.put('Gurgaon','8');
            mapCity.put('Other','11');
            mapCity.put('Others','11');
            strAMeyoLeadId = mapCity.get(strCity);
        }
        String strdata='{"campaignId":"3","leadId":'+strAMeyoLeadId+',"sessionId":"'+strSessionId+'" ,"properties":{"update.customer":"true","migrate.customer":"true"},"status" : "NOT_TRIED","attempts" : "0","customerRecords":[{"phone1":"'+strPhone+'","record_id":"'+strRecordId+'","lead_type":"priority","should_dial":"True"}]}';
        if(!isQueueIdExists){
        HttpResponse strResponse = callAmeyoAPI(strCommand,strData);
        system.debug('-----pushToAmeyo---strResponse----'+strResponse.getBody());
        Map<String,Object>  mapResponse = (Map<String,Object>) JSON.deserializeUntyped((String) strResponse.getBody());
        if(mapResponse.get('message') != null){
            String strMessage = (String) mapResponse.get('message');
            if(strMessage.Contains('Upload Contacts Failed. Reason: [\"SessionService.invalid.sessionid\"') || strMessage.Contains('SessionService.get.user.session.failed.null.sessionid'))
                PushLeadToAmeyo(strRecordId,strPhone,strCity,strSFSessionId);
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
                         SendEmailToManager('Salesforce - This is to inform you that Lead with the phone ='+strPhone+' and record Id = '+strRecordId+' is not pushed to Ameyo,Because we got the following error-'+lstBeanResponse[0].strexception+'.Please do the needful');
                    //}
                    else
                     updateLeadData(strRecordId,strSFSessionId);
                 
            }
             /*String strLogout = '{"sessionId":"'+strSFSessionId+'"}';
             HttpResponse strResponseLogOut = callAmeyoAPI('logout',strLogout);
             system.debug('-----strResponseLogOut---strResponse----'+strResponseLogOut.getBody());*/
            /* Ameyo_Details__c objCSAmeyo = Ameyo_Details__c.getValues('Admin');
             objCSAmeyo.SessionId__c = strSessionId;
             update objCSAmeyo;
        }     
        }
        return null;
     }
 
 
     global static HttpResponse callAmeyoAPI(String strCommand,String strData){
         User use = [select id, Name, Ameyo_was_called__c, Response_Message__c from User where Name = 'Ameyo User'];
         System.debug('------USER IS ---- '+use);
         strData = EncodingUtil.URLENCODE(strData,'UTF-8');
        // try {
         HttpRequest objReq = new HttpRequest();
             Http objHttp = new Http();
             //objReq.setEndPoint('http://ameyo.homelane.com:8888/ameyowebaccess/command/?command='+strCommand+'&data='+strData);
             objReq.setMethod('GET');
             objReq.setClientCertificateName('ameyoserver');
             objReq.setHeader('Content-Type', 'application/json');
             objReq.setTimeout(120000);
             system.debug('--------objReq-----------'+objReq);
             HttpResponse objResponse = objHttp.send(objReq);
             system.debug('--------objResponse -----------'+objResponse );
             Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(objResponse.getBody());
             use.Response_Message__c = String.valueOf(results);
             if (objResponse.getStatusCode() == 200) {
                 use.Ameyo_was_called__c = true;
             }
             return objResponse;
       /*  }
         catch(CallOutException e ) {
            return null;
        } */
       /*}
        global Static void SendEmailToManager(String errMsg){
               String[] strUserEmail = new List<String>();
                 if(!Test.isRunningTest()){Exception_Mail__c objAmeyo = Exception_Mail__c.getValues('SF Lead Mail');strUserEmail = objAmeyo.Email_Addresss__c.split(',');
                 }else{
                  strUserEmail.add('testapi@gmail.com');
                 }
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.toAddresses =strUserEmail; 
                            message.optOutPolicy = 'FILTER';
                            message.subject = 'Lead Push to Ameyo Issue';
                            message.plainTextBody = errMsg;
                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }

     global static HttpResponse updateLeadData(String RecordId, String strUserSessionId){
        
       // String userSessionId = UserInfo.getSessionId();
        system.debug('--------strUserSessionId-----------'+strUserSessionId);
        String sfUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v37.0/sobjects/Lead/'+RecordId;
        final PageReference theUrltoUpdate = new PageReference(sfUrl);
            theUrltoUpdate.getParameters().put('_HttpMethod','PATCH');
        Map<String,Datetime> mapData = new Map<String,Datetime>();
        mapData.put('Ameyo_Upload_Time__c',System.now());
        String strBody = JSON.serialize(mapData);
        
        HttpRequest objReq = new HttpRequest();
        Http objHttp = new Http();
        objReq.setEndpoint(theUrltoUpdate.getUrl());
        objReq.setBody(strBody);
        objReq.setMethod('POST');
        objReq.setHeader('Content-Type', 'application/json');
        objReq.setHeader('Authorization','Bearer '+strUserSessionId);
        objReq.setHeader('SForce-Auto-Assign', 'FALSE');
        
         system.debug('--------objReq-----------'+objReq.getBody());
         HttpResponse objResponse = objHttp.send(objReq);
         system.debug('--------objResponse -----------'+objResponse );
         return objResponse;
       
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