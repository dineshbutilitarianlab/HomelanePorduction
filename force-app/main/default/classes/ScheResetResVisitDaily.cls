global class ScheResetResVisitDaily implements Schedulable {
    global void execute(SchedulableContext SC) {
         List<Lead_Round_Robin_Assignment__c> lstLeadRound= [select id,Daily_Assignment__c from Lead_Round_Robin_Assignment__c for Update];
         for(Lead_Round_Robin_Assignment__c objleadRound : lstLeadRound){
             objleadRound.Daily_Assignment__c = 0;
         }
         if(!lstLeadRound.IsEmpty()){
             update lstLeadRound;  
         }         
    }
}