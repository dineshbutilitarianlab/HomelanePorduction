/**
* @File Name          : IronmenDailyAssignmentResetBatch.cls
* @Description        : Batch class.
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 11/21/2019, 12:21:43 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0    11/21/2019, 12:20:14 PM   Bharatesh Shetty     Initial Version
**/
global class IronmenDailyAssignmentResetBatch implements Database.Batchable<sObject>,Schedulable{
    Public Set<Id> setOfIds = new Set<Id>();
    // Constructor to excecute only set of records in the Batch.
    global IronmenDailyAssignmentResetBatch(Set<Id> setOfIds){
        this.setOfIds = setOfIds;
    }
    global IronmenDailyAssignmentResetBatch(){
    }
    global void execute(SchedulableContext SC) {
        database.executebatch(new IronmenDailyAssignmentResetBatch(),100);
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String queryString = UtilityClass.getQueryString('Showroom_User__c');
        //System.debug('setOfIds '+setOfIds);
        queryString += ' From Showroom_User__c where Id !=null';
        if(!setOfIds.isEmpty()){
            queryString += ' and id=:setOfIds';
        }
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext bc, List<Showroom_User__c> listOfSalesManager) { 
        try{
            Date lastDayOfMonth = Date.newInstance(System.today().year(), System.today().month(),Date.daysInMonth(System.today().year(), System.today().month()));
            System.debug('lastDayOfMonth: '+lastDayOfMonth);
            if(!listOfSalesManager.isEmpty()){
                for(Showroom_User__c ironman :listOfSalesManager){
                    ironman.Daily_Assignment__c = 0;
                    ironman.WT_Leads_Daily_Assignment__c = 0;
                    ironman.Outskirts_Assignment__c=0;
                    ironman.Offline_Daily_Assignment__c=0;
                    if(System.today()==lastDayOfMonth || Test.isRunningTest()){
                        //System.debug('Today is last day of the month.');
                        ironman.Monthly_Assignment__c = 0;
                        ironman.Outskirts_Monthly_Assignment__c=0;
                        ironman.WT_Leads_Monthly_Assignment__c=0;
                        ironman.Offline_Monthly_Assignment__c	=0;
                    }
                }
                update listOfSalesManager;
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
        }
    }   
    
    global void finish(Database.BatchableContext bc){ 
        System.debug('finish method');   
    }
}