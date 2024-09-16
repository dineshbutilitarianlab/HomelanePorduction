@isTest
public class ViewCheckListController_Test{
    static testMethod void viewD1Checklist(){
        
        Test.startTest();
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> pm_user = [SELECT id,Name, Email,Internal_Buddy__c FROM User WHERE ProfileId = :pm_profile.Id and isActive = True];
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email,Internal_Buddy__c FROM User WHERE ProfileId = :smm_profile.Id and isActive = True];
        
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :agent_profile.Id and isActive = True];
        system.debug('agent_user='+agent_user);
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> fac_coordinator = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :fac_profile.Id and isActive = True];
        system.debug('fac_coordinator ='+fac_coordinator );
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :dp_profile.Id and isActive = True];
        system.debug('dp_prof ='+dp_prof );
        
        Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> managerUser=[SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId =:squareMag_profile.id and isActive = True];
        system.debug('*****square manager*****'+managerUser[0]);
        
        Account personAcc=new Account(LastName='John',PersonEmail='John@gmail.com');
        insert personAcc;
        
        Opportunity opp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='Initial Quote Sent',
                                         closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,customer_email__c='John@gmail.com');
        
        insert opp;
        
         
         opp.stageName='D1 Initiated';
         opp.sub_status__c='Site Measurement Meeting Confirmed';
         
        
        update opp;
        
        SC_Section__c sec = SC_MI_TestHandler.insertSection('Test Sec','Site Measurement Meeting Confirmed',10,NULL);       
        insert sec;
        
        SC_Item__c itm1 = SC_MI_TestHandler.insertItem('Test Itm',TRUE,'Picklist','Record Type D1'); 
        //listItems.add(itm1);  
        insert itm1;
        
        SC_Response__c res1 = SC_MI_TestHandler.insertResponse('Test Answer',itm1.Id,5,TRUE,TRUE);
       // listResponse.add(res1);
       insert res1;
        
        SC_Section_Item__c secItm1 = SC_MI_TestHandler.insertSectionItem(itm1.Id,sec.Id,10);
        //listSecItem.add(secItm1); 
        insert secItm1;
        
       
        
        List<SC_User_Response__c> listUsrResp = new List<SC_User_Response__c>();
        SC_User_Response__c usrRsp1 = SC_MI_TestHandler.insertUsrResponse(itm1.Id,res1.Answer__c,'Site Measurement Meeting Confirmed',opp.Id,5);
        listUsrResp.add(usrRsp1);  
        /*SC_User_Response__c usrRsp2 = SC_MI_TestHandler.insertUsrResponse(itm1.Id,res2.Answer__c,'Site Measurement Meeting Confirmed',opp.Id,5);
        listUsrResp.add(usrRsp2); */       
        insert listUsrResp;
        
         PageReference pageRef = Page.ViewChecklistPDF;
         Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',opp.id);
         ApexPages.StandardController sc = new ApexPages.standardController(Opp);
         ViewCheckListD1Controller chklist = new ViewCheckListD1Controller(sc);
         chklist.sendEmail();
         
         Test.stopTest();
     }
     static testMethod void viewD2Checklist(){
        
        Test.startTest();
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> pm_user = [SELECT id,Name, Email,Internal_Buddy__c FROM User WHERE ProfileId = :pm_profile.Id and isActive = True];
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email,Internal_Buddy__c FROM User WHERE ProfileId = :smm_profile.Id and isActive = True];
        
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :agent_profile.Id and isActive = True];
        system.debug('agent_user='+agent_user);
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> fac_coordinator = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :fac_profile.Id and isActive = True];
        system.debug('fac_coordinator ='+fac_coordinator );
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :dp_profile.Id and isActive = True];
        system.debug('dp_prof ='+dp_prof );
        
        Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> managerUser=[SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId =:squareMag_profile.id and isActive = True];
        system.debug('*****square manager*****'+managerUser[0]);
        
        Account personAcc=new Account(LastName='John',PersonEmail='John@gmail.com');
        insert personAcc;
        
        Opportunity opp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D2 Initiated',
                                         closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,customer_email__c='John@gmail.com');
        
        insert opp;
         
        SC_Section__c sec = SC_MI_TestHandler.insertSection('Test Sec','Design Presentation Confirmed',10,NULL);       
        insert sec;
        
        SC_Item__c itm1 = SC_MI_TestHandler.insertItem('Test Itm',TRUE,'Picklist','Record Type D1'); 
        //listItems.add(itm1);  
        insert itm1;
        
        SC_Response__c res1 = SC_MI_TestHandler.insertResponse('Test Answer',itm1.Id,5,TRUE,TRUE);
       // listResponse.add(res1);
       insert res1;
        
        SC_Section_Item__c secItm1 = SC_MI_TestHandler.insertSectionItem(itm1.Id,sec.Id,10);
        //listSecItem.add(secItm1); 
        insert secItm1;
        
       
        
        List<SC_User_Response__c> listUsrResp = new List<SC_User_Response__c>();
        SC_User_Response__c usrRsp1 = SC_MI_TestHandler.insertUsrResponse(itm1.Id,res1.Answer__c,'Design Presentation Confirmed',opp.Id,5);
        listUsrResp.add(usrRsp1);  
        /*SC_User_Response__c usrRsp2 = SC_MI_TestHandler.insertUsrResponse(itm1.Id,res2.Answer__c,'Site Measurement Meeting Confirmed',opp.Id,5);
        listUsrResp.add(usrRsp2); */       
        insert listUsrResp;
        
         PageReference pageRef = Page.ViewD2CheckListPDF;
         Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',opp.id);
         ApexPages.StandardController sc = new ApexPages.standardController(Opp);
         ViewCheckListD2Controller chklist = new ViewCheckListD2Controller(sc);
         chklist.sendEmail();
         
         Test.stopTest();
         
     }
     static testMethod void viewD3Checklist(){
        
        Test.startTest();
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> pm_user = [SELECT id,Name, Email,Internal_Buddy__c FROM User WHERE ProfileId = :pm_profile.Id and isActive = True];
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email,Internal_Buddy__c FROM User WHERE ProfileId = :smm_profile.Id and isActive = True];
        
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :agent_profile.Id and isActive = True];
        system.debug('agent_user='+agent_user);
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> fac_coordinator = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :fac_profile.Id and isActive = True];
        system.debug('fac_coordinator ='+fac_coordinator );
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :dp_profile.Id and isActive = True];
        system.debug('dp_prof ='+dp_prof );
        
        Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> managerUser=[SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId =:squareMag_profile.id and isActive = True];
        system.debug('*****square manager*****'+managerUser[0]);
        
        Account personAcc=new Account(LastName='John',PersonEmail='John@gmail.com');
        insert personAcc;
        
        Opportunity opp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D3 Initiated',sub_status__c='Project Kick-off Meeting Confirmed',
                                         closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,customer_email__c='John@gmail.com');
        
        insert opp;
         
        SC_Section__c sec = SC_MI_TestHandler.insertSection('Test Sec','Project Kick-off Meeting Confirmed',10,NULL);       
        insert sec;
        
        SC_Item__c itm1 = SC_MI_TestHandler.insertItem('Test Itm',TRUE,'Picklist','Record Type D1'); 
        //listItems.add(itm1);  
        insert itm1;
        
        SC_Response__c res1 = SC_MI_TestHandler.insertResponse('Test Answer',itm1.Id,5,TRUE,TRUE);
       // listResponse.add(res1);
       insert res1;
        
        SC_Section_Item__c secItm1 = SC_MI_TestHandler.insertSectionItem(itm1.Id,sec.Id,10);
        //listSecItem.add(secItm1); 
        insert secItm1;
        
       
        
        List<SC_User_Response__c> listUsrResp = new List<SC_User_Response__c>();
        SC_User_Response__c usrRsp1 = SC_MI_TestHandler.insertUsrResponse(itm1.Id,res1.Answer__c,'Project Kick-off Meeting Confirmed',opp.Id,5);
        listUsrResp.add(usrRsp1);  
        /*SC_User_Response__c usrRsp2 = SC_MI_TestHandler.insertUsrResponse(itm1.Id,res2.Answer__c,'Site Measurement Meeting Confirmed',opp.Id,5);
        listUsrResp.add(usrRsp2); */       
        insert listUsrResp;
        
         PageReference pageRef = Page.ViewD3CheckListPDF;
         Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',opp.id);
         ApexPages.StandardController sc = new ApexPages.standardController(Opp);
         ViewCheckListD3Controller chklist = new ViewCheckListD3Controller(sc);
         chklist.sendEmail();
         
         Test.stopTest();
     }
 }