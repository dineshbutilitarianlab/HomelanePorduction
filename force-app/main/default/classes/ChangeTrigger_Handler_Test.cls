@isTest
public class ChangeTrigger_Handler_Test {
    Public static User u;
    Public static Lead ld;
    Public static Account acc;
    Public static Opportunity opp;
    Public static WebEngage_Task__c webEngageTask;
    @TestSetup static void data() { 
        //Create User record
        /*ld = TestData_Factory.CreateFreshLead(false);
        ld.Lead_square_modified_date__c = Date.today();
        ld.Assigned_to_Resi_ASM__c = true;
        insert ld; */
        
        //Create account record
        acc = TestData_Factory.createAccount(True);
        
        //Create Opportunity record
        //opp = TestData_Factory.createOpportunity(acc.Id,True);
    }
    public testMethod static void leadchangeEventTest1(){
        Test.enableChangeDataCapture();
        //Test.startTest();
        //ld = [Select id from Lead limit 1];
        acc = [Select id from Account limit 1];
        
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Lead_square_modified_date__c = Date.today();
        ld.Assigned_to_Resi_ASM__c = true;
        ld.Account__c= acc.id;
        insert ld;
        
        webEngageTask = TestData_Factory.createWebEngageEventTask(ld.id,null,'Property Details Update','Change Event',true);
        
        Test.getEventBus().deliver();
        
        ld.Property_Config__c = '1 BHK';
        ld.LastName ='changed to some name';
        update ld;
        Test.getEventBus().deliver();
        //test.stopTest();
    }
    public testMethod static void leadchangeEventTest2(){
        Test.enableChangeDataCapture();
        acc = [Select id from Account limit 1];
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Lead_square_modified_date__c = Date.today();
        ld.Assigned_to_Resi_ASM__c = true;
        ld.Account__c=acc.id;
        insert ld;
        
        Test.getEventBus().deliver();
        
        ld.Property_Config__c = '1 BHK';
        ld.LastName ='changed to some name';
        update ld;
        Test.getEventBus().deliver();
        //test.stopTest();
    }
    public testMethod static void OppportunitychangeEventTest1(){
        Test.enableChangeDataCapture();
        
        acc = [Select id from Account limit 1];
        //Create Opportunity record
        opp = TestData_Factory.createOpportunity(acc.Id,false);
        insert opp;
        webEngageTask = TestData_Factory.createWebEngageEventTask(null,opp.id,'New Opportunity Status is Changed','Change Event',true);
        Test.getEventBus().deliver();
        
        opp.Amount = 1000;
        update opp;
        
        Test.getEventBus().deliver();
        //test.stopTest();
    }
    public testMethod static void OppportunitychangeEventTest2(){
        Test.enableChangeDataCapture();
        
        acc = [Select id from Account limit 1];
        //Create Opportunity record
        opp = TestData_Factory.createOpportunity(acc.Id,false);
        insert opp;
        
        Test.getEventBus().deliver();
        
        opp.Amount = 1000;
        update opp;
        
        Test.getEventBus().deliver();
        //test.stopTest();
    }
}