@RestResource(urlMapping='/UpdateMeeting/*')
global class Rest_UpdateMeeting{

    @HttpPost
    global static void Rest_UpdateMeeting() {
        list<OpportunityWrapper> lstWrapper = new list<OpportunityWrapper>();
        set<ID> setOppID = new set<ID>();
        list<Opportunity> lstOpportunity = new list<Opportunity>();
        
        RestRequest req = RestContext.Request;
        String inputData = req.requestBody.toString();
        lstWrapper = (List<OpportunityWrapper>)JSON.deserialize(inputData,list<OpportunityWrapper>.class);
        System.debug('lstWrapper  : '+lstWrapper );
        
        try{
            if(lstWrapper != NULL && !lstWrapper.isEmpty()){
                for(OpportunityWrapper objwrapper : lstWrapper)
                {
                    if(objwrapper.opportunity_id != NULL && !String.isEmpty(objwrapper.opportunity_id)){
                        setOppID.add(objwrapper.opportunity_id);
                    }
                }
                
                system.debug('setOppID'+setOppID);
                Map<Id,Opportunity> MapOpp = new Map<Id,Opportunity>([Select id,Name,Second_Meeting_Time__c,Second_Meeting_Status__c ,Second_Meeting_Link__c,Second_Meeting_Start_Time__c from Opportunity where id IN :setOppID]);
                system.debug('MapOpp '+MapOpp );
                
                if(MapOpp != NULL && !MapOpp.isEmpty()){
                    for(OpportunityWrapper objwrapper1 : lstWrapper)
                    {
                        if(objwrapper1.opportunity_id != NULL && !String.isEmpty(objwrapper1.opportunity_id)){
                            if(MapOpp.containsKey(objwrapper1.opportunity_id)){
                                Opportunity objOpportunity = MapOpp.get(objwrapper1.opportunity_id);
                                objOpportunity.Second_Meeting_Link__c = (!String.isEmpty(objwrapper1.Second_Meeting_Link))?objwrapper1.Second_Meeting_Link:objOpportunity.Second_Meeting_Link__c;
                                objOpportunity.Second_Meeting_Time__c = objwrapper1.Second_Meeting_Time != NULL? objwrapper1.Second_Meeting_Time:objOpportunity.Second_Meeting_Time__c ;
                                objOpportunity.Second_Meeting_Start_Time__c = objwrapper1.Second_Meeting_Start_Time != NULL? objwrapper1.Second_Meeting_Start_Time:objOpportunity.Second_Meeting_Start_Time__c;
                                objOpportunity.Second_Meeting_Status__c =  (!String.isEmpty(objwrapper1.Second_Meeting_Status))? objwrapper1.Second_Meeting_Status:objOpportunity.Second_Meeting_Status__c;
                                lstOpportunity.add(objOpportunity);
                                
                            }
                        }
                    }   
                     system.debug('lstOpportunity '+lstOpportunity);
                    if(lstOpportunity != NULL && !lstOpportunity.isEmpty()){
                        Update lstOpportunity;
                        
                        responseWrapper response =new  responseWrapper(True,'');
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(Json.serialize(response));
                    }               
                }
                else{
                    responseWrapper response =new  responseWrapper(False,'Opportunity ID is not present in SF');
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(Json.serialize(response));
                }
            }
        }
        catch(Exception e) {
        system.debug('e.getmessage()'+e.getStackTraceString());
                responseWrapper response =new  responseWrapper(False,e.getmessage());
                RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(response));
        }
        
    }
    public class OpportunityWrapper{
        public String opportunity_id;
        public Datetime Second_Meeting_Time;
        public String Second_Meeting_Link;
        public DateTime Second_Meeting_Start_Time;
        Public String Second_Meeting_Status;
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