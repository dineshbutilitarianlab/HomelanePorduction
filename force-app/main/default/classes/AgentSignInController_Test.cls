@isTest
public class AgentSignInController_Test {
    Public static testMethod void testAgentSignInControllerMethod1(){ 
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
        
        User wta_user=leadUtil_Test.inserUser('te1tWta1@gmail.com','TesWT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        User wta_user1=leadUtil_Test.inserUser('te1tWta2@mail.com','TesWT2','',profileData.get('WTA Profile')); 
        insert wta_user1;
        User wta_user2=leadUtil_Test.inserUser('te1tWta2@gmil.com','TesWT3','',profileData.get('WTA Profile')); 
        insert wta_user2;
          
          
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
            objLH1.Login_Active_Status__c = false;
            objLH1.Round_Robin__c = roundRobin.Id;
            objLH1.Reporting_Time__c = 'Leave';
            objLH1.User__c = wta_user1.Id; 
            listLeaveUser.add(objLH1);  
            
                        
           Insert listLeaveUser;
            
         
             Test.StartTest();
              System.runAs(wta_user) { 
               AgentSignInController objASC = new AgentSignInController();
               objASC.UpdateUserRoster();
               objASC.LogOutUser();
              }
               System.runAs(wta_user1) { 
               AgentSignInController objASC = new AgentSignInController();
               objASC.UpdateUserRoster();
               objASC.LogOutUser();
              }
              System.runAs(wta_user2) { 
               AgentSignInController objASC = new AgentSignInController();
               objASC.UpdateUserRoster();
               objASC.LogOutUser();
              }
             Test.StopTest();
         
    }
     
    
    
}