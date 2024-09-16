global class ChangeDPRestAPI implements Queueable,Database.AllowsCallouts {
    
    Private Opportunity objOpportunity;
    Private String sOldDesignerEmail;
    Private Lead leadObj;
    public ChangeDPRestAPI(Opportunity OpportunityObj,Lead leadObj,String OldDesignerEmail) {
        this.objOpportunity = OpportunityObj;
        this.sOldDesignerEmail = OldDesignerEmail;
        this.leadObj = leadObj;
    }
    public void execute(QueueableContext context){
        try{
            SendJsonWrapper sjson;
            if(objOpportunity != NULL){
                if(String.isNotBlank(objOpportunity.Customer_Email__c)){
                    sjson = new SendJsonWrapper();
                    sjson.designeremail = sOldDesignerEmail;
                    sjson.newdesigneremail = objOpportunity.Design_Partner_Email__c;
                    sjson.orderUniqueId = objOpportunity.Customer_Id__C;
                }  
            }
            else if(leadObj != NULL){
                if( String.isNotBlank(leadObj.email)){
                    sjson = new SendJsonWrapper();
                    sjson.designeremail = sOldDesignerEmail;
                    sjson.newdesigneremail = leadObj.DP_Email__c;
                    sjson.orderUniqueId = leadObj.Customer_Id__C;
                }
            }
            else{
                System.debug('Both leadObj and OpportunityObj are null so SendJsonWrapper is null');
            }
            
            if(sjson !=null){
                Http pro = new Http();
                HttpRequest Req = new HttpRequest();
                HttpResponse Res = new HttpResponse();
                
                integration_Setting__c integrationDetail = Integration_Setting__c.getAll().get('SpaceCraft DPChange API');
                system.debug('---integrationDetail---'+integrationDetail+'----objOpportunity-------'+objOpportunity);
                
                Req.setEndpoint(integrationDetail.End_Point__c);
                Req.setHeader('Content-Type',integrationDetail.ContentType__c);
                Req.setMethod('POST');
                Req.setBody(Json.serialize(sjson));
                System.debug('-----Req------'+Req.getBody());
                Res = pro.send(Req);   
                System.debug('-----Res ------'+Res );
                Map<String,Object> mapResponse = (Map<String, Object>)JSON.deserializeUntyped(Res.getBody());
                if((String) mapResponse.get('status') == 'error'){
                    Logger.log('Exception','ChangeDPRestAPI ','execute',String.ValueOf(mapResponse),Json.serialize(sjson),NULL);
                } 
            }
            else{
                Logger.log('Error','ChangeDPRestAPI ','execute','Both leadObj and OpportunityObj are null so SendJsonWrapper is null',sOldDesignerEmail,NULL);
            }  
            

        }
        catch(Exception e){
            system.debug('Exception'+e.getMessage());
            Logger.log('Exception','ChangeDPRestAPI ','execute',e.getMessage(),e.getStackTraceString(),sOldDesignerEmail);
        }   
    }
    
    // Dummy method can be removed later.
    public static void handleDPchange(list<String> designeremail,list<String> newdesigneremail,list<String> customeremail){
        
    }
    public class SendJsonWrapper{
        public String designeremail;
        public String newdesigneremail;
        public String orderUniqueId;
    }
}