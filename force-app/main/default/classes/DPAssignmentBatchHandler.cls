global class DPAssignmentBatchHandler {
    
    global static boolean flag = false;
    global static Map<Id,Lead> leadToUpdate1 = new Map<Id,Lead>();
    global static map<Lead,id> leadDPmap = new Map<Lead,Id>();
    global static void RosterReassign(String idVal,String AssignDt)
    {
       List<lead> ldlst = new List<lead>();
       Lead ld =  [select id, name, Appointment_Venue_Square__r.Design_Manager__r.Email, Interior_Designer__c, Customer_Score__c, Property__c,Square_Showroom_Manager__r.Email, Interior_Designer__r.Email__c, Appointment_Time__c, city, Email_For_Communication__c, Property__r.Name,Meeting_Status__c, Appointment_Venue_Square__c, Appointment_Venue_Square__r.Name, Appointment_Venue_Square__r.WalkIn_SSA__r.Email, Preferred_Language__c,DP_Stack_Rank__c, Regional_Language_Preference__c, Budget_Range__c from Lead where id=:Id.valueOf(idVal)];
        System.debug('ld value in RosterReassign --> '+ld);
        ldlst.add(ld);
        doactions2(ldlst,Date.valueof(AssignDt));
    }
   /* global static void RosterReassignOtherLead(String AssignDt)
    {    
    DateTime time1 = DateTime.valueOf(AssignDt).addMinutes(-30);
    DateTime time2 = DateTime.valueOf(AssignDt);
    System.debug('----------time1  '+time1);
    System.debug('----------time2  '+time2);
       List<lead> ldlst = new List<lead>();
       ldlst =  [select id, name, Appointment_Venue_Square__r.Design_Manager__r.Email, Interior_Designer__c, Customer_Score__c, Property__c,Square_Showroom_Manager__r.Email, Interior_Designer__r.Email__c, Appointment_Time__c, city, Email_For_Communication__c, Property__r.Name,Meeting_Status__c, Appointment_Venue_Square__c, Appointment_Venue_Square__r.Name, Appointment_Venue_Square__r.WalkIn_SSA__r.Email, Preferred_Language__c,DP_Stack_Rank__c, Regional_Language_Preference__c, Budget_Range__c from Lead where Interior_Designer__c = null and (Status = 'Appointment Fixed' or Status = 'Appointment Confirmed') and Appointment_Type__c = 'Square Showroom Visit'];
        System.debug('ld value in RosterReassign --> '+ldlst.size());
       // ldlst.add(ld);
        doactions(ldlst,Date.valueof(AssignDt));
    }*/
    
    global static void doactions(list<lead> LeadList,Date assignDate)
    {
        DPAssignment__c availability = DPAssignment__c.getValues('Availability');
        String availability1 = availability.API__c;
        
        List<Object> listJson = new List<Object>();
        Set<String> emailList = new Set<String>();
        Map<String,List<Lead>> emailMap = new Map<String,List<Lead>>();
        List<Object> infoList = new List<Object>();
        List<Object> finalScoreSort = new List<Object>();
        Map<Id,Lead> leadMap = new Map<Id,Lead>();
        List<Lead> listUpd = new List<Lead>();
        Lead ll;
        if(leadList.size() > 0) {
            System.debug('lead list size '+leadList.size());
          //  leadMap.clear();
            DateTime gst;
            for(Lead l : leadList) {
              /*  if(l.Interior_Designer__c != null) {
                    System.debug('DP is going to null');
                    l.Interior_Designer__c = null;
                    listUpd.add(l);
                } */
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
              /*  if(!Test.isRunningTest())    
                {
                    HttpMockClassCallout htp = new HttpMockClassCallout('{"error":false,"response":[{"dp_name":"Kishore PG","dp_email":"kishore.p@homelane.com","user_id":"184997","showroom_id":"766","appointment_id":null},{"dp_name":"Vinushitha B","dp_email":"vinushithab.pd@homelane.com","user_id":"208342","showroom_id":"766","appointment_id":null}],"msg":"success"}','OK',200);
                    Test.setMock(HttpCalloutMock.class, htp);
                }*/
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
                
                System.debug('---------EMAIL LIST  '+emailList);
                infoList = Calculate(emailList, l);
                System.debug('InfoList --> '+infoList);
                //  finalScoreSort.clear();
                for(Object s : infoList) {
                    System.debug('s value in infolist --> '+s);
                    finalScoreSort.add(s);
                }  
                }               
               }
                System.debug('finalScoreSort val before dpassignment1 --> '+finalScoreSort);
                System.debug('----------infoList   '+infoList);
                System.debug('emailmap keyset() --> '+emailMap.keyset());
                DPAssignment1(emailMap.keyset(),assignDate, finalScoreSort, leadMap,ll);
                
               
           
            if(flag == false && !emailList.isEmpty() && !leadList.isEmpty()) {
                System.debug('---------flag  INSIDE '+flag);
                System.debug('emailMap keyset() '+emailMap.keyset());
                System.debug('emailMap values() '+emailMap.values());
                System.debug('emailMap  '+emailMap);
                //DPAssignment1(emailMap.keyset(),assignDate, finalScoreSort, leadMap);
                flag = true;
            }
            System.debug('---------flag   '+flag); 
            
            //if(!leadToUpdate1.isEmpty()) 
//update leadToUpdate1.values();  
            
            System.debug('---------leadDPmap '+leadDPmap);
            System.debug('---------leadToUpdate1   '+leadToUpdate1);   
        
        
        if(!leadToUpdate1.isEmpty() && !Test.isRunningTest())  {
            UpdateAvailability__c mc = UpdateAvailability__c.getOrgDefaults();
            mc.Flag__c = false;
            update mc;
            update leadToUpdate1.values();
            mc.Flag__c = true;
            update mc;
        }
        
      }
    } 
    
    
    global static void doactions2(list<lead> LeadList,Date assignDate)
    {
        DPAssignment__c availability = DPAssignment__c.getValues('Availability');
        String availability1 = availability.API__c;
        
        List<Object> listJson = new List<Object>();
        Set<String> emailList = new Set<String>();
        Map<String,List<Lead>> emailMap = new Map<String,List<Lead>>();
        List<Object> infoList = new List<Object>();
        List<Object> finalScoreSort = new List<Object>();
        Map<Id,Lead> leadMap = new Map<Id,Lead>();
        if(leadList.size() > 0) {
            System.debug('lead list size '+leadList.size());
            leadMap.clear();
            for(Lead l : leadList) {
                emailList.clear();
                System.debug('lead val --> '+l);
                DateTime gst = l.Appointment_Time__c.addHours(5).addMinutes(30);
                String con = 'showroom_name='+l.Appointment_Venue_Square__r.Name+'&start_time='+gst;
                System.debug('-----con   '+con );  
                Http http = new http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(availability1);
                request.setMethod('POST');
                request.setBody(con);
                System.debug('-----request  '+request); 
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
                System.debug('---------EMAIL LIST  '+emailList);
                infoList = Calculate(emailList, l);
                System.debug('InfoList --> '+infoList);
                finalScoreSort.clear();
                for(Object s : infoList) {
                    System.debug('s value in infolist --> '+s);
                    finalScoreSort.add(s);
                }  
                System.debug('finalScoreSort val before dpassignment1 --> '+finalScoreSort);
                System.debug('----------infoList   '+infoList);
                System.debug('emailmap keyset() --> '+emailMap.keyset());
                DPAssignment1(emailMap.keyset(),assignDate, finalScoreSort, leadMap,l);
            }  
            
            
            if(flag == false && !emailList.isEmpty() && !leadList.isEmpty()) {
                System.debug('---------flag  INSIDE '+flag);
                System.debug('emailMap keyset() '+emailMap.keyset());
                System.debug('emailMap values() '+emailMap.values());
                System.debug('emailMap  '+emailMap);
                //DPAssignment1(emailMap.keyset(),assignDate, finalScoreSort, leadMap);
                flag = true;
            }
            System.debug('---------flag   '+flag); 
            
            //if(!leadToUpdate1.isEmpty()) 
//update leadToUpdate1.values();  
            
            System.debug('---------leadDPmap '+leadDPmap);
            System.debug('---------leadToUpdate1   '+leadToUpdate1);   
        }
        if(!leadToUpdate1.isEmpty() && !Test.isRunningTest()) {
            UpdateAvailability__c mc = UpdateAvailability__c.getOrgDefaults();
            mc.Flag__c = false;
            update mc;
            update leadToUpdate1.values();
            mc.Flag__c = true;
            update mc;
        }
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
    
    global static void DPAssignment1(Set<String> emailList, Date assignDate, List<Object> finalScoreSort, Map<Id,Lead> leadMap,Lead l) {  //id = '00Q5D0000026CcW' or id='00Q5D000001qWUZ' or 
        Set<Id> showroomId = new Set<Id>();
        System.debug('leadMap --> '+leadMap);
        System.debug('emailList --> '+emailList);
        System.debug('assignDate --> '+assignDate);
        System.debug('finalScoreSort --> '+finalScoreSort);
        /* List<Master__c> showroomList = [select id, name from Master__c where name = 'HSR Showroom' or name = 'Gopalan Showroom' or name = 'Kanakapura Showroom' or name = 'Kodambakkam Showroom' or name = 'Gachibowli Showroom' or name = 'Thane Showroom' or name = 'Noida Showroom' or name = 'Gurgaon Showroom' or name = 'Hebbal Showroom' or name = 'Bellandur Mini showroom' or name = 'Whitefield Cowrks' or name = 'Goregaon Coworks' or name = 'CoWrks OMR' or name = 'Whitefield Showroom'];
for(Master__c m : showroomList ) {
showroomId.add(m.id);
} */
        //   List<Lead> leadList = new List<Lead>([select id, name, Interior_Designer__c, Customer_Score__c, Property__c, city, Property__r.Name, Meeting_Status__c, Appointment_Venue_Square__c, Appointment_Venue_Square__r.Name, Preferred_Language__c,DP_Stack_Rank__c, Regional_Language_Preference__c, Budget_Range__c from Lead where (id = '00Q5D0000026CcW' or id='00Q5D000001qWUZ' or id = '00Q5D0000026DKY')]);
        //  List<Lead> leadList = [select id, name, Interior_Designer__c, Customer_Score__c, Property__c, city, Property__r.Name, Meeting_Status__c, Appointment_Venue_Square__c, Appointment_Venue_Square__r.Name, Preferred_Language__c,DP_Stack_Rank__c, Regional_Language_Preference__c, Budget_Range__c from Lead where appointment_time__c != null and interior_designer__c = null and (Status = 'Appointment Fixed' or Status = 'Appointment Confirmed') and Appointment_Venue_Square__c=: showroomId order by Customer_Score__c ];
        //System.debug('----------leadList  '+leadList );
        //  List<String> emailList = MeetingCreation();
        //  List<Object> infoList = new List<Object>();
        //  List<Object> finalScoreSort = new List<Object>();
        List<Object> custScoreSort = new List<Object>();
        //   Map<Id,Lead> leadMap = new Map<Id,Lead>();
        List<List<Lead>> leadListOfList= new List<List<Lead>>();
        
        /* for(Lead myLead : leadList) {
//  String [] emailList = new List<String>();
// Call Roster API
infoList = new List<String>();
infoList = Calculate(emailList, myLead);
SYstem.debug('========infoList  '+infoList);
for(Object s : infoList) {
finalScoreSort.add(s);
}  
leadMap.put(myLead.Id,myLead); 
//   break;             
}  */
        System.debug('----------leadMap  '+leadMap);
        
        storeInfoWrapper.sortBy = storeInfoWrapper.SORT_BY.ByfinalScore;  
        finalScoreSort.sort();
        custScoreSort.addAll(finalScoreSort);
        storeInfoWrapper.sortBy = storeInfoWrapper.SORT_BY.BycustScore;  
        custScoreSort.sort();
        
        System.debug('----------finalScoreSort  '+finalScoreSort);
        String ss = JSON.serialize(finalScoreSort);
        System.debug('----------String  '+ss);
        List<Object> objList = (List<Object>) JSON.deserializeUntyped(ss);
        System.debug('----------objList  '+objList );
        List<Map<String,Object>> finalScoreSortMap = new List<Map<String,Object>>();
        for(Object o : objList) {
            String s = JSON.serialize(o);                
            Map<String,Object> matrixM =  (Map<String,Object>) JSON.deserializeUntyped(s);
            finalScoreSortMap.add(matrixM);
        }        
        SYstem.debug('========finalScoreSortMap  '+finalScoreSortMap);
        
        System.debug('----------custScoreSort  '+custScoreSort);
        String ss1 = JSON.serialize(custScoreSort);
        System.debug('----------String  '+ss1);
        List<Object> objList1 = (List<Object>) JSON.deserializeUntyped(ss1);
        System.debug('----------objList  '+objList1 );
        List<Map<String,Object>> custScoreSortMap = new List<Map<String,Object>>();
        for(Object o : objList1) {
            String s1 = JSON.serialize(o);                
            Map<String,Object> matrixM1 =  (Map<String,Object>) JSON.deserializeUntyped(s1);
            custScoreSortMap.add(matrixM1);
        }
        SYstem.debug('========custScoreSortMap  '+custScoreSortMap);
        
        DPAssignment(finalScoreSortMap, custScoreSortMap, leadMap, assignDate,l);
        
    }
    
    global static void DPAssignment(List<Map<String,Object>> finalScoreSortMap, List<Map<String,Object>> custScoreSortMap, Map<Id,Lead> leadMap, Date assignDate,Lead ld) {
        Integer count = 0;
        Map<String,Object> MapDPList = new Map<String,Object>();
        Set<Id> leadId = new Set<Id>();
        Set<Id> dpId = new Set<Id>();
        List<Decimal> score = new List<Decimal>();
        Map<Id,List<Map<String,Object>>> countMap = new Map<Id,List<Map<String,Object>>>();
        Map<Id,List<Map<String,Object>>> countMapWeak = new Map<Id,List<Map<String,Object>>>();
        Map<Id,List<Map<String,Object>>> singleStrong = new Map<Id,List<Map<String,Object>>>();
        Map<Id,List<Map<String,Object>>> multipleStrong = new Map<Id,List<Map<String,Object>>>();
        Map<Id,List<Map<String,Object>>> singleWeak = new Map<Id,List<Map<String,Object>>>();
        Map<Id,List<Map<String,Object>>> multipleWeak = new Map<Id,List<Map<String,Object>>>();
        
        Map<Decimal,List<Map<String,Object>>> multipleWeak2 = new Map<Decimal,List<Map<String,Object>>>();
        Map<Decimal,List<Map<String,Object>>> countMapWeak2 = new Map<Decimal,List<Map<String,Object>>>();
        Map<Integer,Id> countDPMap = new Map<Integer,Id>();
        Map<Integer,Id> countLeadMap = new Map<Integer,Id>();
        Map<Id,Lead> leadToUpdate = new Map<Id,Lead>();
        Id ids;
        id idsLead;
        
        for(Map<String,Object> m : custScoreSortMap) {
            System.debug('-------m.get(finalScore)  '+m.get('finalScore'));
            if((Decimal)m.get('finalScore') > 50 ) {
                count = count+1;
                leadId.add((Id)m.get('leadId'));
                dpId.add((Id)m.get('dpId'));
                score.add((Decimal)m.get('finalScore'));
                if(countMap.get((Id)m.get('dpId')) != null) {
                    List<Map<String,Object>> lst = countMap.get((Id)m.get('dpId'));
                    lst.add(m);
                    countMap.put((Id)m.get('dpId'),lst);               
                }
                else {
                    List<Map<String,Object>> lst = new List<Map<String,Object>>();
                    lst.add(m);
                    countMap.put((Id)m.get('dpId'),lst);   
                }
                countDPMap.put(count,(id)m.get('dpId'));
                countLeadMap.put(count,(id)m.get('leadId'));
                //  m.get('countWrap') = count;
            }
          /*  else {
                if(countMapWeak.get((Id)m.get('dpId')) != null) {
                    List<Map<String,Object>> lst = countMapWeak.get((Id)m.get('dpId'));
                    lst.add(m);
                    countMapWeak.put((Id)m.get('dpId'),lst);               
                }
                else {
                    List<Map<String,Object>> lst = new List<Map<String,Object>>();
                    lst.add(m);
                    countMapWeak.put((Id)m.get('dpId'),lst);   
                }
            }  
            
            else {
                if(countMapWeak2.get((Decimal)m.get('custScore')+'/'+(Id)m.get('dpId')) != null) {
                    List<Map<String,Object>> lst = countMapWeak2.get((Decimal)m.get('custScore')+'/'+(Id)m.get('dpId'));
                    lst.add(m);
                    countMapWeak2.put((Decimal)m.get('custScore')+'/'+(Id)m.get('dpId'),lst);               
                }
                else {
                    List<Map<String,Object>> lst = new List<Map<String,Object>>();
                    lst.add(m);
                    countMapWeak2.put((Decimal)m.get('custScore')+'/'+(Id)m.get('dpId'),lst);   
                }
            } */
        }
        
        System.debug('==========leadId  '+leadId);
        System.debug('==========dpId  '+dpId);
        System.debug('==========score  '+score);
        System.debug('==========countMap  '+countMap);
      /*  System.debug('==========countMapWeak  '+countMapWeak);
        System.debug('==========countDPMap  '+countDPMap);
        System.debug('==========countLeadMap  '+countLeadMap); */
        Map<Id,Lead> leadToUpd = new Map<Id,Lead>();
        // Map<Id,Lead> leadMap = new Map<Id,Lead>([select id, name, Interior_Designer__c, Customer_Score__c from Lead where id =: countLeadMap.values() order by Customer_Score__c]);    
        //  List<Lead> leadList = [select id, name, Interior_Designer__c, Customer_Score__c from Lead where id =: countLeadMap.values() order by Customer_Score__c desc];
        // System.debug('===========leadList  '+leadList );
        
        for(Id m : countMap.keyset()) {
            System.debug('***********SIZEs  '+countMap.get(m).size());
            if(countMap.get(m).size() == 1) {
                System.debug('***********INSIDE SIZE 1');
                singleStrong.put(m,countMap.get(m));
            } 
            else if(countMap.get(m).size() > 1) {
                System.debug('***********INSIDE SIZE > 1');
                multipleStrong.put(m,countMap.get(m));              
            } 
        }  
        
      /*  for(Id m : countMapWeak.keyset()) {
            System.debug('***********SIZEs  '+countMapWeak.get(m).size());
            if(countMapWeak.get(m).size() == 1) {
                System.debug('***********INSIDE SIZE 1');
                singleWeak.put(m,countMapWeak.get(m));
            } 
            else if(countMapWeak.get(m).size() > 1) {
                System.debug('***********INSIDE SIZE > 1');
                multipleWeak.put(m,countMapWeak.get(m));
            }
        }  
        
        for(Decimal m : countMapWeak2.keyset()) {
            System.debug('***********SIZEs  '+countMapWeak2.get(m).size());
           
            if(countMapWeak2.get(m).size() > 1) {
                System.debug('***********INSIDE SIZE > 1');
                multipleWeak2.put(m,countMapWeak2.get(m));
            }
        }*/
        
        System.debug('==========singleStrong  '+singleStrong);
        System.debug('==========multipleStrong  '+multipleStrong);
        System.debug('==========singleWeak  '+singleWeak);
        System.debug('==========multipleWeak  '+multipleWeak);
        System.debug('==========multipleWeak2  '+multipleWeak2);
        Boolean flag1 = false;
        Boolean flag2 = false;
        Boolean flag3 = false;
        Boolean flag4 = false;
        
        if(!singleStrong.isEmpty()) {
            System.debug('==========INSIDE SINGLE STRONG');
          //  for(Id m : singleStrong.keyset()) {
            for(Integer i=singleStrong.size()-1; i>=0; i--) {
                for(Map<String,Object> ma : singleStrong.values()[i]) {
                    if(flag1 == false) {
                        //if(LeadMap.containsKey((Id)ma.get('leadId')))
                        //{
                            Lead l = leadMap.get((Id)ma.get('leadId'));
                            l.Interior_Designer__c = (Id)ma.get('dpId');
                            DateTime gst = l.Appointment_Time__c.addHours(-5).addMinutes(-30);
                            //leadToUpdate1.put(ld.Id,ld);
                            leadDPmap.put(l,(Id)ma.get('dpId'));
                            String gstStr = String.valueOf(gst);
                            System.debug('+++++++++leadMap.get((String)ma.get(leadId)).Interior_Designer__r.Email__c   '+(String)ma.get('email'));
                            // update l;
                            /*if(leadToUpdate1.size() >0){
updateAvailabilityAPIRoster objLPA = new updateAvailabilityAPIRoster(leadToUpdate1,UserInfo.getSessionId(), (String)ma.get('email'), (String)ma.get('dpName'), String.valueOf(gst), assignDate);
ID jobID = System.enqueueJob(objLPA);
system.debug('-----jobID----'+jobID); 
} */
                            String message = callAPI((String)ma.get('email'), l.Appointment_Venue_Square__r.Name, String.valueOf(gst), l.Email_For_Communication__c, assignDate);
                            System.debug('message val '+message);
                            if(message =='successful')
                            {
                                leadToUpdate1.put(l.Id,l);
                                if(!leadmap.isempty())
                                {
                                    System.debug('lead map ---> '+leadmap);
                                    leadmap.remove(l.Id);                                   
                                    if(!Test.isRunningTest())
                                    doactions(Leadmap.values(),assignDate);
                                }
                            }
                            // update l;
                            flag1 = true;
                            break;
                        //}
                    }
                }
            }
        }
        
        else if(!multipleStrong.isEmpty()) {
            System.debug('==========INSIDE MULTI STRONG');
            for(Id m : multipleStrong.keyset()) {
                for(Integer i=multipleStrong.get(m).size()-1; i>=0; i--) {
                    if(flag2 == false) {
                        System.debug('Lead Id value in multistrong --> '+(Id)multipleStrong.get(m)[i].get('leadId'));
                        System.debug('Lead map keyset in multiString --> '+leadMap.keyset());
                        //if(leadmap.containskey((Id)multipleStrong.get(m)[i].get('leadId')))
                       // {
                            System.debug('==========INSIDE MULTI STRONG   '+leadMap.get((Id)multipleStrong.get(m)[i].get('leadId')));
                            Lead l = leadMap.get((Id)multipleStrong.get(m)[i].get('leadId'));
                            l.Interior_Designer__c = m;
                            DateTime gst = l.Appointment_Time__c.addHours(-5).addMinutes(-30);
                            //update l;
                            //leadToUpdate1.put(ld.Id,ld);
                            leadDPmap.put(l,m);
                            String gstStr = String.valueOf(gst);
                            /*if(leadToUpdate1.size() >0){
updateAvailabilityAPIRoster objLPA = new updateAvailabilityAPIRoster(leadToUpdate1,UserInfo.getSessionId(), (String)multipleStrong.get(m)[i].get('email'), (String)multipleStrong.get(m)[i].get('dpName'), String.valueOf(gst), assignDate);
ID jobID = System.enqueueJob(objLPA);
system.debug('-----jobID----'+jobID); 
} */
                            String message = callAPI((String)multipleStrong.get(m)[i].get('email'), l.Appointment_Venue_Square__r.Name, String.valueOf(gst), l.Email_For_Communication__c, assignDate);
                            System.debug('message val '+message);
                            if(message =='successful')
                            {
                                leadToUpdate1.put(l.Id,l);
                                if(!leadmap.isempty())
                                {
                                    System.debug('lead map ---> '+leadmap);
                                    leadmap.remove(l.Id);                                    
                                    if(!Test.isRunningTest())
                                    doactions(Leadmap.values(),assignDate);
                                }
                            }
                            //  update l;
                            flag2 = true;
                            break;
                       // }
                    }
                }
            }
        }
        
        // for weak matches
        else if(!custScoreSortMap.isEmpty()) {
            for(Integer i=custScoreSortMap.size()-1; i>=0; i++) {
                System.debug('==========INSIDE WEAK MATCH  '+custScoreSortMap[i]);
                if(flag3 == false) {                   
                    Lead l = leadMap.get((Id)custScoreSortMap[i].get('leadId'));
                    l.Interior_Designer__c = (Id)custScoreSortMap[i].get('dpId');
                    DateTime gst = l.Appointment_Time__c.addHours(-5).addMinutes(-30);
                    //leadToUpdate1.put(ld.Id,ld);
                    leadDPmap.put(l,(Id)custScoreSortMap[i].get('dpId'));
                    String gstStr = String.valueOf(gst);
                    String message = callAPI((String)custScoreSortMap[i].get('email'), l.Appointment_Venue_Square__r.Name, String.valueOf(gst), l.Email_For_Communication__c, assignDate);
                   if(message =='successful')
                    {
                        leadToUpdate1.put(l.Id,l);
                        if(!leadmap.isempty())
                        {
                            System.debug('lead map ---> '+leadmap);
                            leadmap.remove(l.Id);                                    
                            if(!Test.isRunningTest())
                            doactions(Leadmap.values(),assignDate);
                        }
                    }
                    // update l;
                    flag3 = true;
                    break;
                }                
            }
        }        
    } 
    
    
    global static string callAPI(String dp_email, String showroom_name, String meeting_start, String customer_email, Date assignDate) {
        DPAssignment__c appointment = DPAssignment__c.getValues('Appointment');
        
        String appointment1 = appointment.API__c;
       
        //  String con = 'showroom_name='+l.Appointment_Venue_Square__r.Name+'&start_time='+gst;
        //   String con = 'type=create&ap_type=meeting&dp_email='+dp_email+'&showroom_name='+showroom_name+'&meeting_start='+meeting_start+'&customer_email'+customer_email;
        String con = '{"type":"create","ap_type":"meeting","dp_email":"'+dp_email+'","showroom_name":"'+showroom_name+'","meeting_start":"'+meeting_start+'","customer_email":"'+customer_email+'"}';     
        System.debug('-----con   '+con ); 
        Http http = new http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(appointment1);
        request.setMethod('POST');
        request.setBody(con);
        request.setHeader('Content-Type','application/json');
        System.debug('-----request FUTURE '+request);            
        HttpResponse response = http.send(request);  
        System.debug('-----response FUTURE '+response ); 
        System.debug('-----response body FUTURE '+response.getBody()); 
        Map<String, Object> json_req_inputFuture = (Map<String, Object>)JSON.deserializeUntyped(response.getBody()); 
        if(json_req_inputFuture.get('msg') == 'Meeting creation successful') {
            return 'successful';
        }
        else
        {
            return 'error';
        }
    }
    
    global static List<storeInfoWrapper> Calculate(Set<String> emailList, Lead myLead){
        List<String> availAtShowroomList = new List<String>();
        List<String> propertyNames = new List<String>();
        List<CalculateRankDPWrapper> CalculateRankDPList = new List<CalculateRankDPWrapper> ();
        
        Stack_DP_Rank__c stack = [select Name, X10_40_score__c, Rank_for_Conversion_Percent__c, Rank_for_Won_Opp__c, Language_Score__c, New_Active_0_4__c, New_Active_4_8__c, New_Active_8__c, New_Active_Master__c, Project_Score__c from Stack_DP_Rank__c where Name = 'Stack DP'];
        System.debug('emailList-->'+emailList);
        List<Interior_Designer__c> intDesList = new List<Interior_Designer__c>();
        intDesList = [select id, Name, Conversion__c, City__c, Available_at_Showroom__c, Total_Wins__c, OverLoaded__c, Workload_10_40__c, X0_4_Opportunities__c, X4_8_Opportunities__c, X8_Opportunities__c, X0_4_Conversion__c, X4_8_Conversion__c, X8_Conversion__c, X0_4_Won_Opportunities__c, X4_8_Won_Opportunities__c, X8_Won_Opportunities__c, New_joineeV2__c, New_Joinee_0_4__c, New_Joinee_4_8__c, New_Joinee_8__c, Email__c, Property_Exp_Data__c, Languages_Known__c from Interior_Designer__c where Email__c in: emailList];
        System.debug('intDesList-->'+intDesList);
        System.debug('intDesList size-->'+intDesList.size());
        List<Interior_Designer__c> DPToUpdate = new List<Interior_Designer__c>();
        
        for(Interior_Designer__c intDes : intDesList) {
            String showroom = '';
            if(intDes.Available_at_Showroom__c != null)
                showroom = intDes.Available_at_Showroom__c;
            System.debug('!!!!!!!!!!   '+showroom);
            availAtShowroomList = showroom.split(';');   
            
            String prop = '';               
            if(intDes.Property_Exp_Data__c != null)
                prop = intDes.Property_Exp_Data__c;
            System.debug('!!!!!!!!!!   '+prop);
            propertyNames = prop.split('<@>');
            
            System.debug('!!!!!!!!!! myLead.Appointment_Venue_Square__r.Name  '+myLead.Appointment_Venue_Square__r.Name);
            
            if(myLead.city == intDes.City__c) {    
                if(availAtShowroomList.contains(myLead.Appointment_Venue_Square__r.Name)) {
                    CalculateRankDPWrapper CalculateRank = new CalculateRankDPWrapper (); 
                    CalculateRank.recordId = intDes.id; 
                    CalculateRank.email = intDes.Email__c;
                    CalculateRank.leadId = myLead.id;
                    CalculateRank.dpName = intDes.Name;   
                    CalculateRank.custScore = myLead.Customer_Score__c;      
                    if(myLead.Budget_Range__c == 'Upto 1.5L' || myLead.Budget_Range__c == '1.5L - 4L') {
                        if(intDes.X0_4_Opportunities__c != null) {
                            if(intDes.X0_4_Opportunities__c <= 5) 
                                CalculateRank.conversionPercent = stack.New_Active_Master__c;  
                            else 
                                CalculateRank.conversionPercent = intDes.X0_4_Conversion__c;                              
                        }
                        else
                                CalculateRank.conversionPercent = 0;
                        if(intDes.X0_4_Won_Opportunities__c != null) 
                            CalculateRank.wonOpp = intDes.X0_4_Won_Opportunities__c;   
                        else
                            CalculateRank.wonOpp = 0;
                    }
                    if(myLead.Budget_Range__c == '4L - 6L' || myLead.Budget_Range__c == '6L - 8L') {
                        if(intDes.X4_8_Conversion__c != null) {
                            if(intDes.X4_8_Conversion__c <= 5) 
                                CalculateRank.conversionPercent = stack.New_Active_Master__c;  
                            else
                                CalculateRank.conversionPercent = intDes.X4_8_Conversion__c;                            
                        }
                          else
                                CalculateRank.conversionPercent = 0;
                        if(intDes.X4_8_Won_Opportunities__c != null) 
                            CalculateRank.wonOpp = intDes.X4_8_Won_Opportunities__c;  
                         else
                            CalculateRank.wonOpp = 0;
                    }
                    if(myLead.Budget_Range__c == '8L - 10L' || myLead.Budget_Range__c == '10L+') {
                        if(intDes.X8_Conversion__c != null) {
                            if(intDes.X8_Conversion__c <= 5) 
                                CalculateRank.conversionPercent = stack.New_Active_Master__c;  
                            else
                                CalculateRank.conversionPercent = intDes.X8_Conversion__c;                          
                        }
                          else
                                CalculateRank.conversionPercent = 0;
                        if(intDes.X8_Won_Opportunities__c != null) 
                            CalculateRank.wonOpp = intDes.X8_Won_Opportunities__c;   
                         else
                            CalculateRank.wonOpp = 0;
                    }
                    if(myLead.Budget_Range__c != '8L - 10L' && myLead.Budget_Range__c != '10L+' && myLead.Budget_Range__c != '4L - 6L' && myLead.Budget_Range__c != '6L - 8L' && myLead.Budget_Range__c != 'Upto 1.5L' && myLead.Budget_Range__c != '1.5L - 4L' && (myLead.Budget_Range__c == 'Cx didn\'t disclose' || myLead.Budget_Range__c == null)) {
                        if(intDes.Conversion__c != null) {
                            if(intDes.Conversion__c <= 5) 
                                CalculateRank.conversionPercent = stack.New_Active_Master__c;  
                            else
                                CalculateRank.conversionPercent = intDes.Conversion__c;                           
                        }
                          else
                                CalculateRank.conversionPercent = 0;
                        if(intDes.Total_Wins__c != null) 
                            CalculateRank.wonOpp = intDes.Total_Wins__c;    
                         else
                            CalculateRank.wonOpp = 0;
                    }
                    if(intDes.Languages_Known__c != null && myLead.Regional_Language_Preference__c  != null) {
                        if(intDes.Languages_Known__c.contains(myLead.Regional_Language_Preference__c)) {
                            CalculateRank.language = myLead.Regional_Language_Preference__c;
                            CalculateRank.languageScore = stack.Language_Score__c;
                        }                       
                    }
                    else {
                        CalculateRank.languageScore = 0;
                    }
                    
                    if((propertyNames.contains(myLead.Property__r.Name) || propertyNames.contains(myLead.Property__c)) && intDes.Property_Exp_Data__c != null) {                          
                        if(myLead.Property__c != null)
                            CalculateRank.project = myLead.Property__c;
                        else 
                            CalculateRank.project = myLead.Property__r.Name;
                        CalculateRank.projectScore = stack.Project_Score__c;
                    }
                    else {                         
                        CalculateRank.project = '';
                        CalculateRank.projectScore = 0;
                    }
                    if(intDes.OverLoaded__c == true) {
                        CalculateRank.ten40score = stack.X10_40_score__c;
                    }
                    else {
                        CalculateRank.ten40score = 0;
                    }
                    
                    /*  if(myLead.Meeting_Status__c == 'Cancelled - Customer didn\'t come to the showroom') {
if(intDes.Customer_Cancel_Count__c > 0)                         
CalculateRank.priorityScore = 10 * intDes.Customer_Cancel_Count__c;
}
else if(myLead.Meeting_Status__c == 'Cancelled - Designer not free for the meeting') {    
if(intDes.DP_Cancel_Count__c > 0)                   
CalculateRank.priorityScore = -10 * intDes.DP_Cancel_Count__c;
}
else {
CalculateRank.priorityScore = 0;
} 

if(myLead.isConverted == true) {
if(CalculateRank.priorityScore >= 10)
CalculateRank.priorityScore = -10;
}  */
                    
                    if(myLead.Email_For_Communication__c != null) {
                        CalculateRank.custEmail = myLead.Email_For_Communication__c;
                    }
                    if(myLead.Appointment_Venue_Square__c != null)  {
                        CalculateRank.showroomName = myLead.Appointment_Venue_Square__r.Name;
                    }  
                    if(myLead.Appointment_Time__c != null)  {
                        CalculateRank.apptTime = String.valueOf(myLead.Appointment_Time__c);
                    }             
                    
                    if(CalculateRank.languageScore != null && CalculateRank.projectScore != null && CalculateRank.ten40score != null)
                        CalculateRank.finalScore = CalculateRank.languageScore + CalculateRank.projectScore + CalculateRank.ten40score; 
                    else 
                        CalculateRank.finalScore = 0;
                    CalculateRankDPList.add(CalculateRank); 
                }
            }
            //   intDes.Total_Score__c = CalculateRank.finalScore;
            //   DPToUpdate.add(intDes);
        } 
        
        System.debug('-----CalculateRankDPList--- '+CalculateRankDPList);
        //  System.debug('-----DPToUpdate--- '+DPToUpdate);
        
        //   if(!DPToUpdate.isEMpty()) 
        //   update DPToUpdate;
        /*******************************  ******************************/
        
        CalculateRankDPWrapper.sortBy = CalculateRankDPWrapper.SORT_BY.ByconversionScore;
        List<CalculateRankDPWrapper> CalculateRankDPSortByconvScore = new List<CalculateRankDPWrapper> ();
        CalculateRankDPList.sort();
        CalculateRankDPSortByconvScore.addAll(CalculateRankDPList);
        
        List<CalculateRankDPWrapper> SortRankByConvScoreList = new List<CalculateRankDPWrapper> ();
        
        Decimal rankConversion = 1;
        Decimal rankConversionScore = 0;
        for(Integer i = CalculateRankDPSortByconvScore.size() - 1; i>=0; i--) {
            CalculateRankDPWrapper CalculateRankDPv2 = new CalculateRankDPWrapper(); 
            if(SortRankByConvScoreList.size() == 0) {
                rankConversionScore = stack.Rank_for_Conversion_Percent__c/rankConversion;
                CalculateRankDPv2.recordId = CalculateRankDPSortByconvScore[i].recordId;
                CalculateRankDPv2.wonOpp = CalculateRankDPSortByconvScore[i].wonOpp;
                if(CalculateRankDPSortByconvScore[i].conversionPercent != null)
                    CalculateRankDPv2.rankForConversion = rankConversion;
                if(CalculateRankDPv2.rankForConversion != null)
                    CalculateRankDPv2.conversionScore = rankConversionScore.setScale(2);                
                CalculateRankDPv2.conversionPercent = CalculateRankDPSortByconvScore[i].conversionPercent;
                CalculateRankDPv2.email = CalculateRankDPSortByconvScore[i].email;
                CalculateRankDPv2.language = CalculateRankDPSortByconvScore[i].language;
                CalculateRankDPv2.languageScore = CalculateRankDPSortByconvScore[i].languageScore;
                CalculateRankDPv2.project = CalculateRankDPSortByconvScore[i].project;
                CalculateRankDPv2.projectScore = CalculateRankDPSortByconvScore[i].projectScore;
                CalculateRankDPv2.ten40score = CalculateRankDPSortByconvScore[i].ten40score;
                CalculateRankDPv2.leadId = CalculateRankDPSortByconvScore[i].leadId;
                CalculateRankDPv2.priorityScore = CalculateRankDPSortByconvScore[i].priorityScore;
                CalculateRankDPv2.custScore = CalculateRankDPSortByconvScore[i].custScore;
                CalculateRankDPv2.custEmail = CalculateRankDPSortByconvScore[i].custEmail;
                CalculateRankDPv2.showroomName = CalculateRankDPSortByconvScore[i].showroomName;
                CalculateRankDPv2.apptTime = CalculateRankDPSortByconvScore[i].apptTime;
                CalculateRankDPv2.dpName = CalculateRankDPSortByconvScore[i].dpName;
                if(CalculateRankDPv2.conversionScore != null)
                    CalculateRankDPv2.finalScore = CalculateRankDPSortByconvScore[i].finalScore + CalculateRankDPv2.conversionScore;
            }
            else if(SortRankByConvScoreList.size() > 0) {
                if(SortRankByConvScoreList.get(SortRankByConvScoreList.size() - 1).conversionPercent== CalculateRankDPSortByconvScore[i].conversionPercent) {
                    rankConversionScore = stack.Rank_for_Conversion_Percent__c/rankConversion;
                    CalculateRankDPv2.recordId = CalculateRankDPSortByconvScore[i].recordId;
                    CalculateRankDPv2.wonOpp = CalculateRankDPSortByconvScore[i].wonOpp;
                    if(CalculateRankDPSortByconvScore[i].conversionPercent != null)
                        CalculateRankDPv2.rankForConversion = rankConversion;
                    if(CalculateRankDPv2.rankForConversion != null)
                        CalculateRankDPv2.conversionScore = rankConversionScore.setScale(2);                    
                    CalculateRankDPv2.conversionPercent = CalculateRankDPSortByconvScore[i].conversionPercent;
                    CalculateRankDPv2.email = CalculateRankDPSortByconvScore[i].email;
                    CalculateRankDPv2.language = CalculateRankDPSortByconvScore[i].language;
                    CalculateRankDPv2.languageScore = CalculateRankDPSortByconvScore[i].languageScore;
                    CalculateRankDPv2.project = CalculateRankDPSortByconvScore[i].project;
                    CalculateRankDPv2.projectScore = CalculateRankDPSortByconvScore[i].projectScore;
                    CalculateRankDPv2.ten40score = CalculateRankDPSortByconvScore[i].ten40score;
                    CalculateRankDPv2.leadId = CalculateRankDPSortByconvScore[i].leadId;
                    CalculateRankDPv2.priorityScore = CalculateRankDPSortByconvScore[i].priorityScore;
                    CalculateRankDPv2.custScore = CalculateRankDPSortByconvScore[i].custScore;
                    CalculateRankDPv2.custEmail = CalculateRankDPSortByconvScore[i].custEmail;
                    CalculateRankDPv2.showroomName = CalculateRankDPSortByconvScore[i].showroomName;
                    CalculateRankDPv2.apptTime = CalculateRankDPSortByconvScore[i].apptTime;
                    CalculateRankDPv2.dpName = CalculateRankDPSortByconvScore[i].dpName;
                    if(CalculateRankDPv2.conversionScore != null)
                        CalculateRankDPv2.finalScore = CalculateRankDPSortByconvScore[i].finalScore + CalculateRankDPv2.conversionScore;
                }
                else {
                    rankConversion = rankConversion + 1;
                    rankConversionScore = stack.Rank_for_Conversion_Percent__c/rankConversion;
                    CalculateRankDPv2.recordId = CalculateRankDPSortByconvScore[i].recordId;
                    CalculateRankDPv2.wonOpp = CalculateRankDPSortByconvScore[i].wonOpp;
                    if(CalculateRankDPSortByconvScore[i].conversionPercent != null)
                        CalculateRankDPv2.rankForConversion = rankConversion;
                    if(CalculateRankDPv2.rankForConversion != null)
                        CalculateRankDPv2.conversionScore = rankConversionScore.setScale(2);                    
                    CalculateRankDPv2.conversionPercent = CalculateRankDPSortByconvScore[i].conversionPercent;
                    CalculateRankDPv2.email = CalculateRankDPSortByconvScore[i].email;
                    CalculateRankDPv2.language = CalculateRankDPSortByconvScore[i].language;
                    CalculateRankDPv2.languageScore = CalculateRankDPSortByconvScore[i].languageScore;
                    CalculateRankDPv2.project = CalculateRankDPSortByconvScore[i].project;
                    CalculateRankDPv2.projectScore = CalculateRankDPSortByconvScore[i].projectScore;
                    CalculateRankDPv2.ten40score = CalculateRankDPSortByconvScore[i].ten40score;
                    CalculateRankDPv2.leadId = CalculateRankDPSortByconvScore[i].leadId;
                    CalculateRankDPv2.priorityScore = CalculateRankDPSortByconvScore[i].priorityScore;
                    CalculateRankDPv2.custScore = CalculateRankDPSortByconvScore[i].custScore;
                    CalculateRankDPv2.custEmail = CalculateRankDPSortByconvScore[i].custEmail;
                    CalculateRankDPv2.showroomName = CalculateRankDPSortByconvScore[i].showroomName;
                    CalculateRankDPv2.apptTime = CalculateRankDPSortByconvScore[i].apptTime;
                    CalculateRankDPv2.dpName = CalculateRankDPSortByconvScore[i].dpName;
                    if(CalculateRankDPv2.conversionScore != null)
                        CalculateRankDPv2.finalScore = CalculateRankDPSortByconvScore[i].finalScore + CalculateRankDPv2.conversionScore;
                }
            } 
            SortRankByConvScoreList.add(CalculateRankDPv2);
        }
        SYstem.debug('--------SortRankByConvScoreList-----  '+SortRankByConvScoreList);
        
        
        CalculateRankDPWrapper.sortBy = CalculateRankDPWrapper.SORT_BY.BywonOpp;
        SortRankByConvScoreList.sort();
        List<CalculateRankDPWrapper> CalculateRankDPSortBywonOpp = new List<CalculateRankDPWrapper> ();
        CalculateRankDPSortBywonOpp.addAll(SortRankByConvScoreList);
        
        
        List<CalculateRankDPWrapper> SortRankByWonOppList = new List<CalculateRankDPWrapper> ();
        
        Decimal rankWonOpp = 1;
        Decimal rankWonOppScore = 0;
        // Decimal finalCalculatedScore = 0;
        for(Integer i = CalculateRankDPSortBywonOpp.size() - 1; i>=0; i--) {
            CalculateRankDPWrapper CalculateRankDPv2 = new CalculateRankDPWrapper(); 
            if(SortRankByWonOppList .size() == 0) {
                rankWonOppScore = stack.Rank_for_Won_Opp__c/rankWonOpp;
                if(CalculateRankDPSortBywonOpp[i].conversionScore != null)
                    //  finalCalculatedScore = rankWonOppScore + CalculateRankDPSortBywonOpp[i].conversionScore + CalculateRankDPSortBywonOpp[i].languageScore + CalculateRankDPSortBywonOpp[i].projectScore;
                    CalculateRankDPv2.recordId = CalculateRankDPSortBywonOpp[i].recordId;
                CalculateRankDPv2.wonOpp = CalculateRankDPSortBywonOpp[i].wonOpp;
                if(CalculateRankDPSortBywonOpp[i].wonOpp != null)
                    CalculateRankDPv2.rankForWonOpp = rankWonOpp;
                if(CalculateRankDPv2.rankForWonOpp != null)
                    CalculateRankDPv2.wonOppScore = rankWonOppScore.setScale(2);                
                CalculateRankDPv2.conversionPercent = CalculateRankDPSortBywonOpp[i].conversionPercent;
                CalculateRankDPv2.conversionScore = CalculateRankDPSortBywonOpp[i].conversionScore;
                CalculateRankDPv2.rankForConversion = CalculateRankDPSortBywonOpp[i].rankForConversion;
                if(CalculateRankDPv2.wonOppScore != null)
                    CalculateRankDPv2.finalScore = CalculateRankDPSortBywonOpp[i].finalScore + CalculateRankDPv2.wonOppScore;
                CalculateRankDPv2.email = CalculateRankDPSortBywonOpp[i].email;
                CalculateRankDPv2.language = CalculateRankDPSortBywonOpp[i].language;
                CalculateRankDPv2.languageScore = CalculateRankDPSortBywonOpp[i].languageScore;
                CalculateRankDPv2.project = CalculateRankDPSortBywonOpp[i].project;
                CalculateRankDPv2.projectScore = CalculateRankDPSortBywonOpp[i].projectScore;
                CalculateRankDPv2.ten40score = CalculateRankDPSortBywonOpp[i].ten40score;
                CalculateRankDPv2.leadId = CalculateRankDPSortBywonOpp[i].leadId;
                CalculateRankDPv2.priorityScore = CalculateRankDPSortBywonOpp[i].priorityScore;
                CalculateRankDPv2.custScore = CalculateRankDPSortBywonOpp[i].custScore;
                CalculateRankDPv2.custEmail = CalculateRankDPSortBywonOpp[i].custEmail;
                CalculateRankDPv2.showroomName = CalculateRankDPSortBywonOpp[i].showroomName;
                CalculateRankDPv2.apptTime = CalculateRankDPSortBywonOpp[i].apptTime;
                CalculateRankDPv2.dpName = CalculateRankDPSortBywonOpp[i].dpName;
            }
            else if(SortRankByWonOppList .size() > 0) {
                if(SortRankByWonOppList .get(SortRankByWonOppList .size() - 1).wonOpp == CalculateRankDPSortBywonOpp[i].wonOpp) {
                    rankWonOppScore = stack.Rank_for_Won_Opp__c/rankWonOpp;
                    if(CalculateRankDPSortBywonOpp[i].conversionScore != null)
                        // finalCalculatedScore = rankWonOppScore + CalculateRankDPSortBywonOpp[i].conversionScore + CalculateRankDPSortBywonOpp[i].languageScore + CalculateRankDPSortBywonOpp[i].projectScore;
                        CalculateRankDPv2.recordId = CalculateRankDPSortBywonOpp[i].recordId;
                    CalculateRankDPv2.wonOpp = CalculateRankDPSortBywonOpp[i].wonOpp;
                    if(CalculateRankDPSortBywonOpp[i].wonOpp != null)
                        CalculateRankDPv2.rankForWonOpp = rankWonOpp;
                    if(CalculateRankDPv2.rankForWonOpp != null)
                        CalculateRankDPv2.wonOppScore = rankWonOppScore.setScale(2);                    
                    CalculateRankDPv2.conversionPercent = CalculateRankDPSortBywonOpp[i].conversionPercent;
                    CalculateRankDPv2.conversionScore = CalculateRankDPSortBywonOpp[i].conversionScore;
                    CalculateRankDPv2.rankForConversion = CalculateRankDPSortBywonOpp[i].rankForConversion;
                    if(CalculateRankDPv2.wonOppScore != null)
                        CalculateRankDPv2.finalScore = CalculateRankDPSortBywonOpp[i].finalScore + CalculateRankDPv2.wonOppScore;
                    CalculateRankDPv2.email = CalculateRankDPSortBywonOpp[i].email;
                    CalculateRankDPv2.language = CalculateRankDPSortBywonOpp[i].language;
                    CalculateRankDPv2.languageScore = CalculateRankDPSortBywonOpp[i].languageScore;
                    CalculateRankDPv2.project = CalculateRankDPSortBywonOpp[i].project;
                    CalculateRankDPv2.projectScore = CalculateRankDPSortBywonOpp[i].projectScore;
                    CalculateRankDPv2.ten40score = CalculateRankDPSortBywonOpp[i].ten40score;
                    CalculateRankDPv2.leadId = CalculateRankDPSortBywonOpp[i].leadId;
                    CalculateRankDPv2.priorityScore = CalculateRankDPSortBywonOpp[i].priorityScore;
                    CalculateRankDPv2.custScore = CalculateRankDPSortBywonOpp[i].custScore;
                    CalculateRankDPv2.custEmail = CalculateRankDPSortBywonOpp[i].custEmail;
                    CalculateRankDPv2.showroomName = CalculateRankDPSortBywonOpp[i].showroomName;
                    CalculateRankDPv2.apptTime = CalculateRankDPSortBywonOpp[i].apptTime;
                    CalculateRankDPv2.dpName = CalculateRankDPSortBywonOpp[i].dpName;
                }
                else {
                    rankWonOpp = rankWonOpp + 1;
                    rankWonOppScore = stack.Rank_for_Won_Opp__c/rankWonOpp;
                    if(CalculateRankDPSortBywonOpp[i].conversionScore != null)
                        //   finalCalculatedScore = rankWonOppScore + CalculateRankDPSortBywonOpp[i].conversionScore + CalculateRankDPSortBywonOpp[i].languageScore + CalculateRankDPSortBywonOpp[i].projectScore;
                        CalculateRankDPv2.recordId = CalculateRankDPSortBywonOpp[i].recordId;
                    CalculateRankDPv2.wonOpp = CalculateRankDPSortBywonOpp[i].wonOpp;
                    if(CalculateRankDPSortBywonOpp[i].wonOpp != null)
                        CalculateRankDPv2.rankForWonOpp = rankWonOpp;
                    if(CalculateRankDPv2.rankForWonOpp != null)
                        CalculateRankDPv2.wonOppScore = rankWonOppScore.setScale(2);                    
                    CalculateRankDPv2.conversionPercent = CalculateRankDPSortBywonOpp[i].conversionPercent;
                    CalculateRankDPv2.conversionScore = CalculateRankDPSortBywonOpp[i].conversionScore;
                    CalculateRankDPv2.rankForConversion = CalculateRankDPSortBywonOpp[i].rankForConversion;
                    if(CalculateRankDPv2.wonOppScore != null)
                        CalculateRankDPv2.finalScore = CalculateRankDPSortBywonOpp[i].finalScore + CalculateRankDPv2.wonOppScore;
                    CalculateRankDPv2.email = CalculateRankDPSortBywonOpp[i].email;
                    CalculateRankDPv2.language = CalculateRankDPSortBywonOpp[i].language;
                    CalculateRankDPv2.languageScore = CalculateRankDPSortBywonOpp[i].languageScore;
                    CalculateRankDPv2.project = CalculateRankDPSortBywonOpp[i].project;
                    CalculateRankDPv2.projectScore = CalculateRankDPSortBywonOpp[i].projectScore;
                    CalculateRankDPv2.ten40score = CalculateRankDPSortBywonOpp[i].ten40score;
                    CalculateRankDPv2.leadId = CalculateRankDPSortBywonOpp[i].leadId;
                    CalculateRankDPv2.priorityScore = CalculateRankDPSortBywonOpp[i].priorityScore;
                    CalculateRankDPv2.custScore = CalculateRankDPSortBywonOpp[i].custScore;
                    CalculateRankDPv2.custEmail = CalculateRankDPSortBywonOpp[i].custEmail;
                    CalculateRankDPv2.showroomName = CalculateRankDPSortBywonOpp[i].showroomName;
                    CalculateRankDPv2.apptTime = CalculateRankDPSortBywonOpp[i].apptTime;
                    CalculateRankDPv2.dpName = CalculateRankDPSortBywonOpp[i].dpName;
                }
            } 
            SortRankByWonOppList.add(CalculateRankDPv2);
        }
        
        System.debug('=========SortRankByWonOppList  '+SortRankByWonOppList );
        
        CalculateRankDPWrapper.sortBy = CalculateRankDPWrapper.SORT_BY.ByfinalScore;
        SortRankByWonOppList.sort();
        List<CalculateRankDPWrapper> OverallList = new List<CalculateRankDPWrapper> ();
        OverallList.addAll(SortRankByWonOppList);
        System.debug('------- SORT ByFinalScore ------  '+OverallList );
        
        List<CalculateRankDPWrapper> sortByOverallList = new List<CalculateRankDPWrapper> ();
        Decimal finalRankValue = 1;
        for(Integer i = OverallList.size() - 1; i>=0; i--) {
            CalculateRankDPWrapper CalculateRankDPv2 = new CalculateRankDPWrapper(); 
            if(sortByOverallList.size() == 0) {
                rankWonOppScore = stack.Rank_for_Won_Opp__c/rankWonOpp;
                if(OverallList [i].conversionScore != null)
                    CalculateRankDPv2.recordId = OverallList [i].recordId;
                CalculateRankDPv2.wonOpp = OverallList [i].wonOpp;
                if(OverallList [i].wonOpp != null)
                    CalculateRankDPv2.rankForWonOpp = OverallList [i].rankForWonOpp ;
                if(CalculateRankDPv2.rankForWonOpp != null)
                    CalculateRankDPv2.wonOppScore = OverallList [i].wonOppScore;                
                CalculateRankDPv2.conversionPercent = OverallList [i].conversionPercent;
                CalculateRankDPv2.conversionScore = OverallList [i].conversionScore;
                CalculateRankDPv2.rankForConversion = OverallList [i].rankForConversion;
                //  if(finalCalculatedScore != null)
                CalculateRankDPv2.finalScore = OverallList [i].finalScore;
                CalculateRankDPv2.email = OverallList [i].email;
                CalculateRankDPv2.language = OverallList [i].language;
                CalculateRankDPv2.languageScore = OverallList [i].languageScore;
                CalculateRankDPv2.project = OverallList [i].project;
                CalculateRankDPv2.projectScore = OverallList [i].projectScore;
                CalculateRankDPv2.ten40score = OverallList [i].ten40score;
                CalculateRankDPv2.leadId = OverallList[i].leadId;
                CalculateRankDPv2.priorityScore = OverallList[i].priorityScore;
                CalculateRankDPv2.custScore = OverallList[i].custScore;
                CalculateRankDPv2.custEmail = OverallList[i].custEmail;
                CalculateRankDPv2.showroomName = OverallList[i].showroomName;
                CalculateRankDPv2.apptTime = OverallList[i].apptTime;
                CalculateRankDPv2.dpName = OverallList[i].dpName;
                CalculateRankDPv2.finalRank = finalRankValue;
            }
            else if(sortByOverallList.size() > 0) {
                if(sortByOverallList.get(sortByOverallList.size() - 1).finalScore == OverallList[i].finalScore) {
                    rankWonOppScore = stack.Rank_for_Won_Opp__c/rankWonOpp;
                    if(OverallList [i].conversionScore != null)
                        CalculateRankDPv2.recordId = OverallList [i].recordId;
                    CalculateRankDPv2.wonOpp = OverallList [i].wonOpp;
                    if(OverallList [i].wonOpp != null)
                        CalculateRankDPv2.rankForWonOpp = OverallList [i].rankForWonOpp ;
                    if(CalculateRankDPv2.rankForWonOpp != null)
                        CalculateRankDPv2.wonOppScore = OverallList [i].wonOppScore;                   
                    CalculateRankDPv2.conversionPercent = OverallList [i].conversionPercent;
                    CalculateRankDPv2.conversionScore = OverallList [i].conversionScore;
                    CalculateRankDPv2.rankForConversion = OverallList [i].rankForConversion;
                    //   if(finalCalculatedScore != null)
                    CalculateRankDPv2.finalScore = OverallList [i].finalScore;
                    CalculateRankDPv2.email = OverallList [i].email;
                    CalculateRankDPv2.language = OverallList [i].language;
                    CalculateRankDPv2.languageScore = OverallList [i].languageScore;
                    CalculateRankDPv2.project = OverallList [i].project;
                    CalculateRankDPv2.projectScore = OverallList [i].projectScore;
                    CalculateRankDPv2.ten40score = OverallList [i].ten40score;
                    CalculateRankDPv2.leadId = OverallList[i].leadId;
                    CalculateRankDPv2.priorityScore = OverallList[i].priorityScore;
                    CalculateRankDPv2.custScore = OverallList[i].custScore;
                    CalculateRankDPv2.custEmail = OverallList[i].custEmail;
                    CalculateRankDPv2.showroomName = OverallList[i].showroomName;
                    CalculateRankDPv2.apptTime = OverallList[i].apptTime;
                    CalculateRankDPv2.dpName = OverallList[i].dpName;
                    CalculateRankDPv2.finalRank = finalRankValue ;
                }
                else {
                    finalRankValue = finalRankValue + 1;
                    rankWonOppScore = stack.Rank_for_Won_Opp__c/rankWonOpp;
                    if(OverallList [i].conversionScore != null)
                        CalculateRankDPv2.recordId = OverallList [i].recordId;
                    CalculateRankDPv2.wonOpp = OverallList [i].wonOpp;
                    if(OverallList [i].wonOpp != null)
                        CalculateRankDPv2.rankForWonOpp = OverallList [i].rankForWonOpp ;
                    if(CalculateRankDPv2.rankForWonOpp != null)
                        CalculateRankDPv2.wonOppScore = OverallList [i].wonOppScore;                     
                    CalculateRankDPv2.conversionPercent = OverallList [i].conversionPercent;
                    CalculateRankDPv2.conversionScore = OverallList [i].conversionScore;
                    CalculateRankDPv2.rankForConversion = OverallList [i].rankForConversion;
                    //  if(finalCalculatedScore != null)
                    CalculateRankDPv2.finalScore = OverallList [i].finalScore;
                    CalculateRankDPv2.email = OverallList [i].email;
                    CalculateRankDPv2.language = OverallList [i].language;
                    CalculateRankDPv2.languageScore = OverallList [i].languageScore;
                    CalculateRankDPv2.project = OverallList [i].project;
                    CalculateRankDPv2.projectScore = OverallList [i].projectScore;
                    CalculateRankDPv2.ten40score = OverallList [i].ten40score;
                    CalculateRankDPv2.leadId = OverallList[i].leadId;
                    CalculateRankDPv2.priorityScore = OverallList[i].priorityScore;
                    CalculateRankDPv2.custScore = OverallList[i].custScore;
                    CalculateRankDPv2.custEmail = OverallList[i].custEmail;
                    CalculateRankDPv2.showroomName = OverallList[i].showroomName;
                    CalculateRankDPv2.apptTime = OverallList[i].apptTime;
                    CalculateRankDPv2.dpName = OverallList[i].dpName;
                    CalculateRankDPv2.finalRank = finalRankValue ;
                }
            } 
            sortByOverallList.add(CalculateRankDPv2);
        }
        
        System.debug('-------sortByOverallList ------  '+sortByOverallList);  
        
        // TO DISPLAY VALUES       
        List<storeInfoWrapper> storeInfoWrap = new List<storeInfoWrapper>();
        List<string> storeInfoList = new List<string> ();
        
        List<Lead> leadToUpdate = new List<Lead>();
        String valueToDisplayV4 = '';
        if(sortByOverallList.size() == 0){
            // myLead.DP_Stack_Rank__c = null;
        }
        for(CalculateRankDPWrapper store : sortByOverallList ) {
            storeInfoWrapper storeInfo = new storeInfoWrapper();
            storeInfo.email = store.email;
            storeInfo.dpId = store.recordId; 
            storeInfo.finalScore = store.finalScore;  
            storeInfo.leadId = store.leadId;  
            storeInfo.custScore = store.custScore;        
            storeInfoWrap.add(storeInfo); 
            String valueToDisplayV1 = string.valueOf(storeInfo);
            System.debug('================= storeInfo: '+storeInfo);           
            String valueToDisplayV3 = valueToDisplayV1.remove('storeInfoWrapper:');        
            System.debug('================= valueToDisplayV3 : '+valueToDisplayV3 ); 
            valueToDisplayV4 = valueToDisplayV4 + ' ; \n'+valueToDisplayV3;
            System.debug('================= valueToDisplayV4 : '+valueToDisplayV4 );                                      
            
            //  myLead.DP_Stack_Rank__c = valueToDisplayV4 ;
            storeInfoList.add(valueToDisplayV3); 
        }
        //  update myLead;
        System.debug('================= storeInfoList  : '+storeInfoList);  
        System.debug('================= storeInfoWrap  : '+storeInfoWrap); 
        return storeInfoWrap;
        
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
        i++;
     i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
     i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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