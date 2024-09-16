@isTest
public class RoutingHLLeadCounter_Test {
 public Lead_Class_Scoring__c lcs;
    
    @TestSetup static void data() {
        Id recTypeId = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Routing HL Leads').getRecordTypeId();
       Lead_Class_Scoring__c lcs = new Lead_Class_Scoring__c();
        lcs.RecordTypeId =recTypeId;
        lcs.Budget_Counter__c=6;
        lcs.Budget_Counter_Limit__c=25;
        insert lcs;
        
    }
      public testMethod static void RoutingHLLeadCounterTest1(){
        Test.startTest();
        Database.executeBatch(new RoutingHLCountResetBatch ());
        test.stopTest();
    }
    public testMethod static void RoutingHLLeadCounterTest2(){
        Test.startTest();
         RoutingHLCountResetBatch  sh1 = new RoutingHLCountResetBatch();      
    String sch = '0 0 23 * * ?';
 system.schedule('Test check', sch, sh1);
    Test.stopTest();
    }
}