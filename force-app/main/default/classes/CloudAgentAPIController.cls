@RestResource(urlMapping='/CloudAgentPostProcessingAPI/*')
global with sharing class  CloudAgentAPIController {
    @HttpPost
    global static void getRec() {
        RestRequest req = RestContext.request;            
        String leadinput = req.requestBody.toString(); 
        leadInput =  EncodingUtil.urlDecode(leadInput,'UTF-8');
        leadInput = leadInput.remove('data='); 
        system.debug('******RestRequest *******'+req);    
        system.debug('******leadinput *******'+leadinput );      
        Map<String, Object> json_req_input = (Map<String, Object>)JSON.deserializeUntyped(leadinput);        
        system.debug('******json_req_input *******'+json_req_input );
        
        Map<String,User> mapUserData = new Map<String,User>();
        List<sObject> leadsObj = new List<sObject>();
        String Caller = (String)json_req_input.get('CallerID');
        String CallerId = Caller.removeStart('0');
        System.debug('-----CallerId  '+CallerId);
        String monUCID = (String)json_req_input.get('monitorUCID');
        System.debug('-----monitorUCID  '+monUCID);
        String disposition = '';
        String userEmail = (String)json_req_input.get('AgentID');
        userEmail = userEmail.toLowerCase();
        System.debug('---userEmail-->  '+userEmail );
        userEmail = userEmail.replaceAll( '\\s+', '');
        System.debug('---userEmail SPACES -->  '+userEmail );
        String whatsappId = (String)json_req_input.get('UUI');
        list<Whatsapp_Message__c>  lstwhats;
        String sub;
        String type = (String)json_req_input.get('Type');
        String customerStatus = (String)json_req_input.get('CustomerStatus');
        String agentStatus = (String)json_req_input.get('AgentStatus');
        /*   if(String.isNotBlank(whatsappId)) {
try {
lstwhats = [select id, Calculated_WT_allocated_time__c, WT_Agent_Allocated_Time__c, monitorUCID__c, Disposition__c, CustomerStatus__c from Whatsapp_Message__c where id =: whatsappId];
if(lstwhats != NULL && !lstwhats.isEmpty()){
if((String)json_req_input.get('StartTime') != null || (String)json_req_input.get('StartTime') != '') {
if(lstwhats[0].WT_Agent_Allocated_Time__c == null)
lstwhats[0].WT_Agent_Allocated_Time__c = DateTime.valueOf((String)json_req_input.get('StartTime'));
}

if((String)json_req_input.get('StartTime') != null || (String)json_req_input.get('StartTime') != '') {
lstwhats[0].Calculated_WT_allocated_time__c = DateTime.valueOf((String)json_req_input.get('StartTime'));
}

if((String)json_req_input.get('Disposition') != null) {
lstwhats[0].Disposition__c = (String)json_req_input.get('Disposition');
}

if((String)json_req_input.get('monitorUCID') != null) {
lstwhats[0].monitorUCID__c = (String)json_req_input.get('monitorUCID');
}

if((String)json_req_input.get('CustomerStatus') != null) {
lstwhats[0].CustomerStatus__c = (String)json_req_input.get('CustomerStatus');
}
}   
}
catch(Exception e) {
SendEmailToManager('THe Whatsapp could not be updated and error is  '+e.getMessage()+' at Line '+e.getLineNumber()+' StackTrack '+e.getStackTraceString());
Logger.logWithPhone('WhatsappException','CloudAgentAPIController','CloudAgentAPIController',e.getMessage(),e.getStackTraceString(),NULL,CallerId);
}
}  */
        
        if(userEmail.contains('->')) {           
            List<String> strList = userEmail.split('->');
            if(strList.size() > 0) {
                for(Integer i=strList.size()-1; i>0; i--) {
                    userEmail = strList[i];
                    break;
                }
            }
        }
        System.debug('type: '+type);
        System.debug('customerStatus: '+customerStatus);
        System.debug('agentStatus: '+agentStatus);
        if(type.equalsIgnoreCase('Predictive') && (!customerStatus.equalsIgnoreCase('answered') || !agentStatus.equalsIgnoreCase('answered'))){
            System.debug('Predictive call createTaskRecord method');
            //Commented as part of OH changes
            //createTaskRecord(CallerId,json_req_input);
        }
        else{
            System.debug('Else case excecuted in Predictive not answered scenario.');
            List<Task> taskList = new List<Task>();  
            String leadId;
            try {
                taskList = [select id,WhoId, CallDisposition, Disposition_Type__c, subject from Task where subject like: '%'+monUCID limit 1];
                System.debug('-------taskList  '+taskList); 
                leadId = taskList[0].WhoId;
                if(!taskList.isEmpty()) {
                    if(String.isNotBlank(taskList[0].Disposition_Type__c)) {
                        disposition = taskList[0].Disposition_Type__c;
                        System.debug('-------disposition  '+disposition);                    
                    }
                    sub = taskList[0].subject; 
                }
            }
            catch(Exception e) {
                Logger.logWithPhone('TaskQueryException','CloudAgentAPIController','CloudAgentAPIController',e.getMessage(),e.getStackTraceString(),NULL,CallerId);
            }          
            
            /* List<Task_Custom__c> tskCustomList = new List<Task_Custom__c>(); 
try {
tskCustomList = [select id, Name, Lead__c, Test_API_Data__c from Task_Custom__c where Name like: '%'+monUCID limit 1];
System.debug('-------tskCustomList  '+tskCustomList); 
if(!tskCustomList.isEmpty()) { 
if(tskCustomList[0].Test_API_Data__c == null)
tskCustomList[0].Test_API_Data__c = leadInput;
}
}
catch(Exception e) {
Logger.logWithPhone('TaskCustomQueryException','CloudAgentAPIController','CloudAgentAPIController',e.getMessage(),e.getStackTraceString(),null,CallerId);
} */         
            
            
            if(userEmail != null){
                try{
                    for(User objUser : [Select Id,FirstName,Email,UserName,Name,Cloud_Agent_Campaign_Name__c from User where Email =: userEmail Limit 1]) {
                        MapUserData.put(objUser.Email,objUser);
                    }
                }
                catch(Exception exp){
                    system.debug('---User Is not found on SF---'+exp.getMessage());
                    SendEmailToManager('Salesforce - This is to inform you that Lead with the phone ='+CallerId+' is not Updated,Because User with user name '+(String)json_req_input.get('AgentName')+' we got the following error-'+exp.getMessage()+' at Line '+exp.getLineNumber()+' StackTrack '+exp.getStackTraceString()+'.Please do the needful');
                    Logger.logWithPhone('UserException','CloudAgentAPIController','CloudAgentAPIController',exp.getMessage(),exp.getStackTraceString(),null,CallerId);
                }
                system.debug('------------MapUserData---------------'+MapUserData);
            }
            
            try  {
                
                List<Lead> listopp = new List<Lead>();
                if(!String.isBlank(leadId)){
                    listopp = [Select id,Status,Attempts_since_last_connection__c,Calculated_WT_allocated_time__c,Follow_up_time__c,Description__c,Ameyo_Call_Attempts__c,Test_API_Date__c,Sub_Status__c,WT_Agent__c,WT_Agent__r.Name,Owner.Name,OwnerId,WT_Agent_Allocated_Time__c from Lead where id =: leadId AND IsConverted = false order by LastModifiedDate desc limit 1];
                }
                else{
                  listopp = [Select id,Status,Attempts_since_last_connection__c,Calculated_WT_allocated_time__c,Follow_up_time__c,Description__c,Ameyo_Call_Attempts__c,Test_API_Date__c,Sub_Status__c,WT_Agent__c,WT_Agent__r.Name,Owner.Name,OwnerId,WT_Agent_Allocated_Time__c from Lead where Phone =: CallerId AND IsConverted = false order by LastModifiedDate desc limit 1];  
                }
                
                system.debug('------------listopp ---------------'+listopp );
                
                if(!listopp.isEmpty()){
                    Lead obj = new Lead();
                Task_Custom__c tc = new Task_Custom__c();
                for(Lead myLead : listopp){
                    obj.Id = myLead.id;
                    obj.Test_API_Date__c = leadInput;
                    
                    tc.Lead__c = myLead.Id;
                    tc.Test_API_Data__c = leadInput;
                    if(String.isNotBlank(sub)) {
                        tc.Name = sub;
                    }
                    else {
                        tc.Name = monUCID;
                    }
                    
                    if((String)json_req_input.get('StartTime') != null || (String)json_req_input.get('StartTime') != '') {
                        if(myLead.WT_Agent_Allocated_Time__c == null)
                            obj.WT_Agent_Allocated_Time__c = DateTime.valueOf((String)json_req_input.get('StartTime'));
                    }
                    
                    if((String)json_req_input.get('StartTime') != null || (String)json_req_input.get('StartTime') != '') {
                        obj.Calculated_WT_allocated_time__c = DateTime.valueOf((String)json_req_input.get('StartTime'));
                    }
                    
                    if((String)json_req_input.get('StartTime') != null || (String)json_req_input.get('StartTime') != '')
                        obj.Last_Dialed_Time__c = DateTime.valueOf((String)json_req_input.get('StartTime'));
                    
                    if(disposition != null) {  
                        if(!disposition.equalsIgnoreCase('connected')){                   
                            if(myLead.WT_Agent__r.Name == 'Cloud Agent' && myLead.Owner.Name =='Cloud Agent'){
                                if(MapUserData.get(userEmail) != null){
                                    obj.WT_Agent__c = MapUserData.get(userEmail).Id;
                                    obj.OwnerId = MapUserData.get(userEmail).Id;
                                }
                            }
                            else if(myLead.WT_Agent__r.Name != 'Cloud Agent' && myLead.Owner.Name =='Cloud Agent'){
                                if(MapUserData.get(userEmail) != null){
                                    obj.OwnerId = MapUserData.get(userEmail).Id;
                                }
                            }
                        }  
                        
                        /************************************************ End System Disposition Not Connected**************************/           
                        
                        if(disposition.equalsIgnoreCase('connected') && myLead.WT_Agent__r.Name == 'Cloud Agent' && myLead.Owner.Name =='Cloud Agent'){
                            if(MapUserData.get(userEmail) != null){
                                obj.WT_Agent__c = MapUserData.get(userEmail).Id;
                                obj.OwnerId = MapUserData.get(userEmail).Id;
                                obj.Attempts_since_last_connection__c = 0;
                            }
                        }
                        if(disposition.equalsIgnoreCase('connected') && myLead.WT_Agent__r.Name == 'Cloud Agent'){
                            obj.Attempts_since_last_connection__c = 0;
                            
                        }
                        if(disposition.equalsIgnoreCase('connected') && myLead.WT_Agent__r.Name != 'Cloud Agent' && myLead.Owner.Name =='Cloud Agent'){
                            if(MapUserData.get(userEmail) != null){
                                obj.OwnerId = MapUserData.get(userEmail).Id;
                                obj.Attempts_since_last_connection__c = 0;
                            }
                        }
                        
                    }
                    
                }
                System.debug('----OBJ LEAD -->  '+obj);
                if(obj.Id != null) {
                    update obj;
                }
                
                insert tc;
                }
                
            }
            catch(Exception exp){
                System.debug('THe exception is '+exp.getMessage()+'  at Line : '+exp.getLineNumber()+' StackTrack : '+exp.getStackTraceString());
                SendEmailToManager('Salesforce - This is to inform you that Lead with the phone ='+CallerId+' is not Updated,Because we got the following error-'+exp.getMessage()+' at Line '+exp.getLineNumber()+' StackTrack '+exp.getStackTraceString()+'.Please do the needful');
                Logger.logWithPhone('LeadException','CloudAgentAPIController','CloudAgentAPIController',exp.getMessage(),exp.getStackTraceString(),null,CallerId);
            }             
            
            if(taskList != null && !taskList.isEmpty()) { 
                Task t = new Task();
                t.Id = taskList[0].Id;
                if((String)json_req_input.get('monitorUCID') != null || (String)json_req_input.get('monitorUCID') != '')
                    t.CrtObjectId__c = (String)json_req_input.get('monitorUCID');
                if((String)json_req_input.get('AgentPhoneNumber') != null || (String)json_req_input.get('AgentPhoneNumber') != '')
                    t.Call_ID__c = (String)json_req_input.get('AgentPhoneNumber');
                if((String)json_req_input.get('AudioFile') != null || (String)json_req_input.get('AudioFile') != '')
                    t.recording_url__c = (String)json_req_input.get('AudioFile');
                System.debug('**********task  '+t); 
                if(t.Id != null) {
                    ByPassValidation__c mc = ByPassValidation__c.getOrgDefaults();
                    mc.IsTrue__c = false;
                    update mc;
                    update t;  
                    mc.IsTrue__c = true;
                    update mc;
                }
            } 
        }
        
        /*  if(lstwhats != NULL && !lstwhats.isEmpty()){
update lstwhats[0];
}  */ 
        
    }
    
    global Static void SendEmailToManager(String errMsg){
        String[] strUserEmail = new List<String>();
        if(!Test.isRunningTest()){Exception_Mail__c objAmeyo = Exception_Mail__c.getValues('SF Lead Mail');strUserEmail = objAmeyo.Email_Addresss__c.split(',');
                                 }else{
                                     strUserEmail.add('testapi@gmail.com');
                                 }
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = strUserEmail ; 
        message.optOutPolicy = 'FILTER';
        message.subject = 'Post Processing API Failure - OzoneTel';
        message.plainTextBody = errMsg;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
    Public static void createTaskRecord(String phoneNumber, Map<String, Object> json_req_input){
        try{
            System.debug('createTaskRecord:');
            if(!json_req_input.isEmpty()){
                List<Lead> listOfQueriedLeads = new List<Lead>();
                listOfQueriedLeads = [Select id from Lead where phone =: phoneNumber];
                if(!listOfQueriedLeads.isEmpty()){
                    System.debug('listOfQueriedLeads[0].id: '+listOfQueriedLeads[0].id);
                    Task task = new Task();
                    task.WhoId = listOfQueriedLeads[0].id;
                    task.Subject = 'Predictive Dialing - UCID -';
                    if(json_req_input.containsKey('monitorUCID') && json_req_input.get('monitorUCID') != null){
                        task.Subject += (String)json_req_input.get('monitorUCID');
                    }
                    if(json_req_input.containsKey('CustomerStatus') && json_req_input.get('CustomerStatus') != null){
                        task.CustomerStatus__c = (String)json_req_input.get('CustomerStatus');
                    }
                    if(json_req_input.containsKey('AgentStatus') && json_req_input.get('AgentStatus') != null){
                        task.AgentStatus__c = (String)json_req_input.get('AgentStatus');
                    }
                    if(json_req_input.containsKey('CampaignName') && json_req_input.get('CampaignName') != null){
                        task.CampaignName__c = (String)json_req_input.get('CampaignName');
                    }
                    task.CallDisposition = 'Unable_to_Connect';
                    task.Status__c = 'Fail';
                    task.CallType = 'Outbound';
                    insert task;
                    
                   /* ID jobID = System.enqueueJob(new UpdateStandardTaskQueueable(task));
                    system.debug('-----jobID----'+jobID); */
                }
                else{
                    System.debug('Lead not present with the phone number');
                }
            }
            else{
                System.debug('json_req_input Map is Empty');
            }
        }
        catch(Exception e){
            System.debug('Exception mesage: '+ e.getMessage());
            System.debug('Exception StacktraceString: '+ e.getStackTraceString());
            Logger.log('Exception','CloudAgentAPIController Class','createTaskRecord Method',e.getMessage(),e.getStackTraceString(),null);
        }
        
    }
}