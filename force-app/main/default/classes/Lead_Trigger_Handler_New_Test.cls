@istest
global class Lead_Trigger_Handler_New_Test  
{
    
    Public static Lead ld;
    Public static Showroom_User__c showroomuser;
    Public static Account ac;
    
    @TestSetup static void data() 
    {
        Account ac = new account();
        ac.name='Test Account';
        insert ac;
       
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Status = 'Fresh Lead';
        ld.Sub_Status__c = 'Unverified';
        ld.Account__c =ac.id;
        ld.postalcode='123456';
        ld.city='Bengaluru';
        ld.Phone='9988772244';
        ld.Description = 'Test Line 1';
        insert ld;
    }
    
    
    public static testMethod void UpdateDescriptionTest()
    {
        list<Lead> lstLead = [Select Id,email,LastName,LeadSource,Postalcode,city,Assigned_To_Resi_ASM__c,Should_run_Ironman_assignment__c,Description,
                              phone,Squad_IQ_Status__c,Status,Sub_Status__c,Bulk_Upload__C,Brand__c,Meeting_Source__c From Lead Limit 1];
        String UserName = UserInfo.getUserName();
        Test.startTest();
        
        Lead newLead = new Lead();
        newLead.Id=lstLead[0].id;
        newLead.Description = 'Test Line 2';        
        Update newLead;        
               
        System.Debug('UserName-' + UserName);
        System.debug('Description ' + newLead.Description);
        Test.stopTest();
       
    }
    
}