@isTest
public class LeadAssignmentRemovalBatch_Test {
    Public static testMethod void testLeadAssignmentRemovalBatch1(){ 
        Map<String,Id> profileData = new Map<String,Id>();
        RR_Deactivate_Time__c objRR = new RR_Deactivate_Time__c();
        objRR.Name = 'Daily Time';
        objRR.Reporting_Time__c = 9.0;
        objRR.Pattern__c = '9,10,11';
        objRR.Deactivation_Time__c = Date.today().addDays(-1);
        objRR.Error_Email_Address__c = 'Test@gmail.com,test2@gmail.com';
        insert objRR;
        Queue_Custom_Setting__c objQueue = new Queue_Custom_Setting__c();
        objQueue.Queue_Setting__c = 'BLR:BangaloreTeam,CHN:ChennaiTeam,HYD:HyderabadTeam,MUM:MumbaiTeam,NCR:GurgaonTeam,NCR:NewDelhiTeam';
        objQueue.Queue_Count__c = '';
        objQueue.Name= 'Lead Queue';
        
        Insert objQueue;
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        User wta_user=leadUtil_Test.inserUser('tetta1@gmail.com','TesWT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        User wta_user1=leadUtil_Test.inserUser('tetta2@gmail.com','TesWT2','',profileData.get('WTA Profile')); 
        insert wta_user1;
        User wta_user2=leadUtil_Test.inserUser('tetta3@gmail.com','TesWT2','',profileData.get('WTA Profile')); 
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
        
           
        Lead_Assignment__c leadAssign=new Lead_Assignment__c(Name='tetWta1@gmail.com',Round_Robin__c=roundRobin.id,User__c=wta_user.Id,Assign_Percent__c=0,Number_of_Leads__c=0);
        insert leadAssign;
        
        Lead_Assignment__c leadAssign1=new Lead_Assignment__c(Name='tetWta2@gmail.com',Round_Robin__c=roundRobin.id,User__c=wta_user1.Id,Assign_Percent__c=0,Number_of_Leads__c=0);
        insert leadAssign1;
        
        Lead_Assignment__c leadAssign2=new Lead_Assignment__c(Name='tetWta3@gmail.com',Round_Robin__c=roundRobin.id,User__c=wta_user2.Id,Assign_Percent__c=0,Number_of_Leads__c=0);
        insert leadAssign2;
        
                 
         Test.StartTest();
           Database.executeBatch(new LeadAssignmentRemovalBatch ());
         
         Test.StopTest();
    }
}