@isTest

global class MockHttpResponseGenerator implements HttpCalloutMock{

     global HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
           // System.assertEquals('https://dev-artifactservice.homelane.com/v1/customers/0000/artifacts/quotations', req.getEndpoint());
           // System.assertEquals('GET', req.getMethod());
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"metaInfo":{"code":200,"moreInfo":"artifact type not specified properly","timestamp":"2016-08-05 06:44:02"},"notifications":null,"artifacts":{"artifact":[{"objectlength":69330,"lastmodified":1468996714000,"objectKey":"customers/0049/quotations/0049-initial-quote-draft-1.pdf","mimetype":"binary/octet-stream","url":"https://phoenixartifacts-dev.s3.amazonaws.com/customers/0049/quotations/0049-initial-quote-draft-1.pdf?AWSAccessKeyId=AKIAIDNKID72WTU43YAA&Expires=1470379450&Signature=zdo3mCWUb9vX5I6cpyfT4Y%2Bf4uI%3D","md5":null},{"objectlength":69330,"lastmodified":1468996954000,"objectKey":"customers/0049/quotations/0049-initial-quote-draft-2.pdf","mimetype":"binary/octet-stream","url":"https://phoenixartifacts-dev.s3.amazonaws.com/customers/0049/quotations/0049-initial-quote-draft-2.pdf?AWSAccessKeyId=AKIAIDNKID72WTU43YAA&Expires=1470379450&Signature=4J5UY%2FH%2FjU%2F4jKsmvKJzDaUK%2BNU%3D","md5":null}],"customer_id":"0049"}}');
            res.setStatusCode(200);
            return res;
     }

}