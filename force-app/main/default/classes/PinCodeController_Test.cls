@isTest
global class PinCodeController_Test implements HTTPCallOutMock{
    static testMethod void test1(){
     Lead l = new Lead();
     l.FirstName = 'Hamsa';
        l.LastName = 'Raj';
        l.Email = 'HamsaRaj@gmail.com';
        l.Phone = '9000000009';
        l.City = 'Bengaluru';
        l.LeadSource = 'Google Ad';
        l.Status = 'Fresh Lead';
        l.Sub_Status__c = 'New';
        
        insert l;
        l.PostalCode = '560043';
        update l;
        
        test.startTest(); 
        PinCodeController.dummyTestCover();
        Test.setMock(HttpCalloutMock.class, new PinCodeController_Test()); 
        Test.stopTest();
    }
    
    static testMethod void test2(){
        Residential_Area__c r = new Residential_Area__c();
        r.Name = 'Banaswadi';
        r.City__c = 'Bengaluru';
        r.Pincode__c = '560043';
        insert r;
        
     Lead l = new Lead();
     l.FirstName = 'Hamsa';
        l.LastName = 'Raj';
        l.Email = 'HamsaRaj@gmail.com';
        l.Phone = '9000000009';
        l.City = 'Bengaluru';
        l.LeadSource = 'Google Ad';
        l.Status = 'Fresh Lead';
        l.Sub_Status__c = 'New';
        
        insert l;
        l.PostalCode = '560043';
        update l;
        
        test.startTest(); 
        PinCodeController.dummyTestCover();
        Test.setMock(HttpCalloutMock.class, new PinCodeController_Test()); 
        Test.stopTest();
    }
    
    static testMethod void test3(){
        Residential_Area__c r = new Residential_Area__c();
        r.Name = 'Banaswadi';
        r.City__c = 'Bengaluru';
        insert r;
        
     Lead l = new Lead();
     l.FirstName = 'Hamsa';
        l.LastName = 'Raj';
        l.Email = 'HamsaRaj@gmail.com';
        l.Phone = '9000000009';
        l.City = 'Bengaluru';
        l.LeadSource = 'Google Ad';
        l.Status = 'Fresh Lead';
        l.Sub_Status__c = 'New';
        
        insert l;
        l.PostalCode = '560043';
        update l;
        
        test.startTest(); 
        PinCodeController.dummyTestCover();
        Test.setMock(HttpCalloutMock.class, new PinCodeController_Test()); 
        Test.stopTest();
    }
    
    global HTTPResponse respond(HTTPRequest request) {
        HTTPResponse response = new HTTPResponse();
      //  response.setHeader('Content-Type','application/json');
        response.setBody('{"Message": "Number of Post office(s) found: 4","Status": "Success","PostOffice": [{"Name": "Banaswadi","Description": "","BranchType": "Sub Post Office","DeliveryStatus": "Non-Delivery","Taluk": "Bangalore South","Circle": "Bangalore South","District": "Bangalore","Division": "Bangalore South","Region": "Bangalore HQ","State": "Karnataka","Country": "India"}]}');
        response.setStatusCode(200);
        return response;
    }
}