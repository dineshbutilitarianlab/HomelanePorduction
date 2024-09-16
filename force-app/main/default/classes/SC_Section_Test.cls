@isTest
public class SC_Section_Test {
    public static TestMethod void testMethodOne(){
        SC_Section__c sc = SC_MI_TestHandler.insertSection('Test Section','Site Measurement Meeting Confirmed',10,NULL);
        insert sc;
        ApexPages.currentPage().getParameters().put('id',sc.Id);
        ApexPages.StandardController scp = new ApexPages.StandardController(sc);
        SC_Section scEdit = new SC_Section(scp);
    }
}