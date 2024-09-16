global class CallOutToR_Function{

    /*********************************************************************************************************  
    * Name: callFunction
    * Description : Call R function When Master is created 
    *=============================== Modification Log ================================
    * Balaji    ----- 18/06/2019 -------- Replace Space with %20 in URL since space was getting removed from when R function gets it 
    *********************************************************************************************************/ 
     @future(callout=true)
     global static void callFunction(String sID) {
         Lead objLead = new Lead();
         try{
            list<responseWrapper> lstResponse = new list<responseWrapper>();
            responseWrapper res = new responseWrapper(); 
            list<Master__c> lstMasterUpdate = new list<Master__c>();
            list<Master__c> lstMaster = new list<Master__c>();
            String sEndPoint;
            Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
            Integration_Setting__c integrationDetail = allEndPoint.get('R API');

             if(String.IsNotBlank(sID)){
                  objLead = [Select id,name,Property__c,Property__r.name From Lead where id =:sID Limit 1];
                  System.debug('---objLead---'+objLead);
                  if(objLead != NULL && String.isNotBlank(objLead.Property__r.name)){
                    
                    sEndPoint = integrationDetail.End_Point__c+'?q='+objLead.Property__r.name.replaceAll(' ','%20'); 
                    Http http = new Http();
                    HttpRequest request = new HttpRequest();
                    request.setMethod('GET');
                    request.setEndpoint(sEndPoint);
                    request.setTimeout(120000); 
                    
                    
                    System.debug('request'+request);
                    
                    HttpResponse response = http.send(request);
                    System.debug('RESPONSE   '+response);

                    
                    if(response.getStatusCode() == 200){
                        System.debug('------Response----'+response.getBody());
                        String sBody = response.getBody();
                        lstResponse = (List<responseWrapper>)JSON.deserialize(sBody,List<responseWrapper>.class);
                        System.debug('------Response----'+lstResponse);
                        if(String.isNotBlank(lstResponse[0].matchedpropID) && lstResponse[0].matchScore<=0.8){
                            master__c oldMaster = new master__c();
                            
                            lstMaster = [Select id from Master__c where id =: lstResponse[0].matchedpropID limit 1];
                            System.debug('lstMaster'+lstMaster[0].id);
                            System.debug('lstResponse[0].matchedpropID'+lstResponse[0].matchedpropID);
                            if(lstMaster!= NULL && !lstMaster.isEmpty()){
                                if(!(String.ValueOf(lstMaster[0].id).equalsIgnoreCase(objLead.Property__c))){
                                    oldMaster.id = objLead.Property__c;
                                    oldMaster.Verification_Status__c = 'To be Deleted';
                                    lstMasterUpdate.add(oldMaster);
                                    
                                    objLead.Property__c = lstMaster[0].id;
                                    lstMasterUpdate.add(lstMaster[0]);
                              
                                    
                                    if(lstMasterUpdate != NULL && !lstMasterUpdate.isEmpty()){
                                        update lstMasterUpdate;
                                        update objLead;
                                    }
                                }
                            }
                            else{
                                Logger.log('Error','CallOutToR_Function','callFunction','New id not found',sBody,objLead.id);
                            }    
                        }
                        else{
                             Logger.log('Error','CallOutToR_Function','callFunction','matchedpropID is not Present',sBody,NULL);
                        }
                     }  
                   else{
                       Logger.log('Error','CallOutToR_Function','callFunction','Status Error',String.ValueOf(response.getStatusCode()),NULL);
                     }
                 }
             }
         }
         Catch(Exception e){
             System.debug('Exception'+e.getMessage()+ ' Stack '+ e.getStackTraceString());
             Logger.log('Exception','CallOutToR_Function','callFunction',e.getMessage(),e.getStackTraceString(),objLead.id);
         }    
     
     }
     
   public class responseWrapper{
        public String matchedpropID{get;set;}
        public Double matchScore{get;set;}
        public String matchedpropName{get;set;}
   }
 

}