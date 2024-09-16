Public class AccountTriggerHandler{

/**
 * @File Name          : updatePhone
 * @Description        : Update Opportunity Phone when Account Phone is Updated
 *==============================================================================
 * Ver         Date                     Author                Modification
 *==============================================================================
**/
    
    public static void updatePhone(Map<id,Account> newMap,Map<id,Account> oldMap){     
        list<opportunity> lstOpportunity = new List<opportunity>();
        list<opportunity> lstOpportunityUpdate = new List<opportunity>();
        set<Id> accSet = new set<Id>();
        if(newMap != NULL && oldMap != NULL){
            for(Account ObjAccount : newMap.Values()){
                if(ObjAccount.Phone != oldMap.get(ObjAccount.id).Phone && String.IsNotBlank(ObjAccount.Phone)){
                    accSet.add(ObjAccount.id);
                }
            }
        }
        system.debug('*****accSet*****'+accSet);
        
        if(!accSet.IsEmpty()){
            lstOpportunity = [Select Id,Name,Account.Phone from Opportunity where AccountID IN:accSet];
            for(Opportunity Opp :lstOpportunity){
                opp.Customer_Phone_Lead_Square__c = Opp.Account.Phone;
                lstOpportunityUpdate.add(opp);
            }
        }
        
        system.debug('====lstOpportunityUpdate===='+lstOpportunityUpdate);
        if(!lstOpportunityUpdate.isEmpty()){
            Update lstOpportunityUpdate;
        }
    }
    
    
    /**
     * @File Name          : updateEmail
     * @Description        : Update Opportunity email when Account Email is Updated
     *==============================================================================
     * Ver         Date                     Author                Modification
     *==============================================================================
    **/    
    public static void updateEmail(Map<id,Account> newMap,Map<id,Account> oldMap){     
        list<opportunity> lstOpportunity = new List<opportunity>();
        list<opportunity> lstOpportunityUpdate = new List<opportunity>();
        set<Id> accSet = new set<Id>();
        if(newMap != NULL && oldMap != NULL){
            for(Account ObjAccount : newMap.Values()){
                if(ObjAccount.PersonEmail != oldMap.get(ObjAccount.id).PersonEmail && String.IsNotBlank(ObjAccount.PersonEmail)){
                    accSet.add(ObjAccount.id);
                }
            }
        }
        
        if(!accSet.IsEmpty()){
            lstOpportunity = [Select Id,Name,Account.PersonEmail from Opportunity where AccountID IN:accSet];
            for(Opportunity Opp :lstOpportunity){
                opp.Customer_Email__c = Opp.Account.PersonEmail;
                lstOpportunityUpdate.add(opp);
            }
        }
        
        if(!lstOpportunityUpdate.isEmpty()){
            Update lstOpportunityUpdate;
        }
    }
    
    public static void beforeInsert(List<Account> listOfAccounts){
        for(Account acc : listOfAccounts){
            
        }
       
    }
    public static void afterUpdate(Map<Id,Account> mapOfNewAccounts, Map<Id,Account> mapOfOldAccounts){
        Map<Id,Account> mapOfUpdatedAccounts = new Map<Id,Account>();
        for(Account acc : mapOfNewAccounts.values()){
            if(acc.FirstName != mapOfOldAccounts.get(acc.Id).FirstName 
               || acc.LastName != mapOfOldAccounts.get(acc.Id).LastName 
               || acc.MiddleName != mapOfOldAccounts.get(acc.Id).MiddleName 
               || acc.Phone != mapOfOldAccounts.get(acc.Id).phone
              || acc.PersonEmail != mapOfOldAccounts.get(acc.Id).PersonEmail 
               || acc.Alt_Email__c != mapOfOldAccounts.get(acc.Id).Alt_Email__c
              || acc.Alt_Phone_Number__c != mapOfOldAccounts.get(acc.Id).Alt_Phone_Number__c
              || acc.Whatsapp_Opt_in__c != mapOfOldAccounts.get(acc.Id).Whatsapp_Opt_in__c
              || acc.Found_On_TC__C != mapOfOldAccounts.get(acc.Id).Found_On_TC__C
              || acc.OTP_Verified__C != mapOfOldAccounts.get(acc.Id).OTP_Verified__C
              ){
                 mapOfUpdatedAccounts.put(acc.Id,acc);
             }
        }
        if(!mapOfUpdatedAccounts.isEmpty()){
          AccountTriggerHelper.updateAccoutFieldsInOppAndLead(mapOfUpdatedAccounts);
        }
       
    }
    
     public static void updateOpportunityGSTinfo(Map<id,Account> newMap,Map<id,Account> oldMap)
     {     
         system.debug('*****updateOpportunityGSTinfo*****');
        list<opportunity> lstOpportunity = new List<opportunity>();   
        list<opportunity> lstOpportunityUpdate = new List<opportunity>();
        set<Id> accSet = new set<Id>();
        if(newMap != NULL && oldMap != NULL)
        {
            for(Account ObjAccount : newMap.Values())
            {
                if(ObjAccount.Customer_GSTIN__c != oldMap.get(ObjAccount.id).Customer_GSTIN__c || oldMap.get(ObjAccount.id).Customer_GSTIN__c==NUll || String.IsBlank(oldMap.get(ObjAccount.id).Customer_GSTIN__c))
                {
                    accSet.add(ObjAccount.id);                    
                }
            }
        }
        system.debug('*****accSet*****'+accSet);
        
        if(!accSet.IsEmpty())
        {
            lstOpportunity = [Select Id,Name,Account.Phone,Account.Customer_GSTIN__c from Opportunity where AccountID IN:accSet];            
        }
         
        for(Opportunity Opp :lstOpportunity)
        {
                opp.Customer_GSTIN__c = Opp.Account.Customer_GSTIN__c;
                lstOpportunityUpdate.add(opp);
        }
         
        system.debug('====lstOpportunity===='+lstOpportunityUpdate);
        if(!lstOpportunityUpdate.isEmpty())
        {            
            Update lstOpportunityUpdate;
        }
    }
}