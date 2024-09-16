@isTest 
global class LeadPushToOzoneCityQueue_Test implements HTTPCalloutMock{
    @isTest static void test() {
        String testLbl = Label.Cloud_Agent_Id;     
         Lead l1 = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd1@hamelane.com',
            Phone='9844318101',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Bengaluru',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website');
             
             Lead l2 = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd2@hamelane.com',
            Phone='9844318102',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Chennai',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website');
             
             Lead l3 = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd3@hamelane.com',
            Phone='9844318103',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Kolkata',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website');
             
             Lead l4 = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd4@hamelane.com',
            Phone='9844318104',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Pune',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website');
             
             Lead l5 = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd5@hamelane.com',
            Phone='9844318105',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Mumbai',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website');
             
             Lead l6 = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd6@hamelane.com',
            Phone='9844318106',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Others',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website');
             
             Lead l7 = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd7@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='New Delhi',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website');
             
             Lead l8 = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd8@hamelane.com',
            Phone='9844318108',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Hyderabad',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website');
             List<Lead> leadList = new List<Lead>();
             leadList.add(l1);
             leadList.add(l2);
             leadList.add(l3);
             leadList.add(l4);
             leadList.add(l5);
             leadList.add(l6);
             leadList.add(l7);
             leadList.add(l8);
             insert leadList;
             
        Whatsapp_Message__c w = new Whatsapp_Message__c(Name = 'WA - Unable to Contact', Lead__c = l8.Id, Responded_Last_Time__c = System.now(), Response_Msg__c = 'Call', Responded__c = 'Yes', Call_Back_Request__c = 'Inside Business Hours');
        insert w;
            
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new LeadPushToOzoneCityQueue_Test ());
        LeadPushToOzoneCityQueue leadPush = new LeadPushToOzoneCityQueue(leadList, UserInfo.getSessionId(),w.id);
        System.enqueueJob(leadPush);
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