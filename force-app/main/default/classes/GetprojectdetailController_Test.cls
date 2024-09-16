@isTest
public class GetprojectdetailController_Test{
    static testMethod void getProjectDetails(){
        Test.startTest();
       
       SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Account personAcc=new Account(LastName='Anand',PersonEmail='Anand@gmail.com',phone='0801231541');
        insert personAcc;
        
        Opportunity opp=new Opportunity(Name='Vijay',AccountId=personAcc.Id,stageName='Initial Quote Sent',
                                        closeDate=system.today(),Amount=5000);
        insert opp;
        
        //template created as 'Project Planner'
        Template__c temp=new Template__c();
        temp.Name='Project Planner';
        temp.Active__c=true;
        insert temp;
        
        //milestone created for the template 'Project Planner'
        Template_Items__c tempItems=new Template_Items__c();
        tempItems.Template__c=temp.id;
        tempItems.Title__c='Installation';
        tempItems.Item_Type__c='Milestone';
        tempItems.Sr_No__c='PR-005';
        tempItems.active__c=true;
        tempItems.Position__c=1;
        tempItems.lead_time__c=3.0;
        tempItems.Actual_Start_Date__c=system.today();
        tempItems.Actual_End_Date__c=system.today()+2;
        tempItems.OpportunityStatus__c='Production & Procurement Complete';
        insert tempItems;
        
        //create template items of type sub-milestone to milestone
        Template_Items__c tempItem1=new Template_Items__c ();
        tempItem1.Template__c=temp.id;
        tempItem1.Title__c='Crockery Unit';
        tempItem1.Item_Type__c='Sub-Milestone';
        tempItem1.Sr_No__c='PR-006';
        tempItem1.Parent_Id__c=tempItems.id;
        tempItem1.active__c=true;
        tempItem1.Position__c=2;
        tempItem1.Lead_Time__c=5.0;
        tempItem1.Actual_Start_Date__c=system.today();
        tempItem1.Actual_End_Date__c=system.today()+2;
        tempItem1.OpportunityStatus__c='Production & Procurement Complete';
        insert tempItem1;
        
        Template_Items__c tempItem2=new Template_Items__c ();
        tempItem2.Template__c=temp.id;
        tempItem2.Title__c='Living';
        tempItem2.Item_Type__c='Sub-Milestone';
        tempItem2.Sr_No__c='PR-006';
        tempItem2.Parent_Id__c=tempItems.id;
        tempItem2.active__c=true;
        tempItem2.Position__c=2;
        tempItem2.Lead_Time__c=5.0;
        tempItem2.Actual_Start_Date__c=system.today();
        tempItem2.Actual_End_Date__c=system.today()+2;
        tempItem2.OpportunityStatus__c='Production & Procurement Complete';
        insert tempItem2;
        
        Template_Items__c tempItem3=new Template_Items__c ();
        tempItem3.Template__c=temp.id;
        tempItem3.Title__c='Foyer';
        tempItem3.Item_Type__c='Sub-Milestone';
        tempItem3.Sr_No__c='PR-006';
        tempItem3.Parent_Id__c=tempItems.id;
        tempItem3.active__c=true;
        tempItem3.Position__c=2;
        tempItem3.Lead_Time__c=5.0;
        tempItem3.Actual_Start_Date__c=system.today();
        tempItem3.Actual_End_Date__c=system.today()+2;
        tempItem3.OpportunityStatus__c='Production & Procurement Complete';
        insert tempItem3;
        
        Template_Items__c tempItem4=new Template_Items__c ();
        tempItem4.Template__c=temp.id;
        tempItem4.Title__c='Kitchen,Utility & Store';
        tempItem4.Item_Type__c='Sub-Milestone';
        tempItem4.Sr_No__c='PR-006';
        tempItem4.Parent_Id__c=tempItems.id;
        tempItem4.active__c=true;
        tempItem4.Position__c=2;
        tempItem4.Lead_Time__c=5.0;
        tempItem4.Actual_Start_Date__c=system.today();
        tempItem4.Actual_End_Date__c=system.today()+2;
        tempItem4.OpportunityStatus__c='Production & Procurement Complete';
        insert tempItem4;
        
        Template_Items__c tempItem=new Template_Items__c ();
        tempItem.Template__c=temp.id;
        tempItem.Title__c='Bedroom';
        tempItem.Item_Type__c='Sub-Milestone';
        tempItem.Sr_No__c='PR-006';
        tempItem.Parent_Id__c=tempItems.id;
        tempItem.active__c=true;
        tempItem.Position__c=1;
        tempItem.Lead_Time__c=3.0;
        tempItem.Actual_Start_Date__c=system.today();
        tempItem.Actual_End_Date__c=system.today()+2;
        tempItem.OpportunityStatus__c='Production & Procurement Complete';
        insert tempItem;
        
        Template_Items__c tempTaskItem=new Template_Items__c ();
        tempTaskItem.Template__c=temp.id;
        tempTaskItem.Title__c=' Assembly of cabinets';
        tempTaskItem.Item_Type__c='Task';
        tempTaskItem.Sr_No__c='PR-0071';
        tempTaskItem.Parent_Id__c=tempItem.id;
        tempTaskItem.active__c=true;
        tempTaskItem.Position__c=1;
        tempTaskItem.Lead_Time__c=4.0;
        tempTaskItem.Actual_Start_Date__c=system.today();
        tempTaskItem.Actual_End_Date__c=system.today()+2;
        tempTaskItem.OpportunityStatus__c='Production & Procurement Complete';
        insert tempTaskItem;
        
        Template_Items__c tempSubTaskItem=new Template_Items__c ();
        tempSubTaskItem.Template__c=temp.id;
        tempSubTaskItem.Title__c='Get project details items from controller';
        tempSubTaskItem.Item_Type__c='Sub-Task';
        tempSubTaskItem.Sr_No__c='PR-0071';
        tempSubTaskItem.Parent_Id__c=tempTaskItem.id;
        tempSubTaskItem.active__c=true;
        tempSubTaskItem.Position__c=1;
        tempSubTaskItem.Lead_Time__c=4.0;
        tempSubTaskItem.Actual_Start_Date__c=system.today();
        tempSubTaskItem.Actual_End_Date__c=system.today()+2;
        tempSubTaskItem.OpportunityStatus__c='Production & Procurement Complete';
        insert tempSubTaskItem;
        
        Template_Items__c tempTaskItem1=new Template_Items__c ();
        tempTaskItem1.Template__c=temp.id;
        tempTaskItem1.Title__c=' Assembly of cabinets';
        tempTaskItem1.Item_Type__c='Task';
        tempTaskItem1.Sr_No__c='PR-0071';
        tempTaskItem1.Parent_Id__c=tempItem4.id;
        tempTaskItem1.active__c=true;
        tempTaskItem1.Position__c=1;
        tempTaskItem1.Lead_Time__c=4.0;
        tempTaskItem1.Actual_Start_Date__c=system.today();
        tempTaskItem1.Actual_End_Date__c=system.today()+2;
        tempTaskItem1.OpportunityStatus__c='Production & Procurement Complete';
        insert tempTaskItem1;
        
        Template_Items__c tempSubTaskItem1=new Template_Items__c ();
        tempSubTaskItem1.Template__c=temp.id;
        tempSubTaskItem1.Title__c='Get project details items from controller';
        tempSubTaskItem1.Item_Type__c='Sub-Task';
        tempSubTaskItem1.Sr_No__c='PR-0071';
        tempSubTaskItem1.Parent_Id__c=tempTaskItem1.id;
        tempSubTaskItem1.active__c=true;
        tempSubTaskItem1.Position__c=1;
        tempSubTaskItem1.Lead_Time__c=4.0;
        tempSubTaskItem1.Actual_Start_Date__c=system.today();
        tempSubTaskItem1.Actual_End_Date__c=system.today()+2;
        tempSubTaskItem1.OpportunityStatus__c='Production & Procurement Complete';
        insert tempSubTaskItem1;
        
        Template_Items__c tempTaskItem2=new Template_Items__c ();
        tempTaskItem2.Template__c=temp.id;
        tempTaskItem2.Title__c=' Assembly of cabinets';
        tempTaskItem2.Item_Type__c='Task';
        tempTaskItem2.Sr_No__c='PR-0071';
        tempTaskItem2.Parent_Id__c=tempItem3.id;
        tempTaskItem2.active__c=true;
        tempTaskItem2.Position__c=1;
        tempTaskItem2.Lead_Time__c=4.0;
        tempTaskItem2.Actual_Start_Date__c=system.today();
        tempTaskItem2.Actual_End_Date__c=system.today()+2;
        tempTaskItem2.OpportunityStatus__c='Production & Procurement Complete';
        insert tempTaskItem2;
        
        Template_Items__c tempSubTaskItem2=new Template_Items__c ();
        tempSubTaskItem2.Template__c=temp.id;
        tempSubTaskItem2.Title__c='Get project details items from controller';
        tempSubTaskItem2.Item_Type__c='Sub-Task';
        tempSubTaskItem2.Sr_No__c='PR-0071';
        tempSubTaskItem2.Parent_Id__c=tempTaskItem2.id;
        tempSubTaskItem2.active__c=true;
        tempSubTaskItem2.Position__c=1;
        tempSubTaskItem2.Lead_Time__c=4.0;
        tempSubTaskItem2.Actual_Start_Date__c=system.today();
        tempSubTaskItem2.Actual_End_Date__c=system.today()+2;
        tempSubTaskItem2.OpportunityStatus__c='Production & Procurement Complete';
        insert tempSubTaskItem2;
        
        Template_Items__c tempTaskItem3=new Template_Items__c ();
        tempTaskItem3.Template__c=temp.id;
        tempTaskItem3.Title__c=' Assembly of cabinets';
        tempTaskItem3.Item_Type__c='Task';
        tempTaskItem3.Sr_No__c='PR-0071';
        tempTaskItem3.Parent_Id__c=tempItem2.id;
        tempTaskItem3.active__c=true;
        tempTaskItem3.Position__c=1;
        tempTaskItem3.Lead_Time__c=4.0;
        tempTaskItem3.Actual_Start_Date__c=system.today();
        tempTaskItem3.Actual_End_Date__c=system.today()+2;
        tempTaskItem3.OpportunityStatus__c='Production & Procurement Complete';
        insert tempTaskItem3;
        
        Template_Items__c tempSubTaskItem3=new Template_Items__c ();
        tempSubTaskItem3.Template__c=temp.id;
        tempSubTaskItem3.Title__c='Get project details items from controller';
        tempSubTaskItem3.Item_Type__c='Sub-Task';
        tempSubTaskItem3.Sr_No__c='PR-0071';
        tempSubTaskItem3.Parent_Id__c=tempTaskItem3.id;
        tempSubTaskItem3.active__c=true;
        tempSubTaskItem3.Position__c=1;
        tempSubTaskItem3.Lead_Time__c=4.0;
        tempSubTaskItem3.Actual_Start_Date__c=system.today();
        tempSubTaskItem3.Actual_End_Date__c=system.today()+2;
        tempSubTaskItem3.OpportunityStatus__c='Production & Procurement Complete';
        insert tempSubTaskItem3;
        
         Template_Items__c tempTaskItem4=new Template_Items__c ();
        tempTaskItem4.Template__c=temp.id;
        tempTaskItem4.Title__c=' Assembly of cabinets';
        tempTaskItem4.Item_Type__c='Task';
        tempTaskItem4.Sr_No__c='PR-0071';
        tempTaskItem4.Parent_Id__c=tempItem1.id;
        tempTaskItem4.active__c=true;
        tempTaskItem4.Position__c=1;
        tempTaskItem4.Lead_Time__c=4.0;
        tempTaskItem4.Actual_Start_Date__c=system.today();
        tempTaskItem4.Actual_End_Date__c=system.today()+2;
        tempTaskItem4.OpportunityStatus__c='Production & Procurement Complete';
        insert tempTaskItem4;
        
        Template_Items__c tempSubTaskItem4=new Template_Items__c ();
        tempSubTaskItem4.Template__c=temp.id;
        tempSubTaskItem4.Title__c='Get project details items from controller';
        tempSubTaskItem4.Item_Type__c='Sub-Task';
        tempSubTaskItem4.Sr_No__c='PR-0071';
        tempSubTaskItem4.Parent_Id__c=tempTaskItem4.id;
        tempSubTaskItem4.active__c=true;
        tempSubTaskItem4.Position__c=1;
        tempSubTaskItem4.Lead_Time__c=4.0;
        tempSubTaskItem4.Actual_Start_Date__c=system.today();
        tempSubTaskItem4.Actual_End_Date__c=system.today()+2;
        tempSubTaskItem4.OpportunityStatus__c='Production & Procurement Complete';
        insert tempSubTaskItem4;
        
        Project_Name__c projName=new Project_Name__c();
        projName.Name='Bhagmane Builders';
        projName.Start_Date__c=system.today();
        projName.Opportunity_Project__c=opp.id;
        projName.Number_of_Crockery_Unit__c=1;
        projName.Number_of_Kitchen__c=1;
        projName.Number_of_Bedroom__c=1;
        projName.Number_of_Living_Room__c=2;
        projName.Number_of_Foyer__c=3;
        insert projName;
        
        Milestone__c mile = new Milestone__c();
        mile.Title__c= 'Production';
        mile.Expected_Start_Date__c = system.Today();
        mile.Expected_End_Date__c = system.Today()+2;
        mile.Lead_Time__c = 1;
        mile.Type__c='MileStone';
        mile.Number_Of_Sub_MileStone_Records__c = 0;
        insert mile;
        
     /*   list<Milestone__c> listMile=new list<Milestone__c>();
        for(Integer i=0;i<5;i++){
            Milestone__c mileStone = new Milestone__c();
            mileStone.Title__c= 'Production'+i;
            mileStone.Expected_Start_Date__c = system.Today();
            mileStone.Expected_End_Date__c = system.Today()+2;
            mileStone.Lead_Time__c = 1;
            mileStone.Type__c='MileStone';
            mileStone.Number_Of_Sub_MileStone_Records__c = 0;
            listMile.add(mileStone);
        }
        if(!listMile.isEmpty())
            insert listMile;*/
            
        Milestone__c subMile = new Milestone__c();
        subMile.Title__c= 'Production';
        subMile.Expected_Start_Date__c = system.Today();
        subMile.Expected_End_Date__c = system.Today()+2;
        subMile.Lead_Time__c = 1;
        subMile.Type__c='Sub-MileStone';
        subMile.Milestone__c=mile.id;
        subMile.Number_Of_Sub_MileStone_Records__c = 0;
        insert subMile;
        
     /*   list<Milestone__c> listSubMile=new list<Milestone__c>();
        for(Integer i=0;i<5;i++){
            Milestone__c subMileStone = new Milestone__c();
            subMileStone.Title__c= 'Production'+i;
            subMileStone.Expected_Start_Date__c = system.Today();
            subMileStone.Expected_End_Date__c = system.Today()+2;
            subMileStone.Lead_Time__c = 1;
            subMileStone.Type__c='Sub-MileStone';
            subMileStone.Number_Of_Sub_MileStone_Records__c = 0;
            listSubMile.add(subMileStone);
        }
        if(!listSubMile.isEmpty())
            insert listSubMile;*/
            
     /*   Task__c task = new Task__c();
        task.Milestone__c = mile.id;
        task.Title__c = 'Test';
        task.Type__c='Task';
        insert task;
        
        list<Task__c> listsubtask = new list<Task__c>();
        for(Integer i=0;i<5;i++){
            Task__c subtask= new Task__c();
            subtask.Title__c = 'Test'+i;
            subtask.Task__c= task.id;
            subtask.Type__c='Task';
            subtask.Total_No_Of_Task_Records__c=0;
            listsubtask.add(subtask);
        }
        if(!listsubtask.isEmpty())
            insert listsubtask;*/
        
        GetprojectdetailController.getDetails();
        GetprojectdetailController.getTemplates();
        GetprojectdetailController.getProrec(projName.id);
        GetprojectdetailController.getSubmile(tempItems.id);
        GetprojectdetailController.getTasks(tempItem.id);
        GetprojectdetailController.getsubTasks(tempTaskItem.id);
        GetprojectdetailController.projectObj=projName;
        GetprojectdetailController.saveProject(projName,'Project Planner');
        GetprojectdetailController.edittask(tempTaskItem.id);
        GetprojectdetailController.getstatusvaltsk();
        GetprojectdetailController.getstatusval();
      /*  GetprojectdetailController.savesubmilestonerec(subMile,listSubMile);
        GetprojectdetailController.savemilestonerec(mile,listMile);
        GetprojectdetailController.savetaskrec(task,listsubtask);*/
        GetprojectdetailController.editmilestone(mile.id);
        GetprojectdetailController.editsubmilestone(subMile.id);
        
        Test.stopTest();
    }
}