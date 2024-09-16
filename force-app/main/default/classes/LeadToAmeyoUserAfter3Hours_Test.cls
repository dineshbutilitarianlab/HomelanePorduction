@isTest
public class LeadToAmeyoUserAfter3Hours_Test {
    public testmethod static void setup() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    
        User usr = new User(LastName = 'LIVESTON',
                           FirstName='JASON',
                           Alias = 'jliv',
                           Email = 'jason.liveston@asdf.com',
                           Username = 'jasongadfgdfgdf.liveston@asdf.com',
                           ProfileId = p.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert usr;
        System.debug('****User : '+usr);
        
        UserIds__c userId = new UserIds__c();
        userId.Name = 'Ameyo User';
        userId.Id__c = usr.Id;
        insert userId;          
            
        
        lead newLead = new Lead();
        newLead.Email = 'test@test.com';
        newLead.lastName = 'Test';
        newLead.Phone = '1234567890';
        newLead.LeadSource = 'Unqualified Walk-in';
        newLead.Status = 'Fresh Lead';
        newLead.sub_status__c = 'Visited Showroom';
        newLead.Push_lead_to_Ameyo_Time__c = System.now().addHours(3);
        newLead.Follow_up_time__c = Date.today();
        newLead.City = 'Bengaluru';       
        insert newLead;
        System.debug('****newLead  '+newLead);
        newLead.OwnerId = userId.Id__c;
        newLead.Push_lead_to_Ameyo_Time__c = System.now();
        newLead.WT_Agent__c = userId.Id__c;
        update newLead; 
        
        System.debug('****newLead  '+newLead); 
        Test.startTest();
        LeadToAmeyoUserAfter3Hours lta = new LeadToAmeyoUserAfter3Hours();
        DataBase.executeBatch(lta);
        Test.stopTest();
        
      }
}