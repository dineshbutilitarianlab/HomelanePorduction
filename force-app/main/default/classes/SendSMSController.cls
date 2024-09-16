/**
 * @File Name          : SendSMSController.cls
 * @Description        : 
 * @Author             : Bharatesh Shetty
 * @Group              : 
 * @Last Modified By   : Bharatesh Shetty
 * @Last Modified On   : 8/9/2019, 1:28:54 PM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    8/9/2019, 12:53:01 PM   Bharatesh Shetty     Initial Version
**/
Public with sharing Class SendSMSController {
    
    public static void GetSMSTemplate(String strLeadId,String strTemplateName){
        
        try{
            Lead objLead = new Lead();
            String strMSGContent='';
            SMS_Template__c objSMSTemplate = [Select Id,Name,SMS_Content__c,Template_ID__c From SMS_Template__c Where Name =:strTemplateName Limit 1];
            for(Lead leadObj :[Select Id,Status,Sub_Status__c,Name,Email,Phone,Tiny_URL_Generate__c,Appointment_Venue_Square__c,Appointment_Time__c,Appointment_Venue_Square__r.Name,Appointment_Venue_Square__r.Property_State__c,Appointment_Venue_Square__r.Google_Map_Link__c,Appointment_Venue_Square__r.Street__c,Appointment_Venue_Square__r.Property_City__c,Appointment_Venue_Square__r.Property_Postal_Code__c,Appointment_Venue_Square__r.Property_Locality__c,Appointment_Venue_Square__r.Property_Landmark__c,Channel_Partner__c,Channel_Partner__r.Phone__c,Channel_Partner__r.Recordtype.DeveloperName from Lead Where Id =: strLeadId]){
                objLead = leadObj;
            }
            strMSGContent = objSMSTemplate.SMS_Content__c;
            String strId = objLead.Id;
            Datetime objTime = objLead.Appointment_Time__c;
            String strAppointmentTime = objTime==null?'':objTime.format('dd/MM/yyyy\' \'HH:mm');
            System.debug('strMSGContent: '+strMSGContent);
            System.debug('objLead.Name: '+objLead.Name);
            System.debug('objLead.Tiny_URL_Generate__c: '+objLead.Tiny_URL_Generate__c);
            System.debug('strAppointmentTime: '+strAppointmentTime);
            System.debug('objLead.Phone: '+objLead.Phone);
            System.debug('objLead.Email: '+objLead.Email);
            if((objLead.Status == 'Fresh Lead' && objLead.Sub_Status__c =='New') || (objLead.Status == 'Not actively pursued' && objLead.Sub_Status__c == 'Exceeded Max Attempts')){
                strMSGContent = strMSGContent.replace('<customer_name>',objLead.Name).replace('<Link>',String.isNotBlank(objLead.Tiny_URL_Generate__c)?objLead.Tiny_URL_Generate__c:Label.WebsiteURL);
            }
            else if(objLead.Appointment_Venue_Square__c != null){
                strMSGContent = strMSGContent.replace('{Full_Name}',objLead.Name).replace('{Chat_Link}',String.isNotBlank(objLead.Tiny_URL_Generate__c)?objLead.Tiny_URL_Generate__c:Label.WebsiteURL).replace('{Appointment Date & Time}',strAppointmentTime).replace('{Showroom Name}',objLead.Appointment_Venue_Square__r.Name==null?'':objLead.Appointment_Venue_Square__r.Name).replace('{Showroom Address}',objLead.Appointment_Venue_Square__r.Street__c).replace('{Showroom Location Link}',objLead.Appointment_Venue_Square__r.Google_Map_Link__c==null?'':objLead.Appointment_Venue_Square__r.Google_Map_Link__c).replace('{Phone Number}',objLead.Phone).replace('{Lead Email}',objLead.Email);
            }
            else{
                strMSGContent = strMSGContent.replace('{Full_Name}',objLead.Name).replace('{Chat_Link}',String.isNotBlank(objLead.Tiny_URL_Generate__c)?objLead.Tiny_URL_Generate__c:Label.WebsiteURL).replace('{Appointment Date & Time}',strAppointmentTime).replace('{Phone Number}',objLead.Phone).replace('{Lead Email}',objLead.Email); 
            }
            if(strTemplateName.equalsIgnoreCase('Floor Plan Not Received')){
                strMSGContent = strMSGContent.replace('{Full_Name}',objLead.Name);
            }
            system.debug('--------strMSGContent-----'+strMSGContent);
            system.debug('--------objLead.Phone-----'+objLead.Channel_Partner__r.Recordtype.DeveloperName);
            if(strTemplateName.containsIgnoreCase('Appointment Successful')){
                if(String.IsNotBlank(objLead.Channel_Partner__r.Phone__c) && objLead.Channel_Partner__r.Recordtype.DeveloperName.equalsIgnoreCase('Ambassador')){
                    SendSMSMsg91(strMSGContent,objLead.Channel_Partner__r.Phone__c,objLead.id,strTemplateName,objSMSTemplate.Template_ID__c);
                }
            }else{
                SendSMSMsg91(strMSGContent,objLead.Phone,objLead.id,strTemplateName, objSMSTemplate.Template_ID__c);
            }
            // return strId;
        }catch(Exception exp){
            system.debug('--------exp-----'+exp.getMessage());
            system.debug('--------exp stack trackMessage-----'+exp.getStackTraceString());
            String strMsg = 'This is to Inform you that there is error '+exp.getMessage()+' occured when system is sending the SMS to Lead '+strLeadId+'.Please do the needful.';
            Logger.log('Exception','SendSMSController','GetSMSTemplate',strLeadId,exp.getMessage()+ ' '+ exp.getStackTraceString(),strTemplateName);
            // SendEmailToManager(strMsg);
            //  return null;
        }
    }
    
    /*  @future(callout=true)
public Static void SendSMS(String strContant,String strPhone){
strContant = EncodingUtil.urlEncode(strContant,'UTF-8');
httpRequest objReq = new httpRequest();
http objHttp = new http();
String strUrl = 'http://api.msg91.com/api/sendhttp.php?sender=HOMLNE&authkey=193741AbnQDVTh3K9X5a603b1d&mobiles='+strPhone+'&route=4&country=0&message='+strContant;
objReq.setEndPoint(strUrl);
objReq.setMethod('GET');
httpResponse objRes = new httpResponse();
if(!Test.IsRunningTest())
objRes = objHttp.send(objReq);
else
objRes.setStatusCode(101);
system.debug('-----objRes---'+objRes.getBody());
Map<Integer,String> mapErrorMsg = new Map<Integer,String>();
mapErrorMsg.put(101,'Missing mobile no.');
mapErrorMsg.put(102,'Missing message.');
mapErrorMsg.put(103,'Missing sender ID.');
mapErrorMsg.put(105,'Missing password.');
mapErrorMsg.put(106,'Missing Authentication Key.');
mapErrorMsg.put(107,'Missing Route.');
mapErrorMsg.put(202,'Invalid mobile number. You must have entered either less than 10 digits or there is an alphabetic character in the mobile number field in API.');
mapErrorMsg.put(203,'Invalid sender ID. Your sender ID must be 6 characters, alphabetic.');
mapErrorMsg.put(207,'Invalid authentication key. Crosscheck your authentication key from your account’s API section.');
mapErrorMsg.put(208,'IP is blacklisted. We are getting SMS submission requests other than your whitelisted IP list.');
mapErrorMsg.put(301,'Insufficient balance to send SMS.');
mapErrorMsg.put(302,'Expired user account. You need to contact your account manager.');
mapErrorMsg.put(303,'Banned user account.');
mapErrorMsg.put(306,'This route is currently unavailable. You can send SMS from this route only between 9 AM - 9 PM.');
mapErrorMsg.put(307,'Incorrect scheduled time.');
mapErrorMsg.put(308,'Campaign name cannot be greater than 32 characters.');
mapErrorMsg.put(309,'Selected group(s) does not belong to you.');
mapErrorMsg.put(310,'SMS is too long. System paused this request automatically.');
mapErrorMsg.put(311,'Request discarded because same request was generated twice within 10 seconds.');
if(objRes.getStatusCode() != 200){
String strMsg = 'This is to Inform you that there is error '+mapErrorMsg.get(objRes.getStatusCode())+' occured when system is sending the SMS to Customer phone '+strPhone+'.Please do the needfull.';
SendEmailToManager(strMsg);
}
}  */
    
    /*@future(callout=true)
    public Static void SendSMS(String strContant,String strPhone,String objLeadId,String smsType,String templateId){
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
            
            lead newLead = [Select id,Name,Description__c from Lead where id=:objLeadId limit 1];    
            newLead.id = objLeadId;
            if(objRes.getStatusCode() != 200){
                if(String.isNotBlank(objLeadId) && String.isNotBlank(smsType)){
                    
                    system.debug('++++newLead.Description++'+newLead.Description);
                    if(newLead.Description__c == null){
                        newLead.Description__c = smsType + ' - SMS Failed - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']';
                        system.debug('++++newLead.Description++'+newLead.Description);
                    }
                    else {
                        newLead.Description__c = smsType +' - SMS Failed - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']'+'\n'+newLead.Description__c; 
                        system.debug('++++newLead.Description++'+newLead.Description);
                    }
                    update newLead;
                }  
                String strMsg = 'This is to Inform you that there is error '+objRes.getStatusCode()+' occured '+objRes+' when system is sending the SMS to Customer phone '+strPhone+'.Please do the needful.';
                SendEmailToManager(strMsg);
            }
            else if(objRes.getStatusCode() == 200){
                system.debug('++++newLead.Description++'+newLead.Description);
                if(String.isNotBlank(objLeadId) && String.isNotBlank(smsType)){
                    
                    //newLead.id = objLeadId;
                    system.debug('++++newLead.Description++'+newLead.Description);
                    if(newLead.Description__c == null){
                        
                        newLead.Description__c = smsType + ' - SMS Sent - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']';
                        system.debug('++++newLead.Description++'+newLead.Description);
                    }
                    else {
                        newLead.Description__c = smsType + ' -  SMS Sent - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']'+'\n'+newLead.Description__c;
                        system.debug('++++newLead.Description++'+newLead.Description);
                    }
                    update newLead;
                    system.debug('++++newLead.Description++'+newLead.Description);
                }  
            }
        }
        catch(Exception e){
            System.debug('Exception :'+e.getStackTraceString());
        }
    }  
*/
    
    @future(callout=true)
    public Static void SendSMSMsg91(String strContant,String strPhone,String objLeadId,String smsType,String templateId){
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
            
            MSG91SMSRequestWrapper requestWrapper = new MSG91SMSRequestWrapper();
            requestWrapper.sender = integrationDetail.client_Id__c;
            requestWrapper.route = '4';
            requestWrapper.country = '91';
            requestWrapper.DLT_TE_ID = templateId;
            
            SMSWrapper smsWrapper = new SMSWrapper();
            smsWrapper.message = strContant;
            List<String> toNumbers = new List<String>{strPhone};
            smsWrapper.to = toNumbers;
            
            List<SMSWrapper> listOfSMSWrapper = new List<SMSWrapper>{smsWrapper};
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
            
            lead newLead = [Select id,Name,Description__c from Lead where id=:objLeadId limit 1];    
            newLead.id = objLeadId;
            if(objRes.getStatusCode() != 200){
                if(String.isNotBlank(objLeadId) && String.isNotBlank(smsType)){
                    
                    system.debug('++++newLead.Description++'+newLead.Description);
                    if(newLead.Description__c == null){
                        newLead.Description__c = smsType + ' - SMS Failed - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']';
                        system.debug('++++newLead.Description++'+newLead.Description);
                    }
                    else {
                        newLead.Description__c = smsType +' - SMS Failed - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']'+'\n'+newLead.Description__c; 
                        system.debug('++++newLead.Description++'+newLead.Description);
                    }
                    update newLead;
                }  
                String strMsg = 'This is to Inform you that there is error '+objRes.getStatusCode()+' occured '+objRes+' when system is sending the SMS to Customer phone '+strPhone+'.Please do the needful.';
                SendEmailToManager(strMsg);
            }
            else if(objRes.getStatusCode() == 200){
                system.debug('++++newLead.Description++'+newLead.Description);
                if(String.isNotBlank(objLeadId) && String.isNotBlank(smsType)){
                    
                    //newLead.id = objLeadId;
                    system.debug('++++newLead.Description++'+newLead.Description);
                    if(newLead.Description__c == null){
                        
                        newLead.Description__c = smsType + ' - SMS Sent - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']';
                        system.debug('++++newLead.Description++'+newLead.Description);
                    }
                    else {
                        newLead.Description__c = smsType + ' -  SMS Sent - ['+String.valueOf(System.Now().format('dd/MM/yyyy\' \'HH:mm'))+']'+'\n'+newLead.Description__c;
                        system.debug('++++newLead.Description++'+newLead.Description);
                    }
                    update newLead;
                    system.debug('++++newLead.Description++'+newLead.Description);
                }  
            }
        }
        catch(Exception e){
            System.debug('Exception :'+e.getStackTraceString());
            Logger.log('Exception','SendSMSController','SendSMSMsg91',objLeadId,e.getMessage()+ ' '+ e.getStackTraceString(),smsType);
        }
    }
    
    public Static void SendEmailToManager(String errMsg){
        String[] strUserEmail = new List<String>();
        if(!Test.isRunningTest()){Exception_Mail__c objAmeyo = Exception_Mail__c.getValues('SF Lead Mail');strUserEmail = objAmeyo.Email_Addresss__c.split(',');
                                 }else{
                                     strUserEmail.add('testapi@gmail.com');
                                 }
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = strUserEmail ; 
        message.optOutPolicy = 'FILTER';
        message.subject = 'SMS API Failure';
        message.plainTextBody = errMsg;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
    
    Public class MSG91SMSRequestWrapper{
        Public String sender{get;set;}
        Public String route{get;set;}
        Public String DLT_TE_ID{get;set;}
        Public String country{get;set;}
        Public List<SMSWrapper> sms{get;set;} 
    }
    Public class SMSWrapper{
        Public String message{get;set;}
        Public List<String> to{get;set;}
    }
    
}