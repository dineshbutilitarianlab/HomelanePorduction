@isTest
public class SendEmailAfter6Hrs_Test {
   
   public static testMethod void passwordresettest(){
UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
system.debug('portalRole is ' + portalRole);

Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
system.debug('profile1  is ' + profile1 );
User portalAccountOwner1 = new User(
UserRoleId = portalRole.Id,
ProfileId = profile1.Id,
Username = System.now().millisecond() + 'testdfsddg2@tesfdghfghhst.com',
Alias = 'batman',
Email='bruce.waynesadfs@wayneenterprisesfdsdghfj.com',
EmailEncodingKey='UTF-8',
Firstname='Bruce',
Lastname='Wayne',
LanguageLocaleKey='en_US',
LocaleSidKey='en_US',
TimeZoneSidKey='America/Chicago'
);
Database.insert(portalAccountOwner1);
system.debug('User 1  is ' + portalAccountOwner1);

//User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];

System.runAs ( portalAccountOwner1 ) {
//Create account
Account portalAccount1 = new Account(
Name = 'TestAccount',
OwnerId = portalAccountOwner1.Id
);
Database.insert(portalAccount1);
system.debug('Account  is ' + portalAccount1);


//Create contact
Contact contact1 = new Contact(
FirstName = 'Test',
Lastname = 'McTesty',
AccountId = portalAccount1.Id,
Email = System.now().millisecond() + 'test@test.com'
);
Database.insert(contact1);
system.debug('contact  is ' + contact1);


//Create user
Profile portalProfile = [SELECT Id FROM Profile WHERE UserType = 'PowerPartner' Limit 1];
system.debug('portalProfile  is ' + portalProfile );

User user1 = new User(
Username = System.now().millisecond() + 'ssas5@tesadsfghjklljht.com',
ContactId = contact1.Id,
ProfileId = portalProfile.Id,
Alias = 'te23',
Email = 'test123fdsg45fv@teghjst.com',
EmailEncodingKey = 'UTF-8',
LastName = 'McTesty',
CommunityNickname = 'test12345',
TimeZoneSidKey = 'America/Los_Angeles',
LocaleSidKey = 'en_US',
LanguageLocaleKey = 'en_US'
);
Database.insert(user1);
system.debug('user2   is ' + user1);


 Opportunity opp1 = new Opportunity();
    opp1.Name = 'first';
    opp1.Full_Name__c = 'first';        
    opp1.Customer_Email__c = 'opptest2test@testdwg.com';
    opp1.StageName='Quote Required';
    opp1.Opportunity_Stage__c = 'Won';
    opp1.CloseDate = Date.Today();
    opp1.Amount = 1000;
    opp1.CityfromLead__c = 'Noida';
    opp1.Square_Showroom_Agent__c = user1.Id;
    opp1.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-2);       
insert opp1;
}  
Test.startTest();
Database.executeBatch(new SendEmailAfter6Hrs(),2000);

Test.stopTest();

} 

}