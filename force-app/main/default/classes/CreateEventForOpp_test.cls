@isTest
public class CreateEventForOpp_test{
    static testMethod void testGetcustomerstatusMethod1(){
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('Square Sales Profile - SF License','Square Sales Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        User pm_user=leadUtil_Test.inserUser('PM2@HLStest.com','PM2',ac.Id,profileData.get('Square Sales Profile')); 
        insert pm_user;
        User smm_user=leadUtil_Test.inserUser('Smmta2@HLStest.com','SMM2',ac.Id,profileData.get('Square Sales Profile')); 
        insert smm_user;
        User fac_coordinator=leadUtil_Test.inserUser('FCP2@HLStest.com','SMM2',ac.Id,profileData.get('Square Sales Profile')); 
        insert fac_coordinator;
        User agent_user=leadUtil_Test.inserUser('SSP2@HLStest.com','eSSP2',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('SP2@HLStest.com','USP2',ac.Id,profileData.get('Square Sales Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('UDP2@kvpcorp.com','UDP2',ac.Id,profileData.get('Square Sales Profile'));
        insert dp_prof;
         Account acc = new Account(Name = 'Test Account',Phone = '123456789');
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
        opp.Customer_Email__c = 'testClass2@gmail.com';
        opp.Appointment_Type__c = 'Virtual Meeting';
        update opp;
         system.debug('-----Test Opportunity data--'+opp);
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
        
        CreateEventForOpp.strBody = '{"phone":"123456789","email":"testClass2@gmail.com","startTime":"2018-02-07 10:00:00","endTime":"2018-02-07 11:00:00"}';
        CreateEventForOpp.getopprec();
        
    }
     static testMethod void testGetcustomerstatusMethod2(){
        
        CreateEventForOpp.strBody = '{"phone":"123456789","email":"testClassw@gmail.com","startTime":"2018-02-07 10:00:00","endTime":"2018-02-07 11:00:00"}';
       // CreateEventForOpp.getopprec();
        
    }
    static testMethod void testGetcustomerstatusLeadMethod(){
       Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
         User wta_user = new User(alias = 'ameyo', email='ameyousertest@homelane.com',
                emailencodingkey='UTF-8', lastname='Ameyo User', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertest@homelane.com');
        insert wta_user;
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Noida';
        insert objRA;
        lead leadRec1=leadUtil_Test.insertLead('parinitha@gmail.com','1234567899');
         leadRec1.PostalCode='561284';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.LeadSource = 'Website';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.WT_Agent__c = wta_user.Id;
         leadRec1.Ameyo_Call_Attempts__c = 8;
         leadRec1.Attempts_since_last_connection__c = 6;
         leadRec1.Follow_up_time__c= system.now();
         insert leadRec1;

        CreateEventForOpp.strBody = '{"phone":"1234567899","email":"testClassw@gmail.com","startTime":"2018-02-07 10:00:00","endTime":"2018-02-07 11:00:00"}';
        CreateEventForOpp.getopprec();
        
    }
    
    
}