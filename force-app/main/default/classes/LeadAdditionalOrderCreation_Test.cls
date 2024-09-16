@isTest
public class LeadAdditionalOrderCreation_Test {
    static testMethod void leadGeneration(){
        Integration_Point_Additional_Order__c  csobj=new Integration_Point_Additional_Order__c();
        csobj.Field_Data_Type__c ='Text';
        csobj.Field_Label__c ='city';
        csobj.Field_Name__c ='city';
        csobj.In_Use__c = true;
        csobj.Is_QueryString_Element__c = false;
        csobj.Object_Name__c = 'Lead';
        csobj.Name = 'city';
        insert csobj;
        Integration_Point_Additional_Order__c  csobj1=new Integration_Point_Additional_Order__c();
        csobj1.Field_Data_Type__c ='Checkbox';
        csobj1.Field_Label__c ='Manual_Lead_Creation__c';
        csobj1.Field_Name__c ='Manual_Lead_Creation__c';
        csobj1.In_Use__c = true;
        csobj1.Is_QueryString_Element__c = false;
        csobj1.Object_Name__c = 'Lead';
        csobj1.Name = 'Manual_Lead_Creation__c';
        insert csobj1;
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account a = new Account();
        a.lastname= 'Test User';
        a.Customer_ID__c = 'BenTest-09';
        a.PersonEmail= 'asd@afad.com' ;
        a.phone= '1234556789';
        a.RecordTypeID=RecTypeId;
        insert a;
        
        Integration_Point_Additional_Order__c  csobj2=new Integration_Point_Additional_Order__c();
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
        l.Account__c=a.Id;
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
        
        
        String JSONMsg='{"SF_User_Email":"abc@gmail.com","city":"Bengaluru","referrer":"","First_Interaction_Data__c":null,"Click_ID__c":null,"GCLID__c":null,"Session_Date__c":"","Lead_Property_Name__c":"happy harden layout","Property_Status__c":"New","Sub Status":"New","signup_source":"","postalcode":"560016","Manual Lead Creation":false,"LeadSource":"direct","SF_Account_Id":"'+a.Id +'"}';
        
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/AdditionalMainOrder';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            
            RestResponse res = new RestResponse();
            RestContext.request = req;
            RestContext.response = res;
            LeadAdditionalOrderCreation.LeadAdditionalOrderCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        
        
        Test.stopTest();
        
    }
    
    static testMethod void leadGeneration2(){
        test.startTest();
        Integration_Point_Additional_Order__c  csobj=new Integration_Point_Additional_Order__c();
        csobj.Field_Data_Type__c ='Text';
        csobj.Field_Label__c ='city';
        csobj.Field_Name__c ='city';
        csobj.In_Use__c = true;
        csobj.Is_QueryString_Element__c = false;
        csobj.Object_Name__c = 'Lead';
        csobj.Name = 'city';
        insert csobj;
        Integration_Point_Additional_Order__c  csobj1=new Integration_Point_Additional_Order__c();
        csobj1.Field_Data_Type__c ='Checkbox';
        csobj1.Field_Label__c ='Manual_Lead_Creation__c';
        csobj1.Field_Name__c ='Manual_Lead_Creation__c';
        csobj1.In_Use__c = true;
        csobj1.Is_QueryString_Element__c = false;
        csobj1.Object_Name__c = 'Lead';
        csobj1.Name = 'Manual_Lead_Creation__c';
        insert csobj1;
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account a = new Account();
        a.lastname= 'Test User';
        a.Customer_ID__c = 'BenTest-09';
        a.PersonEmail= 'asd@afad.com' ;
        a.phone= '1234556789';
        a.RecordTypeID=RecTypeId;
        insert a;
        
        Integration_Point_Additional_Order__c  csobj2=new Integration_Point_Additional_Order__c();
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
        l.Account__c=a.Id;
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
        
                
        
        String JSONMsg='{"SF_User_Email":"abc@gmail.com","city":"Bengaluru","referrer":"","First_Interaction_Data__c":null,"Click_ID__c":null,"GCLID__c":null,"Session_Date__c":"","Lead_Property_Name__c":"happy harden layout","Property_Status__c":"New","Sub Status":"New","signup_source":"","postalcode":"560016","Manual Lead Creation":false,"LeadSource":"direct","PropertyJson":{"module":"location","Type":"Property","Name":"Prestige Ferns Residency","City":"Haralur","lat":"12.9029705","lng":"77.66","PostalCode":"560102","Locality":"Prestige Ferns Residency","Property_Type__c":"Apartment","Property_Config__c":"2 BHK","Street":"Haralur Main Rd","State":"KA"},"querystring" : {"medium" : "cpc","campaign" : "Ace_Brand_Search","gclid" : "CJjjyvaD3swCFREHvAodCaoA9g","utm_campaign" : "Ace_Brand_Search","utm_medium" : "cpc","utm_source" : "SEM","Session_Date" : "10/10/2019"},"SF_Account_Id":"'+a.Id +'"}';
        
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/AdditionalMainOrder';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            
            RestResponse res = new RestResponse();
            RestContext.request = req;
            RestContext.response = res;
            LeadAdditionalOrderCreation.LeadAdditionalOrderCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        
        
        Test.stopTest();
    }
    
