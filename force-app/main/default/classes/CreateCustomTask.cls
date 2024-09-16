public class CreateCustomTask {
  /*  public static void createCustom(List<Task> taskList) {
        Set<Id> leadId = new Set<Id>();
        List<Task_Custom__c> taskCustomInsert = new List<Task_Custom__c>();
        List<Task> taskIns = new List<Task>();
        
        for(Task t : taskList) {
            if(t.Subject.contains('UCID')) {
                if(String.isNotblank(t.WhoId)) {
                    leadId.add(t.WhoId);
                    taskIns.add(t);
                }
                else {
                    Logger.logWithPhone('CreateCustomTaskException','CreateCustomTask','CreateCustomTask','WHOID Not Present  '+t.Subject,NULL,NULL,NULL);
                }
            }
        }
        
        try {
            Map<Id,Lead> leadMap = new Map<Id,Lead>([select id, name, phone from Lead where id =: leadId and isConverted = false]);            
            
            if(!leadMap.isEmpty()) {
                for(Task t : taskIns) {
                    if(t.Subject.containsIgnoreCase('UCID')) {                        
                        Task_Custom__c tc = new Task_Custom__c();
                        tc.Name = t.Subject;
                        tc.Lead__c = leadMap.get(t.WhoId).Id;
                        taskCustomInsert.add(tc);                        
                    }
                }
            }
            
            if(!taskCustomInsert.isEMpty()) {
                insert taskCustomInsert;
            } 
        }
        catch(Exception e) {
            Logger.logWithPhone('CreateCustomTaskException','CreateCustomTask','CreateCustomTask',e.getMessage(),e.getStackTraceString(),NULL,NULL);
        }       
    }*/
    
    public static void insertTaskCustom(List<Task> taskList, Map<Id,Task> oldMap) {
        Set<Id> leadId = new Set<Id>();
        List<Task_Custom__c> taskCustomInsert = new List<Task_Custom__c>();
        List<Task> taskList1 = new List<Task>();
        
        for(Task t : taskList) {
            if(t.Subject.containsIgnoreCase('UCID')) {
                if(String.isNotblank(t.WhoId) && oldMap.get(t.Id).CallDisposition == null && oldMap.get(t.Id).CallDisposition != t.CallDisposition ) {
                    leadId.add(t.WhoId);
                    taskList1.add(t);
                }
                else if(String.isblank(t.WhoId) && oldMap.get(t.Id).CallDisposition == null && oldMap.get(t.Id).CallDisposition != t.CallDisposition) {
                    Logger.logWithPhone('CreateCustomTaskException','CreateCustomTask','insertTaskCustom','WHOID Not Present  '+t.Subject,NULL,NULL,NULL);
                }
            }
        }
        
        // if lead Id is not empty
        if(leadId != null && !leadId.isEmpty()) {
            try {
                Map<Id,Lead> leadMap = new Map<Id,Lead>([select id, name, phone from Lead where id =: leadId and isConverted = false]);            
                
                if(!leadMap.isEmpty()) {
                    for(Task t : taskList1) {
                        // Create custom Task
                        Task_Custom__c tc = new Task_Custom__c();
                        tc.Name = t.Subject;
                        tc.Lead__c = leadMap.get(t.WhoId).Id;
                        taskCustomInsert.add(tc);                                            
                    }
                }
                
                if(!taskCustomInsert.isEMpty()) {
                    insert taskCustomInsert;
                } 
            }
            catch(Exception e) {
                Logger.logWithPhone('CreateCustomTaskException','CreateCustomTask','insertTaskCustom',e.getMessage(),e.getStackTraceString(),NULL,NULL);
            } 
        }      
    }
}