@isTest
Public class TypeFormLeadCreation_Test{

    public static testMethod void success(){
    
        String request = '{"event_id":"01DC6RT3DK4A4FPD6BPMDC48KH","event_type":"form_response","form_response":{"form_id":"Mb8Xsw","token":"9471327240a8b520162d2fba829de55e","landed_at":"2019-05-31T11:01:05Z","submitted_at":"2019-05-31T11:01:16Z","hidden":{"city":"Hyderabad","email":"Test550@avengers.com","interiordesigneremail":"test2@homelan.com","phone":"9997676950","testlead":"Yes"},"definition":{"id":"Mb8Xsw","title":"Lead Creation","fields":[{"id":"MYDPAmHhr0QH","title":"Customer Name","type":"short_text","ref":"b15b6961-6bce-4b39-999f-e301ea84ff17","properties":{}}]},"answers":[{"type":"text","text":"NewUser abc","field":{"id":"MYDPAmHhr0QH","type":"short_text","ref":"b15b6961-6bce-4b39-999f-e301ea84ff17"}}]}}';
        try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeFormLeadCreation';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(request); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeFormLeadCreation.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }      
    }
    
     public static testMethod void Failuer(){
    
        String request = '{"event_id":"01DC6RT3DK4A4FPD6BPMDC48KH","event_type":"form_response","form_response":{"form_id":"Mb8Xsw","token":"9471327240a8b520162d2fba829de55e","landed_at":"2019-05-31T11:01:05Z","submitted_at":"2019-05-31T11:01:16Z","hidden":{"city":"Hyderabad","email":"Test550@avengers.com","interiordesigneremail":"test2@homelan.com","phone":"9997676950","testlead":"Yes"},"definition":{"id":"Mb8Xsw","title":"Lead Creation","fields":[{"id":"MYDPAmHhr0QH","title":"Customer Name","type":"short_text","ref":"b15b6961-6bce-4b39-999f-e301ea84ff17","properties":{}}]},"answers":[]}}';
        try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeFormLeadCreation';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(request); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeFormLeadCreation.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }      
    }
}