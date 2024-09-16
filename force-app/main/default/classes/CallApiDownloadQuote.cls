public class CallApiDownloadQuote{

    public String catchURL;
    public static Map<String,Object> firstLevelartifactsListMap  = new Map<String,Object>();
    public static Map<String,Object> secondLevelartifactsListMap = new Map<String,Object>();
    public static String S3URL;

    public PageReference CallApiDownloadAction() {
        catchURL = ApexPages.currentPage().getParameters().get('elementId');
        System.debug('catchURL : '+catchURL);

        String fileName = catchURL.substring( 0 , catchURL.IndexOf('?') );
        String fileN = catchURL.substring( 0 , catchURL.IndexOf('/') );

        System.debug('fileName : fileName : '+fileName);
        System.debug('fileN : fileN : '+fileN);

        fileName = fileName.replace('phoenixartifacts-stage.s3.amazonaws.com', 'stage-artifactservice.homelane.com/v1');
        fileName = fileName.replace('quotations', 'artifacts/quotations');

        System.debug('fileName : fileName : '+fileName);

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint(fileName);
        req.setMethod('GET');
        
        //req.setCompressed(true); // otherwise we hit a limit of 32000
        try {
            res = http.send(req);
            System.debug(res.getBody());
        } catch(System.CalloutException e) {
          System.debug('Callout error: '+ e);
          System.debug(res.toString());
        }


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
                        S3URL = (String)secondLevelartifactsListMap.get('url'); 
                   }
             
            system.debug('*** S3URL is '+S3URL );
           }
                    

        PageReference pageRef = new PageReference(S3URL);
        pageRef.setRedirect(true);
        return pageRef;
    }
}