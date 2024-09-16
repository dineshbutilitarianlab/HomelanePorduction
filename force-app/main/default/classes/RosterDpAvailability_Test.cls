@isTest
global class RosterDpAvailability_Test implements HTTPCalloutMock{
    global static testMethod void ros() {
         Master__c m = new Master__c(type__c='Showroom',name='Gopalan Showroom');
        insert m;
        Map<Id,Lead> oldlist = new Map<Id,lead>();
        Map<id,Lead> newList = new Map<id,Lead>();
        Map<id,Lead> newList1 = new Map<id,Lead>();      
        
         lead newLead = new Lead();
        newLead.Email = 'test@test.com';
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
        newLead.Property__c=m.Id;
        newLead.Appointment_Type__c = 'Square Showroom Visit';
       newLead.City = 'Bengaluru';
       newLead.Interior_Start_Date__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       newLead.Property_Type__c  = 'Villa';
       newLead.Property_Config__c = '1 BHK';
       newLead.Property_Status__c = 'New';
       newLead.Property_Move_In_Date__c= Date.valueOf('2019-12-06T00:00:00.000Z');
       newLead.Kitchen__c = 'Yes';
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
       newLead.Possession_Date__c = Date.valueOf('2019-12-06T00:00:00.000Z');
       oldlist.put(newLead.id,newlead);
      update oldlist.values();
       
       newLead.Status='Appointment Cancelled';
       newLead.Appointment_Time__c = System.now().addHours(3);
       newList.put(newLead.id,newlead);
       
       
       Test.startTest();
    //   update newlist.values();
       RosterDpAvailability.RosterDpCancel(oldlist,newlist);
       Test.setMock(HTTPCalloutMock.class, new RosterDpAvailability_Test());
       Test.stopTest();       
    }
    
     global static testMethod void ros2() {
         try{
        Master__c m = new Master__c(type__c='Showroom',name='Gopalan Showroom');
        insert m;
        Map<Id,Lead> oldlist = new Map<Id,lead>();
        Map<id,Lead> newList1 = new Map<id,Lead>();
        
         
        Interior_Designer__c inte = new Interior_Designer__c();
        inte.Name = 'Kishore PG';
        inte.Email__c = 'kishore.p@homelane.com';
        inte.X0_4_Won_Opportunities__c = 1;
        inte.X4_8_Won_Opportunities__c = 2;
        inte.X8_Won_Opportunities__c = 3;
        inte.X0_4_Opportunities__c = 1;
        inte.X4_8_Opportunities__c= 1;
        inte.X8_Opportunities__c = 1;
        inte.Total_Wins__c = 10;
        inte.Total_Opportunities__c = 50;
        inte.Available_at_Showroom__c = 'Gopalan Showroom';
        inte.Property_Exp_Data__c = 'Gopalan Showroom';
        inte.City__c = 'Bengaluru';
        inte.Languages_Known__c = 'Hindi';
        insert inte;
        
       /*  lead newLead = new Lead();
        newLead.Email = 'tes@test.com';
        newLead.lastName = 'Test';
        newLead.Phone = '1234567800';
        newLead.LeadSource = 'Google Ad';
        newLead.Status = 'Fresh Lead';
        newLead.Property__c = m.Id;
        newLead.Budget_Range__c = '1.5L - 4L';
        newLead.City = 'Bengaluru';
        newLead.Regional_Language_Preference__c = 'Hindi';
        newLead.Appointment_Venue_Square__c = m.Id;
        newLead.Appointment_Time__c = System.now();
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
        newLead.Property__c=m.Id;
        newLead.Appointment_Type__c = 'Square Showroom Visit';
       newLead.City = 'Bengaluru';
       newLead.Interior_Start_Date__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       newLead.Property_Type__c  = 'Villa';
       newLead.Property_Config__c = '1 BHK';
       newLead.Property_Status__c = 'New';
       newLead.Property_Move_In_Date__c= Date.valueOf('2019-12-06T00:00:00.000Z');
       newLead.Kitchen__c = 'Yes';
       newLead.Vanity_Unit__c = 'Yes';
       newLead.Utility_Unit__c = 'Yes';
       newLead.Crockery_Unit__c = 'Yes';
       newLead.Entertainment_Unit__c = 'Yes';
       newLead.Pooja__c = 'Yes';
       newLead.How_did_you_hear_about_us__c = 'Email';
       newLead.Study_Table_Book_Shelf__c = 'Yes';
       newLead.Foyer_Shoe_Rack__c = 'Yes';
       newLead.Time_of_Actual_Appointment_Start__c = Date.valueOf('2017-12-06T00:00:00.000Z');  
       newLead.Appointment_Venue_Square__c = m.Id;
       newLead.Possession_Date__c = Date.valueOf('2019-12-06T00:00:00.000Z');
       newlead.Interior_Designer__c = inte.id;
       newLead.Appointment_Time__c = System.now().addHours(2);
       oldlist.put(newLead.id,newlead);
       update oldlist.values();
       System.debug('---old time test  '+newLead.Appointment_Time__c );  */
      
        lead newLead1 = new Lead();
        newLead1.Email = 'tes3t@test.com';
        newLead1.lastName = 'Tjdjfgwg';
        newLead1.Phone = '1234507800';
        newLead1.LeadSource = 'Google Ad';
        newLead1.Status = 'Fresh Lead';
        newLead1.Regional_Language_Preference__c = 'Hindi';
        newLead1.Property__c = m.Id;
        newLead1.Budget_Range__c = '4L - 6L';
        newLead1.City = 'Bengaluru'; 
        newLead1.Appointment_Venue_Square__c = m.Id;   
        newLead1.Appointment_Time__c = System.now(); 
        insert newLead1;
        oldlist.put(newLead1.id,newlead1); 
        
        newLead1.Status='Appointment Fixed';
        newLead1.Entertainment_Unit__c='Yes';
        newLead1.Kitchen__c='Yes';
        newLead1.Pooja__c='Yes';
        newLead1.Crockery_Unit__c='Yes';
        newLead1.Foyer_Shoe_Rack__c='Yes';
        newLead1.LeadSource='website';
        newLead1.Vanity_Unit__c='Yes';
        newLead1.Wardrobes__c='1';
        newLead1.Utility_Unit__c='Yes';
        newLead1.Study_Table_Book_Shelf__c='Yes';
        newLead1.Property__c=m.Id;
        newLead1.Appointment_Type__c = 'Square Showroom Visit';
       newLead1.City = 'Bengaluru';
       newLead1.Interior_Start_Date__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       newLead1.Property_Type__c  = 'Villa';
       newLead1.Property_Config__c = '1 BHK';
       newLead1.Property_Status__c = 'New';
       newLead1.Property_Move_In_Date__c= Date.valueOf('2019-12-06T00:00:00.000Z');
       newLead1.Kitchen__c = 'Yes';
       newLead1.Vanity_Unit__c = 'Yes';
       newLead1.Utility_Unit__c = 'Yes';
       newLead1.Crockery_Unit__c = 'Yes';
       newLead1.Entertainment_Unit__c = 'Yes';
       newLead1.Pooja__c = 'Yes';
       newLead1.How_did_you_hear_about_us__c = 'Email';
       newLead1.Study_Table_Book_Shelf__c = 'Yes';
       newLead1.Foyer_Shoe_Rack__c = 'Yes';
       newLead1.Time_of_Actual_Appointment_Start__c = Date.valueOf('2017-12-06T00:00:00.000Z');  
       newLead1.Appointment_Venue_Square__c = m.Id;
       newLead1.Possession_Date__c = Date.valueOf('2019-12-06T00:00:00.000Z');
        
     //  update oldlist.values();     
        System.debug('--->oldlist  '+oldlist);      
       
       Test.startTest();      
       newLead1.Appointment_Time__c = System.now().addHours(3);
       update newLead1;
       newList1.put(newLead1.id,newlead1);
       System.debug('--->oldlist  '+oldlist);
       System.debug('--->newList1  '+newList1);
       RosterDpAvailability.RescheduleRoster(oldlist,newlist1);
       RosterDpAvailability.dummyTestCover();
       Test.setMock(HTTPCalloutMock.class, new RosterDpAvailability_Test());
       Test.stopTest();
       }
       catch(exception e){
       }
    } 
   
    global HTTPResponse respond(HTTPRequest request) {
        HTTPResponse res = new HTTPResponse();
        res.setBody('{"error":true,"response":false,"msg":"Meeting updated successfully."}');
        res.setHeader('Content-Type','application/json');
        res.setStatusCode(200);
        return res;
    }
}