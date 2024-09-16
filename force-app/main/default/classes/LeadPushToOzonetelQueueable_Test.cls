@isTest
global class LeadPushToOzonetelQueueable_Test implements HTTPCallOutMock{
    global HTTPResponse respond(HTTPRequest request) {
        HTTPResponse response = new HTTPResponse();
        response.setHeader('Content-Type','application/json');
        response.setBody('{"status": "SUCCESS"}');
        response.setStatusCode(200);
        return response;
    }
    
    @isTest static void LeadPush() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
           Lead l = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Bengaluru',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website'
             ); 
        System.debug('Lead is : '+l); 
        leadList.add(l); 
       Test.startTest();
         
        LeadPushToOzonetelQueueable lea = new LeadPushToOzonetelQueueable(leadList,'abc');        
        System.enqueueJob(lea);
         LeadPushToOzonetelQueueable.userCampaignName(l.Id,'9844318107',l.Id);
         Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test());
        Test.stopTest();          
    }   
    
      @isTest static void LeadPush1() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
           Lead l = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Hyderabad',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website'
             ); 
        System.debug('Lead is : '+l); 
        leadList.add(l); 
       Test.startTest();
       // Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test()); 
        LeadPushToOzonetelQueueable lea = new LeadPushToOzonetelQueueable(leadList,'abc');        
        System.enqueueJob(lea);
         LeadPushToOzonetelQueueable.userCampaignName(l.Id,'9844318107',l.Id);
         Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test());
        Test.stopTest();          
    }
    
    @isTest static void LeadPush2() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
           Lead l = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Chennai',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website'
             ); 
        System.debug('Lead is : '+l); 
        leadList.add(l); 
       Test.startTest();
       // Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test()); 
        LeadPushToOzonetelQueueable lea = new LeadPushToOzonetelQueueable(leadList,'abc');        
        System.enqueueJob(lea);
         LeadPushToOzonetelQueueable.userCampaignName(l.Id,'9844318107',l.Id);
         Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test());
        Test.stopTest();          
    }
    
    @isTest static void LeadPush3() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
           Lead l = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='New Delhi',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website'
             ); 
        System.debug('Lead is : '+l); 
        leadList.add(l); 
       Test.startTest();
      //  Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test()); 
        LeadPushToOzonetelQueueable lea = new LeadPushToOzonetelQueueable(leadList,'abc');        
        System.enqueueJob(lea);
         LeadPushToOzonetelQueueable.userCampaignName(l.Id,'9844318107',l.Id);
         Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test());
        Test.stopTest();          
    }
    
    @isTest static void LeadPush4() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
           Lead l = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Mumbai',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website'
             ); 
        System.debug('Lead is : '+l); 
        leadList.add(l); 
       Test.startTest();
      //  Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test()); 
        LeadPushToOzonetelQueueable lea = new LeadPushToOzonetelQueueable(leadList,'abc');        
        System.enqueueJob(lea);
         LeadPushToOzonetelQueueable.userCampaignName(l.Id,'9844318107',l.Id);
         Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test());
        Test.stopTest();          
    }
    
    @isTest static void LeadPush5() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
           Lead l = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Others',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website'
             ); 
        System.debug('Lead is : '+l); 
        leadList.add(l); 
        
        Messaging.SingleEmailMessage Message = new Messaging.SingleEmailMessage(); 
        message.setTargetObjectId(UserInfo.getUserId());
        message.setSaveAsActivity(false);
        message.setSubject('dear diary');
        message.setPlainTextBody('he who controls the spice');
        Messaging.sendEmail(new List<Messaging.Email>{Message}); 
        
       Test.startTest();
       // Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test()); 
        LeadPushToOzonetelQueueable lea = new LeadPushToOzonetelQueueable(leadList,'abc');        
        System.enqueueJob(lea);
         LeadPushToOzonetelQueueable.userCampaignName(l.Id,'9844318107',l.Id);
         
         Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test());
        Test.stopTest();          
    }
    
    @isTest static void LeadPush6() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
           Lead l = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Pune',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website'
             ); 
        System.debug('Lead is : '+l); 
        leadList.add(l); 
       Test.startTest();
       // Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test()); 
        LeadPushToOzonetelQueueable lea = new LeadPushToOzonetelQueueable(leadList,'abc');        
        System.enqueueJob(lea);
         LeadPushToOzonetelQueueable.userCampaignName(l.Id,'9844318107',l.Id);
         Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test());
        Test.stopTest();          
    }
    
    @isTest static void LeadPush7() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
           Lead l = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Kolkata',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website'
             ); 
        System.debug('Lead is : '+l); 
        leadList.add(l); 
       Test.startTest();
       // Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test()); 
        LeadPushToOzonetelQueueable lea = new LeadPushToOzonetelQueueable(leadList,'abc');        
        System.enqueueJob(lea);
         LeadPushToOzonetelQueueable.userCampaignName(l.Id,'9844318107',l.Id);
         Test.setMock(HttpCalloutMock.class, new LeadPushToOzonetelQueueable_Test());
        Test.stopTest();          
    }
    
     @isTest static void LeadPush8() {
    //LeadPushToOzonetelQueueable.SendEmailToManager('Test');
    }
}