@isTest
public class Test_Batch_ToSyncOppFormulaFields {
    
    public static  testMethod void runBatchForSync(){
        opportunity op = new Opportunity();
        op.follow_up_time__c = System.today()-1;
        op.Name = 'Homelane test';
        op.StageName = 'new';
        op.CloseDate = System.today()+3;
        insert op;
        Batch_ToSyncOppFormulaFieldsToWebHook batch = new Batch_ToSyncOppFormulaFieldsToWebHook();
        DataBase.executeBatch(batch, 1);
        SchedulableContext sc;
        batch.execute(sc);
    }
}