    static testMethod void leadGeneration3(){
        test.startTest();
        Integration_Point_Additional_Order__c  csobj=new Integration_Point_Additional_Order__c();
        csobj.Field_Data_Type__c ='Text';
        csobj.Field_Label__c ='city';
        csobj.Field_Name__c ='city';
        csobj.In_Use__c = true;
        csobj.Is_QueryString_Element__c = false;
        csobj.Object_Name__c = 'Lead';
        csobj.Name = 'city';
        insert csobj;
        Integration_Point_Additional_Order__c  csobj1=new Integration_Point_Additional_Order__c();
        csobj1.Field_Data_Type__c ='Checkbox';
        csobj1.Field_Label__c ='Manual_Lead_Creation__c';
        csobj1.Field_Name__c ='Manual_Lead_Creation__c';
        csobj1.In_Use__c = true;
        csobj1.Is_QueryString_Element__c = false;
        csobj1.Object_Name__c = 'Lead';
        csobj1.Name = 'Manual_Lead_Creation__c';
        insert csobj1;
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account a = new Account();
        a.lastname= 'Test User';
        a.Customer_ID__c = 'BenTest-09';
        a.PersonEmail= 'asd@afad.com' ;
        a.phone= '1234556789';
        a.RecordTypeID=RecTypeId;
        insert a;
        
        Integration_Point_Additional_Order__c  csobj2=new Integration_Point_Additional_Order__c();
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
        l.Account__c=a.Id;
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
        
                
        
        //String JSONMsg='{"SF_User_Email":"abc@gmail.com","city":"Bengaluru","referrer":"","First_Interaction_Data__c":null,"Click_ID__c":null,"GCLID__c":null,"Session_Date__c":"","Lead_Property_Name__c":"happy harden layout","Property_Status__c":"New","Sub Status":"New","signup_source":"","postalcode":"560016","Manual Lead Creation":false,"LeadSource":"direct","PropertyJson":{"module":"location","Type":"Property","Name":"Prestige Ferns Residency","City":"Haralur","lat":"12.9029705","lng":"77.66","PostalCode":"560102","Locality":"Prestige Ferns Residency","Property_Type__c":"Apartment","Property_Config__c":"2 BHK","Street":"Haralur Main Rd","State":"KA"},"SF_Account_Id":"'+a.Id +'"}';
        String JSONMsg='';
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/AdditionalMainOrder';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            
            RestResponse res = new RestResponse();
            RestContext.request = req;
            RestContext.response = res;
            LeadAdditionalOrderCreation.LeadAdditionalOrderCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        
        
        Test.stopTest();
    }
    
}