@isTest
public class OutOfServiceCity_Controller_test{
    Public static Lead l;
    @TestSetup static void data() { 
        l = TestData_Factory.CreateFreshLead(true);
    }
    public static testMethod void Pass() {
         
        /*Lead l = new Lead();
        l.FirstName = 'Hamsa';
        l.LastName = 'Raj';
        l.Email = 'HamsaRaj@gmail.com';
        l.Phone = '9000000009';
        l.City = 'Bengaluru';
        l.LeadSource = 'Google Ad';
        l.Status = 'Fresh Lead';
        l.Sub_Status__c = 'New';
        insert l; */
    
         l = [Select id,Out_of_Servicing_City__c from Lead limit 1];
         PageReference pageRef = Page.OutOfServiceCity;
         Test.setCurrentPage(pageRef);
         ApexPages.StandardController sc = new ApexPages.StandardController(l);
         OutOfServiceCity_Controller Objcontroller= new OutOfServiceCity_Controller(sc);
         System.currentPageReference().getParameters().put('scity', 'test');

         Objcontroller.scity = 'test';
         Objcontroller.UpdateCity();
         
      }
        
}