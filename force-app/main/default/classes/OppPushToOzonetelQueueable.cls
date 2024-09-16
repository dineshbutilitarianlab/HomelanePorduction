global class OppPushToOzonetelQueueable implements Queueable{
    private List<Opportunity> lstOpp;
    private String sessionId;
    
    global OppPushToOzonetelQueueable (List<Opportunity> lstOpp, String sessionId) {
        this.lstOpp = lstOpp;
        this.sessionId = sessionId;       
    }
    
    global void execute(QueueableContext QC) {
        System.debug('====lstOpp  '+lstOpp);
        for(Opportunity o : lstOpp) {
           
            if(o.CityfromLead__c == 'Bangalore' || o.CityfromLead__c == 'Bengaluru') {
                callOzonetelAPI('BLR_AutoLead', o.Customer_Phone_Number__c);
            }
            else if(o.CityfromLead__c == 'Hyderabad') {
                callOzonetelAPI('HYD_AutoLead', o.Customer_Phone_Number__c);
            }
            else if(o.CityfromLead__c == 'Chennai') {
                callOzonetelAPI('CHN_AutoLead', o.Customer_Phone_Number__c);
            }
            else if(o.CityfromLead__c == 'New Delhi' || o.CityfromLead__c == 'Ghaziabad' || o.CityfromLead__c == 'Gurgaon' || o.CityfromLead__c == 'Noida') {
                callOzonetelAPI('NCR_AutoLead', o.Customer_Phone_Number__c);
            }
            else if(o.CityfromLead__c == 'Mumbai' || o.CityfromLead__c == 'Thane') {
                callOzonetelAPI('MUM_AutoLead', o.Customer_Phone_Number__c);
            }
            else if(o.CityfromLead__c == 'Pune') {
                callOzonetelAPI('Pune_AutoLead', o.Customer_Phone_Number__c);
            }
            else if(o.CityfromLead__c == 'Kolkata') {
                callOzonetelAPI('Kolkata_AutoLead', o.Customer_Phone_Number__c);
            }
            else if(o.CityfromLead__c == 'Others') {
                callOzonetelAPI('Others_AutoLead', o.Customer_Phone_Number__c);
            }       
        }
    }
    
    @future(callout=true)
    global static void callOzonetelAPI(String campName, String phone) {
        System.debug('====campName  '+campName+'  =======phone  '+phone);
        String content = 'api_key='+EncodingUtil.urlEncode('KK1974dd56933b4c69602c063d589e19ab', 'UTF-8')+'&campaign_name='+EncodingUtil.urlEncode(campName, 'UTF-8')+'&format=json&PhoneNumber='+EncodingUtil.urlEncode(phone, 'UTF-8')+'&action=start';
        System.debug('-----content   '+content);
        HTTp http = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndPoint('https://api1.cloudagent.in/cloudAgentRestAPI/index.php/CloudAgent/CloudAgentAPI/addCamapaignData?');
        req.setMethod('POST');      
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