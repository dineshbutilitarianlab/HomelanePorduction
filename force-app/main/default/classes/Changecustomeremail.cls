global class Changecustomeremail {
    @future(callout=true)
    webservice static void customeremailChange(list<String> newcustomeremail, list<String> oldcustomeremail){
        system.debug('newcustomeremail ---------------->'+newcustomeremail);
        system.debug('oldcustomeremail ---------------->'+oldcustomeremail);
        List<SendJsonWrapper> jsonWrapper = new List<SendJsonWrapper>();
        String finalJSON = null;
        if(!newcustomeremail.isEmpty() && !oldcustomeremail.isEmpty() ){
            SendJsonWrapper jeson = new SendJsonWrapper();
            jeson.oldcustomeremail= newcustomeremail[0];
            jeson.newcustomeremail= oldcustomeremail[0];
            system.debug('json -------------'+jeson);
             
            Http pro = new Http();
            HttpRequest Req = new HttpRequest();
             Req.setMethod('GET');
            HttpResponse Res = new HttpResponse();
            String endPoint = Label.IQAPIURL+'customeremail/update/?oldemail='+oldcustomeremail[0]+'&newemail='+newcustomeremail[0];
            finalJSON = JSON.serialize(jeson);
            System.debug('SF final json------------------> '+finalJson);
            Req.setEndpoint(endPoint);
            String testjson = 'oldemail='+oldcustomeremail[0]+'&newemail='+newcustomeremail[0];
            system.debug('testjson --------------------------------'+testjson);
            system.debug('Req ------------------->'+Req);
            Res.setHeader('Content-Type', 'application/json');
            Res = pro.send(Req);
            Logger.log('LOG','Changecustomeremail class','customeremailChange method','OLD EMAIL'+oldcustomeremail[0]+'New EMAIL'+newcustomeremail[0],finalJSON,null);
            system.debug('Res --------------------------------'+Res);
            Map<String,Object> mapResponse = (Map<String, Object>)JSON.deserializeUntyped(Res.getBody());
            if((String) mapResponse.get('status') == 'error'){
                SendEmailToManager(newcustomeremail[0],oldcustomeremail[0],mapResponse);
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