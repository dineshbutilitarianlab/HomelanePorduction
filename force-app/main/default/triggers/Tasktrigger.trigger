trigger Tasktrigger on Task__c(after insert, after delete,after update) {
    if (Trigger.isAfter && Trigger.isupdate) {
        UtilityController.updateSubMilestoneDateFromTask(Trigger.newmap, Trigger.oldmap);
    }
    
    if((trigger.isInsert && trigger.isAfter) || (trigger.isUpdate && trigger.isAfter)){
        TasktriggerHandler.updateParentMileStone(trigger.new);
        TasktriggerHandler.CountNoOfTaskOnInsert(trigger.new);
        
    }
    if(trigger.isDelete && trigger.isAfter){
        TasktriggerHandler.CountNoOfTaskOnDelete(trigger.old);
        TasktriggerHandler.decreaseCountInParentMileStone(trigger.old);
    }
}