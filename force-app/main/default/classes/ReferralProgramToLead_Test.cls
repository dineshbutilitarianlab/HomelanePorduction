@isTest 
public class ReferralProgramToLead_Test {
    public static testMethod void referral() {
        List<Referrer__c> ref = new List<Referrer__c>();
        Referrer__c r = new Referrer__c();
        r.Name = 'Test';
        r.Email__c = 'test@test.com';
        r.Phone__c = '0000000000';
        r.Referral_Program__c = 'Ambassador';
        r.City__c = 'Pune';
        ref.add(r);
        
        Referrer__c r1 = new Referrer__c();
        r1.Name = 'Test1';
        r1.Email__c = 'test1@test.com';
        r1.Phone__c = '0000000001';
        r1.City__c = 'Pune';
        r1.Referral_Program__c = 'Ambassador';
        
        ref.add(r1);
        insert ref;
        
        lead newLead = new Lead();
        newLead.Email = 'test@test.com';
        newLead.lastName = 'Test';
        newLead.Phone = '1234567890';
        newLead.LeadSource = 'Google Ad';
        newLead.Status = 'Fresh Lead';
        newLead.Budget_Range__c = '1.5L - 4L';
        newLead.City = 'Bengaluru';
        newLead.Regional_Language_Preference__c = 'Hindi';  
        newLead.HL_Referrer_Phone__c = '0000000000';      
        insert newLead;    
        newLead.HL_Referrer_Phone__c = '0000000001';     
        update newLead;
      
    }
}