/**
* @File Name          : CallOutToAddressInfoAPI.cls
* @Description        : 
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 9/10/2019, 1:28:34 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author      		      Modification
*==============================================================================
* 1.0    9/10/2019, 12:03:02 PM   Bharatesh Shetty     Initial Version
**/
Public class CallOutToAddressInfoAPI{
    
    private static HTTPResponse oauthLogin(String loginUri, String clientId,String clientSecret, String username, String password) {
        HttpRequest req = new HttpRequest(); 
        
        req.setMethod('POST');
        req.setEndpoint(loginUri+'/services/oauth2/token');
        req.setBody('grant_type=password' +
                    '&client_id=' + clientId +
                    '&client_secret=' + clientSecret +
                    '&username=' + EncodingUtil.urlEncode(username, 'UTF-8') +
                    '&password=' + EncodingUtil.urlEncode(password, 'UTF-8'));
        
        Http http = new Http();
        System.debug('BODYBODY: '+req.getBody());
        HTTPResponse res = http.send(req);
        
        System.debug('BODY: '+res.getBody());
        System.debug('STATUS:'+res.getStatus());
        System.debug('STATUS_CODE:'+res.getStatusCode());
        
        return res;
    }
    
    public static String callAddressInfoAPI(String sBody) {
        String result;
        System.debug('callAddressInfoAPI method called');
        try{
            
            //String accessToken = UserInfo.getSessionId();
            //String instanceUrl = URL.getSalesforceBaseUrl().toExternalForm();
            /*HTTPResponse respons = oauthLogin('https://homelane--hlprod.cs72.my.salesforce.com',
'3MVG910YPh8zrcR1yVy5MQ5lXnT3TZZJZQxeLVgfwBN_p8w4MggN63YCe9ZXRwxeFu5P6JUkEIJq3JWPQodcK',
'3576553059075121271', 
'tanuj@homelane.com.hlprod', 
'homelane321');*/
            Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
            Integration_Setting__c integrationDetail = allEndPoint.get('Salesforce Login');
            HTTPResponse respons = oauthLogin(integrationDetail.End_Point__c,integrationDetail.Client_Id__c,integrationDetail.Secret_Key__c,integrationDetail.Username__c,integrationDetail.Password__c);
            deserializeResponse resp1= (deserializeResponse)JSON.deserialize(respons.getBody(),deserializeResponse.class);   
            system.debug('resp1'+resp1);                             
            //String response = JSON.serializePretty( JSON.deserializeUntyped(respons.getBody()) );
            String accessToken = resp1.access_token;
            String instanceUrl = resp1.instance_url;
            HttpRequest req = new HttpRequest(); 
            
            req.setMethod('POST');
            req.setHeader('Content-Type',integrationDetail.ContentType__c);
            req.setEndpoint(integrationDetail.End_Point__c+'/services/apexrest/AddressInfoAPI');
            req.setHeader('Authorization', 'Bearer '+accessToken);
            //req.setBody(json.serialize(sBody));
            req.setBody(sBody);
            
            Http http = new Http();
            system.debug('req.setBody'+req.getBody());
            system.debug('req.setBody'+req.getHeader('Authorization'));
            system.debug('UserInfo.getName()'+UserInfo.getName());
            
            HTTPResponse res = http.send(req);
            
            if(res.getStatusCode()==200){
                String resJson = res.getBody();
                List<ResponseWrapper> ListOfResponseWrapper = (List<ResponseWrapper>)JSON.deserialize(resJson,List<ResponseWrapper>.class);
                if(ListOfResponseWrapper[0].status){
                    result = 'Success';
                    System.debug('Error Message: '+ListOfResponseWrapper[0].errorMsg);
                    System.debug('STATUS:'+ListOfResponseWrapper[0].status);
                }
                else{
                    result = 'Fail';
                    System.debug('Error Message: '+ListOfResponseWrapper[0].errorMsg);
                    System.debug('STATUS:'+ListOfResponseWrapper[0].status);
                    System.debug('STATUS_CODE:'+res.getStatusCode());
                    Logger.log('Error','CallOutToAddressInfoAPI','callAddressInfoAPI method','Status Error',ListOfResponseWrapper[0].errorMsg,null);
                }  
            }
            else{
                System.debug('STATUS_CODE:'+res.getStatusCode());
                Logger.log('Error','CallOutToAddressInfoAPI','callAddressInfoAPI method','Status code Error',String.ValueOf(res.getStatusCode()),null);
                result = 'Fail';
            } 
            
        }
        catch(Exception e){
            System.debug('Exception :'+e.getMessage()+ ' --- Stack :'+ e.getStackTraceString());
            Logger.log('Exception','CallOutToAddressInfoAPI class','callAddressInfoAPI method',e.getMessage(),e.getStackTraceString(),null);
            result = 'Exception';
        } 
        return result;
    }
    public class ResponseWrapper {
        public boolean status;
        public String errorMsg;
    }
    public class deserializeResponse {
        public String id;
        public String access_token;
        Public String instance_url;
    }
    
}