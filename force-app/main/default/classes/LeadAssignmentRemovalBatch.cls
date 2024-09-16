global class LeadAssignmentRemovalBatch implements Database.Batchable<sObject>, Database.Stateful{
    global string query;
    global RR_Deactivate_Time__c RRDT{get;set;}
    List<Lead_Assignment__c> lstUpdatedLeadAssignment = new List<Lead_Assignment__c>();
    global LeadAssignmentRemovalBatch(){
        query = 'Select Id,User__c,Number_of_Leads__c,Assign_Percent__c,Round_Robin__c From Lead_Assignment__c';
        
    }
    
     global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator(query);
    }
    
      global void execute(Database.BatchableContext BC, List<Lead_Assignment__c> lstLeadAssignment){
          RRDT = RR_Deactivate_Time__c.getvalues('Daily Time');
          for(Lead_Assignment__c objLA : lstLeadAssignment){
             objLA.Assign_Percent__c = 0;
             objLA.Number_of_Leads__c = 0; 
             lstUpdatedLeadAssignment.add(objLA);
          }
          try{ 
         if(!lstUpdatedLeadAssignment.isEmpty()){
             update lstUpdatedLeadAssignment;
             }system.debug('-------lstUpdatedLeadAssignment-----------'+lstUpdatedLeadAssignment);
        }catch(exception exp){
            system.debug('-------exp start-----------'+exp.getmessage());
        } 
           
      }
    
     global void finish(Database.BatchableContext BC){
        try{
            Queue_Custom_Setting__c queueSetting = Queue_Custom_Setting__c.getvalues('Lead Queue');
            queueSetting.Queue_Count__c = '';
            RRDT.Deactivation_Time__c = System.Now();
            update RRDT;
            update queueSetting;
        }catch(Exception exp){
            system.debug('-------exp finish-----------'+exp.getmessage());
            
        }
    }
    

    
    
    
    
    
    
}