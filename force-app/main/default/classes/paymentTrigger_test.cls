@isTest
public class paymentTrigger_test{
    static testMethod void testPaymentMilesone(){
    
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
      /* Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'Project Manager Profile' LIMIT 1];
        list<User> pm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :pm_profile.Id and isActive = True];
        system.debug('pm_user='+pm_user);
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'SMM Profile' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :smm_profile.Id and isActive = True];
        system.debug('smm_user='+smm_user);*/
        
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :agent_profile.Id and isActive = True];
        system.debug('agent_user='+agent_user);
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> fac_coordinator = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :fac_profile.Id and isActive = True];
        system.debug('fac_coordinator ='+fac_coordinator );
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :dp_profile.Id and isActive = True];
        system.debug('dp_prof ='+dp_prof );
        
      /*  UserRole squareMagUser=[SELECT Id,Name FROM UserRole WHERE Name='Square Showroom Manager Partner User' limit 1];
        User managerUser=[SELECT id,Name, Email,Internal_Buddy__c FROM User WHERE UserRoleId=:squareMagUser.id];*/
        
        Profile finance_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        List<User> finance_user = [SELECT id, Email FROM User WHERE ProfileId = : finance_profile.Id ];
 
        Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> managerUser=[SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId =:squareMag_profile.id and isActive = True];
        system.debug('*****square manager*****'+managerUser[0]);
 
       // RecordType recType=[SELECT Id FROM RecordType WHERE Name='Person Account'];
        Account personAcc=new Account(LastName='Anand',PersonEmail='Anand@gmail.com',phone='0801231541');
        insert personAcc;
       
        Opportunity opp=new Opportunity(Name='Vijay',AccountId=personAcc.Id,stageName='Initial Quote Sent',
                                        closeDate=system.today());
       // insert opp;
        
        opp.StageName='Initial Quote Approved';
        opp.Amount=100;
       // opp.SMM__c=smm_user[0].id;
       // opp.PM__c=pm_user[0].id;
        opp.Square_Showroom_Agent__c=agent_user[0].Id;
        opp.Square_Showroom_Manager__c=managerUser[0].Id;
        opp.customer_email__c='John@gmail.com';
        insert opp;
        
      //  opportunity opptnity=[SELECT id, name, stageName,sub_status__c,customer_email__c FROM Opportunity WHERE Id=:opp.id];
      //  system.assert(opptnity.customer_email__c =='Anand@gmail.com');
        
        Customer_Bill__c custBill=new Customer_Bill__c(Opportunity__c=opp.id, Amount_to_be_paid__c=10);
        insert custBill;
        
        
        Payment_Milestone__c payMile;
       // system.runAs(finance_user[0]){
            payMile=new Payment_Milestone__c(Bill__c=custBill.id,Payment_Mode__c='Wire Transfer',Payment_Type__c='Final Installment');
            insert payMile;
     //   }
         opp.stageName='D4 initiated';
       // update opp;
        
        opp.stageName='Full and Final Settlement Received';
        update opp;
        
        Customer_Bill__c custBill4=new Customer_Bill__c(Opportunity__c=opp.id, Amount_to_be_paid__c=10);
        insert custBill4;
        
        custBill4.bill_status__c='Full and Final Settlement Received';
        custBill4.customer_email__c=opp.customer_email__c;
        update custBill4;
         
       /* Customer_Bill__c custBill5=[SELECT id, name,customer_email__c,Amount_to_be_paid__c,Opportunity__c FROM Customer_Bill__c WHERE Id=:custBill4.id];
        system.debug('custBill5.customer_email__c='+custBill5.customer_email__c);*/
        
        Payment_Milestone__c payMile1;
      //  system.runAs(finance_user[0]){
            payMile1=new Payment_Milestone__c(Bill__c=custBill4.id,Payment_Mode__c='Wire Transfer',Payment_Type__c='Final Installment');
            insert payMile1;
       //  }
        
        payMile1.Payment_Type__c='Installment 1';
        update payMile1;
        
        Payment_Milestone__c payMileStone=[SELECT id,customer_email__c FROM Payment_Milestone__c WHERE id=:payMile1.id];
        system.debug(payMileStone.customer_email__c);
        
        try{
            Payment_Milestone__c payMile2=new Payment_Milestone__c(Bill__c=custBill4.id,Payment_Mode__c='Wire Transfer',Payment_Type__c='Final Installment');
            insert payMile2;
       }catch(DMLexception e){
         //  system.assertEquals('Record with Payment Type Final Installment already exists. Please, change the type and Save again.','Record with Payment Type Final Installment already exists. Please, change the type and Save again.');
         System.assert(e.getMessage().contains('Record with Payment Type Final Installment already exists. Please, change the type and Save again.'),e.getMessage());
             
       }
    }
    static testMethod void testPaymentMilesone1(){
    
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :agent_profile.Id and isActive = True];
        system.debug('agent_user='+agent_user);
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> fac_coordinator = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :fac_profile.Id and isActive = True];
        system.debug('fac_coordinator ='+fac_coordinator );
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :dp_profile.Id and isActive = True];
        system.debug('dp_prof ='+dp_prof );
        
        Profile finance_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        List<User> finance_user = [SELECT id, Email FROM User WHERE ProfileId = : finance_profile.Id ];
 
        Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> managerUser=[SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId =:squareMag_profile.id and isActive = True];
        system.debug('*****square manager*****'+managerUser[0]);
 
        Account personAcc=new Account(LastName='Anand',PersonEmail='Anand@gmail.com',phone='0801231541');
        insert personAcc;
       
        Opportunity opp=new Opportunity(Name='Vijay',AccountId=personAcc.Id,stageName='Initial Quote Sent',
                                        closeDate=system.today());
        
        
        opp.StageName='Initial Quote Approved';
        opp.Amount=100;
        //opp.SMM__c=smm_user[0].id;
        //opp.PM__c=pm_user[0].id;
        opp.Square_Showroom_Agent__c=agent_user[0].Id;
        opp.Square_Showroom_Manager__c=managerUser[0].Id;
        opp.customer_email__c='John@gmail.com';
       insert opp;
        
      //  opportunity opptnity=[SELECT id, name, stageName,sub_status__c,customer_email__c FROM Opportunity WHERE Id=:opp.id];
      //  system.assert(opptnity.customer_email__c =='Anand@gmail.com');
        
        Customer_Bill__c custBill=new Customer_Bill__c(Opportunity__c=opp.id, Amount_to_be_paid__c=10);
        insert custBill;
        
        Payment_Milestone__c payMile;
        system.runAs(finance_user[0]){
            payMile=new Payment_Milestone__c(Bill__c=custBill.id,Payment_Mode__c='Wire Transfer',Payment_Type__c='Final Installment');
            insert payMile;
        }
        
        payMile.Payment_Type__c='Final Installment';
        update payMile;
        
        try{
         Payment_Milestone__c  payMileDup=new Payment_Milestone__c(Bill__c=custBill.id,Payment_Mode__c='Wire Transfer',Payment_Type__c='Final Installment');
            insert payMileDup;
         }catch(DMLException e){
         }  
        opp.stageName='D4 initiated';
       // update opp;
        
        opp.stageName='Full and Final Settlement Received';
        update opp;
        
        Customer_Bill__c custBill4=new Customer_Bill__c(Opportunity__c=opp.id, Amount_to_be_paid__c=10);
        insert custBill4;
        
        custBill4.bill_status__c='Full and Final Settlement Received';
        custBill4.customer_email__c=opp.customer_email__c;
        update custBill4;
         
       /* Customer_Bill__c custBill5=[SELECT id, name,customer_email__c,Amount_to_be_paid__c,Opportunity__c FROM Customer_Bill__c WHERE Id=:custBill4.id];
        system.debug('custBill5.customer_email__c='+custBill5.customer_email__c);*/
        
        Payment_Milestone__c payMile1;
        system.runAs(finance_user[1]){
            payMile1=new Payment_Milestone__c(Bill__c=custBill4.id,Payment_Mode__c='Wire Transfer',Payment_Type__c='Final Installment');
            insert payMile1;
        }
        payMile1.Payment_Type__c='Final Installment';
        try{
            update payMile1;
            Payment_Milestone__c payMileDup1=new Payment_Milestone__c(Bill__c=custBill4.id,Payment_Mode__c='Wire Transfer',Payment_Type__c='Final Installment');
            insert payMileDup1;
        }
        catch(DMLException e){
        }
        Payment_Milestone__c payMileStone=[SELECT id,customer_email__c FROM Payment_Milestone__c WHERE id=:payMile1.id];
        system.debug(payMileStone.customer_email__c);
        
    }
}