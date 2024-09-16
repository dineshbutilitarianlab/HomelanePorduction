@isTest
public class CustomerBillHandler_Test{

    static testMethod void customerBill(){
        Test.startTest();
        
        CustomerBillHandler.dump();
        
        
        /*SC_MI_TestHandler.insertIsTriggerExecute();
       SC_MI_TestHandler.insertCustomDate();
        
        
         Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :dp_profile.Id and isActive = true ];
        system.debug('dp_prof ='+dp_prof );
        
       /* Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'Project Manager Profile' LIMIT 1];
        list<User> pm_user = [SELECT id,Name, Email FROM User WHERE ProfileId = :pm_profile.Id and isActive = true ];
       // system.debug('pm_user='+pm_user);
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'SMM Profile' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email FROM User WHERE ProfileId = :smm_profile.Id and isActive = true ];
        system.debug('smm_user='+smm_user);*/
        
        /*Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email FROM User WHERE ProfileId = :agent_profile.Id and isActive = true];
        system.debug('agent_user='+agent_user);
        
        UserRole squareMagUser=[SELECT Id,Name FROM UserRole WHERE Name='Homelane Internal Partner Account Partner User' limit 1];
        User managerUser=[SELECT id,Name, Email FROM User WHERE UserRoleId=:squareMagUser.id Limit 1];
        system.debug('managerUser='+managerUser);
        
       // RecordType recType=[SELECT Id FROM RecordType WHERE Name='Person Account'];
        Account personAcc=new Account(LastName='Anand',PersonEmail='Anand@gmail.com',phone='0801231541');
        insert personAcc;
       
        Opportunity opp=new Opportunity(Name='Vijay',AccountId=personAcc.Id,stageName='Initial Quote Sent',
                                        closeDate=system.today(),Amount=100);
        insert opp;
        
        opp.StageName='Initial Quote Approved';
        opp.Amount=100;
        //opp.SMM__c=smm_user[0].id;
        //opp.PM__c=pm_user[0].id;
        opp.Square_Showroom_Agent__c=agent_user[0].Id;
        opp.Square_Showroom_Manager__c=managerUser.Id;
        opp.customer_email__c='Anand@gmail.com';
        opp.design_partner__c=dp_prof[0].id; 
        update opp;
        
        Customer_Bill__c custBill=new Customer_Bill__c(Opportunity__c=opp.id, Amount_to_be_paid__c=10,customer_email__c='Anand@gmail.com',design_partner__c=dp_prof[0].id,bill_status__c='10% Payment Received');
        
        
        try{
            insert custBill;
        }catch(DMLException e){
        }
        Customer_Bill__c dupCustBill=new Customer_Bill__c(Opportunity__c=opp.id, Amount_to_be_paid__c=10,customer_email__c='Anand@gmail.com',design_partner__c=dp_prof[0].id);
       // insert dupCustBill;
        
        try{
            dupCustBill.bill_status__c='Payment Stage A Reached';
           // update dupCustBill;
        }catch(DMLException e){
        }
        
        custBill.bill_status__c='10% Payment Approved';
        update custBill;
        
        Test.stopTest();
    }
    static testMethod void customerBill1(){
        Test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
         Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :dp_profile.Id and isActive = true ];
        system.debug('dp_prof ='+dp_prof );
        
         /*Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'Project Manager Profile' LIMIT 1];
       /* list<User> pm_user = [SELECT id,Name, Email FROM User WHERE ProfileId = :pm_profile.Id and isActive = true ];
        system.debug('pm_user='+pm_user);
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'SMM Profile' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email FROM User WHERE ProfileId = :smm_profile.Id and isActive = true ];
        system.debug('smm_user='+smm_user);*/
        
        /*Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email FROM User WHERE ProfileId = :agent_profile.Id and isActive = true ];
        system.debug('agent_user='+agent_user);
        
        UserRole squareMagUser=[SELECT Id,Name FROM UserRole WHERE Name='Homelane Internal Partner Account Partner User' limit 1];
        User managerUser=[SELECT id,Name, Email FROM User WHERE UserRoleId=:squareMagUser.id Limit 1];
        system.debug('managerUser='+managerUser);
        
       // RecordType recType=[SELECT Id FROM RecordType WHERE Name='Person Account'];
        Account personAcc=new Account(LastName='Anand',PersonEmail='Anand@gmail.com',phone='0801231541');
        insert personAcc;
       
        Opportunity opp=new Opportunity(Name='Vijay',AccountId=personAcc.Id,stageName='Initial Quote Sent',
                                        closeDate=system.today(),Amount=100);
        insert opp;
        
        opp.StageName='Initial Quote Approved';
        opp.Amount=100;
        //opp.SMM__c=smm_user[0].id;
        //opp.PM__c=pm_user[0].id;
        opp.Square_Showroom_Agent__c=agent_user[0].Id;
        opp.Square_Showroom_Manager__c=managerUser.Id;
        opp.design_partner__c=dp_prof[0].id; 
        //update opp;
        
        opp.stageName='Full and Final Settlement Received';
        update opp;
        
        Customer_Bill__c custBill4=new Customer_Bill__c(Opportunity__c=opp.id, Amount_to_be_paid__c=10,customer_email__c='Anand@gmail.com',design_partner__c=dp_prof[0].id);
        insert custBill4;
        
        custBill4.bill_status__c='Full and Final Settlement Received';
        update custBill4;
        
        Test.stopTest();
    }
    static testMethod void customerBill2(){
        Test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
         Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :dp_profile.Id and isActive = true ];
        system.debug('dp_prof ='+dp_prof );
        
        /* Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'Project Manager Profile' LIMIT 1];
        /*list<User> pm_user = [SELECT id,Name, Email FROM User WHERE ProfileId = :pm_profile.Id and isActive = true ];
        system.debug('pm_user='+pm_user);
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'SMM Profile' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email FROM User WHERE ProfileId = :smm_profile.Id and isActive = true ];
        system.debug('smm_user='+smm_user);*/
        
        /*Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email FROM User WHERE ProfileId = :agent_profile.Id and isActive = true ];
        system.debug('agent_user='+agent_user);
        
        UserRole squareMagUser=[SELECT Id,Name FROM UserRole WHERE Name='Homelane Internal Partner Account Partner User' limit 1];
        User managerUser=[SELECT id,Name, Email FROM User WHERE UserRoleId=:squareMagUser.id Limit 1];
        system.debug('managerUser='+managerUser);
        
       // RecordType recType=[SELECT Id FROM RecordType WHERE Name='Person Account'];
        Account personAcc=new Account(LastName='Anand',PersonEmail='Anand@gmail.com',phone='0801231541');
        insert personAcc;
       
        Opportunity opp=new Opportunity(Name='Vijay',AccountId=personAcc.Id,stageName='Initial Quote Sent',
                                        closeDate=system.today(),Amount=100);
        insert opp;
        
        opp.StageName='Initial Quote Approved';
        opp.Amount=100;
        //opp.SMM__c=smm_user[0].id;
        //opp.PM__c=pm_user[0].id;
        opp.Square_Showroom_Agent__c=agent_user[0].Id;
        opp.Square_Showroom_Manager__c=managerUser.Id;
        opp.design_partner__c=dp_prof[0].id; 
       // update opp;
        
        opp.stageName='Payment Stage C Reached';
        update opp;
        
        Customer_Bill__c custBill3=new Customer_Bill__c(Opportunity__c=opp.id, Amount_to_be_paid__c=10,customer_email__c='Anand@gmail.com',design_partner__c=dp_prof[0].id);
        insert custBill3;
        
        custBill3.bill_status__c='50% Payment Received';
        update custBill3;
        
        custBill3.bill_status__c='50% Payment Approved';
        update custBill3;
        Test.stopTest();
     }
     static testMethod void customerBill3(){
        Test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
         Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :dp_profile.Id and isActive = true ];
        system.debug('dp_prof ='+dp_prof );
        
         /*Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'Project Manager Profile' LIMIT 1];
        /*list<User> pm_user = [SELECT id,Name, Email FROM User WHERE ProfileId = :pm_profile.Id and isActive = true ];
        system.debug('pm_user='+pm_user);
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'SMM Profile' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email FROM User WHERE ProfileId = :smm_profile.Id and isActive = true ];
        system.debug('smm_user='+smm_user);
        */
        /*Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email FROM User WHERE ProfileId = :agent_profile.Id and isActive = true ];
        system.debug('agent_user='+agent_user);
        
        UserRole squareMagUser=[SELECT Id,Name FROM UserRole WHERE Name='Homelane Internal Partner Account Partner User' limit 1];
        User managerUser=[SELECT id,Name, Email FROM User WHERE UserRoleId=:squareMagUser.id Limit 1];
        system.debug('managerUser='+managerUser);
        
       // RecordType recType=[SELECT Id FROM RecordType WHERE Name='Person Account'];
        Account personAcc=new Account(LastName='Anand',PersonEmail='Anand@gmail.com',phone='0801231541');
        insert personAcc;
       
        Opportunity opp=new Opportunity(Name='Vijay',AccountId=personAcc.Id,stageName='Initial Quote Sent',
                                        closeDate=system.today(),Amount=100);
        insert opp;
        
        opp.StageName='Initial Quote Approved';
        opp.Amount=100;
        //opp.SMM__c=smm_user[0].id;
        //opp.PM__c=pm_user[0].id;
        opp.Square_Showroom_Agent__c=agent_user[0].Id;
        opp.Square_Showroom_Manager__c=managerUser.Id;
        opp.design_partner__c=dp_prof[0].id; 
       // update opp;
        
        opp.stageName='D3 initiated';
        opp.Sub_Status__c='40% Payment Received';
        update opp;
        
       Customer_Bill__c custBill2=new Customer_Bill__c(Opportunity__c=opp.id, Amount_to_be_paid__c=10,customer_email__c='Anand@gmail.com',design_partner__c=dp_prof[0].id);
        insert custBill2;
        
        custBill2.bill_status__c='40% Payment Received';
        update custBill2;*/
        
        Test.stopTest();
     }
    
}