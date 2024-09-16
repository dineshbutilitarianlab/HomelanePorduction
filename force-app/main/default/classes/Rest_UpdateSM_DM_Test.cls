@isTest
Public class Rest_UpdateSM_DM_Test {
    public static testMethod void LeadSuccess() {
    
    Map<String,Id> profileData = new Map<String,Id>();
    for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile','Standard User')]){
        profileData.put(obj.Name,obj.Id);
    }
    
    User wta_user = new User(alias = 'ameyo', email='ameyousertest@homelane.com',
    emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('Standard User'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertest@homelane.com');
    insert wta_user;
    
    Showroom_User__c ShowroomUser= TestData_Factory.createShowroomUser(false); 
    ShowroomUser.email__c='ameyousertest@homelane.com';
    insert ShowroomUser;
    
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
    insert inte;
    
    Lead l = new Lead(); 
    l.FirstName = 'Hamsa';
    l.LastName = 'Raj';
    l.Email = 'HamsaRaj@gmail.com';
    l.Phone = '9000000009';
    l.City = 'Bengaluru';
    l.LeadSource = 'Google Ad';
    l.Status = 'Fresh Lead';
    l.Sub_Status__c = 'New';
    insert l;
    System.debug('lead OPropertu'+l.property__c);
    
    test.startTest();
      String JSONMsg='{"recordId":"'+l.id+'","type":"Lead","smEmail":"ameyousertest@homelane.com","dpEmail":"test@google.com"}';
      try{
          RestRequest req = new RestRequest(); // Build the REST Request for testing
          req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
          req.requestURI = '/services/apexrest/AddressInfoAPI';
          req.httpMethod = 'POST';        // Perform a POST
          req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
          
          RestResponse res = new RestResponse();
          RestContext.request = req;
          RestContext.response = res;
          Rest_UpdateSM_DM.Rest_UpdateSM_DM();
        }
        catch(exception e){
            system.debug('exception');
        }
    test.StopTest();
    }
    
    public static testMethod void oppSuccess(){
    
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile','Standard User')]){
        profileData.put(obj.Name,obj.Id);
        }
        
        User wta_user = new User(alias = 'ameyo', email='ameyousertest@homelane.com',
        emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('Standard User'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertest@homelane.com');
        insert wta_user;
        
        Showroom_User__c ShowroomUser= TestData_Factory.createShowroomUser(false); 
        ShowroomUser.email__c='ameyousertest@homelane.com';
        insert ShowroomUser;        
    
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
        insert inte;
    
    
        Opportunity opp1 = new Opportunity();
        opp1.name = 'first';
        opp1.StageName='Won';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.Opportunity_Status__c = '6.Won';
        // opp1.AccountId = a.id;
        opp1.Customer_Satisfaction__c = 5;
        opp1.CloseDate = Date.Today();
        // opp1.Interior_Design_Partner__c = inte.id;
        opp1.Order_Book_Date__c = Date.Today();
        opp1.Amount = 1000;
        opp1.Order_Closed__c = true;
        opp1.Appointment_Type__c = 'Square Showroom Visit';
        opp1.Time_of_Actual_Appointment_Start__c = Date.Today().addmonths(-1);
        opp1.Order_Book_Date__c = Date.Today().addmonths(-1);
        //oppList.add(opp1);
        System.debug('****opp1  '+opp1);
        insert opp1;
        
        test.startTest();
        String JSONMsg='{"recordId":"'+opp1.id+'","type":"Opportunity","smEmail":"ameyousertest@homelane.com","dpEmail":"test@google.com"}';
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/AddressInfoAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            
            RestResponse res = new RestResponse();
            RestContext.request = req;
            RestContext.response = res;
            Rest_UpdateSM_DM.Rest_UpdateSM_DM();
        }
        catch(exception e){
        system.debug('exception');
        }
        test.StopTest();
    }
    
        public static testMethod void Error(){
    
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile','Standard User')]){
        profileData.put(obj.Name,obj.Id);
        }
        
        User wta_user = new User(alias = 'ameyo', email='ameyousertest@homelane.com',
        emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('Standard User'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertest@homelane.com');
        insert wta_user;
        
        Showroom_User__c ShowroomUser= TestData_Factory.createShowroomUser(false); 
        ShowroomUser.email__c='ameyousertest@homelane.com';
        insert ShowroomUser;
    
    
        Opportunity opp1 = new Opportunity();
        opp1.name = 'first';
        opp1.StageName='Won';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.Opportunity_Status__c = '6.Won';
        // opp1.AccountId = a.id;
        opp1.Customer_Satisfaction__c = 5;
        opp1.CloseDate = Date.Today();
        // opp1.Interior_Design_Partner__c = inte.id;
        opp1.Order_Book_Date__c = Date.Today();
        opp1.Amount = 1000;
        opp1.Order_Closed__c = true;
        opp1.Appointment_Type__c = 'Square Showroom Visit';
        opp1.Time_of_Actual_Appointment_Start__c = Date.Today().addmonths(-1);
        opp1.Order_Book_Date__c = Date.Today().addmonths(-1);
        //oppList.add(opp1);
        System.debug('****opp1  '+opp1);
        insert opp1;
        
        test.startTest();
        String JSONMsg='{"recordId":"12342323443","type":"Opportunity","smEmail":"ameyousertest@homelane.com","dpEmail":"test@google.com"}';
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/AddressInfoAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            
            RestResponse res = new RestResponse();
            RestContext.request = req;
            RestContext.response = res;
            Rest_UpdateSM_DM.Rest_UpdateSM_DM();
        }
        catch(exception e){
        system.debug('exception');
        }
        test.StopTest();
    }
    
 }