/**
 * @File Name          : LeadSquaredOppDetailsCallOutBatch.cls
 * @Description        : 
 * @Author             : Bharatesh Shetty
 * @Group              : 
 * @Last Modified By   : Bharatesh Shetty
 * @Last Modified On   : 8/29/2019, 11:12:37 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/16/2019, 2:40:03 PM   Bharatesh Shetty     Initial Version
**/

global class LeadSquaredOppDetailsCallOutBatch implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable {
    Public Set<Id> setOfIds = new Set<Id>();
    global LeadSquaredOppDetailsCallOutBatch(Set<Id> setOfIds){
        this.setOfIds = setOfIds;
    }
    global LeadSquaredOppDetailsCallOutBatch(){

    }
    global void execute(SchedulableContext SC) {
 	    database.executebatch(new LeadSquaredOppDetailsCallOutBatch(),25);
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String queryString = UtilityClass.getQueryString('Opportunity');
        queryString += ' ,Appointment_Venue_Square__r.Name,Interior_Design_Partner__r.Name,Property_Name__r.Name,Sales_Manager__r.Name From Opportunity where Lead_square_modified_date__c !=null';
        if(!setOfIds.isEmpty()){
            queryString += '  and id=:setOfIds';
        }
        return Database.getQueryLocator(queryString);
    }

    global void execute(Database.BatchableContext bc, List<Opportunity> listOfOppRecords) { 
        try{
            //Lead_square_modified_date__c
            if(!listOfOppRecords.isEmpty()){
                Map<Id,SObject> mapOfSobject = new Map<Id,SObject>();
                for(Opportunity eachOpp : listOfOppRecords){
                    mapOfSobject.put(eachOpp.id,(SObject)eachOpp);
                }
                if(!mapOfSobject.isEmpty()){
                    LeadSquaredBatchCallOutHandler.handleLeadSquaredDetailsCallOuts(mapOfSobject,'Opportunity');
                }
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            Logger.log('Exception','LeadSquaredOppDetailsCallOutBatch','execute method',e.getMessage(),e.getStackTraceString(),null);
        }
    }   

    global void finish(Database.BatchableContext bc){ 
        System.debug('finish method');   
    }
}