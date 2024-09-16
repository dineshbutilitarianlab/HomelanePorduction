global class CallSMSAPIController {
    
    public static String urlCatch;
    
     public static Boolean shouldProcessAsync() {
        return !system.isFuture() && !system.isBatch() && Limits.getLimitFutureCalls() > Limits.getFutureCalls();
     }
    
     @future(callout=true)
     global static void makeSortUrl(String str, Id LeadId) {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.homelane.com/apis/quotes/generateTinyUrl?');
        String strJson = EncodingUtil.urlDecode('share_link=https://www.homelane.com/?email=' +str+ '&utm_source=email&utm_medium=email&utm_campaign=openChat','UTF-8');
        String jsonModified = strJson.replaceall('&','%26');
        System.debug('******strJson  '+strJson);
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setBody(jsonModified);        
        request.setHeader('Accept', 'application/x-www-form-urlencoded');
        System.debug('REQUEST   '+request);
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
        List<Lead> listToUpdate = new List<Lead>();
        for(Lead leadObj :[Select Id,Name,Tiny_URL_Generate__c,Email,Phone from Lead Where Id =: LeadId]){ 
           leadObj.Tiny_URL_Generate__c = urlCatch;
           System.debug('*****leadObj.Tiny_URL_Generate__c '+leadObj.Tiny_URL_Generate__c);
           listToUpdate.add(leadObj);
        }
        System.debug('*****listToUpdate '+listToUpdate);
        update listToUpdate;  
        }
        catch(TypeException e)    {
            String err = 'The error is : '+e.getMessage();
        } 
    }     
         
   @InvocableMethod
   global static void CallSMSAPI(List<Id> LeadIds) {
       if (shouldProcessAsync()) {
       try {
         Lead l = [Select Id,Name,Tiny_URL_Generate__c,Email,Phone from Lead Where Id =: LeadIds limit 1];
               makeSortUrl(l.Email,l.id);
               }
               catch(QueryException e ) {
                   System.debug('Lead row is not found for Tiny URL');
               }
           
       }
   }  
   
  

}