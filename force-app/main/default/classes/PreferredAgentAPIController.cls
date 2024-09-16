@RestResource(urlMapping='/PreferredAgentAPI/*')
global with sharing class  PreferredAgentAPIController {
    @HttpPost
    global static void getRec() {
        RestRequest req = RestContext.request;            
        String leadinput = req.requestBody.toString(); 
        system.debug('******RestRequest *******'+req);    
        system.debug('******leadinput *******'+leadinput ); 
        List<String> lstStr = leadinput.split('&');
        String ph = lstStr[0].remove('cid=');
        system.debug('******PHONE*******'+ph);
        String tollfree = lstStr[1].remove('did=');
        system.debug('******TOLLFREE*******'+tollfree); 
        
        Response response =new Response();
        List<Lead> leadList = new List<Lead>();
        leadList = [select id, name, phone, WT_Agent__c, WT_Agent__r.Name, WT_Agent__r.Email from lead where phone =: ph and IsConverted=False order by CreatedDate Desc limit 1];
        system.debug('******leadList *******'+leadList ); 
        if(leadList.size() > 0) {
            for(Lead l : leadList) {
                if(l.WT_Agent__c != null || l.WT_Agent__r.Name != 'Cloud Agent') {
                    Response.AgentID = l.WT_Agent__r.Email;
                    Response.CallerNumber = l.phone;
                    Response.CalledNumber = tollfree;
                    Response.message = 'Lead Exists';
                    Response.success_code = '200';
                }
            }
        }
        else {
            Response.AgentID = '';
            Response.CallerNumber = '';
            Response.CalledNumber = tollfree;
            Response.message = 'Lead Does not Exist';
            Response.success_code = '501';
        }
        
        string json_data = json.serialize(response);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(json_data); 
            
    }
    
     Private class Response
        {
          String message;
          String AgentID;
          String CalledNumber;
          String CallerNumber;
          String success_code;
        }
}