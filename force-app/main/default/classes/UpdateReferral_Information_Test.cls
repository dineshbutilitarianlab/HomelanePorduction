@isTest
public class UpdateReferral_Information_Test{
    Public static User u;
    Public static Lead ld;
    Public static Channel_partner__c cp;
    Public static Channel_partner__c ambassador;
    @TestSetup static void data() { 
        //Create User record
        cp = TestData_Factory.createChannelPartner('testCP', '1234567834','Broker/Channel Partner', true);
        ambassador = TestData_Factory.createChannelPartner('testambassador', '1234567835','Ambassador', true);
        account acc= new account();
        acc.name='Testacc';
        insert acc;
        ld = TestData_Factory.CreateFreshLead(false);
        ld.HL_Referrer_Phone__c = '1234567834';
        ld.Bulk_Upload__c = True;
        ld.LeadSource = 'Broker/Channel Partner';
        ld.PostalCode = '560040';
        ld.Channel_Partner__c = cp.Id;
        ld.Account__c =acc.id;
        insert ld;
    }
    public testMethod static void UpdateReferralTest1() {
        try{
            Test.StartTest();
            ld = [select id from Lead limit 1];
            ld.HL_Referrer_Phone__c = '1234567835';
            update ld;
            
            Test.StopTest();
        }
        catch(Exception e){
            
        }
        
    }
    public testMethod static void UpdateReferralTest2() {
        try{
            Test.StartTest();
            ld = [select id from Lead limit 1];
            ld.HL_Referrer_Phone__c = '1234567836';
            update ld;
            Test.StopTest();
        }
        catch(Exception e){
            
        }
    }
    public testMethod static void UpdateReferralTest3() {
        try{
            Test.StartTest();
            ld = [select id from Lead limit 1];
            ld.HL_Referrer_Phone__c = '1234567836';
            ld.Bulk_Upload__c = False;
            update ld;
            Test.StopTest();
        }
        catch(Exception e){
        }
    }
    public testMethod static void UpdateReferralTest4() {
        try{
            Test.StartTest();
            ld = [select id from Lead limit 1];
            ld.HL_Referrer_Phone__c =null;
            update ld;
            UpdateReferral_Information.UpdateReferral(null,null);
            Test.StopTest();
        }
        catch(Exception e){
            
        }
    } 
}