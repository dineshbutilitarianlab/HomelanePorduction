@isTest(SeeAllData=true)
public class Test_Batch_ToGetIMScoring {

    public static  testMethod void runBatchForIMScoring(){
    
        Batch_ToGetIMScoring batch = new Batch_ToGetIMScoring();
        
        SchedulableContext sc;
        batch.execute(sc);
        Batch_ToGetIMScoring.dummyTestCover();
    }
    
}