global class PushToOzoneTelAdditionalQueue implements Queueable{
    private List<Lead> lstLead;
    private String sessionId;
    Private Boolean blitzCustomerRegisteredPush = False;
    global PushToOzoneTelAdditionalQueue(List<Lead> lstLead, String sessionId) {
        this.lstLead = lstLead;
        this.sessionId = sessionId;
        System.debug('3 params');
    }
    global PushToOzoneTelAdditionalQueue(List<Lead> lstLead, String sessionId,Boolean blitzCustomerRegisteredPush) {
        this.lstLead = lstLead;
        this.sessionId = sessionId;
        this.blitzCustomerRegisteredPush = blitzCustomerRegisteredPush;
        System.debug('3 params');
    }
    global void execute(QueueableContext QC) {
        for(Lead l : lstLead) {
            System.debug('l.assigned_To_resi_asm__c: '+l.assigned_To_resi_asm__c);
            System.debug('l.Should_run_Ironman_assignment__c: '+l.Should_run_Ironman_assignment__c);
            System.debug('-------blitzCustomerRegisteredPush  '+blitzCustomerRegisteredPush);
            if((l.assigned_To_resi_asm__c == false && l.Should_run_Ironman_assignment__c )|| blitzCustomerRegisteredPush) {
                if(l.City.equalsIgnoreCase('bengaluru') || l.City.equalsIgnoreCase('bangalore')||l.City.equalsIgnoreCase('mysore')){
                    callOzonetelAPI('BLR_AutoLead', l.Phone, l.Id);
                    //callOzonetelAPI('Test_AutoLead', l.Phone, l.Id);
                    System.debug('l.City: '+l.City);
                }
                else if(l.City.equalsIgnoreCase('kolkata')){
                    callOzonetelAPI('Kolkata_AutoLead', l.Phone, l.Id);
                    //callOzonetelAPI('Test_AutoLead', l.Phone, l.Id);
                    System.debug('l.City: '+l.City);
                }
                else if(l.City.equalsIgnoreCase('hyderabad') || l.City.equalsIgnoreCase('visakhapatnam')){
                    callOzonetelAPI('HYD_AutoLead', l.Phone, l.Id);
                    //callOzonetelAPI('Test_AutoLead', l.Phone, l.Id);
                    System.debug('l.City: '+l.City);
                }
                else if(l.City.equalsIgnoreCase('coimbatore')){
                    callOzonetelAPI('OUTBOUND_COIMBATORE', l.Phone, l.Id);
                    //callOzonetelAPI('Test_AutoLead', l.Phone, l.Id);
                    System.debug('l.City: '+l.City);
                }
                else if(l.City.equalsIgnoreCase('chennai')){
                    callOzonetelAPI('CHN_AutoLead', l.Phone, l.Id);
                    //callOzonetelAPI('Test_AutoLead', l.Phone, l.Id);
                    System.debug('l.City: '+l.City);
                }
                else if(l.City == 'New Delhi' || l.City == 'Ghaziabad' || l.City == 'Gurgaon' || l.City == 'Noida') {
                    callOzonetelAPI('NCR_AutoLead', l.Phone, l.Id);
                    //callOzonetelAPI('Test_AutoLead', l.Phone, l.Id);
                    System.debug('l.City: '+l.City);
                }
                else if(l.City == 'Mumbai' || l.City == 'Thane') {
                    callOzonetelAPI('MUM_AutoLead', l.Phone, l.Id);
                    //callOzonetelAPI('Test_AutoLead', l.Phone, l.Id);
                    System.debug('l.City: '+l.City);
                }
                else if(l.City == 'Pune') {
                    callOzonetelAPI('Pune_AutoLead', l.Phone, l.Id);
                    //callOzonetelAPI('Test_AutoLead', l.Phone, l.Id);
                    System.debug('l.City: '+l.City);
                }
                /*else if(l.City == 'Visakhapatnam') {
                    //callOzonetelAPI('Visakhapatnam_AutoLead', l.Phone, l.Id);
                    callOzonetelAPI('Test_AutoLead', l.Phone, l.Id);
                    System.debug('l.City: '+l.City);
                }*/
                else if(l.City == 'Others') {
                    callOzonetelAPI('Others_AutoLead', l.Phone, l.Id);
                    //callOzonetelAPI('Test_AutoLead', l.Phone, l.Id);
                }
                else{
                    System.debug('PushToOzoneTelAdditionalQueue class city is not out of the ones to which the Territory (pincode) IM allocation is implemented. City: '+l.City);
                    Logger.log('City Error','execute method','PushToOzoneTelAdditionalQueue Class','City not in valid city set. City: '+l.City,l.Email,l.Id);
                }
            }  
        } 
    }
    
    @future(callout=true)
    global static void callOzonetelAPI(String campName, String phone, Id id) {
        try{
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
                Logger.logWithPhone('PushToOzonetelException','PushToOzoneTelAdditionalQueue','callOzonetelAPI',String.valueOf(input),(String)input.get('status'),(String)Id,phone);
            }
        }
        catch(Exception e){
            System.debug('Exception message: '+e.getMessage());
            System.debug('Exception stackTrace: '+e.getStackTraceString());
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
    Public class LeadSquareUsersWrapper{
        Public String ID;
        Public String FirstName;
        Public String LastName;
        Public String EmailAddress;
        Public String Role;
        Public Integer StatusCode;
        Public List<String> MemberOfGroups;
        Public String Tag;
        Public Boolean IsPhoneCallAgent;
    }
}