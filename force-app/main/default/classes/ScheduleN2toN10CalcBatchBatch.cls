global class ScheduleN2toN10CalcBatchBatch implements Schedulable {
   global void execute(SchedulableContext sc) {
    
       N2toN10CalcBatch objCDPCB1 = new N2toN10CalcBatch();
        database.executebatch(objCDPCB1,2000);
   }
    
}