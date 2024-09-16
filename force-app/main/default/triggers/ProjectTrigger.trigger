trigger ProjectTrigger on Project_Name__c (before insert,after insert, before update,after update) {
    system.debug('Trigger call');
    
    if(Trigger.isAfter && Trigger.IsInsert){
       //system.debug('Trigger insert');
       ProjectTriggerHandler.updateApprovedProjectOnUser(Trigger.new);
       ProjectTriggerHandler.updateprojectid(Trigger.new);
       
    }
    

}