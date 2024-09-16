@isTest
public class SC_OpportunityStageValidation_Test {
    public static TestMethod void  testMethodOne(){
        Test.startTest();
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
         Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> pm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :pm_profile.Id and isActive = True];
        system.debug('pm_user='+pm_user);
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :smm_profile.Id and isActive = True];
        system.debug('smm_user='+smm_user);
        
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
       
        Opportunity opp = SC_MI_TestHandler.insertOpportunity('Test Opportunity',System.Today(),'Initial Quote Sent',100,System.Today()+1); 
        opp.SMM__c=smm_user[0].id;
        opp.PM__c=pm_user[0].id;
        opp.Square_Showroom_Agent__c=agent_user[0].Id;
        opp.Square_Showroom_Manager__c=managerUser[0].Id;
        opp.Factory_Co_ordinator__c=fac_coordinator[0].id;
        opp.design_partner__c=dp_prof[0].id;
        insert opp;
        
        opp.sub_Status__c='Site Measurement Meeting Confirmed';
        update opp;
        
        SC_Item__c itm = SC_MI_TestHandler.insertItem('Test Itm',TRUE,'Picklist','Record Type D1'); 
        insert itm;
        SC_Section__c sec = SC_MI_TestHandler.insertSection('Test Sec','Site Measurement Meeting Confirmed',10,NULL);       
        insert sec;
        SC_Response__c res = SC_MI_TestHandler.insertResponse('Test Answer',itm.Id,5,TRUE,TRUE);
        insert res;
        SC_Response__c res1 = SC_MI_TestHandler.insertResponse('26-09-2016',itm.Id,5,TRUE,TRUE);
        insert res1;
        
        list<SC_Section_Item__c> listSecItem=new list<SC_Section_Item__c>();
        SC_Section_Item__c secItm = SC_MI_TestHandler.insertSectionItem(itm.Id,sec.Id,10);
        listSecItem.add(secItm);
        insert listSecItem;
        SC_User_Response__c usrRsp = SC_MI_TestHandler.insertUsrResponse(itm.Id,res.Answer__c,'Site Measurement Meeting Confirmed',opp.Id,5);
        insert usrRsp;  
        SC_User_Response__c usrRsp1 = SC_MI_TestHandler.insertUsrResponse(itm.Id,res1.Answer__c,'Site Measurement Meeting Confirmed',opp.Id,5);
        insert usrRsp1;               
        SC_OpportunityStageValidation stageValidate = new SC_OpportunityStageValidation();
        SC_OpportunityStageValidation.SC_OpportunityStageValidate(opp.Id,'Site Measurement Meeting Confirmed',listSecItem);
        Test.stopTest();
    }    
    public static TestMethod void  testMethodTwo(){
        Test.startTest();
         SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
         Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> pm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :pm_profile.Id and isActive = True];
        system.debug('pm_user='+pm_user);
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :smm_profile.Id and isActive = True];
        system.debug('smm_user='+smm_user);
        
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
       
        Opportunity opp = SC_MI_TestHandler.insertOpportunity('Test Opportunity',System.Today(),'Initial Quote Sent',100,System.Today()+1); 
        opp.SMM__c=smm_user[0].id;
        opp.PM__c=pm_user[0].id;
        opp.Square_Showroom_Agent__c=agent_user[0].Id;
        opp.Square_Showroom_Manager__c=managerUser[0].Id;
        opp.Factory_Co_ordinator__c=fac_coordinator[0].id;
        opp.design_partner__c=dp_prof[0].id;
        insert opp;
        
        opp.sub_status__c='Site Measurement Meeting Confirmed';
        update opp;
        
        SC_Item__c itm = SC_MI_TestHandler.insertItem('Test Itm',TRUE,'Picklist','Record Type D1'); 
        insert itm;        
        SC_Section__c sec = SC_MI_TestHandler.insertSection('Test Sec','Design Presentation Completed',10,NULL);       
        insert sec;
        SC_Section__c subSec = SC_MI_TestHandler.insertSection('Test SubSec',NULL,10,sec.Id);       
        insert subSec;
        SC_Response__c res = SC_MI_TestHandler.insertResponse('Test Answer1',itm.Id,5,TRUE,TRUE);
        insert res;
        SC_Response__c res2 = SC_MI_TestHandler.insertResponse('Test Answer2',itm.Id,1,TRUE,FALSE);
        insert res2;
        list<SC_Section_Item__c> listSecItem=new list<SC_Section_Item__c>();
            SC_Section_Item__c secItm = SC_MI_TestHandler.insertSectionItem(itm.Id,sec.Id,10);
            listSecItem.add(secItm);
        if(!listSecItem.isEmpty())
            insert listSecItem;
        SC_User_Response__c usrRsp = SC_MI_TestHandler.insertUsrResponse(itm.Id,res2.Answer__c,'Design Presentation Completed',opp.Id,1);
        insert usrRsp;               
        SC_OpportunityStageValidation stageValidate = new SC_OpportunityStageValidation();
        SC_OpportunityStageValidation.SC_OpportunityStageValidate(opp.Id,'Design Presentation Completed',listSecItem);
        Test.stopTest();
    } 
    public static TestMethod void  testMethodThree(){
        Test.startTest();
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
         Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> pm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :pm_profile.Id and isActive = True];
        system.debug('pm_user='+pm_user);
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :smm_profile.Id and isActive = True];
        system.debug('smm_user='+smm_user);
        
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
       
        Opportunity opp = SC_MI_TestHandler.insertOpportunity('Test Opportunity',System.Today(),'Initial Quote Sent',100,System.Today()+1); 
        opp.SMM__c=smm_user[0].id;
        opp.PM__c=pm_user[0].id;
        opp.Square_Showroom_Agent__c=agent_user[0].Id;
        opp.Square_Showroom_Manager__c=managerUser[0].Id;
        opp.Factory_Co_ordinator__c=fac_coordinator[0].id;
        opp.design_partner__c=dp_prof[0].id;
        insert opp;
        
        opp.StageName='Site Measurement Meeting Confirmed';
        update opp;
        
        SC_Item__c itm = SC_MI_TestHandler.insertItem('Test Itm',TRUE,'Check Box','Record Type D1'); 
        insert itm;
        SC_Section__c sec = SC_MI_TestHandler.insertSection('Test Sec','Site Measurement Meeting Confirmed',10,NULL);       
        insert sec;
        SC_Response__c res = SC_MI_TestHandler.insertResponse('TRUE',itm.Id,NULL,TRUE,TRUE);
        insert res;
        list<SC_Section_Item__c> listSecItem=new list<SC_Section_Item__c>();
        SC_Section_Item__c secItm = SC_MI_TestHandler.insertSectionItem(itm.Id,sec.Id,10);
        listSecItem.add(secItm);
        insert listSecItem;
        SC_User_Response__c usrRsp = SC_MI_TestHandler.insertUsrResponse(itm.Id,res.Answer__c,'Site Measurement Meeting Confirmed',opp.Id,5);
        insert usrRsp;               
        SC_OpportunityStageValidation stageValidate = new SC_OpportunityStageValidation();
        SC_OpportunityStageValidation.SC_OpportunityStageValidate(opp.Id,'Site Measurement Meeting Confirmed',listSecItem);
        Test.stopTest();
    } 
}