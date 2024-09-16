global class OppFollowUpMeetingCancelled_Batch implements Database.Batchable<sObject>,Database.AllowsCallouts,Schedulable{
    Public Set<Id> setOfIds = new Set<Id>();
    // Constructor to excecute only set of records in the Batch.
    global OppFollowUpMeetingCancelled_Batch(Set<Id> setOfIds){
        this.setOfIds = setOfIds;
    }
    global OppFollowUpMeetingCancelled_Batch(){
        
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        if(setOfIds.isEmpty()){    
            return Database.getQueryLocator([select id, Opportunity_Funnel_Status__c,Opportunity_Funnel_Sub_Status__c,Follow_up_time__c 
                                             from Opportunity 
                                             where Second_meeting_appointment_time__c <=: System.now().addHours(-48) AND 
                                             Opportunity_Funnel_Status__c = 'Follow-up Meeting Fixed']);
        }
        else{
            return Database.getQueryLocator([select id, Opportunity_Funnel_Status__c,Opportunity_Funnel_Sub_Status__c,Follow_up_time__c 
                                             from Opportunity 
                                             where Second_meeting_appointment_time__c <=: System.now().addHours(-48) AND 
                                             Opportunity_Funnel_Status__c = 'Follow-up Meeting Fixed' and 
                                             id=: setOfIds]);
        }
        
    }
  
    global void execute(Database.BatchableContext bc,List<Opportunity> scope)
    {
        list<Opportunity> listOfOppsToUpdate  = new list<Opportunity>();
        try{
            for(Opportunity objOpportunity : scope){
                objOpportunity.Opportunity_Funnel_Status__c = 'Followup Meeting Cancelled';
                objOpportunity.Opportunity_Funnel_Sub_Status__c = 'Meeting Cancelled - Follow Up Later';
                objOpportunity.Follow_up_time__c = System.now().addHours(8);
                listOfOppsToUpdate.add(objOpportunity);
            }
            if(!listOfOppsToUpdate.isempty() && listOfOppsToUpdate != NULL){
                update listOfOppsToUpdate;
            }
        }
        catch(Exception e){
            Logger.log('Exception','OppFollowUpMeetingCancelled_Batch ','execute',e.getMessage(),e.getStackTraceString(),NULL);
        }
    }
    
    global void finish(Database.BatchableContext bc)
    {
    }

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new OppFollowUpMeetingCancelled_Batch (),1);
    }
}