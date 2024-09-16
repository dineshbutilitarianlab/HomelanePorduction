global class ScheduledAssignmentRemovalBatch implements Schedulable {
   global void execute(SchedulableContext sc) {
      LeadAssignmentRemovalBatch objLeaveBatch = new LeadAssignmentRemovalBatch(); 
      database.executebatch(objLeaveBatch );
   }
}