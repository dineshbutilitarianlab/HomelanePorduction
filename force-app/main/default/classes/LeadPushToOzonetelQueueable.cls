global class LeadPushToOzonetelQueueable implements Queueable{
    private List<Lead> lstLead;
    private String sessionId;
    global LeadPushToOzonetelQueueable(List<Lead> lstLead, String sessionId) {
        this.lstLead = lstLead;
        this.sessionId = sessionId;
    }
    global void execute(QueueableContext QC) {
        for(Lead l : lstLead) {
            System.debug('--------l.OwnerId  '+l.OwnerId);
            System.debug('--------l.WT_Agent__c  '+l.WT_Agent__c);
            if(l.OwnerId == label.Cloud_Agent_Id && l.WT_Agent__c == label.Cloud_Agent_Id){
                System.debug('INSIDE 1');
                if(l.City == 'Bangalore' || l.City == 'Bengaluru') {
                    callOzonetelAPI('BLR_AutoLead', l.Phone, l.Id);
                }
                else if(l.City == 'Hyderabad') {
                    callOzonetelAPI('HYD_AutoLead', l.Phone, l.Id);
                }
                else if(l.City == 'Chennai') {
                    callOzonetelAPI('CHN_AutoLead', l.Phone, l.Id);
                }
                else if(l.City == 'New Delhi' || l.City == 'Ghaziabad' || l.City == 'Gurgaon' || l.City == 'Noida') {
                    callOzonetelAPI('NCR_AutoLead', l.Phone, l.Id);
                }
                else if(l.City == 'Mumbai' || l.City == 'Thane') {
                    callOzonetelAPI('MUM_AutoLead', l.Phone, l.Id);
                }
                else if(l.City == 'Pune') {
                    callOzonetelAPI('Pune_AutoLead', l.Phone, l.Id);
                }
                else if(l.City == 'Kolkata') {
                    callOzonetelAPI('Kolkata_AutoLead', l.Phone, l.Id);
                }
                else if(l.City == 'Others') {
                    callOzonetelAPI('Others_AutoLead', l.Phone, l.Id);
                }
            }
            else if(l.WT_Agent__c != label.Cloud_Agent_Id) {
                System.debug('INSIDE 2');
                userCampaignName(l.WT_Agent__c, l.Phone, l.Id);
            }           
            
        } 
    }
    
    @future(callout=true)
    global static void callOzonetelAPI(String campName, String phone, Id id) {
        System.debug('====campName  '+campName+'  =======phone  '+phone+'  =======id  '+id);
        User use = [select id, name from User where name = 'Cloud Agent' limit 1];
        System.debug('------USER IS ---- '+use.Name);
        String content = 'api_key='+EncodingUtil.urlEncode('KK1974dd56933b4c69602c063d589e19ab', 'UTF-8')+'&campaign_name='+EncodingUtil.urlEncode(campName, 'UTF-8')+'&format=json&PhoneNumber='+EncodingUtil.urlEncode(phone, 'UTF-8')+'&action=start';
        System.debug('-----content   '+content);
        HTTp http = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndPoint('https://api1.cloudagent.in/cloudAgentRestAPI/index.php/CloudAgent/CloudAgentAPI/addCamapaignData?');
        req.setMethod('POST');      
        req.setBody(content);
        req.setHeader('Accept','application/json');
        
        HTTPResponse res = http.send(req);
        
        System.debug('*****Response  :  '+res);
        System.debug('*****Response To String :  '+res.toString());
        System.debug('*****Response Get Body :  '+res.getBody());
        Map<String,Object> input = (Map<String,Object>)json.deserializeUntyped(res.getBody());
        if(input.get('status') == 'SUCCESS') {
            Lead l = new Lead();
            l.Id = id;
            l.Pushed_To_Ozone_1st_Time__c = true;
            if(!Test.isRunningTest()){
                update l;
            }
        }
        else {
            SendEmailToManager('LeadPushToOzonetel failed for lead '+Id+' with phone number  '+phone);
            Logger.logWithPhone('PushToOzonetelException','LeadPushToOzonetelQueueable','callOzonetelAPI',String.valueOf(input),(String)input.get('status'),(String)Id,phone);
        }
        
    }
    
    global static void userCampaignName(String recordId, String phone, Id id) {
        User u;
        String err = '';
        try {
            u = [select id, Name, Cloud_Agent_Campaign_Name__c from User where Id =: recordId limit 1];
            callOzonetelAPI(u.Cloud_Agent_Campaign_Name__c, phone, id);
        }
        catch(Exception e) {
            err = 'The Cloud agent Campaign Name does not exist for this user '+e;
        }        
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
        message.subject = 'Lead Push To Ozonetel API Failure - OzoneTel';
        message.plainTextBody = errMsg;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
    
}