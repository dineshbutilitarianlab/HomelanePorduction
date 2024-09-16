public class SendNpsToRoster implements Queueable,Database.AllowsCallouts {
    
    private List<Opportunity> lstOpportunity;
    
    public SendNpsToRoster (List<Opportunity> opportunityList) {
        this.lstOpportunity = opportunityList;
    }
    public void execute(QueueableContext context) {
        
        for (Opportunity objOpp: lstOpportunity) {
            try{
                if(objOpp.Customer_Satisfaction__c != NULL && String.isNotBlank(objOpp.Customer_ID__c)){
                    Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                    Integration_Setting__c integrationDetail = allEndPoint.get('Roster NPS');
                    Http h = new Http();
                    String sbody;
                    HttpRequest httpReq = new HttpRequest();
                    httpReq.setMethod('POST');
                    httpReq.setHeader('Content-Type',integrationDetail.ContentType__c);
                    requestWrapper body = new requestWrapper(objOpp.Customer_Satisfaction__c,objOpp.Customer_ID__c);
                    sbody = JSON.serialize(body);
                    httpReq.setBody(sbody);
                    httpReq.setEndpoint(integrationDetail.End_Point__c);
                    System.debug('++++++httpReq++++'+httpReq);
                    System.debug('++++++httpReq.setBody++++'+httpReq.getBody());
                    if(!test.isRunningTest()){
                        HttpResponse res = h.send(httpReq);
                        system.debug('+++res++'+res);
                    }
                }  
            }
            Catch(Exception e){
                Logger.log('Exception','SendNpsToRoster','execute',e.getMessage(),e.getStackTraceString(),NULL);
            }   
         }

    } 
    
    public class requestWrapper{
        public Decimal nps{get;set;}
        public String customer_id{get;set;}
        
        public requestWrapper(Decimal NPSScore, String CustomerNumber){
            this.nps = NPSScore;
            this.customer_id  = CustomerNumber;
        }
    }
    
    public static void CheckNpsUpdation(List<Opportunity> opportunityList,Map<id,Opportunity> oldMap){
        
        list<Opportunity> lstOpportunityNps = new list<Opportunity>();
        for (Opportunity objOpp: opportunityList){   
            system.debug('objOpp.Customer_Satisfaction__c-->'+objOpp.Customer_Satisfaction__c  +'objOpp.Customer_ID__c--->'+objOpp.Customer_ID__c);
            if(objOpp.Customer_Satisfaction__c != NULL && String.isNotBlank(objOpp.Customer_ID__c)){
                if(objOpp.Customer_Satisfaction__c != oldMap.get(objOpp.id).Customer_Satisfaction__c){
                    lstOpportunityNps.add(objOpp);
                }
            }    
        }    
        if(!lstOpportunityNps.isEmpty()){
            if( System.isBatch() && Limits.getQueueableJobs() == 0) {
                System.debug('limits: '+Limits.getQueueableJobs());
                System.enqueueJob(new SendNpsToRoster(lstOpportunityNps));
            }
            else if(System.isBatch()==false){
                System.debug('limits2: '+Limits.getQueueableJobs());
                System.enqueueJob(new SendNpsToRoster(lstOpportunityNps));
            }
        }
    }
}