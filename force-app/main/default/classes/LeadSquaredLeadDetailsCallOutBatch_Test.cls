@isTest
public class LeadSquaredLeadDetailsCallOutBatch_Test{
  Public static User u;
    Public static Lead ld;
    @TestSetup static void data() { 
        //Create User record
        u = TestData_Factory.inserWTAUser('bhara@test.in', 'testUser', true);
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Lead_square_modified_date__c = Date.today();
        insert ld;
    }
    public testMethod static void updateLeadSquareModifeidDateTest2() {
      
        set<id> setIds = new set<id>();
        list<Lead> lstlead = [select id,Status,Lead_square_modified_date__c,Full_Name__c from Lead limit 1];
        if(!lstlead.isEmpty()){
            for(lead l:lstlead){
                setIds.add(l.id);
            }
        }
       
        Test.StartTest();
            system.assertEquals(1, setIds.size());
            LeadSquaredLeadDetailsCallOutBatch ObjBatch = new LeadSquaredLeadDetailsCallOutBatch(setIds);
            LeadSquaredLeadDetailsCallOutBatch ObjBatch1 = new LeadSquaredLeadDetailsCallOutBatch();
            DataBase.executeBatch(ObjBatch);

        Test.StopTest();
    }
    public testMethod Static void scheduleLeadBatchTest1(){
        /*set<id> setIds = new set<id>();
        list<Lead> lstlead = [select id,Status,Lead_square_modified_date__c,Full_Name__c from Lead limit 1];
        if(!lstlead.isEmpty()){
            for(lead l:lstlead){
                setIds.add(l.id);
            }
        }*/
       
        Test.StartTest();
        LeadSquaredLeadDetailsCallOutBatch sh1 = new LeadSquaredLeadDetailsCallOutBatch();
		String sch = '0 0 23 * * ?'; 
        system.schedule('Test lead details batch', sch, sh1); 
        Test.StopTest();
    }
}