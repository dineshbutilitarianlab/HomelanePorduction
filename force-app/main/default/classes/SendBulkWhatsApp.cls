public class SendBulkWhatsApp implements Queueable,Database.AllowsCallouts {
    
    private String phone;
    private String body;
    private String objIntName;
    
    public SendBulkWhatsApp (String sPhone,String sBody,String sobjIntName) {
        this.phone= sPhone;
        this.body= sBody;
        this.objIntName = sobjIntName;
    }
    public void execute(QueueableContext context) {
        try{
            HTTP http = new HTTP();
            HTTPRequest req = new HTTPRequest();
            Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
            Integration_Setting__c integrationDetail = allEndPoint.get(objIntName); 
            System.debug('BODY:  '+body);
            if(integrationDetail != NULL){
            req.setMethod('POST');
            req.setHeader('Content-Type',integrationDetail.ContentType__c);
            req.setEndPoint(integrationDetail.End_Point__c);
            req.setBody(body);
            HTTPResponse res = http.send(req);
            System.debug('HTTPResponse  '+res);
            System.debug('HTTPResponse GETBODY '+res.getbody());   
            }  
        }       
        catch(Exception e){
            Logger.log('Exception','SendWhatsApp_StandAlone','sendWhatsapp','Error in sending WhatsApp Record',body,NULL);
        }    
    }
 }