@isTest
public class SendEmailToDPAndManagers_Test {
  @TestVisible static Messaging.SingleEmailMessage Message = new Messaging.SingleEmailMessage();
    @isTest static void send() {
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User user1 = new User(
      //  UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
        Username = System.now().millisecond() + 'testdfsddgsd2@tesfdghfghhst.com',
        Alias = 'batman',
        Email='bruce.waynesadfs@wayneefdfnterprisesfdsdghfj.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago'
        );
        Database.insert(user1);
        system.debug('User 1  is ' + user1);
        
        Account portalAccount1 = new Account(
        Name = 'TestAccount',
        Customer_ID__c = 'portalAccountOwner1'
        );
        Database.insert(portalAccount1);
        system.debug('Account  is ' + portalAccount1);
        
        Interior_Designer__c inte2 = new Interior_Designer__c();
        inte2.name = 'test1235353';
        inte2.Email__c = 'test@231afa34.com';
        inte2.Active__c   = true;
        insert inte2;
        
        List<Opportunity> oppList = new List<Opportunity>();
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
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
        opp1.Interior_Design_Partner__c = inte2.Id;
        opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
        opp1.AccountId = portalAccount1.Id;
        oppList.add(opp1);
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'firdst';
        opp2.Full_Name__c = 'firsft';        
        opp2.Customer_Email__c = 'opptest2test@testdwg.com';
        opp2.StageName='Quote Required';
        opp2.Opportunity_Stage__c = 'Won';
        opp2.CloseDate = Date.Today();
        opp2.Amount = 1000;
        opp2.CityfromLead__c = 'Noida';
        opp2.Square_Showroom_Agent__c = user1.Id;
        opp2.Second_Meeting_Time__c = System.now().addHours(-25);  
        opp2.Interior_Design_Partner__c = inte2.Id;
        opp2.Square_Showroom_Manager__c = user1.Id;   
        opp2.X4_Hrs_Email_Sent__c = false;   
        opp2.AccountId = portalAccount1.Id;
        oppList.add(opp2);
        
        Opportunity opp3 = new Opportunity();
        opp3.Name = 'firddst';
        opp3.Full_Name__c = 'firddst';        
        opp3.Customer_Email__c = 'opptest2test@testdwg.com';
        opp3.StageName='Quote Required';
        opp3.Opportunity_Stage__c = 'Won';
        opp3.CloseDate = Date.Today();
        opp3.Amount = 1000;
        opp3.CityfromLead__c = 'Noida';
        opp3.Square_Showroom_Agent__c = user1.Id;
        opp3.Second_Meeting_Time__c = System.now().addHours(-49);   
        opp3.Interior_Design_Partner__c = inte2.Id;
        opp3.Square_Showroom_Manager__c = user1.Id;     
        opp3.X8_Hrs_Email_Sent__c = false;
        opp3.AccountId = portalAccount1.Id;
        oppList.add(opp3);
        insert oppList;
        
        message.setTargetObjectId(UserInfo.getUserId());
        message.setSaveAsActivity(false);
        message.setSubject('dear diary');
        message.setPlainTextBody('he who controls the spice');
        Messaging.sendEmail(new List<Messaging.Email>{Message});
    
    
        Test.startTest();
        Database.executeBatch(new SendEmailToDPAndManagers ());
        Test.stopTest();
    }
    

}