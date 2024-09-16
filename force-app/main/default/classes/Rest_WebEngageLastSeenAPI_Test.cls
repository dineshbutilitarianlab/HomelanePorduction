@isTest
public class Rest_WebEngageLastSeenAPI_Test{
    Public static User u;
    Public static Lead ld;
    Public static Channel_partner__c cp;
    Public static Channel_partner__c ambassador;
    @TestSetup static void data() { 
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Customer_ID__c ='BEN-ABCD-0001';
        insert ld;
    }
    public testMethod static void updateLastSeenTest1() {
        try{
            ld = [select id,Customer_ID__c from Lead limit 1];
            
            //String JSONMsg = '[{"CustomerID":"Mum-r-3000006755","LastSeen":"2019-10-22T20:29:00Z"},{"CustomerID":"Tha-r-3000006754","LastSeen":"2019-10-22T20:29:00Z"}]';
            
            List <Rest_WebEngageLastSeenAPI.RequestWrapper> listOfreqWrapper = new List <Rest_WebEngageLastSeenAPI.RequestWrapper>();
            Rest_WebEngageLastSeenAPI.RequestWrapper reqWrapper1 = new Rest_WebEngageLastSeenAPI.RequestWrapper();
            reqWrapper1.CustomerID = ld.Customer_ID__c;
            reqWrapper1.LastSeen = System.now();
            listOfreqWrapper.add(reqWrapper1);
            
            Rest_WebEngageLastSeenAPI.RequestWrapper reqWrapper2 = new Rest_WebEngageLastSeenAPI.RequestWrapper();
            reqWrapper2.CustomerID = 'AB-BC-001';
            reqWrapper2.LastSeen = System.now();
            listOfreqWrapper.add(reqWrapper2);
            
            String requestWrapperString = JSON.serialize(listOfreqWrapper);
            System.debug('requestWrapperString :'+requestWrapperString);
            System.debug('Blob requestWrapperString :'+Blob.valueOf(requestWrapperString));
            
            // Set up a test request
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            RestRequest request = new RestRequest();
            request.addHeader('Content-Type', 'application/json');
            request.requestUri =baseUrl+'/services/apexrest/UpdateLastSeen';
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueOf(requestWrapperString);
            RestContext.request = request;
            Test.StartTest();
            Rest_WebEngageLastSeenAPI.updateLastSeen();
            Test.StopTest();
        }
        catch(Exception e){
            
        }  
    }
    public testMethod static void updateLastSeenTest2() {
        try{
            ld = [select id,Customer_ID__c from Lead limit 1];
            
            //String JSONMsg = '[{"CustomerID":"Mum-r-3000006755","LastSeen":"2019-10-22T20:29:00Z"},{"CustomerID":"Tha-r-3000006754","LastSeen":"2019-10-22T20:29:00Z"}]';
            
            List <Rest_WebEngageLastSeenAPI.RequestWrapper> listOfreqWrapper = new List <Rest_WebEngageLastSeenAPI.RequestWrapper>();
            Rest_WebEngageLastSeenAPI.RequestWrapper reqWrapper1 = new Rest_WebEngageLastSeenAPI.RequestWrapper();
            reqWrapper1.CustomerID = ld.Customer_ID__c;
            reqWrapper1.LastSeen = System.now();
            listOfreqWrapper.add(reqWrapper1);
            
            
            String requestWrapperString = JSON.serialize(listOfreqWrapper);
            System.debug('requestWrapperString :'+requestWrapperString);
            System.debug('Blob requestWrapperString :'+Blob.valueOf(requestWrapperString));
            
            // Set up a test request
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            RestRequest request = new RestRequest();
            request.addHeader('Content-Type', 'application/json');
            request.requestUri =baseUrl+'/services/apexrest/UpdateLastSeen';
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueOf(requestWrapperString);
            RestContext.request = request;
            Test.StartTest();
            Rest_WebEngageLastSeenAPI.updateLastSeen();
            Test.StopTest();
        }
        catch(Exception e){
            
        }  
    }
    public testMethod static void updateLastSeenTest3() {
        try{
            ld = [select id,Customer_ID__c from Lead limit 1];
            
            //String JSONMsg = '[{"CustomerID":"Mum-r-3000006755","LastSeen":"2019-10-22T20:29:00Z"},{"CustomerID":"Tha-r-3000006754","LastSeen":"2019-10-22T20:29:00Z"}]';
            
            List <Rest_WebEngageLastSeenAPI.RequestWrapper> listOfreqWrapper = new List <Rest_WebEngageLastSeenAPI.RequestWrapper>();
            Rest_WebEngageLastSeenAPI.RequestWrapper reqWrapper1 = new Rest_WebEngageLastSeenAPI.RequestWrapper();
            reqWrapper1.CustomerID = ld.Customer_ID__c;
            reqWrapper1.LastSeen = System.now();
            listOfreqWrapper.add(reqWrapper1);
            
            
            String requestWrapperString = JSON.serialize(listOfreqWrapper);
            System.debug('requestWrapperString :'+requestWrapperString);
            System.debug('Blob requestWrapperString :'+Blob.valueOf(requestWrapperString));
            
            // Set up a test request
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            RestRequest request = new RestRequest();
            RestResponse res = new RestResponse();
            
            request.addHeader('Content-Type', 'application/json');
            request.requestUri =baseUrl+'/services/apexrest/UpdateLastSeen';
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueOf(requestWrapperString);
            RestContext.request = request;
            Test.StartTest();
            Rest_WebEngageLastSeenAPI.updateLastSeen();
            Test.StopTest();
        }
        catch(Exception e){
            
        }  
    }
    public testMethod static void updateLastSeenTest4() {
        try{
            ld = [select id,Customer_ID__c from Lead limit 1];
            
            String JSONMsg = '[{"CustomerID":"Mum-r-3000006755","LastSeen":"2019-10-22T20:29:00Z"},{"CustomerID":"Tha-r-3000006754","LastSeen":"2019-10-22T20:29:00Z"}]';
            
            // Set up a test request
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            RestRequest request = new RestRequest();
            RestResponse res = new RestResponse();
            
            request.addHeader('Content-Type', 'application/json');
            request.requestUri =baseUrl+'/services/apexrest/UpdateLastSeen';
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueOf(JSONMsg);
            RestContext.request = request;
            Test.StartTest();
            Rest_WebEngageLastSeenAPI.updateLastSeen();
            Test.StopTest();
        }
        catch(Exception e){
            
        }  
    }
}