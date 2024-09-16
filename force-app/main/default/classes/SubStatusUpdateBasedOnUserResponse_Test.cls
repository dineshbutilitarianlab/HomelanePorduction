@isTest
public class SubStatusUpdateBasedOnUserResponse_Test{
    static testMethod void testStatusUpdate1(){
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> pm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :pm_profile.Id and isActive = True];
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :smm_profile.Id and isActive = True];
        
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :agent_profile.Id and isActive = True];
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> fac_coordinator = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :fac_profile.Id and isActive = True];
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :dp_profile.Id and isActive = True];
        
        Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> managerUser=[SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId =:squareMag_profile.id and isActive = True];
       
        Opportunity opp = SC_MI_TestHandler.insertOpportunity('Test Opportunity',System.Today(),'Initial Quote Sent',100,System.Today()+1); 
        opp.SMM__c=smm_user[0].id;
        opp.PM__c=pm_user[0].id;
        opp.Square_Showroom_Agent__c=agent_user[0].Id;
        opp.Square_Showroom_Manager__c=managerUser[0].Id;
        opp.Factory_Co_ordinator__c=fac_coordinator[0].id;
        opp.design_partner__c=dp_prof[0].id;
        insert opp;
        
        opp.StageName='D1 Initiated';
        opp.sub_status__c='Site Measurement Meeting Confirmed';
        update opp;
        
        List<SC_Item__c> listItems = new List<SC_Item__c>();
        SC_Item__c itm1 = SC_MI_TestHandler.insertItem('Test Itm',TRUE,'Picklist','Record Type D1'); 
        listItems.add(itm1);
        SC_Item__c itm2 = SC_MI_TestHandler.insertItem('Test Itm check',TRUE,'Check Box','Record Type D1'); 
        listItems.add(itm2);
        SC_Item__c itm3 = SC_MI_TestHandler.insertItem('Test Itm check',TRUE,'Check Box','Record Type D1'); 
        listItems.add(itm3);
        insert listItems;
        
        SC_Section__c sec = SC_MI_TestHandler.insertSection('Test Sec','Site Measurement Meeting Confirmed',10,NULL);       
        insert sec;        
        List<SC_Response__c> listResponse = new List<SC_Response__c>();
        
        SC_Response__c res1 = SC_MI_TestHandler.insertResponse('Test Answer',itm1.Id,5,TRUE,TRUE);
        listResponse.add(res1);
        SC_Response__c res2 = SC_MI_TestHandler.insertResponse('TRUE',itm2.Id,NULL,TRUE,TRUE);
        listResponse.add(res2);        
        insert listResponse;
        
        List<SC_Section_Item__c> listSecItem = new List<SC_Section_Item__c>();
        SC_Section_Item__c secItm1 = SC_MI_TestHandler.insertSectionItem(itm1.Id,sec.Id,10);
        listSecItem.add(secItm1);
        SC_Section_Item__c secItm2 = SC_MI_TestHandler.insertSectionItem(itm2.Id,sec.Id,20);
        listSecItem.add(secItm2);
        SC_Section_Item__c secItm3 = SC_MI_TestHandler.insertSectionItem(itm3.Id,sec.Id,30);
        listSecItem.add(secItm3);
        insert listSecItem ;
        
        List<SC_User_Response__c> listUsrResp = new List<SC_User_Response__c>();
        SC_User_Response__c usrRsp1 = SC_MI_TestHandler.insertUsrResponse(itm1.Id,res1.Answer__c,'Site Measurement Meeting Confirmed',opp.Id,5);
        listUsrResp.add(usrRsp1);  
        SC_User_Response__c usrRsp2 = SC_MI_TestHandler.insertUsrResponse(itm2.Id,res2.Answer__c,'Site Measurement Meeting Confirmed',opp.Id,5);
        listUsrResp.add(usrRsp2);       
        insert listUsrResp;

        Test.stopTest();
    }
    static testMethod void testStatusUpdate2(){
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> pm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :pm_profile.Id and isActive = True];
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :smm_profile.Id and isActive = True];
        
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :agent_profile.Id and isActive = True];
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> fac_coordinator = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :fac_profile.Id and isActive = True];
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :dp_profile.Id and isActive = True];
        
        Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> managerUser=[SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId =:squareMag_profile.id and isActive = True];
       
        Opportunity opp = SC_MI_TestHandler.insertOpportunity('Test Opportunity',System.Today(),'Initial Quote Sent',100,System.Today()+1); 
        opp.SMM__c=smm_user[0].id;
        opp.PM__c=pm_user[0].id;
        opp.Square_Showroom_Agent__c=agent_user[0].Id;
        opp.Square_Showroom_Manager__c=managerUser[0].Id;
        opp.Factory_Co_ordinator__c=fac_coordinator[0].id;
        opp.design_partner__c=dp_prof[0].id;
        insert opp;
        
        opp.StageName='D2 Initiated';
        //opp.sub_status__c='Design Presentation Confirmed';
        update opp;
        
        List<SC_Item__c> listItems = new List<SC_Item__c>();
        SC_Item__c itm1 = SC_MI_TestHandler.insertItem('Test Itm',TRUE,'Picklist','Record Type D1'); 
        listItems.add(itm1);
        SC_Item__c itm2 = SC_MI_TestHandler.insertItem('Test Itm check',TRUE,'Check Box','Record Type D1'); 
        listItems.add(itm2);
        SC_Item__c itm3 = SC_MI_TestHandler.insertItem('Test Itm check',TRUE,'Check Box','Record Type D1'); 
        listItems.add(itm3);
        insert listItems;
        
        SC_Section__c sec = SC_MI_TestHandler.insertSection('Test Sec','Design Presentation Confirmed',10,NULL);       
        insert sec;        
        List<SC_Response__c> listResponse = new List<SC_Response__c>();
        
        SC_Response__c res1 = SC_MI_TestHandler.insertResponse('Test Answer',itm1.Id,5,TRUE,TRUE);
        listResponse.add(res1);
        SC_Response__c res2 = SC_MI_TestHandler.insertResponse('TRUE',itm2.Id,NULL,TRUE,TRUE);
        listResponse.add(res2);        
        insert listResponse;
        
        List<SC_Section_Item__c> listSecItem = new List<SC_Section_Item__c>();
        SC_Section_Item__c secItm1 = SC_MI_TestHandler.insertSectionItem(itm1.Id,sec.Id,10);
        listSecItem.add(secItm1);
        SC_Section_Item__c secItm2 = SC_MI_TestHandler.insertSectionItem(itm2.Id,sec.Id,20);
        listSecItem.add(secItm2);
        SC_Section_Item__c secItm3 = SC_MI_TestHandler.insertSectionItem(itm3.Id,sec.Id,30);
        listSecItem.add(secItm3);
        insert listSecItem ;
        
        List<SC_User_Response__c> listUsrResp = new List<SC_User_Response__c>();
        SC_User_Response__c usrRsp1 = SC_MI_TestHandler.insertUsrResponse(itm1.Id,res1.Answer__c,'Design Presentation Confirmed',opp.Id,5);
        listUsrResp.add(usrRsp1);  
        SC_User_Response__c usrRsp2 = SC_MI_TestHandler.insertUsrResponse(itm2.Id,res2.Answer__c,'Design Presentation Confirmed',opp.Id,5);
        listUsrResp.add(usrRsp2);       
        insert listUsrResp;

        Test.stopTest();
    }
    static testMethod void testStatusUpdate3(){
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> pm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :pm_profile.Id and isActive = True];
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :smm_profile.Id and isActive = True];
        
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :agent_profile.Id and isActive = True];
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> fac_coordinator = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :fac_profile.Id and isActive = True];
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId = :dp_profile.Id and isActive = True];
        
        Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> managerUser=[SELECT id,Name, Email,Internal_buddy__c FROM User WHERE ProfileId =:squareMag_profile.id and isActive = True];
       
        Opportunity opp = SC_MI_TestHandler.insertOpportunity('Test Opportunity',System.Today(),'Initial Quote Sent',100,System.Today()+1); 
        opp.SMM__c=smm_user[0].id;
        opp.PM__c=pm_user[0].id;
        opp.Square_Showroom_Agent__c=agent_user[0].Id;
        opp.Square_Showroom_Manager__c=managerUser[0].Id;
        opp.Factory_Co_ordinator__c=fac_coordinator[0].id;
        opp.design_partner__c=dp_prof[0].id;
        insert opp;
        
        opp.StageName='D3 Initiated';
        opp.sub_status__c='Project kick-off Meeting Confirmed';
        update opp;
        
        List<SC_Item__c> listItems = new List<SC_Item__c>();
        SC_Item__c itm1 = SC_MI_TestHandler.insertItem('Test Itm',TRUE,'Picklist','Record Type D1'); 
        listItems.add(itm1);
        SC_Item__c itm2 = SC_MI_TestHandler.insertItem('Test Itm check',TRUE,'Check Box','Record Type D1'); 
        listItems.add(itm2);
        SC_Item__c itm3 = SC_MI_TestHandler.insertItem('Test Itm check',TRUE,'Check Box','Record Type D1'); 
        listItems.add(itm3);
        insert listItems;
        
        SC_Section__c sec = SC_MI_TestHandler.insertSection('Test Sec','Project kick-off Meeting Confirmed',10,NULL);       
        insert sec;        
        List<SC_Response__c> listResponse = new List<SC_Response__c>();
        
        SC_Response__c res1 = SC_MI_TestHandler.insertResponse('Test Answer',itm1.Id,5,TRUE,TRUE);
        listResponse.add(res1);
        SC_Response__c res2 = SC_MI_TestHandler.insertResponse('TRUE',itm2.Id,NULL,TRUE,TRUE);
        listResponse.add(res2);        
        insert listResponse;
        
        List<SC_Section_Item__c> listSecItem = new List<SC_Section_Item__c>();
        SC_Section_Item__c secItm1 = SC_MI_TestHandler.insertSectionItem(itm1.Id,sec.Id,10);
        listSecItem.add(secItm1);
        SC_Section_Item__c secItm2 = SC_MI_TestHandler.insertSectionItem(itm2.Id,sec.Id,20);
        listSecItem.add(secItm2);
        SC_Section_Item__c secItm3 = SC_MI_TestHandler.insertSectionItem(itm3.Id,sec.Id,30);
        listSecItem.add(secItm3);
        insert listSecItem ;
        
        List<SC_User_Response__c> listUsrResp = new List<SC_User_Response__c>();
        SC_User_Response__c usrRsp1 = SC_MI_TestHandler.insertUsrResponse(itm1.Id,res1.Answer__c,'Project kick-off Meeting Confirmed',opp.Id,5);
        listUsrResp.add(usrRsp1);  
        SC_User_Response__c usrRsp2 = SC_MI_TestHandler.insertUsrResponse(itm2.Id,res2.Answer__c,'Project kick-off Meeting Confirmed',opp.Id,5);
        listUsrResp.add(usrRsp2);       
        insert listUsrResp;

        Test.stopTest();
    }
}