public class OpportunityTriggerHelper {
    
    
    @future
    public static void assignParentOpporutnityForSubOrders(Set<Id> setOfOppIds){
        try{
            //System.debug(mapOfOpportunity.values()[0].LeadId__c);
        Set<Id> setOfMainLeadIds = new Set<Id>(); 
        Map<Id,Id> mapOfLeadIdToOppId = new Map<Id,Id>();
        List<Opportunity> listOfOppToUpdate = new List<Opportunity>();
        Map<Id,Opportunity> mapOfOpps = new Map<Id,Opportunity>([Select Id, LeadId__c,LeadId__r.Main_Order__c from Opportunity where Id in:setOfOppIds]);
        System.debug('mapOfOpps'+ mapOfOpps.values()[0].LeadId__c);
            System.debug('mapOfOpps main'+mapOfOpps.values()[0].LeadId__r.Main_Order__c);
            for(Opportunity opp: mapOfOpps.values()){
            if(opp.LeadId__c!= null && opp.LeadId__r.Main_Order__c != null){
                setOfMainLeadIds.add(opp.LeadId__r.Main_Order__c);
            }
        }
            System.debug(setOfMainLeadIds);
        if(setOfMainLeadIds != null){
            List<Opportunity> listOfOpps = [Select Id,LeadId__c from Opportunity where LeadId__c in :setOfMainLeadIds];
            for(Opportunity op : listOfOpps){
                mapOfLeadIdToOppId.put(op.LeadId__c, op.Id);
            }
            System.debug(mapOfLeadIdToOppId);
            
            for(Opportunity op : mapOfOpps.values()){
                System.debug(op);
                Opportunity opp = new Opportunity();
                System.debug(mapOfOpps.containsKey(op.Id));
                System.debug(mapOfOpps.get(op.Id).LeadId__c != null );

                System.debug(mapOfLeadIdToOppId.get(mapOfOpps.get(op.Id).LeadId__c) != null);
                   if(mapOfOpps.containsKey(op.Id) 
                   && mapOfOpps.get(op.Id).LeadId__c != null 
                   && mapOfLeadIdToOppId.get(mapOfOpps.get(op.Id).LeadId__r.Main_Order__c) != null ){
                       System.debug('test');
                       opp.Id = op.Id;
                       opp.Main_Order__c = mapOfLeadIdToOppId.get(mapOfOpps.get(op.Id).LeadId__r.Main_Order__c);
                       listOfOppToUpdate.add(opp);
                       
                   }
            }
            update listOfOppToUpdate;
        }
        }Catch(Exception e){
            Logger.log('OpportunityTriggerHelper','assignParentOpporutnityForSubOrders','assignParentOpporutnityForSubOrders',e.getMessage(),e.getStackTraceString(),NULL);
        }
    }
        
    
}