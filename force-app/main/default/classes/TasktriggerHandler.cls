public class TasktriggerHandler{

    /****************************************************************************************************/
    // To count number of sub-task type records based on insert and update which is used for project planner
    
    public static void CountNoOfTaskOnInsert(list<task__c> taskList){
        Map<Id,Integer> countSubTaskOnTask=new Map<Id,Integer>();
        for(task__c task:taskList){
            if(task.task__c != null) {
                if(!countSubTaskOnTask.containsKey(task.task__c )) {
                        countSubTaskOnTask.put(task.task__c , 1);
                 }else {
                        countSubTaskOnTask.put(task.task__c , countSubTaskOnTask.get(task.task__c)+1);
                }
             }
        }
        //system.debug('countSubMileStone='+countSubMileStone);
        List<task__c> taslist = new List<task__c>();
        
        for(task__c tasks: [SELECT Id, total_No_Of_task_Records__c FROM task__c WHERE Id IN : countSubTaskOnTask.keySet()] ) {
           if(tasks.total_No_Of_task_Records__c>=1){
                tasks.total_No_Of_task_Records__c += countSubTaskOnTask.get(tasks.Id);
           }else{
                tasks.total_No_Of_task_Records__c = countSubTaskOnTask.get(tasks.Id);
           }
            taslist.add(tasks);
        }
        
        if(!taslist.isEmpty())
        update taslist;
        
    } 
    /***************************************************************************************/
    
    
    /**************************************************************************************************************************/
    // To count or to decrease the number of sub-task type records based on after delete event which is used for project planner
    
    
    public static void CountNoOfTaskOnDelete(list<task__c> taskList){
        Map<Id,Integer> countSubTaskOnTask=new Map<Id,Integer>();
        for(task__c task:taskList){
            if(task.task__c != null) {
                if(!countSubTaskOnTask.containsKey(task.task__c)) {
                        countSubTaskOnTask.put(task.task__c , 1);
                 }else {
                        countSubTaskOnTask.put(task.task__c , countSubTaskOnTask.get(task.task__c)-1);
                }
             }
        }
        //system.debug('countSubMileStone='+countSubMileStone);
        List<task__c> taslist= new List<task__c>();
        
        for(task__c tasks: [SELECT Id, total_No_Of_task_Records__c FROM task__c WHERE Id IN : countSubTaskOnTask.keySet()] ) {
           if(tasks.total_No_Of_task_Records__c>=1){
                tasks.total_No_Of_task_Records__c -= countSubTaskOnTask.get(tasks.Id);
           }//else{
              //  tasks.total_No_Of_task_Records__c = countSubTaskOnTask.get(tasks.Id);
         //  }
            taslist.add(tasks);
        }
        if(!taslist.isEmpty())
        update taslist;
    } 
    
    /*************************************************************************************************************************/
    
    
    /*************************************************************************************************************************/
    // To count number of sub-milestone type records based on insert and update which is used for project planner
    
    public static void updateParentMileStone(list<task__c> listTask){
   
        Map<Id,Integer> countSubMileStone=new Map<Id,Integer>();
        for(task__c mStone:listTask){
            if(mStone.Milestone__c != null) {
                if(!countSubMileStone.containsKey(mStone.Milestone__c)) {
                        countSubMileStone.put(mStone.Milestone__c , 1);
                }  else {
                        countSubMileStone.put(mStone.Milestone__c , countSubMileStone.get(mStone.Milestone__c)+1);
                }
            }
        }
        system.debug('*************'+countSubMileStone);
         List<Milestone__c> mileStonelist = new List<Milestone__c>();
        
        for(Milestone__c milStones: [SELECT Id, Total_No_Of_Tasks_Under_Sub_Milestone__c ,(SELECT Id from Tasks) FROM Milestone__c WHERE Id IN : countSubMileStone.keySet()] ) {
           if(milStones.Total_No_Of_Tasks_Under_Sub_Milestone__c>=1){
                milStones.Total_No_Of_Tasks_Under_Sub_Milestone__c += countSubMileStone.get(milStones.Id);
           }else{
                milStones.Total_No_Of_Tasks_Under_Sub_Milestone__c = countSubMileStone.get(milStones.Id);
           }
            mileStonelist.add(milStones);
        }
        if(!mileStonelist.isEmpty())
        update mileStonelist;
    }
    /********************************************************************************************************************/
    
    /**************************************************************************************************************************/
    // To count or to decrease the number of sub-milestone type records based on after delete event which is used for project planner
    
    public static void decreaseCountInParentMileStone(list<task__c> taskList){
        Map<Id,Integer> countSubMileStone=new Map<Id,Integer>();
        for(task__c mStone:taskList){
            if(mStone.Milestone__c != null ) {
                if(!countSubMileStone.containsKey(mStone.Milestone__c )) {
                    countSubMileStone.put(mStone.Milestone__c , 1);
                } else {
                    countSubMileStone.put(mStone.Milestone__c , countSubMileStone.get(mStone.Milestone__c)-1);
                }
            }
        }
        
        system.debug('countSubMileStone='+countSubMileStone);
        List<Milestone__c> mileStonelist = new List<Milestone__c>();
        
        for(Milestone__c milStones: [SELECT Id, Total_No_Of_Tasks_Under_Sub_Milestone__c FROM Milestone__c WHERE Id IN : countSubMileStone.keySet()] ) {
            if(milStones.Total_No_Of_Tasks_Under_Sub_Milestone__c>=1){
            milStones.Total_No_Of_Tasks_Under_Sub_Milestone__c -= countSubMileStone.get(milStones.Id );
            }
            mileStonelist.add(milStones);
        }
        if(!mileStonelist.isEmpty())
        update mileStonelist;
    }
    /**************************************************************************************************************************/
}