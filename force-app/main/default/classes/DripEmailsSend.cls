global class DripEmailsSend implements Database.Batchable <sObject> , Database.AllowsCallouts{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Drip_Emails__c drip = [select Name, No_of_days__c, No_of_Email_Templates__c from Drip_Emails__c where Name = 'Drip Email'];
        return Database.getQueryLocator([select id, name, email, city, createdDate from Lead where 
createdDate >=:(Date.Today().addDays(-Integer.valueOf(drip.No_of_Email_Templates__c)*Integer.valueOf(drip.No_of_days__c))) and createdDate <=: Date.Today()]);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        Drip_Emails__c drip = [select Name, No_of_days__c, No_of_Email_Templates__c from Drip_Emails__c where Name = 'Drip Email'];
        List<Lead> leadList = (List<sObject>)(scope);
        System.debug('-------------SCOPE : '+scope);
        
        Boolean flag = false;
        for(Lead myLead : leadList) {
            if(Date.today() == myLead.createdDate.date().addDays(Integer.valueOf(drip.No_of_days__c)*1)) {
                mandril('Email_2_Welcome-message-2', 'Doing home interiors should be fun!', myLead.Email);             
            } 
                     
        else if(Date.today() == myLead.createdDate.date().addDays(Integer.valueOf(drip.No_of_days__c)*2)) {
                if(myLead.City == 'Chennai') 
                mandril('Email_4_Did-not-respond-to-calls-CHENNAI', 'Visit us at our Experience Centre in your city', myLead.Email);
                else if(myLead.City == 'Gurgaon')
                mandril('Email_4_Did-not-respond-to-calls-GURUGRAM', 'Visit us at our Experience Centre in your city', myLead.Email);
                else if(myLead.City == 'Hyderabad')
                mandril('Email_4_Did-not-respond-to-calls-HYDERABAD', 'Visit us at our Experience Centre in your city', myLead.Email);
                else if(myLead.City == 'Mumbai' || myLead.City == 'Thane')
                mandril('Email_4_Did-not-respond-to-calls-MUMBAI', 'Visit us at our Experience Centre in your city', myLead.Email);
                else if(myLead.City == 'Bengaluru')
                mandril('Email_4_Did-not-respond-to-calls', 'Visit us at our Experience Centre in your city', myLead.Email);
                
             }         
          
           else if(Date.today() == myLead.createdDate.date().addDays(Integer.valueOf(drip.No_of_days__c)*3)) {
                mandril('Email_5_Did-not-confirm', 'We make beautiful home interiors for you.', myLead.Email);
               }           
        
           else if(Date.today() == myLead.createdDate.date().addDays(Integer.valueOf(drip.No_of_days__c)*4)) {
                mandril('Email_6_Confirms_meeting', 'Do you know how we help you build beautiful homes?', myLead.Email);
                }            
          
          else if(Date.today() == myLead.createdDate.date().addDays(Integer.valueOf(drip.No_of_days__c)*5)) {
                mandril('Email_8_Does-not-turn-up-for-the-meeting', 'Your guide to beautiful home interiors. Read now.', myLead.Email);
              }           
          
          else if(Date.today() == myLead.createdDate.date().addDays(Integer.valueOf(drip.No_of_days__c)*6)) {
           System.debug('----I AM IN DAY 6');
                mandril('Email_9_Turns-up-for-the-meeting-and-talks', 'Have you met your HomeLane design expert yet?', myLead.Email);
            }   
                        
           else if(Date.today() == myLead.createdDate.date().addDays(Integer.valueOf(drip.No_of_days__c)*7)) {
               System.debug('-------7 days ');
                mandril('Email_10_Call-for-the-second-meeting', 'Seems like a lot of work? It\'s not!', myLead.Email);
            }        
          
          else if(Date.today() == myLead.createdDate.date().addDays(Integer.valueOf(drip.No_of_days__c)*8)) {
                mandril('Email_11_Gets-reminder-for-the-second-meeting', 'Home interiors is a bit of science and bit of art!', myLead.Email);
             }         
          
          else if(Date.today() == myLead.createdDate.date().addDays(Integer.valueOf(drip.No_of_days__c)*9)) {
                mandril('Email_12_Does-not-turn-up-for-the-second-meeting', 'Here\'s why our design experts are the best!', myLead.Email);
           }            
          
          else if(Date.today() == myLead.createdDate.date().addDays(Integer.valueOf(drip.No_of_days__c)*10)) {
                mandril('Email_13_Meets-the-designer-for-the-second-time', 'Expert tips to get you closer to beautiful home interiors', myLead.Email);
              }           
        }    
    }
  
    global void finish(Database.BatchableContext BC) {
    
    }
    
    global static void mandril(String template, String subject, String email) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //request.setEndpoint('https://mandrillapp.com/api/1.0/messages/send-template.json');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setTimeout(20000);
        // Set the body as a JSON object
      //  request.setBody('{"key": "xhJxn_DI9P1L9lu3CLHfjQ","template_name": "'+template+'","template_content": [ {"name": "example name","content": "example content" }], "message": {"html": "<p>Example HTML content</p>","text": "Example text content","subject": "'+subject+'","from_email": "message.from_email@example.com","from_name": "Homelane","to": [{"email": "'+email+'","name": "Recipient Name","type": "to"}],"headers": {"Reply-To": "message.reply@example.com"},"important": false,"track_opens": null,"track_clicks": null,"auto_text": null,"auto_html": null, "inline_css": null,"url_strip_qs": null, "preserve_recipients": null,"view_content_link": null,"bcc_address": "message.bcc_address@example.com","tracking_domain": null,"signing_domain": null,"return_path_domain": null,"merge": true,"merge_language": "mailchimp","global_merge_vars": [{"name": "merge1","content": "merge1 content"}],"merge_vars": [{"rcpt": "recipient.email@example.com","vars": [ {"name": "merge2", "content": "merge2 content"}]}],"tags": ["password-resets"],"google_analytics_domains": ["example.com"],"google_analytics_campaign": "message.from_email@example.com","metadata": {"website": "www.example.com"},"recipient_metadata": [ {"rcpt": "recipient.email@example.com","values": {"user_id": 123456} }]},"async": false, "ip_pool": "Main Pool","send_at": "2018-08-01"}');
       
        request.setBody('{"key": "xhJxn_DI9P1L9lu3CLHfjQ","template_name": "'+template+'","template_content": [ {"name": "example name","content": "example content" }], "message": {"html": "<p>Example HTML content</p>","text": "Example text content","subject": "'+subject+'","from_email": "Homelane@homelane.com","to": [{"email": "'+email+'","name": "Recipient Name","type": "to"}],"headers": {"Reply-To": ""},"important": false,"track_opens": null,"track_clicks": null,"auto_text": null,"auto_html": null, "inline_css": null,"url_strip_qs": null, "preserve_recipients": null,"view_content_link": null,"bcc_address": "message.bcc_address@example.com","tracking_domain": null,"signing_domain": null,"return_path_domain": null,"merge": true,"merge_language": "mailchimp","global_merge_vars": [{"name": "merge1","content": "merge1 content"}],"merge_vars": [{"rcpt": "recipient.email@example.com","vars": [ {"name": "merge2", "content": "merge2 content"}]}],"tags": ["password-resets"],"google_analytics_domains": ["example.com"],"google_analytics_campaign": "message.from_email@example.com","metadata": {"website": "www.example.com"},"recipient_metadata": [ {"rcpt": "recipient.email@example.com","values": {"user_id": 123456} }]},"async": false, "ip_pool": "Main Pool","send_at": "2018-08-01"}');
        if(!Test.isRunningTest()) {
        HttpResponse response = http.send(request); 
        // Parse the JSON response
        System.debug('RESPONSE IS  : '+response+'  BODY IS  '+response.getBody());
        }
    }
}