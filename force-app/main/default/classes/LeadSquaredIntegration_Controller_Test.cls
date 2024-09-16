/**
 * @File Name          : LeadSquaredIntegration_Controller_Test.cls
 * @Description        : 
 * @Author             : Bharatesh Shetty
 * @Group              : 
 * @Last Modified By   : Bharatesh Shetty
 * @Last Modified On   : 8/29/2019, 11:03:47 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/29/2019, 11:03:47 AM   Bharatesh Shetty     Initial Version
**/
@isTest
public class LeadSquaredIntegration_Controller_Test{
    Public static User u;
    Public static Lead ld;
    Public static Account acc;
    Public static Opportunity opp;
    Public static Lead_Square_Mapping__c leadSquareMap;
    Public static Integration_Setting__c intSetting;
    @TestSetup static void data() { 
        //Create User record
        ld = TestData_Factory.CreateFreshLead(false);
        //ld.Lead_square_modified_date__c = Date.today();
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
    public testMethod static void getLeadSquaredRequestWrapperTest1(){
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        test.startTest();
        List<sObject> listOfSObject = new List<sObject>();
        String queryString = 'select id';
        for(Schema.FieldSetMember fld :SObjectType.Lead.FieldSets.Lead_Square_Integration_Leads.getFields()) {
         	queryString += ', ' + fld.getFieldPath();
        }
        queryString += ',Lead_square_modified_date__c from Lead limit 1';
        listOfSObject = Database.query(queryString);
        
        LeadSquareIntegration_Controller.ResponseWrapper requestWrapper = new LeadSquareIntegration_Controller.ResponseWrapper();
        requestWrapper = LeadSquareIntegration_Controller.getLeadSquaredRequestWrapper(listOfSObject,'Lead');
        LeadSquareIntegration_Controller.calloutToLeadSquared(requestWrapper.sbody,'LeadSquared API');
        LeadSquareIntegration_Controller.calloutToLeadSquared(null,null);
        test.stopTest();
    }
    public testMethod static void getLeadSquaredRequestWrapperTest2(){
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        opp = [Select id,Name from Opportunity limit 1];
        opp.Name ='Some Name Changed from something';
        opp.Assigned_to_Resi_ASM__c = false;
        update opp;
        test.startTest();
        List<sObject> listOfSObject = new List<sObject>();
        String queryString = 'select id';
        for(Schema.FieldSetMember fld :SObjectType.Opportunity.FieldSets.Lead_Square_Integration_Opportunity.getFields()) {
         	queryString += ', ' + fld.getFieldPath();
        }
        queryString += ',Lead_square_modified_date__c from Opportunity limit 1';
        listOfSObject = Database.query(queryString);
        
        LeadSquareIntegration_Controller.ResponseWrapper requestWrapper = new LeadSquareIntegration_Controller.ResponseWrapper();
        requestWrapper = LeadSquareIntegration_Controller.getLeadSquaredRequestWrapper(listOfSObject,'Opportunity');
        LeadSquareIntegration_Controller.calloutToLeadSquared(requestWrapper.sbody,'LeadSquared API');
        LeadSquareIntegration_Controller.calloutToLeadSquared(null,null);
        test.stopTest();
    }
    public testMethod static void checkIfLeadSquareFieldsModified1(){
        //opp = [Select id from];
    }
}