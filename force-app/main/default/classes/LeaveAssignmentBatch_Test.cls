@isTest
public class LeaveAssignmentBatch_Test {
    Public static testMethod void testLeadTrigger1(){ 
        Map<String,Id> profileData = new Map<String,Id>();
        RR_Deactivate_Time__c objRR = new RR_Deactivate_Time__c();
        objRR.Name = 'Daily Time';
        objRR.Reporting_Time__c = 9.0;
        objRR.Pattern__c = '9,10,11';
        objRR.Deactivation_Time__c = Date.today().addDays(-1);
        objRR.Error_Email_Address__c = 'Test@gmail.com,test2@gmail.com';
        insert objRR;
        Queue_Custom_Setting__c objQueue = new Queue_Custom_Setting__c();
        objQueue.Queue_Count__c = '';
        objQueue.Name= 'Lead Queue';
        
        Insert objQueue;
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        User wta_user=leadUtil_Test.inserUser('tetWta1@gmail.com','TesWT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        User wta_user1=leadUtil_Test.inserUser('tetWta2@gmail.com','TesWT2','',profileData.get('WTA Profile')); 
        insert wta_user1;
        User wta_user2=leadUtil_Test.inserUser('tetWta3@gmail.com','TesWT2','',profileData.get('WTA Profile')); 
        insert wta_user2;
        User agent_user=leadUtil_Test.inserUser('tesSP1@gmail.com','TeSSP1',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('tstP1@gmail.com','TesSP1',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('tesDP1@gmail.com','TesDP1',ac.Id,profileData.get('Design Partner Profile')); 
          insert dp_prof;
          
          
        //assign users in round robin manner to leads
        Group grp=new group();
        grp.Name='BangaloreTeam';
        grp.Type='Queue';
        insert grp;
        
        System.runAs(new User(Id = UserInfo.getUserId())) {   
            QueueSobject testQueue = new QueueSObject(QueueId = grp.Id, SobjectType = 'Lead');
            insert testQueue;
        }
      
            
        Round_Robin__c roundRobin=new Round_Robin__c(Name='BangaloreTeam',Queue_Name__c='BangaloreTeam',Total_Leads__c=45);
        insert roundRobin;
        List<Agent_Roster__c> listLeaveUser = new List<Agent_Roster__c>();
        Agent_Roster__c objLH = new Agent_Roster__c();
            objLH.Apply_Date__c = System.Today();
            objLH.Login_Active_Status__c = true;
            objLH.Round_Robin__c = roundRobin.Id;
            objLH.Reporting_Time__c = '9:00 AM';
            objLH.User__c = wta_user.Id; 
            listLeaveUser.add(objLH);
            
        Agent_Roster__c objLH1 = new Agent_Roster__c();
            objLH1.Apply_Date__c = System.Today();
            objLH1.Login_Active_Status__c = true;
            objLH1.Round_Robin__c = roundRobin.Id;
            objLH1.Reporting_Time__c = '9:00 AM';
            objLH1.User__c = wta_user1.Id; 
            listLeaveUser.add(objLH1);
        Agent_Roster__c objLH2 = new Agent_Roster__c();
            objLH2.Apply_Date__c = System.Today();
            objLH2.Login_Active_Status__c = false;
            objLH2.Round_Robin__c = roundRobin.Id;
            objLH2.Reporting_Time__c = '9:00 AM';
            objLH2.User__c = wta_user2.Id; 
            listLeaveUser.add(objLH2);              
           Insert listLeaveUser;
           
        Lead_Assignment__c leadAssign=new Lead_Assignment__c(Name='tetWta1@gmail.com',Round_Robin__c=roundRobin.id,User__c=wta_user.Id,Assign_Percent__c=0,Number_of_Leads__c=0);
        insert leadAssign;
        
        Lead_Assignment__c leadAssign1=new Lead_Assignment__c(Name='tetWta2@gmail.com',Round_Robin__c=roundRobin.id,User__c=wta_user1.Id,Assign_Percent__c=0,Number_of_Leads__c=0);
        insert leadAssign1;
        
        Lead_Assignment__c leadAssign2=new Lead_Assignment__c(Name='tetWta3@gmail.com',Round_Robin__c=roundRobin.id,User__c=wta_user2.Id,Assign_Percent__c=0,Number_of_Leads__c=0);
        insert leadAssign2;
        
        lead leadRec1=leadUtil_Test.insertLead('parinitha@gmail.com','7845111201');
         leadRec1.PostalCode='561284';
         leadRec1.status='Fresh Lead';
         leadRec1.City='Bengaluru';
         leadRec1.LeadSource = 'Website';
         insert leadRec1;
         lead leadRec2=leadUtil_Test.insertLead('parinitha2@gmail.com','7845111202');
         leadRec2.PostalCode='561284';
         leadRec2.status='Fresh Lead';
         leadRec2.City='Bengaluru';
         leadRec2.LeadSource = 'Website';
         insert leadRec2;
         lead leadRec3=leadUtil_Test.insertLead('parinitha3@gmail.com','7845111203');
         leadRec3.PostalCode='561284';
         leadRec3.status='Fresh Lead';
         leadRec3.City='Bengaluru';
        leadRec3.LeadSource = 'Website';
         insert leadRec3;
         lead leadRec4=leadUtil_Test.insertLead('parinitha4@gmail.com','7845111204');
         leadRec4.PostalCode='561284';
         leadRec4.status='Fresh Lead';
        leadRec4.LeadSource = 'Website';
         leadRec4.City='Bengaluru';
         insert leadRec4;
         
         Test.StartTest();
           Database.executeBatch(new LeaveAssignmentBatch());
         
         Test.StopTest();
    }
    
    Public static testMethod void testLeadTrigger2(){ 
        
         
         Test.StartTest();
           Database.executeBatch(new LeaveAssignmentBatch());
         
         Test.StopTest();
    }
}