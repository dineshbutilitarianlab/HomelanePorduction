@isTest
public class LeadSquaredBatchCallOutHandler_Test{
    Public static User u;
    Public static Lead ld;
    Public static Account acc;
    Public static Opportunity opp;
    Public static Lead_Square_Mapping__c leadSquareMap;
    Public static Integration_Setting__c intSetting;
    @TestSetup static void data() { 
        //Create User record
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Lead_square_modified_date__c = Date.today();
        ld.Assigned_to_Resi_ASM__c = true;
        insert ld;
        
        //Create account record
        acc = TestData_Factory.createAccount(True);
        
        //Create Opportunity record
        opp = TestData_Factory.createOpportunity(acc.Id,True);
        
        // Create integration Setting record for Lead square
        intSetting = TestData_Factory.createIntegrationSetting('LeadSquared API','https://api-in21.leadsquared.com/v2/LeadManagement.svc/Lead/Bulk/CreateOrUpdate?','u$r132fe08ce31d4b4f','application/json','2e388d2e3c98');
        
        // Create LeadSquare Mapping record for Lead Square
        leadSquareMap = TestData_Factory.createLeadSquareMapping(false,'LastName','Name','Full_Name__c','Name');
    }
    public testMethod static void updateLeadSquareModifeidDateTest2() {
        
        
        /*Integration_Setting__c intSetting = new Integration_Setting__c();
        intSetting.Name = 'LeadSquared API';
        intSetting.End_Point__c = 'https://api-in21.leadsquared.com/v2/LeadManagement.svc/Lead/Bulk/CreateOrUpdate?';
        intSetting.Authorization__c = 'u$r132fe08ce31d4b4f';
        intSetting.ContentType__c = 'application/json';
        intSetting.Secret_Key__c = '2e388d2e3c98';
        insert intSetting;
        
        Lead_Square_Mapping__c leadSquareMap = new Lead_Square_Mapping__c();
        leadSquareMap.IsDateField__c = false;
        leadSquareMap.Lead_Square_Field__c ='LastName';
        leadSquareMap.SF_Lead_Field__c ='Full_Name__c';
        leadSquareMap.SF_Opportunity_Field__c ='Name';
        leadSquareMap.Name = 'Full Name';
        insert leadSquareMap;
*/
        
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test()); 
        
        
        Map<id,SObject> mapSobject = new Map<id,SObject> ([select id,Status,Lead_Squared_Id__c,Lead_square_modified_date__c,Full_Name__c from Lead limit 1]);
        
        Test.StartTest();
        LeadSquaredBatchCallOutHandler.handleLeadSquaredDetailsCallOuts(mapSobject,'Lead');
        
        Test.StopTest();
    }
    public testMethod static void opportunityBatchHandler3() {
        
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test()); 
        
        
        Map<id,SObject> mapSobject = new Map<id,SObject> ([select id,Name,Lead_square_modified_date__c,StageName,Assigned_to_Resi_ASM__c,Lead_Squared_Id__c from Opportunity limit 1]);
        
        Test.StartTest();
        LeadSquaredBatchCallOutHandler.handleLeadSquaredDetailsCallOuts(mapSobject,'Opportunity');
        
        Test.StopTest();
    }
}