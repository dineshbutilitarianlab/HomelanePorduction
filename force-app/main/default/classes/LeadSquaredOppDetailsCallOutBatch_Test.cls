@isTest
public class LeadSquaredOppDetailsCallOutBatch_Test{
    Public static User u;
    Public static Account acc;
    Public static Opportunity opp;
    Public static Lead_Square_Mapping__c leadSquareMap;
    Public static Integration_Setting__c intSetting;
    @TestSetup static void data() { 
        
        //Create account record
        acc = TestData_Factory.createAccount(True);
        
        //Create Opportunity record
        opp = TestData_Factory.createOpportunity(acc.Id,True);
        
        // Create integration Setting record for Lead square
        intSetting = TestData_Factory.createIntegrationSetting('LeadSquared API','https://api-in21.leadsquared.com/v2/LeadManagement.svc/Lead/Bulk/CreateOrUpdate?','u$r132fe08ce31d4b4f','application/json','2e388d2e3c98');
        
        // Create LeadSquare Mapping record for Lead Square
        leadSquareMap = TestData_Factory.createLeadSquareMapping(false,'LastName','Name','Full_Name__c','Name');
    }
    public testMethod static void opportunityBatchHandler3() {
        
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test()); 
        
        
        Map<id,SObject> mapSobject = new Map<id,SObject> ([select id,Name,Lead_square_modified_date__c,StageName,Assigned_to_Resi_ASM__c,Lead_Squared_Id__c from Opportunity limit 1]);
        
        Test.StartTest();
        LeadSquaredBatchCallOutHandler.handleLeadSquaredDetailsCallOuts(mapSobject,'Opportunity');
        
        Test.StopTest();
    }
    public testMethod static void OpportunityBatchTest1() {
      
        set<id> setIds = new set<id>();
        list<Opportunity> lstlead = [select id,Name,Lead_square_modified_date__c,StageName,Assigned_to_Resi_ASM__c,Lead_Squared_Id__c from Opportunity limit 1];
        if(!lstlead.isEmpty()){
            for(Opportunity opp:lstlead){
                setIds.add(opp.id);
            }
        }
       
        Test.StartTest();
            system.assertEquals(1, setIds.size());
            LeadSquaredOppDetailsCallOutBatch ObjBatch = new LeadSquaredOppDetailsCallOutBatch(setIds);
            LeadSquaredOppDetailsCallOutBatch ObjBatch1 = new LeadSquaredOppDetailsCallOutBatch();
            DataBase.executeBatch(ObjBatch);

        Test.StopTest();
    }
    public testMethod Static void scheduleOpportunityBatchTest1(){
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test()); 
        Test.StartTest();
        
        LeadSquaredOppDetailsCallOutBatch sh1 = new LeadSquaredOppDetailsCallOutBatch();
		String sch = '0 0 23 * * ?'; 
        system.schedule('Test opp details batch', sch, sh1); 
        Test.StopTest();
    }
}