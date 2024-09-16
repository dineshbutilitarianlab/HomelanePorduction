@isTest 
public class CloudAgentAPIController_Test {
public static ByPassValidation__c mc = new ByPassValidation__c();
    public static testMethod void test() {
        
        mc.IsTrue__c = true;
        insert mc;
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
         User wta_user = new User(alias = 'ozone12', email='ozcloudznesertest@homelane.com',
                emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ozcloudznesertest@homelane.com',Cloud_Agent_Campaign_Name__c= 'Adnan_AutoLead');
        insert wta_user;
         
        
         Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Noida';
        insert objRA;
        
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.WT_Agent__c = wta_user.Id;
         leadRec1.email = 'sakf@dfjkc.com';
         leadRec1.phone = '6291029375';
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Calculated_WT_allocated_time__c = null;
         leadRec1.Description__c = 'ehllo';
         leadRec1.Ameyo_Call_Attempts__c = 0;
         leadRec1.WT_Agent_Allocated_Time__c = null;
         insert leadRec1;  
        
        Messaging.SingleEmailMessage Message = new Messaging.SingleEmailMessage(); 
        message.setTargetObjectId(UserInfo.getUserId());
        message.setSaveAsActivity(false);
        message.setSubject('dear diary');
        message.setPlainTextBody('he who controls the spice');
        Messaging.sendEmail(new List<Messaging.Email>{Message}); 
         
        Task t = new Task(subject = 'Manual - 4139154601393821', CallDisposition = 'Unable_to_Connect', Disposition_Type__c = 'Couldn\'t_Contact');
        insert t;
        
        Test.startTest();
        String json = '{"monitorUCID": "4139154601393821", "UUI": "6291029375", "Did": "918068280901", "CampaignName": "Adnan_AutoLead", "Location": "Bangalore", "CallerID": "06291029375", "PhoneName": "20133", "Skill": "Adnan_AutoLead", "StartTime": "2018-12-28 21:48:59", "EndTime": "2018-12-28 21:49:43", "TimeToAnswer": "00:00:10", "CallDuration": "00:00:44", "Duration": "00:00:34", "FallBackRule": "AgentDial", "DialedNumber": "20133", "Type": "Progressive", "AgentID": "test@abc.com -> ozcloudznesertest@homelane.com", "AgentPhoneNumber": "20133", "AgentUniqueID": "70437", "AgentName": "testozone", "Disposition": "Couldn\'t_Contact", "HangupBy": "UserHangup", "Status": "Answered", "AudioFile": "http://recordings.kookoo.in/HomeLane/HomeLane_4139154601393821.mp3", "TransferType": "No Transfers", "TransferredTo": "", "Comments": "", "DialStatus": "answered", "Apikey": "KK1974dd56933b4c69602c063d589e19ab", "AgentStatus": "answered", "CustomerStatus": "answered", "UserName": "homelane", "CallerConfAudioFile": "", "ConfDuration": "00:00:00", "CampaignStatus": "ONLINE"}';
        RestRequest req = new Restrequest();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =  '/services/apexrest/CloudAgentPostProcessingAPI';
        req.HTTPMethod = 'POST'; 
        req.requestBody = Blob.valueof(json);
        
        
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        CloudAgentAPIController.getRec();
        
        CloudAgentAPIController.SendEmailToManager('Test');
        Test.stopTest();
    }
    
    public static testMethod void test2() {
    mc.IsTrue__c = true;
        insert mc;
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
         User wta_user = new User(alias = 'ozone12', email='ozcloudznesertest@homelane.com',
                emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ozcloudznesertest@homelane.com',Cloud_Agent_Campaign_Name__c= 'Adnan_AutoLead');
        insert wta_user;
        
        User wta_user1 = new User(alias = 'adnan12', email='ozcloudzneseadnanrtest@homelane.com',
                emailencodingkey='UTF-8', lastname='Adnan sami', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ozcloudzneseadnanrtest@homelane.com',Cloud_Agent_Campaign_Name__c= 'Adnan_AutoLead');
        insert wta_user1;
               
         lead leadRec2 = new Lead();
         leadRec2.lastName='checking this 2';
         leadRec2.Status='Fresh Lead';
         leadRec2.Sub_Status__c ='Follow Up Later';
         leadRec2.LeadSource = 'Google Ad';
         leadRec2.City='Bengaluru';
         leadRec2.OwnerId = wta_user.Id;
         leadRec2.WT_Agent__c = wta_user1.Id;
         leadRec2.email = 'saefrkf@dfjkc.com';
         leadRec2.phone = '6291029374';
         leadRec2.Follow_up_time__c= system.now();
         leadRec2.Attempts_since_last_connection__c = 0;
         leadRec2.Calculated_WT_allocated_time__c = null;
         leadRec2.Description__c = 'ehllo';
         leadRec2.Ameyo_Call_Attempts__c = 0;
         leadRec2.WT_Agent_Allocated_Time__c = null;
         insert leadRec2;       
 
         Task t = new Task(subject = 'Manual - 4139154601393822', CallDisposition = 'Appointment_Confirmed');
        insert t;
        
        Test.startTest();
        String json = '{"monitorUCID": "4139154601393822", "UUI": "6291029374", "Did": "918068280901", "CampaignName": "Adnan_AutoLead", "Location": "Bangalore", "CallerID": "06291029374", "PhoneName": "20133", "Skill": "Adnan_AutoLead", "StartTime": "2018-12-28 21:48:59", "EndTime": "2018-12-28 21:49:43", "TimeToAnswer": "00:00:10", "CallDuration": "00:00:44", "Duration": "00:00:34", "FallBackRule": "AgentDial", "DialedNumber": "20133", "Type": "Progressive", "AgentID": "ozcloudzneseadnanrtest@homelane.com", "AgentPhoneNumber": "20133", "AgentUniqueID": "70437", "AgentName": "testozone", "Disposition": "Call_Later", "HangupBy": "UserHangup", "Status": "Answered", "AudioFile": "http://recordings.kookoo.in/HomeLane/HomeLane_4139154601393821.mp3", "TransferType": "No Transfers", "TransferredTo": "", "Comments": "", "DialStatus": "answered", "Apikey": "KK1974dd56933b4c69602c063d589e19ab", "AgentStatus": "answered", "CustomerStatus": "answered", "UserName": "homelane", "CallerConfAudioFile": "", "ConfDuration": "00:00:00", "CampaignStatus": "ONLINE"}';
        RestRequest req = new Restrequest();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =  '/services/apexrest/CloudAgentPostProcessingAPI';
        req.HTTPMethod = 'POST'; 
        req.requestBody = Blob.valueof(json);
        
        
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        CloudAgentAPIController.getRec();
        
        Test.stopTest();
    }
    
     public static testMethod void test3() {
     mc.IsTrue__c = true;
        insert mc;
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
         User wta_user = new User(alias = 'ozone12', email='ozcloudznesertest@homelane.com',
                emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ozcloudznesertest@homelane.com',Cloud_Agent_Campaign_Name__c= 'Adnan_AutoLead');
        insert wta_user;
        
        User wta_user1 = new User(alias = 'adnan12', email='ozcloudzneseadnanrtest@homelane.com',
                emailencodingkey='UTF-8', lastname='Adnan sami', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ozcloudzneseadnanrtest@homelane.com',Cloud_Agent_Campaign_Name__c= 'Adnan_AutoLead');
        insert wta_user1;
               
         lead leadRec2 = new Lead();
         leadRec2.lastName='checking this 2';
         leadRec2.Status='Fresh Lead';
         leadRec2.Sub_Status__c ='Follow Up Later';
         leadRec2.LeadSource = 'Google Ad';
         leadRec2.City='Bengaluru';
         leadRec2.OwnerId = wta_user.Id;
         leadRec2.WT_Agent__c = wta_user1.Id;
         leadRec2.email = 'saefrkf@dfjkc.com';
         leadRec2.phone = '6291029374';
         leadRec2.Follow_up_time__c= system.now();
         leadRec2.Attempts_since_last_connection__c = 0;
         leadRec2.Calculated_WT_allocated_time__c = null;
         leadRec2.Description__c = 'ehllo';
         leadRec2.Ameyo_Call_Attempts__c = 0;
         leadRec2.WT_Agent_Allocated_Time__c = null;
         insert leadRec2;       
 
         Task t = new Task(subject = 'Manual - 4139154601393822', CallDisposition = 'Unable_to_Connect');
        insert t;
        
        Test.startTest();
        String json = '{"monitorUCID": "4139154601393822", "UUI": "6291029374", "Did": "918068280901", "CampaignName": "Adnan_AutoLead", "Location": "Bangalore", "CallerID": "06291029374", "PhoneName": "20133", "Skill": "Adnan_AutoLead", "StartTime": "2018-12-28 21:48:59", "EndTime": "2018-12-28 21:49:43", "TimeToAnswer": "00:00:10", "CallDuration": "00:00:44", "Duration": "00:00:34", "FallBackRule": "AgentDial", "DialedNumber": "20133", "Type": "Progressive", "AgentID": "ozcloudznesertest@homelane.com -> ozcloudzneseadnanrtest@homelane.com", "AgentPhoneNumber": "20133", "AgentUniqueID": "70437", "AgentName": "testozone", "Disposition": "connected", "HangupBy": "UserHangup", "Status": "Answered", "AudioFile": "http://recordings.kookoo.in/HomeLane/HomeLane_4139154601393821.mp3", "TransferType": "No Transfers", "TransferredTo": "", "Comments": "", "DialStatus": "answered", "Apikey": "KK1974dd56933b4c69602c063d589e19ab", "AgentStatus": "answered", "CustomerStatus": "answered", "UserName": "homelane", "CallerConfAudioFile": "", "ConfDuration": "00:00:00", "CampaignStatus": "ONLINE"}';
        RestRequest req = new Restrequest();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =  '/services/apexrest/CloudAgentPostProcessingAPI';
        req.HTTPMethod = 'POST'; 
        req.requestBody = Blob.valueof(json);
        
        
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        CloudAgentAPIController.getRec();
        
        Test.stopTest();
    }
    
      public static testMethod void test4() {
      mc.IsTrue__c = true;
        insert mc;
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
         User wta_user = new User(alias = 'ozone12', email='ozcloudznesertest@homelane.com',
                emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ozcloudznesertest@homelane.com',Cloud_Agent_Campaign_Name__c= 'Adnan_AutoLead');
        insert wta_user;
        
        User wta_user1 = new User(alias = 'adnan12', email='ozcloudzneseadnanrtest@homelane.com',
                emailencodingkey='UTF-8', lastname='Adnan sami', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ozcloudzneseadnanrtest@homelane.com',Cloud_Agent_Campaign_Name__c= 'Adnan_AutoLead');
        insert wta_user1;
               
         lead leadRec2 = new Lead();
         leadRec2.lastName='checking this 2';
         leadRec2.Status='Fresh Lead';
         leadRec2.Sub_Status__c ='Follow Up Later';
         leadRec2.LeadSource = 'Google Ad';
         leadRec2.City='Bengaluru';
         leadRec2.OwnerId = wta_user.Id;
         leadRec2.WT_Agent__c = wta_user.Id;
         leadRec2.email = 'saefrkf@dfjkc.com';
         leadRec2.phone = '6291029374';
         leadRec2.Follow_up_time__c= system.now();
         leadRec2.Attempts_since_last_connection__c = 0;
         leadRec2.Calculated_WT_allocated_time__c = null;
         leadRec2.Description__c = 'ehllo';
         leadRec2.Ameyo_Call_Attempts__c = 0;
         leadRec2.WT_Agent_Allocated_Time__c = null;
         insert leadRec2;       
 
         Task t = new Task(subject = 'Manual - 4139154601393822', CallDisposition = 'Appointment_Confirmed',Disposition_Type__c = 'connected');
        insert t;
        
        Test.startTest();
        String json = '{"monitorUCID": "4139154601393822", "UUI": "6291029374", "Did": "918068280901", "CampaignName": "Adnan_AutoLead", "Location": "Bangalore", "CallerID": "06291029374", "PhoneName": "20133", "Skill": "Adnan_AutoLead", "StartTime": "2018-12-28 21:48:59", "EndTime": "2018-12-28 21:49:43", "TimeToAnswer": "00:00:10", "CallDuration": "00:00:44", "Duration": "00:00:34", "FallBackRule": "AgentDial", "DialedNumber": "20133", "Type": "Progressive", "AgentID": "ozcloudznesertest@homelane.com -> ozcloudzneseadnanrtest@homelane.com", "AgentPhoneNumber": "20133", "AgentUniqueID": "70437", "AgentName": "testozone", "Disposition": "connected", "HangupBy": "UserHangup", "Status": "Answered", "AudioFile": "http://recordings.kookoo.in/HomeLane/HomeLane_4139154601393821.mp3", "TransferType": "No Transfers", "TransferredTo": "", "Comments": "", "DialStatus": "answered", "Apikey": "KK1974dd56933b4c69602c063d589e19ab", "AgentStatus": "answered", "CustomerStatus": "answered", "UserName": "homelane", "CallerConfAudioFile": "", "ConfDuration": "00:00:00", "CampaignStatus": "ONLINE"}';
        RestRequest req = new Restrequest();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =  '/services/apexrest/CloudAgentPostProcessingAPI';
        req.HTTPMethod = 'POST'; 
        req.requestBody = Blob.valueof(json);
        
        
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        CloudAgentAPIController.getRec();
        
        Test.stopTest();
    }
    public static testMethod void createTaskRecordTest1() {
      mc.IsTrue__c = true;
        insert mc;
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
         User wta_user = new User(alias = 'ozone12', email='ozcloudznesertest@homelane.com',
                emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ozcloudznesertest@homelane.com',Cloud_Agent_Campaign_Name__c= 'Adnan_AutoLead');
        insert wta_user;
        
        User wta_user1 = new User(alias = 'adnan12', email='ozcloudzneseadnanrtest@homelane.com',
                emailencodingkey='UTF-8', lastname='Adnan sami', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ozcloudzneseadnanrtest@homelane.com',Cloud_Agent_Campaign_Name__c= 'Adnan_AutoLead');
        insert wta_user1;
               
         lead leadRec2 = new Lead();
         leadRec2.lastName='checking this 2';
         leadRec2.Status='Fresh Lead';
         leadRec2.Sub_Status__c ='Follow Up Later';
         leadRec2.LeadSource = 'Google Ad';
         leadRec2.City='Bengaluru';
         leadRec2.OwnerId = wta_user.Id;
         leadRec2.WT_Agent__c = wta_user.Id;
         leadRec2.email = 'saefrkf@dfjkc.com';
         leadRec2.phone = '6291029374';
         leadRec2.Follow_up_time__c= system.now();
         leadRec2.Attempts_since_last_connection__c = 0;
         leadRec2.Calculated_WT_allocated_time__c = null;
         leadRec2.Description__c = 'ehllo';
         leadRec2.Ameyo_Call_Attempts__c = 0;
         leadRec2.WT_Agent_Allocated_Time__c = null;
         insert leadRec2;       
 
         Task t = new Task(subject = 'Manual - 4139154601393822', CallDisposition = 'Appointment_Confirmed',Disposition_Type__c = 'connected');
        insert t;
        
        Test.startTest();
        String json = '{"monitorUCID": "4139154601393822", "UUI": "6291029374", "Did": "918068280901", "CampaignName": "Adnan_AutoLead", "Location": "Bangalore", "CallerID": "06291029374", "PhoneName": "20133", "Skill": "Adnan_AutoLead", "StartTime": "2018-12-28 21:48:59", "EndTime": "2018-12-28 21:49:43", "TimeToAnswer": "00:00:10", "CallDuration": "00:00:44", "Duration": "00:00:34", "FallBackRule": "AgentDial", "DialedNumber": "20133", "Type": "Predictive", "AgentID": "ozcloudznesertest@homelane.com -> ozcloudzneseadnanrtest@homelane.com", "AgentPhoneNumber": "20133", "AgentUniqueID": "70437", "AgentName": "testozone", "Disposition": "connected", "HangupBy": "UserHangup", "Status": "Answered", "AudioFile": "http://recordings.kookoo.in/HomeLane/HomeLane_4139154601393821.mp3", "TransferType": "No Transfers", "TransferredTo": "", "Comments": "", "DialStatus": "answered", "Apikey": "KK1974dd56933b4c69602c063d589e19ab", "AgentStatus": "not_answered", "CustomerStatus": "not_answered", "UserName": "homelane", "CallerConfAudioFile": "", "ConfDuration": "00:00:00", "CampaignStatus": "ONLINE"}';
        RestRequest req = new Restrequest();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =  '/services/apexrest/CloudAgentPostProcessingAPI';
        req.HTTPMethod = 'POST'; 
        req.requestBody = Blob.valueof(json);
        
        
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        CloudAgentAPIController.getRec();
        
        Test.stopTest();
    }
    
}