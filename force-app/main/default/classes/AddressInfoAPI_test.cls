@isTest
public class AddressInfoAPI_test {
    public static testMethod void createNewMasterPropertyNotPresents() {
         test.startTest();
        Account acc= new Account();
        acc.Name ='testacc';
        insert acc;
        Lead l = new Lead();
        l.FirstName = 'Hamsa';
        l.LastName = 'Raj';
        l.Email = 'HamsaRaj@gmail.com';
        l.Phone = '9000000009';
        l.City = 'Bengaluru';
        l.LeadSource = 'Google Ad';
        l.Status = 'Fresh Lead';
        l.Sub_Status__c = 'New';
        l.Account__c=acc.id;
        insert l;
         
         String JSONMsg='{"PlaceId":"qwyriophdiepo","LeadId":"'+l.id+'","OppId": "","Type": "Property","Name": "Brigade Palmsprings","City": "Bengaluru","lat": "12.971100","lng":"77.640920","Postal Code": null,"Locality": "Brigade Palmsprings","Landmark": null,"Property_Type__c": "Apartment","Street": "35/37, Brigade Millenium Road, Paradise Colony, Phase 7, J. P. Nagar, Bengaluru, Karnataka 560078, India","State": "KA","Map Link": "https://maps.google.com/?cid=9766203242150079081" }';
          try{
             RestRequest req = new RestRequest(); // Build the REST Request for testing
             req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
             req.requestURI = '/services/apexrest/AddressInfoAPI';
             req.httpMethod = 'POST';        // Perform a POST
             req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
             RestContext.request = req;
             AddressInfoAPI.AddressInfoAPI();
            }
            catch(exception e){
                system.debug('exception');
            }
             Test.stopTest();
    }
    
    public static testMethod void googlePlaceIdExtactMatch() {
      test.startTest();
      Map<String,String> mapRecordType = new Map<String,String>();
      Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
      for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
        mapRecordType.put(reType.getDeveloperName(),reType.getRecordTypeId());
      }
         Account acc= new Account();
        acc.Name ='testacc';
        insert acc;
      Lead l = new Lead();
      l.FirstName = 'Hamsa';
      l.LastName = 'Raj';
      l.Email = 'HamsaRaj@gmail.com';
      l.Phone = '9000000009';
      l.City = 'Bengaluru';
      l.LeadSource = 'Google Ad';
      l.Status = 'Fresh Lead';
      l.Sub_Status__c = 'New';
        l.Account__c= acc.id;
      insert l;

      Master__c m = new Master__c();
      m.isActive__c = true;
      m.Type__c = 'Property';
      m.Name = 'Brigade Palmsprings';
      m.Full_Name__c = 'Brigade Palmsprings';
      m.Total_Won_Opportunity__c = 6;
      m.Avg_Opportunites_Month__c = 20;
      m.Location__latitude__s = 12.971100;
      m.Location__longitude__s = 77.640920;
      m.RecordTypeId = mapRecordType.get('Property');
      m.PlaceId__c = 'qwyriophdiepo';
      m.Verification_Status__c = 'Google Verified';
      insert m;

