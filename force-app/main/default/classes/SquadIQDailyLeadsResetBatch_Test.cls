@isTest
public class SquadIQDailyLeadsResetBatch_Test {    
    @TestSetup static void data(){
        Id recTypeId = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('SquadIQ Configs').getRecordTypeId();
        
        Lead_Class_Scoring__c squadIQConfig = new Lead_Class_Scoring__c();
        squadIQConfig.RecordTypeId = recTypeId;
        insert squadIQConfig;
    }
    public testMethod static void SquadIQDailyLeadsResetBatchTest1(){
        Test.startTest();
        Database.executeBatch(new SquadIQDailyLeadsResetBatch());
        test.stopTest();
    }
    public testMethod static void SquadIQDailyLeadsResetBatchTest2(){
        Map<Id,Lead_Class_Scoring__c> mapOfSquadIQConfig = new Map<Id,Lead_Class_Scoring__c>([Select id from Lead_Class_Scoring__c]); 
        Test.startTest();
        Database.executeBatch(new SquadIQDailyLeadsResetBatch(mapOfSquadIQConfig.keySet()));
        test.stopTest();
    }
}