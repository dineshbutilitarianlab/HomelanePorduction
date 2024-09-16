@isTest

global class MockHttpResponseGeneratorAmeyo {//implements HttpCalloutMock

    /* global HTTPResponse respond(HTTPRequest req) {
                       
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            if(req.getEndPoint() != null && req.getEndPoint().Contains('1234567865'))
            res.setBody('{"beanResponse":[{"inserted":false,"exception":"[\"CustomerManager.Phone.number.does.not.match.with.regex\",\"[0-9]+\"]","resultTypeString":"PREPROCESSING_REGEX_DOES_NOT_MATCH","crmIntegrated":false,"crmSuccess":false}]}');
            else if(req.getEndPoint()!= null && req.getEndPoint().Contains('updateContactlead-Invalid'))
                res.setBody('{"beanResponse":[],"message":"Upload Contacts Failed. Reason: [\"CustomerManager.process.not.with.lead\",8,1]"}');
             else if( req.getEndPoint()!= null && req.getEndPoint().Contains('updateContactSessionId-Invalid'))
                res.setBody('{"beanResponse":[],"message":"Upload Contacts Failed. Invalid sessionId: d6189-53f34b03-ses-CustomerManager-9705-18"}');
             else if(req.getEndPoint()!= null && req.getEndPoint().Contains('valid Session'))
                res.setBody('{"alive":true,"serverTime":1425297998312}');
             else if(req.getEndPoint()!= null && req.getEndPoint().Contains('d224-5ad8bd34-ses-CustomerManager-vc2JkjaF-14'))
                res.setBody('{"beanResponse":[{"inserted":true,"customerId":18738,"resultTypeString":"ADDED","crmIntegrated":true,"crmSuccess":true,"crmResultTypeString":"ADDED"},{"inserted":true,"customerId":18739,"resultTypeString":"ADDED","crmIntegrated":true,"crmSuccess":true,"crmResultTypeString":"ADDED"}]}');
             else if(req.getEndPoint()!= null && req.getEndPoint().Contains('ameyowebaccess/command/?command=login&data={"userId":"CustomerManager1"'))
                res.setBody('{"message":"Incorrect Username or Password. Please try again..., userId: CustomerManager ","type":"ProcessingException","isPopulated":true}');
             else if(req.getEndPoint()!= null && req.getEndPoint().Contains('ameyowebaccess/command/?command=login'))
                res.setBody('{"contactCenterId":1,"sessionId":"d224-5ad8bd34-ses-CustomerManager-vc2JkjaF-14","userId":"CustomerManager","userType":"CustomerManager"}');
             else if(req.getEndPoint()!= null && req.getEndPoint().Contains('ping-session'))
                res.setBody('{"status":"error","reason":"Invalid session Id: d224-5ad8bd34-ses-CustomerManager-vc2JkjaF-14","details":"Invalid session Id: d224-5ad8bd34-ses-CustomerManager-vc2JkjaF-14"}');
                res.setStatusCode(200);
            return res;
     }*/

}