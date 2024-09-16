@isTest
public class OfflineLeadsOzoneTelPushQueueable_Test {
    Public static Lead ld;
    Public static Account acc;
    Public static List<Lead> listOfLeads;
    Public static Integration_Setting__c intSetting;
    @TestSetup static void data() { 
        //Create User record
        acc = new account();
        acc.Name='testeacc';
        insert acc;
        
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Status = 'Fresh Lead';
        ld.Bulk_Upload__c = True;
        ld.Assigned_to_Resi_ASM__c = False;
        ld.Account__c = acc.id;
        insert ld;
        
        // create Integration Setting
        intSetting = TestData_Factory.createIntegrationSetting('OzoneTel addCamapaignData API','https://api1.cloudagent.in/cloudAgentRestAPI/index.php/CloudAgent/CloudAgentAPI/addCamapaignData?','u$r132fe08ce31d4b4f','application/json','KK1974dd56933b4c69602c063d589e19ab');
    }
    /*public testMethod static void test1(){
        Test.StartTest();
        ld = [Select id from Lead limit 1];
        ld.Status = 'Fresh Lead';
        ld.Bulk_Upload__c = True;
        ld.Assigned_to_Resi_ASM__c = False;
        ld.Dialler_Campaign_Type_and_Status__c = '';
        update ld;
        
        listOfLeads = new List<Lead>();
        listOfLeads.add(ld);
        
        Test.setCurrentPage(Page.ProgressiveDailPushPage);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(listOfLeads);
        stdSetController.setSelected(listOfLeads);
        ProgressiveDialPush_Controller sp = new ProgressiveDialPush_Controller(stdSetController);
        ProgressiveDialPush_Controller.updateDiallerCampaignStatusCallIntiated();
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
    }*/
    public testMethod static void test1(){
        
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        Test.StartTest();
        ld = [Select id from Lead limit 1];
   //     ld.Offline_Priority_Lead__c = True;
        ld.Dialler_Campaign_Type_and_Status__c = 'Progressive Dial Initiated';
        update ld;
        
        Set<String> setOfIdsToEnqueJob = new Set<String>();
        setOfIdsToEnqueJob.add(ld.Id);
        ID jobID = System.enqueueJob(new OfflineLeadsOzoneTelPushQueueable(setOfIdsToEnqueJob));
        test.stoptest();  
    }
    public testMethod static void test2(){
        
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        Test.StartTest();
        ld = [Select id from Lead limit 1];
   //     ld.Offline_Priority_Lead__c = True;
        ld.Dialler_Campaign_Type_and_Status__c = 'Predictive Dial Initiated';
        update ld;
        
        Set<String> setOfIdsToEnqueJob = new Set<String>();
        setOfIdsToEnqueJob.add(ld.Id);
        ID jobID = System.enqueueJob(new OfflineLeadsOzoneTelPushQueueable(setOfIdsToEnqueJob));
        test.stoptest();  
    }
    public testMethod static void test3(){
        
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        Test.StartTest();
        ld = [Select id from Lead limit 1];
   //     ld.Offline_Priority_Lead__c = False;
        ld.Dialler_Campaign_Type_and_Status__c = 'Progressive Dial Initiated';
        update ld;
        
        Set<String> setOfIdsToEnqueJob = new Set<String>();
        setOfIdsToEnqueJob.add(ld.Id);
        ID jobID = System.enqueueJob(new OfflineLeadsOzoneTelPushQueueable(setOfIdsToEnqueJob));
        test.stoptest();  
    }
    public testMethod static void test4(){
        
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        Test.StartTest();
        ld = [Select id from Lead limit 1];
 //       ld.Offline_Priority_Lead__c = False;
        ld.Dialler_Campaign_Type_and_Status__c = 'Predictive Dial Initiated';
        update ld;
        
        Set<String> setOfIdsToEnqueJob = new Set<String>();
        setOfIdsToEnqueJob.add(ld.Id);
        ID jobID = System.enqueueJob(new OfflineLeadsOzoneTelPushQueueable(setOfIdsToEnqueJob));
        test.stoptest();  
    }
    public testMethod static void test5(){
        Test.StartTest();
        OfflineLeadsOzoneTelPushQueueable.pushLeadToOzoneTelEventsFuture(null,null,null,null);
        test.stoptest();  
    }
}