global class SendFeedBackToRoasterAPI {
 public static boolean firstRun = true;
    @future(callout=true)
    webservice static void SendToRoaster(String OpportunityOrderID){
        
        System.debug('OpportunityOrderID VALUE COMING---->'+OpportunityOrderID);
       
       
            Http pro = new Http();
            HttpRequest Req = new HttpRequest();
            HttpResponse Res = new HttpResponse();
            String strEndPoint = Label.RosterUrl+'contract/update_nps_data_to_roster';
            Req.setEndpoint(strEndPoint);
            Req.setMethod('POST');
            //Req.setBody(finalJson);
           /* String testjson = 'newdesigneremail='+newdesigneremail[0]+'&designeremail='+designeremail[0];
            system.debug('testjson --------------------------------'+testjson);*/
            
            Req.setBody('OpportunityOrderID='+OpportunityOrderID);
            Req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
             if (firstRun) {
           System.debug('---------  FIRST RUN  2 '+firstRun);
            firstRun = false;     
            System.debug('---------  FIRST RUN  3 '+firstRun); 
            Res = pro.send(Req);         
           }
           else {
           System.debug('---------  FIRST RUN  4 '+firstRun);
           System.debug('Already ran!');
    return;
           }
            
            System.debug('Res status is='+Res.getBody()+'==>'+Res.getStatus()+'==>'+Res.getStatusCode());
            Map<String,Object> mapResponse = (Map<String, Object>)JSON.deserializeUntyped(Res.getBody());
            System.debug('Map ***  '+mapResponse);
            
           
            if((boolean) mapResponse.get('error') == true){
                //SendEmailToManager(OpportunityOrderID,mapResponse,strEndPoint);
                System.debug('Error	');
            }
            
            
            
        }

         @future(callout=true)
    webservice static void SendDPIncentive(String customeremail,String dpEmail,String meetingDate,String amount){
        System.debug('customeremail VALUE COMING---->'+customeremail+'----dpEmail----'+dpEmail+'---meetingDate----'+meetingDate+'----amount----'+amount);
              
            Http pro = new Http();
            HttpRequest Req = new HttpRequest();
            HttpResponse Res = new HttpResponse();
            String strEndPoint = Label.RosterUrl+'apis/dp_payment/update_scvm_details';
            Req.setEndpoint(strEndPoint);
            Req.setMethod('POST');
            //Req.setBody(finalJson);
           // String testjson = 'newdesigneremail='+newdesigneremail[0]+'&designeremail='+designeremail[0];
            //system.debug('testjson --------------------------------'+testjson);
            Req.setBody('customer_email='+customeremail+'&dp_email='+dpEmail+'&meeting_date='+meetingDate+'&amount='+amount);
            Req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            system.debug('Req --------------------------------'+Req);
             system.debug('Req body --------------------------------'+Req.getBody());
            Res = pro.send(Req);
            System.debug('Res status is='+Res.getBody()+'==>'+Res.getStatus()+'==>'+Res.getStatusCode());
            Map<String,Object> mapResponse = (Map<String, Object>)JSON.deserializeUntyped(Res.getBody());
            System.debug('THE MAP IS '+mapResponse );
            if((String) mapResponse.get('message') == 'failure'){
                SendEmailToManager(customeremail,mapResponse,strEndPoint);
            }
        }
    
      global Static void SendEmailToManager(String OpportunityOrderID ,Map<String,Object> Response, String strAPIName){
        String[] strUserEmail = new List<String>();
                 if(!Test.isRunningTest()){Exception_Mail__c objAmeyo = Exception_Mail__c.getValues('Roster Mail');strUserEmail = objAmeyo.Email_Addresss__c.split(',');
                 }else{
                  strUserEmail.add('testapi@gmail.com');
                 }
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.toAddresses = strUserEmail; 
                            message.optOutPolicy = 'FILTER';
                            message.subject = 'Roster API Issue ';
                            message.plainTextBody = 'Salesforce - This is to inform you that Customer with the OpportunityOrderID ='+OpportunityOrderID+' is not updated on Roaster,Because we got the following error-'+(String) Response.get('message')+' and response is : '+Response.get('response')+' on API- '+strAPIName+' . Please do the needful';
                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
    public class SendJsonWrapper{
        public String customeremail;
    }
}