@isTest
public class LeadTrigger_Test1 {

  static testMethod void handleRoundRobin_Test(){

        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti',Customer_ID__c='BEN-C-0000180') ;
        insert ac; 

        User wta_user=leadUtil_Test.inserUser('tetWta1@gmail.com','TesWT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        User agent_user=leadUtil_Test.inserUser('tesSP1@gmail.com','TeSSP1',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('tstP1@gmail.com','TesSP1',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('tesDP1@gmail.com','TesDP1',ac.Id,profileData.get('Design Partner Profile')); 
        insert dp_prof;

        Lead_Round_Robin_Assignment__c ObjleadRound = new  Lead_Round_Robin_Assignment__c();
        ObjleadRound.Assignment_Days__c = 'Monday;Tuesday;Wednesday;Thursday;Friday;Saturday;Sunday';
        ObjleadRound.Daily_Assignment__c= 0;
        ObjleadRound.Daily_Limit__c= 2;
        ObjleadRound.Distance_from_ShowRoom__c= 5;
        ObjleadRound.Monthly_Assignments__c= 5;
        ObjleadRound.Monthly_Limit__c= 50;
        ObjleadRound.Showroom_Name__c= 'HSR';
        ObjleadRound.User__c= agent_user.id;
        
        insert ObjleadRound;

        lead leadRec1=leadUtil_Test.insertLead('parinitha@gmail.com','7845211200');
        leadRec1.PostalCode='561284';
        leadRec1.status='Fresh Lead';
        leadRec1.Lead_Assingment__c=true;
        //  leadRec1.Interior_Designer__c=objIDP.id;
        leadRec1.City='Bengaluru';
        leadRec1.OwnerId = wta_user.Id;
        leadRec1.leadSource = 'Google Ad';
        leadRec1.Closest_Showroom__c = 'HSR 1 km';
        //stem.runAs(wta_user){
        test.startTest();   
        insert leadRec1;
        //assign users in round robin manner to leads

        leadRec1.Lead_Assingment__c=true;
        system.debug('*************agent_user*******************'+agent_user);
        system.debug('*************managerUser*******************'+managerUser);
        system.debug('*************dp_prof*******************'+dp_prof);
        leadRec1.Square_Showroom_Manager__c=managerUser.id;
        leadRec1.Appointment_Time__c=System.now();
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appointment Successful';
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.LeadSource='website';
        leadRec1.Vanity_Unit__c='Yes';
        leadRec1.Wardrobes__c='1';
        leadRec1.Utility_Unit__c='Yes';
        leadRec1.Study_Table_Book_Shelf__c='Yes';
        //leadRec1.Property__c=master2.Id;
        leadRec1.Appointment_Type__c = 'Mobile Showroom Visit';
        leadRec1.City = 'Mumbai';
        leadRec1.Interior_Start_Date__c = Date.valueOf('2017-12-06T00:00:00.000Z');
        leadRec1.Property_Type__c  = 'Villa';
        leadRec1.Property_Config__c = '1 BHK';
        leadRec1.Property_Status__c = 'New';
        leadRec1.Property_Move_In_Date__c= Date.valueOf('2019-12-06T00:00:00.000Z');
        leadRec1.Kitchen__c = 'Yes';
        leadRec1.Vanity_Unit__c = 'Yes';
        leadRec1.Utility_Unit__c = 'Yes';
        leadRec1.Crockery_Unit__c = 'Yes';
        leadRec1.Entertainment_Unit__c = 'Yes';
        leadRec1.Pooja__c = 'Yes';
        leadRec1.How_did_you_hear_about_us__c = 'Email';
        leadRec1.Study_Table_Book_Shelf__c = 'Yes';
        leadRec1.Foyer_Shoe_Rack__c = 'Yes';
        leadRec1.Appointment_Time__c = Date.valueOf('2017-12-06T00:00:00.000Z');
        leadRec1.Time_of_Actual_Appointment_Start__c = Date.valueOf('2017-12-06T00:00:00.000Z');
        leadRec1.Phone = '69786756783';
        leadRec1.Possession_Date__c = Date.valueOf('2018-12-06T00:00:00.000Z');
        
 
            try{
                update leadRec1;
            }
            catch(DmlException e){
            }
       

        test.stopTest();
    }   
}