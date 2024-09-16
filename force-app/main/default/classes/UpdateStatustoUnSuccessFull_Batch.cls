global class UpdateStatustoUnSuccessFull_Batch implements Database.Batchable<sObject>,Database.AllowsCallouts,Schedulable{
    Public Set<Id> setOfIds = new Set<Id>();
    // Constructor to excecute only set of records in the Batch.
    global UpdateStatustoUnSuccessFull_Batch(Set<Id> setOfIds){
        this.setOfIds = setOfIds;
    }
    global UpdateStatustoUnSuccessFull_Batch(){
        
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        if(setOfIds.isEmpty()){    
            return Database.getQueryLocator([select id, name,status,Sub_Status__c,Alternative_Appointment_Time__c,Appointment_Time__C,Follow_up_time__c from lead where (Assigned_to_Dealer__c!=true) And ((Appointment_Time__c <=: System.now() and Appointment_Time__c >=: System.now().addHours(-24)  and Check_In_Time__c = NULL and (Status = 'Appointment Fixed' OR Status = 'Appointment Confirmed')) OR (Appointment_Time__c <=: System.now().addHours(-72) and Appointment_Time__c >=: System.now().addHours(-96) AND Status = 'DP Assigned') OR ( Appointment_Time__c <=: System.now() and Appointment_Time__c >=: System.now().addHours(-48) AND Status = 'Meeting Incomplete'))]);
        }
        else{
            return Database.getQueryLocator([select id, name,status,Sub_Status__c,Alternative_Appointment_Time__c,Appointment_Time__C,Follow_up_time__c from lead where (Assigned_to_Dealer__c!=true) And ((Appointment_Time__c <=: System.now() and Appointment_Time__c >=: System.now().addHours(-24)  and Check_In_Time__c = NULL and (Status = 'Appointment Fixed' OR Status = 'Appointment Confirmed')) OR (Appointment_Time__c <=: System.now().addHours(-72) and Appointment_Time__c >=: System.now().addHours(-96) AND Status = 'DP Assigned') OR (Appointment_Time__c <=: System.now() and Appointment_Time__c >=: System.now().addHours(-48) AND Status = 'Meeting Incomplete')) and id=: setOfIds]);
        }
        
    }
  
    global void execute(Database.BatchableContext bc,List<Lead> scope)
    {
        list<Lead> leadtoUpdate  = new list<Lead>();
        try{
            for(lead objLead : scope){
                objLead.status = 'Appointment Unsuccessful';
                objLead.Sub_Status__c = 'Appointment Unsuccessful';
                objLead.Alternative_Appointment_Time__c =null;
                objLead.Appointment_Time__C= null;
                objLead.Follow_up_time__c = System.now().addHours(8);
                leadtoUpdate.add(objLead);
            }
            if(!leadtoUpdate.isempty() && leadtoUpdate != NULL){
                update leadtoUpdate;
            }
        }
        catch(Exception e){
            Logger.log('Exception','UpdateStatustoUnSuccessFull_Batch ','execute',e.getMessage(),e.getStackTraceString(),NULL);
        }
    }
    
    global void finish(Database.BatchableContext bc)
    {
    }

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new UpdateStatustoUnSuccessFull_Batch (),5);
    }
}