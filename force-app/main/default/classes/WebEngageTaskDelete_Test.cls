@isTest
public class WebEngageTaskDelete_Test {
    
    Public static WebEngage_Task__c webEngageTask;
    Public static Lead ld;
    @TestSetup static void data() {
        ld = TestData_Factory.CreateFreshLead(false);
        insert ld;
        webEngageTask = TestData_Factory.createWebEngageEventTask(ld.id,null,'Appointment Details Updated','Change Event',true);
    }
    
    public testMethod static void WebEngageTest1(){
        
        Test.startTest();
        WebEngage_Task__c webTaskList =[select id from WebEngage_Task__c limit 1];
        webTasklist.Status__c='Closed';
        update webTaskList;
        
        WebEngageTaskDelete_Batch webTask = new WebEngageTaskDelete_Batch();
        database.executeBatch(webTask);
        Test.stopTest();
    }
    public testMethod static void WebEngageTest2(){
        Test.startTest();
        WebEngageTaskDelete_Batch   sh1 = new WebEngageTaskDelete_Batch();
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Check', sch, sh1); 
        
        Database.executeBatch(new WebEngageTaskDelete_Batch());
        test.stopTest();
    }
    
}