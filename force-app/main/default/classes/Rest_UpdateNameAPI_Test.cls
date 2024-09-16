@isTest
public class Rest_UpdateNameAPI_Test{
    Public static Lead ld;
    Public static Master__c showRoom;
    Public static Account acc;
    Public static Opportunity opp;
    @TestSetup static void data() {
        //Create a Active ShowRoom Master record
        showRoom = TestData_Factory.CreateShowRoom(False);
        showRoom.Type__c ='Showroom';
        insert showRoom;
        
        //Create Lead Record
        ld = TestData_Factory.CreateFreshLead(true);
        
        //Create Account Record
        Account acc= new Account();
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        acc.RecordTypeid=RecTypeId;
        acc.LastName='Abc';
        insert acc;
        
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        //Create Opportunity records
        Opp = TestData_Factory.createOpportunity(acc.Id, true);
        
    }
    
     public static testMethod void LeadSuccess(){
        Test.startTest();

        Lead ObjLead  = [Select id,Customer_ID__c from Lead limit 1];

        
        String JSONMsg='{"CustomerID":"'+ObjLead.Customer_ID__c +'","LastName":"Test USer","SobjectName":"Lead"}';        
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestResponse res = new RestResponse();
            RestContext.response = res;                
            
            Rest_UpdateNameAPI.updateName();
            lead testCheck = [Select LastName from Lead where Customer_ID__c =:ObjLead.Customer_ID__c ];
            //system.AssertEquals('Test USer',testCheck.LastName);  
            
      
            
        }

        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    
   public static testMethod void OpportunitySuccess(){
        Test.startTest();
        Lead ObjLead  = [Select id,Customer_ID__c from Lead limit 1];
        Account objAccount = [Select id,Customer_ID__c  from Account limit 1];
        objAccount .Customer_ID__c = ObjLead.Customer_ID__c;
        Update objAccount;
        Opportunity objOpportunity = [Select id,Customer_ID__c from Opportunity limit 1];
        
        system.debug('objOpportunity.Customer_ID__c '+objOpportunity.Customer_ID__c +'ObjLead.Customer_ID__c'+ObjLead.Customer_ID__c+'objAccount.Customer_ID__c'+objAccount.Customer_ID__c);
        
        String JSONMsg='{"CustomerID":"'+objAccount.Customer_ID__c+'","LastName":"Test USer","SobjectName":"Opportunity"}';        
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestResponse res = new RestResponse();
            RestContext.response = res;                
            
            Rest_UpdateNameAPI.updateName();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    
   public static testMethod void AccountError(){
        Test.startTest();
        Lead ObjLead  = [Select id,Customer_ID__c from Lead limit 1];
        Account objAccount = [Select id,Customer_ID__c  from Account limit 1];
        objAccount .Customer_ID__c = ObjLead.Customer_ID__c+'a';
        Update objAccount;
        Opportunity objOpportunity = [Select id,Customer_ID__c from Opportunity limit 1];
        
        system.debug('objOpportunity.Customer_ID__c '+objOpportunity.Customer_ID__c +'ObjLead.Customer_ID__c'+ObjLead.Customer_ID__c+'objAccount.Customer_ID__c'+objAccount.Customer_ID__c);
        
        String JSONMsg='{"CustomerID":"'+ObjLead.Customer_ID__c+'","LastName":"Test USer","SobjectName":"Opportunity"}';        
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestResponse res = new RestResponse();
            RestContext.response = res;                
            Rest_UpdateNameAPI.updateName();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }    
    
   public static testMethod void LeadError(){
        Test.startTest();
        Lead ObjLead  = [Select id,Customer_ID__c from Lead limit 1];
        
        String JSONMsg='{"CustomerID":"'+'BEN-TEST'+'","LastName":"Test USer","SobjectName":"Lead"}';        
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestResponse res = new RestResponse();
            RestContext.response = res;                
            Rest_UpdateNameAPI.updateName();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }  
   
   
   public static testMethod void OpportunityError(){
        Test.startTest();
        Lead ObjLead  = [Select id,Customer_ID__c from Lead limit 1];
        Account objAccount = [Select id,Customer_ID__c  from Account limit 1];
        objAccount .Customer_ID__c = ObjLead.Customer_ID__c;
        Update objAccount;        
        Opportunity objOpportunity = [Select id,Customer_ID__c from Opportunity limit 1];
        
        String JSONMsg='{"CustomerID":"BEN-NNA","LastName":"Test USer","SobjectName":"Opportunity"}';         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestResponse res = new RestResponse();
            RestContext.response = res;                
            Rest_UpdateNameAPI.updateName();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }    
    
   public static testMethod void EmptyParameter(){
        Test.startTest();
        
        String JSONMsg='{"CustomerID":,"LastName":"Test USer","SobjectName":"Opportunity"}';         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestResponse res = new RestResponse();
            RestContext.response = res;                
            Rest_UpdateNameAPI.updateName();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }    
    
   public static testMethod void invalidSobject(){
        Test.startTest();
        
        String JSONMsg='{"CustomerID":"asdfas","LastName":"Test USer","SobjectName":"Account"}';         
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestResponse res = new RestResponse();
            RestContext.response = res;                
            Rest_UpdateNameAPI.updateName();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }      
    
    public static testMethod void testDummy(){
        Test.startTest();
       // Rest_UpdateNameAPI.testMethodDummy1();
        Test.stopTest();
    }
    
   public static testMethod void ParamError(){
        Test.startTest();
        Lead ObjLead  = [Select id,Customer_ID__c from Lead limit 1];
        Account objAccount = [Select id,Customer_ID__c  from Account limit 1];
        objAccount .Customer_ID__c = ObjLead.Customer_ID__c+'a';
        Update objAccount;
        Opportunity objOpportunity = [Select id,Customer_ID__c from Opportunity limit 1];
        
        system.debug('objOpportunity.Customer_ID__c '+objOpportunity.Customer_ID__c +'ObjLead.Customer_ID__c'+ObjLead.Customer_ID__c+'objAccount.Customer_ID__c'+objAccount.Customer_ID__c);
        
        String JSONMsg='{"CustomerID":"'+ObjLead.Customer_ID__c+'","LastName":"","SobjectName":"Opportunity"}';        
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestResponse res = new RestResponse();
            RestContext.response = res;                
            Rest_UpdateNameAPI.updateName();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    
   public static testMethod void NoParam(){
        Test.startTest();
        Lead ObjLead  = [Select id,Customer_ID__c from Lead limit 1];
        Account objAccount = [Select id,Customer_ID__c  from Account limit 1];
        objAccount .Customer_ID__c = ObjLead.Customer_ID__c+'a';
        Update objAccount;
        Opportunity objOpportunity = [Select id,Customer_ID__c from Opportunity limit 1];
        
        system.debug('objOpportunity.Customer_ID__c '+objOpportunity.Customer_ID__c +'ObjLead.Customer_ID__c'+ObjLead.Customer_ID__c+'objAccount.Customer_ID__c'+objAccount.Customer_ID__c);
        
        String JSONMsg='';        
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestResponse res = new RestResponse();
            RestContext.response = res;                
            Rest_UpdateNameAPI.updateName();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }      
    
}