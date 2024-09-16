global class LeadToAmeyoUserAfter3Hours implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([select Id,Name,LeadSource,Email,Push_lead_to_Ameyo_Time__c,Follow_up_time__c,Sub_Status__c ,Customer_ID__c,Status from Lead where (LeadSource = 'Unqualified Walk-in' and Status = 'Fresh Lead' and Sub_Status__c = 'Visited Showroom')]);        
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('******SCOPE : '+scope);
        List<Lead> leadList = (List<sObject>)(scope);
        List<Lead> updateLead = new List<Lead>();
        UserIds__c userId = [select name, Id__c from UserIds__c where Name = 'Ameyo User'];
        System.debug('******userId  '+userId);
        for(Lead objLead : leadList) {        
            if(System.now() >= objLead.Push_lead_to_Ameyo_Time__c) {
                System.debug('******INSIDE : ');
                objLead.OwnerId = userId.Id__c;
                objLead.WT_Agent__c = userId.Id__c;
                updateLead.add(objLead);
            }
        }
        if(!updateLead.isEmpty()) {
        System.debug('******updateLead  : '+updateLead);
        update updateLead;
        }
    }
     global void finish(Database.BatchableContext BC){
       
    }
}