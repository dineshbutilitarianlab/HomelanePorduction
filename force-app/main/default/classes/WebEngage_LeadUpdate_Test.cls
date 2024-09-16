@isTest
public class WebEngage_LeadUpdate_Test{
    Public static User u;
    Public static Lead ld;
    Public static Channel_partner__c cp;
    Public static Channel_partner__c ambassador;
    @TestSetup static void data() { 
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Customer_ID__c ='BEN-ABCD-0001';
        insert ld;
    }
    public testMethod static void WebEngage_LeadUpdateTest1() {
        try{
            List<Lead> listofLead = [select id,Customer_ID__c from Lead limit 1];
            Lead dummyLead = new Lead();
            listofLead.add(dummyLead);
            Test.StartTest();
            System.enqueueJob(new WebEngage_LeadUpdate(listofLead));
            //System.enqueueJob(new WebEngage_LeadUpdate(null));
            Test.StopTest();
        }
        catch(Exception e){
            
        }  
    }
}