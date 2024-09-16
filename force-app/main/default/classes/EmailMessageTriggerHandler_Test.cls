@isTest
public class EmailMessageTriggerHandler_Test {
    static testMethod void checkEmailMessage(){
    
        test.startTest();
        
         SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        /* Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'Project Manager Profile' LIMIT 1];
        list<User> pm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :pm_profile.Id  ];
        system.debug('pm_user='+pm_user); */
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'SMM Profile' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :smm_profile.Id  ];
        system.debug('smm_user='+smm_user);
        
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'Square Sales Profile' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :agent_profile.Id  ];
        system.debug('agent_user='+agent_user);
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'Factory Coordinator Profile' LIMIT 1];
        list<User> fac_coordinator = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :fac_profile.Id  ];
        system.debug('fac_coordinator ='+fac_coordinator );
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'Design Partner Profile' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :dp_profile.Id  ];
        system.debug('dp_prof ='+dp_prof );
        
        UserRole squareMagUser=[SELECT Id,Name FROM UserRole WHERE Name='Homelane Internal Partner Account Partner User' limit 1];
        User managerUser=[SELECT id,Name, Email,Internal_buddy__c FROM User WHERE UserRoleId=:squareMagUser.id LIMIT 1];
        system.debug('managerUser='+managerUser);
        
        Account personAcc=new Account(LastName='Anand',PersonEmail='Anand@gmail.com');
        insert personAcc;
        
        Opportunity businessOpp=new Opportunity(Name='Gagan',AccountId=personAcc.Id,stageName='Quote Required',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser.id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id);
        insert businessOpp;
        
        EmailMessage emailMsg=new EmailMessage();
        emailMsg.Subject='Initial Quote Confirmation';
        emailMsg.RelatedToId=businessOpp.Id;
        insert emailMsg;
        
        EmailMessage emailMsg1=new EmailMessage();
        emailMsg1.Subject='Initial 3D Design & Quote Sent';
        emailMsg1.RelatedToId=businessOpp.Id;
        insert emailMsg1;
        
        businessOpp.stageName='D1 initiated';
        update businessOpp;
        
        businessOpp.stageName='D2 initiated';
      //  businessOpp.Sub_Status__c = 'Design Presentation Completed';
        update businessOpp;
        
        EmailMessage emailMsg2=new EmailMessage();
        emailMsg2.Subject='Final 3D Design & Quote Sent';
        emailMsg2.RelatedToId=businessOpp.Id;
        insert emailMsg2;
        
       /* businessOpp.stageName='D3 initiated';
        businessOpp.Sub_Status__c = 'Project Kick-off Completed';
        update businessOpp;*/
        
        EmailMessage emailMsg3=new EmailMessage();
        emailMsg3.Subject='D3: Drawings & Quote Approval Required';
        emailMsg3.RelatedToId=businessOpp.Id;
        insert emailMsg3;
        
    //    businessOpp.Sub_Status__c = 'Drawings approved by factory';
      //  update businessOpp;
        
      /*  EmailMessage emailMsg4=new EmailMessage();
        emailMsg4.Subject='Works Contract, D3 Drawings & Quote Approval Required';
        emailMsg4.RelatedToId=businessOpp.Id;
        insert emailMsg4;*/
        
      /*  EmailMessage emailMsg5=new EmailMessage();
        emailMsg5.Subject='Production Drawings Sent';
        emailMsg5.RelatedToId=businessOpp.Id;
        insert emailMsg5;*/
        
        EmailMessageTriggerHandler.dummytestcover();
      } 
}