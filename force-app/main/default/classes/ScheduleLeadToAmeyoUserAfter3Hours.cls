global class ScheduleLeadToAmeyoUserAfter3Hours  implements Schedulable {
   global void execute(SchedulableContext sc) {
     
        LeadToAmeyoUserAfter3Hours  lta = new LeadToAmeyoUserAfter3Hours ();
       
      
       if(!Test.isRunningTest())
          database.executebatch(lta,100);
       else  
        database.executebatch(lta);
   }
    
}