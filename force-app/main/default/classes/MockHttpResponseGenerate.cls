@isTest

global class MockHttpResponseGenerate implements HttpCalloutMock{



 global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
       // System.assertEquals('https://dev-artifactservice.homelane.com/v1/customers/0000/artifacts/quotations', req.getEndpoint());
      //  System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
     //  res.setBody('{"metaInfo":{"code":200,"moreInfo":"artifact type not specified properly","timestamp":"2016-08-05 06:44:02"},"notifications":null,"artifacts":{"artifact":[{"objectlength":69330,"lastmodified":1468996714000,"objectKey":"customers/0049/quotations/0049-initial-quote-draft-1.pdf","mimetype":"binary/octet-stream","url":"https://phoenixartifacts-dev.s3.amazonaws.com/customers/0049/quotations/0049-initial-quote-draft-1.pdf?AWSAccessKeyId=AKIAIDNKID72WTU43YAA&Expires=1470379450&Signature=zdo3mCWUb9vX5I6cpyfT4Y%2Bf4uI%3D","md5":null},{"objectlength":69330,"lastmodified":1468996954000,"objectKey":"customers/0049/quotations/0049-initial-quote-draft-2.pdf","mimetype":"binary/octet-stream","url":"https://phoenixartifacts-dev.s3.amazonaws.com/customers/0049/quotations/0049-initial-quote-draft-2.pdf?AWSAccessKeyId=AKIAIDNKID72WTU43YAA&Expires=1470379450&Signature=4J5UY%2FH%2FjU%2F4jKsmvKJzDaUK%2BNU%3D","md5":null}],"customer_id":"0049"}}');
      
     //  res.setBody('{"name":"test","opptynumber":100529,"projectId":"1466497460896","priceVersion":"0802-Bengaluru","customerEmail":"derek@homelane.comx","version":10,"rooms":[{"id":"56017cfc9de1cee85601e692","rooms":[{"name":"Kitchen_","roomType":"56017cfc9de1cee85601e692","roomTypeName":"Kitchen","woodWorks":[{"productName":"Gola Profile","productId":"560197b79de1cee85601e7a9","internalMaterial":"L Gola for Hinged Shutters / Top Drawers - Width in Running MM","width":"","height":"","area":"0","price"0,"qty":100,"unit":null,"wall":null,"price":1000,"qty":100}],"accessories":[],"applinces":[{"category":"Sinks & Taps","categoryId":"55f11ae10526b7c67cbbc60c","applianceType":"Tap","applianceTypeId":"55f11b120526b7c67cbbc6e1","applianceProductType":"SINK MOUNTED","applianceProductTypeId":"55f11b260526b7c67cbbc6e8","appliance":"Florentine - Single Inlet Single Lever Swinging Spout: Sink Mounted","applianceId":"55f11b3b0526b7c67cbbc710","quantity":1,"price":5000,"unit":"no.s","amount":5000,"code":"FLR_5357ND"}],"hds":[]},{"name":"Kitchen_2","roomType":"56017cfc9de1cee85601e692","roomTypeName":"Kitchen","woodWorks":[],"accessories":[],"applinces":[],"hds":[] }] }],"city":"bengaluru","typeOfWork":["Civil Work","Electrical Work","Plumbing","Others"],"otherDetails":{"discount":0},"versions":null,"comparison":[],"codeValidity":"1472541241362","designerEmail":"tanuj@homelane.com","basic":{},"premium":{}}');
        res.setBody('{"name": "new project","projectId": "14178","priceVersion": "0802-Bengaluru","customerEmail": "roshi.rai@kvpcorp.com","opptynumber": "0280","designerEmail": "kvpcorp4@gmail.com","version": 7,"summary":{"total": 1074737,"roomDetails": [{"roomType": "Kitchen","name": "Kitchen_","wwPrice": 3586,"wwTax": 605,"wwTotal": 4191,"accPrice": 0,"accTax": 0,"accTotal": 0,"appPrice": 0,"appTax": 0,"appTotal": 0,"hdsPrice": 1014928,"roomTotal": 1019119},{"roomType": "Utility","name": "Utility_","wwPrice": 46732,"wwTax": 7886,"wwTotal": 54618,"accPrice": 0,"accTax": 0,"accTotal": 0,"appPrice": 0,"appTax": 0,"appTotal": 0,"hdsPrice": 0,"roomTotal": 54618}],"otherServices": [{"price": 1000,"selectedWorkTypeIdx": "0","workTextValue": "civil"}],"discount": 10}}');
        res.setStatusCode(200);
        return res;
    }

        
    
}