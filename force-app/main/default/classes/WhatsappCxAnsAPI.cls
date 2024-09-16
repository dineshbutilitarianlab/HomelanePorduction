@RestResource(urlMapping='/WhatsappCxAnsAPI/*')
global class WhatsappCxAnsAPI {
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
            
            Id leadId = (Id)json_input.get('leadId');
            String l = 'select id, name, Description__c, City, Phone from lead where id =:leadId';
            Lead myLead = Database.query(l);
            system.debug('******myLead *******  '+myLead );
            String nowTime = System.Now().format('dd/MM/yyyy\' \'HH:mm');           
             
            String respMsg = (String)json_input.get('response_msg');
            String respName;
            if(respMsg == 'call')
            respName = 'WA - Unable to Contact';
            
            Whatsapp_Message__c whats = new Whatsapp_Message__c();
            String whatstr = 'select id, name, Call_Back_Request__c, Delivered__c, Read__c, Responded__c, Responded_First_Time__c, Responded_Last_Time__c, Response_Msg__c, Sent__c from Whatsapp_Message__c where Lead__c =: leadId and name = \''+respName+'\' order by createdDate desc  limit 1 ';
            System.debug('======whatstr===='+whatstr);
            whats = database.query(whatstr);
            system.debug('******whats*******  '+whats);   
            
            if(myLead != null) {
                if(myLead.Description__c == null)
                myLead.Description__c = 'Call back request was made on ['+nowTime+'] stamp';
                else 
                myLead.Description__c = 'Call back request was made on ['+nowTime+'] stamp'+'\n'+myLead.Description__c;
                
                List<Lead> lstOzoneLead = new List<Lead>();
                lstOzoneLead.add(myLead);
                LeadPushToOzoneCityQueue objLPA = new LeadPushToOzoneCityQueue(lstOzoneLead,UserInfo.getSessionId(),whats.Id);
                ID jobID = System.enqueueJob(objLPA);
                system.debug('-----jobID----'+jobID);                              
                update myLead; 
            }          
            
            if(whats != null) {
                if((String)json_input.get('within_business_hours') == 'false')
                whats.Call_Back_Request__c = 'Outside Business Hours';
                else if((String)json_input.get('within_business_hours') == 'true')
                whats.Call_Back_Request__c = 'Inside Business Hours';      
                whats.Responded__c = 'Yes';
                whats.Response_Msg__c = respMsg;
                if(whats.Responded_First_Time__c == null)
                whats.Responded_First_Time__c = System.now();
                whats.Responded_Last_Time__c = System.now();    
                update whats;         
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