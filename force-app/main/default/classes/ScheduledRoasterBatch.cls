global class ScheduledRoasterBatch implements Schedulable {
   global void execute(SchedulableContext sc) {
      LeaveAssignmentBatch objLeaveBatch = new LeaveAssignmentBatch(); 
      database.executebatch(objLeaveBatch );
   }
}