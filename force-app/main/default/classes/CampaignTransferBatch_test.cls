@isTest
public class CampaignTransferBatch_test 
{
 	Public static Lead ld;
    Public static Custom_Campaign__c ccRecord;
    Public static String CampaignName;
    Public static Id CampaignId;
    Public static Decimal totalLeads;
    Public static String Description;
    Public static List<String> cityList = new List<String>();
    Public static List<String> priorityValues = new List<String>();
       
    @TestSetup static void data() 
    { 
        ccRecord =new Custom_Campaign__c();
        ccRecord.Name = 'Nimbus Telugu Transfer';
        ccRecord.City__c = 'Bengaluru;Coimbatore';
        ccRecord.Offline_Priority_Values__c = 'L0;L1;L2';
        ccRecord.Batch_Process_Description__c = 'Test';
        ccRecord.Total_Leads_Processed__c = 0;
        insert ccRecord;
        
        Account acc = new account();
        acc.Name='acctest';
        insert acc;

        ld = TestData_Factory.CreateFreshLead(false);
        ld.Status = 'Fresh Lead';
        ld.Sub_Status__c = 'Unverified';
        ld.Account__c =acc.id;
        ld.city='Bengaluru';
        ld.Offline_Priority_Lead__c = 'L0';
        insert ld;
        
    }
    
    public testMethod static void CampaignTransferBatch_test1()
    {
        Test.startTest();
        Database.executeBatch(new CampaignTransferBatch());
        test.stopTest();
    }
    
    public testMethod static void CampaignTransferBatch_test2()
    {
        Test.startTest();        
        
        List<Custom_Campaign__c> ccList = new  List<Custom_Campaign__c>();     
        ccList = [SELECT id,City__c, Offline_Priority_Values__c,Name,Batch_Process_Description__c,Total_Leads_Processed__c 
                  from Custom_Campaign__c LIMIT 1];
        
        System.debug('ccList :'+ccList);
        
         CampaignId = ccList[0].Id ;
         CampaignName = ccList[0].Name ;
    //     cityList =  ccList[0].City__c.split(';'); 
    //     priorityValues = ccList[0].Offline_Priority_Values__c.split(';'); 
         totalLeads = ccList[0].Total_Leads_Processed__c;
         Description = ccList[0].Batch_Process_Description__c;
        
         ld = [Select id from Lead limit 1];
         Set<Id> setOfIds = new Set<Id>();
         setOfIds.add(ld.id);
        
        Database.executeBatch(new CampaignTransferBatch(setOfIds,CampaignName,CampaignId,TotalLeads,Description,ccRecord));
        test.stopTest();
    }
    
    public testMethod static void CampaignTransferBatch_test3()
    {
        Test.startTest();
        String sch = '0 0 23 * * ?';
        test.stopTest();
    }
}