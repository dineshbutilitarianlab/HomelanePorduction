// THIS CLASS IS COVERED AS A PART OF TEST CLASS : CountATskonLead_Test

global class standerdTaskTriggerHandler{
    public static void updateLeadData(Map<Id,Task> NewEventMap){
        try{
            Set<Id> setLeadIds = new Set<Id>();
            Set<Id> setOwnerId = new Set<Id>();       
            Map<Id,Task> mapStrTask = new Map<Id,Task>();        
            List<Whatsapp_Message__c> whatsAppUpdate = new List<Whatsapp_Message__c>(); 
            List<Lead> lstOzoneLead = new List<Lead>(); 

            for(Task objTask : NewEventMap.Values()){
                if(objTask.Disposition_Type__c != null && objTask.WhoId != null) {
                    if(objTask.UUI__c != null) {                
                        mapStrTask.put(objTask.UUI__c, objTask);           
                    }                
                    setLeadIds.add(objTask.WhoId);
                    setOwnerId.add(objTask.OwnerId);
                }
            } 
            //system.debug('---------mapStrTask --------'+mapStrTask);
            
            if(mapStrTask != null && !mapStrTask.isEMpty()) {
                List<Whatsapp_Message__c> whatsAppList = [select id, name, CustomerStatus__c, Disposition__c, AgentStatus__c, monitorUCID__c, WT_Agent_Allocated_Time__c, Calculated_WT_allocated_time__c from Whatsapp_Message__c where id =: mapStrTask.keyset()]; 
                //System.debug('whatsAppList-->  '+whatsAppList);
                
                if(!whatsAppList.isEmpty()) {
                    for(Whatsapp_Message__c w : whatsAppList) {
                        if(mapStrTask.get(w.Id).CustomerStatus__c != null) {
                            w.CustomerStatus__c = mapStrTask.get(w.Id).CustomerStatus__c;
                        }
                        if(mapStrTask.get(w.Id).AgentStatus__c != null) {
                            w.AgentStatus__c = mapStrTask.get(w.Id).AgentStatus__c;
                        }
                        if(mapStrTask.get(w.Id).monitorUCID__c != null) {
                            w.monitorUCID__c = mapStrTask.get(w.Id).monitorUCID__c;
                        }
                        if(mapStrTask.get(w.Id).CallDisposition != null) {
                            w.Disposition__c = mapStrTask.get(w.Id).CallDisposition;
                        }
                        if(w.WT_Agent_Allocated_Time__c == null) {
                            w.WT_Agent_Allocated_Time__c = mapStrTask.get(w.Id).createdDate;
                        }
                        w.Calculated_WT_allocated_time__c = mapStrTask.get(w.Id).createdDate;
                        whatsAppUpdate.add(w);
                    }
                }
                
                //System.debug('whatsAppUpdate-->  '+whatsAppUpdate);
                if(!whatsAppUpdate.isEmpty()) {
                    update whatsAppUpdate;
                }
            }            
            //system.debug('---------setLeadIds--------'+setLeadIds);
            
            if(setLeadIds.size() > 0){           
                Map<Id,Lead> mapLeadData = new Map<Id,Lead>([Select id,City,Status,Attempts_since_last_connection__c,Follow_up_time__c,Description__c,Ameyo_Call_Attempts__c,Test_API_Date__c,Sub_Status__c,WT_Agent__c,WT_Agent__r.Name,Owner.Name,OwnerId,WT_Agent_Allocated_Time__c,Phone,UCL_Call_Attempts_Check__c,UCL_Call_Attempts__c,Whatsapp_UCL_Call_Attempts__c,Whatsapp_UCL_Call_Attempts_Chk__c,Whatsapp_Opt_in__c,Full_Name__c from Lead Where Id IN : setLeadIds]);
                Map<Id,User> MapUserData = new Map<Id,User>([Select Id,FirstName,LastName From User Where Id IN : setOwnerId]);
                List<Lead> listUpdateLead = new List<Lead>();
                //system.debug('---------mapLeadData --------'+mapLeadData );
                //system.debug('---------mapUserData --------'+mapUserData );
                
                // FOR LOOP START
                for(String objId : NewEventMap.KeySet()) {
                    Lead obj = new Lead();
                    //system.debug('---------NewEventMap.get(objId).WhoId--------'+NewEventMap.get(objId).WhoId);
                    Lead objLead = mapLeadData.get(NewEventMap.get(objId).WhoId);
                    //system.debug('---------objLead --------'+objLead );
                    obj.Id = objLead.Id;
                    String strDisposition = NewEventMap.get(objId).Disposition_Type__c;
                    //System.debug('------strDisposition --------  '+strDisposition );                                
                    
                    if(objLead.WT_Agent_Allocated_Time__c == null) {
                        obj.WT_Agent_Allocated_Time__c = NewEventMap.get(objId).createdDate;
                    }
                    obj.Calculated_WT_allocated_time__c = NewEventMap.get(objId).createdDate;
                    obj.Last_Dialed_Time__c = NewEventMap.get(objId).createdDate;
                    if(objLead.Ameyo_Call_Attempts__c == null)
                        obj.Ameyo_Call_Attempts__c = 1;
                    else
                        obj.Ameyo_Call_Attempts__c = objLead.Ameyo_Call_Attempts__c + 1;
                    String strDesc = objLead.Description__c;  
                    
                    if( objLead.WT_Agent__r.Name == 'Cloud Agent' && objLead.Owner.Name =='Cloud Agent'){
                        obj.WT_Agent__c = NewEventMap.get(objId).createdById;
                        obj.OwnerId = NewEventMap.get(objId).createdById;

                    }
                    
                    else if(objLead.WT_Agent__r.Name != 'Cloud Agent' && objLead.Owner.Name =='Cloud Agent'){
                        obj.OwnerId = NewEventMap.get(objId).createdById;
                    } 
                    
                    Date strFollowUpLater = Date.today();   
                    if(objLead.Follow_up_time__c !=null)
                        strFollowUpLater = Date.newinstance(objLead.Follow_up_time__c.year(), objLead.Follow_up_time__c.month(),objLead.Follow_up_time__c.day());
                    //system.debug('---------strFollowUpLater--------'+strFollowUpLater);               
                    
                    // IF UUL IS NULL    
                    if(NewEventMap.get(objId).UUI__c == null) {
                        
                        // UPDATE FLAG WHEN STATUS IS NOT FRESH LEAD 
                        if(objLead.Status != 'Fresh Lead') {
                            if(objLead.UCL_Call_Attempts_Check__c == false) {
                                obj.UCL_Call_Attempts_Check__c = true;
                            }
                        }
                        
                        // IF DISPOSITION IS NOT CONNECTED - UUL NULL
                        if(String.isNotBlank(strDisposition) && !strDisposition.equalsIgnoreCase('connected')){   
                            
                            // UPDATE DESCRIPTION                                                                                     
                            if(strDesc == null) {
                                strDesc ='';
                            }
                            String formatted = System.Now().format('dd/MM/yyyy\' \'HH:mm');
                            strDesc = formatted+' - '+ MapUserData.get(NewEventMap.get(objId).OwnerId).FirstName +' - '+ strDisposition+'\n'+strDesc;
                            //System.debug('-------------strDesc --------  '+strDesc);
                            obj.Description__c = strDesc;
                            
                            // INCREMENT ATTEMPTS SINCE LAST CONNECTION
                            if(strDisposition.equalsIgnoreCase('Couldn\'t Contact')){
                                if(objLead.Attempts_since_last_connection__c == null){
                                    obj.Attempts_since_last_connection__c = 1;
                                }
                                else{
                                    obj.Attempts_since_last_connection__c = objLead.Attempts_since_last_connection__c+1;
                                }
                            }
                            
                            // INCREMENT FOLLOW UP TIME - EXTRA DAY COMPARING WITH TODAY'S DATE    
                            if(objLead.Sub_Status__c == 'Unable To Contact' && strDisposition.equalsIgnoreCase('Couldn\'t Contact') && strFollowUpLater <= Date.today() && objLead.Attempts_since_last_connection__c < 6){
                                //Commented and changed by Bharatesh Shetty
                                //obj.Follow_up_time__c = System.now().addDays(1); 
                                obj.Follow_up_time__c = System.now().addHours(15);
                            }
                            
                            // NOT ACTIVELY PURSUED CONDITION
                            if(objLead.Status == 'Fresh Lead' && strDisposition.equalsIgnoreCase('Couldn\'t Contact') && objLead.Attempts_since_last_connection__c >= 6){
                                obj.Follow_up_time__c = null;
                                obj.Status = 'Not Actively Pursued';
                                obj.Sub_Status__c = 'Exceeded Max Attempts';
                                //Added due to Issue raised BY WTA
                                objLead.Status = 'Not Actively Pursued';
                                objLead.Sub_Status__c = 'Exceeded Max Attempts';
                                obj.Attempts_since_last_connection__c = 0;
                                if(objLead.UCL_Call_Attempts_Check__c == false) {
                                    obj.UCL_Call_Attempts_Check__c = true;
                                } 
                            }
                            
                            // UPDATE TO CALL BACK IN 2 HRS CONDITION
                            if(objLead.Status == 'Fresh Lead' && (objLead.Sub_Status__c == 'New' || objLead.Sub_Status__c == 'Unverified')&& strDisposition.equalsIgnoreCase('Couldn\'t Contact')){
                                obj.Sub_Status__c = 'Call back in 2 hrs';
                                obj.Follow_up_time__c = System.now().addHours(2);
                                if(objLead.UCL_Call_Attempts_Check__c == false) {
                                    if(objLead.UCL_Call_Attempts__c == null) {
                                        obj.UCL_Call_Attempts__c = 1;
                                    }
                                    else {
                                        obj.UCL_Call_Attempts__c = objLead.UCL_Call_Attempts__c+1;
                                    }
                                }
                                if(objLead.Whatsapp_Opt_in__c == true) {
                                    //Stopped because of no Verloop contract as suggested by pavan on 09/09/2020
                                    //sendWhatsapp(objLead); 
                                }
                            }
                            
                            // UPDATE TO UNABLE CONTACT CONDITION
                            
                            if(objLead.Status == 'Fresh Lead' && (objLead.Sub_Status__c == 'Call back in 2 hrs' || objLead.Sub_Status__c == 'Unable To Contact') && strDisposition.equalsIgnoreCase('Couldn\'t Contact')){
                               
                                obj.Sub_Status__c = 'Unable To Contact';
                                if(objLead.Follow_up_time__c != NULL){
                                    //Commented and changed by Bharatesh Shetty
                                    //obj.Follow_up_time__c = System.now().addDays(1); 
                                    obj.Follow_up_time__c = System.now().addHours(15);
                                }
                                if(objLead.UCL_Call_Attempts_Check__c == false) {
                                    if(objLead.UCL_Call_Attempts__c == null) {
                                        obj.UCL_Call_Attempts__c = 1;
                                    }
                                    else {
                                        obj.UCL_Call_Attempts__c = objLead.UCL_Call_Attempts__c+1;
                                    }
                                }
                                if(objLead.Whatsapp_Opt_in__c == true) {
                                    //Stopped because of no Verloop contract as suggested by pavan on 09/09/2020
                                    //sendWhatsapp(objLead); 
                                }
                            }
                            
                            // DEAD LEAD CONDITION
                            if((strDisposition.equalsIgnoreCase('Dead Lead')) && (objLead.Sub_Status__c == 'New' || objLead.Sub_Status__c == 'Unverified') && objLead.Status =='Fresh Lead'){
                                obj.Status = 'Dead Lead';
                                obj.Sub_Status__c = 'Wrong Contact Number';     
                                obj.Attempts_since_last_connection__c = 0;  
                                if(objLead.UCL_Call_Attempts_Check__c == false) {
                                    obj.UCL_Call_Attempts_Check__c = true;
                                }                   
                            }                          
                        }
                        
                        // IF DISPOSITION IS CONNECTED - UUI NULL
                        else if(String.isNotBlank(strDisposition)  && strDisposition.equalsIgnoreCase('connected')){
                            
                            if(NewEventMap.get(objId) !=null && String.isBlank(NewEventMap.get(objId).CallDisposition)){
                                if(!NewEventMap.get(objId).CallDisposition.equalsIgnoreCase('Follow_Up_Later')) {
                                    obj.Attempts_since_last_connection__c = 0;
                                } 
                            }                                                          
                        }                   
                    }
                    
                    // IF UUL IS NOT NULL
                    else {
                        
                        // UPDATE FLAG WHEN STATUS IS NOT FRESH LEAD        
                        if(objLead.Status != 'Fresh Lead') {
                            if(objLead.Whatsapp_UCL_Call_Attempts_Chk__c == false) {
                                obj.Whatsapp_UCL_Call_Attempts_Chk__c = true;
                            } 
                        }
                        
                        // IF DISPOSITION IS NOT CONNECTED - UUI NOT NULL
                        if(String.isNotBlank(strDisposition) && !strDisposition.equalsIgnoreCase('connected')){ 
                            
                            // UPDATE DESCRIPTION
                            if(strDesc == null)
                                strDesc ='';
                            String formatted = System.Now().format('dd/MM/yyyy\' \'HH:mm');
                            strDesc = formatted+' - '+ MapUserData.get(NewEventMap.get(objId).OwnerId).FirstName +' - '+ strDisposition+' - Whatsapp. \n'+strDesc;
                            System.debug('-------------strDesc --------  '+strDesc);
                            obj.Description__c = strDesc;
                            
                            // UPDATE TO UNABLE CONTACT CONDITION
                            if(objLead.Status == 'Fresh Lead' && (objLead.Sub_Status__c == 'Call back in 2 hrs' || objLead.Sub_Status__c == 'Unable To Contact') && strDisposition.equalsIgnoreCase('Couldn\'t Contact')) {
                                if(objLead.Whatsapp_UCL_Call_Attempts_Chk__c == false) {
                                    if(objLead.Whatsapp_UCL_Call_Attempts__c == null) {
                                        obj.Whatsapp_UCL_Call_Attempts__c = 1;
                                    }
                                    else {
                                        obj.Whatsapp_UCL_Call_Attempts__c = objLead.Whatsapp_UCL_Call_Attempts__c+1;
                                    }
                                } 
                                //obj.Sub_Status__c = 'Unable To Contact';
                                if(objLead.Whatsapp_Opt_in__c == true) {
                                    //Stopped because of no Verloop contract as suggested by pavan on 09/09/2020
                                    //sendWhatsapp(objLead); 
                                }
                            }    
                        }                                                           
                    }
                    listUpdateLead.add(obj);

                    // FOR LOOP END 
                }
                if(listUpdateLead.size() >0){
                    update listUpdateLead;

                }
            
            }
            
        }
        
        catch(Exception exp){      
            Logger.logWithPhone('TaskTriggerException','standerdTaskTriggerHandler','updateLeadData',exp.getMessage(),exp.getStackTraceString(),null,null);

        }  
    }
    
    public static void sendWhatsapp(Lead l) {
        if(label.WhatsApp_UnableToContact.equalsIgnoreCase('True')){
            try {
                /* Whatsapp_Message__c w = new Whatsapp_Message__c();
                w.Name = 'WA - Unable to Contact'; 
                w.Sent__c = System.now();
                w.Lead__c = l.Id; */
                String body = '{"CampaignID": "b1c09bc1-5346-4fa0-9b84-255b882f9b6b","To": {"PhoneNumber": "91'+l.phone+'"},"WhatsAppCampaignParameters": {"LocalizableParams": [{"Default": "'+l.Full_Name__c+'"},{"Default": "10"}]}}';
                //String body = '{"CampaignID": "b1c09bc1-5346-4fa0-9b84-255b882f9b6b","To": {"PhoneNumber": ""},"WhatsAppCampaignParameters": {"LocalizableParams": [{"Default": "'+l.Full_Name__c+'"},{"Default": "10"}]}}';
                //insert w;
                WhatsappTrigger.sendWhatsapp(l.phone,body,'Verloop API','lead',l.Id,'WA - Unable to Contact');  
            } 
            catch(Exception exp) {      
                Logger.logWithPhone('TaskTriggerException','standerdTaskTriggerHandler','sendWhatsapp',exp.getMessage(),exp.getStackTraceString(),null,null);
            }  
        }    
    }
}