      String JSONMsg='{"PlaceId":"qwyriophdiepo","LeadId":"'+l.id+'","OppId": "","Type": "Property","Name": "Brigade Palmsprings","City": "Bengaluru","lat": "12.971100","lng":"77.640920","Postal Code": null,"Locality": "Brigade Palmsprings","Landmark": null,"Property_Type__c": "Apartment","Street": "35/37, Brigade Millenium Road, Paradise Colony, Phase 7, J. P. Nagar, Bengaluru, Karnataka 560078, India","State": "KA","Map Link": "https://maps.google.com/?cid=9766203242150079081" }';
      try{
          RestRequest req = new RestRequest(); // Build the REST Request for testing
          req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
          req.requestURI = '/services/apexrest/AddressInfoAPI';
          req.httpMethod = 'POST';        // Perform a POST
          req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
          
          RestResponse res = new RestResponse();
          RestContext.request = req;
          RestContext.response = res;
          AddressInfoAPI.AddressInfoAPI();
        }
        catch(exception e){
            system.debug('exception');
        }
        test.StopTest();
    }

    public static testMethod void googleVerfiedStringMatch() {
      test.startTest();
      Map<String,String> mapRecordType = new Map<String,String>();
      Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
      for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
        mapRecordType.put(reType.getDeveloperName(),reType.getRecordTypeId());
      }
         Account acc= new Account();
        acc.Name ='testacc';
        insert acc;
      Lead l = new Lead();
      l.FirstName = 'Hamsa';
      l.LastName = 'Raj';
      l.Email = 'HamsaRaj@gmail.com';
      l.Phone = '9000000009';
      l.City = 'Bengaluru';
      l.LeadSource = 'Google Ad';
      l.Status = 'Fresh Lead';
      l.Sub_Status__c = 'New';
      l.Account__c= acc.id;
      insert l;

      Master__c m = new Master__c();
      m.isActive__c = true;
      m.Type__c = 'Property';
      m.Name = 'Brigade Palmsprings Phase1';
      m.Full_Name__c = 'Brigade Palmsprings Phase1';
      m.Total_Won_Opportunity__c = 6;
      m.Avg_Opportunites_Month__c = 20;
      m.Location__latitude__s = 12.971100;
      m.Location__longitude__s = 77.640920;
      m.RecordTypeId = mapRecordType.get('Property');
      m.Verification_Status__c = 'Google Verified';
      m.PlaceId__c = 'qwyriophdiepo';
      insert m;

      String JSONMsg='{"PlaceId":"qwyriophdiepowerfA","LeadId":"'+l.id+'","OppId": "","Type": "Property","Name": "Brigade Palmsprings","City": "Bengaluru","lat": "12.971100","lng":"77.640920","Postal Code": null,"Locality": "Brigade Palmsprings","Landmark": null,"Property_Type__c": "Apartment","Street": "35/37, Brigade Millenium Road, Paradise Colony, Phase 7, J. P. Nagar, Bengaluru, Karnataka 560078, India","State": "KA","Map Link": "https://maps.google.com/?cid=9766203242150079081" }';
      try{
          RestRequest req = new RestRequest(); // Build the REST Request for testing
          req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
          req.requestURI = '/services/apexrest/AddressInfoAPI';
          req.httpMethod = 'POST';        // Perform a POST
          req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
          
          RestResponse res = new RestResponse();
          RestContext.request = req;
          RestContext.response = res;
          AddressInfoAPI.AddressInfoAPI();
        }
        catch(exception e){
            system.debug('exception');
        }
        test.StopTest();
    }

    public static testMethod void StringMatchManuallyVerfied() {
      test.startTest();
      Map<String,String> mapRecordType = new Map<String,String>();
      Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
      for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
        mapRecordType.put(reType.getDeveloperName(),reType.getRecordTypeId());
      }
         Account acc= new Account();
        acc.Name ='testacc';
        insert acc;
      Lead l = new Lead();
      l.FirstName = 'Hamsa';
      l.LastName = 'Raj';
      l.Email = 'HamsaRaj@gmail.com';
      l.Phone = '9000000009';
      l.City = 'Bengaluru';
      l.LeadSource = 'Google Ad';
      l.Status = 'Fresh Lead';
      l.Sub_Status__c = 'New';
      l.Account__c= acc.id;
      insert l;

      Master__c m = new Master__c();
      m.isActive__c = true;
      m.Type__c = 'Property';
      m.Name = 'Brigade Palmsprings Phase1';
      m.Full_Name__c = 'Brigade Palmsprings Phase1';
      m.Total_Won_Opportunity__c = 6;
      m.Avg_Opportunites_Month__c = 20;
      m.Location__latitude__s = 12.971100;
      m.Location__longitude__s = 77.640920;
      m.RecordTypeId = mapRecordType.get('Property');
      m.Verification_Status__c = 'Manually Verified';
      m.PlaceId__c = 'qwyriophdiepo';
      insert m;

      String JSONMsg='{"PlaceId":"qwyriophdiepowerfA","LeadId":"'+l.id+'","OppId": "","Type": "Property","Name": "Brigade Palmsprings","City": "Bengaluru","lat": "12.971100","lng":"77.640920","Postal Code": null,"Locality": "Brigade Palmsprings","Landmark": null,"Property_Type__c": "Apartment","Street": "35/37, Brigade Millenium Road, Paradise Colony, Phase 7, J. P. Nagar, Bengaluru, Karnataka 560078, India","State": "KA","Map Link": "https://maps.google.com/?cid=9766203242150079081" }';
      try{
          RestRequest req = new RestRequest(); // Build the REST Request for testing
          req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
          req.requestURI = '/services/apexrest/AddressInfoAPI';
          req.httpMethod = 'POST';        // Perform a POST
          req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
          
          RestResponse res = new RestResponse();
          RestContext.request = req;
          RestContext.response = res;
          AddressInfoAPI.AddressInfoAPI();
        }
        catch(exception e){
            system.debug('exception');
        }
        test.StopTest();
    }

    public static testMethod void PlaceIdiSNull() {
      test.startTest();
      Map<String,String> mapRecordType = new Map<String,String>();
      Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
      for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
        mapRecordType.put(reType.getDeveloperName(),reType.getRecordTypeId());
      }
         Account acc= new Account();
        acc.Name ='testacc';
        insert acc;
      Lead l = new Lead();
      l.FirstName = 'Hamsa';
      l.LastName = 'Raj';
      l.Email = 'HamsaRaj@gmail.com';
      l.Phone = '9000000009';
      l.City = 'Bengaluru';
      l.LeadSource = 'Google Ad';
      l.Status = 'Fresh Lead';
      l.Sub_Status__c = 'New';
        l.Account__c= acc.id;
      insert l;

      Master__c m = new Master__c();
      m.isActive__c = true;
      m.Type__c = 'Property';
      m.Name = 'Brigade Palmsprings Phase1';
      m.Full_Name__c = 'Brigade Palmsprings Phase1';
      m.Total_Won_Opportunity__c = 6;
      m.Avg_Opportunites_Month__c = 20;
      m.Location__latitude__s = 12.971100;
      m.Location__longitude__s = 77.640920;
      m.RecordTypeId = mapRecordType.get('Property');
      insert m;

      String JSONMsg='{"LeadId":"'+l.id+'","OppId": "","Type": "Property","Name": "Brigade Palmsprings","City": "Bengaluru","lat": "","lng":"","Postal Code": null,"Locality": "Brigade Palmsprings","Landmark": null,"Property_Type__c": "Apartment","Street": "35/37, Brigade Millenium Road, Paradise Colony, Phase 7, J. P. Nagar, Bengaluru, Karnataka 560078, India","State": "KA","Map Link": "https://maps.google.com/?cid=9766203242150079081" }';
      try{
          RestRequest req = new RestRequest(); // Build the REST Request for testing
          req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
          req.requestURI = '/services/apexrest/AddressInfoAPI';
          req.httpMethod = 'POST';        // Perform a POST
          req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
          
          RestResponse res = new RestResponse();
          RestContext.request = req;
          RestContext.response = res;
          AddressInfoAPI.AddressInfoAPI();
        }
        catch(exception e){
            system.debug('exception');
        }
        test.StopTest();
    }            

    public static testMethod void createNewMasterNoRecordMatch() {
      test.startTest();
      Map<String,String> mapRecordType = new Map<String,String>();
      Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
      for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
        mapRecordType.put(reType.getDeveloperName(),reType.getRecordTypeId());
      }
         Account acc= new Account();
        acc.Name ='testacc';
        insert acc;
      Lead l = new Lead();
      l.FirstName = 'Hamsa';
      l.LastName = 'Raj';
      l.Email = 'HamsaRaj@gmail.com';
      l.Phone = '9000000009';
      l.City = 'Bengaluru';
      l.LeadSource = 'Google Ad';
      l.Status = 'Fresh Lead';
      l.Sub_Status__c = 'New';
      l.Account__c= acc.id;
      insert l;

      Master__c m = new Master__c();
      m.isActive__c = true;
      m.Type__c = 'Property';
      m.Name = 'Brigade Palmsprings Phase1';
      m.Full_Name__c = 'Brigade Palmsprings Phase1';
      m.Total_Won_Opportunity__c = 6;
      m.Avg_Opportunites_Month__c = 20;
      m.Location__latitude__s = 12.971100;
      m.Location__longitude__s = 77.640920;
      m.RecordTypeId = mapRecordType.get('Property');
      insert m;

      String JSONMsg='{"LeadId":"'+l.id+'","OppId": "","Type": "Property","Name": "Brigade Palmsprings phase2","City": "Bengaluru","lat": "12.9711","lng":"77.640930","Postal Code": null,"Locality": "Brigade Palmsprings","Landmark": null,"Property_Type__c": "Apartment","Street": "35/37, Brigade Millenium Road, Paradise Colony, Phase 7, J. P. Nagar, Bengaluru, Karnataka 560078, India","State": "KA","Map Link": "https://maps.google.com/?cid=9766203242150079081" }';
      try{
          RestRequest req = new RestRequest(); // Build the REST Request for testing
          req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
          req.requestURI = '/services/apexrest/AddressInfoAPI';
          req.httpMethod = 'POST';        // Perform a POST
          req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
          
          RestResponse res = new RestResponse();
          RestContext.request = req;
          RestContext.response = res;
          AddressInfoAPI.AddressInfoAPI();
        }
        catch(exception e){
            system.debug('exception');
        }
        test.StopTest();
    }            
          
     public static testMethod void manuallyVerifiedExactNameMatch() {
      test.startTest();
      Map<String,String> mapRecordType = new Map<String,String>();
      Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
      for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
        mapRecordType.put(reType.getDeveloperName(),reType.getRecordTypeId());
      }
       Account acc= new Account();
        acc.Name ='testacc';
        insert acc;
      Lead l = new Lead();
      l.FirstName = 'Hamsa';
      l.LastName = 'Raj';
      l.Email = 'HamsaRaj@gmail.com';
      l.Phone = '9000000009';
      l.City = 'Bengaluru';
      l.LeadSource = 'Google Ad';
      l.Status = 'Fresh Lead';
      l.Sub_Status__c = 'New';
         l.Account__c= acc.id;
      insert l;

      Master__c m = new Master__c();
      m.isActive__c = true;
      m.Type__c = 'Property';
      m.Name = 'Brigade Palmsprings Phase2';
      m.Full_Name__c = 'Brigade Palmsprings Phase2';
      m.Total_Won_Opportunity__c = 6;
      m.Avg_Opportunites_Month__c = 20;
      m.Location__latitude__s = 12.971100;
      m.Location__longitude__s = 77.640920;
      m.RecordTypeId = mapRecordType.get('Property');
      m.Verification_Status__c = 'Manually Verified';
      m.Unique_Name__c = 'brigadepalmsprings2';
      m.PlaceId__c = 'qwyriophdiepo';
      insert m;

      String JSONMsg='{"PlaceId":"qwyriophdiepowerfA","LeadId":"'+l.id+'","OppId": "","Type": "Property","Name": "Brigade Palmsprings Phase2","City": "Bengaluru","lat": "12.971100","lng":"77.640920","Postal Code": null,"Locality": "Brigade Palmsprings","Landmark": null,"Property_Type__c": "Apartment","Street": "35/37, Brigade Millenium Road, Paradise Colony, Phase 7, J. P. Nagar, Bengaluru, Karnataka 560078, India","State": "KA","Map Link": "https://maps.google.com/?cid=9766203242150079081" }';
      try{
          RestRequest req = new RestRequest(); // Build the REST Request for testing
          req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
          req.requestURI = '/services/apexrest/AddressInfoAPI';
          req.httpMethod = 'POST';        // Perform a POST
          req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
          
          RestResponse res = new RestResponse();
          RestContext.request = req;
          RestContext.response = res;
          AddressInfoAPI.AddressInfoAPI();
          //AddressInfoAPI.SendEmailToManager('test error');
        }
        catch(exception e){
            system.debug('exception');
        }
        test.StopTest();
    }               
    public static testMethod void matchPropertyNameTest() {
        test.startTest();
        AddressInfoAPI.matchPropertyName('sExisting', 'sMatchString');
        test.stopTest();
    }
}