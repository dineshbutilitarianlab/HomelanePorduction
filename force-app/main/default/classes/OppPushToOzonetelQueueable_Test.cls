@isTest 
global class OppPushToOzonetelQueueable_Test implements HTTPCalloutMock{
    @isTest static void opp() {
        List<Opportunity> oppList = new List<Opportunity>();
        List<Account> accList = new List<Account>();
        
        Account a1 = new Account(LastName = 'test', firstName = 'test', BillingCity = 'Bengaluru', phone = '9000000001', PersonEmail= 'test@test1.com');
        Account a2 = new Account(LastName = 'test', firstName = 'test', BillingCity = 'Mumbai', phone = '9000000002', PersonEmail= 'test@test2.com');
        Account a3 = new Account(LastName = 'test', firstName = 'test', BillingCity = 'Chennai', phone = '9000000003', PersonEmail= 'test@test3.com');
        Account a4 = new Account(LastName = 'test', firstName = 'test', BillingCity = 'New Delhi', phone = '9000000004', PersonEmail= 'test@test4.com');
        Account a5 = new Account(LastName = 'test', firstName = 'test', BillingCity = 'Others', phone = '9000000005', PersonEmail= 'test@test5.com');
        Account a6 = new Account(LastName = 'test', firstName = 'test', BillingCity = 'Kolkata', phone = '9000000006', PersonEmail= 'test@test6.com');
        Account a7 = new Account(LastName = 'test', firstName = 'test', BillingCity = 'Hyderabad', phone = '9000000007', PersonEmail= 'test@test7.com');
        Account a8 = new Account(LastName = 'test', firstName = 'test', BillingCity = 'Pune', phone = '9000000008', PersonEmail= 'test@test8.com');
        accList.add(a1);
        accList.add(a2);
        accList.add(a3);
        accList.add(a4);
        accList.add(a5);
        accList.add(a6); 
        accList.add(a7);
        accList.add(a8);
        insert accList;
        System.debug('accList===>  '+accList);
        
        Opportunity opp1 = new Opportunity();
        opp1.name = 'first';
        opp1.StageName='Won';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.AccountId = a1.id;
        opp1.CloseDate = Date.Today();
      //  opp1.Interior_Design_Partner__c = inte.id;
        opp1.Amount = 1000;
      //  opp1.Appointment_Venue_Square__c = m.Id;
        opp1.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-2);
        opp1.CityfromLead__c = 'Bengaluru';
        System.debug('opp1.Customer_Phone_Number__c   '+opp1.Customer_Phone_Number__c);        
        oppList.add(opp1);
             
        Opportunity opp2 = new Opportunity();
        opp2.name = 'first1';
        opp2.StageName='Won';
        opp2.Opportunity_Stage__c = 'Won';
        opp2.AccountId = a2.id;
        opp2.CloseDate = Date.Today();
      //  opp2.Interior_Design_Partner__c = inte.id;
        opp2.Amount = 5000000;
        opp2.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-4);
        opp2.CityfromLead__c = 'Mumbai';
        oppList.add(opp2);
        
        Opportunity opp3 = new Opportunity();
        opp3.name = 'first3';
        opp3.StageName='Won';
        opp3.Opportunity_Stage__c = 'Won';
        opp3.AccountId = a3.id;
        opp3.CloseDate = Date.Today();
      //  opp3.Interior_Design_Partner__c = inte.id;
        opp3.Amount = 500000;
        opp3.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-3);
        opp3.CityfromLead__c = 'Chennai';
        oppList.add(opp3);
      
        Opportunity opp4 = new Opportunity();
        opp4.name = 'first1zv';
        opp4.StageName='D1 Initiated';
        opp4.Opportunity_Stage__c = 'Won';
        opp4.AccountId = a4.id;
        opp4.CloseDate = Date.Today();
       // opp4.Interior_Design_Partner__c = inte.id;
        opp4.Amount = 5000;
        opp4.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-5);
        opp4.CityfromLead__c = 'New Delhi';
        oppList.add(opp4);
      
        Opportunity opp5 = new Opportunity();
        opp5.name = 'first1mklzv';
        opp5.StageName='D1 Initiated';
        opp5.Opportunity_Stage__c = 'Won';
        opp5.AccountId = a5.id;
        opp5.CloseDate = Date.Today();
     //   opp5.Interior_Design_Partner__c = inte.id;
        opp5.Amount = 500000;
        opp5.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-1);
        opp5.CityfromLead__c = 'Others';
        oppList.add(opp5);
       
        Opportunity opp6 = new Opportunity();
        opp6.name = 'firstlknk1zv';
        opp6.StageName='D1 Initiated';
        opp6.Opportunity_Stage__c = 'Won';
        opp6.AccountId = a6.id;
        opp6.CloseDate = Date.Today();
       // opp6.Interior_Design_Partner__c = inte.id;
        opp6.Amount = 5000000;
        opp6.CityfromLead__c = 'Kolkata';
        oppList.add(opp6);
        
        Opportunity opp7 = new Opportunity();
        opp7.name = 'firstlknk1zv';
        opp7.StageName='D1 Initiated';
        opp7.Opportunity_Stage__c = 'Won';
        opp7.AccountId = a6.id;
        opp7.CloseDate = Date.Today();
       // opp6.Interior_Design_Partner__c = inte.id;
        opp7.Amount = 5000000;
        opp7.CityfromLead__c = 'Hyderabad';
        oppList.add(opp7);
        
        Opportunity opp8 = new Opportunity();
        opp8.name = 'firstlknk1zv';
        opp8.StageName='D1 Initiated';
        opp8.Opportunity_Stage__c = 'Won';
        opp8.AccountId = a6.id;
        opp8.CloseDate = Date.Today();
       // opp6.Interior_Design_Partner__c = inte.id;
        opp8.Amount = 5000000;
        opp8.CityfromLead__c = 'Pune';
        oppList.add(opp8);
        
        insert oppList;
               
     Set<Id> setId = new Set<Id>();
     for(Opportunity o : oppList) {
         setId.add(o.Id);
     }
     oppList = [select id, name, stagename, accountid, closedate,Opportunity_Stage__c,amount, Time_of_Actual_Appointment_Start__c,CityfromLead__c, Customer_Phone_Number__c from opportunity where id =: setId];
     System.debug('oppList===>  '+oppList);
       
        
        System.debug('opp1.Customer_Phone_Number__c   '+opp1.Customer_Phone_Number__c);
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new OppPushToOzonetelQueueable_Test());
        OppPushToOzonetelQueueable oppPush = new OppPushToOzonetelQueueable(oppList, UserInfo.getSessionId());
        System.enqueueJob(oppPush);
        Test.stopTest();
    }
    
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"monitorUCID": "4139154609145591", "UUI": "", "Did": "918068280905", "CampaignName": "Inbound_Bangalore", "Location": "", "CallerID": "09844318107", "PhoneName": "20133", "Skill": "None", "StartTime": "2018-12-29 19:20:59", "EndTime": "2018-12-29 19:21:12", "TimeToAnswer": "00:00:06", "CallDuration": "00:00:13", "Duration": "00:00:07", "FallBackRule": "AgentDial", "DialedNumber": "20133", "Type": "Manual", "AgentID": "ozone", "AgentPhoneNumber": "20133", "AgentUniqueID": "66519", "AgentName": "ozone", "Disposition": "Unable_to_Connect", "HangupBy": "UserHangup", "Status": "Answered", "AudioFile": "http://recordings.kookoo.in/HomeLane/HomeLane_4139154609145591.mp3", "TransferType": "No Transfers", "TransferredTo": "", "Comments": "", "DialStatus": "answered", "Apikey": "KK1974dd56933b4c69602c063d589e19ab", "AgentStatus": "answered", "CustomerStatus": "answered", "UserName": "homelane", "CallerConfAudioFile": "", "ConfDuration": "00:00:00", "CampaignStatus": "ONLINE"}');
        response.setStatusCode(200);
        return response; 
    }
}