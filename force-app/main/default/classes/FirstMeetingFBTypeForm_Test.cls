@isTest
public class FirstMeetingFBTypeForm_Test {
    public static testMethod void test1() {
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        Account a = new Account();
        a.PersonEmail = 'test@testing.com';
        a.FirstName = 'Test';
        a.lastName = 'Test';
        a.RecordTypeID = RecTypeId;
        insert a;
        
        Opportunity opp1 = new Opportunity();
        opp1.name = 'first';
        opp1.StageName='Won';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.AccountId = a.id;
        opp1.CloseDate = Date.Today();
        insert opp1;
        
        Test.startTest();
        String json = '{"event_id":"01D5BDF5WZYV3SMPYAVTFB9DE3","event_type":"form_response","form_response":{"form_id":"Au0zQ6","token":"7b68304831fbb4523f0836200a3a3c2b","landed_at":"2019-03-07T06:29:06Z","submitted_at":"2019-03-07T06:29:23Z","hidden":{"email":"test@testing.com"},"definition":{"id":"Au0zQ6","title":"First Meeting Feedback","fields":[{"id":"xv1UtsothGFV","title":"How happy are you with your overall HomeLane Experience?","type":"opinion_scale","ref":"c2500406-f879-46dc-8377-5b13818a051a","properties":{}},{"id":"DAntAgNY8M9r","title":"What went well?","type":"multiple_choice","allow_multiple_selections":true,"ref":"34c6cd72-829e-4cbb-8c0e-1c326ae7022a","properties":{},"choices":[{"id":"hbFVt9i2uGTj","label":"Designer was knowledgable"},{"id":"WKwhn8BNpWG7","label":"Happy with quality of designs proposed by the designer"},{"id":"Xo5SmKGm0COF","label":"Proposal is in my budget"},{"id":"BFMsRpmCv8ar","label":"HomeLane staff was friendly and made me feel welcome"},{"id":"mqBpmApX1wtP","label":"Others"}]},{"id":"H1Mnxae41KAY","title":"Comments","type":"short_text","ref":"e5a3fe36-92f1-4ae4-9bbe-9b5711f207ff","properties":{}}]},"answers":[{"type":"number","number_Z":5,"field":{"id":"xv1UtsothGFV","type":"opinion_scale","ref":"c2500406-f879-46dc-8377-5b13818a051a"}},{"type":"choices","choices":{"labels":["Happy with quality of designs proposed by the designer","Designer was knowledgable"]},"field":{"id":"DAntAgNY8M9r","type":"multiple_choice","ref":"34c6cd72-829e-4cbb-8c0e-1c326ae7022a"}},{"type":"text","type_Z":"hello","field":{"id":"H1Mnxae41KAY","type":"short_text","ref":"e5a3fe36-92f1-4ae4-9bbe-9b5711f207ff"}}]}}';
        
        try {
            RestRequest req = new Restrequest();
            req.addHeader('Content-Type','application/json');
            req.requestURI = 'services/apexrest/FirstMeetingFBTypeForm';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(json);
            
            RestResponse res = new RestResponse();
            RestContext.request = req;
            RestContext.response = res;
            //FirstMeetingFBTypeForm.Typeform();
        }
        catch(Exception e) {}
        Test.stopTest();
    }
    
    public static testMethod void test2() {
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        Account a = new Account();
        a.PersonEmail = 'test@testing.com';
        a.FirstName = 'Test';
        a.lastName = 'Test';
        a.RecordTypeID = RecTypeId;
        insert a;
        
        Opportunity opp1 = new Opportunity();
        opp1.name = 'first';
        opp1.StageName='Won';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.AccountId = a.id;
        opp1.CloseDate = Date.Today();
        insert opp1;
        
        Test.startTest();
        String json = '{"event_id":"01D5BE9EYE9FZNESHQ4T611T3C","event_type":"form_response","form_response":{"form_id":"Au0zQ6","token":"b5965b3f869c8c5c17f4c08ce7a6a29d","landed_at":"2019-03-07T06:43:34Z","submitted_at":"2019-03-07T06:43:44Z","hidden":{"email":"test@testing.com"},"definition":{"id":"Au0zQ6","title":"First Meeting Feedback","fields":[{"id":"xv1UtsothGFV","title":"How happy are you with your overall HomeLane Experience?","type":"opinion_scale","ref":"c2500406-f879-46dc-8377-5b13818a051a","properties":{}},{"id":"H1Mnxae41KAY","title":"Comments","type":"short_text","ref":"e5a3fe36-92f1-4ae4-9bbe-9b5711f207ff","properties":{}}]},"answers":[{"type":"number","number_Z":5,"field":{"id":"xv1UtsothGFV","type":"opinion_scale","ref":"c2500406-f879-46dc-8377-5b13818a051a"}},{"type":"text","type_Z":"hello","field":{"id":"H1Mnxae41KAY","type":"short_text","ref":"e5a3fe36-92f1-4ae4-9bbe-9b5711f207ff"}}]}}';
        
        try {
            RestRequest req = new Restrequest();
            req.addHeader('Content-Type','application/json');
            req.requestURI = 'services/apexrest/FirstMeetingFBTypeForm';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(json);
            
            RestResponse res = new RestResponse();
            RestContext.request = req;
            RestContext.response = res;
            //FirstMeetingFBTypeForm.Typeform();
        }
        catch(Exception e) {}
        Test.stopTest();
    }
    
    public static testMethod void test3() {
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        Account a = new Account();
        a.PersonEmail = 'test@testing.com';
        a.FirstName = 'Test';
        a.lastName = 'Test';
        a.RecordTypeID = RecTypeId;
        insert a;
        
        Opportunity opp1 = new Opportunity();
        opp1.name = 'first';
        opp1.StageName='Won';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.AccountId = a.id;
        opp1.CloseDate = Date.Today();
        insert opp1;
        
        Test.startTest();
        String json = '{"event_id":"01D5BFS1NC10ECA9KNT1JV02T0","event_type":"form_response","form_response":{"form_id":"Au0zQ6","token":"57597a6d0a750cec57dc82ed1644f928","landed_at":"2019-03-07T07:09:29Z","submitted_at":"2019-03-07T07:09:43Z","hidden":{"email":"test@testing.com"},"definition":{"id":"Au0zQ6","title":"First Meeting Feedback","fields":[{"id":"xv1UtsothGFV","title":"How happy are you with your overall HomeLane Experience?","type":"opinion_scale","ref":"c2500406-f879-46dc-8377-5b13818a051a","properties":{}}]},"answers":[{"type":"number","number_Z":4,"field":{"id":"xv1UtsothGFV","type":"opinion_scale","ref":"c2500406-f879-46dc-8377-5b13818a051a"}}]}}';
        
        try {
            RestRequest req = new Restrequest();
            req.addHeader('Content-Type','application/json');
            req.requestURI = 'services/apexrest/FirstMeetingFBTypeForm';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(json);
            
            RestResponse res = new RestResponse();
            RestContext.request = req;
            RestContext.response = res;
            //FirstMeetingFBTypeForm.Typeform();
        }
        catch(Exception e) {}
        Test.stopTest();
    }
}