public Class Rest_SendOpportunitytoSpaceCraft implements Queueable,Database.AllowsCallouts{

    List<Opportunity> lstOpportunity = new List<Opportunity>();
    public Rest_SendOpportunitytoSpaceCraft(list<opportunity> OpportunityList ){
        this.lstOpportunity = OpportunityList;
    }

    public void execute(QueueableContext context) {
        try{
            if(lstOpportunity != NULL && !lstOpportunity.isEmpty()){
                Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                Integration_Setting__c integrationDetail = allEndPoint.get('Spacecraft Opportunity API');
                System.debug('------lstOpportunity----'+lstOpportunity[0].Lead_Customer_Quote_Number__c);
                for(Opportunity opp:lstOpportunity){
                    if(String.isNotBlank(opp.Lead_Customer_Quote_Number__c)){
                        HTTP h = new HTTP();
                        HTTPRequest req = new HTTPRequest();  
                        String url = integrationDetail.End_Point__c+opp.Lead_Customer_Quote_Number__c;
                        req.setEndpoint(url);
                        req.setMethod('POST');
                        req.setHeader('Authorization',integrationDetail.Authorization__c);
                        System.debug('++++req++++'+req);
                        HTTPResponse response = new HTTPResponse();                      
                        response = h.send(req);
                        System.debug('response'+response +' Body'+response.getBody());            
                    }
                }
            }
        }
        catch(Exception e){
            system.debug('Error '+ e.getMessage());
            Logger.log('Exception','Rest_SendOpportunitytoSpaceCraft','execute',e.getMessage(),e.getStackTraceString(),NULL);
        }    
    }
}