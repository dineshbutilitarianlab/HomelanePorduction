/*
 *Author: Venkat Arisa
 *Version: 1
 *Date 6/29/2016
 */

public class AWSCallout{

    public static Map<String,Object> firstLevelartifactsListMap  = new Map<String,Object>();
    public static Map<String,Object> secondLevelartifactsListMap = new Map<String,Object>();
    public static String S3URL;
     public static String customsettingURL;
    
    public static String getS3URL(String opptynumber) {
    
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
       AWSArtifactS3URL__c artificatURL= AWSArtifactS3URL__c.getValues('AWSS3URL'); 
        if(null != artificatURL.S3_URL__c){
           customsettingURL = artificatURL.S3_URL__c;
         } 
         
         system.debug('*** customsettingURL '+customsettingURL);
         customsettingURL = customsettingURL +opptynumber + '/artifacts/quotations';
         system.debug('*** customsettingURLafterconcatenation '+customsettingURL);
        
                 /* String URL= 'https://dev-artifactservice.homelane.com/v1/customers/';
                   URL =  customsettingURL + opptynumber + '/artifacts/quotations';
                   system.debug('//////////////////'+URL); */
        
        req.setEndpoint(customsettingURL);
        req.setMethod('GET');
       // req.setHeader('Content-Type', 'application/x-www-form-urlencoded'); 

        //req.setBody('');
        //req.setCompressed(true); // otherwise we hit a limit of 32000


        try {
            res = http.send(req);
           } catch(System.CalloutException e) {
              System.debug('Callout error: '+ e);
              System.debug(res.toString());
           }

        system.debug('*** res '+res.getbody());
    
      if('' != res.getbody()){
            Map<String, Object> JSON_Input = (Map<String, Object>)JSON.deserializeUntyped(res.getbody());
            system.debug('*** JSON_Input '+JSON_Input.get('artifacts'));
            
             firstLevelartifactsListMap = (Map<String, Object>)JSON_Input.get('artifacts');
             system.debug('**** In firstLevelartifactsMap '+ firstLevelartifactsListMap );
    
            Decimal lastmodified ;
            Decimal FinalValue = null;
            List<Object> firstLevelartifactsList = (List<Object>)firstLevelartifactsListMap.get('artifact');
             system.debug('**** In firstLevelartifactsList '+ firstLevelartifactsList );
              for (Object item : firstLevelartifactsList) {
                     secondLevelartifactsListMap = (Map<String, Object>)item;
                     
                      lastmodified = (Decimal)secondLevelartifactsListMap.get('lastmodified');
                      if(null == FinalValue ){
                        FinalValue = (Decimal)secondLevelartifactsListMap.get('lastmodified');
                      }
                     
                     system.debug(' lastmodified *** '+lastmodified+' *** FinalValue '+FinalValue );
                     if(lastmodified >= FinalValue ){
                        S3URL = (String)secondLevelartifactsListMap.get('url'); 
                     }

                  }
             
            system.debug('*** S3URL is '+S3URL );
            
           /* S3URL = (String)secondLevelartifactsListMap.get('url');
             system.debug('**** In S3URL '+S3URL); */
             
           }
                return S3URL;

      }

  }