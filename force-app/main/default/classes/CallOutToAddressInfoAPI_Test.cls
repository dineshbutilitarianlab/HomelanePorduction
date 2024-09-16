@isTest
public class CallOutToAddressInfoAPI_Test {
    Public static User u;
    Public static Lead ld;
    Public static Master__c showRoom;
    Public static City__c city;
    Public Static Integration_Setting__c salesforceLogin;
    @TestSetup static void data() { 
        //Create User record
        u = TestData_Factory.inserWTAUser('bhara@test.in', 'testUser', true);
        
        // Create Salesforce login Integration Settings
        salesforceLogin = new Integration_Setting__c();
        salesforceLogin.Name = 'Salesforce Login';
        salesforceLogin.End_Point__c = 'https://homelane--hlprod.cs72.my.salesforce.com';
        salesforceLogin.Client_Id__c = '3MVG910YPh8zrcR1yVy5MQ5lXnT3TZZJZQxeLVgfwBN_p8w4MggN63YCe9ZXRwxeFu5P6JUkEIJq3JWPQodcK';
        salesforceLogin.Secret_Key__c ='3576553059075121271';
        salesforceLogin.Username__c = 'tanuj@homelane.com.hlprod';
        salesforceLogin.Password__c = 'homelane321';
        salesforceLogin.ContentType__c = 'application/json';
        insert salesforceLogin; 
        
        
        //Create a Active ShowRoom Master record
        showRoom = TestData_Factory.CreateShowRoom(true);
        
        //Create City custom settings record
        city = new City__c();
        city.Name = 'Bengaluru';
        insert city; 
        
        //Create Lead Record
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Kitchen__c = LeadConstants.VALUE_YES;
        ld.Wardrobes__c ='1';
        ld.Entertainment_Unit__c = LeadConstants.VALUE_YES;
        ld.Crockery_Unit__c = LeadConstants.VALUE_YES;
        ld.Study_Table_Book_Shelf__c = LeadConstants.VALUE_YES;
        ld.Pooja__c = LeadConstants.VALUE_YES;
        ld.Vanity_Unit__c = LeadConstants.VALUE_YES;
        ld.Utility_Unit__c = LeadConstants.VALUE_YES;
        ld.Foyer_Shoe_Rack__c = LeadConstants.VALUE_YES;
        ld.Urban_Ladder__c = 'Category A';
        ld.False_Ceiling__c = true;
        ld.Painting__c = true;
        ld.Wallpaper__c = true;
        ld.city = 'Bengaluru';
        ld.LastName = 'test last name';
        ld.Email ='someEmail@some.com';
        ld.Phone ='7823901784';
        ld.Appointment_Time__c = System.now();
        ld.Appointment_Venue_Site_Residence_Add1__c ='some address';
        ld.Appointment_Venue_Site_Resi_Locality__c ='Some locality';
        ld.Appointment_Venue_Site_Resi_Landmark__c = 'Some landmark';
        ld.Street = 'Some Street';
        ld.HL_Referrer_Phone__c = '8947390267';
        ld.Property_Type__c = 'Villa';
        ld.Property_Status__c = 'Renovation';
        ld.Property_Config__c = '1 BHK';
        ld.Possession_Date__c = System.Today();
        ld.Purpose_of_Interiors__c ='It will be rented out';
        ld.Budget_Range__c = '8L - 10L';
        ld.Property_Move_In_Date__c = System.Today();
        ld.Floorplan_Received__c = LeadConstants.VALUE_YES;
        ld.First_home__c = LeadConstants.VALUE_YES;
        ld.Appointment_Type__c = LeadConstants.RESIDENCE_VISIT_APPOINTMENT_TYPE;
        ld.Other_Source__c = '';
        ld.How_did_you_hear_about_us__c ='Refered by a friend who has used HL';
        insert ld;
    }
    public testMethod static void callAddressInfoAPITest1() {
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test()); 
        
        test.startTest();
        List<Lead> listOfLeadsQueryied = new List<Lead>();
        String queryString = UtilityClass.getQueryString('Lead');
        queryString += ',Property__r.Name,Appointment_Venue_Square__r.Name From Lead limit 1';
        listOfLeadsQueryied = Database.query(queryString);
        if(!listOfLeadsQueryied.isEmpty()){
            ld = listOfLeadsQueryied[0];
            UpdateLeadDetails_Controller.propertyWrapper PW = new UpdateLeadDetails_Controller.propertyWrapper();
            PW.latitude = 10.0011;
            PW.longitude = 20.0028;
            PW.city = 'Bengaluru';
            PW.country = 'India';
            PW.searched_address = 'Some Address In India';
            PW.property_name = 'Some test Property';
            PW.map_url = 'testMapUrl';
            PW.lead_id = ld.id;
            PW.pincode ='560056';
            PW.state = 'Karnataka';
            PW.locality = 'Some test locality';
            
            String PWString = JSON.serialize(PW);
            
            CallOutToAddressInfoAPI.callAddressInfoAPI(PWString);
        }
        test.stopTest();
    }
}