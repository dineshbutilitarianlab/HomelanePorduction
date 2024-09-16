Public class TaskTriggerHelper{

    /*
    This Method is called after the task record is Updated.
    This Method Update the Lead records based on some values Present in task.
    */
    Public static void calculateLeadMatrix(Map<Id,Task> NewEventMap,Map<Id,Task> OldEventMap){
        try{
            Map<String,Task> mapSubjectandTask = new Map<String,Task>(); 
            Map<Id,Lead> mapLeadIdandLead = new Map<Id,Lead>(); 
            Set<Id> setLeadIdUpdates = new Set<Id>(); 
            List<Lead> lstToUpdate = new List<Lead>(); 
            List<Log__c> lstLogger = new List<Log__c>();
            
            for(Task objTask : NewEventMap.Values()){
                // Check if the Task Subject contains UCID in It
                if(objTask.Subject.containsIgnoreCase('UCID') && objTask.WhoId != null){
                    mapSubjectandTask.put(objTask.Subject,ObjTask);
                    setLeadIdUpdates.add(objTask.WhoId);
                }else{
                     //Logger.logWithPhone('TaskTriggerHelper NULL who ID','TaskTriggerHelper','calculateLeadMatrix',objTask.id,null,null,null);
                }
            }     
            
            System.debug('setLeadIdUpdates----->'+setLeadIdUpdates);     
            if(mapSubjectandTask != NULL){
                if(!setLeadIdUpdates.isEmpty()){
                    // Get the Lead Details
                    mapLeadIdandLead = new Map<Id,Lead>([Select Id,Name,First_Ameyo_Activity_Created_Time__c,First_Call_Response__c,First_Connected_Call_Time__c,Total_Connected_Calls__c,Ameyo_Call_Attempts__c,Total_Calls__c,Last_Attempted_Call_Time__c,
                                                          (Select id,Subject from tasks where subject Like'%UCID%') from lead where ID IN:setLeadIdUpdates]);
                    if(!mapLeadIdandLead.isEmpty()){
                        for(Task ObjTask : mapSubjectandTask.Values()){
                            if(mapLeadIdandLead.containsKey(ObjTask.whoId)){
                                Lead ObjLead = mapLeadIdandLead.get(ObjTask.whoId);
                                
                                System.debug('ObjLead----->'+ObjLead); 
                                
                                //First Call Response 
                               /* if(String.IsBlank(ObjLead.First_Call_Response__c) && String.IsNotBlank(ObjTask.Disposition_Type__c)){
                                    objLead.First_Call_Response__c = ObjTask.Disposition_Type__c;
                                }*/
                                
                                
                                //Total Calls
                                
                                system.debug('mapLeadIdandLead.get(ObjTask.whoId).tasks.size()'+mapLeadIdandLead.get(ObjTask.whoId).tasks.size());
                                
                                if(objLead.Total_Calls__c != mapLeadIdandLead.get(ObjTask.whoId).tasks.size()){
                                    objLead.Total_Calls__c = mapLeadIdandLead.get(ObjTask.whoId).tasks.size();
                                }
                                
                              /*  if(ObjTask.whoId != OldEventMap.get(ObjTask.Id).whoId && ObjTask.whoId != NULL ){
                                    if(objLead.Total_Calls__c== NULL){
                                        objLead.Total_Calls__c= 1;
                                    }else{
                                        objLead.Total_Calls__c= objLead.Total_Calls__c+ 1;
                                    }
                                }    */
                                
                                
                                
                               // First Attempted Call Time
                               if(ObjLead.First_Ameyo_Activity_Created_Time__c == NULL){
                                    ObjLead.First_Ameyo_Activity_Created_Time__c = ObjTask.Createddate;
                                }
                                
                                // Last Attempted Call Time
                                
                                if(objLead.Last_Attempted_Call_Time__c == NULL){
                                    objLead.Last_Attempted_Call_Time__c = ObjTask.Createddate;
                                }else if(objLead.Last_Attempted_Call_Time__c < ObjTask.Createddate){
                                    // If Last
                                    objLead.Last_Attempted_Call_Time__c = ObjTask.Createddate;
                                }else{
                                    // Do nothing 
                                }
                                
                                //First Connected Call Time
                                if(ObjLead.First_Connected_Call_Time__c == NULL && String.IsNotBlank(ObjTask.Status__c)){
                                    if(ObjTask.Status__c.containsIgnoreCase('success')){
                                        objLead.First_Connected_Call_Time__c = ObjTask.Createddate;

                                    }    
                                }
                                                                                                      
                                //Total Connected Calls
                                if(String.IsNotBlank(ObjTask.Status__c)){
                                    if(ObjTask.Status__c != OldEventMap.get(ObjTask.id).Status__c || (ObjTask.whoId != OldEventMap.get(ObjTask.Id).whoId && ObjTask.whoId != NULL)){ 
                                        if(ObjTask.Status__c.containsIgnoreCase('success')){         
                                            if(objLead.Total_Connected_Calls__c == NULL){
                                                objLead.Total_Connected_Calls__c = 1;
                                            }else{
                                                objLead.Total_Connected_Calls__c = objLead.Total_Connected_Calls__c + 1;
                                            }
                                        }
                                     }   
                                 }
                                 
                                 Log__c newLog = new Log__c();
                                 newLog.class__c = 'TaskTriggerHelper';
                                 newLog.Name = 'Debug Values';
                                 newLog.Method__c = 'Total Call Value';
                                 newLog.message__c = 'Total Call' + ObjTask.id ;
                                 newLog.StackTrace__c = 'Total Connected Call'+ ObjLead.Total_Connected_Calls__c+'Total Call' + ObjLead.Total_Calls__c;
                                 lstLogger.add(newLog);
                                 

                                lstToUpdate.add(ObjLead);

                            }
                            
                            else{
                                // ELSE Error LEAD ID not Present 
                               // Logger.logWithPhone('TaskTriggerHelper Error','TaskTriggerHelper','calculateLeadMatrix','Lead ID not Present',null,null,null);
                            }
                        }
                        
                        if(!lstToUpdate.isEmpty()){
                           // insert lstLogger;
                            update lstToUpdate;
                            
                        }
                    }
                }
            }
        }
        catch(Exception e){
            system.debug('Exception occured --->'+e.getmessage());
            Logger.logWithPhone('TaskTriggerHelperException','TaskTriggerHelper','calculateLeadMatrix',e.getMessage(),e.getStackTraceString(),null,null);
        }
    }
    
    /*
    This Method is called after the task record is inserted.
    This Method Update the Lead records based on some values Present in task.
    */
    
    Public static void calculateLeadMatrixAfterInsert(Map<Id,Task> NewEventMap){
        try{
            Map<String,Task> mapSubjectandTask = new Map<String,Task>(); 
            Map<Id,Lead> mapLeadIdandLead = new Map<Id,Lead>(); 
            Set<Id> setLeadIdUpdates = new Set<Id>();  
            List<Lead> lstToUpdate = new List<Lead>();
            
            for(Task objTask : NewEventMap.Values()){
                // Check if the Task Subject contains UCID in It
                if(objTask.Subject.containsIgnoreCase('UCID') && objTask.WhoId != null){
                    mapSubjectandTask.put(objTask.Subject,ObjTask);
                    setLeadIdUpdates.add(objTask.WhoId);
                }
            } 
            
            System.debug('setLeadIdUpdates----->'+setLeadIdUpdates);              
            if(mapSubjectandTask != NULL){
                if(!setLeadIdUpdates.isEmpty()){
                    // Get the Lead Details
                    mapLeadIdandLead = new Map<Id,Lead>([Select Id,Name,First_Ameyo_Activity_Created_Time__c,First_Call_Response__c,First_Connected_Call_Time__c,Total_Connected_Calls__c,Ameyo_Call_Attempts__c,Last_Attempted_Call_Time__c,Total_Calls__c
                                                          from lead where ID IN:setLeadIdUpdates]);
                                                          
                    System.debug('mapLeadIdandLead----->'+mapLeadIdandLead);                                           
                    if(!mapLeadIdandLead.isEmpty()){
                        for(Task ObjTask : mapSubjectandTask.Values()){
                            if(mapLeadIdandLead.containsKey(ObjTask.whoId)){
                                Lead ObjLead = mapLeadIdandLead.get(ObjTask.whoId);
                                
                                // First Attempted Call Time
                               if(ObjLead.First_Ameyo_Activity_Created_Time__c == NULL){
                                    ObjLead.First_Ameyo_Activity_Created_Time__c = ObjTask.Createddate;
                                }
                                
                                //Last Attempted Call Time
                                objLead.Last_Attempted_Call_Time__c = ObjTask.Createddate;
                                
                                //Total Calls
                                
                                if(objLead.Total_Calls__c == NULL){
                                    objLead.Total_Calls__c= 1;
                                }else{
                                    objLead.Total_Calls__c= objLead.Total_Calls__c+ 1;
                                }
                                objLead.Dialler_Campaign_Type_and_Status__c = Null;
                                system.debug('objLead---->'+objLead.Total_Calls__c);
                                lstToUpdate.add(ObjLead);
                                
                            }else{
                                Logger.logWithPhone('TaskTriggerHelper Error','TaskTriggerHelper','calculateLeadMatrixAfterInsert','Lead ID not Present',null,null,null);
                            }
                        }
                    }
                    if(!lstToUpdate.isEmpty()){
                        update lstToUpdate;
                    }
                }
            }
        }
        catch(Exception e){
            system.debug('Exception occured --->'+e.getmessage());
            Logger.logWithPhone('TaskTriggerHelperException','TaskTriggerHelper','calculateLeadMatrixAfterInsert',e.getMessage(),e.getStackTraceString(),null,null);
        }
    }
}