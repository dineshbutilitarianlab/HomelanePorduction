public class PropertyOpportunityAssoication{

   public static void opportunityInsert(List<Opportunity> OppList) {
        try{
            Set<Id> newSet = new Set<Id>();
            for(Opportunity opp : OppList) {
                if(opp.Property_Name__c != null)
                newSet.add(opp.Property_Name__c);
            }
            
            Map<Id,Master__c> masterMap = new Map<Id,Master__c>([select id, name, Is_Associated_With_Lead_Opportunity__c,(select id, name from Opportunities2__r) from Master__c where id =: newSet]);
            List<Master__c> masterToUpdate = new List<Master__c>();
            
            if(!masterMap.isEmpty()) {
                for(Master__c m : masterMap.values()) {
                    if(m.Opportunities2__r.size() > 0) {
                        if(m.Is_Associated_With_Lead_Opportunity__c ==  false) {
                            m.Is_Associated_With_Lead_Opportunity__c = true;
                            masterToUpdate.add(m);
                        }
                    }
                }
            }
            
            if(!masterToUpdate.isEmpty()){
                update masterToUpdate;
            }                
        }   
        catch(Exception e){
            Logger.log('Exception','PropertyOpportunityAssoication ','OpportunityInsert',e.getMessage(),e.getStackTraceString(),NULL);
        }
    }
 public static void opportunityUpdate(List<Opportunity> opporunityList, Map<Id,Opportunity> oldMap) {
        try{
            Set<Id> newSet = new Set<Id>();
            
            for(Opportunity l : opporunityList) {
                if(l.Property_Name__c != oldMap.get(l.id).Property_Name__c ){
                    if(l.Property_Name__c != NULL){
                        newSet.add(l.Property_Name__c );
                        if(oldMap.get(l.id).Property_Name__c != NULL){
                            newSet.add(oldMap.get(l.id).Property_Name__c);
                        }    
                    }
                    else if(oldMap.get(l.id).Property_Name__c != NULL){
                        newSet.add(oldMap.get(l.id).Property_Name__c );
                    }                   
                }
                
            }
            system.debug('-------newSet-------'+newSet);
            Map<Id,Master__c> masterMap = new Map<Id,Master__c>([select id, name, Is_Associated_With_Lead_Opportunity__c,(select id, name from Opportunities2__r limit 1),(select id, name from leads__r limit 1) from Master__c where id =: newSet]);
            List<Master__c> masterToUpdate = new List<Master__c>();
            system.debug('-------masterMap -------'+masterMap );
            if(!masterMap.isEmpty()) {
                for(Master__c m : masterMap.values()) {
                system.debug('-------masterMap -------'+m.Opportunities2__r.size()+ '------masterMap ----'+m.leads__r.size());
                    if(m.Opportunities2__r.size() > 0 || m.leads__r.size() > 0) {
                        if(m.Is_Associated_With_Lead_Opportunity__c ==  false) {
                            m.Is_Associated_With_Lead_Opportunity__c = true;
                            masterToUpdate.add(m);
                        }
                    }
                    else {
                        if(m.Is_Associated_With_Lead_Opportunity__c ==  true) {
                            m.Is_Associated_With_Lead_Opportunity__c = false;
                            masterToUpdate.add(m);
                        }
                    }
                }
            }
            
            if(!masterToUpdate.isEmpty())
            update masterToUpdate;
        }
        catch(Exception e){
            Logger.log('Exception','PropertyOpportunityAssoication ','OpportunityInsert',e.getMessage(),e.getStackTraceString(),NULL);
        }
      } 


}