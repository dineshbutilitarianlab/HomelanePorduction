@isTest
public class WebEngageChangeEventBatch_Test {
    Public static User u;
    Public static Lead ld;
    Public static Account acc;
    Public static Opportunity opp;
    Public static WebEngage_Task__c webEngageTask;
    @TestSetup static void data() { 
        acc= new account();
        acc.name='Testacc';
        insert acc;
        //Create User record
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Lead_square_modified_date__c = Date.today();
        ld.Assigned_to_Resi_ASM__c = true;
        
        ld.Account__c= acc.Id;
        insert ld;
        
        // Create WebEngageTask
        webEngageTask = TestData_Factory.createWebEngageEventTask(ld.id,null,'Property Details Update','Change Event',true);
        //Create account record
        //acc = TestData_Factory.createAccount(True);
        
        //Create Opportunity record
        //opp = TestData_Factory.createOpportunity(acc.Id,True);
    }
    public testMethod static void WebEngageChangeEventBatchTest1(){
        
        Test.startTest();
        Database.executeBatch(new WebEngageChangeEventBatch());
        test.stopTest();
    }
    public testMethod static void WebEngageChangeEventBatchTest2(){
        
        webEngageTask = [select id from WebEngage_Task__c limit 1];
        Set<Id> setOfIds = new Set<Id>();
        setOfIds.add(webEngageTask.id);
        Test.startTest();
        Database.executeBatch(new WebEngageChangeEventBatch(setOfIds));
        test.stopTest();
    }
    public testMethod static void WebEngageChangeEventBatchTest3(){
        
        Test.startTest();
        System.schedule('WebEngageUserEventBatch', '0 0 * * * ?', new WebEngageChangeEventBatch());
        test.stopTest();
    }
    public testMethod static void WebEngageUserEventBatchTestdoowup2(){
        
         webEngageTask = [select id from WebEngage_Task__c limit 1];
        webEngageTask.Brand__c='Doowup';
        update webEngageTask;
        Set<Id> setOfIds = new Set<Id>();
        setOfIds.add(webEngageTask.id);
        Test.startTest();
        Database.executeBatch(new WebEngageUserEventBatch(setOfIds));
        test.stopTest();
    }
}