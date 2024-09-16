@isTest
public class WebHookController_Test {
    @TestVisible
    public static testMethod void webHook1() {
        Interior_Designer__c objInt = new Interior_Designer__c();
        objInt.Name = 'Test Designer';
        objInt.Email__c = 'test@test.com';
        insert objInt;
        SYstem.debug('ID IS : '+objInt.Id);
        test.startTest();
           
        String JSONMsg = '{"event_id":"01CTQR1E6PKATN7AKSASPBADAC","event_type":"form_response","form_response":{"form_id":"mv78AS","token":"ac43a6d5ae43cb37f895dbb5babd2543","landed_at":"2018-10-26T08:31:24Z","submitted_at":"2018-10-26T08:32:20Z","hidden":{"email":"","interiordesignerid":"' + objInt.Id + '","name":""},"definition":{"id":"mv78AS","title":"Availability","fields":[{"id":"H3BcCkUfQ8eM","title":"Kindly update your availability.","type":"dropdown","ref":"2baae94a-2128-47f4-9f4a-329181cc6d3a","properties":{}},{"id":"VePbeGHKa1s3","title":"Leave Start Date","type":"date","ref":"f1c22173-40c7-4776-8024-49a176189b8b","properties":{}},{"id":"PUchXlzdvPxr","title":"Leave End Date","type":"date","ref":"3a92e788-7270-4d54-9d4b-ec486fb05a98","properties":{}}]},"answers":[{"type":"choice","choice":{"label":"On Short Leave."},"field":{"id":"H3BcCkUfQ8eM","type":"dropdown","ref":"2baae94a-2128-47f4-9f4a-329181cc6d3a"}},{"type":"date","customDate":"2018-08-08","field":{"id":"VePbeGHKa1s3","type":"date","ref":"f1c22173-40c7-4776-8024-49a176189b8b"}},{"type":"date","customDate":"2018-09-09","field":{"id":"PUchXlzdvPxr","type":"date","ref":"3a92e788-7270-4d54-9d4b-ec486fb05a98"}}]}}}';  
        System.JSONParser parser = System.JSON.createParser(JSONMsg );
        InteriorDesignerWebhookResponse inte = new InteriorDesignerWebhookResponse(parser ); 
            try{
             RestRequest req = new RestRequest(); // Build the REST Request for testing
             req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
             req.requestURI = '/services/apexrest/WebHookAPITesting';
             req.httpMethod = 'POST';        // Perform a POST
             req.requestBody = Blob.valueof(JSONMsg ); // Add JSON Message as a POST
             
             RestResponse res = new RestResponse();
             RestContext.request = req;
             RestContext.response = res;
             SYstem.debug('RES IS : '+res);
             SYstem.debug('REQ IS : '+req);
             WebHookController.getRec();
             
            }
            catch(exception e){
                system.debug('exception');
            }
        
         Test.stopTest();
    }
    @TestVisible
    public static testMethod void webHook2() {
        Interior_Designer__c objInt = new Interior_Designer__c();
        objInt.Name = 'Test Designer';
        objInt.Email__c = 'test@test.com';
        insert objInt;
        SYstem.debug('ID IS : '+objInt.Id);
        test.startTest();
             
        String JSONMsg='{"event_id":"01CTQR1E6PKATN7AKSASPBADAC","event_type":"form_response","form_response":{"form_id":"mv78AS","token":"ac43a6d5ae43cb37f895dbb5babd2543","landed_at":"2018-10-26T08:31:24Z","submitted_at":"2018-10-26T08:32:20Z","hidden":{"email":"","interiordesignerid":"' + objInt.Id + '","name":""},"definition":{"id":"mv78AS","title":"Availability","fields":[{"id":"H3BcCkUfQ8eM","title":"Kindly update your availability.","type":"dropdown","ref":"2baae94a-2128-47f4-9f4a-329181cc6d3a","properties":{}},{"id":"VePbeGHKa1s3","title":"Leave Start Date","type":"date","ref":"f1c22173-40c7-4776-8024-49a176189b8b","properties":{}},{"id":"PUchXlzdvPxr","title":"Leave End Date","type":"date","ref":"3a92e788-7270-4d54-9d4b-ec486fb05a98","properties":{}}]},"answers":[{"type":"choice","choice":{"label":"I am available to take meetings."},"field":{"id":"H3BcCkUfQ8eM","type":"dropdown","ref":"2baae94a-2128-47f4-9f4a-329181cc6d3a"}},{"type":"date","customDate":"2018-08-08","field":{"id":"VePbeGHKa1s3","type":"date","ref":"f1c22173-40c7-4776-8024-49a176189b8b"}},{"type":"date","customDate":"2018-09-09","field":{"id":"PUchXlzdvPxr","type":"date","ref":"3a92e788-7270-4d54-9d4b-ec486fb05a98"}}]}}}';      
        try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/WebHookAPITesting';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         WebHookController.getRec();
        }
        catch(exception e){
            system.debug('exception');
        }
        
