public class IMAttendanceUpdateAPIQueueable implements Queueable, Database.AllowsCallouts {
    private Integer isCheckAttendance;
    
    public IMAttendanceUpdateAPIQueueable(){
    }
    public IMAttendanceUpdateAPIQueueable(Integer isCheckAttendance){
        this.isCheckAttendance = isCheckAttendance;
    }
    public void execute(QueueableContext qc) {
        UpdateShowroomUserAttendance();
    }
    public void UpdateShowroomUserAttendance(){
        try{
            //To get the auth token
            String authToken = getAccessTokenFromAuth();
            system.debug('authToken  ' + authToken);
            
           Map<String,boolean>  attMap = new Map<String,boolean>(); 
            if(String.isNotBlank(authToken)){
                
                System.debug('ischeckatten. '+isCheckAttendance );
                //To get the IRM Attendance details
                
               attMap = getIRMAttendanceAPICallout(authToken,isCheckAttendance);
                
                 system.debug('map ' + attMap);
                //Update the IRM/Showroom user record.
                if(!attMap.isEmpty()){
                    List<Showroom_User__C> showRoomUserListToUpdate = new List<Showroom_User__C>();
                    showRoomUserListToUpdate = [select Id,Email__c,IsActive__c,Name from Showroom_User__C where Email__c IN : attMap.keySet()];
                    if(!showRoomUserListToUpdate.isEmpty()){
                        for(Showroom_User__c sru : showRoomUserListToUpdate){
                            if(attMap.containsKey(sru.Email__c)){
                                sru.IsActive__c = attMap.get(sru.Email__c);
                            }
                        }
                        update showRoomUserListToUpdate;
                        System.Debug(showRoomUserListToUpdate);
                    }
                }
                else{
                    Logger.log('Error','IMAttendanceUpdateAPIQueueable class','UpdateShowroomUserAttendance method','Empty IM map returned in the API response','','');
                }
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception','IMAttendanceUpdateAPIQueueable class','UpdateShowroomUserAttendance method',e.getMessage(),e.getStackTraceString(),'');
        }
        
    }
    
    public static String getAccessTokenFromAuth(){
        String token = '';
        try
        {
            Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
            Integration_Setting__c integrationDetail = allEndPoint.get('DarwinBOX Auth Token');
            System.debug('integrationDetail'+ integrationDetail);
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(integrationDetail.End_Point__c);
            String body  = '{"username":"'+integrationDetail.Username__c +'","password":"'+integrationDetail.Password__c +'"}';
            
            req.setBody(body);
            req.setHeader('Content-Type', integrationDetail.ContentType__c);
            System.debug('request'+ req);
            System.debug('request Body'+ req.getBody());
            Http http = new Http();
            
            HTTPResponse response = http.send(req);     
            System.debug('Body ' + response.getBody());
            System.debug('Status ' + response.getStatus());
            if(response.getStatusCode() == 200){
                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                if(!results.isEmpty()){
                    if(results.get('access_token') != null ){
                        token = (String)results.get('access_token');
                    }
                    else{
                        Logger.log('Error','IMAttendanceUpdateAPIQueueable class','getAccessTokenFromAuth method','Empty access token from API',String.ValueOf(results.get('message')),'');
                    }
                }
                else{
                    //Log response body empty while deserialize error
                    Logger.log('Error','IMAttendanceUpdateAPIQueueable class','getAccessTokenFromAuth method','response body empty while deserialize','','');
                }
            }
            else{
                //Log response code error
                Logger.log('Error','IMAttendanceUpdateAPIQueueable class','getAccessTokenFromAuth method','Status code error',String.ValueOf(response.getStatusCode()),'');
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception','IMAttendanceUpdateAPIQueueable class','getAccessTokenFromAuth method',e.getMessage(),e.getStackTraceString(),'');
        }
        System.debug('main classs' + token);
        return token;
    }
    
    public static Map<String,boolean> getIRMAttendanceAPICallout(String accessToken , Integer isCheckAttendance){
        Map<String,boolean> attMap = new Map<String,boolean>(); 
        
        
        try{
            if( String.isNotBlank(accessToken) && isCheckAttendance!=Null){
                Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                Integration_Setting__c integrationDetail = allEndPoint.get('DarwinBOX IRM Attendance_API');
                
                String endPointUrl = integrationDetail.End_Point__c+'?is_check_attendence='+isCheckAttendance;
                System.debug('endpoint '+ endPointUrl);
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setMethod('GET');
                request.setHeader('Authorization','Bearer '+ accessToken);
                request.setEndpoint(endpointURL);
               
                
                HttpResponse response = http.send(request);
                
                system.debug(response);
                if(response.getstatusCode() == 200 && response.getbody() != null){
                    AttendanceResponseWrapper  responseWrap;
                    responseWrap = (AttendanceResponseWrapper)JSON.deserialize(response.getBody(),AttendanceResponseWrapper.class);
                    //Map<String,boolean> attMap;
                    if(responseWrap!=null){
                        if(responseWrap.error == false){
                            attMap = responseWrap.response;
                            System.debug('attMap'+ attMap);
                        }
                        else{
                            Logger.log('Error','IMAttendanceUpdateAPIQueueable class','getIRMAttendanceAPICallout method','responseWrap error param true',responseWrap.message,'');
                        }
                    }
                    else{
                        //responseWrap is null
                        System.debug('respWrap is null.');
                        Logger.log('Error','IMAttendanceUpdateAPIQueueable class','getIRMAttendanceAPICallout method','responseWrap is null','','');
                    } 
                }
                else{
                    Logger.log('Error','IMAttendanceUpdateAPIQueueable class','getIRMAttendanceAPICallout method','Status code error',String.ValueOf(response.getStatusCode()),'');
                }
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception','IMAttendanceUpdateAPIQueueable class','getIRMAttendanceAPICallout method',e.getMessage(),e.getStackTraceString(),'');
        }
        return attMap;
    }
    public class AttendanceResponseWrapper{
        public Boolean error;
        public Map<String,Boolean> response;
        public String message;
        
    }

}