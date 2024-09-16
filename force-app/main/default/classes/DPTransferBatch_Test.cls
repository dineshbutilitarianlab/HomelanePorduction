@isTest
public class DPTransferBatch_Test {
 Public static Lead ld;
    Public static Account accountRec;
    Public static Opportunity opportunityRec;
    Public static Interior_Designer__c  IDRec;
    @TestSetup static void data() {
        //Create Lead Record
        ld = TestData_Factory.CreateFreshLead(true);
        accountRec = TestData_factory.createAccount(true);
        opportunityRec = TestData_factory.createOpportunity(accountRec.Id, true);
        Interior_Designer__c IDRec1 = new Interior_Designer__c();
        IDRec1.Name ='Interior designer 1';
        IDRec1.Email__c ='intdesig1@gmail.com';
        IDRec1.Active__c= true;
        insert IDRec1;
        Interior_Designer__c IDRec2 = new Interior_Designer__c();
        IDRec2.Name ='Interior designer 2';
        IDRec2.Email__c ='intdesig2@gmail.com';
        IDRec2.Active__c= true;
        insert IDRec2;
    }
    public  static testMethod void DpTransferBatchTest1(){
        Test.startTest();
        IDRec =[Select id from Interior_Designer__c Limit 1];
        ld = [Select id From Lead limit 1];
        ld.Interior_Designer__c = IDRec.id;
        update ld;
        opportunityRec = [select id from Opportunity limit 1];
        opportunityRec.Interior_Design_Partner__c = IDRec.id;
        
        update  opportunityRec;
        DPTransferBatch batchable = new DPTransferBatch('intdesig1@gmail.com','intdesig2@gmail.com',Lead.sOBjectType);
        database.executeBatch(batchable);
}
}