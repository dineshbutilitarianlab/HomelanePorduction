@isTest
public class SC_MISalesProcess_Test {
    public static TestMethod void  testMethodOne(){ 
        test.startTest();
        
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
        
       // opp.StageName='Design Presentation Completed';
        
       /* opp.StageName='D2 initiated';
        opp.sub_status__c='Design Presentation Completed';
        update opp;*/
        
        opp.Amount = null;
        String usrRspJSON = '[{\"item\":[{\"checkValue\":false,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Motivation\",\"response\":[{\"responseName\":\"Desire to resolve or improve\",\"score\":-1}],\"responseType\":\"PickList\",\"userResId\":\"a0E8E00000063weUAA\",\"value\":\"Desire to resolve or improve\"},{\"checkValue\":false,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Motivation\",\"response\":[{\"responseName\":\"Desire to resolve or improve\",\"score\":-1}],\"responseType\":\"PickList\",\"userResId\":\"a0E8E00000063weUAA\",\"value\":\"NONE\"}],\"section\":[],\"sectionName\":\"Assessing and confirming Needs\"}]';
        //String OppJSON = '{name:thePage:formId,value:thePage:formId},{name:thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c,value:Indiana}';
        String OppJSON = '[{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id48:Id\",\"value\":\"'+opp.Id+'\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:pBlkSecItmStage:PIS__c\",\"value\":\"7,65"},{\"name\":\"thePage:formId:pBlock:pBlockSec:pBlkSecItmStage:StageName\",\"value\":\"Discovery"},{\"name\":\"thePage:formId\",\"value\":\"thePage:formId\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id36:Opportunity_type__c\",\"value\":\"Printer\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id36:Opportunity_type__c\",\"value\":\"Printer\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id36:Probability\",\"value\":\"10\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id42:NextStep\",\"value\":\"a\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id44:Product_Level_3__c\",\"value\":\"Consulting hours\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id49:Number_of_printers_units__c\",\"value\":\"1\"},{\"name\":\"thePage:formId:pBlock:j_id69:j_id83:Sales_type__c\",\"value\":\"Leasing & Rental Sales\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id32:Opportunity_Contact__c_lkid\",\"value\":\"0038E0000072WiI\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c\",\"value\":\"\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id23:Reason_Lost__c\",\"value\":\"_\\u0001_\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"16/03/2016\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id27:Amount\",\"value\":\"10.000,00\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"'+System.today()+'\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id14:Parent_Opportunity__c_lkid\",\"value\":\"000000000000000\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id17:AccountId_lkid\",\"value\":\"0018E000007tjDO\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id6:Country_owner__c\",\"value\":\"\"}]';
        System.debug('Calliung 2st save---------->'+opp.StageName);
        SC_MISalesProcess.saveData(usrRspJSON,null,'Design Presentation Completed');    
        System.debug('opp test000000000000000000 '+opp);
        SC_MISalesProcess.validateStage(opp.Id,'Project kick-off Completed');

        Test.stopTest();
    }    
    
