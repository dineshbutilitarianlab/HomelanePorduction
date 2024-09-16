trigger CountATskonLead on Task (after delete, after insert, after undelete, after update) {
    
    
    if(UserInfo.getName() != System.Label.DataLoad_User){
    Set<ID> LeadIds = new Set<ID>();
    String leadPrefix = Lead.SObjectType.getDescribe().getKeyPrefix();
    
    
    if(trigger.new!=null){
        for (Task t : Trigger.new) {
            if (t.WhoId!= null && string.valueof(t.WhoId).startsWith(leadPrefix) /*&& t.subject =='Follow Up' */) {
                if(!LeadIds.contains(t.WhoId)){
                    LeadIds.add(t.WhoId);
                }
            }
        }
    }


    if(trigger.old!=null){
        for (Task t2 : Trigger.old) {
            if (t2.WhoId!= null && string.valueof(t2.WhoId).startsWith(leadPrefix) /*&& t2.subject =='Follow Up' */){
                if(!LeadIds.contains(t2.WhoId)){
                    LeadIds.add(t2.WhoId);
                }
            }
        }
    }
    
    if (LeadIds.size() > 0){
        List<Lead> leadsWithTasks = [select id,Activity_Count__c,(select id from Tasks WHERE subject ='Follow Up') from Lead where Id IN : Leadids];
        List<Lead> leadsUpdatable = new List<Lead>();
        for(Lead L : leadsWithTasks){
            L.Activity_Count__c = L.Tasks.size();
            leadsUpdatable.add(L);
        }
        if(leadsUpdatable.size()>0){
        
            update leadsUpdatable;
        
        }
        
    }
    
    if(trigger.isInsert && trigger.isAfter){
        //
        TaskTriggerHelper.calculateLeadMatrixAfterInsert(trigger.newMap);
        //
    }
    
    
    if(trigger.isUpdate && trigger.isAfter) {
    
        //
        TaskTriggerHelper.calculateLeadMatrix(trigger.newMap,trigger.oldMap);
        //
        ByPassValidation__c mc = ByPassValidation__c.getOrgDefaults();

        if(mc.IsTrue__c)
        {
            standerdTaskTriggerHandler.updateLeadData(trigger.newMap);
        }
    }
   }
}