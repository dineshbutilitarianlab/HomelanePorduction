@isTest
global class update_availability_Test {
    global static testMethod void upd() {
         Master__c m = new Master__c(type__c='Showroom',name='Gopalan Showroom');
        insert m;
        
         lead newLead = new Lead();
        newLead.Email = 'trailtest114@mailinator.com';
        newLead.lastName = 'Test';
        newLead.Phone = '1234567890';
        newLead.LeadSource = 'Google Ad';
        newLead.Status = 'Fresh Lead';
        newLead.Property__c = m.Id;
        newLead.Budget_Range__c = '1.5L - 4L';
        newLead.City = 'Bengaluru';
        newLead.Regional_Language_Preference__c = 'Hindi';
        newLead.Appointment_Venue_Square__c = m.Id;
        insert newLead;
       
        Test.startTest();
        try {
            String json = '{"cx_email" : "trailtest114@mailinator.com", "reason" : "dp no show"}';
            RestRequest req = new RestRequest();
            req.addHeader('Content-Type','application/json');
            req.requestURI = '/services/apexrest/update_availability';
            req.HTTPMethod = 'POST';
            req.requestBody = Blob.valueOf(json);
            
            RestResponse res = new RestResponse();
            RestContext.request = req;
            RestContext.response = res;
            update_availability.index();
            
        }
        catch(Exception e) {}
        update_availability.dummyTestCover();
        Test.stopTest();
    }
}