     public static TestMethod void  testMethodFour(){
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
        
        /* opp.StageName='Site Measurement Meeting Confirmed';
        update opp;*/
        opp.StageName='D1 Initiated';
        opp.sub_status__c='Site Measurement Meeting Confirmed';
        update opp;
        
        SC_Item__c itm1 = SC_MI_TestHandler.insertItem('Test Itm',TRUE,'Picklist','Record Type D1'); 
        insert itm1 ;
        
        SC_Response__c res1 = SC_MI_TestHandler.insertResponse('Test Answer',itm1.Id,5,TRUE,TRUE);
        insert res1;
        
        List<SC_User_Response__c> listUsrResp = new List<SC_User_Response__c>();
        SC_User_Response__c usrRsp1 = SC_MI_TestHandler.insertUsrResponse(itm1.Id,res1.Answer__c,'Site Measurement Meeting Confirmed',opp.Id,5);
        listUsrResp.add(usrRsp1); 
              
        insert listUsrResp;
              
        SC_Item__c itm2 = SC_MI_TestHandler.insertItem('Test Itm',TRUE,'Picklist','Record Type D1');        
        insert itm2 ;
        
        SC_Response__c res2 = SC_MI_TestHandler.insertResponse('Test Answer',itm2.Id,5,TRUE,TRUE);
        insert res2;
        
        List<SC_User_Response__c> listUsrResp2 = new List<SC_User_Response__c>();
        
        
        opp.StageName='D3 Initiated';
        opp.sub_status__c='Project kick-off meeting confirmed';
        update opp;
        
        SC_User_Response__c usrRsp2 = SC_MI_TestHandler.insertUsrResponse(itm2.Id,res2.Answer__c,'Site Measurement Meeting Confirmed',opp.Id,5);
        listUsrResp2.add(usrRsp2);  
        insert listUsrResp2;
        
        
        
        String usrRspJSON = '[{\"item\":[{\"checkValue\":false,\"itemId\":\"'+itm2.Id +'\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO rrr\",\"score\":10}],\"responseType\":\"Check Box\",\"userResId\":null,\"value\":\"\"},{\"checkValue\":false,\"itemId\":\"'+itm2.Id +'\",\"itemName\":\"Motivation\",\"response\":[{\"responseName\":\"Desire to resolve or improve\",\"score\":10}],\"responseType\":\"PickList\",\"userResId\":null,\"value\":\"NONE\"}],\"section\":[],\"sectionName\":\"Assessing and confirming Needs\"}]';
        //String OppJSON = '{name:thePage:formId,value:thePage:formId},{name:thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c,value:Indiana}';
        String OppJSON = '[{\"name\":\"thePage:formId\",\"value\":\"thePage:formId\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id27:Amount\",\"value\":\"10000,00\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c\",\"value\":\"\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:pBlkSecItmStage:StageName\",\"value\":\"Closed Lost"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id23:Reason_Lost__c\",\"value\":\"_\\u0001_\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"16/03/2016\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"16/03/2016\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id14:Parent_Opportunity__c_lkid\",\"value\":\"000000000000000\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id17:AccountId_lkid\",\"value\":\"0018E000007tjDO\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id6:Country_owner__c\",\"value\":\"\"}]';
        System.debug('res usr___________>'+usrRspJSON);        System.debug('res usr___________>'+usrRspJSON);
        System.debug('Calliung 3st save---------->'+opp.StageName);
        SC_MISalesProcess.saveData(usrRspJSON,opp.Id,'Closed Lost');

        Test.StopTest(); 
        
        usrRspJSON = '[{\"item\":[{\"checkValue\":true,\"itemId\":\"'+itm2.Id +'\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO rrr\",\"score\":10}],\"responseType\":\"Check Box\",\"userResId\":null,\"value\":\"\"},{\"checkValue\":false,\"itemId\":\"'+itm2.Id +'\",\"itemName\":\"Motivation\",\"response\":[{\"responseName\":\"Desire to resolve or improve\",\"score\":10}],\"responseType\":\"PickList\",\"userResId\":null,\"value\":\"NONE\"}],\"section\":[],\"sectionName\":\"Assessing and confirming Needs\"}]';
        //String OppJSON = '{name:thePage:formId,value:thePage:formId},{name:thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c,value:Indiana}';
        OppJSON = '[{\"name\":\"thePage:formId\",\"value\":\"thePage:formId\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id27:Amount\",\"value\":\"10000,00\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c\",\"value\":\"\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:pBlkSecItmStage:StageName\",\"value\":\"Assessment"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id23:Reason_Lost__c\",\"value\":\"_\\u0001_\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"16/03/2016\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"16/03/2016\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id14:Parent_Opportunity__c_lkid\",\"value\":\"000000000000000\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id17:AccountId_lkid\",\"value\":\"0018E000007tjDO\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id6:Country_owner__c\",\"value\":\"\"}]';
        System.debug('res usr___________>'+usrRspJSON);        System.debug('res usr___________>'+usrRspJSON);
        System.debug('Calliung 3st save---------->'+opp.StageName);
        SC_MISalesProcess.saveData(usrRspJSON,opp.Id,'Closed Lost');
        
        //opp.sub_status__c= 'Design Presentation Completed';
        update opp;  
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
        
        opp.StageName='Project kick-off Completed';
        //opp.stageName='Design Presentation Completed';
        update opp;
        SC_Item__c itm = SC_MI_TestHandler.insertItem('Inspect each area within the client’s requirement',TRUE,'Check Box','Record Type D1'); 
        insert itm;        
        SC_Section__c sec1 = SC_MI_TestHandler.insertSection('Test Sec','Project kick-off Completed',10,NULL);       
        insert sec1;
        
        List<SC_Section__c> listSubSec = new List<SC_Section__c>();
        SC_Section__c subSec1 = SC_MI_TestHandler.insertSection('Test SubSec',NULL,10,sec1.Id);       
        listSubSec.add(subSec1);
        SC_Section__c subSec2 = SC_MI_TestHandler.insertSection('Test SubSec',NULL,20,sec1.Id);       
        listSubSec.add(subSec2);
        insert listSubSec;
        SC_Response__c res = SC_MI_TestHandler.insertResponse('Inspect each area within the client’s requirement',itm.Id,5,TRUE,TRUE);
        insert res;
        
        List<SC_Section_Item__c> listSecItm = new List<SC_Section_Item__c>();
        SC_Section_Item__c secItm1 = SC_MI_TestHandler.insertSectionItem(itm.Id,subSec1.Id,10);
        listSecItm.add(secItm1);
        SC_Section_Item__c secItm2 = SC_MI_TestHandler.insertSectionItem(itm.Id,subSec1.Id,20);
        listSecItm.add(secItm2);
        insert listSecItm;
        SC_User_Response__c usrRsp = SC_MI_TestHandler.insertUsrResponse(itm.Id,res.Answer__c,'Design Presentation Completed',opp.Id,1);
        insert usrRsp;               
        SC_MISalesProcess.getResponse(opp.Id,'Project kick-off Completed','Record Type D1',1,1,1,1,1,1,1,1); 
        SC_MISalesProcess.getOpportunityStages();
        SC_MISalesProcess.getAllPreviousStage('Project kick-off Completed');
        SC_MISalesProcess.isReadyToNextStage(opp.Id,'Project kick-off Completed');
        SC_MISalesProcess.dltCommitmentUsrRsp(opp.Id);
        
        DateTime CreatedDateTime = datetime.newInstance(2016, 3, 10, 12, 30, 0);

        String usrRspJSON = '[{\"item\":[],\"section\":[{\"item\":[{\"checkValue\":true,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO rrr\",\"score\":-1}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E00000063weUbA\",\"value\":\"NONE\"},{\"checkValue\":false,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO received?\",\"score\":0}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E00000063weUAA\",\"value\":\"NONE\"},{\"checkValue\":false,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Motivation\",\"response\":[{\"responseName\":\"Desire to resolve or improve\",\"score\":-1}],\"responseType\":\"PickList\",\"userResId\":\"a0E8E00000063weUAA\",\"value\":\"Desire to resolve or improve\"},{\"checkValue\":true,\"itemId\":\"a0B8E000000iA4YUAU\",\"itemName\":\"Do you know the end customer?\",\"response\":[{\"responseName\":\"Do you know the end customer?\",\"score\":-1}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E0000004tT2UAI\",\"value\":\"\"}],\"section\":[],\"sectionName\":\"OEM information\"},{\"item\":[{\"checkValue\":true,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO rrr\",\"score\":0}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E00000063weUbA\",\"value\":\"\"},{\"checkValue\":true,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO received?\",\"score\":0}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E00000063weUAA\",\"value\":\"\"},{\"checkValue\":true,\"itemId\":\"a0B8E000000iA4YUAU\",\"itemName\":\"Do you know the end customer?\",\"response\":[{\"responseName\":\"Do you know the end customer?\",\"score\":0}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E0000004tT2UAI\",\"value\":\"\"}],\"section\":[],\"sectionName\":\"OEM information\"},{\"item\":[{\"checkValue\":true,\"itemId\":\"a0E8E00000063weUAA\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO received?\",\"score\":-1}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E00000063weUAA\",\"value\":\"\"},{\"checkValue\":true,\"itemId\":\"a0B8E000000iA4YUAU\",\"itemName\":\"Do you know the end customer?\",\"response\":[{\"responseName\":\"Do you know the end customer?\",\"score\":0}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E0000004tT2UAI\",\"value\":\"\"}],\"section\":[],\"sectionName\":\"OEM information\"}],\"sectionName\":\"Exploring Customer Needs\"}]';
        //String OppJSON = '{name:thePage:formId,value:thePage:formId},{name:thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c,value:Indiana}';
        String OppJSON = '[{\"name\":\"thePage:formId\",\"value\":\"thePage:formId\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id27:Amount\",\"value\":\"10000,00\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c\",\"value\":\"NONE\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:pBlkSecItmStage:StageName\",\"value\":\"Commitment\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id23:Reason_Lost__c\",\"value\":\"_\\u0001_\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"16/03/2016\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"16/03/2016\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id14:Parent_Opportunity__c_lkid\",\"value\":\"000000000000000\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id17:AccountId_lkid\",\"value\":\"0018E000007tjDO\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id6:Country_owner__c\",\"value\":\"\"}]';
        System.debug('res usr___________>'+usrRspJSON);        System.debug('res usr___________>'+usrRspJSON);
        System.debug('Calliung 3st save---------->'+opp.StageName);
        SC_MISalesProcess.saveData(usrRspJSON,opp.Id,'Project kick-off Completed');
        PreviousStageSections sp = new PreviousStageSections('section test','true',3,3);
        //sp.compareTo(null);
        Test.stopTest();
    }
    public static TestMethod void  testMethodThree(){
        test.startTest();
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
        SC_MISalesProcess.getResponse(opp.Id,'Site Measurement Meeting Confirmed','Record Type D1',0,0,0,0,0,0,0,0); 
        SC_MISalesProcess.getOpportunityStages();
        SC_MISalesProcess.getAllPreviousStage('Design Presentation Completed');
        SC_MISalesProcess.isReadyToNextStage(opp.Id,'Design Presentation Completed');
        
        PreviousStageSections sp = new PreviousStageSections('section test','test 2',3,3);
        SC_MISalesProcess.ErrorMsgWrapper ew = new SC_MISalesProcess.ErrorMsgWrapper('error','field'); 
        
         SC_MISalesProcess.validateStage(opp.Id,'Site Measurement Meeting Confirmed');
        String usrRspJSON = '[{\"item\":[{\"checkValue\":true,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO rrr\",\"score\":null}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E00000063weUbA\",\"value\":\"\"},{\"checkValue\":false,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Motivation\",\"response\":[{\"responseName\":\"Desire to resolve or improve\",\"score\":-1}],\"responseType\":\"PickList\",\"userResId\":\"a0E8E00000063weUAA\",\"value\":\"Desire to resolve or improve\"}],\"section\":[],\"sectionName\":\"Assessing and confirming Needs\"}]';
        //String OppJSON = '{name:thePage:formId,value:thePage:formId},{name:thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c,value:Indiana}';
        String OppJSON = '[{\"name\":\"thePage:formId\",\"value\":\"thePage:formId\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id27:Amount\",\"value\":\"10ww000,00\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c\",\"value\":\"\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:pBlkSecItmStage:StageName\",\"value\":\"Commitment"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id23:Reason_Lost__c\",\"value\":\"_\\u0001_\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"16/03/2016\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"16/03/2016\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id14:Parent_Opportunity__c_lkid\",\"value\":\"000000000000000\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id17:AccountId_lkid\",\"value\":\"0018E000007tjDO\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id6:Country_owner__c\",\"value\":\"\"}]';
        System.debug('res usr___________>'+usrRspJSON);        System.debug('res usr___________>'+usrRspJSON);
        System.debug('Calliung 3st save---------->'+opp.StageName);
        SC_MISalesProcess.saveData(usrRspJSON,opp.Id,'Closed Won');
        SC_MISalesProcess.validateStage(opp.Id,'Closed Won');
              
        Test.stopTest();
    }
    public static TestMethod void testMEthodFive(){
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
        
        opp.StageName='Project kick-off Completed';
        //opp.stageName='Design Presentation Completed';
        update opp;
        SC_Item__c itm = SC_MI_TestHandler.insertItem('Inspect each area within the client’s requirement',TRUE,'Check Box','Record Type D1'); 
        insert itm;        
        SC_Section__c sec1 = SC_MI_TestHandler.insertSection('Test Sec','Project kick-off Completed',10,NULL);       
        insert sec1;
        
        List<SC_Section__c> listSubSec = new List<SC_Section__c>();
        SC_Section__c subSec1 = SC_MI_TestHandler.insertSection('Test SubSec',NULL,10,sec1.Id);       
        listSubSec.add(subSec1);
        SC_Section__c subSec2 = SC_MI_TestHandler.insertSection('Test SubSec',NULL,20,sec1.Id);       
        listSubSec.add(subSec2);
        insert listSubSec;
        SC_Response__c res = SC_MI_TestHandler.insertResponse('Inspect each area within the client’s requirement',itm.Id,5,TRUE,TRUE);
        insert res;
        
        List<SC_Section_Item__c> listSecItm = new List<SC_Section_Item__c>();
        SC_Section_Item__c secItm1 = SC_MI_TestHandler.insertSectionItem(itm.Id,subSec1.Id,10);
        listSecItm.add(secItm1);
        SC_Section_Item__c secItm2 = SC_MI_TestHandler.insertSectionItem(itm.Id,subSec1.Id,20);
        listSecItm.add(secItm2);
        insert listSecItm;
        SC_User_Response__c usrRsp = SC_MI_TestHandler.insertUsrResponse(itm.Id,res.Answer__c,'Project kick-off Completed',opp.Id,1);
        insert usrRsp;               
        SC_MISalesProcess.getResponse(opp.Id,'Project kick-off Completed','Record Type D1',1,0,1,0,1,0,1,0); 
        SC_MISalesProcess.getOpportunityStages();
        SC_MISalesProcess.getAllPreviousStage('Project kick-off Completed');
        SC_MISalesProcess.isReadyToNextStage(opp.Id,'Project kick-off Completed');
        
        DateTime CreatedDateTime = datetime.newInstance(2016, 3, 10, 12, 30, 0);

        String usrRspJSON = '[{\"item\":[],\"section\":[{\"item\":[{\"checkValue\":true,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO rrr\",\"score\":3}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E00000063weUAA\",\"value\":\"\"},{\"checkValue\":true,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO received?\",\"score\":0}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E00000063weUAA\",\"value\":\"a0E8E00000063weUAA\"},{\"checkValue\":true,\"itemId\":\"a0B8E000000iA4YUAU\",\"itemName\":\"Do you know the end customer?\",\"response\":[{\"responseName\":\"Do you know the end customer?\",\"score\":-1}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E0000004tT2UAI\",\"value\":\"\"}],\"section\":[],\"sectionName\":\"OEM information\"},{\"item\":[{\"checkValue\":true,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO rrr\",\"score\":null}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E00000063weUbA\",\"value\":\"\"},{\"checkValue\":true,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO received?\",\"score\":0}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E00000063weUAA\",\"value\":\"\"},{\"checkValue\":true,\"itemId\":\"a0B8E000000iA4YUAU\",\"itemName\":\"Do you know the end customer?\",\"response\":[{\"responseName\":\"Do you know the end customer?\",\"score\":0}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E0000004tT2UAI\",\"value\":\"\"}],\"section\":[],\"sectionName\":\"OEM information\"},{\"item\":[{\"checkValue\":true,\"itemId\":\"a0E8E00000063weUAA\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO received?\",\"score\":7}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E00000063weUAA\",\"value\":\"\"},{\"checkValue\":true,\"itemId\":\"a0B8E000000iA4YUAU\",\"itemName\":\"Do you know the end customer?\",\"response\":[{\"responseName\":\"Do you know the end customer?\",\"score\":0}],\"responseType\":\"Check Box\",\"userResId\":\"a0E8E0000004tT2UAI\",\"value\":\"\"}],\"section\":[],\"sectionName\":\"OEM information\"}],\"sectionName\":\"Exploring Customer Needs\"}]';
        //String OppJSON = '{name:thePage:formId,value:thePage:formId},{name:thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c,value:Indiana}';
        String OppJSON = '[{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id48:Id\",\"value\":\"'+opp.Id+'\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:pBlkSecItmStage:StageName\",\"value\":\"Discovery"},{\"name\":\"thePage:formId\",\"value\":\"thePage:formId\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id36:Opportunity_type__c\",\"value\":\"Printer\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id36:Opportunity_type__c\",\"value\":\"Printer\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id42:NextStep\",\"value\":\"a\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id44:Product_Level_3__c\",\"value\":\"Consulting hours\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id49:Number_of_printers_units__c\",\"value\":\"1\"},{\"name\":\"thePage:formId:pBlock:j_id69:j_id83:Sales_type__c\",\"value\":\"Leasing & Rental Sales\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id32:Opportunity_Contact__c_lkid\",\"value\":\"0038E0000072WiI\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c\",\"value\":\"\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id23:Reason_Lost__c\",\"value\":\"_\\u0001_\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"16/03/2016\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id27:Amount\",\"value\":\"10ww.000,00\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"'+System.today()+'\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id14:Parent_Opportunity__c_lkid\",\"value\":\"000000000000000\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id17:AccountId_lkid\",\"value\":\"0018E000007tjDO\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id6:Country_owner__c\",\"value\":\"\"}]';
        System.debug('res usr___________>'+usrRspJSON);        System.debug('res usr___________>'+usrRspJSON);
        System.debug('Calliung 3st save---------->'+opp.StageName);
        SC_MISalesProcess.saveData(usrRspJSON,opp.Id,'Project kick-off Completed');
        PreviousStageSections sp = new PreviousStageSections('section test','true',3,3);
        //sp.compareTo(null);
        Test.stopTest();
    }
        public static TestMethod void testMEthodSix(){
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
        
        /* previous stage information */
        SC_Item__c itm11 = SC_MI_TestHandler.insertItem('Inspect each area within the client’s requirement',TRUE,'Check Box','Record Type D1'); 
        insert itm11;        
        SC_Section__c sec11 = SC_MI_TestHandler.insertSection('Test Sec','Site Measurement Meeting Confirmed',10,NULL);       
        insert sec11;
        
        List<SC_Section__c> listSubSec11 = new List<SC_Section__c>();
        SC_Section__c subSec11 = SC_MI_TestHandler.insertSection('Test SubSec',NULL,10,sec11.Id);       
        listSubSec11.add(subSec11);
        SC_Section__c subSec22 = SC_MI_TestHandler.insertSection('Test SubSec',NULL,20,sec11.Id);       
        listSubSec11.add(subSec22);
        insert listSubSec11;
        SC_Response__c res11 = SC_MI_TestHandler.insertResponse('Inspect each area within the client’s requirement',itm11.Id,5,TRUE,TRUE);
        insert res11;
        
        List<SC_Section_Item__c> listSecItm11 = new List<SC_Section_Item__c>();
        SC_Section_Item__c secItm11 = SC_MI_TestHandler.insertSectionItem(itm11.Id,subSec11.Id,10);
        listSecItm11.add(secItm11);
        SC_Section_Item__c secItm22 = SC_MI_TestHandler.insertSectionItem(itm11.Id,subSec11.Id,20);
        listSecItm11.add(secItm22);
        insert listSecItm11;
        SC_User_Response__c usrRsp11 = SC_MI_TestHandler.insertUsrResponse(itm11.Id,res11.Answer__c,'Site Measurement Meeting Confirmed',opp.Id,1);
        insert usrRsp11;               
        
        
        /* End - Previous tstage info */        
        
        opp.StageName='Project kick-off Completed';
        //opp.stageName='Design Presentation Completed';
        update opp;
        SC_Item__c itm = SC_MI_TestHandler.insertItem('Inspect each area within the client’s requirement',TRUE,'Check Box','Record Type D1'); 
        insert itm;        
        SC_Section__c sec1 = SC_MI_TestHandler.insertSection('Test Sec','Project kick-off Completed',10,NULL);       
        insert sec1;
        
        List<SC_Section__c> listSubSec = new List<SC_Section__c>();
        SC_Section__c subSec1 = SC_MI_TestHandler.insertSection('Test SubSec',NULL,10,sec1.Id);       
        listSubSec.add(subSec1);
        SC_Section__c subSec2 = SC_MI_TestHandler.insertSection('Test SubSec',NULL,20,sec1.Id);       
        listSubSec.add(subSec2);
        insert listSubSec;
        SC_Response__c res = SC_MI_TestHandler.insertResponse('Inspect each area within the client’s requirement',itm.Id,5,TRUE,TRUE);
        insert res;
        
        List<SC_Section_Item__c> listSecItm = new List<SC_Section_Item__c>();
        SC_Section_Item__c secItm1 = SC_MI_TestHandler.insertSectionItem(itm.Id,subSec1.Id,10);
        listSecItm.add(secItm1);
        SC_Section_Item__c secItm2 = SC_MI_TestHandler.insertSectionItem(itm.Id,subSec1.Id,20);
        listSecItm.add(secItm2);
        insert listSecItm;
        SC_User_Response__c usrRsp = SC_MI_TestHandler.insertUsrResponse(itm.Id,res.Answer__c,'Project kick-off Completed',opp.Id,1);
        insert usrRsp;               
        SC_MISalesProcess.getResponse(opp.Id,'Project kick-off Completed','Record Type D1',2,2,2,2,2,2,2,2); 
        SC_MISalesProcess.getOpportunityStages();
        SC_MISalesProcess.getAllPreviousStage('Project kick-off Completed');
        SC_MISalesProcess.isReadyToNextStage(opp.Id,'Project kick-off Completed');
         
        
        DateTime CreatedDateTime = datetime.newInstance(2016, 3, 10, 12, 30, 0);

        String usrRspJSON = '[{\"item\":[{\"checkValue\":true,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO rrr\",\"score\":10}],\"responseType\":\"Check Box\",\"userResId\":\"\",\"value\":\"\"},{\"checkValue\":false,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Motivation\",\"response\":[{\"responseName\":\"Desire to resolve or improve\",\"score\":10}],\"responseType\":\"PickList\",\"userResId\":\"a0E8E00000063weUAA\",\"value\":\"NONE\"}],\"section\":[],\"sectionName\":\"Assessing and confirming Needs\"}]';
        //String OppJSON = '{name:thePage:formId,value:thePage:formId},{name:thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c,value:Indiana}';
        String OppJSON = '[{\"name\":\"thePage:formId\",\"value\":\"thePage:formId\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id27:Amount\",\"value\":\"10000,00\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c\",\"value\":\"\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:pBlkSecItmStage:StageName\",\"value\":\"Commitment"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id23:Reason_Lost__c\",\"value\":\"_\\u0001_\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"16/03/2016\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"16/03/2016\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id14:Parent_Opportunity__c_lkid\",\"value\":\"000000000000000\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id17:AccountId_lkid\",\"value\":\"0018E000007tjDO\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id6:Country_owner__c\",\"value\":\"\"}]';
        System.debug('res usr___________>'+usrRspJSON);        System.debug('res usr___________>'+usrRspJSON);
        System.debug('Calliung 3st save---------->'+opp.StageName);
        SC_MISalesProcess.saveData(usrRspJSON,opp.Id,'Project kick-off Completed');
        
        Sections sc = new Sections('section 2',10);
        sc.compareTo(sc);
        
        Sections sc1 = new Sections('section 1',20);
        sc.compareTo(sc1);
        
        
        PreviousStageSections sp = new PreviousStageSections('section test','true',3,3);
        sp.compareTo(sp);
        PreviousStageSections sp1 = new PreviousStageSections('section test','true',2,2);
        sp.compareTo(sp1);       
        
        
        
        
        
        //sp.compareTo(null);
        Test.stopTest();
    }
     public static TestMethod void testMEthodSeven(){
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
        
        opp.StageName='Project kick-off Completed';
        //opp.stageName='Design Presentation Completed';
        update opp;
        SC_Item__c itm = SC_MI_TestHandler.insertItem('Inspect each area within the client’s requirement',TRUE,'Check Box','Record Type D1'); 
        insert itm;        
        SC_Section__c sec1 = SC_MI_TestHandler.insertSection('Test Sec','Project kick-off Completed',10,NULL);       
        insert sec1;
        
        List<SC_Section__c> listSubSec = new List<SC_Section__c>();
        SC_Section__c subSec1 = SC_MI_TestHandler.insertSection('Test SubSec',NULL,10,sec1.Id);       
        listSubSec.add(subSec1);
        SC_Section__c subSec2 = SC_MI_TestHandler.insertSection('Test SubSec',NULL,20,sec1.Id);       
        listSubSec.add(subSec2);
        insert listSubSec;
        SC_Response__c res = SC_MI_TestHandler.insertResponse('Inspect each area within the client’s requirement',itm.Id,5,TRUE,TRUE);
        insert res;
        
        List<SC_Section_Item__c> listSecItm = new List<SC_Section_Item__c>();
        SC_Section_Item__c secItm1 = SC_MI_TestHandler.insertSectionItem(itm.Id,subSec1.Id,10);
        listSecItm.add(secItm1);
        SC_Section_Item__c secItm2 = SC_MI_TestHandler.insertSectionItem(itm.Id,subSec1.Id,20);
        listSecItm.add(secItm2);
        insert listSecItm;
        SC_User_Response__c usrRsp = SC_MI_TestHandler.insertUsrResponse(itm.Id,res.Answer__c,'Design Presentation Completed',opp.Id,1);
        insert usrRsp;               
        SC_MISalesProcess.getResponse(opp.Id,'Project kick-off Completed','Record Type D1',0,1,0,1,0,1,0,1); 
        SC_MISalesProcess.getOpportunityStages();
        SC_MISalesProcess.getAllPreviousStage('Project kick-off Completed');
        SC_MISalesProcess.isReadyToNextStage(opp.Id,'Project kick-off Completed');
         
        SC_MISalesProcess.dltCommitmentUsrRsp(opp.Id);
        
        DateTime CreatedDateTime = datetime.newInstance(2016, 3, 10, 12, 30, 0);

        String usrRspJSON = '[{\"item\":[],\"section\":[{\"item\":[{\"checkValue\":true,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO rrr\",\"score\":-1}],\"responseType\":\"Check Box\",\"userResId\":null,\"value\":\"NONE\"},{\"checkValue\":false,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO received?\",\"score\":0}],\"responseType\":\"Check Box\",\"userResId\":null,\"value\":\"NONE\"},{\"checkValue\":false,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Motivation\",\"response\":[{\"responseName\":\"Desire to resolve or improve\",\"score\":-1}],\"responseType\":\"PickList\",\"userResId\":null,\"value\":\"Desire to resolve or improve\"},{\"checkValue\":true,\"itemId\":\"a0B8E000000iA4YUAU\",\"itemName\":\"Do you know the end customer?\",\"response\":[{\"responseName\":\"Do you know the end customer?\",\"score\":-1}],\"responseType\":\"Check Box\",\"userResId\":null,\"value\":\"\"}],\"section\":[],\"sectionName\":\"OEM information\"},{\"item\":[{\"checkValue\":true,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO rrr\",\"score\":0}],\"responseType\":\"Check Box\",\"userResId\":null,\"value\":\"\"},{\"checkValue\":true,\"itemId\":\"a0B8E000000i78YUAQ\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO received?\",\"score\":0}],\"responseType\":\"Check Box\",\"userResId\":null,\"value\":\"\"},{\"checkValue\":true,\"itemId\":\"a0B8E000000iA4YUAU\",\"itemName\":\"Do you know the end customer?\",\"response\":[{\"responseName\":\"Do you know the end customer?\",\"score\":0}],\"responseType\":\"Check Box\",\"userResId\":null,\"value\":\"\"}],\"section\":[],\"sectionName\":\"OEM information\"},{\"item\":[{\"checkValue\":true,\"itemId\":\"a0E8E00000063weUAA\",\"itemName\":\"Written customer PO received?\",\"response\":[{\"responseName\":\"Written customer PO received?\",\"score\":-1}],\"responseType\":\"Check Box\",\"userResId\":null,\"value\":\"\"},{\"checkValue\":true,\"itemId\":\"a0B8E000000iA4YUAU\",\"itemName\":\"Do you know the end customer?\",\"response\":[{\"responseName\":\"Do you know the end customer?\",\"score\":0}],\"responseType\":\"Check Box\",\"userResId\":null,\"value\":\"\"}],\"section\":[],\"sectionName\":\"OEM information\"}],\"sectionName\":\"Exploring Customer Needs\"}]';
        //String OppJSON = '{name:thePage:formId,value:thePage:formId},{name:thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c,value:Indiana}';
        String OppJSON = '[{\"name\":\"thePage:formId\",\"value\":\"thePage:formId\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id27:Amount\",\"value\":\"10000\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id2:Region_owner__c\",\"value\":\"NONE\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:pBlkSecItmStage:StageName\",\"value\":\"Commitment\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id23:Reason_Lost__c\",\"value\":\"_\\u0001_\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"16/03/2016\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id4:Creation_Date__c\",\"value\":\"16/03/2016\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id14:Parent_Opportunity__c_lkid\",\"value\":\"000000000000000\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id17:AccountId_lkid\",\"value\":\"0018E000007tjDO\"},{\"name\":\"thePage:formId:pBlock:pBlockSec:j_id6:Country_owner__c\",\"value\":\"\"}]';
        System.debug('res usr___________>'+usrRspJSON);        System.debug('res usr___________>'+usrRspJSON);
        System.debug('Calliung 3st save---------->'+opp.StageName);
        SC_MISalesProcess.saveData(usrRspJSON,opp.Id,'Project kick-off Completed');
        PreviousStageSections sp = new PreviousStageSections('section test','true',3,3);
        //sp.compareTo(null);
        Test.stopTest();

    }

}