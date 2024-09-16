@isTest
public class SC_MI_TestHandler_Test {
    public static TestMethod void testMethodOne(){
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
        
        opp.StageName='D1 initiated';
        opp.sub_status__c='Site Measurement Meeting Confirmed';
        update opp;
        
        SC_Item__c itm1 = SC_MI_TestHandler.insertItem('Test Itm',TRUE,'Picklist','Printer'); 
        insert itm1;
        SC_Section__c sec = SC_MI_TestHandler.insertSection('Test Sec','Site Measurement Meeting Confirmed',10,NULL); 
        insert sec;
        SC_Response__c res1 = SC_MI_TestHandler.insertResponse('Test Answer',itm1.Id,5,TRUE,TRUE);
        insert res1;
        SC_Section_Item__c secItm1 = SC_MI_TestHandler.insertSectionItem(itm1.Id,sec.Id,10);
        insert secItm1;
        SC_User_Response__c usrRsp1 = SC_MI_TestHandler.insertUsrResponse(itm1.Id,res1.Answer__c,'Site Measurement Meeting Confirmed',opp.Id,5);
        insert usrRsp1;  
        Test.stopTest();
    }
}