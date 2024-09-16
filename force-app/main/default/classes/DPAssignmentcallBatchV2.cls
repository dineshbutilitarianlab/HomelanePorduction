//  THIS CLASS IS COVERED BY assignment_trigger_Test

global class DPAssignmentcallBatchV2{
   
    global static void MeetingCreation(Date assignDate) {
     
        DPAssignmentBatchClassV2 dpa1 = new DPAssignmentBatchClassV2(assignDate);
        Database.executeBatch(dpa1, 10);
    }
}