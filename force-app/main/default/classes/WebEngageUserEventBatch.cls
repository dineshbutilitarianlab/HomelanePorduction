/**
 * @File Name          : WebEngageUserEventBatch.cls
 * @Description        : Batch class to process webEngage callout for user events.
 * @Author             : Bharatesh Shetty
 * @Group              : 
 * @Last Modified By   : Bharatesh Shetty
 * @Last Modified On   : 10/15/2019, 12:21:43 PM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    10/15/2019, 12:20:14 PM   Bharatesh Shetty     Initial Version
**/
global class WebEngageUserEventBatch implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable {
    Public Set<Id> setOfIds = new Set<Id>();
    // Constructor to excecute only set of records in the Batch.
    global WebEngageUserEventBatch(Set<Id> setOfIds){
        this.setOfIds = setOfIds;
    }
    global WebEngageUserEventBatch(){
        
    }
    global void execute(SchedulableContext SC) {
 	    database.executebatch(new WebEngageUserEventBatch(),10);
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String queryString = UtilityClass.getQueryString('WebEngage_Task__c');
        queryString += ' From WebEngage_Task__c where Type__c =\'User Event\' and Status__c!=\'Closed\'';
        if(!setOfIds.isEmpty()){
            queryString += ' and id=:setOfIds';
        }
        return Database.getQueryLocator(queryString);
    }

    global void execute(Database.BatchableContext bc, List<WebEngage_Task__c> listOfWebEngageTaskRecords) { 
        try{
           // Call the getdetails method from WebEngageBatchHandler.
           // 
           //List<WebEngage_Task__c> listOfWebEngageDoowupTask =  new List<WebEngage_Task__c>();
            //List<WebEngage_Task__c> listOfWebEngageHomeLaneTask =  new List<WebEngage_Task__c>();
            //for(WebEngage_Task__c task : listOfWebEngageTaskRecords){
               Map<String,List<WebEngage_Task__c>> mapOfBrandAnsWebEngageTaskList = new  Map<String,List<WebEngage_Task__c>>();
            for(WebEngage_Task__c task : listOfWebEngageTaskRecords){
                if(mapOfBrandAnsWebEngageTaskList.containsKey(task.Brand__c)){
                    mapOfBrandAnsWebEngageTaskList.get(task.Brand__c).add(task);
                }
                else{
                    mapOfBrandAnsWebEngageTaskList.put(task.Brand__c ,new List<WebEngage_Task__c> {task});
                }
            }
            if(!mapOfBrandAnsWebEngageTaskList.isEmpty()){
                 WebEngageBatchHandler.getdetails(mapOfBrandAnsWebEngageTaskList,'USER EVENT');
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