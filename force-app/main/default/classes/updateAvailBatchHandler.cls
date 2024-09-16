//  THIS CLASS IS COVERED BY assignment_trigger_Test

global class updateAvailBatchHandler implements Database.Batchable<sObject>,Database.AllowsCallouts {
   global Date myDate;
     global updateAvailBatchHandler(Date myDate) {
         this.myDate = myDate;
     }
     global database.QueryLocator start(Database.BatchableContext bc)
    {
   
        String leadquerystr = 'select id, name from DP_Assignment__c';
        System.debug('----------leadquerystr  '+leadquerystr );
        return database.getQueryLocator(leadquerystr);
    }
    global void execute(Database.BatchableContext bc,List<DP_Assignment__c> scope)
    {
        if(scope.size() > 0) {
            delete scope;
        }
    }
    global void finish(Database.BatchableContext bc)
    {     
         if(myDate >= Date.Today())
            DPAssignmentcallBatchV2.MeetingCreation(myDate );
    }
}