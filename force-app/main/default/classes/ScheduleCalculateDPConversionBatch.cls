global class ScheduleCalculateDPConversionBatch implements Schedulable {
   global void execute(SchedulableContext sc) {
      CalculateDPConversionBatch objCDPCB = new CalculateDPConversionBatch();
        database.executebatch(objCDPCB,200);
      
   }
    
}