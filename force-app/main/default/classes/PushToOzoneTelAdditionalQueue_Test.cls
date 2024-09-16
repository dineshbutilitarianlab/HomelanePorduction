@isTest
global class PushToOzoneTelAdditionalQueue_Test implements HTTPCallOutMock{
    global HTTPResponse respond(HTTPRequest request) {
        HTTPResponse response = new HTTPResponse();
        response.setHeader('Content-Type','application/json');
        response.setBody('{"status": "SUCCESS"}');
        response.setStatusCode(200);
        return response;
    }
    
    
    @isTest static void LeadPushBengaluru() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
        Lead l = new Lead(
            FirstName='Vaniya',
            LastName='Sowmyala',
            Email='WLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Bengaluru',
            Status='Fresh Lead',
            Sub_Status__c ='New',
            LeadSource='Website'
        ); 
        insert l;
        System.debug('Lead is : '+l); 
        leadList.add(l); 
        Test.startTest();
        
        PushToOzoneTelAdditionalQueue lea = new PushToOzoneTelAdditionalQueue(leadList,'abc');        
        System.enqueueJob(lea);
        PushToOzoneTelAdditionalQueue.userCampaignName(l.Id,'9844318107',l.Id);
        Test.setMock(HttpCalloutMock.class, new PushToOzoneTelAdditionalQueue_Test());
        Test.stopTest();          
    }
    @isTest static void LeadPushHyderabad() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
        Lead l = new Lead(
            FirstName='Vaniya',
            LastName='Sowmyala',
            Email='WLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Hyderabad',
            Status='Fresh Lead',
            Sub_Status__c ='New',
            LeadSource='Website'
        ); 
        insert l;
        System.debug('Lead is : '+l); 
        leadList.add(l); 
        Test.startTest();
        
        PushToOzoneTelAdditionalQueue lea = new PushToOzoneTelAdditionalQueue(leadList,'abc');        
        System.enqueueJob(lea);
        PushToOzoneTelAdditionalQueue.userCampaignName(l.Id,'9844318107',l.Id);
        Test.setMock(HttpCalloutMock.class, new PushToOzoneTelAdditionalQueue_Test());
        Test.stopTest();          
    }
    @isTest static void LeadPushKolkata() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
        Lead l = new Lead(
            FirstName='Vaniya',
            LastName='Sowmyala',
            Email='WLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Kolkata',
            Status='Fresh Lead',
            Sub_Status__c ='New',
            LeadSource='Website'
        ); 
        insert l;
        System.debug('Lead is : '+l); 
        leadList.add(l); 
        Test.startTest();
        
        PushToOzoneTelAdditionalQueue lea = new PushToOzoneTelAdditionalQueue(leadList,'abc');        
        System.enqueueJob(lea);
        PushToOzoneTelAdditionalQueue.userCampaignName(l.Id,'9844318107',l.Id);
        Test.setMock(HttpCalloutMock.class, new PushToOzoneTelAdditionalQueue_Test());
        Test.stopTest();          
    }
    @isTest static void LeadPushMumbai() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
        Lead l = new Lead(
            FirstName='Vaniya',
            LastName='Sowmyala',
            Email='WLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Mumbai',
            Status='Fresh Lead',
            Sub_Status__c ='New',
            LeadSource='Website'
        ); 
        insert l;
        System.debug('Lead is : '+l); 
        leadList.add(l); 
        Test.startTest();
        
        PushToOzoneTelAdditionalQueue lea = new PushToOzoneTelAdditionalQueue(leadList,'abc');        
        System.enqueueJob(lea);
        PushToOzoneTelAdditionalQueue.userCampaignName(l.Id,'9844318107',l.Id);
        Test.setMock(HttpCalloutMock.class, new PushToOzoneTelAdditionalQueue_Test());
        Test.stopTest();          
    }
    
    @isTest static void LeadPushChennai() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
        Lead l = new Lead(
            FirstName='Vaniya',
            LastName='Sowmyala',
            Email='WLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Chennai',
            Status='Fresh Lead',
            Sub_Status__c ='New',
            LeadSource='Website'
        ); 
        insert l;
        System.debug('Lead is : '+l); 
        leadList.add(l); 
        Test.startTest();
        
        PushToOzoneTelAdditionalQueue lea = new PushToOzoneTelAdditionalQueue(leadList,'abc');        
        System.enqueueJob(lea);
        PushToOzoneTelAdditionalQueue.userCampaignName(l.Id,'9844318107',l.Id);
        Test.setMock(HttpCalloutMock.class, new PushToOzoneTelAdditionalQueue_Test());
        Test.stopTest();          
    }
    @isTest static void LeadPushCoimbatore() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
        Lead l = new Lead(
            FirstName='Vaniya',
            LastName='Sowmyala',
            Email='WLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Coimbatore',
            Status='Fresh Lead',
            Sub_Status__c ='New',
            LeadSource='Website'
        ); 
        insert l;
        System.debug('Lead is : '+l); 
        leadList.add(l); 
        Test.startTest();
        
        PushToOzoneTelAdditionalQueue lea = new PushToOzoneTelAdditionalQueue(leadList,'abc');        
        System.enqueueJob(lea);
        PushToOzoneTelAdditionalQueue.userCampaignName(l.Id,'9844318107',l.Id);
        Test.setMock(HttpCalloutMock.class, new PushToOzoneTelAdditionalQueue_Test());
        Test.stopTest();          
    }
     @isTest static void LeadPushNoida() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
        Lead l = new Lead(
            FirstName='Vaniya',
            LastName='Sowmyala',
            Email='WLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Noida',
            Status='Fresh Lead',
            Sub_Status__c ='New',
            LeadSource='Website'
        ); 
        insert l;
        System.debug('Lead is : '+l); 
        leadList.add(l); 
        Test.startTest();
        
        PushToOzoneTelAdditionalQueue lea = new PushToOzoneTelAdditionalQueue(leadList,'abc');        
        System.enqueueJob(lea);
        PushToOzoneTelAdditionalQueue.userCampaignName(l.Id,'9844318107',l.Id);
        Test.setMock(HttpCalloutMock.class, new PushToOzoneTelAdditionalQueue_Test());
        Test.stopTest();          
    }
    @isTest static void LeadPushPune() {
        String testLbl = Label.Cloud_Agent_Id;       
        List<Lead> leadList = new List<Lead>();
        Lead l = new Lead(
            FirstName='Vaniya',
            LastName='Sowmyala',
            Email='WLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = testLbl,
            WT_Agent__c = testLbl,
            City='Pune',
            Status='Fresh Lead',
            Sub_Status__c ='New',
            LeadSource='Website'
        ); 
        insert l;
        System.debug('Lead is : '+l); 
        leadList.add(l); 
        Test.startTest();
        
        PushToOzoneTelAdditionalQueue lea = new PushToOzoneTelAdditionalQueue(leadList,'abc');        
        System.enqueueJob(lea);
        PushToOzoneTelAdditionalQueue.userCampaignName(l.Id,'9844318107',l.Id);
        Test.setMock(HttpCalloutMock.class, new PushToOzoneTelAdditionalQueue_Test());
        Test.stopTest();          
    }
    @isTest static void SendEmailToManagerTest() {
        Test.startTest();
        PushToOzoneTelAdditionalQueue.SendEmailToManager('Error msg');
        Test.stopTest(); 
    }
   /*@isTest static void Dummy() {
        Test.startTest();
        PushToOzoneTelAdditionalQueue.dummyTestCover();
        Test.stopTest(); 
    }*/
}