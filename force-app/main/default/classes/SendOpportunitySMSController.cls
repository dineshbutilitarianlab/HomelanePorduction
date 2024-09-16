Public with sharing Class SendOpportunitySMSController {
    
    /*=================================================================================================== 
    * @Description   : Get called from Opportunity Trigger handler and In this class SMS content 
    *                  Is Modified      
    * @param         : List<Opportunity ID>, SMS Template Name 
    *=====================================================================================================
    **/
    public static void getSMSTemplate(List<String> lstOpportunityId,String strTemplateName){
        try{
            String strMSGContent='';
            if(!lstOpportunityId.isEmpty() && String.IsNotBlank(strTemplateName)){
                SMS_Template__c objSMSTemplate = [Select Id,Name,SMS_Content__c,Template_ID__c From SMS_Template__c Where Name =:strTemplateName Limit 1];
                if(objSMSTemplate != NULL){
                    for(Opportunity Opp : [Select Id,Name,Full_Name__c,Channel_Partner__c,Amount_Collected__c,Channel_Partner__r.Phone__c,Channel_Partner__r.Recordtype.DeveloperName from Opportunity where ID IN:lstOpportunityId]){
                         system.debug('Opp---->'+Opp);
                        strMSGContent = objSMSTemplate.SMS_Content__c;
                        if(String.IsNotBlank(Opp.Channel_Partner__r.Phone__c) && Opp.Channel_Partner__r.Recordtype.DeveloperName.equalsIgnoreCase('Ambassador')){
                            if(Integer.Valueof(Opp.Amount_Collected__c) > 48000 && String.IsNotBlank(Opp.Channel_Partner__r.Phone__c)){
                                strMSGContent = strMSGContent.replace('{Full_Name}',Opp.Full_Name__c);
                                system.debug('strMSGContent---->'+strMSGContent);
                                SendSMSMsg91(strMSGContent,Opp.Channel_Partner__r.Phone__c,Opp.id,strTemplateName,objSMSTemplate.Template_ID__c);
                            }
                         }   
                    }
                }   
            }
        }
        catch(Exception e){Logger.log('Exception ','SendOpportunitySMSController Class','getSMSTemplate Method',e.getMessage(),e.getStackTraceString(),null);}
    }   
    
    /*=================================================================================================== 
    * @Description   : In This Method we are making callout to valueFirst Api and update the Description            
    * @param         : List<Opportunity ID>, SMS Template Name 
    *=====================================================================================================
    **/
   /*@future(callout=true)
    public Static void SendSMS(String strContant,String strPhone,String objOpportunityId,String smsType){
        try{
            Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
            Integration_Setting__c integrationDetail = allEndPoint.get('myvaluefirst_API');
            
            strContant = EncodingUtil.urlEncode(strContant,'UTF-8');
            httpRequest objReq = new httpRequest();
            http objHttp = new http();
            //String strUrl = 'http://www.myvaluefirst.com/smpp/sendsms?username=homehtptrans&password=home1290&to='+strPhone+'&from=HOMLNE&text='+strContant;
            String strUrl = integrationDetail.End_Point__c+'username='+integrationDetail.Username__c+'&password='+integrationDetail.Password__c+'&to='+strPhone+'&from='+integrationDetail.Client_Id__c+'&text='+strContant;
            System.debug('******strUrl  '+strUrl);
            objReq.setEndPoint(strUrl);
            objReq.setMethod('GET');
            httpResponse objRes = new httpResponse();
            system.debug('objRes'+objRes);
            if(!Test.IsRunningTest())
                objRes = objHttp.send(objReq);
            else{
                objRes.setStatusCode(101);
            }  
            System.debug('*****objRes*****  '+objRes);  
            System.debug('*****objRes*****  '+objRes.getBody());             
            Opportunity newOpp = [ Select id,Name,Sales_Description__c from Opportunity where id=:objOpportunityId limit 1];

            if(objRes.getStatusCode() != 200){
                if(newOpp != NULL && String.isNotBlank(smsType)){
                    
                    if(newOpp.Sales_Description__c == null){
                        newOpp.Sales_Description__c = smsType + ' - SMS Failed - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']';
                    }
                    else {
                        newOpp.Sales_Description__c = smsType +' - SMS Failed - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']'+'\n'+newOpp.Sales_Description__c; 
                    }
                    update newOpp;
                }  
            }
            else if(objRes.getStatusCode() == 200){
                if(newOpp != NULL  && String.isNotBlank(smsType)){
                    if(newOpp.Sales_Description__c == null){ 
                        newOpp.Sales_Description__c = smsType + ' - SMS Sent - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']';
                    }
                    else {
                        newOpp.Sales_Description__c = smsType + ' -  SMS Sent - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']'+'\n'+newOpp.Sales_Description__c;
                    }
                    update newOpp;
                }  
            }
        }
        catch(Exception e){System.debug('Exception :'+e.getStackTraceString());Logger.log('Exception ','SendOpportunitySMSController Class','SendSMS Method',e.getMessage(),e.getStackTraceString(),null);
        }
    } */
        @future(callout=true)
    public Static void SendSMSMsg91(String strContant,String strPhone,String objOpportunityId,String smsType,String templateId){
        try{
            Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
            Integration_Setting__c integrationDetail = allEndPoint.get('MSG91_API');
            
            strContant = EncodingUtil.urlEncode(strContant,'UTF-8');
            httpRequest objReq = new httpRequest();
            http objHttp = new http();
            //String strUrl = http://api.msg91.com/api/v2/sendsms?dev_mode=1;
            String strUrl = integrationDetail.End_Point__c;
            System.debug('******strUrl  '+strUrl);
            objReq.setEndPoint(strUrl);
            objReq.setHeader('Content-Type', integrationDetail.ContentType__c);
            objReq.setHeader('authkey', integrationDetail.Authorization__c);
            
            SendSMSController.MSG91SMSRequestWrapper requestWrapper = new SendSMSController.MSG91SMSRequestWrapper();
            requestWrapper.sender = integrationDetail.client_Id__c;
            requestWrapper.route = '4';
            requestWrapper.country = '91';
            requestWrapper.DLT_TE_ID = templateId;
            
            SendSMSController.SMSWrapper smsWrapper = new SendSMSController.SMSWrapper();
            smsWrapper.message = strContant;
            List<String> toNumbers = new List<String>{strPhone};
            smsWrapper.to = toNumbers;
            
            List<SendSMSController.SMSWrapper> listOfSMSWrapper = new List<SendSMSController.SMSWrapper>{smsWrapper};
            requestWrapper.sms = listOfSMSWrapper;
            
            String requestBody = Json.serialize(requestWrapper);
            System.debug('requestBody: '+requestBody);
            objReq.setMethod('POST');
            objReq.setBody(requestBody);
            httpResponse objRes = new httpResponse();
            system.debug('objRes'+objRes);
            if(!Test.IsRunningTest())
                objRes = objHttp.send(objReq);
            else{
                objRes.setStatusCode(101);
            }  
            System.debug('*****objRes*****  '+objRes);  
            
            Opportunity newOpp = [ Select id,Name,Sales_Description__c from Opportunity where id=:objOpportunityId limit 1];

            if(objRes.getStatusCode() != 200){
                if(newOpp != NULL && String.isNotBlank(smsType)){
                    
                    if(newOpp.Sales_Description__c == null){
                        newOpp.Sales_Description__c = smsType + ' - SMS Failed - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']';
                    }
                    else {
                        newOpp.Sales_Description__c = smsType +' - SMS Failed - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']'+'\n'+newOpp.Sales_Description__c; 
                    }
                    update newOpp;
                }  
            }
            else if(objRes.getStatusCode() == 200){
                if(newOpp != NULL  && String.isNotBlank(smsType)){
                    if(newOpp.Sales_Description__c == null){ 
                        newOpp.Sales_Description__c = smsType + ' - SMS Sent - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']';
                    }
                    else {
                        newOpp.Sales_Description__c = smsType + ' -  SMS Sent - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']'+'\n'+newOpp.Sales_Description__c;
                    }
                    update newOpp;
                }  
            }
        }
        catch(Exception e){
            System.debug('Exception :'+e.getStackTraceString());
            Logger.log('Exception','SendSMSController','SendSMSMsg91',objOpportunityId,e.getMessage()+ ' '+ e.getStackTraceString(),smsType);
        }
    }
}