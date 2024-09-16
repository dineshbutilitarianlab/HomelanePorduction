@isTest
public class OpportunityChangeTrigger_Test {
    Public static Account acc;
    Public static Opportunity opp;
    @TestSetup static void data() { 
        
        acc = TestData_Factory.createAccount(True);
       
    }
    public testMethod static void OppportunitychangeEventTest1(){
        Test.enableChangeDataCapture();
        //Test.startTest();
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