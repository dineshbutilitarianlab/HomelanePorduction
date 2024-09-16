@isTest
public class Test_Batch_ToCopyAccountIdToTemp {
    
    public static  testMethod void runBatchForSync(){
        Account acc= new Account();
        acc.LastName = 'Test';
        acc.Customer_ID__c = 'Abc';
        insert acc;
        Batch_ToCopyAccountIdToTemp batch = new Batch_ToCopyAccountIdToTemp();
        DataBase.executeBatch(batch, 1);
        SchedulableContext sc;
        batch.execute(sc);
    }
}