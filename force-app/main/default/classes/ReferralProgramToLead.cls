public class ReferralProgramToLead {
    public static void referralUpdate(Map<Id,Lead> newMap, Map<Id,Lead> oldMap) {
        Set<String> phoneSet = new Set<String>();
        Map<String, Referrer__c> referrerMap = new Map<String, Referrer__c>();
        
        for(Lead l : newMap.values()) {
            if(l.HL_Referrer_Phone__c != null) {
                phoneSet.add(l.HL_Referrer_Phone__c);
            }
        }
        
        List<Referrer__c> referrerList = [select id, name, Email__c, Phone__c, Property_Name__c, Referral_Program__c from Referrer__c where Phone__c =: phoneSet];
        if(referrerList.size() > 0) {            
            for(Referrer__c ref : referrerList) {
                referrerMap.put(ref.Phone__c, ref);
            }
        } 
        
        if(!referrerMap.isEmpty()){
            for(Lead l : newMap.values()) {               
                if(l.HL_Referrer_Phone__c != null && oldMap.get(l.id).HL_Referrer_Phone__c  != l.HL_Referrer_Phone__c) {               
                    Referrer__c ref = referrerMap.get(l.HL_Referrer_Phone__c);
                    l.Referral_Program__c = ref.Referral_Program__c;
                }                                       
            }
        }   
        else {
            for(Lead l : newMap.values()) {
                l.Referral_Program__c = null;
            }
        }           
    }
    
    public static void referralInsert(List<Lead> newMap) {
        Set<String> phoneSet = new Set<String>();
        Map<String, Referrer__c> referrerMap = new Map<String, Referrer__c>();
        
        for(Lead l : newMap) {
            if(l.HL_Referrer_Phone__c != null) {
                phoneSet.add(l.HL_Referrer_Phone__c);
            }
        }
        
        List<Referrer__c> referrerList = [select id, name, Email__c, Phone__c, Property_Name__c, Referral_Program__c from Referrer__c where Phone__c =: phoneSet];
        if(referrerList.size() > 0) {
            
            for(Referrer__c ref : referrerList) {
                referrerMap.put(ref.Phone__c, ref);
            }
        } 
        
        if(!referrerMap.isEmpty()){
            for(Lead l : newMap) {
                if(l.HL_Referrer_Phone__c != null) {
                    Referrer__c ref = referrerMap.get(l.HL_Referrer_Phone__c);
                    l.Referral_Program__c = ref.Referral_Program__c;
                }
            }
        }
       
    }
}