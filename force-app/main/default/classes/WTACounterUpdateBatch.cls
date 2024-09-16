/**
* @File Name          : WTACounterUpdateBatch.cls
* @Description        : Batch class which runs daily and updates the daily, weekly and monthly counters on condition. Test Class: WTACounterUpdateBatch_Test
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 7/31/2019, 2:18:09 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author      		      Modification
*==============================================================================
* 1.0    7/31/2019, 4:51:50 PM   Bharatesh Shetty     Initial Version
**/
Global class WTACounterUpdateBatch implements Database.Batchable<sObject>,schedulable{
    public dateTime todayDate;
    Public String ContextToRUNLogic;
    //schedulable execute
    global void execute(SchedulableContext sc) {
        WTACounterUpdateBatch b = new WTACounterUpdateBatch();
        database.executebatch(b,100);
    }
    //Constructor
    Public WTACounterUpdateBatch(){
        todayDate = Date.Today();
        if(todayDate.day()==1){
            ContextToRUNLogic ='MONTHLY';
        }
        else if(todayDate.format('EEEE')=='Monday'){
            ContextToRUNLogic ='WEEKLY';
        }
        else{
            ContextToRUNLogic ='DAILY';
        }
    }
    
    //batchable context
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = UtilityClass.getQueryString('WTA_Assignment__c');
        query += ' From WTA_Assignment__c where isActive__c =True';
        return Database.getQueryLocator(query);
    }
    
    //batchable execute
    global void execute(Database.BatchableContext bc, List<WTA_Assignment__c> listOfWTAAssignment) {
        try{
            if(!listOfWTAAssignment.isEmpty()){
                WTACounterUpdateHandler.refreshWTAAssignmentCounter(listOfWTAAssignment,ContextToRUNLogic);
            }
        }
        catch(Exception e){
            Logger.log('Exception','WTACounterUpdateBatch','execute',e.getMessage(),e.getStackTraceString(),NULL);
        }
    }
    
    //batchable finish
    global void finish(Database.BatchableContext bc) {
        
    }
}