         Test.stopTest();
    }
    @TestVisible
    public static testMethod void webHook3() {
        Interior_Designer__c objInt = new Interior_Designer__c();
        objInt.Name = 'Test Designer';
        objInt.Email__c = 'test@test.com';
        insert objInt;
        SYstem.debug('ID IS : '+objInt.Id);
        test.startTest();
             
        String JSONMsg='{"event_id":"01CTQR1E6PKATN7AKSASPBADAC","event_type":"form_response","form_response":{"form_id":"mv78AS","token":"ac43a6d5ae43cb37f895dbb5babd2543","landed_at":"2018-10-26T08:31:24Z","submitted_at":"2018-10-26T08:32:20Z","hidden":{"email":"","interiordesignerid":"' + objInt.Id + '","name":""},"definition":{"id":"mv78AS","title":"Availability","fields":[{"id":"H3BcCkUfQ8eM","title":"Kindly update your availability.","type":"dropdown","ref":"2baae94a-2128-47f4-9f4a-329181cc6d3a","properties":{}},{"id":"VePbeGHKa1s3","title":"Leave Start Date","type":"date","ref":"f1c22173-40c7-4776-8024-49a176189b8b","properties":{}},{"id":"PUchXlzdvPxr","title":"Leave End Date","type":"date","ref":"3a92e788-7270-4d54-9d4b-ec486fb05a98","properties":{}}]},"answers":[{"type":"choice","choice":{"label":"On Long Leave."},"field":{"id":"H3BcCkUfQ8eM","type":"dropdown","ref":"2baae94a-2128-47f4-9f4a-329181cc6d3a"}},{"type":"date","customDate":"2018-08-08","field":{"id":"VePbeGHKa1s3","type":"date","ref":"f1c22173-40c7-4776-8024-49a176189b8b"}},{"type":"date","customDate":"2018-09-09","field":{"id":"PUchXlzdvPxr","type":"date","ref":"3a92e788-7270-4d54-9d4b-ec486fb05a98"}}]}}}';      
        try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/WebHookAPITesting';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         WebHookController.getRec();
        }
        catch(exception e){
            system.debug('exception');
        }
        
         Test.stopTest();
    }
    @TestVisible
    public static testMethod void webHook4() {
        Interior_Designer__c objInt = new Interior_Designer__c();
        objInt.Name = 'Test Designer';
        objInt.Email__c = 'test@test.com';
        insert objInt;
        SYstem.debug('ID IS : '+objInt.Id);
        test.startTest();
             
        String JSONMsg='{"event_id":"01CTQR1E6PKATN7AKSASPBADAC","event_type":"form_response","form_response":{"form_id":"mv78AS","token":"ac43a6d5ae43cb37f895dbb5babd2543","landed_at":"2018-10-26T08:31:24Z","submitted_at":"2018-10-26T08:32:20Z","hidden":{"email":"","interiordesignerid":"' + objInt.Id + '","name":""},"definition":{"id":"mv78AS","title":"Availability","fields":[{"id":"H3BcCkUfQ8eM","title":"Kindly update your availability.","type":"dropdown","ref":"2baae94a-2128-47f4-9f4a-329181cc6d3a","properties":{}},{"id":"VePbeGHKa1s3","title":"Leave Start Date","type":"date","ref":"f1c22173-40c7-4776-8024-49a176189b8b","properties":{}},{"id":"PUchXlzdvPxr","title":"Leave End Date","type":"date","ref":"3a92e788-7270-4d54-9d4b-ec486fb05a98","properties":{}}]},"answers":[{"type":"choice","choice":{"label":"I have quit HomeLane."},"field":{"id":"H3BcCkUfQ8eM","type":"dropdown","ref":"2baae94a-2128-47f4-9f4a-329181cc6d3a"}},{"type":"date","customDate":"2018-08-08","field":{"id":"VePbeGHKa1s3","type":"date","ref":"f1c22173-40c7-4776-8024-49a176189b8b"}},{"type":"date","customDate":"2018-09-09","field":{"id":"PUchXlzdvPxr","type":"date","ref":"3a92e788-7270-4d54-9d4b-ec486fb05a98"}}]}}}';    
      //  WebHookController.InteriorDesignerWebhookResponse1 page = new WebHookController.InteriorDesignerWebhookResponse1();  
        try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/WebHookAPITesting';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         WebHookController.getRec();
        }
        catch(exception e){
            system.debug('exception');
        }
        
         Test.stopTest();
    }
    
   //  public static testMethod void webHook5() {
       // WebHookController.InteriorDesignerWebhookResponse1 page = new WebHookController.InteriorDesignerWebhookResponse1();
      //  page.label  = 'Hello';
      //  System.debug('>>>> Section Name '+page.label);
   //  }
}