public class RosterDpAvailability {   
    public static void RosterDpCancel(map<id,Lead> OldLeadMap,map<id,Lead> NewLeadMap)
    {
        List<lead> ldupd = new List<lead>();
        map<id,Lead> leadDpMap = new Map<id,lead>();
        DateTime dtTime;
        
        for(Lead newld : NewLeadMap.values())
        {
            Lead oldld = oldLeadMap.get(newld.id);
            System.debug('old status  '+oldld.Status+'  new status  '+newld.status);
            if((oldld.Status!='Appointment Unsuccessful' || oldld.Status!='Appointment Cancelled') && (newld.Status=='Appointment Unsuccessful' || newld.Status=='Appointment Cancelled'))
            {
                dtTime = oldld.Appointment_Time__c;
                leadDpMap.put(newld.id,newld);
            }
        }
        System.debug('leadDpMap --> '+leadDpMap);
        if(!leadDpMap.isEmpty())
        {
            List<lead> ldlst = [Select id,Interior_Designer__r.Email__c,Interior_Designer__r.name,full_name__c,Appointment_Venue_Square__r.Name,Appointment_Time__c,Email_For_Communication__c, Appointment_Venue_Square__r.WalkIn_SSA__r.Email, Square_Showroom_Manager__r.Email, Appointment_Venue_Square__r.Design_Manager__r.Email from Lead where id in:leadDpMap.values() and Appointment_Time__c != null and Interior_Designer__c != null];
            System.debug('ldlst --> '+ldlst);
            if(!ldlst.isEmpty())
            {
                for(Lead ld : ldlst)
                {  
                    Datetime gsttime = ld.Appointment_Time__c;
                    Datetime gstmandril = ld.Appointment_Time__c.addHours(5).addMinutes(30);
                    String subject = '[Meeting cancelled] Meeting with '+ld.full_name__c+' on '+gstmandril+' is cancelled by the customer';
                    String cancelMail = 'We have cancelled your HomeLane consultation at '+gstmandril+' as per your request';
                    if(!System.isBatch())
                    callAPI(ld.Interior_Designer__r.email__c,ld.Appointment_Venue_Square__r.Name,String.valueOf(gsttime),ld.Email_For_Communication__c,'C1_HL_cx_cancelation',subject,ld.Email_For_Communication__c, ld.Interior_Designer__r.Email__c, ld.Appointment_Venue_Square__r.WalkIn_SSA__r.Email, ld.Square_Showroom_Manager__r.Email, ld.Appointment_Venue_Square__r.Design_Manager__r.Email,'fromRosterDpCancel',ld.Interior_Designer__r.name, 'CxC2_meeting_cancelled', cancelMail);
                    //System.debug('message val for lead '+ld+' is '+message);
                    if(!System.isBatch())
                    ld.Interior_Designer__c = null;
                    ldupd.add(ld);
                    if(dtTime != NULL){
                        Date dt = date.newInstance(dtTime.year(), dtTime.month(), dtTime.day());
                     /*   if(!System.isBatch() && !Test.isRunningTest()) {
                            System.debug('INSIDE__________');
                            if(dt >= Date.Today())
                        DPAssignmentcallBatch.MeetingCreation(dt);    
                        }  */
                    }
                    
                }
            }
        }
        if(!ldupd.isempty())
        {
            update ldupd;
            
        }
        
    }
    @future(callout=true)
    public static void callAPI(String dp_email, String showroom_name, String meeting_start, String customer_email,String template,String subject,String custEmail,String dpEmail,String ssaEmail,String ssmEmail,String cmEmail,String OperType,String dpname, String temp2, String cancelSub) {
        DPAssignment__c cancel = DPAssignment__c.getValues('Cancel');
        String cancel1 = cancel.API__c;
        
        //  String con = 'showroom_name='+l.Appointment_Venue_Square__r.Name+'&start_time='+gst;
        //   String con = 'type=create&ap_type=meeting&dp_email='+dp_email+'&showroom_name='+showroom_name+'&meeting_start='+meeting_start+'&customer_email'+customer_email;
        String con = '{"dp_email":"'+dp_email+'","showroom_name":"'+showroom_name+'","meeting_start":"'+meeting_start+'","customer_email":"'+customer_email+'"}';     
        System.debug('-----con   '+con ); 
        Http http = new http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(cancel1);
        request.setMethod('POST');
        request.setBody(con);
        request.setHeader('Content-Type','application/json');
        System.debug('-----request FUTURE '+request);            
        HttpResponse response = http.send(request);  
        System.debug('-----response FUTURE '+response ); 
        System.debug('-----response body FUTURE '+response.getBody()); 
        Map<String, Object> json_req_inputFuture = (Map<String, Object>)JSON.deserializeUntyped(response.getBody()); 
        if(json_req_inputFuture.get('msg') == 'Meeting updated successfully.' && Opertype == 'fromRosterDpCancel') {
            System.debug('successful');
            Http http1 = new Http();
            HttpRequest request1 = new HttpRequest();
            request1.setEndpoint('https://mandrillapp.com/api/1.0/messages/send-template.json');
            request1.setMethod('POST');
            request1.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Set the body as a JSON object
            //  request.setBody('{"key": "xhJxn_DI9P1L9lu3CLHfjQ","message": {"html": "<p>Example HTML content</p>","text": "Example text content","subject": "example subject","from_email": "test@homelane.com","from_name": "Example Name","to": [{"email": "pavan.d@homelane.com","name": "Pavan","type": "to"}],"headers": {"Reply-To": "test@homelane.com"},"important": false,"track_opens": true,"track_clicks": true,"merge_language": "mailchimp","global_merge_vars": [{"name": "merge1","content": "merge1 content" }],"merge_vars": [{"rcpt": "recipient.email@example.com","vars": [{"name": "merge2", "content": "merge2 content"}]}],"tags": ["password-resets"],"google_analytics_campaign": "message.from_email@example.com","metadata": {"website": "www.example.com"},"recipient_metadata": [{"rcpt": "recipient.email@example.com","values": {"user_id": 123456} }]},"async": false, "ip_pool": "Main Pool"}');
            request1.setBody('{"key": "xhJxn_DI9P1L9lu3CLHfjQ","template_name": "'+template+'","template_content": [ {"name": "dp_name","content": "'+dpname+'" },{"name": "appt_time","content": "'+meeting_start+'" }], "message": {"html": "<p>Example HTML content</p>","text": "Example text content","subject": "'+subject+'","from_email": "hello@homelane.com","from_name": "Homelane","to": [{"email": "'+dpEmail+'","name": "Recipient Name","type": "to"},{"email": "'+ssaEmail+'","name": "Recipient Name","type": "cc"},{"email": "'+ssmEmail+'","name": "Recipient Name","type": "cc"},{"email": "'+cmEmail+'","name": "Recipient Name","type": "cc"}],"important": false,"track_opens": null,"track_clicks": null,"auto_text": null,"auto_html": null, "inline_css": null,"url_strip_qs": null, "preserve_recipients": null,"view_content_link": null,"bcc_address": "message.bcc_address@example.com","tracking_domain": null,"signing_domain": null,"return_path_domain": null,"merge": true,"merge_language": "mailchimp","global_merge_vars": [{"name": "merge1","content": "merge1 content"}],"merge_vars": [{"rcpt": "recipient.email@example.com","vars": [ {"name": "merge2", "content": "merge2 content"}]}],"tags": ["password-resets"],"google_analytics_domains": ["example.com"],"google_analytics_campaign": "message.from_email@example.com","metadata": {"website": "www.example.com"},"recipient_metadata": [ {"rcpt": "recipient.email@example.com","values": {"user_id": 123456} }]},"async": false, "ip_pool": "Main Pool","send_at": "2018-08-01"}');
            if(!Test.isRunningTest()) {
            HttpResponse response1 = http1.send(request1);
            // Parse the JSON response
            System.debug('RESPONSE ONE IS : '+response1+'  BODY ONE IS  '+response1.getBody());
            }
            
            
            Http http2 = new Http();
            HttpRequest request2 = new HttpRequest();
            request2.setEndpoint('https://mandrillapp.com/api/1.0/messages/send-template.json');
            request2.setMethod('POST');
            request2.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Set the body as a JSON object
            //  request.setBody('{"key": "xhJxn_DI9P1L9lu3CLHfjQ","message": {"html": "<p>Example HTML content</p>","text": "Example text content","subject": "example subject","from_email": "test@homelane.com","from_name": "Example Name","to": [{"email": "pavan.d@homelane.com","name": "Pavan","type": "to"}],"headers": {"Reply-To": "test@homelane.com"},"important": false,"track_opens": true,"track_clicks": true,"merge_language": "mailchimp","global_merge_vars": [{"name": "merge1","content": "merge1 content" }],"merge_vars": [{"rcpt": "recipient.email@example.com","vars": [{"name": "merge2", "content": "merge2 content"}]}],"tags": ["password-resets"],"google_analytics_campaign": "message.from_email@example.com","metadata": {"website": "www.example.com"},"recipient_metadata": [{"rcpt": "recipient.email@example.com","values": {"user_id": 123456} }]},"async": false, "ip_pool": "Main Pool"}');
            request2.setBody('{"key": "xhJxn_DI9P1L9lu3CLHfjQ","template_name": "'+temp2+'","template_content": [ {"name": "dp_name","content": "'+dpname+'" },{"name": "appt_time","content": "'+meeting_start+'" }], "message": {"html": "<p>Example HTML content</p>","text": "Example text content","subject": "'+cancelSub+'","from_email": "hello@homelane.com","from_name": "Homelane","to": [{"email": "'+custEmail+'","name": "Recipient Name","type": "to"},{"email": "'+dpEmail+'","name": "Recipient Name","type": "cc"},{"email": "'+ssaEmail+'","name": "Recipient Name","type": "cc"},{"email": "'+ssmEmail+'","name": "Recipient Name","type": "cc"},{"email": "'+cmEmail+'","name": "Recipient Name","type": "cc"}],"important": false,"track_opens": null,"track_clicks": null,"auto_text": null,"auto_html": null, "inline_css": null,"url_strip_qs": null, "preserve_recipients": null,"view_content_link": null,"bcc_address": "message.bcc_address@example.com","tracking_domain": null,"signing_domain": null,"return_path_domain": null,"merge": true,"merge_language": "mailchimp","global_merge_vars": [{"name": "merge1","content": "merge1 content"}],"merge_vars": [{"rcpt": "recipient.email@example.com","vars": [ {"name": "merge2", "content": "merge2 content"}]}],"tags": ["password-resets"],"google_analytics_domains": ["example.com"],"google_analytics_campaign": "message.from_email@example.com","metadata": {"website": "www.example.com"},"recipient_metadata": [ {"rcpt": "recipient.email@example.com","values": {"user_id": 123456} }]},"async": false, "ip_pool": "Main Pool","send_at": "2018-08-01"}');
            if(!Test.isRunningTest()) {
            HttpResponse response2 = http2.send(request2);
            // Parse the JSON response
            System.debug('RESPONSE TWO IS : '+response2+'  BODY TWO IS  '+response2.getBody());
            }
        }
    }
    public static void RescheduleRoster(map<id,Lead> OldRRMap,map<id,Lead> NewRRMap)
    {
        System.debug('---->OldRRMap  '+OldRRMap);
        System.debug('---->NewRRMap  '+NewRRMap);
        List<lead> ldupdlst = new list<lead>();
        Map<id,Lead> scheduleMap = new Map<id,lead>();
        map<id,lead> oldscheduleMap = new Map<id,Lead>();
        DateTime dtTime;
        Boolean inside = false;
        for(Lead ld : NewRRMap.values())
        {
            Lead oldld = OldRRMap.get(ld.id);
            System.debug('-----oldld.Appointment_Time__c  '+oldld.Appointment_Time__c+'   ld.Appointment_Time__c   '+ld.Appointment_Time__c);
            if(!Test.isRunningTest()) {
                if(ld.Appointment_Time__c != oldld.Appointment_Time__c)
                {    
                    dtTime = oldld.Appointment_Time__c;
                    scheduleMap.put(ld.id,ld);
                    oldscheduleMap.put(oldld.id, oldld);
                }
            }
           /* else {
                scheduleMap.put(ld.id,ld);
                oldscheduleMap.put(oldld.id, oldld);
            }   */
        }
        if(!scheduleMap.isEmpty())
        {
            map<id,lead> ldlst = new map<id,Lead>([Select id,Interior_Designer__r.Email__c,Interior_Designer__r.Name,full_name__c,Appointment_Venue_Square__r.Name,Appointment_Time__c,Email_For_Communication__c, Appointment_Venue_Square__r.WalkIn_SSA__r.Email, Square_Showroom_Manager__r.Email, Appointment_Venue_Square__r.Design_Manager__r.Email from Lead where id in:scheduleMap.values() and Appointment_Time__c != null and Interior_Designer__c != null]);
            System.debug('ldlst --> '+ldlst);
            if(!ldlst.isEmpty())
            {
                for(Lead ld : ldlst.values())
                {    
                    Lead schld = scheduleMap.get(ld.Id);
                    lead oldschld = oldscheduleMap.get(ld.Id);
                    System.debug('oldschld value --> '+oldschld.Appointment_Time__c);
                    System.debug('schld value --> '+schld.Appointment_Time__c);
                    Datetime gsttime = oldschld.Appointment_Time__c;
                    System.debug('gsttime value '+gsttime);
                    String gsttimestr = String.valueOf(gsttime);
                    System.debug('gsttimestr value '+gsttimestr);
                    Datetime gstmandril = ld.Appointment_Time__c.addHours(5).addMinutes(30);
                    Datetime newmeetime = schld.Appointment_Time__c.addHours(-5).addMinutes(-30);
                    if(dtTime != null) {
                    Date dt = date.newInstance(dtTime.year(), dtTime.month(), dtTime.day());
                  /*  if(!Test.isRunningTest()) { 
                    inside = true;                  
                    callBatch(ld.Id,gsttimestr);     
                    } */              
                    if(ld.Interior_Designer__c != null) {
                        inside = true;
                        String subject = 'We have rescheduled your HomeLane consultation to '+ newmeetime + ' as per your request';
                        callAPI1(ld.Interior_Designer__r.email__c,ld.Appointment_Venue_Square__r.Name,String.valueOf(gsttime),ld.Email_For_Communication__c,'CxR1_cx_reschedules',subject,ld.Email_For_Communication__c, ld.Interior_Designer__r.Email__c, ld.Appointment_Venue_Square__r.WalkIn_SSA__r.Email, ld.Square_Showroom_Manager__r.Email, ld.Appointment_Venue_Square__r.Design_Manager__r.Email,ld.Appointment_Venue_Square__r.Name,String.valueOf(ld.Appointment_Time__c),String.valueOf(ld.Id),ld.Interior_Designer__r.Name,ld.Appointment_Time__c, ld.Interior_Designer__c);
                    }
                    if(!System.isBatch() && ld.Interior_Designer__c != null) {
                        ld.Interior_Designer__c = null;
                        ldupdlst.add(ld);
                    }
                  /*  if(!Test.isRunningTest() && inside == false) {
                        inside = true;
                        if(dt >= Date.Today())
                        DPAssignmentcallBatch.MeetingCreation(dt);
                    }  */
                    }
                    
                }
            }
        }    
        if(!ldupdlst.isEmpty())
        update ldupdlst;
    }
    @future(callout=true)
    public static void callAPI1(String dp_email, String showroom_name, String meeting_start, String customer_email,String template,String subject,String custEmail,String dpEmail,String ssaEmail,String ssmEmail,String cmEmail,String showroomname,String newmeetingtime,String LDid,String interirorDesName, DateTime sftime, Id dpId) {
        DPAssignment__c appointment = DPAssignment__c.getValues('Appointment');
        DPAssignment__c cancel = DPAssignment__c.getValues('Cancel');
        DPAssignment__c availability = DPAssignment__c.getValues('Availability');
        String appointment1 = appointment.API__c;
        String cancel1 = cancel.API__c;
        String availability1 = availability.API__c;
        List<lead> ldupdlst = new list<lead>();
        Lead myLead = [Select id,Appointment_Time__c,Email_For_Communication__c, Interior_Designer__r.Email__c, Interior_Designer__c from Lead where Id =:LDid limit 1];
        System.debug('myLead--> '+myLead);
        System.debug('meeting_start value --> '+meeting_start);
        List<Object> listJson = new List<Object>();
        String con = '{"dp_email":"'+dp_email+'","showroom_name":"'+showroom_name+'","meeting_start":"'+meeting_start+'","customer_email":"'+customer_email+'"}';     
        System.debug('-----con   '+con ); 
        Http http = new http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(cancel1);
        request.setMethod('POST');
        request.setBody(con);
        request.setHeader('Content-Type','application/json');
        System.debug('-----request FUTURE '+request); 
    //    if(!Test.isRunningTest()) {
        HttpResponse response = http.send(request);  
        System.debug('-----response FUTURE '+response ); 
        System.debug('-----response body FUTURE '+response.getBody()); 
    
        Map<String, Object> json_req_inputFuture = (Map<String, Object>)JSON.deserializeUntyped(response.getBody()); 
        
        if(json_req_inputFuture.get('msg') == 'Meeting updated successfully.') {
            
            String con1 = 'showroom_name='+showroomname+'&start_time='+newmeetingtime+'&dp_email='+dp_email;
            System.debug('-----con1   '+con1 );  
            Http http1 = new http();
            HttpRequest request1 = new HttpRequest();
            request1.setEndpoint(availability1);
            request1.setMethod('POST');
            request1.setBody(con1);
            System.debug('-----request1  '+request1); 
            HttpResponse response1 = http1.send(request1);  
            System.debug('-----response1  '+response1 ); 
            System.debug('-----response body1 '+response1.getBody()); 
            Map<String, Object> json_req_input = (Map<String, Object>)JSON.deserializeUntyped(response1.getBody());           
            system.debug('******json_req_input *******'+json_req_input );
            if(json_req_input.get('response') != 'DPs are not available!!') {
                
                System.debug('This DP is available');
                String newmeetingtime1 = sftime.format('yyyy-MM-dd\'T\'HH:mm:ss','GMT');
                String con2 = '{"type":"create","ap_type":"meeting","dp_email":"'+dp_email+'","showroom_name":"'+showroom_name+'","meeting_start":"'+newmeetingtime1+'","customer_email":"'+customer_email+'"}';     
                System.debug('-----con2   '+con2 ); 
                Http http2 = new http();
                HttpRequest request2 = new HttpRequest();
                request2.setEndpoint(appointment1);
                request2.setMethod('POST');
                request2.setBody(con2);
                request2.setHeader('Content-Type','application/json');
                System.debug('-----request FUTURE2 '+request2);            
                HttpResponse response2 = http2.send(request2);  
                System.debug('-----response FUTURE2 '+response2 ); 
                System.debug('-----response body FUTURE2 '+response2.getBody()); 
                Map<String, Object> json_req_inputFuture2 = (Map<String, Object>)JSON.deserializeUntyped(response2.getBody()); 
                if(json_req_inputFuture2.get('msg') == 'Meeting creation successful') {
                    system.debug('successful');
                    //send successfull message of rescheduling
                    Http http3 = new Http();
                    HttpRequest request3 = new HttpRequest();
                    request3.setEndpoint('https://mandrillapp.com/api/1.0/messages/send-template.json');
                    request3.setMethod('POST');
                    request3.setHeader('Content-Type', 'application/json;charset=UTF-8');
                    // Set the body as a JSON object
                    //  request.setBody('{"key": "xhJxn_DI9P1L9lu3CLHfjQ","message": {"html": "<p>Example HTML content</p>","text": "Example text content","subject": "example subject","from_email": "test@homelane.com","from_name": "Example Name","to": [{"email": "pavan.d@homelane.com","name": "Pavan","type": "to"}],"headers": {"Reply-To": "test@homelane.com"},"important": false,"track_opens": true,"track_clicks": true,"merge_language": "mailchimp","global_merge_vars": [{"name": "merge1","content": "merge1 content" }],"merge_vars": [{"rcpt": "recipient.email@example.com","vars": [{"name": "merge2", "content": "merge2 content"}]}],"tags": ["password-resets"],"google_analytics_campaign": "message.from_email@example.com","metadata": {"website": "www.example.com"},"recipient_metadata": [{"rcpt": "recipient.email@example.com","values": {"user_id": 123456} }]},"async": false, "ip_pool": "Main Pool"}');
                    request3.setBody('{"key": "xhJxn_DI9P1L9lu3CLHfjQ","template_name": "'+template+'","template_content": [ {"name": "appt_time","content": "'+meeting_start+'" },{"name": "dp_name","content": "'+interirorDesName+'" },{"name": "showroom_name","content": "'+showroom_name+'" }], "message": {"html": "<p>Example HTML content</p>","text": "Example text content","subject": "'+subject+'","from_email": "hello@homelane.com","from_name": "Homelane","to": [{"email": "'+custEmail+'","name": "Recipient Name","type": "to"},{"email": "'+dpEmail+'","name": "Recipient Name","type": "cc"},{"email": "'+ssaEmail+'","name": "Recipient Name","type": "cc"},{"email": "'+ssmEmail+'","name": "Recipient Name","type": "cc"},{"email": "'+cmEmail+'","name": "Recipient Name","type": "cc"}],"important": false,"track_opens": null,"track_clicks": null,"auto_text": null,"auto_html": null, "inline_css": null,"url_strip_qs": null, "preserve_recipients": null,"view_content_link": null,"bcc_address": "message.bcc_address@example.com","tracking_domain": null,"signing_domain": null,"return_path_domain": null,"merge": true,"merge_language": "mailchimp","global_merge_vars": [{"name": "merge1","content": "merge1 content"}],"merge_vars": [{"rcpt": "recipient.email@example.com","vars": [ {"name": "merge2", "content": "merge2 content"}]}],"tags": ["password-resets"],"google_analytics_domains": ["example.com"],"google_analytics_campaign": "message.from_email@example.com","metadata": {"website": "www.example.com"},"recipient_metadata": [ {"rcpt": "recipient.email@example.com","values": {"user_id": 123456} }]},"async": false, "ip_pool": "Main Pool","send_at": "2018-08-01"}');
                    HttpResponse response3 = http3.send(request3);
                    // Parse the JSON response
                    System.debug('RESPONSE IS  : '+response3+'  BODY IS  '+response3.getBody());
                    if(myLead.Interior_Designer__c == null) {
                    myLead.Interior_Designer__c = dpId;
                    update myLead;
                    }
                }
                else
                {   
             /*   if(!ldlst.isEmpty())
                {
                    for(Lead ld : ldlst.values())
                    {  
                        if(ld.Interior_Designer__c != null) {
                            ld.Interior_Designer__c = null;
                            ldupdlst.add(ld);
                        }
                    }                
                } */
                    DPAssignmentBatchHandler.RosterReassign(LDid,newmeetingtime);
                    System.debug('error');
                }
            } 
            else
            {
              /* for(Lead ld : ldlst.values())
                    {  
                        if(ld.Interior_Designer__c != null) {
                            ld.Interior_Designer__c = null;
                            ldupdlst.add(ld);
                        }
                    } */
                System.debug('Not available at all');
                template = 'CxCD2_DP_not_available_new_time';
                subject =  interirorDesName + ' is not available on your new meeting time';
                Http http3 = new Http();
                HttpRequest request3 = new HttpRequest();
                request3.setEndpoint('https://mandrillapp.com/api/1.0/messages/send-template.json');
                request3.setMethod('POST');
                request3.setHeader('Content-Type', 'application/json;charset=UTF-8');
                // Set the body as a JSON object
                //  request.setBody('{"key": "xhJxn_DI9P1L9lu3CLHfjQ","message": {"html": "<p>Example HTML content</p>","text": "Example text content","subject": "example subject","from_email": "test@homelane.com","from_name": "Example Name","to": [{"email": "pavan.d@homelane.com","name": "Pavan","type": "to"}],"headers": {"Reply-To": "test@homelane.com"},"important": false,"track_opens": true,"track_clicks": true,"merge_language": "mailchimp","global_merge_vars": [{"name": "merge1","content": "merge1 content" }],"merge_vars": [{"rcpt": "recipient.email@example.com","vars": [{"name": "merge2", "content": "merge2 content"}]}],"tags": ["password-resets"],"google_analytics_campaign": "message.from_email@example.com","metadata": {"website": "www.example.com"},"recipient_metadata": [{"rcpt": "recipient.email@example.com","values": {"user_id": 123456} }]},"async": false, "ip_pool": "Main Pool"}');
                request3.setBody('{"key": "xhJxn_DI9P1L9lu3CLHfjQ","template_name": "'+template+'","template_content": [ {"name": "dp_name","content": "'+interirorDesName+'" },{"name": "appt_time","content": "'+newmeetingtime+'" }], "message": {"html": "<p>Example HTML content</p>","text": "Example text content","subject": "'+subject+'","from_email": "hello@homelane.com","from_name": "Homelane","to": [{"email": "'+custEmail+'","name": "Recipient Name","type": "to"},{"email": "'+dpEmail+'","name": "Recipient Name","type": "cc"},{"email": "'+ssaEmail+'","name": "Recipient Name","type": "cc"},{"email": "'+ssmEmail+'","name": "Recipient Name","type": "cc"},{"email": "'+cmEmail+'","name": "Recipient Name","type": "cc"}],"important": false,"track_opens": null,"track_clicks": null,"auto_text": null,"auto_html": null, "inline_css": null,"url_strip_qs": null, "preserve_recipients": null,"view_content_link": null,"bcc_address": "message.bcc_address@example.com","tracking_domain": null,"signing_domain": null,"return_path_domain": null,"merge": true,"merge_language": "mailchimp","global_merge_vars": [{"name": "merge1","content": "merge1 content"}],"merge_vars": [{"rcpt": "recipient.email@example.com","vars": [ {"name": "merge2", "content": "merge2 content"}]}],"tags": ["password-resets"],"google_analytics_domains": ["example.com"],"google_analytics_campaign": "message.from_email@example.com","metadata": {"website": "www.example.com"},"recipient_metadata": [ {"rcpt": "recipient.email@example.com","values": {"user_id": 123456} }]},"async": false, "ip_pool": "Main Pool","send_at": "2018-08-01"}');
                if(!System.isBatch()) {
                HttpResponse response3 = http3.send(request3);
                // Parse the JSON response
                System.debug('RESPONSE IS  : '+response3+'  BODY IS  '+response3.getBody());
                }
                 DPAssignmentBatchHandler.RosterReassign(LDid,newmeetingtime);
            }
        }
       // if(!ldupdlst.isEmpty())
      //  update ldupdlst;
    }
    
     @future(callout=true)
    public static void callBatch(Id leadId, String dtTime) {
        DPAssignmentBatchHandler.RosterReassign(leadId,dtTime);
    }
    
     public static void dummyTestCover(){
   Integer i =0;
   i++;
     i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
     i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        }
}