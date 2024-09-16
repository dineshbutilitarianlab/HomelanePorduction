@isTest
global class leadGeneration_Test{
    static testMethod void leadGeneration(){
        IntegrationPoints__c  csobj6=new IntegrationPoints__c();
        csobj6.Field_Data_Type__c ='text';
        csobj6.Field_Label__c ='lastname';
        csobj6.Field_Name__c ='lastname';
        csobj6.In_Use__c = true;
        csobj6.Is_QueryString_Element__c = false;
        csobj6.Object_Name__c = 'lead';
        csobj6.Name = 'Phone';
        insert csobj6;
        IntegrationPoints__c  csobj8=new IntegrationPoints__c();
        csobj8.Field_Data_Type__c ='text';
        csobj8.Field_Label__c ='lastname';
        csobj8.Field_Name__c ='lastname';
        csobj8.In_Use__c = true;
        csobj8.Is_QueryString_Element__c = false;
        csobj8.Object_Name__c = 'Account';
        csobj8.Name = 'Phone';
        insert csobj8;
        IntegrationPoints__c  csobj5=new IntegrationPoints__c();
        csobj5.Field_Data_Type__c ='Text';
        csobj5.Field_Label__c ='phone';
        csobj5.Field_Name__c ='phone';
        csobj5.In_Use__c = true;
        csobj5.Is_QueryString_Element__c = false;
        csobj5.Object_Name__c = 'Account';
        csobj5.Name = 'Phone';
        insert csobj5;
        IntegrationPoints__c  csobj=new IntegrationPoints__c();
        csobj.Field_Data_Type__c ='Text';
        csobj.Field_Label__c ='city';
        csobj.Field_Name__c ='city';
        csobj.In_Use__c = true;
        csobj.Is_QueryString_Element__c = false;
        csobj.Object_Name__c = 'Lead';
        csobj.Name = 'city';
        insert csobj;
        IntegrationPoints__c  csobj1=new IntegrationPoints__c();
        csobj1.Field_Data_Type__c ='checkbox';
        csobj1.Field_Label__c ='Manual Lead Creation';
        csobj1.Field_Name__c ='Lead_Assingment__c';
        csobj1.In_Use__c = true;
        csobj1.Is_QueryString_Element__c = false;
        csobj1.Object_Name__c = 'Lead';
        csobj1.Name = 'Lead_Assingment__c';
        insert csobj1;
        IntegrationPoints__c  csobj7=new IntegrationPoints__c();
        csobj7.Field_Data_Type__c ='checkbox';
        csobj7.Field_Label__c ='Found_On_TC__c ';
        csobj7.Field_Name__c ='Found_On_TC__c ';
        csobj7.In_Use__c = true;
        csobj7.Is_QueryString_Element__c = false;
        csobj7.Object_Name__c = 'Account';
        csobj7.Name = 'Found_On_TC__c ';
        insert csobj7;
        IntegrationPoints__c  csobj10=new IntegrationPoints__c();
        csobj10.Field_Data_Type__c ='Text';
        csobj10.Field_Label__c ='LeadSource ';
        csobj10.Field_Name__c ='LeadSource ';
        csobj10.In_Use__c = true;
        csobj10.Is_QueryString_Element__c = true;
        csobj10.Object_Name__c = 'Lead';
        csobj10.Name = 'LeadSource ';
        insert csobj10;
        Integration_Point_Additional_Order__c  csobj11=new Integration_Point_Additional_Order__c();
        csobj11.Field_Data_Type__c ='Date';
        csobj11.Field_Label__c ='Session_Date__c';
        csobj11.Field_Name__c ='Session_Date__c';
        csobj11.In_Use__c = true;
        csobj11.Is_QueryString_Element__c = false;
        csobj11.Object_Name__c = 'Lead';
        csobj11.Name = 'Session Date';
        insert csobj11;
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account a = new Account();
        a.lastname= 'Test User';
        a.Customer_ID__c = 'BenTest-09';
        a.PersonEmail= 'asd@afad.com' ;
        a.phone= '1234556789';
        a.RecordTypeID=RecTypeId;
        insert a;
        
        IntegrationPoints__c  csobj2=new IntegrationPoints__c();
        csobj2.Field_Data_Type__c ='Date';
        csobj2.Field_Label__c ='Session_Date__c';
        csobj2.Field_Name__c ='Session_Date__c';
        csobj2.In_Use__c = true;
        csobj2.Is_QueryString_Element__c = false;
        csobj2.Object_Name__c = 'Lead';
        csobj2.Name = 'Session Date';
        insert csobj2;
     Lead l = new Lead();
     l.FirstName = 'Hamsa';
        l.LastName = 'Raj';
        l.Email = 'HamsaRaj@gmail.com';
        l.Phone = '9000000009';
        l.City = 'Bengaluru';
        l.LeadSource = 'Google Ad';
        l.Status = 'Fresh Lead';
        l.Sub_Status__c = 'New';
        l.Account__c=a.id;
        insert l;
        l.Status = 'Dead Lead';
        l.Sub_Status__c = 'Dead Lead';
        update l;
        
        IntegrationPoints__c i = new IntegrationPoints__c();
        i.name = '1';
        i.Object_Name__c = 'Lead';
        i.Field_Name__c = 'firstname';
        i.Field_Label__c = 'firstname';
        i.In_Use__c = true;
        i.Is_QueryString_Element__c = false;
        insert i;
     test.startTest();
     
        
       String JSONMsg='{"Session_Date__c":"","SF_User_Email":"abc@test.com","LeadSource":"Website","Manual Lead Creation":"false","Found_On_TC__c" : "true","name" : "Hamsa Raj","FirstName" : "Hamsa","lastname" : "Raj","email" : "HamsaRaj@gmail.com","phone" : "9000000009","city" : "Bengaluru","sourceurl" : "/hl/interiors13" ,"Company":"KVP","referred_by_code__c":"test code","querystring" : {"medium" : "cpc","campaign" : "Ace_Brand_Search","gclid" : "CJjjyvaD3swCFREHvAodCaoA9g","utm_campaign" : "Ace_Brand_Search","utm_medium" : "cpc","utm_source" : "SEM","Session_Date" : "10/10/2019"}}';

       
        try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/leadGeneration';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
          RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         leadGeneration.leadGeneration();
        }
        catch(exception e){
            system.debug('exception');
        }
 
        
         Test.stopTest();
         
    }
    
    static testMethod void leadGeneration1(){
    Account a1 = new Account(lastname = 'test', firstName = 'test', BillingCity = 'Bengaluru', phone = '9000000008', PersonEmail= 'HamsaRaj1@gmail.com');
        insert a1;
         Opportunity opp1 = new Opportunity();
        opp1.name = 'first';
        opp1.StageName='Won';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.AccountId = a1.id;
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-2);
        opp1.CityfromLead__c = 'Bengaluru';
        insert opp1;
        
     opp1 = [select id, name, stagename, accountid, closedate,Opportunity_Stage__c,amount, Time_of_Actual_Appointment_Start__c,CityfromLead__c, Customer_Phone_Number__c from opportunity where id =: opp1.id];
    
     test.startTest();
     
        
       String JSONMsg='{"name" : "Hamsa Raj","FirstName" : "Hamsa","lastname" : "Raj","email" : "HamsaRaj1@gmail.com","phone" : "9000000008","city" : "Bengaluru","sourceurl" : "/hl/interiors13" ,"Company":"KVP","referred_by_code__c":"test code","querystring" : {"medium" : "cpc"}';

       
        try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/leadGeneration';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
          RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         leadGeneration.leadGeneration();
        }
        catch(exception e){
            system.debug('exception');
        }
 
        
         Test.stopTest();
         
    }
        
    static testMethod void leadGeneration2(){
     
     test.startTest();
     
         IntegrationPoints__c  csobj6=new IntegrationPoints__c();
        csobj6.Field_Data_Type__c ='text';
        csobj6.Field_Label__c ='lastname';
        csobj6.Field_Name__c ='lastname';
        csobj6.In_Use__c = true;
        csobj6.Is_QueryString_Element__c = false;
        csobj6.Object_Name__c = 'lead';
        csobj6.Name = 'Phone';
        insert csobj6;
        IntegrationPoints__c  csobj8=new IntegrationPoints__c();
        csobj8.Field_Data_Type__c ='text';
        csobj8.Field_Label__c ='lastname';
        csobj8.Field_Name__c ='lastname';
        csobj8.In_Use__c = true;
        csobj8.Is_QueryString_Element__c = false;
        csobj8.Object_Name__c = 'Account';
        csobj8.Name = 'Phone';
        insert csobj8;
        IntegrationPoints__c  csobj5=new IntegrationPoints__c();
        csobj5.Field_Data_Type__c ='Text';
        csobj5.Field_Label__c ='phone';
        csobj5.Field_Name__c ='phone';
        csobj5.In_Use__c = true;
        csobj5.Is_QueryString_Element__c = false;
        csobj5.Object_Name__c = 'Account';
        csobj5.Name = 'Phone';
        insert csobj5;
        IntegrationPoints__c  csobj=new IntegrationPoints__c();
        csobj.Field_Data_Type__c ='Text';
        csobj.Field_Label__c ='city';
        csobj.Field_Name__c ='city';
        csobj.In_Use__c = true;
        csobj.Is_QueryString_Element__c = false;
        csobj.Object_Name__c = 'Lead';
        csobj.Name = 'city';
        insert csobj;
        IntegrationPoints__c  csobj10=new IntegrationPoints__c();
        csobj10.Field_Data_Type__c ='Text';
        csobj10.Field_Label__c ='LeadSource ';
        csobj10.Field_Name__c ='LeadSource ';
        csobj10.In_Use__c = true;
        csobj10.Is_QueryString_Element__c = true;
        csobj10.Object_Name__c = 'Lead';
        csobj10.Name = 'LeadSource ';
        insert csobj10;
       String JSONMsg='{"name" : "Hamsa Raj","FirstName" : "Hamsa","lastname" : "Raj","email" : "HamsaRaj2@gmail.com","phone" : "1234567890","city" : "Bengaluru","PropertyJson":{"State":"KA","Street":"Haralur Main Rd","Property_Config__c":"2 BHK","Property_Type__c":"Apartment","PlaceId":"ChIJzUYyvCe25zsR2cLBgiWdBtU","Locality":"Prestige Ferns Residency","PostalCode":"560102","lng":"77.66220729999999","lat":"12.9029705","City":"Haralur","Name":"Prestige Ferns Residency","Type":"Property","LeadId":"00QC2000006iavfMAA","module":"location"},"querystring" : {"medium" : "cpc","campaign" : "Ace_Brand_Search","source" : "SEM","gclid" : "CJjjyvaD3swCFREHvAodCaoA9g","utm_campaign" : "Ace_Brand_Search","utm_medium" : "cpc","utm_source" : "SEM"}}';
         
       
        try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/leadGeneration';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
          RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         leadGeneration.leadGeneration();
        }
        catch(exception e){
            system.debug('exception');
        }
 
        
         Test.stopTest();
         
    }
    public static testMethod void leadGenerationprop1(){
     
     test.startTest();
        String JSONMsg ='{ "lastname":"checkpropertyonline","phone":"6656783118","city":"Bengaluru","email":"1t99@gmail.com","postalcode":"526378","PropertyJson":'
        +'{"State":"KA","Street":"Haralur Main Rd","Property_Config__c":"2 BHK","Property_Type__c":"Apartment","PlaceId":"ChIJzUYyvCe25zsR2cLBgiWdBtU;ChIJozn-gWcTrjsRCrw_bCMhEyU","Locality":"Prestige Ferns Residency","PostalCode":"560102","lng":"77.66220729999999","lat":"12.9029705","City":"Haralur","Name":"Prestige Ferns Residency","Type":"Property","LeadId":"00QC2000006iavfMAA","module":"location"},"querystring":{"source":"Direct"}}';
          try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/leadGeneration';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
          RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         leadGeneration.leadGeneration();
        }
        catch(exception e){
            system.debug('exception');
        }
 
        
         Test.stopTest();
    }
    static testMethod void leadGeneration3(){
     
     test.startTest();
        Map<String,String> mapRecordType = new Map<String,String>();
      Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
      for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
        mapRecordType.put('Property',reType.getRecordTypeId());
      }
        Master__c m = new Master__c();
      m.isActive__c = true;
      m.Type__c = 'Property';
      m.Name = 'Brigade Palmsprings';
      m.Full_Name__c = 'Brigade Palmsprings';
      m.Total_Won_Opportunity__c = 6;
      m.Avg_Opportunites_Month__c = 20;
      m.Location__latitude__s = 12.971100;
      m.Location__longitude__s = 77.640920;
      m.RecordTypeId = Schema.SObjectType.Master__c.getRecordTypeInfosByName().get('Property').getRecordTypeId();
      m.PlaceId__c = 'qwyriophdiepo';
      m.Verification_Status__c = 'Google Verified';
     insert m;
     
         IntegrationPoints__c  csobj6=new IntegrationPoints__c();
        csobj6.Field_Data_Type__c ='text';
        csobj6.Field_Label__c ='lastname';
        csobj6.Field_Name__c ='lastname';
        csobj6.In_Use__c = true;
        csobj6.Is_QueryString_Element__c = false;
        csobj6.Object_Name__c = 'lead';
        csobj6.Name = 'Phone';
        insert csobj6;
        IntegrationPoints__c  csobj8=new IntegrationPoints__c();
        csobj8.Field_Data_Type__c ='text';
        csobj8.Field_Label__c ='lastname';
        csobj8.Field_Name__c ='lastname';
        csobj8.In_Use__c = true;
        csobj8.Is_QueryString_Element__c = false;
        csobj8.Object_Name__c = 'Account';
        csobj8.Name = 'Phone';
        insert csobj8;
        IntegrationPoints__c  csobj5=new IntegrationPoints__c();
        csobj5.Field_Data_Type__c ='Text';
        csobj5.Field_Label__c ='phone';
        csobj5.Field_Name__c ='phone';
        csobj5.In_Use__c = true;
        csobj5.Is_QueryString_Element__c = false;
        csobj5.Object_Name__c = 'Account';
        csobj5.Name = 'Phone';
        insert csobj5;
        IntegrationPoints__c  csobj=new IntegrationPoints__c();
        csobj.Field_Data_Type__c ='Text';
        csobj.Field_Label__c ='city';
        csobj.Field_Name__c ='city';
        csobj.In_Use__c = true;
        csobj.Is_QueryString_Element__c = false;
        csobj.Object_Name__c = 'Lead';
        csobj.Name = 'city';
        insert csobj;
        IntegrationPoints__c  csobj10=new IntegrationPoints__c();
        csobj10.Field_Data_Type__c ='Text';
        csobj10.Field_Label__c ='LeadSource ';
        csobj10.Field_Name__c ='LeadSource ';
        csobj10.In_Use__c = true;
        csobj10.Is_QueryString_Element__c = true;
        csobj10.Object_Name__c = 'Lead';
        csobj10.Name = 'LeadSource ';
        insert csobj10;
       String JSONMsg='{"name" : "Hamsa Raj","FirstName" : "Hamsa","lastname" : "Raj","email" : "HamsaRaj2@gmail.com","phone" : "1234567890","city" : "Bengaluru","PropertyJson":{"PlaceId":"qwyriophdiepo","LeadId":"","OppId": "","Type": "Property","Name": "Brigade Palmsprings","City": "Bengaluru","lat": "12.971100","lng":"77.640920","Postal Code": null,"Locality": "Brigade Palmsprings","Landmark": null,"Property_Type__c": "Apartment","Street": "35/37, Brigade Millenium Road, Paradise Colony, Phase 7, J. P. Nagar, Bengaluru, Karnataka 560078, India","State": "KA","Map Link": "https://maps.google.com/?cid=9766203242150079081"},"querystring" : {"medium" : "cpc","campaign" : "Ace_Brand_Search","source" : "SEM","gclid" : "CJjjyvaD3swCFREHvAodCaoA9g","utm_campaign" : "Ace_Brand_Search","utm_medium" : "cpc","utm_source" : "SEM"}}';
         
       
        try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/leadGeneration';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
          RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         leadGeneration.leadGeneration();
        }
        catch(exception e){
            system.debug('exception');
        }
 
        
         Test.stopTest();
         
    }
    static testMethod void leadGeneration4(){
     
     test.startTest();
        Map<String,String> mapRecordType = new Map<String,String>();
      Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
      for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
        mapRecordType.put('Property',reType.getRecordTypeId());
      }
        Master__c m = new Master__c();
      m.isActive__c = true;
      m.Type__c = 'Property';
      m.Name = 'Brigade Palmsprings';
      m.Full_Name__c = 'Brigade Palmsprings';
      m.Total_Won_Opportunity__c = 6;
      m.Avg_Opportunites_Month__c = 20;
      m.Location__latitude__s = 12.971100;
      m.Location__longitude__s = 77.640920;
      m.RecordTypeId = Schema.SObjectType.Master__c.getRecordTypeInfosByName().get('Property').getRecordTypeId();
      m.PlaceId__c = 'qwyriophdiepo';
      m.Verification_Status__c = 'Manually Verified';
     insert m;
     
         IntegrationPoints__c  csobj6=new IntegrationPoints__c();
        csobj6.Field_Data_Type__c ='text';
        csobj6.Field_Label__c ='lastname';
        csobj6.Field_Name__c ='lastname';
        csobj6.In_Use__c = true;
        csobj6.Is_QueryString_Element__c = false;
        csobj6.Object_Name__c = 'lead';
        csobj6.Name = 'Phone';
        insert csobj6;
        IntegrationPoints__c  csobj8=new IntegrationPoints__c();
        csobj8.Field_Data_Type__c ='text';
        csobj8.Field_Label__c ='lastname';
        csobj8.Field_Name__c ='lastname';
        csobj8.In_Use__c = true;
        csobj8.Is_QueryString_Element__c = false;
        csobj8.Object_Name__c = 'Account';
        csobj8.Name = 'Phone';
        insert csobj8;
        IntegrationPoints__c  csobj5=new IntegrationPoints__c();
        csobj5.Field_Data_Type__c ='Text';
        csobj5.Field_Label__c ='phone';
        csobj5.Field_Name__c ='phone';
        csobj5.In_Use__c = true;
        csobj5.Is_QueryString_Element__c = false;
        csobj5.Object_Name__c = 'Account';
        csobj5.Name = 'Phone';
        insert csobj5;
        IntegrationPoints__c  csobj=new IntegrationPoints__c();
        csobj.Field_Data_Type__c ='Text';
        csobj.Field_Label__c ='city';
        csobj.Field_Name__c ='city';
        csobj.In_Use__c = true;
        csobj.Is_QueryString_Element__c = false;
        csobj.Object_Name__c = 'Lead';
        csobj.Name = 'city';
        insert csobj;
        IntegrationPoints__c  csobj10=new IntegrationPoints__c();
        csobj10.Field_Data_Type__c ='Text';
        csobj10.Field_Label__c ='LeadSource ';
        csobj10.Field_Name__c ='LeadSource ';
        csobj10.In_Use__c = true;
        csobj10.Is_QueryString_Element__c = true;
        csobj10.Object_Name__c = 'Lead';
        csobj10.Name = 'LeadSource ';
        insert csobj10;
       String JSONMsg='{"name" : "Hamsa Raj","requestedBy":"Roster","FirstName" : "Hamsa","lastname" : "Raj","email" : "HamsaRaj2@gmail.com","phone" : "1234567890","city" : "Bengaluru","PropertyJson":{"PlaceId":"qwyriophdiepo","LeadId":"","OppId": "","Type": "Property","Name": "Brigade Palmsprings","City": "Bengaluru","lat": "12.971100","lng":"77.640920","Postal Code": null,"Locality": "Brigade Palmsprings","Landmark": null,"Property_Type__c": "Apartment","Street": "35/37, Brigade Millenium Road, Paradise Colony, Phase 7, J. P. Nagar, Bengaluru, Karnataka 560078, India","State": "KA","Map Link": "https://maps.google.com/?cid=9766203242150079081"},"querystring" : {"medium" : "cpc","campaign" : "Ace_Brand_Search","source" : "SEM","gclid" : "CJjjyvaD3swCFREHvAodCaoA9g","utm_campaign" : "Ace_Brand_Search","utm_medium" : "cpc","utm_source" : "SEM"}}';
         
       
        try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/leadGeneration';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
          RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         leadGeneration.leadGeneration();
        }
        catch(exception e){
            system.debug('exception');
        }
 
        
         Test.stopTest();
         
    }
    public static testMethod void matchPropertyNameTest() {
        test.startTest();
        AddressInfoAPI.matchPropertyName('sExisting', 'sMatchString');
        test.stopTest();
    }
    public static testMethod void leadGeneration5(){
        test.startTest();
        Map<String,String> mapRecordType = new Map<String,String>();
      Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
      for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
        mapRecordType.put('Property',reType.getRecordTypeId());
      }
        Master__c m = new Master__c();
      m.isActive__c = true;
      m.Type__c = 'Property';
      m.Name = 'Brigade Palmsprings';
      m.Full_Name__c = 'Brigade Palmsprings';
      m.Total_Won_Opportunity__c = 6;
      m.Avg_Opportunites_Month__c = 20;
      m.Location__latitude__s = 12.971100;
      m.Location__longitude__s = 77.640920;
      m.RecordTypeId = Schema.SObjectType.Master__c.getRecordTypeInfosByName().get('Property').getRecordTypeId();
      m.PlaceId__c = 'qwyriophdiepo';
      m.Verification_Status__c = 'Manually Verified';
     insert m;
     
         IntegrationPoints__c  csobj6=new IntegrationPoints__c();
        csobj6.Field_Data_Type__c ='text';
        csobj6.Field_Label__c ='lastname';
        csobj6.Field_Name__c ='lastname';
        csobj6.In_Use__c = true;
        csobj6.Is_QueryString_Element__c = false;
        csobj6.Object_Name__c = 'lead';
        csobj6.Name = 'Phone';
        insert csobj6;
        IntegrationPoints__c  csobj8=new IntegrationPoints__c();
        csobj8.Field_Data_Type__c ='text';
        csobj8.Field_Label__c ='lastname';
        csobj8.Field_Name__c ='lastname';
        csobj8.In_Use__c = true;
        csobj8.Is_QueryString_Element__c = false;
        csobj8.Object_Name__c = 'Account';
        csobj8.Name = 'Phone';
        insert csobj8;
        IntegrationPoints__c  csobj5=new IntegrationPoints__c();
        csobj5.Field_Data_Type__c ='Text';
        csobj5.Field_Label__c ='phone';
        csobj5.Field_Name__c ='phone';
        csobj5.In_Use__c = true;
        csobj5.Is_QueryString_Element__c = false;
        csobj5.Object_Name__c = 'Account';
        csobj5.Name = 'Phone';
        insert csobj5;
        IntegrationPoints__c  csobj=new IntegrationPoints__c();
        csobj.Field_Data_Type__c ='Text';
        csobj.Field_Label__c ='city';
        csobj.Field_Name__c ='city';
        csobj.In_Use__c = true;
        csobj.Is_QueryString_Element__c = false;
        csobj.Object_Name__c = 'Lead';
        csobj.Name = 'city';
        insert csobj;
        IntegrationPoints__c  csobj10=new IntegrationPoints__c();
        csobj10.Field_Data_Type__c ='Text';
        csobj10.Field_Label__c ='LeadSource ';
        csobj10.Field_Name__c ='LeadSource ';
        csobj10.In_Use__c = true;
        csobj10.Is_QueryString_Element__c = true;
        csobj10.Object_Name__c = 'Lead';
        csobj10.Name = 'LeadSource ';
        insert csobj10;
       String JSONMsg='{"name" : "Hamsa Raj","FirstName" : "Hamsa","lastname" : "Raj","email" : "HamsaRaj2@gmail.com","phone" : "1234567890","city" : "Bengaluru","querystring" : {"medium" : "cpc","campaign" : "Ace_Brand_Search","source" : "SEM","gclid" : "CJjjyvaD3swCFREHvAodCaoA9g","utm_campaign" : "Ace_Brand_Search","utm_medium" : "cpc","utm_source" : "SEM"}}';
         
       
        try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/leadGeneration';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
          RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         leadGeneration.leadGeneration();
        }
        catch(exception e){
            system.debug('exception');
        }
 
        
         Test.stopTest();
    }
     
    public static testMethod void leadGeneration6(){
     
     test.startTest();
        Map<String,String> mapRecordType = new Map<String,String>();
      Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
      for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
        mapRecordType.put('Property',reType.getRecordTypeId());
      }
        Master__c m = new Master__c();
      m.isActive__c = true;
      m.Type__c = 'Property';
      m.Name = 'Brigade Palmsprings';
      m.Full_Name__c = 'Brigade Palmsprings';
      m.Total_Won_Opportunity__c = 6;
      m.Avg_Opportunites_Month__c = 20;
      m.Location__latitude__s = 12.971100;
      m.Location__longitude__s = 77.640920;
      m.RecordTypeId = Schema.SObjectType.Master__c.getRecordTypeInfosByName().get('Property').getRecordTypeId();
      m.PlaceId__c = 'qwyriophdiepo';
      m.Verification_Status__c = 'Manually Verified';
     insert m;
     
         IntegrationPoints__c  csobj6=new IntegrationPoints__c();
        csobj6.Field_Data_Type__c ='text';
        csobj6.Field_Label__c ='lastname';
        csobj6.Field_Name__c ='lastname';
        csobj6.In_Use__c = true;
        csobj6.Is_QueryString_Element__c = false;
        csobj6.Object_Name__c = 'lead';
        csobj6.Name = 'Phone';
        insert csobj6;
        IntegrationPoints__c  csobj8=new IntegrationPoints__c();
        csobj8.Field_Data_Type__c ='text';
        csobj8.Field_Label__c ='lastname';
        csobj8.Field_Name__c ='lastname';
        csobj8.In_Use__c = true;
        csobj8.Is_QueryString_Element__c = false;
        csobj8.Object_Name__c = 'Account';
        csobj8.Name = 'Phone';
        insert csobj8;
        IntegrationPoints__c  csobj5=new IntegrationPoints__c();
        csobj5.Field_Data_Type__c ='Text';
        csobj5.Field_Label__c ='phone';
        csobj5.Field_Name__c ='phone';
        csobj5.In_Use__c = true;
        csobj5.Is_QueryString_Element__c = false;
        csobj5.Object_Name__c = 'Account';
        csobj5.Name = 'Phone';
        insert csobj5;
        IntegrationPoints__c  csobj=new IntegrationPoints__c();
        csobj.Field_Data_Type__c ='Text';
        csobj.Field_Label__c ='city';
        csobj.Field_Name__c ='city';
        csobj.In_Use__c = true;
        csobj.Is_QueryString_Element__c = false;
        csobj.Object_Name__c = 'Lead';
        csobj.Name = 'city';
        insert csobj;
        IntegrationPoints__c  csobj10=new IntegrationPoints__c();
        csobj10.Field_Data_Type__c ='Text';
        csobj10.Field_Label__c ='LeadSource ';
        csobj10.Field_Name__c ='LeadSource ';
        csobj10.In_Use__c = true;
        csobj10.Is_QueryString_Element__c = true;
        csobj10.Object_Name__c = 'Lead';
        csobj10.Name = 'LeadSource ';
        insert csobj10;
       //String JSONMsg='{"name" : "Hamsa Raj","FirstName" : "Hamsa","lastname" : "Raj","email" : "HamsaRaj2@gmail.com","phone" : "1234567890","city" : "Bengaluru","PropertyJson":"","querystring" : {"medium" : "cpc","campaign" : "Ace_Brand_Search","source" : "SEM","gclid" : "CJjjyvaD3swCFREHvAodCaoA9g","utm_campaign" : "Ace_Brand_Search","utm_medium" : "cpc","utm_source" : "SEM"}}';
         String JsonMsg='';
       
        try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/leadGeneration';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
          RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         leadGeneration.leadGeneration();
        }
        catch(exception e){
            system.debug('exception');
        }
 
        
         Test.stopTest();
    }
}