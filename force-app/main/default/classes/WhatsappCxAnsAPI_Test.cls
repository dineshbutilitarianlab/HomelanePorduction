@isTest
public class WhatsappCxAnsAPI_Test {
    @isTest static void test() {
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
        
        Whatsapp_Message__c w = new Whatsapp_Message__c(Name = 'WA - Unable to Contact', Lead__c = l.Id, Responded_Last_Time__c = System.now(), Response_Msg__c = 'Call', Responded__c = 'Yes', Call_Back_Request__c = 'Inside Business Hours');
        insert w;
        Test.startTest();
        String json = '{"mobile_no":"9000000009","response_msg":"call","within_business_hours":"false","leadId":"'+l.Id+'","cx_response":"call"}';
        RestRequest req = new RestRequest();
        req.addHeader('Content-Type','application/json');
        req.requestURI = '/services/apexrest/WhatsappCxAnsAPI';
        req.HTTPMethod = 'POST';
        req.requestBody = Blob.valueOf(json);
        
        RestResponse res = new RestResponse();
        RestContext.Request = req;
        RestContext.Response = res;
        WhatsappCxAnsAPI.leadPush();
        Test.stopTest();
    }
    
     @isTest static void test2() {
        Lead l = new Lead();
        l.FirstName = 'Hamsa';
        l.LastName = 'Raj';
        l.Email = 'HamsaRaj@gmail.com';
        l.Phone = '9000000009';
        l.City = 'Bengaluru';
        l.LeadSource = 'Google Ad';
        l.Status = 'Fresh Lead';
        l.Sub_Status__c = 'New';
        l.Description__c = 'ABC';
        insert l;
        
        Whatsapp_Message__c w = new Whatsapp_Message__c(Name = 'WA - Unable to Contact', Lead__c = l.Id, Responded_Last_Time__c = System.now(), Response_Msg__c = 'Call', Responded__c = 'Yes', Call_Back_Request__c = 'Inside Business Hours');
        insert w;
        
        String json = '{"mobile_no":"9000000009","response_msg":"call","within_business_hours":"true","leadId":"'+l.Id+'","cx_response":"call"}';
        
        Test.startTest();
        RestRequest req = new RestRequest();
        req.addHeader('Content-Type','application/json');
        req.RequestURI = '/services/apexrest/WhatsappCxAnsAPI';
        req.HTTPMethod = 'POST';
        req.requestBody = Blob.valueOf(json);
        
        RestResponse res = new RestResponse();
        RestContext.Request = req;
        RestContext.Response = res;
        WhatsappCxAnsAPI.leadPush();
        Test.stopTest();
    }
    
    @isTest static void test3() {
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
        
        String json = '{"mobile_no":"9000000008","response_msg":"call","within_business_hours":"true","leadId":"'+l.Id+'","cx_response":"call"}';
        
        Test.startTest();
        RestRequest req = new RestRequest();
        req.addHeader('Content-Type','application/json');
        req.requestURI = '/services/apexrest/WhatsappCxAnsAPI';
        req.HTTPMethod = 'POST';
        req.requestBody = Blob.valueOf(json);
        
        RestResponse res = new RestResponse();
        RestContext.Request = req;
        RestContext.Response = res;
        WhatsappCxAnsAPI.leadPush();
        Test.stopTest();
        }
}