@isTest
public class WebEngageBatchHandler_Test {
    Public static User u;
    Public static Lead ld;
    Public static Account acc;
    Public static Opportunity opp;
    Public static WebEngage_Task__c webEngageTask;
    Public static Integration_Setting__c webEngageBulkUserAPI;
    Public static Integration_Setting__c webEngageBulkEventAPI;
    
    @TestSetup static void data() { 
        //Create User record
        
        
        // Create WebEngageTask
       
        //Create account record
        acc = TestData_Factory.createAccount(false);
        acc.Customer_ID__c ='Abgdbjeneb';
        insert acc;
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Lead_square_modified_date__c = Date.today();
        ld.Assigned_to_Resi_ASM__c = true;
        ld.Customer_ID__c = 'ABCDEFGH';
        ld.Whatsapp_Opt_in__c = true;
        ld.Closest_ShowRoom_Distance__c = 10;
        ld.Appointment_Type__c = 'Square Showroom Visit';
        ld.Appointment_Time__c = system.now().addDays(2);
        ld.Brand__c='HomeLane';
        ld.Account__c= acc.id;
        insert ld;
        
         webEngageTask = TestData_Factory.createWebEngageEventTask(ld.id,null,'Appointment Details Updated','Change Event',true);
        //Create Opportunity record
        opp = TestData_Factory.createOpportunity(acc.Id,false);
        opp.Follow_Up_Time__c = System.now().addHours(3);
        opp.Amount_Collected__c = 48000;
        //opp.Brand__c='HomeLane';
        insert opp;
        
        webEngageBulkEventAPI = TestData_Factory.createIntegrationSetting('WebEngage Bulk Events API','https://api.webengage.com/v1/accounts/~47b65dd3/bulk-events','application/json','5aeae25c-aab5-45ee-9746-0fd2b9665699',null);
        webEngageBulkUserAPI = TestData_Factory.createIntegrationSetting('WebEngage Bulk Users API','https://api.webengage.com/v1/accounts/~47b65dd3/bulk-users','application/json','5aeae25c-aab5-45ee-9746-0fd2b9665699',null);
    }
    public testMethod static void WebEngageBatchHandlerTest1(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        Database.executeBatch(new WebEngageChangeEventBatch());
        test.stopTest();
    }
    public testMethod static void WebEngageBatchHandlerTest2(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        webEngageTask = [select id from WebEngage_Task__c limit 1];
        opp = [Select id from Opportunity limit 1];
        
        webEngageTask.Lead__c = null;
        webEngageTask.Opportunity__c = opp.id;
        webEngageTask.Name = 'New Opportunity is Created';
        
        update webEngageTask;
        
        Set<Id> setOfIds = new Set<Id>();
        setOfIds.add(webEngageTask.id);
        
        
        
        Database.executeBatch(new WebEngageChangeEventBatch(setOfIds));
        test.stopTest();
    }
    public testMethod static void WebEngageBatchHandlerTest3(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        webEngageTask = [select id from WebEngage_Task__c limit 1];
        opp = [Select id from Opportunity limit 1];
        
        webEngageTask.Name = 'User Attributes Updated';
        webEngageTask.Type__c = 'User Event';  
        webEngageTask.Brand__c= 'HomeLane';
        update webEngageTask;
        
        List<WebEngage_Task__c> listOfWebEngageTasks = [select name,type__c,Opportunity__c,Lead__c,createddate,Brand__c from WebEngage_Task__c where id=:webEngageTask.id];
        
        WebEngageUserEventBatch webUserBatch = new WebEngageUserEventBatch();
        webUserBatch.execute(null,listOfWebEngageTasks);
        //System.schedule('WebEngageUserEventBatch', '0 0 * * * ?', new WebEngageUserEventBatch());
        test.stopTest();
    }
    public testMethod static void WebEngageBatchHandlerTest4(){
        Test.startTest();
        List<WebEngage_Task__c> listOfWebEngageTasks = [select id from WebEngage_Task__c];
        WebEngageBatchHandler.updateWebEngageTaskStatus(listOfWebEngageTasks);
        test.stopTest();
    }
    public testMethod static void WebEngageBatchHandlerTest5(){
        Test.startTest();
        WebEngageBatchHandler.calloutToWebEngage('','');
        WebEngageBatchHandler.calloutToWebEngage('abc', 'abc');
        test.stopTest();
    }
    public testMethod static void WebEngageBatchHandlerTest6(){
        
        
        
        //Opportunity opp =  [Select id from Opportunity limit 1];
        Account acc = [Select id from Account];
        opp = TestData_Factory.createOpportunity(acc.Id,false);
        opp.Follow_Up_Time__c = System.now().addHours(3);
        opp.Amount_Collected__c = 48000;
        insert opp;
        
        list<WebEngage_Task__c> webengageList = new list<WebEngage_Task__c>();
        WebEngage_Task__c webEngageTask = new WebEngage_Task__c();
        webEngageTask.Lead__c = null;
        webEngageTask.Opportunity__c = opp.id;
        webEngageTask.Name = 'New Opportunity is Created';
        webEngageTask.Type__c = 'Change Event';
        webEngageTask.Brand__c='Doowup';
        
        insert webEngageTask;
        
        webengageList = [select name,type__c,Opportunity__c,Lead__c,createddate ,Brand__c from WebEngage_Task__c];
       Map<String,List<WebEngage_Task__c>> Mapwebengage= new Map<String,List<WebEngage_Task__c>>();
        Mapwebengage.put('CHANGE EVENT',webengageList);
        Set<Id> setOfIds = new Set<Id>();
        setOfIds.add(webEngageTask.id);
        
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        WebEngageChangeEventBatch obj = new WebEngageChangeEventBatch();
        obj.execute(null,webengageList);
        WebEngageBatchHandler.calloutToWebEngage('test','WebEngage Bulk Events API');
        Database.executeBatch(new WebEngageChangeEventBatch());
        WebEngageBatchHandler.getdetails(Mapwebengage,'USER EVENT');
        obj.finish(null);
        test.stopTest();
    }
    
     public testMethod static void WebEngageBatchHandlerTest7()
     {
         test.starttest();
         WebEngageBatchHandler.dummyTestCover();
         test.stopTest();
     }
}