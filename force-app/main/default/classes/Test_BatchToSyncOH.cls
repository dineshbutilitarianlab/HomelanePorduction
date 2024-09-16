@isTest
public class Test_BatchToSyncOH {
     public static  testMethod void runBatchForSync(){
        Lead ld = TestData_Factory.CreateFreshLead(true); 
        Account acc = TestData_Factory.createAccount(true);
        Opportunity op = TestData_Factory.createOpportunity(acc.Id, true);
        Batch_ToSyncLeadsOH batch = new Batch_ToSyncLeadsOH();
        DataBase.executeBatch(batch, 200);
       Batch_ToSyncOppsOH batch2 = new Batch_ToSyncOppsOH();
        DataBase.executeBatch(batch2, 200);
         SchedulableContext sc;
        batch.execute(sc);
         
        batch2.execute(sc);
    }
}