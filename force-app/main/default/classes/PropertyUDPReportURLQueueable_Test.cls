@isTest
public class PropertyUDPReportURLQueueable_Test{
    Public static Lead ld;
    Public static Integration_Setting__c intSetting;
    @TestSetup static void data() { 
        //Create User record
        ld = TestData_Factory.CreateFreshLead(false);
       // ld.Lead_square_modified_date__c = Date.today();
        ld.Assigned_to_Resi_ASM__c = true;
        ld.Lead_Property_Name__c = 'ABC property name';
        insert ld;
        
        
        // Create integration Setting record for Lead square
        intSetting = TestData_Factory.createIntegrationSetting('UDP_Property_Report_URL_API','http://3.1.38.107:5000/link','eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzb21lIjoicGF5bG9hZCJ9.2z3S7N7VekXPl2UeZpIonXviPKKerZ1R9bGN1qGCT5w','application/json','');
    }
    public testMethod static void PropertyUDPReportURLQueueable_Test1() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test()); 
        Map<String,String> mapOfLeadAndPropertyName = new Map<String,String>();
        Lead ld = [Select id,Lead_Property_Name__c from Lead limit 1];
        mapOfLeadAndPropertyName.put(ld.Id,ld.Lead_Property_Name__c);
        PropertyUDPReportURLQueueable emailQueable = new PropertyUDPReportURLQueueable(mapOfLeadAndPropertyName);
        System.enqueueJob(emailQueable);
        
        Map<String,String> mapOfLeadAndPropertyName2 = new Map<String,String>();
        PropertyUDPReportURLQueueable emailQueable2 = new PropertyUDPReportURLQueueable(mapOfLeadAndPropertyName2);
        System.enqueueJob(emailQueable2);
        
        Test.StopTest();
    }
}