@isTest
public class TasktriggerHandler_Test{
    static testMethod void countMilestone_TestMethod(){
        Test.startTest();
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Milestone__c mile = new Milestone__c();
        mile.Title__c= 'Production';
        mile.Expected_Start_Date__c = system.Today();
        mile.Expected_End_Date__c = system.Today()+2;
        mile.Lead_Time__c = 1;
        mile.Number_Of_Sub_MileStone_Records__c = 0;
        mile.Total_No_Of_Tasks_Under_Sub_Milestone__c =0;
        insert mile;
        
        Milestone__c mile1 = new Milestone__c();
        mile1.Title__c= 'Production';
        mile1.Expected_Start_Date__c = system.Today();
        mile1.Expected_End_Date__c = system.Today()+2;
        mile1.Lead_Time__c = 1;
        mile1.Number_Of_Sub_MileStone_Records__c = 0;
        mile1.Total_No_Of_Tasks_Under_Sub_Milestone__c =0;
        insert mile1;
        
        Milestone__c subMile1 = new Milestone__c();
        subMile1.Title__c= 'Production';
        subMile1.Milestone__c = mile.id;
        subMile1.Expected_Start_Date__c = system.Today();
        subMile1.Expected_End_Date__c = system.Today()+2;
        subMile1.Lead_Time__c = 1;
        submile1.Total_No_Of_Tasks_Under_Sub_Milestone__c =0;
        submile1.Number_Of_Sub_MileStone_Records__c = 0;
        insert subMile1;
        
        Milestone__c subMile2 = new Milestone__c();
        subMile2.Title__c= 'Production';
        subMile2.Milestone__c = mile.id;
        subMile2.Expected_Start_Date__c = system.Today();
        subMile2.Expected_End_Date__c = system.Today()+2;
        subMile2.Number_Of_Sub_MileStone_Records__c=0;
        submile2.Total_No_Of_Tasks_Under_Sub_Milestone__c =0;
        submile2.Number_Of_Sub_MileStone_Records__c = 0;
        subMile2.Lead_Time__c = 1;
        insert subMile2;
        
        Milestone__c subMile3 = new Milestone__c();
        subMile3.Title__c= 'Production';
        subMile3.Milestone__c = mile.id;
        subMile3.Expected_Start_Date__c = system.Today();
        subMile3.Expected_End_Date__c = system.Today()+2;
        subMile3.Lead_Time__c = 1;
        submile3.Total_No_Of_Tasks_Under_Sub_Milestone__c =0;
        submile3.Number_Of_Sub_MileStone_Records__c = 0;
        insert subMile3;
        
        delete subMile3;
        
        Task__c task = new Task__c();
        task.Milestone__c = subMile2.id;
        task.Title__c = 'Test';
        task.Type__c='Task';
    //    task.Total_No_Of_Task_Records__c=0;
        insert task;
        
        Task__c subtask = new Task__c();
        subtask.Title__c = 'Test';
        subtask.Task__c= task.id;
        subtask.Type__c='Sub-Task';
        subtask.Total_No_Of_Task_Records__c=0;
        insert subtask ;
        
         Task__c subtask1 = new Task__c();
        subtask1.Title__c = 'Test1';
        subtask1.Task__c= task.id;
        subtask1.Type__c='Sub-Task';
        subtask1.Total_No_Of_Task_Records__c=0;
        insert subtask1;
        
     /*   submile2.Total_No_Of_Tasks_Under_Sub_Milestone__c =1;
        update submile2;*/
        
        delete subTask1;
       // delete subTask;
        delete task;
       
        Test.stopTest();

        
    }
     
}