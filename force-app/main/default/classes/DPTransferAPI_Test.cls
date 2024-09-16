@isTest
public class DPTransferAPI_Test {

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
    public  static testMethod void DpTransferAPITest1(){
        Test.startTest();
        IDRec =[Select id from Interior_Designer__c Limit 1];
        ld = [Select id From Lead limit 1];
        ld.Interior_Designer__c = IDRec.id;
        update ld;
        opportunityRec = [select id from Opportunity limit 1];
        opportunityRec.Interior_Design_Partner__c = IDRec.id;
        update  opportunityRec;
        DPTransferAPI.RequestWrapper reqst1 = new DPTransferAPI.RequestWrapper();
        reqst1.new_DP_Email='intdesig2@gmail.com';
        reqst1.old_DP_EMail='intdesig1@gmail.com';
        String JSONMsg = JSON.serialize(reqst1);
         try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/DPTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
          DPTransferAPI.DPTransferUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
     public  static testMethod void DpTransferAPITest2(){
        Test.startTest();
        IDRec =[Select id from Interior_Designer__c Limit 1];
        ld = [Select id From Lead limit 1];
        ld.Interior_Designer__c = IDRec.id;
        update ld;
        opportunityRec = [select id from Opportunity limit 1];
        opportunityRec.Interior_Design_Partner__c = IDRec.id;
        update  opportunityRec;
        DPTransferAPI.RequestWrapper reqst1 = new DPTransferAPI.RequestWrapper();
        reqst1.new_DP_Email='intdesig2@gmail.com';
        reqst1.old_DP_EMail='';
        String JSONMsg = JSON.serialize(reqst1);
         try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/DPTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
          DPTransferAPI.DPTransferUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public  static testMethod void DpTransferAPITest3(){
        Test.startTest();
        IDRec =[Select id from Interior_Designer__c Limit 1];
        ld = [Select id From Lead limit 1];
        ld.Interior_Designer__c = IDRec.id;
        update ld;
        opportunityRec = [select id from Opportunity limit 1];
        opportunityRec.Interior_Design_Partner__c = IDRec.id;
        update  opportunityRec;
        DPTransferAPI.RequestWrapper reqst1 = new DPTransferAPI.RequestWrapper();
        reqst1.new_DP_Email='intdesig22@gmail.com';
        reqst1.old_DP_EMail='intdesig1@gmail.com';
        String JSONMsg = JSON.serialize(reqst1);
         try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/DPTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
          DPTransferAPI.DPTransferUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
     public  static testMethod void DpTransferAPITest4(){
        Test.startTest();
        IDRec =[Select id from Interior_Designer__c Limit 1];
        ld = [Select id From Lead limit 1];
        
        opportunityRec = [select id from Opportunity limit 1];
        
        DPTransferAPI.RequestWrapper reqst1 = new DPTransferAPI.RequestWrapper();
        reqst1.new_DP_Email='intdesig2@gmail.com';
        reqst1.old_DP_EMail='intdesig1@gmail.com';
        String JSONMsg = JSON.serialize(reqst1);
         try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/DPTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
          DPTransferAPI.DPTransferUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public  static testMethod void DpTransferAPITest5(){
        Test.startTest();
        ld = [Select id From Lead limit 1];
         opportunityRec = [select id from Opportunity limit 1];
        DPTransferAPI.RequestWrapper reqst1 = new DPTransferAPI.RequestWrapper();
        reqst1.new_DP_Email='intdesig1@gmail.com';
        reqst1.old_DP_EMail='intdesig2@gmail.com';
        String JSONMsg = JSON.serialize(reqst1);
         try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/DPTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
          DPTransferAPI.DPTransferUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public  static testMethod void DpTransferAPITest6(){
        
        Test.startTest();
        DPTransferAPI.RequestWrapper reqst1 = new DPTransferAPI.RequestWrapper();
        reqst1.new_DP_Email='intdesig112@gmail.com';
        reqst1.old_DP_EMail='int1@gmail.com';
        String JSONMsg = JSON.serialize(reqst1);
         try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/DPTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(''); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
          DPTransferAPI.DPTransferUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public  static testMethod void DpTransferAPITest7(){
        Test.startTest();
        IDRec =[Select id from Interior_Designer__c Limit 1];
        ld = [Select id From Lead limit 1];
        ld.Interior_Designer__c = IDRec.id;
        update ld;
        opportunityRec = [select id from Opportunity limit 1];
        opportunityRec.Interior_Design_Partner__c = IDRec.id;
        update  opportunityRec;
        DPTransferAPI.RequestWrapper reqst1 = new DPTransferAPI.RequestWrapper();
        reqst1.new_DP_Email='intdesig2@gmail.com';
        reqst1.old_DP_EMail='abc@gmails.com';
        String JSONMsg = JSON.serialize(reqst1);
         try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/DPTransferAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            
          DPTransferAPI.DPTransferUpdate();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    
}