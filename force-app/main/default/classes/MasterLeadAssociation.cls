public class MasterLeadAssociation {
   public static void leadIns(List<Lead> leadList) {
    try{
            Set<Id> newSet = new Set<Id>();
            for(Lead l : leadList) {
                if(l.property__c != null)
                newSet.add(l.property__c);
            }
            
            if(!newSet.isEmpty() && newSet != null) {
                Map<Id,Master__c> masterMap = new Map<Id,Master__c>([select id, name, Is_Associated_With_Lead_Opportunity__c,(select id, name from Leads__r limit 1) from Master__c where id =: newSet]);
                List<Master__c> masterToUpdate = new List<Master__c>();
                
                if(!masterMap.isEmpty()) {
                    for(Master__c m : masterMap.values()) {
                        if(m.Leads__r.size() > 0) {
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
         }   
         catch(Exception e){
             Logger.log('Exception','MasterLeadAssociation ','leadIns',e.getMessage(),e.getStackTraceString(),NULL);
         }
    }
    
    public static void leadUpd(List<Lead> leadList, Map<Id,Lead> oldMap) {
        try{
            Set<Id> newSet = new Set<Id>();
            for(Lead l : leadList) {
                if(l.property__c != oldMap.get(l.id).property__c ){
                    if(l.property__c != NULL){
                        newSet.add(l.property__c);
                        if(oldMap.get(l.id).property__c != NULL){
                            newSet.add(oldMap.get(l.id).property__c);
                        } 
                    }
                    else if(oldMap.get(l.id).property__c != NULL){
                        newSet.add(oldMap.get(l.id).property__c);
                    }                   
                }    
            }
            
            if(!newSet.isEmpty() && newSet != null) {
                Map<Id,Master__c> masterMap = new Map<Id,Master__c>([select id, name, Is_Associated_With_Lead_Opportunity__c,(select id, name from Leads__r limit 1),(select id, name from Opportunities2__r limit 1) from Master__c where id =: newSet]);
                List<Master__c> masterToUpdate = new List<Master__c>();
                
                if(!masterMap.isEmpty()) {
                    for(Master__c m : masterMap.values()) {
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
            
            
                if(!masterToUpdate.isEmpty()) {
                    update masterToUpdate;
                }
            }
        }
        catch(Exception e){
            Logger.log('Exception','MasterLeadAssociation ','leadUpd',e.getMessage(),e.getStackTraceString(),NULL);
        }
      } 
    }