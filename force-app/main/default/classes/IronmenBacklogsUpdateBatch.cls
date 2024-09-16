/**
* @File Name          : IronmenBacklogsUpdateBatch.cls
* @Description        : Batch class.
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 11/21/2019, 12:21:43 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author      		      Modification
*==============================================================================
* 1.0    11/21/2019, 12:20:14 PM   Bharatesh Shetty     Initial Version
**/
global class IronmenBacklogsUpdateBatch implements Database.Batchable<sObject>,Schedulable{
    Public Set<Id> setOfIds = new Set<Id>();
    // Constructor to excecute only set of records in the Batch.
    global IronmenBacklogsUpdateBatch(Set<Id> setOfIds){
        this.setOfIds = setOfIds;
    }
    global IronmenBacklogsUpdateBatch(){
    }
    global void execute(SchedulableContext SC) {
        database.executebatch(new IronmenBacklogsUpdateBatch(),100);
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String queryString = UtilityClass.getQueryString('Showroom_User__c');
        //System.debug('setOfIds '+setOfIds);
        queryString += ' From Showroom_User__c where IsActive__c = True and Threashold__c !=null';
        if(!setOfIds.isEmpty()){
            queryString += ' and id=:setOfIds';
        }
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext bc, List<Showroom_User__c> listOfSalesManager) { 
        try{
            if(!listOfSalesManager.isEmpty()){
                Set<Id> setOfIronmenId = new Set<Id>();
                for(Showroom_User__c ironman :listOfSalesManager){
                    setOfIronmenId.add(ironman.id);
                }
                if(!setOfIronmenId.isEmpty()){
                    Map<Id,AggregateResult> mapOfIronmanWithAggregateResult = new Map<Id,AggregateResult>();
                    mapOfIronmanWithAggregateResult = new Map<Id,AggregateResult>([SELECT Sales_Manager__r.Id Id,Count(Id) 
                                                                                   FROM Lead 
                                                                                   WHERE Sales_Manager__r.Id =:setOfIronmenId and Assigned_To_Resi_ASM__c =True
                                                                                   and Status='Fresh Lead' and (Sub_Status__c='New' or Sub_Status__c='Unverified') and Test_Flag__c = False
                                                                                   GROUP BY Sales_Manager__r.Id]);
                    if(!mapOfIronmanWithAggregateResult.isEmpty()){
                        IronmenBacklogsUpdateBatchHandler.updateBackLogsCount(setOfIronmenId, mapOfIronmanWithAggregateResult);
                    } 
                }
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