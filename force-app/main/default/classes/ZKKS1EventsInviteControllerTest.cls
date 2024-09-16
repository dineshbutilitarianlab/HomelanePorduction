@isTest
private class ZKKS1EventsInviteControllerTest {
    
    @TestVisible  class returnData{
        Boolean success {get;set;}
        String message {get;set;}
    }

    @isTest static void test_method_one() {
        // Implement test code
        List<Contact> contacts = new List<Contact>();
        List<Lead> leads = new List<Lead>();
        List<Id> relIds = new List<Id>();
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact 1';
        con.Email = 'test1@example.com';
        insert con;
        relIds.add(con.id);

        con = new Contact();
        con.FirstName = 'Test';
        con.LastName = ' Contact 2';
        con.Email = 'test2@example.com';
        insert con;
        relIds.add(con.id);

        Lead l = new Lead();
        l.FirstName = 'Test';
        l.LastName = 'Lead 1';
        l.Email = 'Lead1@example.com';
        l.company = 'Acme Inc';
        l.City= 'Pune';
        l.Phone= '8999663214';
        l.LeadSource= 'Website';
        insert l;
        relIds.add(l.id);

        Event evt = new Event();
        evt.StartDateTime = Datetime.newInstance(2016, 2, 13);
        evt.EndDateTime = evt.StartDateTime.addDays(1);
        evt.Subject = 'Test Event';
        evt.whoid = con.id;
        insert evt;


        ApexPages.StandardController sc =  new ApexPages.StandardController(evt);
        ZKKS1EventsInviteController z = new ZKKS1EventsInviteController(sc);
        //String recentlyViewed = ZKKS1EventsInviteController.getRecentlyViewedPeople();
        //System.assert(recentlyViewed.contains('true'));
        String searchResult = ZKKS1EventsInviteController.searchPeople('Test');
        System.assert(searchResult.contains('true'));
        String addResult = ZKKS1EventsInviteController.addInvitees(evt.Id, relIds);

    }
        
}