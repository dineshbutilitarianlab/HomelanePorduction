global class SquadIQDailyLeadsResetBatch implements Database.Batchable<sObject>,Schedulable{
    Public Set<Id> setOfIds = new Set<Id>();
    // Constructor to excecute only set of records in the Batch.
    global SquadIQDailyLeadsResetBatch(Set<Id> setOfIds){
        this.setOfIds = setOfIds;
    }
    global SquadIQDailyLeadsResetBatch(){
    }
    global void execute(SchedulableContext SC) {
        database.executebatch(new SquadIQDailyLeadsResetBatch(),1);
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Id recTypeId = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('SquadIQ Configs').getRecordTypeId();
        String queryString = UtilityClass.getQueryString('Lead_Class_Scoring__c');
        System.debug('setOfIds '+setOfIds);
        queryString += ' From Lead_Class_Scoring__c where RecordTypeId =:recTypeId';
        if(!setOfIds.isEmpty()){
            queryString += ' and id=:setOfIds';
        }
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead_Class_Scoring__c> listOfSquadIQConfigRecord) { 
        try{
            if(!listOfSquadIQConfigRecord.isEmpty()){
                Map<Id,Lead_Class_Scoring__c> mapOfSquadIQConfigRecordToUpdate = new Map<Id,Lead_Class_Scoring__c>();
                for(Lead_Class_Scoring__c SquadIQConfigRecord : listOfSquadIQConfigRecord){
                    SquadIQConfigRecord.Squad_IQ_Daily_Leads_Assigned__c = 0;
                    mapOfSquadIQConfigRecordToUpdate.put(SquadIQConfigRecord.Id,SquadIQConfigRecord);
                }
                if(!mapOfSquadIQConfigRecordToUpdate.isEmpty()){
                    update mapOfSquadIQConfigRecordToUpdate.values();
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