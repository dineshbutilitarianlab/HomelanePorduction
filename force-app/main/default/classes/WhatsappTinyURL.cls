global class WhatsappTinyURL implements Queueable, Database.AllowsCallouts{
    private String em;
    private String phone;
    private String nam;
    private String projId;
    private String verId;
    private String oppId;
    global WhatsappTinyURL(String phone, String nam, String projId, String verId, String oppId) {
      //  this.em = em;
        this.phone = phone;
        this.nam = nam;
        this.projId = projId;
        this.verId = verId;
        this.oppId = oppId;
    } 
   
    global void execute(QueueableContext QC) {
        Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
        Integration_Setting__c integrationDetail = allEndPoint.get('Tiny URL API'); 
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.homelane.com/apis/quotes/generateTinyUrl?');
        String strJson = EncodingUtil.urlDecode('share_link='+integrationDetail.End_Point__C+'/'+projId+'/'+verId+'/'+oppId,'UTF-8');
        String jsonModified = strJson.replaceall('&','%26');
        System.debug('******strJson  '+strJson);
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setBody(jsonModified);        
        request.setHeader('Accept', '');
        System.debug('REQUEST   '+request);
        String urlCatch;
        try {
            HttpResponse response = http.send(request);
            System.debug('RESPONSE   '+response);
            System.debug('RESPONSE BODY  '+response.getbody());
            String leadinput = response.toString();
            System.debug('#####leadinput  '+leadinput);
            Map<String, Object> json_req_input = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('#####json_req_input   '+json_req_input );
            urlCatch = (String)json_req_input.get('tiny_url');
            System.debug('#####urlCatch   '+urlCatch );
           
            String body = '{"CampaignID": "55f6fb37-c2d4-4ead-9aad-2ff249b4499e","To": {"PhoneNumber": "91'+phone+'"},"WhatsAppCampaignParameters": {"LocalizableParams": [{"Default": "'+nam+'"},{"Default":"'+urlCatch+'" }]}}';
            WhatsappTrigger.sendWhatsapp( phone,body,'Verloop API','opportunity',oppId,'WA - Quote');
             //sendWhatsapp(phone, urlCatch, nam); 
        }
        catch(TypeException e) {}
    }        
}