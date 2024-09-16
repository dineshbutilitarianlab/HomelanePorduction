@isTest
public class TypeformOpportunity_Test {
    @TestVisible
    public static testMethod void test1() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Discussion Meeting Fixed';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '1';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'first';
        opp2.Full_Name__c = 'first';        
        opp2.Customer_Email__c = 'opptest2test@testdwg.com';
        opp2.StageName='Quote Required';
        opp2.Opportunity_Stage__c = 'Won';
        opp2.CloseDate = Date.Today();
        opp2.Amount = 1000;
        opp2.CityfromLead__c = 'Noida';
     //   opp2.Square_Showroom_Agent__c = user1.Id;
        opp2.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp2.Interior_Design_Partner__c = inte2.Id;
      //  opp2.Square_Showroom_Manager__c = user1.Id; 
        opp2.X_Hrs_Email_Sent__c = false;
     //   opp2.AccountId = portalAccount1.Id;
        opp2.Meeting_Stage__c = 'Discussion Meeting Fixed';
        opp2.Meeting_Response__c = 0;
        opp2.No_of_Meetings_Done__c = '1';
        insert opp2;
        SYstem.debug('****opp2 '+opp2);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"Yes"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"Yes"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }      
        
    /*    String JSONMsg1 = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp2.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"Yes"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg1); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }  */       
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test2() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Discussion Meeting Fixed';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '1';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"No"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test3() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '2';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"Yes"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test4() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '2';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"No"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test5() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '3';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"Yes"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test6() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '3';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"No"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test7() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '4';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"Yes"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test8() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '4';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"No"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test9() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '5';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"Yes"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test10() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '5';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"No"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test11() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '6';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"Yes"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test12() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '6';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"No"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test13() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '7';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"Yes"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test14() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '7';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"No"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test15() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '8';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"Yes"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test16() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '8';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"No"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test17() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '9';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"Yes"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
    
     @TestVisible
    public static testMethod void test18() {   
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
     //   opp1.Square_Showroom_Agent__c = user1.Id;
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
      //  opp1.Interior_Design_Partner__c = inte2.Id;
      //  opp1.Square_Showroom_Manager__c = user1.Id; 
        opp1.X_Hrs_Email_Sent__c = false;
     //   opp1.AccountId = portalAccount1.Id;
        opp1.Meeting_Stage__c = 'Second Meeting Done';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '9';
        insert opp1;
        SYstem.debug('****opp1 '+opp1);
        
        Test.startTest();
        String JSONMsg = '{"event_id":"01CXSSMYBE5E3X6DKRQBAW1S7C","event_type":"form_response","form_response":{"form_id":"yQjBXa","token":"5ef55dcbb155d057a28e5d7151c8eaab","landed_at":"2018-12-03T10:25:57Z","submitted_at":"2018-12-03T10:26:02Z","hidden":{"opportunityid":"' + opp1.Id + '"},"definition":{"id":"yQjBXa","title":"Second Meeting Status","fields":[{"id":"Zy2BEMxBosjZ","title":"Was this customers meeting completed ?" ,"type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff","properties":{},"choices":[{"id":"qL3wLQ4TORiP","label":"No"},{"id":"nAZhiwh7WMfK","label":"No"}]}]},"answers":[{"type":"choice","choice":{"label":"No"},"field":{"id":"Zy2BEMxBosjZ","type":"multiple_choice","ref":"86625b72-8703-47a9-9c42-85017a0d3eff"}}]}}';
     try{
         RestRequest req = new RestRequest(); // Build the REST Request for testing
         req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
         req.requestURI = '/services/apexrest/TypeformOpportunity';
         req.httpMethod = 'POST';        // Perform a POST
         req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
         
         RestResponse res = new RestResponse();
         RestContext.request = req;
         RestContext.response = res;
         TypeformOpportunity.Typeform();
        }
        catch(exception e){
            system.debug('exception  '+e.getMessage() +' at line : '+e.getLineNumber());
        }        
         Test.stopTest();
    }
}