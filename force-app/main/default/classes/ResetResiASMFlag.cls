global class ResetResiASMFlag implements Database.Batchable<sObject>,Schedulable{

   public final String Query;
   public final String Entity;
   public final String Field;
   public final String Value;
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new UnverifiedLeadsAssignmentInitiateBatch(),1);
    }

   global ResetResiASMFlag(){

      
   }

   public Database.QueryLocator start(Database.BatchableContext BC){
       String queryString = UtilityClass.getQueryString('Lead');
        queryString += ' From Lead where  assigned_To_resi_Asm__c = true and Transfer_Status__c =\'Doowup Transfer\' ';      
           
      return Database.getQueryLocator(queryString);
   }

   public void execute(Database.BatchableContext BC, List<Lead> ldList){
       list<Lead> updateFlagList = new List<Lead>();
       system.debug('ldList'+ LdList);
       system.debug('size'+LdList.size());
     for(Lead ld : ldList){
     ld.Assigned_to_Resi_ASM__c = false;
         ld.Sales_Manager__c=null;
         ld.Sales_Manager_Email__c=null;
         ld.Transfer_Status__c=null;
         ld.Description__c =ld.Description__c+ 'Duplicate doowup Lead is created';
         updateFlagList.add(ld);
     }
       if( !updateFlagList.isEmpty()){
           update updateFlagList;
       }
    }

   public void finish(Database.BatchableContext BC){
   }
}