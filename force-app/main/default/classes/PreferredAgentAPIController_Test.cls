@isTest
public class PreferredAgentAPIController_Test{
    @isTest static void pref() {
         lead leadRec1=leadUtil_Test.insertLead('parinitha@gmail.com','1234567899');
         leadRec1.PostalCode='561284';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Call back in 2 hrs';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.Ameyo_Call_Attempts__c = 1;
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.leadSource = 'Google Ad';
         insert leadRec1;
         
         Test.startTest();
         String json = 'cid=1234567899&did=1234567899';
         RestRequest req = new RestRequest();
         req.addHeader('Content-Type','application/json');
         req.requestURI = '/services/apexrest/PreferredAgentAPI';
         req.HTTPMethod = 'POST';
         req.requestBody = Blob.valueOf(json);
         
         RestResponse res = new Restresponse();
         RestContext.request = req;
         RestContext.response = res;
         PreferredAgentAPIController.getRec();
         Test.stopTest();
    }   
    
     @isTest static void pref2() {
        
         Test.startTest();
         String json = 'cid=1234567899&did=1234567899';
         RestRequest req = new RestRequest();
         req.addHeader('Content-Type','application/json');
         req.requestURI = '/services/apexrest/PreferredAgentAPI';
         req.HTTPMethod = 'POST';
         req.requestBody = Blob.valueOf(json);
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         PreferredAgentAPIController.getRec();
         Test.stopTest();
    } 
}