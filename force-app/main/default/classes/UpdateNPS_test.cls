@isTest
public class UpdateNPS_test{
    static testMethod void testUpdateNPSMethod(){
        String userEmail = '@HlxxTest.com';
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
        Account ac = new Account(name ='Grazitti',Phone = '1234567892') ;
        insert ac; 
        
        User pm_user=leadUtil_Test.inserUser('pmOu1'+userEmail,'PM1',ac.Id,profileData.get('PM Profile')); 
        insert pm_user;
        User smm_user=leadUtil_Test.inserUser('Smmou1'+userEmail,'SMM1',ac.Id,profileData.get('SMM Profile')); 
        insert smm_user;
        User fac_coordinator=leadUtil_Test.inserUser('FCou1'+userEmail,'SMM1',ac.Id,profileData.get('Factory Coordinator Profile')); 
        insert fac_coordinator;
        User agent_user=leadUtil_Test.inserUser('SSPou1'+userEmail,'eSSP1',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('SPou1'+userEmail,'USP1',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('UDou1'+userEmail,'UDP1',ac.Id,profileData.get('Design Partner Profile'));
        insert dp_prof;
        Account acc = new Account(Name = 'Test Account',Phone = '1234567892');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Test Opportunity',CloseDate  = System.Today(),Amount = 10000,stageName='D1 Initiated',NextStep = 'test step',AccountId = acc.Id);
        //Opportunity opp = SC_MI_TestHandler.insertOpportunity('Test Opportunity',System.Today(),'Initial Quote Sent',100,System.Today()+1); 
        opp.SMM__c=smm_user.id;
        opp.PM__c=pm_user.id;
        opp.Square_Showroom_Agent__c=agent_user.Id;
        opp.Square_Showroom_Manager__c=managerUser.Id;
        opp.Factory_Co_ordinator__c=fac_coordinator.id;
        opp.Customer_Email__c = 'testOpp1@gmail.com';
        opp.design_partner__c=dp_prof.id;
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
        UpdateNPS.strBody = '1234567892';
        UpdateNPS.getopprec();
        
    }
    
    static testMethod void testUpdateNPSMethod2(){
          
        
     Test.StartTest(); 
        
        UpdateNPS.strBody = '1234567898';
        UpdateNPS.getopprec();
        Test.StopTest(); 
    }
}