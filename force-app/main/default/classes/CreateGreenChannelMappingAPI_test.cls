@isTest
public class CreateGreenChannelMappingAPI_test 
{
      @testSetup
    static void setup() 
    {       
        // Fetch the RecordType Ids
        Id goldRecordTypeId = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Gold_RECID).getRecordTypeId();
        Id silverRecordTypeId = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Silver_RECID).getRecordTypeId();          

        // Create Lead_Class_Scoring__c records
        List<Lead_Class_Scoring__c> leadClassifications = new List<Lead_Class_Scoring__c>();
        leadClassifications.add(new Lead_Class_Scoring__c(City__c = 'Pune', RecordTypeId = goldRecordTypeId));
        leadClassifications.add(new Lead_Class_Scoring__c(City__c = 'Pune', RecordTypeId = silverRecordTypeId));
        leadClassifications.add(new Lead_Class_Scoring__c(City__c = 'Bengaluru', RecordTypeId = goldRecordTypeId));
        leadClassifications.add(new Lead_Class_Scoring__c(City__c = 'Bengaluru', RecordTypeId = silverRecordTypeId));
        insert leadClassifications;
    }
    
    @isTest
    static void testCreateGreenChannelMapping_Success() 
    {
        // Create test data
        CreateGreenChannelMappingAPI.RequestWrapper req1 = new CreateGreenChannelMappingAPI.RequestWrapper();
        req1.city_name = 'Pune';
        req1.classification = 'Gold';
        req1.paid_search_otp = new List<String>{'Campaign1', 'Campaign2'};
        req1.paid_search = new List<String>{'Campaign3', 'Campaign4'};
        req1.facebook_ad_otp = new List<String>{'Campaign5', 'Campaign6'};
        req1.facebook_ad = new List<String>{'Campaign7', 'Campaign8'};
        req1.discovery_otp = new List<String>{'Campaign9', 'Campaign10'};
        req1.discovery = new List<String>{'Campaign11', 'Campaign12'};

        CreateGreenChannelMappingAPI.RequestWrapper req2 = new CreateGreenChannelMappingAPI.RequestWrapper();
        req2.city_name = 'Pune';
        req2.classification = 'Silver';
        req2.paid_search_otp = new List<String>{'Campaign13', 'Campaign14'};
        req2.paid_search = new List<String>{'Campaign15', 'Campaign16'};
        req2.facebook_ad_otp = new List<String>{'Campaign17', 'Campaign18'};
        req2.facebook_ad = new List<String>{'Campaign19', 'Campaign20'};
        req2.discovery_otp = new List<String>{'Campaign21', 'Campaign22'};
        req2.discovery = new List<String>{'Campaign23', 'Campaign24'};

        List<CreateGreenChannelMappingAPI.RequestWrapper> requestList = new List<CreateGreenChannelMappingAPI.RequestWrapper>{req1, req2};
        String requestBody = JSON.serialize(requestList);

        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CreateGreenChannelMappingAPI/';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;
        RestContext.response = res;

        CreateGreenChannelMappingAPI.CreateGreenChannelMapping();

        Test.stopTest();

     }

    @isTest
    static void testCreateGreenChannelMapping_EmptyInputData() 
    {
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CreateGreenChannelMappingAPI/';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf('');
        RestContext.request = req;
        RestContext.response = res;

        CreateGreenChannelMappingAPI.CreateGreenChannelMapping();

        Test.stopTest();

        CreateGreenChannelMappingAPI.ResponseWrapper responseWrapper = (CreateGreenChannelMappingAPI.ResponseWrapper) JSON.deserialize(res.responseBody.toString(), CreateGreenChannelMappingAPI.ResponseWrapper.class);
        System.assertEquals('FAILURE', responseWrapper.Status);
        System.assertEquals('InputData string in the request is blank or empty.', responseWrapper.Message);
    }

    @isTest
    static void testCreateGreenChannelMapping_ExceptionHandling() 
    {
        // Create invalid test data to trigger an exception
        CreateGreenChannelMappingAPI.RequestWrapper req1 = new CreateGreenChannelMappingAPI.RequestWrapper();
        req1.city_name = 'Bengaluru';
        req1.classification = 'Gold';
        req1.paid_search_otp = new List<String>{null}; // Invalid data to trigger exception

        List<CreateGreenChannelMappingAPI.RequestWrapper> requestList = new List<CreateGreenChannelMappingAPI.RequestWrapper>{req1};
        String requestBody = JSON.serialize(requestList);

        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CreateGreenChannelMappingAPI/';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;
        RestContext.response = res;

        CreateGreenChannelMappingAPI.CreateGreenChannelMapping();

        Test.stopTest();     
    }
}