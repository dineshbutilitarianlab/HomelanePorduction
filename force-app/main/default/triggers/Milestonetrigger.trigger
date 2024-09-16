trigger Milestonetrigger on Milestone__c(after update,after insert,after delete) {
    if (Trigger.isAfter && Trigger.isupdate) {
        system.debug('---------------->milestonestagenameforkitchen');
        UtilityController.updateDateonLeadTimeChange(Trigger.newmap, Trigger.oldmap);
        UtilityController.updateMilestoneDateFromSubMilestone(Trigger.newmap, Trigger.oldmap);
    }
    
    //added to count and decrease the number of sub-milestone type records based on after insert and after delete
     if(trigger.isInsert && trigger.isAfter){
        MilestoneTriggerHandler.increaseCountInParentMileStone(trigger.new);
     }
     if(trigger.isDelete && trigger.isAfter){
         MilestoneTriggerHandler.decreaseCountInParentMileStone(trigger.old);   
     }
}