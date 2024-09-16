global class Rest_ChangeCustomerEmail {
    @future(callout=true)
    Public static void customeremailChange(Map<String,String> mapOldNewEmail){
        List<SendJsonWrapper> jsonWrapper = new List<SendJsonWrapper>();
        String finalJSON = null;
        if(!mapOldNewEmail.isEmpty()){
            for(String oldEmail : mapOldNewEmail.keySet()){
                Http http = new Http();
                HttpRequest Req = new HttpRequest();
                HttpResponse Res = new HttpResponse();
                Req.setMethod('GET');
                String endPoint = Label.IQAPIURL+'customeremail/update/?oldemail='+oldEmail+'&newemail='+mapOldNewEmail.get(oldEmail);
                Req.setEndpoint(endPoint);
                system.debug('Req --------------------------------'+Req);
                Res = http.send(Req);
                Logger.log('LOG','Changecustomeremail class','customeremailChange method','OLD EMAIL'+oldEmail+'New EMAIL'+mapOldNewEmail.get(oldEmail),endPoint,null);
                system.debug('Res --------------------------------'+Res);
                Map<String,Object> mapResponse = (Map<String, Object>)JSON.deserializeUntyped(Res.getBody());
                if((String) mapResponse.get('status') == 'error'){
                    SendEmailToManager(mapOldNewEmail.get(oldEmail),oldEmail,mapResponse);
                }
            }
        }
    
    }
      global Static void SendEmailToManager(String newEmail,String oldEmail ,Map<String,Object> Response){
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.toAddresses = new String[] {'sachin.k@kvpcorp.com','akhilesh.s@homelane.com','rohit.b@homelane.com'}; 
                            message.optOutPolicy = 'FILTER';
                            message.subject = 'Customer Email Change Issue Change Issue';
                            message.plainTextBody = 'Salesforce - This is to inform you that Opportunity with New Email ='+oldEmail+' is not updated on IQ With New Email '+newEmail+' ,Because we got the following error-'+(String) Response.get('message')+'. Please do the needful';
                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
    public class SendJsonWrapper{
        public String newcustomeremail;
        public String oldcustomeremail;
    }
}