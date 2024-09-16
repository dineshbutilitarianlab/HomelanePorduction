@isTest
global class FirstMeetingFeedbackEmail_Test implements HTTPCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        HTTPResponse response = new HTTPResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        SYstem.debug('-----TESTING RESPONSE  '+response);
        return response;
    }
    
    @isTest static void FIrst() {
        Test.startTest();
        
        FirstMeetingFeedbackEmail.dummyTestCover();
        Opportunity opp1 = new Opportunity();
        opp1.name = 'first';
        opp1.StageName='Won';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-2);
        insert opp1;  
        Test.setMock(HttpCalloutMock.class, new FirstMeetingFeedbackEmail_Test ());    
        Database.executeBatch(new FirstMeetingFeedbackEmail());
        Test.stopTest();
    }
}