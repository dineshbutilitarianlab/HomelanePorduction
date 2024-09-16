@isTest 
global class ReassignDPJavaScript_Test implements HTTPCalloutMock{
    global static testMethod void test(){
        Master__c m = new Master__c(type__c='Showroom',name='Gopalan Showroom',isActive__c=true);
        insert m;
        
        
         Interior_Designer__c inte = new Interior_Designer__c();
        inte.Name = 'Test Int';
        inte.Email__c = 'test@google.com';
        inte.X0_4_Opportunities__c = 1;
        inte.X0_4_Won_Opportunities__c = 1;
        inte.X4_8_Won_Opportunities__c = 2;
        inte.X8_Won_Opportunities__c = 3;
        inte.Total_Wins__c = 10;
        inte.Total_Opportunities__c = 0;
       // inte.Today_s_Showroom__c = 'Test Showroom 2';
        inte.Available_at_Showroom__c = 'Test Showroom 2';
        inte.Property_Exp_Data__c = 'Kanakapura Showroom';
        inte.City__c = 'Bengaluru';
        inte.Languages_Known__c = 'Hindi';
        inte.DP_Status__c = 'Active - Overloaded 10-40';
        
        
         lead newLead = new Lead();
        newLead.Email = 'test@test.com';
        newLead.lastName = 'Test';
        newLead.Phone = '1234567890';
        newLead.LeadSource = 'Google Ad';
        newLead.Status = 'Fresh Lead';
        newLead.Budget_Range__c = '1.5L - 4L';
        newLead.City = 'Bengaluru';
        newLead.Regional_Language_Preference__c = 'Hindi';
        newLead.Interior_Designer__c = inte.Id;
        insert newLead;
        
        newLead.Status='Appointment Fixed';
        newLead.Entertainment_Unit__c='Yes';
        newLead.Kitchen__c='Yes';
        newLead.Pooja__c='Yes';
        newLead.Crockery_Unit__c='Yes';
        newLead.Foyer_Shoe_Rack__c='Yes';
        newLead.LeadSource='website';
        newLead.Vanity_Unit__c='Yes';
        newLead.Wardrobes__c='1';
        newLead.Utility_Unit__c='Yes';
        newLead.Study_Table_Book_Shelf__c='Yes';
        newLead.Appointment_Type__c = 'Square Showroom Visit';
       newLead.City = 'Bengaluru';
       newLead.Interior_Start_Date__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       newLead.Property_Type__c  = 'Villa';
       newLead.Property_Config__c = '1 BHK';
       newLead.Property_Status__c = 'New';
       newLead.Property_Move_In_Date__c= Date.valueOf('2019-12-06T00:00:00.000Z');
       newLead.Kitchen__c = 'Yes';
       newLead.Interior_Designer__c = inte.Id;
       newLead.Vanity_Unit__c = 'Yes';
       newLead.Utility_Unit__c = 'Yes';
       newLead.Crockery_Unit__c = 'Yes';
       newLead.Entertainment_Unit__c = 'Yes';
       newLead.Pooja__c = 'Yes';
       newLead.How_did_you_hear_about_us__c = 'Email';
       newLead.Study_Table_Book_Shelf__c = 'Yes';
       newLead.Foyer_Shoe_Rack__c = 'Yes';
       newLead.Appointment_Time__c = System.now();
       newLead.Time_of_Actual_Appointment_Start__c = Date.valueOf('2017-12-06T00:00:00.000Z');  
       newLead.Appointment_Venue_Square__c = m.Id;
       newLead.Property__c = m.Id;
       newLead.Possession_Date__c = Date.valueOf('2019-12-06T00:00:00.000Z');
       update newLead; 
       
       Test.startTest();
       DPAssignment__c noShow = new DPAssignment__c(name= 'NoShow', API__c = 'http://rosters.homelane.com/apis/dp_availability/dp_no_show');
       insert noShow;
       ReassignDPJavaScript.NoShowButton(newLead.Id);    
       Test.setMock(HttpCalloutMock.class, new ReassignDPJavaScript_Test ());     
       Test.stopTest();
    }
    
    global HTTPResponse respond(HTTPRequest req) {
        HTTPResponse response = new HTTPResponse();
        response.setHeader('Content-Type','application/json');
        response.setStatusCode(200);
        response.setBody('{"error":false,"response":true,"msg":"Updated successfully!"}');
        SYstem.debug('-----TESTING RESPONSE  '+response);
        return response;
    }
}