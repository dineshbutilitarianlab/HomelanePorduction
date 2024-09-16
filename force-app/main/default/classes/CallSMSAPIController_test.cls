@isTest
global class CallSMSAPIController_test implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"response":"success","tiny_url":"tinyurl.com/y45cog","status":1}');
        response.setStatusCode(200);
        return response; 
    }
    @isTest static void CallSMS() {
        Master__c m = new Master__c();
        m.Type__c = 'Showroom';
        m.Name = 'Testing the Shwoeroom';
        insert m;
        
         Lead l = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd@hamelane.com',
            Phone='6530007890',
            City='Noida',
            Status='Fresh Lead',
             Sub_Status__c ='Follow Up Later',
             Appointment_Venue_Square__c = m.Id,
             LeadSource='Website'
             ); 

        insert l; 
        System.debug('Lead is : '+l);  
     //  CallSMSAPIController.dummyTestCover();
        Test.setMock(HttpCalloutMock.class, new CallSMSAPIController_test ()); 
      //  HttpResponse response = response;
      //  String contentType = response.getHeader('Content-Type');
      //  String actualValue = response.getBody();
      //  return response; 
              
    } 
}