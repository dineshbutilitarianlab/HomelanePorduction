global class LeadPushToOzoneCityQueue implements Queueable{
    private List<Lead> lstLead;
    private String sessionId;
    private String whatsappId;
    global LeadPushToOzoneCityQueue (List<Lead> lstLead, String sessionId, String whatsappId) {
        this.lstLead = lstLead;
        this.sessionId = sessionId;
        this.whatsappId = whatsappId;
    }
    global void execute(QueueableContext QC) {
        for(Lead l : lstLead) {      
            if(l.City == 'Bangalore' || l.City == 'Bengaluru') {
                callOzonetelAPI('BLR_AutoLead', l.Phone, whatsappId);
            }
            else if(l.City == 'Hyderabad') {
                callOzonetelAPI('HYD_AutoLead', l.Phone, whatsappId);
            }
            else if(l.City == 'Chennai') {
                callOzonetelAPI('CHN_AutoLead', l.Phone, whatsappId);
            }
            else if(l.City == 'New Delhi' || l.City == 'Ghaziabad' || l.City == 'Gurgaon' || l.City == 'Noida') {
                callOzonetelAPI('NCR_AutoLead', l.Phone, whatsappId);
            }
            else if(l.City == 'Mumbai' || l.City == 'Thane') {
                callOzonetelAPI('MUM_AutoLead', l.Phone, whatsappId);
            }
            else if(l.City == 'Pune') {
                callOzonetelAPI('Pune_AutoLead', l.Phone, whatsappId);
            }
            else if(l.City == 'Kolkata') {
                callOzonetelAPI('Kolkata_AutoLead', l.Phone, whatsappId);
            }
            else if(l.City == 'Others') {
                callOzonetelAPI('Others_AutoLead', l.Phone, whatsappId);
            }           
        }
    }
    @future(callout=true)
    global static void callOzonetelAPI(String campName, String phone, String Name) {
        System.debug('====campName  '+campName+'  =======phone  '+phone+'  =======Name  '+Name);
        String content = 'api_key='+EncodingUtil.urlEncode('KK1974dd56933b4c69602c063d589e19ab', 'UTF-8')+'&campaign_name='+EncodingUtil.urlEncode(campName, 'UTF-8')+'&format=json&PhoneNumber='+EncodingUtil.urlEncode(phone, 'UTF-8')+'&action=start&Name='+EncodingUtil.urlEncode(Name, 'UTF-8');
        System.debug('-----content   '+content);
        HTTp http = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndPoint('https://api1.cloudagent.in/cloudAgentRestAPI/index.php/CloudAgent/CloudAgentAPI/addCamapaignData?');
        req.setMethod('POST');  
        req.setTimeout(20000);    
        req.setBody(content);
        req.setHeader('Accept','application/json');
        if(!Test.isRunningTest()){
        HTTPResponse res = http.send(req);

        System.debug('*****Response  :  '+res);
        System.debug('*****Response To String :  '+res.toString());
        System.debug('*****Response Get Body :  '+res.getBody());
        }
    }
}