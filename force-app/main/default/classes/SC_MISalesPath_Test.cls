@isTest
public class SC_MISalesPath_Test {
    public static TestMethod void testMethodOne(){
        Test.startTest();
        SC_MISalesPath.getOpportunityStages();
        SC_MISalesPath.refresh();
        Test.stopTest();
    }
}