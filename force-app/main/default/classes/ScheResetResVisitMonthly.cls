global class ScheResetResVisitMonthly implements Schedulable {
    global void execute(SchedulableContext SC) {
         List<Lead_Round_Robin_Assignment__c> lstLeadRound= [select id,Monthly_Assignments__c from Lead_Round_Robin_Assignment__c for Update];
         for(Lead_Round_Robin_Assignment__c objleadRound : lstLeadRound){
             objleadRound.Monthly_Assignments__c= 0;
         }
         if(!lstLeadRound.IsEmpty()){
             update lstLeadRound;  
         }         
    }
}