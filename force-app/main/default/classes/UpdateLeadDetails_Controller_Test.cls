@isTest
public class UpdateLeadDetails_Controller_Test {
    Public static User u;
    Public static Lead ld;
    Public static Master__c showRoom;
    Public static City__c city;
    Public Static Integration_Setting__c googleSheetAPI ;
    @TestSetup static void data() { 
        //Create User record
        u = TestData_Factory.inserWTAUser('bhara88@test.in', 'testUser', true);
         Account acc= new account();
        acc.Name= 'Testacc';
        insert acc;
        //Create a Active ShowRoom Master record
        showRoom = TestData_Factory.CreateShowRoom(true);
        
        //Create City custom settings record
        city = new City__c();
        city.Name = 'Bengaluru';
        insert city; 
        
        //Create Integration Setting custom Setting record
        googleSheetAPI = new Integration_Setting__c();
        googleSheetAPI.Name = 'GOOGLE SHEET API';
        googleSheetAPI.End_Point__c = 'http://someTest';
        insert googleSheetAPI;
        
        //Create Lead Record
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Account__c= acc.id;
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
        ld.Renovation_services__c = 'Electrical';
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
    public testMethod static void updateLeadDetailsController1() {
        Test.StartTest();
        u = [Select id from User limit 1];
        
        List<Lead> listOfLeadsQueryied = new List<Lead>();
        String queryString = UtilityClass.getQueryString('Lead');
        queryString += ',Property__r.Name,Appointment_Venue_Square__r.Name From Lead limit 1';
        listOfLeadsQueryied = Database.query(queryString);
        if(!listOfLeadsQueryied.isEmpty()){
            ld = listOfLeadsQueryied[0];
            ApexPages.currentPage().getParameters().put('id',ld.Id);
            ApexPages.StandardController ap=new ApexPages.StandardController(ld);
            UpdateLeadDetails_Controller sp=new UpdateLeadDetails_Controller(ap);
            sp.SubmitLeadRecord();
            //UpdateLeadDetails_Controller.callOutToGoogleSheets(null);
            sp.callOutToGoogleSheets(u.id);
        }
        
        test.stoptest();  
    }
    public testMethod static void updateLeadDetailsController2() {
        Test.StartTest();
        u = [Select id from User limit 1];
        showRoom = [Select id from Master__c limit 1];
        List<Lead> listOfLeadsQueryied = new List<Lead>();
        String queryString = UtilityClass.getQueryString('Lead');
        queryString += ',Property__r.Name,Appointment_Venue_Square__r.Name From Lead limit 1';
        listOfLeadsQueryied = Database.query(queryString);
        if(!listOfLeadsQueryied.isEmpty()){
            ld = listOfLeadsQueryied[0];
            ld.Kitchen__c = LeadConstants.VALUE_NO;
            ld.Wardrobes__c ='0';
            ld.Entertainment_Unit__c = LeadConstants.VALUE_NO;
            ld.Crockery_Unit__c = LeadConstants.VALUE_NO;
            ld.Study_Table_Book_Shelf__c = LeadConstants.VALUE_NO;
            ld.Pooja__c = LeadConstants.VALUE_NO;
            ld.Vanity_Unit__c = LeadConstants.VALUE_NO;
            ld.Utility_Unit__c = LeadConstants.VALUE_NO;
            ld.Foyer_Shoe_Rack__c = LeadConstants.VALUE_NO;
            ld.Urban_Ladder__c = '';
            ld.False_Ceiling__c = false;
            ld.Painting__c = false;
            ld.Wallpaper__c = false;
            ld.Appointment_Venue_Site_Residence_Add1__c ='';
            ld.Appointment_Type__c = 'Others';
            ld.How_did_you_hear_about_us__c ='Others';
            ld.Other_Source__c = 'Some other Source';
            ld.Appointment_Venue_Square__c = showRoom.id;
            update ld;
            
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
            
            ApexPages.currentPage().getParameters().put('id',ld.Id);
            ApexPages.currentPage().getParameters().put('calledFromButton','APPOINTMENT');
            ApexPages.currentPage().getParameters().put('googlePropertyDetails',PWString);
            
            ApexPages.StandardController ap=new ApexPages.StandardController(ld);
            UpdateLeadDetails_Controller sp=new UpdateLeadDetails_Controller(ap);
            sp.SubmitLeadRecord();
            UpdateLeadDetails_Controller.formatDate(System.today());
            UpdateLeadDetails_Controller.formatDate(null);
            sp.callOutToGoogleSheets(null);
            sp.callOutToGoogleSheets(u.id);
            sp.selectclick();
            sp.unselectclick();
            sp.getunSelectedValues();
            sp.getSelectedValues();
        }
        
        test.stoptest();  
    }
}