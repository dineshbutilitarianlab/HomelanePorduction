@isTest
public class OppPipelineNewCloseDateDelete_Batch_test 
{
	Public static Opportunity opp;
    public static Account acc;
    
    @TestSetup 
    static void data() 
    { 
        //Create account
        acc = TestData_Factory.createAccount(false);
        insert acc;
        
        //Create Opportunity
        opp = TestData_Factory.createOpportunity(acc.Id,True);
        opp.New_Close_Date__c = System.today().addDays(-1);
        opp.Opportunity_Funnel_Status__c = 'Pipeline';
        
        update opp;
        
      }
   
    public testMethod static void OppBatchTest1()
    {
        Test.startTest();
        Database.executeBatch(new OppPipelineNewCloseDateDelete_Batch());
        Test.stopTest();
     }
    
    public testMethod static void OppBatchTest2()
    {        
        opp = [select id,Opportunity_Funnel_Status__c,Second_meeting_appointment_time__c from Opportunity limit 1];
        
        Test.startTest();
        Set<Id> setOfIds = new Set<Id>();
        setOfIds.add(opp.id);
        Database.executeBatch(new OppPipelineNewCloseDateDelete_Batch(setOfIds));
        Test.stopTest();
    }
    
    public testMethod static void OppBatchTest3()
    {
        Test.startTest();
        String sch = '0 0 23 * * ?';
        System.schedule('OppPipelineNewCloseDateDelete_Batch',sch, new OppPipelineNewCloseDateDelete_Batch());
        Test.stopTest();
    }
    
}