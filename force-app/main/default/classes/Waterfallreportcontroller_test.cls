@IsTest
private class Waterfallreportcontroller_test{
    @isTest static void starttestWaterfallreportcontroller() {
         
         City_Names__c c2 = new City_Names__c(Name = 'Bengaluru');
         insert c2;
         
         
         lead h = new lead();
         h.LastName = 'AdityaSain';
         h.Leadsource = 'Website';
         h.city = 'Bengaluru';
         h.phone = '8899567876';
         h.Status='Fresh Lead';
         h.Creation_Date__c = Date.valueof('2018-01-01T00:24:09.000Z');
         insert h;
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
        Opportunity opp = new Opportunity(Name = 'Test Opportunity',CloseDate  = System.Today(),Amount = 10000,stageName='D1 Initiated',NextStep = 'test step',AccountId = acc.Id,Lead_Created_Date__c = Date.valueof('2018-01-01T00:24:09.000Z'),CityfromLead__c = 'Bengaluru',Opportunity_Status__c='WON');
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
        
         Test.StartTest();
         Waterfallreportcontroller tess = new Waterfallreportcontroller(); 
          tess.getReportdata();
          tess.getYears();
          tess.Download();
          Test.StopTest();
    }
    @isTest static void starttestWaterfallreportcontroller2() { 
         City_Names__c c1 = new City_Names__c(Name = 'Noida');
         insert c1;
         lead hn = new lead();
         hn.LastName = 'AdityaSain';
         hn.Leadsource = 'Website';
         hn.city = 'Noida';
         hn.phone = '8899567876';
         hn.Status='Fresh Lead';
         hn.Creation_Date__c = Date.valueof('2018-01-01T00:24:09.000Z');
         insert hn;
         
         lead h1n = new lead();
         h1n.LastName = 'AdityaSain';
         h1n.Leadsource = 'Website';
         h1n.city = 'Noida';
         h1n.phone = '8899567876';
         h1n.Status='Fresh Lead';
         h1n.Creation_Date__c = Date.valueof('2018-01-01T00:24:09.000Z');
         insert h1n;
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
        Opportunity opp = new Opportunity(Name = 'Test Opportunity',CloseDate  = System.Today(),Amount = 10000,stageName='D1 Initiated',NextStep = 'test step',AccountId = acc.Id,CityfromLead__c = 'Noida',Opportunity_Status__c='WON',Lead_Created_Date__c = Date.valueof('2018-01-01T00:24:09.000Z'));
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
        
         Test.StartTest();
         Waterfallreportcontroller tess = new Waterfallreportcontroller(); 
          tess.getReportdata();
          tess.getYears();
          tess.Download();
         Test.StopTest(); 
    }
   @isTest static void starttestWaterfallreportcontroller3() {  
        City_Names__c c3 = new City_Names__c(Name = 'Hyderabad');
         insert c3;
         lead h1 = new lead();
         h1.LastName = 'AdityaSin';
         h1.Leadsource = 'Website';
         h1.city = 'Hyderabad';
         h1.phone = '8899777876';
         h1.Status='Fresh Lead';
         h1.Creation_Date__c = Date.valueof('2018-01-01T00:24:09.000Z');
         insert h1;
                 
         lead h2 = new lead();
         h2.LastName = 'AdiaSain';
         h2.Leadsource = 'Website';
         h2.city = 'Hyderabad';
         h2.phone = '8899564476';
         h2.Status='Fresh Lead';
         h2.Creation_Date__c = Date.valueof('2018-01-01T00:24:09.000Z');
         insert h2;
         Test.StartTest();
         Waterfallreportcontroller tess = new Waterfallreportcontroller(); 
          tess.getReportdata();
          tess.getYears();
          tess.Download();
          Test.StopTest();
        
         
          
          
   }
   
}