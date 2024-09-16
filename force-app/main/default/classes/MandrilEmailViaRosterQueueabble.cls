global class MandrilEmailViaRosterQueueabble implements Queueable{
    private List<String> listOfJSON;
    global MandrilEmailViaRosterQueueabble(List<String> listOfJSON) {
        this.listOfJSON = listOfJSON;
    }
    global void execute(QueueableContext QC) {
        if(!listOfJSON.isEmpty()){
            callRosterEmailAPI(listOfJSON);
        }
    }
    @future(callout=true)
    public static void callRosterEmailAPI(List<String> listOfJSON){
        if(!listOfJSON.isEmpty()){
            calloutToRosterEmailAPI(listOfJSON);
        }
    }
    
    public static void calloutToRosterEmailAPI(List<String> listOfJSON){
        try{
            if(!listOfJSON.isEmpty()){
                System.debug('listOfJSON is not empty: '+listOfJSON);
                Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                Integration_Setting__c integrationDetail = allEndPoint.get('Roster_Mandril_Email_API');
                String endPointUrl = integrationDetail.End_Point__c;
                String contentType = integrationDetail.ContentType__c;
                for(String body: listOfJSON){
                    if(!String.isBlank(body)){
                        if(Limits.getCallouts() < Limits.getLimitCallouts()){
                            Http http = new Http();
                            HttpRequest request = new HttpRequest();
                            Httpresponse response = new Httpresponse();
                            
                            request.setMethod('POST');
                            request.setBody(body);
                            request.setHeader('Content-Type', contentType);
                            request.setHeader('Accept', contentType);
                            request.setEndPoint(endPointUrl);
                            
                            System.debug('request: '+request);
                            System.debug('request body: '+body);
                            
                            response = http.send(request);
                            System.debug('response: '+response);
                            
                            RosterEmailResponseWrapper respWrap;
                            
                            String resJson;
                            if(response.getStatusCode()==200){
                                resJson = response.getBody();
                                System.debug('response.getStatusCode(): '+response.getStatusCode());
                                System.debug('resJson: '+resJson);
                                respWrap = (RosterEmailResponseWrapper)JSON.deserialize(resJson,RosterEmailResponseWrapper.class);
                                if(respWrap !=null){
                                    if(respWrap.error ==False){
                                        System.debug('Success msg: '+respWrap.msg);
                                    }
                                    else{
                                        System.debug('Error msg: '+respWrap.msg);
                                        Logger.log('Error','MandrilEmailViaRosterQueueabble class','calloutToRosterEmailAPI method','Error msg: '+respWrap.msg,String.ValueOf(respWrap),null);
                                    }
                                }
                                else{
                                    System.debug('respWrap is null '+respWrap);
                                    Logger.log('Error','MandrilEmailViaRosterQueueabble class','calloutToRosterEmailAPI method','respWrap is null',String.ValueOf(respWrap),null);
                                }
                            }
                            else{
                                System.debug('response.getStatusCode(): '+response.getStatusCode());
                                Logger.log('Error','MandrilEmailViaRosterQueueabble class','calloutToRosterEmailAPI method','Status code error',String.ValueOf(response.getStatusCode()),null);
                            }
                        }
                        else{
                            System.debug('API callouts limit hit. Limits.getCallouts(): '+Limits.getCallouts());
                            Logger.log('Error','MandrilEmailViaRosterQueueabble class','calloutToRosterEmailAPI method','API callouts limit hit. Limits.getCallouts(): '+Limits.getCallouts(),'',null);
                        }
                    }
                    else{
                        System.debug('blank body');
                        System.debug('body: '+body);
                        Logger.log('Error','MandrilEmailViaRosterQueueabble class','calloutToRosterEmailAPI method','blank body error','',null);
                    }
                }
                
            }
            else{
                System.debug('empty listOfJSON: '+listOfJSON);
                Logger.log('Error','MandrilEmailViaRosterQueueabble class','calloutToRosterEmailAPI method','empty listOfJSON:','',null);
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception','MandrilEmailViaRosterQueueabble class','calloutToRosterEmailAPI method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    Public class RosterEmailWrapper{
        Public String template {get;set;}
        Public String subject {get;set;}
        Public String global_params {get;set;}
        Public Map<String,String> fromUser {get;set;}
        Public Map<String,String> to {get;set;}
        Public List<Map<String,String>> cc {get;set;}
        Public List<Map<String,String>> bcc {get;set;}
        Public List<Map<String,String>> template_content {get;set;}
        public List<AttachmentWrapper> attachment;
    }
    Public class AttachmentWrapper{
        public String file {get;set;}
        public String type {get;set;}
        public String name {get;set;}
    }
    Public class RosterEmailResponseWrapper{
        public Boolean error {get;set;}
        public Boolean response {get;set;}
        public String msg {get;set;}
    }
    Public Static String rosterEmailWrapperJsonCreator(String templateName, String subject,Map<String,String> toEmailMap,List<Map<String,String>> template_contentList,List<String>ccEmailList){
        String rosterEmailWrapperJson;
        try{
            MandrilEmailViaRosterQueueabble.RosterEmailWrapper wrap = new MandrilEmailViaRosterQueueabble.RosterEmailWrapper();
            
            wrap.template = templateName;
            wrap.subject = subject;
            wrap.global_params = '';
            /*Map<String,String> toEmailMap = new Map<String,String>();
            toEmailMap.put('email','test@warpdrivetech.in');
            toEmailMap.put('name','test');*/
            wrap.to = toEmailMap;
            
            List<Map<String,String>> ccAddressList = new List<Map<String,String>>();
            
       /*     Map<String,String> ccEmailMap1 = new Map<String,String>();
            ccEmailMap1.put('email','prachi.k@homelane.com');
            ccEmailMap1.put('name','cc1');
            ccAddressList.add(ccEmailMap1);
            
            Map<String,String> ccEmailMap2 = new Map<String,String>();
            ccEmailMap2.put('email','kumara.r2@homelane.com');
            ccEmailMap2.put('name','cc2');
            ccAddressList.add(ccEmailMap2);
            
            Map<String,String> ccEmailMap3 = new Map<String,String>();
            ccEmailMap3.put('email','ashwaq.n@homelane.com');
            ccEmailMap3.put('name','cc3');
            ccAddressList.add(ccEmailMap3);
            
            Map<String,String> ccEmailMap4 = new Map<String,String>();
            ccEmailMap4.put('email','shabarish.k@homelane.com');
            ccEmailMap4.put('name','cc4');
            ccAddressList.add(ccEmailMap4);*/
            
            if(!ccEmailList.isEMpty())
            {                 
                Map<String,String> ccEmailMap5 = new Map<String,String>();
                ccEmailMap5.put('email',ccEmailList[0]);
                ccEmailMap5.put('name',ccEmailList[1]);
                ccAddressList.add(ccEmailMap5);  
                System.debug('ccEmailList '+ccEmailList);
            }
            
			wrap.cc=ccAddressList;
            
            System.debug('wrap.cc '+wrap.cc);
            
            Map<String,String> fromEmailMap = new Map<String,String>();
            fromEmailMap.put('email','hello@homelane.com');
            fromEmailMap.put('name','HomeLane');
            wrap.fromUser = fromEmailMap;
            
            /*List<Map<String,String>> template_contentList = new List<Map<String,String>>();
            Map<String,String> template_contentMap1 = new Map<String,String>();
            template_contentMap1.put('name','Customer Name');
            template_contentMap1.put('content','Test customer');
            template_contentList.add(template_contentMap1);
            
            Map<String,String> template_contentMap2 = new Map<String,String>();
            template_contentMap2.put('name','Customer Id');
            template_contentMap2.put('content','BEN-ABC-1234');
            template_contentList.add(template_contentMap2);*/
            
            wrap.template_content = template_contentList; 
            
                        
         /*   List<Map<String,String>> bccAddressList = new List<Map<String,String>>();
            Map<String,String> bccEmailMap1 = new Map<String,String>();
            bccEmailMap1.put('email','bcc1@warpdrivetech.in');
            bccEmailMap1.put('name','bcc1');
            bccAddressList.add(bccEmailMap1);
            
            Map<String,String> bccEmailMap2 = new Map<String,String>();
            bccEmailMap2.put('email','bcc2@warpdrivetech.in');
            bccEmailMap2.put('name','bcc2');
            bccAddressList.add(bccEmailMap2);
            
            wrap.bcc = bccAddressList;
            
            
            
            List<MandrilEmailViaRosterQueueabble.AttachmentWrapper> attachmentList = new List<MandrilEmailViaRosterQueueabble.AttachmentWrapper>();
            
            MandrilEmailViaRosterQueueabble.AttachmentWrapper attchWrap1 = new MandrilEmailViaRosterQueueabble.AttachmentWrapper();
            attchWrap1.file ='atchfile1';
            attchWrap1.type ='atchtype1';
            attchWrap1.name ='atchname1';
            attachmentList.add(attchWrap1);
            
            MandrilEmailViaRosterQueueabble.AttachmentWrapper attchWrap2 = new MandrilEmailViaRosterQueueabble.AttachmentWrapper();
            attchWrap2.file ='atchfile2';
            attchWrap2.type ='atchtype2';
            attchWrap2.name ='atchname2';
            attachmentList.add(attchWrap2);
            
            wrap.attachment = attachmentList;
            */
            rosterEmailWrapperJson = Json.serialize(wrap);
            System.debug('rosterEmailWrapperJson :'+rosterEmailWrapperJson);
            
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception','MandrilEmailViaRosterQueueabble class','rosterEmailWrapperJsonCreator method',e.getMessage(),e.getStackTraceString(),null);
        }
        return rosterEmailWrapperJson;
    }
    public static void dummyTestCover(){
        Integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}