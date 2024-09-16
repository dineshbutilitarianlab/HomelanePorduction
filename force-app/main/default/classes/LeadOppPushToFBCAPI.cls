global class LeadOppPushToFBCAPI Implements Queueable{
    private List<String> listOfJSON;
    
global LeadOppPushToFBCAPI (List<String> listOfJSON) {
        this.listOfJSON = listOfJSON;
        
        
    }
     global void execute(QueueableContext QC) {
        if(!listOfJSON.isEmpty() ){
           callFBCAPIFuture(listOfJSON);
        }
    }
    @future(callout=true)
    public static void callFBCAPIFuture(List<String> listOfJSON){
        if( !listOfJSON.isEmpty()){
            calloutToFBAPI(listOfJSON);
        }
    }
    Public Static void calloutToFBAPI(List<String> listOfJSON){
        try{
        if(!listOfJSON.isEmpty()){
            
                  Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                Integration_Setting__c integrationDetail = allEndPoint.get('Facebook CAPI');
           
                for(String body: listOfJSON){
                    if(!String.isBlank(body)){
                        if(Limits.getCallouts() < Limits.getLimitCallouts()){
                            Http http = new Http();
                            HttpRequest request = new HttpRequest();
                            Httpresponse response = new Httpresponse();
                            
                            request.setMethod('POST');
                            request.setBody(body);
                            request.setHeader('Content-Type', integrationDetail.ContentType__c);
                            
                            request.setEndPoint(integrationDetail.End_Point__c);
                            
                            System.debug('request: '+request);
                            System.debug('request body: '+body);
                            
                            response = http.send(request);
                            System.debug('response: '+response);
                            
                            
                            
                            String resJson;
                            if(response.getStatusCode()==200){
                                resJson = response.getBody();
                                System.debug('response.getStatusCode(): '+response.getStatusCode());
                                System.debug('resJson: '+resJson);
                                
                                
                                
                            }
                            else{
                                System.debug('response.getStatusCode(): '+response.getStatusCode());
                                Logger.log('Error','LeadOppPushToFBCAPI class','calloutToFBAPI method','Status code error',String.ValueOf(response.getStatusCode()),null);
                            }
                        }
                        else{
                            System.debug('API callouts limit hit. Limits.getCallouts(): '+Limits.getCallouts());
                            Logger.log('Error','LeadOppPushToFBCAPI class','calloutToFBAPI method','API callouts limit hit. Limits.getCallouts(): '+Limits.getCallouts(),'',null);
                        }
                    }
                    else{
                        System.debug('blank body');
                        System.debug('body: '+body);
                        Logger.log('Error','LeadOppPushToFBCAPI class','calloutToFBAPI method','blank body error','',null);
                    }
                }
                
            }
            else{
                System.debug('empty listOfJSON: '+listOfJSON);
                Logger.log('Error','LeadOppPushToFBCAPI class','calloutToFBAPI method','empty listOfJSON:','',null);
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception','LeadOppPushToFBCAPI class','calloutToFBAPI method',e.getMessage(),e.getStackTraceString(),null);
        }
                
    }
}