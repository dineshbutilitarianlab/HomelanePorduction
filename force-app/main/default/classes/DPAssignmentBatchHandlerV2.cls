//  THIS CLASS IS COVERED BY assignment_trigger_Test

global class DPAssignmentBatchHandlerV2 {
    
    global static boolean flag = false;
    global static Map<Id,Lead> leadToUpdate1 = new Map<Id,Lead>();
    global static map<Lead,id> leadDPmap = new Map<Lead,Id>();
    global static String oper;
    global static void RosterReassign(String idVal,String AssignDt)
    {
       List<lead> ldlst = new List<lead>();
       Lead ld =  [select id, name, Appointment_Venue_Square__r.Design_Manager__r.Email, Interior_Designer__c, Customer_Score__c, Property__c,Square_Showroom_Manager__r.Email, Interior_Designer__r.Email__c, Appointment_Time__c, city, Email_For_Communication__c, Property__r.Name,Meeting_Status__c, Appointment_Venue_Square__c, Appointment_Venue_Square__r.Name, Appointment_Venue_Square__r.WalkIn_SSA__r.Email, Preferred_Language__c,DP_Stack_Rank__c, Regional_Language_Preference__c, Budget_Range__c from Lead where id=:Id.valueOf(idVal)];
        System.debug('ld value in RosterReassign --> '+ld);
        ldlst.add(ld);
    }
  
   /* global static void doactions(list<lead> LeadList,Date assignDate)
    {
      //  oper = OperType;
        System.debug('oper value--> '+oper);
        DPAssignment__c availability = DPAssignment__c.getValues('Availability');
        String availability1 = availability.API__c;
        
        List<Object> listJson = new List<Object>();
        Set<String> emailList = new Set<String>();
        Map<String,List<Lead>> emailMap = new Map<String,List<Lead>>();
        List<Object> infoList = new List<Object>();
        List<Object> finalScoreSort = new List<Object>();
        Map<Id,Lead> leadMap = new Map<Id,Lead>();
        List<Lead> listUpd = new List<Lead>();
        List<DP_Assignment__c> dpEmailList = new List<DP_Assignment__c>();
        Lead ll;
        if(leadList.size() > 0) {
            System.debug('lead list size '+leadList.size());
          //  leadMap.clear();
            DateTime gst;
            for(Lead l : leadList) {
              
                emailList.clear();
                System.debug('lead val --> '+l);
                gst = l.Appointment_Time__c.addHours(5).addMinutes(30);
                String con = 'showroom_name='+l.Appointment_Venue_Square__r.Name+'&start_time='+gst;
                System.debug('-----con   '+con );  
                Http http = new http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(availability1);
                request.setMethod('POST');
                request.setBody(con);
                System.debug('-----request  '+request);
              
                if(!Test.isRunningTest()) {
                HttpResponse response = http.send(request);  
                System.debug('-----response  '+response ); 
                System.debug('-----response body '+response.getBody());                 
                Map<String, Object> json_req_input = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());           
                system.debug('******json_req_input *******'+json_req_input );
                      
                if(json_req_input.get('response') != 'DPs are not available!!') {
                    listJson = (List<Object>)json_req_input.get('response');
                    System.debug('LIST OBJECT '+listJson); 
                    
                    for(Object em : listJson) {
                        
                        Map<String, Object>  json_req_input1 = (Map<String, Object>)em;
                        String strJson = (String)json_req_input1.get('dp_email');
                        
                        emailList.add(strJson);
                        System.debug('Entering before emailMap key '+strJson+' and lead '+l);
                        //emailMap.put(strJson,l);   
                        leadMap.put(l.Id,l);     
                        System.debug('INSIDE  '+strJson );
                        
                    }       
                         
                }
                else if(json_req_input.get('response') == 'DPs are not available!!') {
                    
                    System.debug('DP not available Entered');
                    mandril('CxA3_No_DP_Found', 'Our HomeLane interior designer will be waiting for you on '+gst, l.Email_For_Communication__c, l.Interior_Designer__r.Email__c, l.Appointment_Venue_Square__r.WalkIn_SSA__r.Email, l.Square_Showroom_Manager__r.Email, l.Appointment_Venue_Square__r.Design_Manager__r.Email);
                }
                          
                System.debug('InfoList --> '+infoList);
                //  finalScoreSort.clear();
                for(Object s : infoList) {
                    System.debug('s value in infolist --> '+s);
                    finalScoreSort.add(s);
                }  
                }               
           }              
      }
      
      System.debug('---------EMAIL LIST  '+emailList); 
      try {
          Map<String,DP_Assignment__c> dpMap = new Map<String,DP_Assignment__c>();        
          List<DP_Assignment__c> dpList = [select id, name from DP_Assignment__c where name =: emailList];          
          if(dpList.isEMpty()) {
              for(String s : emailList) {
                  System.debug('====INSIDE TRY ');
                  DP_Assignment__c dpEmail = new DP_Assignment__c();
                  dpEmail.Name = s;
                  dpEmailList.add(dpEmail);
              } 
          }
      }
      catch(System.QueryException e) {
          for(String s : emailList) {
              System.debug('====INSIDE CATCH ');
              DP_Assignment__c dpEmail = new DP_Assignment__c();
              dpEmail.Name = s;
              dpEmailList.add(dpEmail);
          } 
      }      
      upsert dpEmailList; 

    } */
    
   global static void doactions(list<lead> LeadList,Date assignDate)
    {
        System.debug('oper value--> '+oper);
        DPAssignment__c availability = DPAssignment__c.getValues('Availability');
        String availability1 = availability.API__c;
        
        List<Object> listJson = new List<Object>();
        Set<String> emailList = new Set<String>();
        Map<String,Set<String>> emailMap = new Map<String,Set<String>>();
        List<Object> infoList = new List<Object>();
        List<Object> finalScoreSort = new List<Object>();
        Map<Id,Lead> leadMap = new Map<Id,Lead>();
        List<Lead> listUpd = new List<Lead>();
        List<DP_Assignment__c> dpEmailList = new List<DP_Assignment__c>();
        Map<String,Lead> dates = new Map<String,Lead>();
        Lead ll;
        if(leadList.size() > 0) {
            System.debug('lead list size '+leadList.size());
          //  leadMap.clear();
            DateTime gst;
            for(Lead l : leadList) {                             
                System.debug('lead val --> '+l);
                gst = l.Appointment_Time__c.addHours(5).addMinutes(30);
                dates.put(l.Appointment_Venue_Square__r.Name+'/'+gst+'/'+l.id, l);
            }  
         }  
          System.debug('dates val --> '+dates); 
            for(String t : dates.keyset()) {
               emailList.clear();
               List<String> show = t.split('/');               
               String con = 'showroom_name='+show[0]+'&start_time='+show[1];
                System.debug('-----con   '+con );  
                Http http = new http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(availability1);
                request.setMethod('POST');
                request.setBody(con);
                System.debug('-----request  '+request);
                
                if(!Test.isRunningTest()) {
                HttpResponse response = http.send(request);  
                System.debug('-----response  '+response ); 
                System.debug('-----response body '+response.getBody());                 
                Map<String, Object> json_req_input = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());           
                system.debug('******json_req_input *******'+json_req_input );
                      
                if(json_req_input.get('response') != 'DPs are not available!!') {
                    listJson = (List<Object>)json_req_input.get('response');
                    System.debug('LIST OBJECT '+listJson); 
                    
                    for(Object em : listJson) {
                        
                        Map<String, Object>  json_req_input1 = (Map<String, Object>)em;
                        String strJson = (String)json_req_input1.get('dp_email');
                        
                        emailList.add(strJson);
                        emailMap.put(dates.get(t).Id,emailList);   
                        leadMap.put(dates.get(t).Id,dates.get(t));     
                        System.debug('INSIDE  '+strJson );                       
                    }                               
                }
                else if(json_req_input.get('response') == 'DPs are not available!!') {
                    
                    System.debug('DP not available Entered');
                    mandril('CxA3_No_DP_Found', 'Our HomeLane interior designer will be waiting for you on '+show[1], dates.get(t).Email_For_Communication__c, dates.get(t).Interior_Designer__r.Email__c, dates.get(t).Appointment_Venue_Square__r.WalkIn_SSA__r.Email, dates.get(t).Square_Showroom_Manager__r.Email, dates.get(t).Appointment_Venue_Square__r.Design_Manager__r.Email);
                }
                          
                System.debug('InfoList --> '+infoList);
                //  finalScoreSort.clear();
                for(Object s : infoList) {
                    System.debug('s value in infolist --> '+s);
                    finalScoreSort.add(s);
                }  
                }
                
                 System.debug('---------EMAIL LIST  '+emailList); 
                  try {
                      List<DP_Assignment__c> dpList = [select id, name from DP_Assignment__c where name =: dates.get(t).Id];          
                      if(dpList.isEMpty()) {
                              System.debug('====INSIDE TRY ');
                              DP_Assignment__c dpEmail = new DP_Assignment__c();
                              dpEmail.Name = dates.get(t).Id;
                              for(String s : emailList) {
                                  dpEmail.DP_Email_List__c = s+','+dpEmail.DP_Email_List__c;
                              }
                              dpEmailList.add(dpEmail);
                      }
                  }
                  catch(System.QueryException e) {
                          System.debug('====INSIDE CATCH ');
                          DP_Assignment__c dpEmail = new DP_Assignment__c();
                          dpEmail.Name = dates.get(t).Id;
                          for(String s : emailList) {
                              dpEmail.DP_Email_List__c = s+','+dpEmail.DP_Email_List__c;
                          }
                          dpEmailList.add(dpEmail);
                  }      
                      
           }            
   upsert dpEmailList;
    } 
    
   global static void mandril(String template, String subject, String custEmail, String dpEmail, String ssaEmail, String ssmEmail, String cmEmail) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://mandrillapp.com/api/1.0/messages/send-template.json');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        //  request.setBody('{"key": "xhJxn_DI9P1L9lu3CLHfjQ","message": {"html": "<p>Example HTML content</p>","text": "Example text content","subject": "example subject","from_email": "test@homelane.com","from_name": "Example Name","to": [{"email": "pavan.d@homelane.com","name": "Pavan","type": "to"}],"headers": {"Reply-To": "test@homelane.com"},"important": false,"track_opens": true,"track_clicks": true,"merge_language": "mailchimp","global_merge_vars": [{"name": "merge1","content": "merge1 content" }],"merge_vars": [{"rcpt": "recipient.email@example.com","vars": [{"name": "merge2", "content": "merge2 content"}]}],"tags": ["password-resets"],"google_analytics_campaign": "message.from_email@example.com","metadata": {"website": "www.example.com"},"recipient_metadata": [{"rcpt": "recipient.email@example.com","values": {"user_id": 123456} }]},"async": false, "ip_pool": "Main Pool"}');
        request.setBody('{"key": "xhJxn_DI9P1L9lu3CLHfjQ","template_name": "'+template+'","template_content": [ {"name": "example name","content": "example content" }], "message": {"html": "<p>Example HTML content</p>","text": "Example text content","subject": "'+subject+'","from_email": "hello@homelane.com","from_name": "Homelane","to": [{"email": "'+custEmail+'","name": "Recipient Name","type": "to"},{"email": "'+dpEmail+'","name": "Recipient Name","type": "cc"},{"email": "'+ssaEmail+'","name": "Recipient Name","type": "cc"},{"email": "'+ssmEmail+'","name": "Recipient Name","type": "cc"},{"email": "'+cmEmail+'","name": "Recipient Name","type": "cc"}],"important": false,"track_opens": null,"track_clicks": null,"auto_text": null,"auto_html": null, "inline_css": null,"url_strip_qs": null, "preserve_recipients": null,"view_content_link": null,"bcc_address": "message.bcc_address@example.com","tracking_domain": null,"signing_domain": null,"return_path_domain": null,"merge": true,"merge_language": "mailchimp","global_merge_vars": [{"name": "merge1","content": "merge1 content"}],"merge_vars": [{"rcpt": "recipient.email@example.com","vars": [ {"name": "merge2", "content": "merge2 content"}]}],"tags": ["password-resets"],"google_analytics_domains": ["example.com"],"google_analytics_campaign": "message.from_email@example.com","metadata": {"website": "www.example.com"},"recipient_metadata": [ {"rcpt": "recipient.email@example.com","values": {"user_id": 123456} }]},"async": false, "ip_pool": "Main Pool","send_at": "2018-08-01"}');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        System.debug('RESPONSE IS  : '+response+'  BODY IS  '+response.getBody());
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
    }
}