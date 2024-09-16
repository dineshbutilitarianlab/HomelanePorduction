@istest
global class CampaignTransfer_test 
{    
    Public static Lead ld;
    Public static Custom_Campaign__c ccRecord;
    
    @TestSetup static void data() 
    { 
        ccRecord =new Custom_Campaign__c();
        ccRecord.Name = 'Nimbus Telugu Transfer';
        ccRecord.City__c = 'Bengaluru;Coimbatore';
        ccRecord.Offline_Priority_Values__c = 'L0;L1;L2';
        ccRecord.Batch_Process_Description__c = '';
        ccRecord.Total_Leads_Processed__c = 0;
        insert ccRecord;
        
        Account acc= new account();
        acc.name='TestAcc';
        insert acc;             
       
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Account__c =acc.id;
        ld.city='Bengaluru';
        ld.Offline_Priority_Lead__c = 'L0';
        insert ld;
        
    }
    
    
    
    public testMethod static void testscenario1()
    {    
        
        try
        {
            ld=[select id from lead limit 1];            
            List<Id> LeadIds = new List<Id>();   
            LeadIds.add(ld.id);
            
            ccRecord = [SELECT id from Custom_Campaign__c LIMIT 1];                
            List<Id> cc_record_ids = new List<Id>();   
            cc_record_ids.add(ccRecord.Id);
            
            test.startTest();
            CampaignTransfer.CampaignTransferMethod(cc_record_ids);
            test.stoptest();
        }
        catch(exception e)
        {
            system.debug('Exception :'+e.getMessage());
        }           
        
    }
     
}