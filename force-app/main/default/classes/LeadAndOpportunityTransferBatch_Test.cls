@isTest
public class LeadAndOpportunityTransferBatch_Test {
    Public static Lead ld, Dlead;
    Public static Account accountRec,accountRecDlead;
    Public static Opportunity opportunityRec;
    Public static Showroom_User__C IMRec;
    public static Setup_Configuration__c setUp;
    public static ID recTypeId;
    public static user WTAUser;
    
    @TestSetup static void data() {
        //Create Lead Record
        accountRec = TestData_factory.createAccount(true);
        accountRecDlead = TestData_factory.createAccount(true);
        ld = TestData_Factory.CreateFreshLead(false);
        Dlead = TestData_Factory.CreateFreshDoowupLead(false);
        ld.Account__c = accountRec.id;
        insert ld;
        Dlead.Account__c = accountRecDlead.id;
        insert Dlead;
        opportunityRec = TestData_factory.createOpportunity(accountRec.Id, true);
        IMRec = TestData_factory.createShowroomUser(true);
         WTAUser = TestData_factory.inserWTAUser('usr22@gmail.com','us2',true);       
        Setup_Configuration__c setUpUpdate = new  Setup_Configuration__c();
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        
        insert setUpUpdate;
        
    }
    
    public static testMethod void leadOrOpportunityUpdateTest1(){
        Test.startTest();
        ld =[select Id from Lead where Phone = '9000000000' Limit 1];
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Initiator_Email__c ='abc@abc.com';
        setUp.Lead__c =ld.id;
        setUp.Type_Of_Transfer__c ='IM Transfer';
        setUp.RecordTypeId = recTypeId;
        setUp.Sales_Manager_Email__c =IMRec.Email__c;
        setUp.Operation_Status__c='Open';
        
        update setUp;
        LeadAndOpportunityTransferBatch ldTransfer = new LeadAndOpportunityTransferBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
    public static testMethod void leadOrOpportunityUpdateTest2(){
        Test.startTest();
        ld =[select Id from Lead where Phone = '9000000000' Limit 1];
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        opportunityRec = [select id from Opportunity limit 1];
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Initiator_Email__c ='abc@abc.com';
        setUp.Opportunity__c =opportunityRec.id;
        setUp.Type_Of_Transfer__c ='IM Transfer';
        setUp.RecordTypeId =recTypeId;
        setUp.Sales_Manager_Email__c =IMRec.Email__c;
        setUp.Operation_Status__c='Open';
        
        update setUp;
        LeadAndOpportunityTransferBatch ldTransfer = new LeadAndOpportunityTransferBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
    public static testMethod void leadOrOpportunityUpdateTest3(){
        Test.startTest();
        ld =[select Id from Lead where Phone = '9000000011' Limit 1];
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        opportunityRec = [select id from Opportunity limit 1];
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Initiator_Email__c ='abc@abc.com';
        setUp.Lead__c = ld.id;
        setUp.Type_Of_Transfer__c ='FreeLancer Transfer';
        setUp.RecordTypeId =recTypeId;
        setUp.Sales_Manager_Email__c =IMRec.Email__c;
        setUp.Operation_Status__c='Open';
        
    //    update setUp;
        LeadAndOpportunityTransferBatch ldTransfer = new LeadAndOpportunityTransferBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
     public static testMethod void leadOrOpportunityUpdateTest4(){
        Test.startTest();
        ld =[select Id from Lead where Phone = '9000000011' Limit 1];
        IMRec = [Select id,Email__c, Role__c from Showroom_User__C limit 1];
         Imrec.Role__c = 'Tele Caller Agent';
         update IMRec ;
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Initiator_Email__c ='abc@abc.com';
        setUp.Lead__c =ld.id;
        setUp.Type_Of_Transfer__c ='Telecaller Transfer';
        setUp.RecordTypeId = recTypeId;
        setUp.Sales_Manager_Email__c =IMRec.Email__c;
        setUp.Operation_Status__c='Open';
        
         update setUp;
        LeadAndOpportunityTransferBatch ldTransfer = new LeadAndOpportunityTransferBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
     public static testMethod void leadOrOpportunityUpdateTest5(){
        Test.startTest();
        ld =[select Id from Lead where Phone = '9000000000' Limit 1];
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Initiator_Email__c ='abc@abc.com';
        setUp.Lead__c =ld.id;
        setUp.Type_Of_Transfer__c ='Nimbus Transfer';
        setUp.RecordTypeId = recTypeId;
        setUp.Sales_Manager_Email__c =IMRec.Email__c;
        setUp.Operation_Status__c='Open';
        
        update setUp;
        LeadAndOpportunityTransferBatch ldTransfer = new LeadAndOpportunityTransferBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
    public static testMethod void leadOrOpportunityUpdateTest6(){
        Test.startTest();
        ld =[select Id from Lead where Phone = '9000000011' Limit 1];
        ld.Budget_Range__c='Upto 1.5L';
        update ld;
        
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C limit 1];
        IMrec.Role__c ='Doowup Presales';
        update IMrec;
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Initiator_Email__c ='abc@abc.com';
        setUp.Lead__c =ld.id;
        setUp.Type_Of_Transfer__c ='Doowup Transfer';
        setUp.RecordTypeId = recTypeId;
        setUp.Sales_Manager_Email__c =IMRec.Email__c;
        setUp.Operation_Status__c='Open';
        setUp.Lead_Source__c ='HomeLane';
        
        update setUp;
        LeadAndOpportunityTransferBatch ldTransfer = new LeadAndOpportunityTransferBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
    
    public static testMethod void leadOrOpportunityUpdateTestNewDoowup(){
        Test.startTest();
        ld =[select Id from Lead where Phone = '9000000011' Limit 1];
        ld.Budget_Range__c='1.5L - 4L';
        update ld;
        
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C limit 1];
        IMrec.Role__c ='Doowup Presales';
        update IMrec;
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Initiator_Email__c ='abc@abc.com';
        setUp.Lead__c =ld.id;
        setUp.Type_Of_Transfer__c ='Doowup Transfer';
        setUp.RecordTypeId = recTypeId;
        setUp.Sales_Manager_Email__c ='nimbus@homelane.com';
        setUp.Operation_Status__c='Open';
        setUp.Lead_Source__c ='HomeLane';
        
        update setUp;
        LeadAndOpportunityTransferBatch ldTransfer = new LeadAndOpportunityTransferBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
    
    public static testMethod void leadOrOpportunityUpdateTest7(){
        Test.startTest();
        ld =[select Id,Brand__c from Lead where Phone = '9000000011' Limit 1];
        ld.Brand__c='Doowup';
        update ld;
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C limit 1];
        IMrec.Role__c ='Doowup Presales';
        update IMrec;
        
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Initiator_Email__c ='abc@abc.com';
        setUp.Lead__c =ld.id;
        setUp.Type_Of_Transfer__c ='Doowup Presales Transfer';
        setUp.RecordTypeId = recTypeId;
        setUp.Sales_Manager_Email__c =IMRec.Email__c;
        setUp.Operation_Status__c='Open';
        
        update setUp;
        LeadAndOpportunityTransferBatch ldTransfer = new LeadAndOpportunityTransferBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
    public static testMethod void leadOrOpportunityUpdateTest8(){
        Test.startTest();
        ld =[select Id,Brand__c from Lead where Phone = '9000000011' Limit 1];
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C limit 1];
        IMRec.Role__c='Inside Sales Agent';
        update IMRec;
        //WTAUser = [select Id,Email from User Limit 1];
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Initiator_Email__c ='abc@abc.com';
        setUp.Lead__c =ld.id;
        setUp.Type_Of_Transfer__c ='Inside Sales Transfer';
        setUp.RecordTypeId = recTypeId;
        setUp.Sales_Manager_Email__c = IMRec.Email__c;
        setUp.Operation_Status__c='Open';
        setUp.Lead_Source__c ='HomeLane';
        
        update setUp;
        LeadAndOpportunityTransferBatch ldTransfer = new LeadAndOpportunityTransferBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
    public static testMethod void leadOrOpportunityUpdateTest9(){
        Test.startTest();
        ld =[select Id,Brand__c from Lead where Phone = '9000000000' Limit 1];
        ld.Nimbus_Status__c='Sent to Nimbus';
        update ld;
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C limit 1];
        
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Initiator_Email__c ='abc@abc.com';
        setUp.Lead__c =ld.id;
        setUp.Type_Of_Transfer__c ='Nimbus Transfer';
        setUp.RecordTypeId = recTypeId;
        setUp.Sales_Manager_Email__c =IMRec.Email__c;
        setUp.Operation_Status__c='Open';
        
        update setUp;
        LeadAndOpportunityTransferBatch ldTransfer = new LeadAndOpportunityTransferBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
    public static testMethod void leadOrOpportunityUpdateTest10(){
        Test.startTest();
        ld =[select Id,Brand__c from Lead where Phone = '9000000000' Limit 1];
        ld.Brand__c='Doowup';
        update ld;
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C limit 1];
        IMRec.Role__c='Doowup Presales';
        update IMRec;
        
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Initiator_Email__c ='abc@abc.com';
        setUp.Lead__c =ld.id;
        setUp.Type_Of_Transfer__c ='Doowup Presales Transfer';
        setUp.RecordTypeId = recTypeId;
        setUp.Sales_Manager_Email__c =IMRec.Email__c;
        setUp.Operation_Status__c='Open';
        
        update setUp;
        LeadAndOpportunityTransferBatch ldTransfer = new LeadAndOpportunityTransferBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
    
     public static testMethod void leadOrOpportunityUpdateTestpresales(){
        Test.startTest();
        ld =[select Id,Brand__c from Lead where Phone = '9000000000' Limit 1];
        ld.Brand__c='Doowup';
        update ld;
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C limit 1];
        IMRec.Role__c='Pre-Sales Freelancer';
        update IMRec;
        
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Initiator_Email__c ='abc@abc.com';
        setUp.Lead__c =ld.id;
        setUp.Type_Of_Transfer__c ='Freelancer Transfer';
        setUp.RecordTypeId = recTypeId;
        setUp.Sales_Manager_Email__c =IMRec.Email__c;
        setUp.Operation_Status__c='Open';
        
        update setUp;
        LeadAndOpportunityTransferBatch ldTransfer = new LeadAndOpportunityTransferBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
    
    
    
      public static testMethod void leadOrOpportunityUpdateTestCubico(){
        Test.startTest();
        ld =[select Id from Lead where Phone = '9000000011' Limit 1];
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C limit 1];
        IMrec.Role__c ='Doowup Presales';
        update IMrec;
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Initiator_Email__c ='abc@abc.com';
        setUp.Lead__c =ld.id;
        setUp.Type_Of_Transfer__c ='Cubico Transfer';
        setUp.RecordTypeId = recTypeId;
        setUp.Sales_Manager_Email__c =IMRec.Email__c;
        setUp.Operation_Status__c='Open';
        setUp.Lead_Source__c ='HomeLane';
        
        update setUp;
        LeadAndOpportunityTransferBatch ldTransfer = new LeadAndOpportunityTransferBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
    
    
      public static testMethod void leadOrOpportunityUpdateTestNew(){
        Test.startTest();
        ld =[select Id from Lead where Phone = '9000000011' Limit 1];
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C limit 1];
        IMrec.Role__c ='Doowup Presales';
        update IMrec;
        recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        setUp =[select id,Name from Setup_Configuration__c limit 1];
        setUp.Initiator_Email__c ='abcd@abc.com';
        setUp.Lead__c =ld.id;
        setUp.Type_Of_Transfer__c ='Offline Relanded Transfer';
        setUp.RecordTypeId = recTypeId;
        setUp.Sales_Manager_Email__c =IMRec.Email__c;
        setUp.Operation_Status__c='Open';
        setUp.Lead_Source__c ='HomeLane';
        
        update setUp;
        LeadAndOpportunityTransferBatch ldTransfer = new LeadAndOpportunityTransferBatch();
        database.executeBatch(ldTransfer);
        Test.stopTest();
        
        
    }
}