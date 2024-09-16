@RestResource(urlMapping='/WhatsappQuoteAPI/*')
global class WhatsappQuoteAPI{
    @HTTPPost
    global static void leadPush() {
        ResponseWrapper wrapper = new ResponseWrapper();
        try {
            RestRequest req = RestContext.request;
            system.debug('******req *******  '+req);
            String input = req.requestBody.toString();
            system.debug('******input *******  '+input );
            Map<String,Object> json_input = (Map<String,Object>)JSON.deserializeUntyped(input);
            system.debug('******json_input*******  '+json_input);
           
            Id oppId = (Id)json_input.get('oppId');
            String o = 'select id, name, DescriptionCopy__c from Opportunity where id =:oppId';
            Opportunity myOpp = Database.query(o);
            system.debug('******myOpp *******  '+myOpp );
            String nowTime = System.Now().format('dd/MM/yyyy\' \'HH:mm');           
             
            String respMsg = (String)json_input.get('response_msg');
            String respName;
            if(respMsg == 'Count' )
            respName = 'WA - Quote';
            
            List<Whatsapp_Message__c> whats = new List<Whatsapp_Message__c>();
            whats = [select id, name, Quote_Link_Click__c,Call_Back_Request__c,Quote_WA_Message__c, Delivered__c, Read__c, Responded__c, Responded_First_Time__c, Responded_Last_Time__c, Response_Msg__c, Sent__c from Whatsapp_Message__c where Opportunity__c =: oppId and name = :respName  order by createdDate desc limit 1];
            system.debug('******whats*******  '+whats);   
            
           /*if(respMsg == 'quote'){                    
                if(whats[0] != null) {
                    if((String)json_input.get('within_business_hours') == 'false')
                    whats[0].Call_Back_Request__c = 'Outside Business Hours';
                    else if((String)json_input.get('within_business_hours') == 'true')
                    whats[0].Call_Back_Request__c = 'Inside Business Hours';      
                    whats[0].Responded__c = 'Yes';
                    whats[0].Response_Msg__c = respMsg;
                    if(whats[0].Responded_First_Time__c == null)
                    whats[0].Responded_First_Time__c = System.now();
                    whats[0].Responded_Last_Time__c = System.now();    
                    update whats[0];         
                }
            }*/

            if(respMsg == 'Count'){  
                if(whats[0] != null) {
                    if(whats[0].Quote_Link_Click__c == null){ 
                        whats[0].Quote_Link_Click__c = 1;
                    }    
                    else{
                        whats[0].Quote_Link_Click__c++;   
                    }
                    if(whats[0].Quote_WA_Message__c == null) {
                        whats[0].Quote_WA_Message__c = nowTime;
                    }
                    else{
                        whats[0].Quote_WA_Message__c = nowTime+'\n'+whats[0].Quote_WA_Message__c; 
                    }                  
                    update whats[0];
                }
            }
            
            wrapper.status_code = '201';
            wrapper.message = 'Success';
        }
         catch(Exception e) {
            
            wrapper.status_code = '501';
            wrapper.message = 'Failure';
        }
        
        String json = json.serialize(wrapper);
        RestContext.response.addHeader('Content-Type','application/json');
        RestContext.response.responseBody = Blob.valueOf(json);
    }
    
     global class ResponseWrapper {
        String status_code;
        String message;
    }
}