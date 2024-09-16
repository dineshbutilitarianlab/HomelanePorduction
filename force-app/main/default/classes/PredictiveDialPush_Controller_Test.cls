@isTest
public class PredictiveDialPush_Controller_Test {
    Public static Lead ld;
    Public static Account acc;
    Public static List<Lead> listOfLeads;
    @TestSetup static void data() { 
        
        acc = new account();
        acc.Name='testeacc';
        insert acc;
        
        //Create User record
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Account__c = acc.id;
        insert ld;
    }
    public testMethod static void test1(){
        Test.StartTest();
        ld = [Select id from Lead limit 1];
        listOfLeads = new List<Lead>();
        listOfLeads.add(ld);
        Test.setCurrentPage(Page.PredictiveDailPushPage);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(listOfLeads);
        stdSetController.setSelected(listOfLeads);
        PredictiveDialPush_Controller sp = new PredictiveDialPush_Controller(stdSetController);
        PredictiveDialPush_Controller.updateDiallerCampaignStatusCallIntiated();
        test.stoptest();  
    }
    public testMethod static void test2(){
        Test.StartTest();
        ld = [Select id from Lead limit 1];
        ld.Status = 'Fresh Lead';
        ld.Bulk_Upload__c = True;
        ld.Assigned_to_Resi_ASM__c = False;
        ld.Dialler_Campaign_Type_and_Status__c = '';
        update ld;
        
        listOfLeads = new List<Lead>();
        listOfLeads.add(ld);
        
        Test.setCurrentPage(Page.PredictiveDailPushPage);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(listOfLeads);
        stdSetController.setSelected(listOfLeads);
        PredictiveDialPush_Controller sp = new PredictiveDialPush_Controller(stdSetController);
        PredictiveDialPush_Controller.updateDiallerCampaignStatusCallIntiated();
        test.stoptest();  
    }
    public testMethod static void test3(){
        Test.StartTest();
        ld = [Select id from Lead limit 1];
        listOfLeads = new List<Lead>();
        Test.setCurrentPage(Page.PredictiveDailPushPage);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(listOfLeads);
        stdSetController.setSelected(listOfLeads);
        PredictiveDialPush_Controller sp = new PredictiveDialPush_Controller(stdSetController);
        PredictiveDialPush_Controller.updateDiallerCampaignStatusCallIntiated();
        test.stoptest();  
    }
}