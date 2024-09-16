global class WhatsappTrigger {
    
    
    /* Invoked Throught the Button on opportunity  */
    Webservice static void SendNPS(String OpportunityID) {
        
        if(label.WhatsApp_NPS.equalsIgnoreCase('True')){
            String nowTime = System.Now().format('dd/MM/yyyy\' \'HH:mm');
            List<Whatsapp_Message__c> insertwhatsapp = new List<Whatsapp_Message__c>();
            list<Opportunity>  lstOpporunity = new list<Opportunity> ();
            if(String.isNotBlank(OpportunityID)){
                lstOpporunity = [Select Name,id,Customer_ID__c,Whatsapp_Opt_in__c,Customer_Phone_Number__c from Opportunity where id =:OpportunityID];
                System.debug('++++lstOpporunity+++'+lstOpporunity);
                if(lstOpporunity!= NULL && !lstOpporunity.isEmpty()){
                    if(lstOpporunity[0].Whatsapp_Opt_in__c == true && String.isNotBlank(lstOpporunity[0].Customer_Phone_Number__c)) {    
                        /*Whatsapp_Message__c w = new Whatsapp_Message__c();
                        w.Name = 'WA - NPS Request Sent'; 
                        w.Sent__c = System.now();
                        w.Opportunity__c = lstOpporunity[0].Id; */
                        String body = '{"CampaignID": "88fb6dc1-e80f-4b49-97f2-9097e3b9e74f","To": {"PhoneNumber": "91'+lstOpporunity[0].Customer_Phone_Number__c+'"},"WhatsAppCampaignParameters": {"LocalizableParams": [{"Default": "'+lstOpporunity[0].Name+'"}]}}';
                        /* String body = 'method='+EncodingUtil.urlEncode('wa', 'UTF-8')+
                        '&api_key='+EncodingUtil.urlEncode('A0de77e7eddabb9fdc5c92599bb19cfc3', 'UTF-8')+
                        '&body='+EncodingUtil.urlEncode('{ "to": "91'+lstOpporunity[0].Customer_Phone_Number__c+'","type": "template","template": {"namespace": "6c5ee8f7_840c_de7e_6979_b2dfee5b6e8b","template_name": "feedback_2","policy": "deterministic","lang_code": "en","params": ["'+lstOpporunity[0].Name+'"],"ttl": "86400"},"callback": "http://example.com/callback?}"}', 'UTF-8')+
                        '&from='+EncodingUtil.urlEncode('919513664689', 'UTF-8')+
                        '&format='+EncodingUtil.urlEncode('json', 'UTF-8');*/
                        sendWhatsapp(lstOpporunity[0].Customer_Phone_Number__c,body,'Verloop API','opportunity',lstOpporunity[0].Id,'WA - NPS Request Sent');
                        //Commennted because whatsapp message record will be inserted after successfully sending the whatapp message in the call out method.
                        //insertwhatsapp.add(w);
                    }
                }
            }   
            
            system.debug('insertwhatsapp'+insertwhatsapp);
            if(!insertwhatsapp.isEmpty()){
                insert insertwhatsapp; 
            }  
        }
    }
    
    
    /*
Name: whatsappQuote
Description : Sends whatsapp msg to user the Condition are met from Quote Trigger
TinyUrl Will be generated from Website
*/
    public static void whatsappQuote(List<Quote> quoteList, Map<Id,Quote> oldMap) {
        system.debug('label.WhatsApp_Quotes'+label.WhatsApp_Quotes);
        if(label.WhatsApp_Quotes.equalsIgnoreCase('True')){
            Set<Id> newSet = new Set<Id>();
            List<Whatsapp_Message__c> insertwhatsapp = new List<Whatsapp_Message__c>();
            for(Quote q : quoteList) {
                if(q.OpportunityId != null)
                    newSet.add(q.OpportunityId);
            }
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([select id, name, Customer_Phone_Number__c, Whatsapp_Opt_in__c from Opportunity where id =: newSet]);
            for(Quote q : quoteList) {
                if(oldMap.get(q.Id).Published__c != q.Published__c && q.Published__c == 'Yes' && oppMap.get(q.OpportunityId).Whatsapp_Opt_in__c == true) {
                    //Commennted because whatsapp message record will be inserted after successfully sending the whatapp message in the call out method.
                    /*Whatsapp_Message__c w = new Whatsapp_Message__c();
                    w.Name = 'WA - Quote'; 
                    w.Sent__c = System.now();
                    w.Opportunity__c = oppMap.get(q.OpportunityId).Id;
                    insertwhatsapp.add(w);  */                             
                    WhatsappTinyURL what = new WhatsappTinyURL(oppMap.get(q.OpportunityId).Customer_Phone_Number__c, oppMap.get(q.OpportunityId).name, q.projectId__c, String.valueOf(q.version__c), String.valueOf(oppMap.get(q.OpportunityId).Id));
                    String jobID = System.enqueueJob(what);
                    
                    System.debug('+++jobID+++'+jobID);
                    
                }
            }       
            if(!insertwhatsapp.isEmpty())
                insert insertwhatsapp;
        } 
    }  
    
    @Future(callout=true)
    global static void sendWhatsapp(String phone,String body,String objIntName,String objectName,String relatedRecordId,String whatsappName) {
        try{
            if(!String.isBlank(body) && !String.isBlank(objIntName) && !String.isBlank(objectName) && !String.isBlank(relatedRecordId) && !String.isBlank(whatsappName)){
                HTTP http = new HTTP();
                HTTPRequest req = new HTTPRequest();
                Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                Integration_Setting__c integrationDetail = allEndPoint.get(objIntName); 
                System.debug('BODY:  '+body);
                if(integrationDetail != NULL){
                    req.setMethod('POST');
                    req.setHeader('Content-Type',integrationDetail.ContentType__c);
                    req.setHeader('id',integrationDetail.Authorization__c);
                    req.setEndPoint(integrationDetail.End_Point__c);
                    req.setBody(body);
                    HTTPResponse res = http.send(req);
                    System.debug('HTTPResponse  '+res);
                    System.debug('HTTPResponse GETBODY '+res.getbody());
                    System.debug('HTTPResponse GET status '+res.getStatus());
                    System.debug('HTTPResponse GET status code'+res.getStatusCode());
                    if(res.getStatusCode()==200){
                        Whatsapp_Message__c w = new Whatsapp_Message__c();
                        w.Name = whatsappName; 
                        w.Sent__c = System.now();
                        if(objectName.equalsIgnoreCase('lead')){
                            w.Lead__c = relatedRecordId;
                        }
                        else if(objectName.equalsIgnoreCase('opportunity')){
                            w.Opportunity__c = relatedRecordId;
                        }
                        else{
                            System.debug('Error in creating Whatsapp message record. Object name is neither lead nor opportunity. Object Name: '+objectName);
                            Logger.log('Error','WhatsappTrigger Class','sendWhatsapp Method','','Error in creating Whatsapp message record. Object name is neither lead nor opportunity. Object Name: '+objectName,relatedRecordId);
                        }
                        if(w.Lead__c !=null || w.Opportunity__c !=null){
                            insert w;
                        }
                    }
                    else{
                        System.debug('Whatsapp Message Status code error. Status Code: '+res.getStatusCode()+ ' . Response Body: '+res.getBody());
                        Logger.log('Error','WhatsappTrigger Class','sendWhatsapp Method','Status Error','Status code: '+String.ValueOf(res.getStatusCode())+ ' . Response Body: '+res.getBody(),relatedRecordId);
                    }
                }
            }
            else{
                System.debug('Some parameter is empty to the sendWhatsapp method');
                Logger.log('Error','WhatsappTrigger Class','sendWhatsapp Method','Method parameter error','Some parameter is empty to the sendWhatsapp method','related record Id: '+relatedRecordId+' . Pnone: '+phone);
            }
        }
        catch(Exception e){
            System.debug('Exception : '+e.getMessage());
            System.debug('Exception stack trace: '+e.getStackTraceString());
            Logger.log('Exception','WhatsappTrigger Class','sendWhatsapp Method',e.getMessage(),e.getStackTraceString(),relatedRecordId);
        }       
    }
    
    @Future(callout=true)
    global static void sendWhatsapp1(String phone) {}
    
}