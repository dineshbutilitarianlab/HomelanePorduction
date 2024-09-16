@RestResource(urlMapping='/UpdateSMDM/*')
global class Rest_UpdateSM_DM{

    @HttpPost
    global static void  Rest_UpdateSM_DM(){
        
        RestRequest req = RestContext.request;
         Http http = new Http();
        RestContext.response.addHeader('Content-Type', 'application/json');
        rosterResponse wrapper = new rosterResponse();
        List<String> lstEmaillst = new List<String>();
        List<String> lstDpEmaillst = new List<String>();
        List<User> lstUser = new List<User>();
        List<Showroom_User__c> lstShowroomUser = new List<Showroom_User__c>();
        List<Interior_Designer__c> lstInteriorDesigner = new List<Interior_Designer__c>();
        Map<String,User> mapUSerEmail = new Map<String,User>();
        lead objLead = new lead();
        Boolean bSMError = false;
        Boolean bDpError = false;
        Opportunity objOpp = new Opportunity();
       
        try
        {
            system.debug('req'+req);
            wrapper = (rosterResponse) JSON.deserialize(req.requestBody.toString(),rosterResponse.class);
            system.debug('wrapper'+wrapper);
            if(wrapper != NULL){
                if(String.isNotBlank(wrapper.recordId) && String.isNotBlank(wrapper.type)){
                    if(String.isNotBlank(wrapper.smEmail)){
                        lstEmaillst.add(wrapper.smEmail);
                    }
                    if(String.isNotBlank(wrapper.dpEmail)){
                        lstDpEmaillst.add(wrapper.dpEmail);
                    }

                    if(lstEmaillst!= NULL && !lstEmaillst.isEmpty()){
                        
                        lstShowroomUser = [Select Name,email__C from Showroom_User__c where email__C IN: lstEmaillst Limit 1];
                        
                        system.debug('===lstShowroomUser ====='+lstUser);
                        if(lstShowroomUser.isEmpty() || lstShowroomUser== NULL){
                            bSMError = true;
                        }
                    }

                    if(lstDpEmaillst != NULL && !lstDpEmaillst.isEmpty()){
                        lstInteriorDesigner = [Select name,id,Email__c,OwnerID from Interior_Designer__c where Email__c IN: lstDpEmaillst  Limit 1];
                        system.debug('===lstInteriorDesigner====='+lstInteriorDesigner);
                        if(lstInteriorDesigner.isEmpty()){
                            bDpError =true;
                            
                        }
                    }

                    if(!bDpError && !bSMError){
                        if(wrapper.type == 'Lead'){
                            
                            objLead =[Select id,name,Square_Showroom_Agent__c ,Interior_Designer__c,OwnerID,Sales_Manager__c from lead 
                                        where Id =: wrapper.recordId limit 1];
                            
                            objLead.Interior_Designer__c = (lstInteriorDesigner!= NULL && !lstInteriorDesigner.isEmpty())?lstInteriorDesigner[0].id:objLead.Interior_Designer__c;
                            objLead.Sales_Manager__c = (lstShowroomUser!= NULL && !lstShowroomUser.isEmpty())?lstShowroomUser[0].id:objLead.Sales_Manager__c;
                            //objLead.OwnerID = (lstUser!= NULL && !lstUser.isEmpty())?lstUser[0].id:objLead.OwnerID;
                            update objLead;
                            responseWrapper response = new responseWrapper(true,'');
                            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(response));
                        }
                        else{
                            
                            objOpp =[Select id,name,Square_Showroom_Agent__c,Interior_Design_Partner__c,OwnerID,Sales_Manager__c from Opportunity 
                                        where Id =: wrapper.recordId limit 1];
                            
                            objOpp.Interior_Design_Partner__c = (lstInteriorDesigner!= NULL && !lstInteriorDesigner.isEmpty())?lstInteriorDesigner[0].id:objOpp.Interior_Design_Partner__c;
                            objOpp.Sales_Manager__c = (lstShowroomUser!= NULL && !lstShowroomUser.isEmpty())?lstShowroomUser[0].id:objOpp.Sales_Manager__c;
                            
                            update objOpp;
                            responseWrapper response = new responseWrapper(true,'');
                            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(response));
                        }
                    System.debug('objLead'+objLead);
                    System.debug('objOpp'+objOpp);
                    }
                    else{
                        responseWrapper response =new  responseWrapper(False,'Please Check DP or SM Email ID');
                        RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(response));
                    }
                }  
                else{
                responseWrapper response =new  responseWrapper(False,'Record Id not present or type is not defined');
                RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(response));
                }
            }
            //return NULL;
        }
        catch(Exception e){
            Logger.log('Exception','Rest_UpdateSM_ASM','Rest_UpdateSM_ASM',e.getMessage(),e.getStackTraceString(),NULL);
            responseWrapper response = new responseWrapper(false,e.getMessage());
            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(response));
        }
    }

    public class rosterResponse{
        public String recordId;
        public String type;
        public String smEmail;
        public String dpEmail;

    }

    public class responseWrapper{
        public Boolean status;
        public String Error;
        
        public responseWrapper(Boolean bStatus,String sError ){
            this.status = bStatus;
            this.Error = sError;
        }
    }    
}