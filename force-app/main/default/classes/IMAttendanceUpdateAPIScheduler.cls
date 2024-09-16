global class IMAttendanceUpdateAPIScheduler Implements Schedulable, Database.AllowsCallouts{
    
    private Integer isCheckAttendance;
    
    public IMAttendanceUpdateAPIScheduler(){
    }
    public IMAttendanceUpdateAPIScheduler(Integer isCheckAttendance){
        this.isCheckAttendance = isCheckAttendance;
    }
    global void execute(SchedulableContext sc)
    {
        //UpdateShowroomUserAttendance();
        //The Queueable class is invoked since scheduled clsses does not support API callouts
        ID jobID = System.enqueueJob(new IMAttendanceUpdateAPIQueueable(isCheckAttendance));
    }
   
    

}