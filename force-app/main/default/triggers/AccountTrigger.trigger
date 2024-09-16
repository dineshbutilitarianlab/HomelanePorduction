trigger AccountTrigger on Account (After Update, before insert) {
    if(UserInfo.getName() != System.Label.DataLoad_User){
        if(Trigger.IsAfter && Trigger.IsUpdate){
            AccountTriggerHandler.afterUpdate(Trigger.NewMap,Trigger.OldMap);
            AccountTriggerHandler.updatePhone(Trigger.NewMap,Trigger.OldMap);
            AccountTriggerHandler.updateEmail(Trigger.NewMap,Trigger.OldMap);
            AccountTriggerHandler.updateOpportunityGSTinfo(Trigger.NewMap,Trigger.OldMap);
        }
        if(Trigger.isBefore && Trigger.isInsert){
            AccountTriggerHandler.beforeInsert(Trigger.new);
        }
     }   
}