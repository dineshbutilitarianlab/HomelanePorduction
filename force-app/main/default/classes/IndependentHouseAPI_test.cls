@isTest
public class IndependentHouseAPI_test {
    @isTest static void TestData() {
        Master__c mas = new Master__c();
        mas.Name = 'Test Property';
        insert mas;
        System.debug('######mas  '+mas);
        
        lead newLead = new Lead();
        newLead.Email = 'test@test.com';
        newLead.lastName = 'Test';
        newLead.Phone = '1234567890';
        newLead.LeadSource = 'Google Ad';
        newLead.Status = 'Fresh Lead';
        newLead.Property__c = mas.Id;
        newLead.Budget_Range__c = '1.5L - 4L';
        newLead.City = 'Bengaluru';
        newLead.Regional_Language_Preference__c = 'Hindi';
      //  newLead.Appointment_Venue_Square__c = m1.Id;
        insert newLead;
        System.debug('######newLead  '+newLead);
     
         test.startTest();
         String JSONMsg='{"Property__c" : "' + mas.Id + '",  "Independent_House_Address__c" : "Bengaluru",  "Property_Type__c" : "Independent House",  "LeadId" : "' + newLead.Id + '"}';
         System.debug('*******JSONMsg  '+JSONMsg);
          try{
             RestRequest req = new RestRequest(); // Build the REST Request for testing
             req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
             req.requestURI = '/services/apexrest/IndependentHouseAPI';
             req.httpMethod = 'POST';        // Perform a POST
             req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
             
           //  RestResponse res = new RestResponse();
             RestContext.request = req;
           //  RestContext.response = res;
             IndependentHouseAPI.IndependentHouse();
          
            }
            catch(exception e){
                system.debug('exception  '+e.getMessage());
            }
             Test.stopTest();
    }
    
     @isTest static void TestData1() {
        Master__c mas = new Master__c();
        mas.Name = 'Test Property';
        insert mas;
        System.debug('######mas  '+mas);
      
        Account a = new Account(LastName = 'test', firstName = 'test');
        insert a;
        System.debug('######  '+a); 
        
        
        Opportunity opp5 = new Opportunity();
        opp5.name = 'first1mklzv';
        opp5.StageName='D1 Initiated';
        opp5.Opportunity_Stage__c = 'Won';
        opp5.AccountId = a.id;
        opp5.CloseDate = Date.Today();
        //opp5.Interior_Design_Partner__c = inte.id;
        opp5.Amount = 500000;
        insert opp5;
        System.debug('######opp5  '+opp5);
        
        
         test.startTest();
         String JSONMsg='{"Property__c" : "' + mas.Id + '",  "Independent_House_Address__c" : "Bengaluru",  "Property_Type__c" : "Independent House",  "LeadId" : "' + opp5.Id + '"}';
         System.debug('*******JSONMsg  '+JSONMsg);
          try{
             RestRequest req = new RestRequest(); // Build the REST Request for testing
             req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
             req.requestURI = '/services/apexrest/IndependentHouseAPI';
             req.httpMethod = 'POST';        // Perform a POST
             req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
             
           //  RestResponse res = new RestResponse();
             RestContext.request = req;
           //  RestContext.response = res;
             IndependentHouseAPI.IndependentHouse();
          
            }
            catch(exception e){
                system.debug('exception  '+e.getMessage());
            }
             Test.stopTest();
    }
}