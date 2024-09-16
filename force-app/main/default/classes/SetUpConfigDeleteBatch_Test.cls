@IsTest
public class SetUpConfigDeleteBatch_Test {
public static Setup_Configuration__c setUp;
    Public static Lead ld;
   
    Public static Showroom_User__C IMRec;
    @TestSetup static void data() {
        //Create Lead Record
        ld = TestData_Factory.CreateFreshLead(true);
        
        IMRec = TestData_factory.createShowroomUser(true);
     Setup_Configuration__c setUp = new  Setup_Configuration__c();
        
        
        
        
        insert setUp;
    }
     public testMethod static void SetUpConfigDeleteBatchTest3(){
         Test.startTest();
       SetUpConfigDeleteBatch  sh1 = new SetUpConfigDeleteBatch();
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Check', sch, sh1); 
        
        Database.executeBatch(new SetUpConfigDeleteBatch());
        test.stopTest();
    }
    public static testMethod void leadOrOpportunityUpdateTest1(){
        Test.startTest();
        ld =[select Id from Lead Limit 1];
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Operation_Status__c ='Closed';
        setUp.Lead__c = ld.id;
        setUp.Initiator_Email__c= 'abc@abc.com';
        setUp.Type_Of_Transfer__c ='IM Transfer';
        
        update setUp;
     SetUpConfigDeleteBatch ldTransfer = new SetUpConfigDeleteBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
   
}