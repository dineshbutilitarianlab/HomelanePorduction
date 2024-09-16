@isTest
public class UpdateLeadMeetings_test{
     
    static testMethod void testUpdateLeadMeetingsMethod3(){
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        User wta_user=leadUtil_Test.inserUser('tetWta1@gmail.com','TesWT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        User agent_user=leadUtil_Test.inserUser('tesSP1@gmail.com','TeSSP1',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('tstP1@gmail.com','TesSP1',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('tesDP1@gmail.com','TesDP1',ac.Id,profileData.get('Design Partner Profile')); 
        insert dp_prof;
         Interior_Designer__c objIDP = new Interior_Designer__c();
        objIDP.Name = 'testData';
        objIDP.Email__c = 'TestDesighP@abtest.com';
        objIDP.User_Name__c = dp_prof.Id;
        insert objIDP;
         //insert new lead record 
          Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Mumbai';
        insert objRA;        
         lead leadRec1=leadUtil_Test.insertLead('testMetr@hamelane.com','8989442949');
         leadRec1.PostalCode='561284';
         leadRec1.status='Fresh Lead';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.LeadSource = 'Test Source';
         insert leadRec1;
        //leadUtil_Test.insertLeadData('@abtest.com', 'testMetr@hamelane.com');
        UpdateLeadMeetings.strBody = '{"customeremail": "testMetr@hamelane.com","DPName": "Design Partner Test","DPemail": "TestDesighP@abtest.com","Meetingdateandtime": "2017-11-08 09:00:00","Status": "Appointment Fixed","Sub-status": "","showroomvenue":"Gopalan Showroom"}';
        UpdateLeadMeetings.UpdateLeadMeetings();
    }
    static testMethod void testUpdateLeadMeetingsMethod(){
       UpdateLeadMeetings.strBody = '{"customeremail": "testMet1@hamelane.com","DPName": "Design Partner Test","DPemail": "TestDesighP@abtest.com","Meetingdateandtime": "2017-11-08 09:00:00","Status": "Appointment Fixed","Sub-status": "","showroomvenue":"Gopalan Showroom"}';
        UpdateLeadMeetings.UpdateLeadMeetings();
    }
    static testMethod void testUpdateLeadMeetingsMethod2(){
        //leadUtil_Test.insertLeadData('@abtestl.com', 'testMet@hamelane.com');
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        User wta_user=leadUtil_Test.inserUser('tetWta1@gmail.com','TesWT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        User agent_user=leadUtil_Test.inserUser('tesSP1@gmail.com','TeSSP1',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('tstP1@gmail.com','TesSP1',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('tesDP1@gmail.com','TesDP1',ac.Id,profileData.get('Design Partner Profile')); 
        insert dp_prof;
         Interior_Designer__c objIDP = new Interior_Designer__c();
        objIDP.Name = 'testData';
        objIDP.Email__c = 'TestDesighP@abtest.com';
        objIDP.User_Name__c = dp_prof.Id;
        insert objIDP;
         //insert new lead record 
          Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Mumbai';
        insert objRA;        
         lead leadRec1=leadUtil_Test.insertLead('testMet@hamelane.com','8981442949');
         leadRec1.PostalCode='561284';
         leadRec1.status='Fresh Lead';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.LeadSource = 'Test Source';
         insert leadRec1;
        UpdateLeadMeetings.strBody = '{"customeremail": "testMet@hamelane.com","DPName": "Design Partner Test","DPemail": "TestDesighP@abtest.com","Meetingdateandtime": "2017-11-08 09:00:00","Status": "Appointment Fixed","Sub-status": "","showroomvenue":"Gopalan Showroom"}';
        UpdateLeadMeetings.UpdateLeadMeetings();
    }
    static testMethod void testUpdateLeadMeetingsMethodNoDP(){
        //leadUtil_Test.insertLeadData('@ab3test.com', 'testMetdp@hamelane.com');
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        User wta_user=leadUtil_Test.inserUser('tetWta1@gmail.com','TesWT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        User agent_user=leadUtil_Test.inserUser('tesSP1@gmail.com','TeSSP1',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('tstP1@gmail.com','TesSP1',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('tesDP1@gmail.com','TesDP1',ac.Id,profileData.get('Design Partner Profile')); 
        insert dp_prof;
         Interior_Designer__c objIDP = new Interior_Designer__c();
        objIDP.Name = 'testData';
        objIDP.Email__c = 'TestDesiP@ab3test.com';
        objIDP.User_Name__c = dp_prof.Id;
        insert objIDP;
         //insert new lead record 
          Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Mumbai';
        insert objRA;        
         lead leadRec1=leadUtil_Test.insertLead('testMetdp@hamelane.com','8989442949');
         leadRec1.PostalCode='561284';
         leadRec1.status='Fresh Lead';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.LeadSource = 'Test Source';
         insert leadRec1;
        UpdateLeadMeetings.strBody = '{"customeremail": "testMetdp@hamelane.com","DPName": "Design Partner Test","DPemail": "TestDesiP@ab3test.com","Meetingdateandtime": "2017-11-08 09:00:00","Status": "Appointment Fixed","Sub-status": "","showroomvenue":"Gopalan Showroom","priority_lead":"Yes","priority_type":"Requested Callback"}';
        UpdateLeadMeetings.UpdateLeadMeetings();
    }
     static testMethod void testUpdateLeadMeetingsMethodESTValue(){
          Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        User wta_user=leadUtil_Test.inserUser('tetWta1@gmail.com','TesWT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        User agent_user=leadUtil_Test.inserUser('tesSP1@gmail.com','TeSSP1',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('tstP1@gmail.com','TesSP1',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('tesDP1@gmail.com','TesDP1',ac.Id,profileData.get('Design Partner Profile')); 
        insert dp_prof;
         Interior_Designer__c objIDP = new Interior_Designer__c();
        objIDP.Name = 'testData';
        objIDP.Email__c = 'TestDesighP@abtest.com';
        objIDP.User_Name__c = dp_prof.Id;
        insert objIDP;
         //insert new lead record 
          Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Mumbai';
        insert objRA;        
         lead leadRec1=leadUtil_Test.insertLead('testMetest@hamelane.com','8989442949');
         leadRec1.PostalCode='561284';
         leadRec1.status='Fresh Lead';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.LeadSource = 'Test Source';
         insert leadRec1;
        //leadUtil_Test.insertLeadData('@abestest.com', 'testMetest@hamelane.com');
        UpdateLeadMeetings.strBody = '{"customeremail": "testMetest@hamelane.com","estimate_value": 32000}';
        UpdateLeadMeetings.UpdateLeadMeetings();
    }
}