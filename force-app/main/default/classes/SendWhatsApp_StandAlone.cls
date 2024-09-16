Public Class SendWhatsApp_StandAlone{
    public Static void sendMessage(List<Lead> lstLead){
       List<Whatsapp_Message__c> insertwhatsapp = new List<Whatsapp_Message__c>();
        if(lstLead != NULL && !lstLead.isEmpty()){
            for(lead l :lstLead){
                try{
                    if(l.Whatsapp_Opt_in__c){
                        if(l.Phone != NULL){
                            Whatsapp_Message__c w = new Whatsapp_Message__c();
                            w.Name = 'WA - Offer Message JULY-19'; 
                            w.Sent__c = System.now();
                            w.Lead__c = l.Id;
                            insertwhatsapp.add(w);
                            String body = '{"CampaignID": "c2d76038-39cf-4b8c-af55-35a026bd06c8","To": {"PhoneNumber": ["91'+l.Phone+'"]},"WhatsAppCampaignParameters": {"LocalizableParams": [{"Default": "'+l.Name+'"},{"Default": "10"}]}}';
                             System.enqueueJob(new SendBulkWhatsApp(l.Phone,body,'Verloop API'));
                            
                        }
                    }    
                }
                catch(Exception e){
                    Logger.log('Exception','SendWhatsApp_StandAlone','sendMessage',e.getMessage(),e.getStackTraceString(),NULL);
                }  
            }
        }
        if(insertwhatsapp != NULL && !insertwhatsapp.isEmpty()){
            insert insertwhatsapp;
        }
    }

 /*   @Future(callout=true)
    public static void sendWhatsapp(String phone,String body,String objIntName){
        try{
            HTTP http = new HTTP();
            HTTPRequest req = new HTTPRequest();
            Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
            Integration_Setting__c integrationDetail = allEndPoint.get(objIntName); 
            System.debug('BODY:  '+body);
            if(integrationDetail != NULL){
                req.setMethod('POST');
                req.setHeader('Content-Type',integrationDetail.ContentType__c);
                req.setEndPoint(integrationDetail.End_Point__c);
                req.setBody(body);
                HTTPResponse res = http.send(req);
                System.debug('HTTPResponse  '+res);
                System.debug('HTTPResponse GETBODY '+res.getbody());   
            }  
        }       
        catch(Exception e){
            Logger.log('Exception','SendWhatsApp_StandAlone','sendWhatsapp','Error in sending WhatsApp Record',body,NULL);
        }  
    }*/
}