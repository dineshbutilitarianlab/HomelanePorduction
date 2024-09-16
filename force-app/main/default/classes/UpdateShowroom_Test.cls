@isTest
public class UpdateShowroom_Test {
    Public static Lead ld;
    Public static Master__c showRoom;
    Public static Account acc;
    Public static Opportunity opp;
    @TestSetup static void data() {
        //Create a Active ShowRoom Master record
        showRoom = TestData_Factory.CreateShowRoom(False);
        showRoom.Type__c ='Showroom';
        insert showRoom;
        acc = TestData_Factory.createAccount(true);
        //Create Lead Record
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Account__c = acc.id;
        insert ld;
        
        //Create Account Record
        acc = TestData_Factory.createAccount(true);
        
        //Create Opportunity records
        Opp = TestData_Factory.createOpportunity(acc.Id, true);
        
    }
    public static testMethod void UpdateShowroomTest1(){
        Test.startTest();
        ld = [Select id from Lead limit 1];
        showRoom = [Select id from Master__c limit 1];
        opp = [Select id from Opportunity limit 1];
        
        String showroomId = String.valueOf(showRoom.Id);
        String leadId = String.valueOf(ld.Id);
        String oppId = String.valueOf(opp.Id);
        
        String JSONMsg='{"recordId":"'+leadId+'","showRoomId":"'+showroomId+'"}';        
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            UpdateShowroomAPI.updateShowroom();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    
    public static testMethod void UpdateShowroomTest2(){
        Test.startTest();
        ld = [Select id from Lead limit 1];
        showRoom = [Select id from Master__c limit 1];
        opp = [Select id from Opportunity limit 1];
        
        String showroomId = String.valueOf(showRoom.Id);
        String leadId = String.valueOf(ld.Id);
        String oppId = String.valueOf(opp.Id);
        
        String JSONMsg='{"recordId":"xyz","showRoomId":"xyz"}';
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            UpdateShowroomAPI.updateShowroom();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    
    public static testMethod void UpdateShowroomTest3(){
        
        ld = [Select id from Lead limit 1];
        showRoom = [Select id from Master__c limit 1];
        opp = [Select id from Opportunity limit 1];
        opp.LeadId__c = ld.id;
        update opp;
        
        Test.startTest();
        String showroomId = String.valueOf(showRoom.Id);
        String leadId = String.valueOf(ld.Id);
        String oppId = String.valueOf(opp.Id);
        
        String JSONMsg='{"recordId":"'+oppId+'","showRoomId":"'+showroomId+'"}'; 
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            UpdateShowroomAPI.updateShowroom();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void UpdateShowroomTest4(){
        
        ld = [Select id from Lead limit 1];
        showRoom = [Select id from Master__c limit 1];
        opp = [Select id from Opportunity limit 1];
        
        Test.startTest();
        String showroomId = String.valueOf(showRoom.Id);
        String leadId = String.valueOf(ld.Id);
        String oppId = String.valueOf(opp.Id);
        
        String JSONMsg='{"recordId":"'+oppId+'","showRoomId":"'+showroomId+'"}'; 
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            UpdateShowroomAPI.updateShowroom();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
     public static testMethod void UpdateShowroomTest5(){
        
        ld = [Select id from Lead limit 1];
        showRoom = [Select id from Master__c limit 1];
        opp = [Select id from Opportunity limit 1];
         
        showRoom.IsActive__c = false;
        update showRoom;
        
        Test.startTest();
        String showroomId = String.valueOf(showRoom.Id);
        String leadId = String.valueOf(ld.Id);
        String oppId = String.valueOf(opp.Id);
        
        String JSONMsg='{"recordId":"'+oppId+'","showRoomId":"'+showroomId+'"}'; 
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            UpdateShowroomAPI.updateShowroom();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
     public static testMethod void UpdateShowroomTest6(){
        
        ld = [Select id from Lead limit 1];
        showRoom = [Select id from Master__c limit 1];
        opp = [Select id from Opportunity limit 1];
        
        Test.startTest();
        String showroomId = String.valueOf(showRoom.Id);
        String leadId = String.valueOf(ld.Id);
        String oppId = String.valueOf(opp.Id);
        
        String JSONMsg='{"recordId":"","showRoomId":""}'; 
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            UpdateShowroomAPI.updateShowroom();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
     public static testMethod void UpdateShowroomTest7(){
        
        ld = [Select id from Lead limit 1];
        showRoom = [Select id from Master__c limit 1];
        opp = [Select id from Opportunity limit 1];
        acc = [Select id from Account limit 1];
        
        Test.startTest();
        String showroomId = String.valueOf(showRoom.Id);
        String leadId = String.valueOf(ld.Id);
        String accID = String.valueOf(acc.Id);
        
        String JSONMsg='{"recordId":"'+accID+'","showRoomId":"'+showroomId+'"}'; 
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/UpdateShowroomAPI';
            req.httpMethod = 'POST';        // Perform a POST
            
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            UpdateShowroomAPI.updateShowroom();
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
}