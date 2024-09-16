@isTest
public class LeadAndOpportunityTransferAPI_Test {
    Public static Lead ld;
    Public static lead doowupLd;
    Public static Account accountRec;
    Public static Opportunity opportunityRec;
    Public static Showroom_User__C IMRec;
    Public static User us;
    //public static Batch_Processing_Check__c IMTransferCheck ;
    @TestSetup static void data() {
        //Create Lead Record
       
        
        accountRec = TestData_factory.createAccount(true);
        ld = TestData_Factory.CreateFreshLead(false);
        doowupLd =  TestData_Factory.CreateFreshLead(false);
        doowupLd.Account__c=accountRec.id;
        doowupLd.Brand__c='Doowup';
        insert doowupLd;
        ld.Account__c= accountRec.id;
        insert ld;
        opportunityRec = TestData_factory.createOpportunity(accountRec.Id, true);
        IMRec = TestData_factory.createShowroomUser(true);
        us = TestData_factory.inserWTAUser('testwta@gmail.com','aliasNe',true);
        
    }
    
    public static testMethod void leadOrOpportunityUpdateTest1(){
        Test.startTest();
        ld = [Select id From Lead limit 1];
         opportunityRec = [select id,Brand__c,leadId__c from Opportunity limit 1];
        opportunityRec.leadId__c =ld.id;
        update opportunityRec;
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C limit 1];
        IMRec.Role__c='Iron man';
        LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='IM Transfer';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer ='IM Transfer';
        
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        
}
    public static testMethod void leadOrOpportunityUpdateTestdoowup1(){
        Test.startTest();
        doowupLd = [Select id From Lead where Brand__c='Doowup' limit 1];
        opportunityRec = [select id,Brand__c,leadId__c from Opportunity limit 1];
        opportunityRec.leadId__c =doowupLd.id;
        update opportunityRec;
        ld = [Select id From Lead limit 1];
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C limit 1];
        IMRec.Role__c='Product Consultant';
        update IMRec;
        LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c;
        requst1.SF_Lead_Opportunity_ID =doowupLd.id;
        requst1.Type_Of_Transfer ='IM Transfer';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email = IMRec.Email__c;
        requst2.SF_Lead_Opportunity_ID =Ld.id;
        requst2.Type_Of_Transfer ='IM Transfer';
        LeadAndOpportunityTransferAPI.RequestWrapper requst3 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst3.Initiator_Email ='abc@abc.com';
        requst3.Sales_Manager_Email = IMRec.Email__c;
        requst3.SF_Lead_Opportunity_ID =OpportunityRec.id;
        requst3.Type_Of_Transfer ='IM Transfer';
        
        
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        
}
    public static testMethod void leadOrOpportunityDoowUpdateTest123(){
        Test.startTest();
        ld = [Select id From Lead limit 1];
        
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C ];
        IMRec.Role__c='Product Consultant';
        update IMRec;
        opportunityRec = [select id from Opportunity limit 1];
        
        
        LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        
        requst1.Sales_Manager_Email = IMRec.Email__c;
        
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Doowup Transfer';
        
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer ='Doowup Transfer';
        requst2.Lead_Source='HomeLane';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
         
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        }   
//}
   
   
     public static testMethod void leadOrOpportunityUpdateTest12(){
        Test.startTest();
        ld = [Select id From Lead limit 1];
        //IMTransferCheck =[select id,IsExecuting__c from Batch_Processing_Check__c limit 1 ];
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"IM Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
        
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Nimbus Transfer';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer ='Nimbus Transfer';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        
}
    public static testMethod void leadOrOpportunitNimbusyUpdateTest12(){
        Test.startTest();
        ld = [Select id From Lead limit 1];
        ld.Nimbus_Status__c='Sent to Nimbus';
        update ld;
        //IMTransferCheck =[select id,IsExecuting__c from Batch_Processing_Check__c limit 1 ];
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"IM Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
        
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Nimbus Transfer';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer ='Nimbus Transfer';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        
}
      public static testMethod void leadOrOpportunityUpdateTest13(){
        Test.startTest();
        ld = [Select id,Brand__c From Lead limit 1];
        ld.Brand__c='HomeLane';
          update ld;
        //IMTransferCheck =[select id,IsExecuting__c from Batch_Processing_Check__c limit 1 ];
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C];
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"IM Transfer"'+'","Initiator_Email":"abc@abc.com"}]'; 
          IMRec.Role__c='Tele Caller Agent';
          update  IMRec;
        opportunityRec = [select id,Brand__c from Opportunity limit 1];
     
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Telecaller Transfer';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer ='Telecaller Transfer';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        
}
    public static testMethod void leadOrOpportunityUpdateTest14(){
        Test.startTest();
        ld = [Select id,Brand__c From Lead limit 1];
        ld.Brand__c='HomeLane';
          update ld;
        //IMTransferCheck =[select id,IsExecuting__c from Batch_Processing_Check__c limit 1 ];
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C];
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"IM Transfer"'+'","Initiator_Email":"abc@abc.com"}]'; 
          IMRec.Role__c='Product Consultant';
          update  IMRec;
        opportunityRec = [select id,Brand__c from Opportunity limit 1];
     
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Telecaller Transfer';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer ='Telecaller Transfer';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        
}
public static testMethod void leadOrOpportunityUpdateTest2(){
        Test.startTest();
        ld = [Select id From Lead limit 1];
        
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"IM Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email =IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =opportunityRec.id;
        requst1.Type_Of_Transfer ='IM Transfer';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer ='IM Transfer';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        
} 
    public static testMethod void leadOrOpportunityUpdateTest3(){
        Test.startTest();
        ld = [Select id From Lead limit 1];
        
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"IM Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
         
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        
        String JSONMsg = JSON.serialize(reqList);
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        
}   
    public static testMethod void leadOrOpportunityUpdateTest4(){
        Test.startTest();
        ld = [Select id From Lead limit 1];
        
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C];
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"IM Transfer"'+'","Initiator_Email":"abc@abc.com"}]';   
          IMRec.Role__c='Pre-Sales Freelancer';
        update IMRec;
        opportunityRec = [select id from Opportunity limit 1];
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email =IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='FreeLancer Transfer';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer ='IM Transfer';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
       /* Batch_Processing_Check__c batchInProgressCheck = Batch_Processing_Check__c.getInstance('IM Transfer Check');
            batchInProgressCheck.IsExecuting__c = false;
        update batchInProgressCheck;*/
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        
}
    public static testMethod void leadOrOpportunityUpdateTest5(){
        Test.startTest();
        ld = [Select id From Lead limit 1];
        
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"IM Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email =IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='FreeLancer Transfer';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer ='Freelancer Transfer';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
       /* Batch_Processing_Check__c batchInProgressCheck = Batch_Processing_Check__c.getInstance('IM Transfer Check');
            batchInProgressCheck.IsExecuting__c = false;
        update batchInProgressCheck;*/
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        
}
    public static testMethod void leadOrOpportunityUpdateTest6(){
        Test.startTest();
        ld = [Select id From Lead limit 1];
        
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"IM Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email =IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='FreeLancer Transfer';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer ='IM Transfer';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = '';
       /* Batch_Processing_Check__c batchInProgressCheck = Batch_Processing_Check__c.getInstance('IM Transfer Check');
            batchInProgressCheck.IsExecuting__c = false;
        update batchInProgressCheck;*/
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        
}
    public static testMethod void leadOrOpportunityUpdateTest7(){
        Test.startTest();
        ld = [Select id From Lead limit 1];
        
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
              
        opportunityRec = [select id from Opportunity limit 1];
         
        LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email =IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='abc';
        
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer ='abc';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
       /* Batch_Processing_Check__c batchInProgressCheck = Batch_Processing_Check__c.getInstance('IM Transfer Check');
            batchInProgressCheck.IsExecuting__c = false;
        update batchInProgressCheck;*/
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        
}
    public static testMethod void leadOrOpportunityUpdateTest8(){
        Test.startTest();
       
        
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID ='0079D00000DEBwKQAX';
        requst1.Type_Of_Transfer ='IM Transfer';
        
        
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
       
        String JSONMsg = JSON.serialize(reqList);
       
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
      public static testMethod void leadOrOpportunityUpdateTest55(){
        Test.startTest();
       
        
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID ='0069D00000DEBwKQAX';
        requst1.Type_Of_Transfer ='Doowup Transfer';
        
        
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
       
        String JSONMsg = JSON.serialize(reqList);
       
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void leadOrOpportunityUpdateTest56(){
        Test.startTest();
       
        
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID ='0059D00000DEBwKQAX';
        requst1.Type_Of_Transfer ='Doowup Transfer';
        
        
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
       
        String JSONMsg = JSON.serialize(reqList);
       
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
         public static testMethod void leadOrOpportunityUpdateTest9(){
        Test.startTest();
        ld = [Select id From Lead limit 1];
        //IMTransferCheck =[select id,IsExecuting__c from Batch_Processing_Check__c limit 1 ];
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"Telecaller Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
        
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Telecaller Transfer';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer ='IM Transfer';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        

}
    public static testMethod void leadOrOpportunityUpdateTest10(){
        Test.startTest();
        ld = [Select id From Lead limit 1];
        //IMTransferCheck =[select id,IsExecuting__c from Batch_Processing_Check__c limit 1 ];
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        IMRec.Role__c='Product Consultant';
        update IMRec;
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"Telecaller Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
        
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Doowup Transfer';
        requst1.Lead_Source ='HomeLane';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer ='Doowup Transfer';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        

}
    public static testMethod void leadOrOpportunityUpdateTest11(){
        Test.startTest();
        ld = [Select id From Lead limit 1];
        ld.Brand__c='Doow up';
        us = [select id,Email from user limit 1];
        //IMTransferCheck =[select id,IsExecuting__c from Batch_Processing_Check__c limit 1 ];
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        IMRec.Role__c='Product Consultant';
        update IMRec;
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"Telecaller Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
        
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = us.Email ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Doowup Transfer';
        requst1.Lead_Source ='HomeLane';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email = us.Email ;
        requst2.SF_Lead_Opportunity_ID =ld.id;
        requst2.Type_Of_Transfer ='Doowup Presales Transfer';
        requst2.Lead_Source ='HomeLane';
        
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        //reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        

}
    public static testMethod void leadOrOpportunityTest13(){
        Test.startTest();
        ld = [Select id,Brand__c From Lead limit 1];
        ld.Brand__c='Doowup';
        update ld;
        us = [select id,Email from user limit 1];
        //IMTransferCheck =[select id,IsExecuting__c from Batch_Processing_Check__c limit 1 ];
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        IMRec.Role__c='Iron Man';
        update IMRec;
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"Telecaller Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
        
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Doowup Transfer';
        requst1.Lead_Source ='HomeLane';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = 'testnouser@gmail.com' ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Doowup Transfer';
        requst1.Lead_Source ='HomeLane';
        
        
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        

}
    public static testMethod void leadOrOpportunityTestPresales(){
        Test.startTest();
        ld = [Select id,Brand__c From Lead limit 1];
        ld.Brand__c='Doowup';
        update ld;
        
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        IMRec.Role__c='Doowup Presales';
        update IMRec;
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"Telecaller Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
        
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Doowup Presales Transfer';
        requst1.Lead_Source ='HomeLane';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email = IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID =opportunityRec.id;
        requst2.Type_Of_Transfer ='Doowup Presales Transfer';
        requst2.Lead_Source ='HomeLane';
        
        
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        

}
    public static testMethod void leadOrOpportunityTestPresales2(){
        Test.startTest();
        ld = [Select id,Brand__c From Lead limit 1];
        ld.Brand__c='HomeLane';
        update ld;
        
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        IMRec.Role__c='Doowup Presales';
        update IMRec;
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"Telecaller Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
        
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Doowup Presales Transfer';
        requst1.Lead_Source ='HomeLane';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email = IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID =opportunityRec.id;
        requst2.Type_Of_Transfer ='Doowup Presales Transfer';
        requst2.Lead_Source ='HomeLane';
        
        
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        

}
    public static testMethod void leadOrOpportunityTestPresales3(){
        Test.startTest();
        ld = [Select id,Brand__c From Lead limit 1];
        ld.Brand__c='Doowup';
        update ld;
        
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        IMRec.Role__c='Iron man';
        update IMRec;
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"Telecaller Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
        
         LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Doowup Presales Transfer';
        requst1.Lead_Source ='HomeLane';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email = IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID =opportunityRec.id;
        requst2.Type_Of_Transfer ='Doowup Presales Transfer';
        requst2.Lead_Source ='HomeLane';
        
        
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        

}
    public static testMethod void leadOrOpportunityTestsameEmail(){
        Test.startTest();
        ld = [Select id,Brand__c From Lead limit 1];
        
        
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        IMRec.Role__c='Iron man';
        update IMRec;
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":" Transfer"'+'","Initiator_Email":"abc@abc.com"},{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"Doowup Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
        
        LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Doowup Transfer';
        requst1.Lead_Source ='HomeLane';
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email = IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID =ld.id;
        requst2.Type_Of_Transfer ='Doowup Transfer';
        requst2.Lead_Source ='HomeLane';
        
        
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        

}
    public static testMethod void leadOrOpportunityImEmail(){
        Test.startTest();
        ld = [Select id,Brand__c From Lead limit 1];
        
        
        IMRec = [Select id,Email__c from Showroom_User__C limit 1];
        IMRec.Role__c='Tele Caller Agent';
        update IMRec;
        //String JSONMsg='[{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":" Transfer"'+'","Initiator_Email":"abc@abc.com"},{"SF_Lead_Opportunity_ID":"'+ld.Id+'","Sales_Manager_Email":"'+IMRec.Email__c+'","Type_Of_Transfer":"Doowup Transfer"'+'","Initiator_Email":"abc@abc.com"}]';       
        opportunityRec = [select id from Opportunity limit 1];
        
        LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='IM Transfer';
        requst1.Lead_Source ='HomeLane';
       
        
        
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        

}
    public static testMethod void updateImTest1(){
        test.startTest();
        IMRec = [Select id,Email__c,IM_Class__c from Showroom_User__C limit 1];
        ld = [Select id,Brand__c From Lead limit 1];
        LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =IMRec.id;
        requst1.Type_Of_Transfer ='IM Classification';
        requst1.Lead_Source ='Gold';
        
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email = IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID =IMRec.id;
        requst2.Type_Of_Transfer ='IM Classification';
        requst2.Lead_Source ='Gold+';
        
        LeadAndOpportunityTransferAPI.RequestWrapper requst3 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst3.Initiator_Email ='abc@abc.com';
        requst3.Sales_Manager_Email = IMRec.Email__c ;
        requst3.SF_Lead_Opportunity_ID =ld.id;
        requst3.Type_Of_Transfer ='IM Classification';
        requst3.Lead_Source ='Gold';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        reqList.add(requst3);        
        
        String JSONMsg = JSON.serialize(reqList);
        
        
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    
    public static testMethod void OfflineRelandedTest(){
        test.startTest();
        IMRec = [Select id,Email__c,IM_Class__c from Showroom_User__C limit 1];
        ld = [Select id,Brand__c From Lead limit 1];
        LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        requst1.Sales_Manager_Email = IMRec.Email__c ;
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Offline Relanded Transfer';
        requst1.Lead_Source ='Gold';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
         String JSONMsg = JSON.serialize(reqList);
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }    
    
    
    
     public static testMethod void leadOrOpportunityCubicoUpdateTest123()
     {
        Test.startTest();
        ld = [Select id From Lead limit 1];
        
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C ];
        IMRec.Role__c='Product Consultant';
        update IMRec;
        opportunityRec = [select id from Opportunity limit 1];
        
        
        LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        
        requst1.Sales_Manager_Email = IMRec.Email__c;
        
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer ='Cubico Transfer';
        
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer ='Cubico Transfer';
        requst2.Lead_Source='HomeLane';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
         
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        }   
    
    
    public static testMethod void leadOrOpportunityNimbusDoowupOppTransfer()
     {
        Test.startTest();
        ld = [Select id From Lead limit 1];
        
        IMRec = [Select id,Email__c,Role__c from Showroom_User__C ];
        IMRec.Role__c='Iron Man';
        update IMRec;
        opportunityRec = [select id from Opportunity limit 1];
        
        
        LeadAndOpportunityTransferAPI.RequestWrapper requst1 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst1.Initiator_Email ='abc@abc.com';
        
        requst1.Sales_Manager_Email = IMRec.Email__c;
        
        requst1.SF_Lead_Opportunity_ID =ld.id;
        requst1.Type_Of_Transfer =GenericConstants.Nimbus_Doowup_Opp_Transfer;
        
        LeadAndOpportunityTransferAPI.RequestWrapper requst2 = new LeadAndOpportunityTransferAPI.RequestWrapper();
        requst2.Initiator_Email ='abc@abc.com';
        requst2.Sales_Manager_Email =IMRec.Email__c ;
        requst2.SF_Lead_Opportunity_ID = opportunityRec.id;
        requst2.Type_Of_Transfer =GenericConstants.Nimbus_Doowup_Opp_Transfer;
        requst2.Lead_Source='HomeLane';
        List<LeadAndOpportunityTransferAPI.RequestWrapper> reqList = new List<LeadAndOpportunityTransferAPI.RequestWrapper>();
        reqList.add(requst1);
        reqList.add(requst2);
        String JSONMsg = JSON.serialize(reqList);
        
         
         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/LeadAndOpportunityTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
            LeadAndOpportunityTransferAPI.leadOrOpportunityUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
        }   
}