/**
* @File Name          : ExceptionLeadsCountResetBatch.cls
* @Description        : Batch class to Reset the monthly assigned exceptional leads count of Showroom Users.
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 04/14/2019, 12:21:43 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author      		      Modification
*==============================================================================
* 1.0    11/21/2019, 12:20:14 PM   Bharatesh Shetty     Initial Version
**/
global class ExceptionLeadsCountResetBatch implements Database.Batchable<sObject>,Schedulable{
    Public Set<Id> setOfIds = new Set<Id>();
    // Constructor to excecute only set of records in the Batch.
    global ExceptionLeadsCountResetBatch(Set<Id> setOfIds){
        this.setOfIds = setOfIds;
    }
    global ExceptionLeadsCountResetBatch(){
    }
    global void execute(SchedulableContext SC) {
        database.executebatch(new ExceptionLeadsCountResetBatch(),50);
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String queryString = UtilityClass.getQueryString('Showroom_User__C');
        System.debug('setOfIds '+setOfIds);
        queryString += ' From Showroom_User__C where id != Null';
        if(!setOfIds.isEmpty()){
            queryString += ' and id=:setOfIds';
        }
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext bc, List<Showroom_User__C> listOfShowroomUsers) { 
        try{
            if(!listOfShowroomUsers.isEmpty()){
                Map<Id,Showroom_User__c> mapOfShowroomUsersToUpdate = new Map<Id,Showroom_User__c>();
                for(Showroom_User__c showroomUser : listOfShowroomUsers){
                    showroomUser.Monthly_Exception_Leads_Assigned__c = 0;
                    mapOfShowroomUsersToUpdate.put(showroomUser.Id,showroomUser);
                }
                if(!mapOfShowroomUsersToUpdate.isEmpty()){
                    update mapOfShowroomUsersToUpdate.values();
                }
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            Logger.log('Exception','ExceptionLeadsCountResetBatch Class','execute method',e.getMessage(),e.getStackTraceString(),null);
        }
    }   
    
    global void finish(Database.BatchableContext bc){ 
        System.debug('finish method');   
    }
}