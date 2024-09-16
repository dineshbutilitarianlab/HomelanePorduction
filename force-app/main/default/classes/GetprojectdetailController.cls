public with sharing class GetprojectdetailController {
    
    //variables for project Details to display
    public static Map<Template_Items__c, List<Template_Items__c>> milestoneToSubMilestoneItemsMap;
    public static Map<Template_Items__c, List<Template_Items__c>> taskToSubTaskItemsMap;
    public static Map<Template_Items__c, List<Template_Items__c>> subMilestoneToTaskItemsMap;
    Public static Map<Id, Milestone__c> templateItemIdToMileStoneMap;
    Public Static Map<Id, Template_Items__c> milestoneIdToMilestoneItemsMap;
    Public static Map<Id, List<Template_Items__c>> milestoneIdToSubMilestoneItemsMap;
    Public static Map<Id, Template_Items__c> subMilestoneIdTosubMilestoneItemsMap;
    Public static Map<Id, List<Template_Items__c>> subMilestoneIdToTaskItemsMap;
    Public static Map<Id, Template_Items__c> taskIdToTaskItemsMap;
    Public static Map<Id, List<Template_Items__c>> taskIdToSubTaskItemsMap;
    Public static Map<Id, Template_Items__c> subTaskIdTosubTaskItemsMap;
    Public static Map<Id, List<Milestone__c>> templateItemIdToSubMileStonesMap;
    Public static Map<Id, Task__c> templateItemIdToTaskMap;
    Public static Map<Id, List<Task__c>> templateItemIdToSubTasksMap;
    Public static Project_Name__c projectObj;
    
    
    
    //variables for project records to display
    public static Map<id,List<Task__c>>mapActivty_SubStageId;
    public static Map<id,List<Task__c>>mapSubActivity_ActivityId;
    public static Map<id,List<Milestone__c>>mapStage_StageId;
    public static map<id,List<Milestone__c>>mapSubStage_StageId;
    
    
    
    
    
    
    
    @AuraEnabled 
    Public static void initializeVar(){
       
        //variables for project Details to display
        milestoneToSubMilestoneItemsMap = new Map<Template_Items__c, List<Template_Items__c>>();
        taskToSubTaskItemsMap = new Map<Template_Items__c, List<Template_Items__c>>();
        subMilestoneToTaskItemsMap = new Map<Template_Items__c, List<Template_Items__c>>();
        templateItemIdToMileStoneMap = new Map<Id, Milestone__c>();
        milestoneIdToMilestoneItemsMap = new Map<Id, Template_Items__c>(); 
        milestoneIdToSubMilestoneItemsMap = new Map<Id, List<Template_Items__c>>();
        subMilestoneIdTosubMilestoneItemsMap = new Map<Id, Template_Items__c>();
        subMilestoneIdToTaskItemsMap = new Map<Id, List<Template_Items__c>>();
        taskIdToTaskItemsMap = new Map<Id, Template_Items__c>();
        taskIdToSubTaskItemsMap = new Map<Id, List<Template_Items__c>>(); 
        subTaskIdTosubTaskItemsMap = new Map<Id, Template_Items__c>();
        templateItemIdToSubMileStonesMap = new Map<Id, List<Milestone__c>>();
        templateItemIdToTaskMap = new Map<Id, Task__c>();
        templateItemIdToSubTasksMap = new Map<Id, List<Task__c>>();
        
        
        
        
        //variables for project records to display
        mapActivty_SubStageId =new Map<id,List<Task__c>>();
        mapSubActivity_ActivityId= new Map<id,List<Task__c>>();
        mapStage_StageId= new map<id,List<Milestone__c>>();
        mapSubStage_StageId= new map<id,List<Milestone__c>>();
        
        
        
        
        
        
        
        
        
        
        
    }
    
    @AuraEnabled
    public static list<Project_Name__c> getDetails(){
    
        return[SELECT id,name,Start_Date__c,Opportunity_Project__r.Name from Project_Name__c];
    }
    
    @AuraEnabled
    public static List<Template__c> getTemplates(){
        
       return [SELECT Id, Name FROM Template__c WHERE Active__c = true Order By CreatedDate Desc ];
    }
    
    @AuraEnabled 
    Public static Project_Name__c saveProject(Project_Name__c projectrec, String strSelectedTemplate){
    system.debug('function strat');
        
        try{
            insert projectrec;
            projectObj = projectrec;
        }catch(Exception e){
        }
        system.debug('projectrec ID-------->>>>>>>>>'+projectrec.id);
        createProjectwithmilestone(strSelectedTemplate);
        return projectrec;
    }
    @AuraEnabled 
    Public static void createProjectwithmilestone(string strSelectedTemplate){
        initializeVar();
        
        milestoneToSubMilestoneItems(strSelectedTemplate);
        subMilestoneToTaskItems(strSelectedTemplate);
        taskToSubTaskItems(strSelectedTemplate);
        subTaskItems(strSelectedTemplate);
        createMileAndSubMileStone(milestoneToSubMilestoneItemsMap);
        createTaskToSubTask(taskToSubTaskItemsMap);
        createSubMilestoneToTask(subMilestoneToTaskItemsMap);
    }
    @AuraEnabled
    Public static void milestoneToSubMilestoneItems(String strSelectedTemplate) {
    system.debug('success class'+strSelectedTemplate);
    
        if(strSelectedTemplate!= null){
        system.debug('templateItem//');
            for(Template_Items__c templateItem :[Select Id , Name, Complexity__c,OpportunityStatus__c , Item_Type__c, Lead_Time__c, Position__c, Sr_No__c, Title__c,  
                                                    (Select Id , Name, Complexity__c,OpportunityStatus__c , Item_Type__c, Lead_Time__c, Position__c, Sr_No__c, Title__c FROM Project_Items__r)
                                                    FROM Template_Items__c WHERE Template__r.Name = :strSelectedTemplate AND Item_Type__c = 'Milestone' Order By Position__c ASC]){
                system.debug('templateItem//////////');
                milestoneIdToMilestoneItemsMap.put(templateItem.Id, templateItem);
                milestoneIdToSubMilestoneItemsMap.put(templateItem.Id, templateItem.Project_Items__r);
                
                milestoneToSubMilestoneItemsMap.put(templateItem, templateItem.Project_Items__r);
            }
            system.debug('milestoneIdToSubMilestoneItemsMap>>>>>>>>>>>>>>>>>>'+milestoneIdToSubMilestoneItemsMap);
        }   
    }
    
    @AuraEnabled
    public static void subMilestoneToTaskItems(String strSelectedTemplate) {
        if(strSelectedTemplate != null){
            for(Template_Items__c templateItem : [Select Id , Name,OpportunityStatus__c , Complexity__c, Item_Type__c, Lead_Time__c, Position__c, Sr_No__c, Title__c,  
                                                    (Select Id, Name, Complexity__c,OpportunityStatus__c , Item_Type__c, Lead_Time__c, Position__c, Sr_No__c, Title__c FROM Project_Items__r)
                                                    FROM Template_Items__c WHERE Template__r.Name = :strSelectedTemplate AND Item_Type__c = 'Sub-Milestone' Order By Position__c ASC]){
                
                subMilestoneIdTosubMilestoneItemsMap.put(templateItem.Id, templateItem);
                subMilestoneIdToTaskItemsMap.put(templateItem.Id, templateItem.Project_Items__r);
                subMilestoneToTaskItemsMap.put(templateItem, templateItem.Project_Items__r);
            } 
              
        }
    }
    
    @AuraEnabled
    Public static void taskToSubTaskItems(String strSelectedTemplate) {
        if(strSelectedTemplate != null){
            for(Template_Items__c templateItem : [Select Id, Name ,OpportunityStatus__c , Complexity__c, Item_Type__c, Lead_Time__c, Position__c, Sr_No__c, Title__c,  
                                                    (Select Id, Name , Complexity__c,OpportunityStatus__c , Item_Type__c, Lead_Time__c, Position__c, Sr_No__c, Title__c FROM Project_Items__r)
                                                    FROM Template_Items__c WHERE Template__r.Name = :strSelectedTemplate AND Item_Type__c = 'Task' Order By Position__c ASC]){
            
            
                taskIdToTaskItemsMap.put(templateItem.Id, templateItem);
                taskIdToSubTaskItemsMap.put(templateItem.Id, templateItem.Project_Items__r);
                taskToSubTaskItemsMap.put(templateItem, templateItem.Project_Items__r);
            }
            system.debug('//////taskToSubTaskItemsMap////////////'+taskToSubTaskItemsMap.values());
        }
    }
    
    @AuraEnabled
    Public static void subTaskItems(String strSelectedTemplate ) {
        if(strSelectedTemplate != null){
            for(Template_Items__c templateItem : [Select Id, Name , Complexity__c,OpportunityStatus__c , Item_Type__c, Lead_Time__c, Position__c, Sr_No__c, Title__c  
                                                    FROM Template_Items__c WHERE Template__c = :strSelectedTemplate AND Item_Type__c = 'Sub-Task' Order By Position__c ASC]){
            
            
                subTaskIdTosubTaskItemsMap.put(templateItem.Id, templateItem);
            }
        }
    }
    
    @AuraEnabled
    Public static void createMileAndSubMileStone(Map<Template_Items__c, List<Template_Items__c>> mileStoneToSubMileStoneItemsMapNew){
        List < Milestone__c > lsttaskparentid;
        List < Milestone__c > lsttaskparentidbed;
        List<Milestone__c> milestonesToInsert = new List<Milestone__c>();
        Map<Milestone__c, List<Milestone__c>> mileToSubMileStoneMap = new Map<Milestone__c, List<Milestone__c>>();
        //Map<Id, Map<Milestone__c, List<Milestone__c> > > templateItemIdToSubMileStoneMap = new Map<Id, Map<Milestone__c, List<Milestone__c> >>();
        List<Milestone__c> subMilestonesToInsert = new List<Milestone__c>();
        
        for(Template_Items__c templateItem :mileStoneToSubMileStoneItemsMapNew.keySet()){
        
            Milestone__c milestone = new Milestone__c();
            milestone.Project__c = projectObj.Id;
            milestone.Type__c = templateItem.Item_Type__c;
            milestone.Title__c = templateItem.Title__c;
            milestone.Position__c = templateItem.Position__c;
            milestone.Lead_Time__c = templateItem.Lead_Time__c;
            if(templateItem.OpportunityStatus__c != NULL){
            milestone.OpportunityStatus__c = templateItem.OpportunityStatus__c;
            }
            milestone.Sr_No__c = templateItem.Sr_No__c;
            milestone.Actual_Start_Date__c = projectObj.Start_Date__c;
            milestone.Actual_End_Date__c = projectObj.Start_Date__c.addDays(integer.valueof(templateItem.Lead_Time__c));
            milestonesToInsert.add(milestone);
            system.debug('milestonesToInsert>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+milestonesToInsert);
            templateItemIdToMileStoneMap.put(templateItem.Id, milestone);
            system.debug('templateItemIdToMileStoneMap>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+templateItemIdToMileStoneMap);
            
            List<Milestone__c> subMilestones = new List<Milestone__c>();
            
            system.debug('mileStoneIdToSubMileStoneItemsMap>>>>>>>>>>>>>>>>>>>>>>>>>>'+mileStoneIdToSubMileStoneItemsMap);
            for(Template_Items__c childTemplateItem :mileStoneIdToSubMileStoneItemsMap.get(templateItem.Id)){
                
                
                Milestone__c subMilestone = new Milestone__c();
                subMilestone.Project__c = projectObj.id;
                subMilestone.Type__c = childTemplateItem.Item_Type__c;
                subMilestone.Lead_Time__c = childTemplateItem.Lead_Time__c;
                //subMilestone.IsTask__c = childTemplateItem.IsTask__c;
                subMilestone.Sr_No__c = childTemplateItem.Sr_No__c;
                subMilestone.Title__c = childTemplateItem.Title__c;
                system.debug('childTemplateItem.OpportunityStatus__c--------------->'+childTemplateItem);
                if(childTemplateItem.OpportunityStatus__c != NULL){
                    subMilestone.OpportunityStatus__c = childTemplateItem.OpportunityStatus__c;
                    system.debug('childTemplateItem.OpportunityStatus__c--------------->'+childTemplateItem.OpportunityStatus__c);
                }
                subMilestone.Position__c = childTemplateItem.Position__c;
                subMilestone.Actual_Start_Date__c = milestone.Actual_End_Date__c.addDays(1);
                subMilestone.Actual_End_Date__c = subMilestone.Actual_Start_Date__c.addDays(integer.valueof(subMilestone.Lead_Time__c));
               
                subMilestones.add(subMilestone);
                system.debug('subMilestones>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+subMilestones);
                templateItemIdToMileStoneMap.put(childTemplateItem.Id, subMilestone);   
            }
            mileToSubMileStoneMap.put(milestone, subMilestones);
            templateItemIdToSubMileStonesMap.put(templateItem.Id, subMilestones);
        }
        
        try{
            insert milestonesToInsert;
        }catch(Exception e){}   
        System.debug('=======templateItemIdToMileStoneMap======'+templateItemIdToMileStoneMap);
        
        for(Template_Items__c templateItem :mileStoneToSubMileStoneItemsMapNew.keySet()){
            Milestone__c milestone = templateItemIdToMileStoneMap.get(templateItem.Id);
            for(Milestone__c subMilestone :templateItemIdToSubMileStonesMap.get(templateItem.Id)){
                subMilestone.Milestone__c = milestone.Id;
                subMilestonesToInsert.add(subMilestone);    
            }
        }
        
        try{
            insert subMilestonesToInsert;
        }catch(Exception e){}
        
         integer i = 0;
        for (Milestone__c subile: subMilestonesToInsert) {
            if (subile.Title__c == 'Kitchen,Utility & Store' && projectobj.Number_of_Kitchen__c != NULL) {
                for (i = 0; i < projectobj.Number_of_Kitchen__c; i++) {
                    Milestone__c milesto = subile.clone(false, true);
                    lsttaskparentid = new List < Milestone__c > ();
                    lsttaskparentid.add(milesto);
                    insert lsttaskparentid;

                }

            }


            if (subile.Title__c == 'Bedroom' && projectobj.Number_of_Bedroom__c != NULL) {
                for (i = 0; i < projectobj.Number_of_Bedroom__c; i++) {
                    Milestone__c milesto = subile.clone(false, true);
                    lsttaskparentidbed = new List < Milestone__c > ();
                    lsttaskparentidbed.add(milesto);
                    insert lsttaskparentidbed;
                }
            }
            
            if (subile.Title__c == 'Crockery Unit' && projectobj.Number_of_Crockery_Unit__c != NULL) {
                for (i = 0; i < projectobj.Number_of_Crockery_Unit__c; i++) {
                    Milestone__c milesto = subile.clone(false, true);
                    lsttaskparentidbed = new List < Milestone__c > ();
                    lsttaskparentidbed.add(milesto);
                    insert lsttaskparentidbed;
                }
            }
            
            
            if (subile.Title__c == 'Living' && projectobj.Number_of_Living_Room__c != NULL) {
                for (i = 0; i < projectobj.Number_of_Living_Room__c; i++) {
                    Milestone__c milesto = subile.clone(false, true);
                    lsttaskparentidbed = new List < Milestone__c > ();
                    lsttaskparentidbed.add(milesto);
                    insert lsttaskparentidbed;
                }
            }
            
            if (subile.Title__c == 'Foyer' && projectobj.Number_of_Foyer__c != NULL) {
                for (i = 0; i < projectobj.Number_of_Foyer__c; i++) {
                    Milestone__c milesto = subile.clone(false, true);
                    lsttaskparentidbed = new List < Milestone__c > ();
                    lsttaskparentidbed.add(milesto);
                    insert lsttaskparentidbed;
                }
            }
            
            
            
            
        }
        
        
        
    }
    
    @AuraEnabled 
       public static void createTaskToSubTask(Map<Template_Items__c, List<Template_Items__c>> taskToSubTaskItemsMapNew){
           
           system.debug('*********taskToSubTaskItemsMapNew****************'+taskToSubTaskItemsMapNew);
        List<Task__c> tasksToInsert = new List<Task__c>();
        Map<Task__c, List<Task__c>> taskToSubTasksMap = new Map<Task__c, List<Task__c>>();
        List<Task__c> subTasksToInsert = new List<Task__c>();
        
        system.debug('taskToSubTaskItemsMapNew.keySet()>>>>>>>>>>>>>>>>'+taskToSubTaskItemsMapNew);
        
        for(Template_Items__c templateItem :taskToSubTaskItemsMapNew.keySet()){
        system.debug('aaaaaddddddd-------------------');
            Task__c task = new Task__c();
            task.Project__c = projectobj.Id;
            task.Type__c = templateItem.Item_Type__c;
            task.Title__c = templateItem.Title__c;
            if(templateItem.OpportunityStatus__c != NULL){
                task.OpportunityStatus__c = templateItem.OpportunityStatus__c;
            }
            task.Position__c = templateItem.Position__c;
            task.Lead_Time__c = templateItem.Lead_Time__c;
            task.Sr_No__c = templateItem.Sr_No__c;
            tasksToInsert.add(task);
            system.debug('][[[[[[[[[[[task]]]]]]]]]]]]'+task);
            
            templateItemIdToTaskMap.put(templateItem.Id, task);
            
            system.debug('************taskIdToSubTaskItemsMap(templateItem.Id)***************'+taskIdToSubTaskItemsMap);
            
            //value not comming
            
            List<Task__c> subTasks = new List<Task__c>();
            for(Template_Items__c childTemplateItem :taskIdToSubTaskItemsMap.get(templateItem.Id)){
                
                Task__c subTask = new Task__c();
                subTask.Project__c = projectobj.Id;
                subTask.Type__c = childTemplateItem.Item_Type__c;
                subTask.Title__c = childTemplateItem.Title__c;
                subTask.Position__c = childTemplateItem.Position__c;
                subTask.Sr_No__c = childTemplateItem.Sr_No__c;
                if(childTemplateItem.OpportunityStatus__c != NULL){
                    subTask.OpportunityStatus__c = childTemplateItem.OpportunityStatus__c;
                }
                subTasks.add(subTask);
                templateItemIdToTaskMap.put(childTemplateItem.Id, subTask);
            }
            
            taskToSubTasksMap.put(task, subTasks);
            templateItemIdToSubTasksMap.put(templateItem.Id, subTasks); 
        }
        
        try{
            insert tasksToInsert;
        }catch(Exception e){}   
        
        for(Template_Items__c templateItem :taskToSubTaskItemsMapNew.keySet()){
            Task__c task = templateItemIdToTaskMap.get(templateItem.Id);
            for(Task__c subTask :templateItemIdToSubTasksMap.get(templateItem.Id)){
                subTask.Task__c = task.Id;
                subTasksToInsert.add(subTask);  
            }
        }
        
        try{
            insert subTasksToInsert;
        }catch(Exception e){}   
    }
    
    @AuraEnabled
     public static void createSubMilestoneToTask(Map<Template_Items__c, List<Template_Items__c>> subMilestoneToTaskItemsMapNew){
        List<Task__c> tasksToUpdate = new List<Task__c>();
        
        for(Template_Items__c templateItem :subMilestoneToTaskItemsMapNew.keySet()){
            Milestone__c subMilestone = templateItemIdToMileStoneMap.get(templateItem.Id);
            system.debug('----------subMilestone --------------'+subMilestone );
            
            List<Milestone__c> subMilestones = new List<Milestone__c>();

            for(Template_Items__c childTemplateItem :subMilestoneIdToTaskItemsMap.get(templateItem.Id)){
                
                system.debug('templateItemIdToTaskMap???????????????'+templateItemIdToTaskMap);
                
                Task__c task = templateItemIdToTaskMap.get(childTemplateItem.Id);
                system.debug('***********task *********************'+task );
                task.MileStone__c = subMilestone.Id;
                system.debug('*******subMilestone.Actual_End_Date__***********'+subMilestone.Actual_End_Date__c);
                task.Actual_Start_Date__c = subMilestone.Actual_End_Date__c.addDays(1);
                system.debug('*******task.Actual_Start_Date__c***********'+task.Actual_Start_Date__c);
                system.debug('***********task.Lead_Time__c*************'+task.Lead_Time__c);
                task.Actual_End_Date__c = task.Actual_Start_Date__c.addDays(integer.valueof(task.Lead_Time__c));
                
                tasksToUpdate.add(task);    
            }
        }
        
        try{
            update tasksToUpdate;
        }catch(Exception e){}
        
        if (tasksToUpdate.size() > 0) {
            Map < Id, Milestone__c > updatesubmilestonekitchen;
            Map < Id, Milestone__c > updatesubmilestonebedroom;
            Map < Id, Milestone__c > updatesubmilestoneCockryunit;
            Map < Id, Milestone__c > updatesubmilestoneLiving;
            Map < Id, Milestone__c > updatesubmilestoneFoyer;
            List < Task__c > lstUpdateCloneTask = new List < Task__c > ();

            updatesubmilestonekitchen = new map < id, MileStone__c > ([select id, createddate from MileStone__c where Title__c =: 'Kitchen,Utility & Store'
                AND Project__c =: projectobj.id
            ]);
            updatesubmilestonebedroom = new map < id, MileStone__c > ([select id from MileStone__c where Title__c =: 'Bedroom'
                AND Project__c =: projectobj.id
            ]);
            
            updatesubmilestoneCockryunit= new map < id, MileStone__c > ([select id from MileStone__c where Title__c =: 'Crockery Unit'
                AND Project__c =: projectobj.id
            ]);
            
            updatesubmilestoneLiving= new map < id, MileStone__c > ([select id from MileStone__c where Title__c =: 'Living'
                AND Project__c =: projectobj.id
            ]);
            
            
            updatesubmilestoneFoyer= new map < id, MileStone__c > ([select id from MileStone__c where Title__c =: 'Foyer'
                AND Project__c =: projectobj.id
            ]);

            for (Template_Items__c templateItem: subMilestoneToTaskItemsMap.keySet()) {
                Milestone__c subMilestone = templateItemIdToMileStoneMap.get(templateItem.Id);
                integer i = 0;
                for (MileStone__c key: updatesubmilestonekitchen.values()) {
                    for (Task__c task: tasksToUpdate) {
                        if (subMilestone.Title__c == 'Kitchen,Utility & Store' && projectobj.Number_of_Kitchen__c != NULL) {
                            if (task.MileStone__c == subMilestone.id) {

                                Task__c task1 = task.clone(false, true);
                                task1.MileStone__c = key.id;
                                if (key.id != subMilestone.id)
                                    lstUpdateCloneTask.add(task1);
                            }
                        }
                    }
                }

                for (MileStone__c key: updatesubmilestonebedroom.values()) {
                    for (Task__c task: tasksToUpdate) {

                        if (subMilestone.Title__c == 'Bedroom' && projectobj.Number_of_Bedroom__c != NULL) {
                            if (task.MileStone__c == subMilestone.id) {
                                Task__c task1 = task.clone(false, true);
                                task1.MileStone__c = key.id;
                                if (key.id != subMilestone.id)
                                    lstUpdateCloneTask.add(task1);
                            }
                        }
                    }
                }
                
                
                 for (MileStone__c key: updatesubmilestoneCockryunit.values()) {
                    for (Task__c task: tasksToUpdate) {

                        if (subMilestone.Title__c == 'Crockery Unit' && projectobj.Number_of_Crockery_Unit__c!= NULL) {
                            if (task.MileStone__c == subMilestone.id) {
                                Task__c task1 = task.clone(false, true);
                                task1.MileStone__c = key.id;
                                if (key.id != subMilestone.id)
                                    lstUpdateCloneTask.add(task1);
                            }
                        }
                    }
                }
                
                 for (MileStone__c key: updatesubmilestoneLiving.values()) {
                    for (Task__c task: tasksToUpdate) {

                        if (subMilestone.Title__c == 'Living' && projectobj.Number_of_Living_Room__c!= NULL) {
                            if (task.MileStone__c == subMilestone.id) {
                                Task__c task1 = task.clone(false, true);
                                task1.MileStone__c = key.id;
                                if (key.id != subMilestone.id)
                                    lstUpdateCloneTask.add(task1);
                            }
                        }
                    }
                }
                
                 for (MileStone__c key: updatesubmilestoneFoyer.values()) {
                    for (Task__c task: tasksToUpdate) {

                        if (subMilestone.Title__c == 'Foyer' && projectobj.Number_of_Foyer__c!= NULL) {
                            if (task.MileStone__c == subMilestone.id) {
                                Task__c task1 = task.clone(false, true);
                                task1.MileStone__c = key.id;
                                if (key.id != subMilestone.id)
                                    lstUpdateCloneTask.add(task1);
                            }
                        }
                    }
                }
            }
            try {
                insert lstUpdateCloneTask;
            } catch (Exception e) {}
        }       
    }
    
    
 
    
   
    
    //getting milestone records
    @AuraEnabled
    public static List<Milestone__c> getProrec( String proid){
        system.debug('proid==============>'+proid);
        
        list<Milestone__c> milestonelist = new list<Milestone__c>();
        milestonelist =  [Select Id,Resource_Name__c,Comments__c,Status__c,Number_Of_Sub_MileStone_Records__c,Completion__c, Name,Actual_Start_Date__c,Actual_End_Date__c,Expected_End_Date__c,Expected_Start_Date__c, Sr_No__c, Position__c,Milestone__c.Type__c ,Milestone__c.Project__c,  Title__c,Milestone__c , Predecessor__c, Lead_Time__c, Complexity__c
                                   From Milestone__c where Project__c =:proid and Type__c='Milestone'
                                order by Position__c ASC ];
                                
        system.debug('milestonelist ==============>'+milestonelist );
        return milestonelist ;
    }
    
   
    //getting submilestone records
    @AuraEnabled
    public static List<Milestone__c> getSubmile( String submileid){
        system.debug('submileid==============>'+submileid);
        
        list<Milestone__c> submilestonelist = new list<Milestone__c>();
        submilestonelist =  [Select Id,Resource_Name__c,Comments__c,Number_Of_Sub_MileStone_Records__c,Total_No_Of_Tasks_Under_Sub_Milestone__c,Status__c,Completion__c, Name,Actual_Start_Date__c,Actual_End_Date__c,Expected_End_Date__c,Expected_Start_Date__c, Sr_No__c, Position__c,Milestone__c.Type__c ,Milestone__c.Project__c,  Title__c,Milestone__c.Milestone__c , Predecessor__c, Lead_Time__c, Complexity__c
                                   From Milestone__c where Milestone__c =:submileid and Type__c='Sub-Milestone'
                                order by Position__c ASC ];
        system.debug('submilestonelist ==============>'+submilestonelist );
        return submilestonelist ;
    }
    
    //getting task records
    @AuraEnabled
    public static List<Task__c> getTasks( String submilesid){
        system.debug('submilesid==============>'+submilesid);
        
        list<Task__c> taskslist = new list<Task__c>();
        taskslist = [Select Id,Resource_Name__c,Comments__c,Total_No_Of_Task_Records__c,Status__c,Completion__c,Task__c.Project__c, Name, Sr_No__c,Task__c.Milestone__c ,Actual_Start_Date__c,
        Actual_End_Date__c,Expected_End_Date__c,Expected_Start_Date__c, Position__c,Task__c.Type__c ,  Title__c,Task__c.Task__c ,
         Predecessor__c, Lead_Time__c, Complexity__c From Task__c where Milestone__c =:submilesid and Type__c = 'Task' order by Position__c ASC];
         
        system.debug('taskslist ==============>'+taskslist );
        return taskslist;
    }
    
    //getting subtasks records
    
    @AuraEnabled
    public static List<Task__c> getsubTasks( String taskiids){
        system.debug('taskiids==============>'+taskiids);
        
        list<Task__c> taskslist = new list<Task__c>();
        taskslist = [Select Id,Resource_Name__c,Comments__c,Total_No_Of_Task_Records__c,Status__c,Completion__c,Task__c.Project__c, Name, Sr_No__c,Task__c.Milestone__c ,Actual_Start_Date__c,
        Actual_End_Date__c,Expected_End_Date__c,Expected_Start_Date__c, Position__c,Task__c.Type__c ,  Title__c,Task__c.Task__c ,
         Predecessor__c, Lead_Time__c, Complexity__c From Task__c where Milestone__c =:taskiids and Type__c = 'Sub-Task' order by Position__c ASC];
         
        system.debug('taskslist ==============>'+taskslist );
        return taskslist;
    }
    @AuraEnabled
    public static List<Milestone__c> editmilestone( String prorecid){
    list<Milestone__c> editmile = new list<Milestone__c>();
    editmile = [Select Id,Status__c,Completion__c, Name,Actual_Start_Date__c,Actual_End_Date__c,Expected_End_Date__c,Expected_Start_Date__c, Sr_No__c, Position__c,Milestone__c.Type__c ,Milestone__c.Project__c,  Title__c,Milestone__c.Milestone__c , Predecessor__c, Lead_Time__c, Complexity__c
                                   From Milestone__c where id =:prorecid];
    return editmile;
    }
    
     @AuraEnabled
    public static List<Milestone__c> editsubmilestone( String prorecid){
    list<Milestone__c> editmile = new list<Milestone__c>();
    editmile = [Select Id,Status__c,Completion__c, Name,Actual_Start_Date__c,Actual_End_Date__c,Expected_End_Date__c,Expected_Start_Date__c, Sr_No__c, Position__c,Milestone__c.Type__c ,Milestone__c.Project__c,  Title__c,Milestone__c.Milestone__c , Predecessor__c, Lead_Time__c, Complexity__c
                                   From Milestone__c where id =:prorecid];
                                   
    
    return editmile;
    //submile
    
    
    }
    
     @AuraEnabled
     public static List<Milestone__c> savemilestonerec( Milestone__c  mileobj, list<Milestone__c> mileoldlist){
        date dToday=mileobj.Actual_Start_Date__c;
        date dTodayend=mileobj.Actual_End_Date__c;
        Datetime startdate=datetime.newInstance(dToday.year(), dToday.month(),dToday.day());
        Datetime enddate=datetime.newInstance(dTodayend.year(), dTodayend.month(),dTodayend.day());
        mileobj.Lead_Time__c = UtilityController.daysBetweenExcludingWeekends(startdate,enddate)+1;
      
         
         for(integer i=0 ;i< mileoldlist.size();i++ ){
           system.debug('kkkk'+mileoldlist[i]);
           if(mileoldlist[i].Id == mileobj.Id){
             mileoldlist.set(i, mileobj);
             }
         }
         system.debug('kkk------------k'+mileoldlist);
    system.debug('mileobj---------->'+mileobj);  
    update mileoldlist; 
    return mileoldlist;
    
    }
    
    
    //Save Task
     @AuraEnabled
     public static List<Task__c> savetaskrec( Task__c  tskobj, list<Task__c> tskoldlist){
         
            date dToday=tskobj.Actual_Start_Date__c;
            date dTodayend=tskobj.Actual_End_Date__c;
            
            Datetime startdate=datetime.newInstance(dToday.year(), dToday.month(),dToday.day());
            Datetime enddate=datetime.newInstance(dTodayend.year(), dTodayend.month(),dTodayend.day());
            tskobj.Lead_Time__c = UtilityController.daysBetweenExcludingWeekends(startdate,enddate)+1;
                        system.debug('updatedtskobj----------------------->'+tskobj);
     
     
         for(integer i=0 ;i< tskoldlist.size();i++ ){
           if(tskoldlist[i].Id == tskobj.Id){
             tskoldlist.set(i, tskobj);
             }
         }
         
         
                // list<UtilityController.fieldDefinition> fieldDefinitions =  new list<UtilityController.fieldDefinition> {

          // new UtilityController.fieldDefinition('SUM', 'Lead_Time__c', 'Lead_Time__c') 
        //};
        

            List<Task__c> projectItemsListTask=[Select Id,Milestone__c from Task__c where id=: tskobj.Id];
            id milestoneid=[Select Id,Milestone__c from Task__c  where id=: tskobj.Id ].Milestone__c;
            system.debug('milestoneid------>'+milestoneid);
            List<Milestone__c> projectItemsListparent = [Select Id,Milestone__c from Milestone__c where id=: milestoneid];    
           // UtilityController.rollUpLeadTime(fieldDefinitions, projectItemsListTask, 'Task__c','Milestone__c', 'Milestone__c', 'and Type__c =\'Task\'');
           // UtilityController.rollUpLeadTime(fieldDefinitions, projectItemsListparent , 'Milestone__c','Milestone__c', 'Milestone__c', 'and Type__c =\'Sub-Milestone\'');
         
         
         
         
         
         
         
         
         
         
         
         
         
         
    update tskoldlist; 
    return tskoldlist;
    
    }
    
  
     @AuraEnabled
     public static List<Milestone__c> savesubmilestonerec( Milestone__c  mileobj, list<Milestone__c> mileoldlist){
            date dToday=mileobj.Actual_Start_Date__c;
            date dTodayend=mileobj.Actual_End_Date__c;
            
            Datetime startdate=datetime.newInstance(dToday.year(), dToday.month(),dToday.day());
            Datetime enddate=datetime.newInstance(dTodayend.year(), dTodayend.month(),dTodayend.day());
            mileobj.Lead_Time__c = UtilityController.daysBetweenExcludingWeekends(startdate,enddate)+1;
           
         
         system.debug('updatedmileobj------------------------------>'+mileobj);
         
         for(integer i=0 ;i< mileoldlist.size();i++ ){
           system.debug('subkkkk'+mileoldlist[i]);
           if(mileoldlist[i].Id == mileobj.Id){
             mileoldlist.set(i, mileobj);
             }
         }
         update mileoldlist;    
         system.debug('subkkk------------k'+mileoldlist);
    
    
   // list<UtilityController.fieldDefinition> fieldDefinitions =  new list<UtilityController.fieldDefinition> {
       //    new UtilityController.fieldDefinition('SUM', 'Lead_Time__c', 'Lead_Time__c') 
      //  };
        
        List<Milestone__c> projectItemsList = [Select Id,Milestone__c,Type__c from Milestone__c where id=: mileobj.Id]; 
        // UtilityController.rollUpLeadTime(fieldDefinitions, projectItemsList , 'Milestone__c','Milestone__c', 'Milestone__c', 'and Type__c =\'Sub-Milestone\'');
     
     
    return mileoldlist;
    
    
    }
    
    @AuraEnabled
    public static List<String> getstatusval() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Milestone__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }       
        return options;
    }
    
    
    @AuraEnabled
    public static List<String> getstatusvaltsk() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }       
        return options;
    }
    
    
    
    @AuraEnabled
    public static List<Task__c> edittask( String tasksrecid){
    list<Task__c> edittask = new list<Task__c>();
    edittask = [Select Id,Status__c,Completion__c,Resource_Name__c,Comments__c,Task__c.Project__c, Name,Task__c.Milestone__c ,Actual_Start_Date__c,Actual_End_Date__c,Expected_End_Date__c,Expected_Start_Date__c,  Title__c,Task__c.Task__c , Lead_Time__c, Complexity__c
              From Task__c where id =:tasksrecid];
    return edittask;
    }
    
    
     @AuraEnabled
    public static void saveEditdata(list <Milestone__c> milelist , list<Milestone__c> submilelist , list<Task__c> taskslist) {
        
        system.debug('milelist---------------------------------------->'+milelist);
        system.debug('submilelist--------------------------------------->'+submilelist);
        system.debug('taskslist------------------------------------------>'+taskslist);
        if(!milelist.isEmpty()){
            update milelist;
        }
        if(!submilelist.isEmpty()){
            update submilelist;
        }
        if(!taskslist.isEmpty()){
            update taskslist;
        }
        
    }
    
     
}