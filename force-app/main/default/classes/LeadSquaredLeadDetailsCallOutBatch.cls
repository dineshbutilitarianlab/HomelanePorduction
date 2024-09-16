/**
 * @File Name          : LeadSquaredLeadDetailsCallOutBatch.cls
 * @Description        : 
 * @Author             : Bharatesh Shetty
 * @Group              : 
 * @Last Modified By   : Bharatesh Shetty
 * @Last Modified On   : 8/29/2019, 11:08:00 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/14/2019, 4:18:44 PM   Bharatesh Shetty     Initial Version
**/
global class LeadSquaredLeadDetailsCallOutBatch implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable {
    Public Set<Id> setOfIds = new Set<Id>();
    global LeadSquaredLeadDetailsCallOutBatch(Set<Id> setOfIds){
        this.setOfIds = setOfIds;
    }
    global LeadSquaredLeadDetailsCallOutBatch(){
        
    }
    global void execute(SchedulableContext SC) {
 	    database.executebatch(new LeadSquaredLeadDetailsCallOutBatch(),25);
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String queryString = UtilityClass.getQueryString('Lead');
        queryString += ' ,Appointment_Venue_Square__r.name,Interior_Designer__r.Name,Property__r.Name,Sales_Manager__r.Name From Lead';
        queryString += ' where Lead_square_modified_date__c !=null';
        if(!setOfIds.isEmpty()){
            queryString += '  and id=:setOfIds';
        }
        return Database.getQueryLocator(queryString);
    }

    global void execute(Database.BatchableContext bc, List<Lead> listOfLeadRecords) { 
        try{
            //Lead_square_modified_date__c
            if(!listOfLeadRecords.isEmpty()){
                Map<Id,SObject> mapOfSobject = new Map<Id,SObject>();
                for(Lead eachLead : listOfLeadRecords){
                    mapOfSobject.put(eachLead.id,(SObject)eachLead);
                }
                if(!mapOfSobject.isEmpty()){
                    LeadSquaredBatchCallOutHandler.handleLeadSquaredDetailsCallOuts(mapOfSobject,'Lead');
                }
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            Logger.log('Exception','LeadSquaredLeadDetailsCallOutBatch','execute method',e.getMessage(),e.getStackTraceString(),null);
        }
    }   

    global void finish(Database.BatchableContext bc){ 
        System.debug('finish method');   
    }
}