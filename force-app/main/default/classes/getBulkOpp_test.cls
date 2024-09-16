@isTest
public class getBulkOpp_test{
    static testMethod void testgetBulkOppMethod1(){
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','SMM Profile','Square Sales Profile','Square Profile','Factory Coordinator Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        User pm_user=leadUtil_Test.inserUser('PM2@hlOtest.com','PM2',ac.Id,profileData.get('PM Profile')); 
        insert pm_user;
        User smm_user=leadUtil_Test.inserUser('Smmta2@hlOtest.com','SMM2',ac.Id,profileData.get('SMM Profile')); 
        insert smm_user;
        User fac_coordinator=leadUtil_Test.inserUser('FCP2@hlOtest.com','SMM2',ac.Id,profileData.get('Factory Coordinator Profile')); 
        insert fac_coordinator;
        User agent_user=leadUtil_Test.inserUser('SSP2@hlOtest.com','eSSP2',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('SP2@hlOtest.com','USP2',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('UDP2@kvpcorp.com','UDP2',ac.Id,profileData.get('Design Partner Profile'));
        insert dp_prof;
         Account acc = new Account(Name = 'Test Account');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Test Opportunity',CloseDate  = System.Today(),Amount = 10000,stageName='D1 Initiated',NextStep = 'test step',AccountId = acc.Id);
        //Opportunity opp = SC_MI_TestHandler.insertOpportunity('Test Opportunity',System.Today(),'Initial Quote Sent',100,System.Today()+1); 
        opp.SMM__c=smm_user.id;
        opp.PM__c=pm_user.id;
        opp.Square_Showroom_Agent__c=agent_user.Id;
        opp.Square_Showroom_Manager__c=managerUser.Id;
        opp.Factory_Co_ordinator__c=fac_coordinator.id;
        opp.Customer_Email__c = 'testClass1@gmail.com';
        opp.design_partner__c=dp_prof.id;
        opp.sub_status__c='Site Measurement Meeting Confirmed';
        insert opp;
         
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
        Getbulkopp.strBody = '{"email":"testClass1@gmail.com"}';
        Getbulkopp.getopprec();
        
    }
    static testMethod void testgetBulkOppMethod2(){
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','SMM Profile','Square Sales Profile','Square Profile','Factory Coordinator Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        User pm_user=leadUtil_Test.inserUser('PM1@hlotest.com','PM2',ac.Id,profileData.get('PM Profile')); 
        insert pm_user;
        User smm_user=leadUtil_Test.inserUser('Smmta1@hlotest.com','SMM2',ac.Id,profileData.get('SMM Profile')); 
        insert smm_user;
        User fac_coordinator=leadUtil_Test.inserUser('FCP1@hlotest.com','SMM2',ac.Id,profileData.get('Factory Coordinator Profile')); 
        insert fac_coordinator;
        User agent_user=leadUtil_Test.inserUser('SSP1@hlotest.com','eSSP2',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('SP1@hlotest.com','USP2',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('UDP2@kvpcorp.com','UDP2',ac.Id,profileData.get('Design Partner Profile'));
        insert dp_prof;
         Account acc = new Account(Name = 'Test Account');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Test Opportunity',CloseDate  = System.Today(),Amount = 10000,stageName='D1 Initiated',NextStep = 'test step',AccountId = acc.Id);
        //Opportunity opp = SC_MI_TestHandler.insertOpportunity('Test Opportunity',System.Today(),'Initial Quote Sent',100,System.Today()+1); 
        opp.SMM__c=smm_user.id;
        opp.PM__c=pm_user.id;
        opp.Square_Showroom_Agent__c=agent_user.Id;
        opp.Square_Showroom_Manager__c=managerUser.Id;
        opp.Factory_Co_ordinator__c=fac_coordinator.id;
        opp.Customer_Email__c = 'testClass2@gmail.com';
        opp.design_partner__c=dp_prof.id;
        opp.sub_status__c='Site Measurement Meeting Confirmed';
        insert opp;
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
        Opportunity ObjOpp1 = new Opportunity();
        ObjOpp1.Name = 'TestOpp2';
        ObjOpp1.Customer_Email__c = 'testClass2@gmail.com';
        ObjOpp1.StageName = 'Quote Required';
        ObjOpp1.CloseDate = Date.valueOf('2017-12-06T00:00:00.000Z');
        Insert ObjOpp1;
        Getbulkopp.strBody = '{"email":"testClass2@gmail.com"}';
        Getbulkopp.getopprec();
        
    }
}