@isTest
public class CallBackAPI_Controller_Test {
    Public static Lead ld;
    Public static Master__c showRoom;
    Public static Account acc;
    Public static Opportunity opp;
    Public static User WTAUser;
    Public static Integration_Setting__c intSetting;
    Public static Call_Back_City_Campaign_Mapping__c callBackCityCampaining;
    @TestSetup static void data() {
        // Create a WTA user
        WTAUser = TestData_Factory.inserWTAUser('someWTAuser@some.com','abc',TRUE);
        //Create a Active ShowRoom Master record
        showRoom = TestData_Factory.CreateShowRoom(False);
        showRoom.Type__c ='Showroom';
        insert showRoom;
        
        //Create Lead Record
        ld = TestData_Factory.CreateFreshLead(true);
        /*
        //Create Account Record
        acc = TestData_Factory.createAccount(true);
        
        //Create Opportunity records
        Opp = TestData_Factory.createOpportunity(acc.Id, true);
        */
        callBackCityCampaining = new Call_Back_City_Campaign_Mapping__c();
        callBackCityCampaining.Name='bengaluru';
        callBackCityCampaining.Campaign_Name__c = 'CityWise_Callback';
        insert callBackCityCampaining;
    }
    public static testMethod void getLeadInfoTest1(){
        Test.startTest();
        ld = [Select 
              id,customer_Id__c,Email,Phone,City,IsConverted,Sales_Manager__c,Sales_Manager_Email__c,Assigned_To_Resi_ASM__c,Requested_Call_Back__c,
              WT_Agent__c,WT_Agent__r.Name,WT_Agent__r.Cloud_Agent_Campaign_Name__c,WT_Agent__r.Email,WT_Agent__r.Profile.Name
              From Lead limit 1];
        showRoom = [Select id from Master__C];
        /*database.leadConvert lc = new database.leadConvert();
        lc.setLeadId(ld.id);*/
        ld = TestData_Factory.MarkAsAppointmentFixed(ld);
        ld.Status = 'Appointment Successful';
        ld.Sub_Status__c = 'Appointment Successful';
        ld.Appointment_Venue_Square__c = showRoom.Id;
        ld.Time_of_Actual_Appointment_Start__c = System.now();
        update ld;
        //String JSONMsg='{"recordId":"'+leadId+'","showRoomId":"'+showroomId+'"}'; 
        String JSONMsg='{"Customer_Order_Id" : "'+ld.customer_Id__c+'"}';       
        
        try{
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/CallbackAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            CallBackAPI_Controller.getLeadInfo();  
            
            //JSONMsg='{"Phone" : "1234","Email" : "'+ld.Email+'"}';
            JSONMsg='{"Customer_Order_Id" : "'+ld.customer_Id__c+'"}';
            req.requestBody = Blob.valueof(JSONMsg);
            CallBackAPI_Controller.getLeadInfo();
            
            //JSONMsg='{"Phone" : "","Email" : "'+ld.Email+'"}';
            JSONMsg='{"Customer_Order_Id" : ""}';
            req.requestBody = Blob.valueof(JSONMsg);
            CallBackAPI_Controller.getLeadInfo();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void processCallBackRequestLeadTest1(){
        Test.startTest();
        ld = [Select 
              id,customer_Id__c,Email,Phone,City,IsConverted,Sales_Manager__c,Sales_Manager_Email__c,Assigned_To_Resi_ASM__c,Requested_Call_Back__c,
              WT_Agent__c,WT_Agent__r.name,WT_Agent__r.Cloud_Agent_Campaign_Name__c,WT_Agent__r.Email,WT_Agent__r.Profile.Name
              From Lead limit 1];
        try{
            ld.Assigned_to_Resi_ASM__c = true;
            update ld;
            CallBackAPI_Controller.processCallBackRequestLead(ld);
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void processCallBackRequestLeadTest2(){
        Test.startTest();
        ld = [Select 
              id,customer_Id__c,Email,Phone,City,IsConverted,Sales_Manager__c,Sales_Manager_Email__c,Assigned_To_Resi_ASM__c,Requested_Call_Back__c,
              WT_Agent__c,WT_Agent__r.name,WT_Agent__r.Cloud_Agent_Campaign_Name__c,WT_Agent__r.Email,WT_Agent__r.Profile.Name
              From Lead limit 1];
        WTAUser = [Select id,Profile.Name,Name from User limit 1];
        System.debug('WTAUser: '+WTAUser);
        System.debug('WTAUser.Profile.Name: '+WTAUser.Profile.Name);
        try{
            ld.WT_Agent__c = WTAUser.Id;
            update ld;
            CallBackAPI_Controller.processCallBackRequestLead(ld);
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    /*public static testMethod void processCallBackRequestLeadTest3(){
        Test.startTest();
        ld = [Select 
              id,Email,Phone,City,IsConverted,Sales_Manager__c,Sales_Manager_Email__c,Assigned_To_Resi_ASM__c,Requested_Call_Back__c,
              WT_Agent__c,WT_Agent__r.name,WT_Agent__r.Cloud_Agent_Campaign_Name__c,WT_Agent__r.Email,WT_Agent__r.Profile.Name
              From Lead limit 1];
        WTAUser = [Select id,Profile.Name,Name from User limit 1];
        System.debug('WTAUser: '+WTAUser);
        System.debug('WTAUser.Profile.Name: '+WTAUser.Profile.Name);
        try{
            ld.WT_Agent__c = WTAUser.Id;
            ld.Change_Owner__c = TRUE;
            update ld;
            CallBackAPI_Controller.processCallBackRequestLead(ld);
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }*/
    public static testMethod void getAgentStatusfromOZoneTelTest1(){
        // Create integration Setting record for Lead square
        intSetting = TestData_Factory.createIntegrationSetting('OzoneTel Agent Status API','https://api1.cloudagent.in/CAServices/AgentDetails/AgentDetails.php?userName=','u$r132fe08ce31d4b4f','application/json','KK1974dd56933b4c69602c063d589e19ab');
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        Test.startTest();
        ld = [Select 
              id,customer_Id__c,Email,Phone,City,IsConverted,Sales_Manager__c,Sales_Manager_Email__c,Assigned_To_Resi_ASM__c,Requested_Call_Back__c,
              WT_Agent__c,WT_Agent__r.name,WT_Agent__r.Cloud_Agent_Campaign_Name__c,WT_Agent__r.Email,WT_Agent__r.Profile.Name
              From Lead limit 1];
        WTAUser = [Select id,Profile.Name,Name from User limit 1];
        System.debug('WTAUser: '+WTAUser);
        System.debug('WTAUser.Profile.Name: '+WTAUser.Profile.Name);
        try{
            
            CallBackAPI_Controller.getAgentStatusfromOZoneTel('Test@mailnator.com','OzoneTel Agent Status API');
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void getAgentStatusfromOZoneTelTest2(){
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        Test.startTest();
        ld = [Select 
              id,customer_Id__c,Email,Phone,City,IsConverted,Sales_Manager__c,Sales_Manager_Email__c,Assigned_To_Resi_ASM__c,Requested_Call_Back__c,
              WT_Agent__c,WT_Agent__r.name,WT_Agent__r.Cloud_Agent_Campaign_Name__c,WT_Agent__r.Email,WT_Agent__r.Profile.Name
              From Lead limit 1];
        WTAUser = [Select id,Profile.Name,Name from User limit 1];
        System.debug('WTAUser: '+WTAUser);
        System.debug('WTAUser.Profile.Name: '+WTAUser.Profile.Name);
        try{
            // Create integration Setting record for Lead square
        intSetting = TestData_Factory.createIntegrationSetting('OzoneTel Agent Status API','https://api1.cloudagent.in/CAServices/AgentDetails/AgentDetails.php?userName=','u$r132fe08ce31d4b4f','application/json','KK1974dd56933b4c69602c063d589e19ab');
        
            CallBackAPI_Controller.getAgentStatusfromOZoneTel('Test@mailnator.com','OzoneTel Agent Status API');
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void pushLeadToOzonetelPriorityCityQueueTest1(){
        intSetting = TestData_Factory.createIntegrationSetting('OzoneTel addCamapaignData API','https://api1.cloudagent.in/cloudAgentRestAPI/index.php/CloudAgent/CloudAgentAPI/addCamapaignData?','u$r132fe08ce31d4b4f','application/json','KK1974dd56933b4c69602c063d589e19ab');
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        Test.startTest();
        ld = [Select 
              id,customer_Id__c,Email,Phone,City,IsConverted,Sales_Manager__c,Sales_Manager_Email__c,Assigned_To_Resi_ASM__c,Requested_Call_Back__c,
              WT_Agent__c,WT_Agent__r.name,WT_Agent__r.Cloud_Agent_Campaign_Name__c,WT_Agent__r.Email,WT_Agent__r.Profile.Name
              From Lead limit 1];
        WTAUser = [Select id,Profile.Name,Name from User limit 1];
        System.debug('WTAUser: '+WTAUser);
        System.debug('WTAUser.Profile.Name: '+WTAUser.Profile.Name);
        try{
            
        	CallBackAPI_Controller.pushLeadToOzonetelPriorityCityQueue(ld, 'OzoneTel addCamapaignData API');
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void pushLeadToOzonetelPriorityCityQueueTest2(){
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        Test.startTest();
        ld = [Select 
              id,customer_Id__c,Email,Phone,City,IsConverted,Sales_Manager__c,Sales_Manager_Email__c,Assigned_To_Resi_ASM__c,Requested_Call_Back__c,
              WT_Agent__c,WT_Agent__r.name,WT_Agent__r.Cloud_Agent_Campaign_Name__c,WT_Agent__r.Email,WT_Agent__r.Profile.Name
              From Lead limit 1];
        WTAUser = [Select id,Profile.Name,Name from User limit 1];
        System.debug('WTAUser: '+WTAUser);
        System.debug('WTAUser.Profile.Name: '+WTAUser.Profile.Name);
        try{
            intSetting = TestData_Factory.createIntegrationSetting('OzoneTel addCamapaignData API','https://api1.cloudagent.in/cloudAgentRestAPI/index.php/CloudAgent/CloudAgentAPI/addCamapaignData?','u$r132fe08ce31d4b4f','application/json','KK1974dd56933b4c69602c063d589e19ab');
        	CallBackAPI_Controller.pushLeadToOzonetelPriorityCityQueue(ld, 'OzoneTel addCamapaignData API');
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void pushLeadToOzonetelPriorityAgentQueueTest1(){
        intSetting = TestData_Factory.createIntegrationSetting('OzoneTel addCamapaignData API','https://api1.cloudagent.in/cloudAgentRestAPI/index.php/CloudAgent/CloudAgentAPI/addCamapaignData?','u$r132fe08ce31d4b4f','application/json','KK1974dd56933b4c69602c063d589e19ab');
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        Test.startTest();
        ld = [Select 
              id,customer_Id__c,Email,Phone,City,IsConverted,Sales_Manager__c,Sales_Manager_Email__c,Assigned_To_Resi_ASM__c,Requested_Call_Back__c,
              WT_Agent__c,WT_Agent__r.name,WT_Agent__r.Cloud_Agent_Campaign_Name__c,WT_Agent__r.Email,WT_Agent__r.Profile.Name
              From Lead limit 1];
        WTAUser = [Select id,Profile.Name,Name from User limit 1];
        System.debug('WTAUser: '+WTAUser);
        System.debug('WTAUser.Profile.Name: '+WTAUser.Profile.Name);
        try{
            
        	CallBackAPI_Controller.pushLeadToOzonetelPriorityAgentQueue(ld, 'OzoneTel addCamapaignData API',Label.Call_Back_Priority_Agent_Campaign_Name,'Test@mailnator.com');
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void pushLeadToOzonetelPriorityAgentQueueTest2(){
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        Test.startTest();
        ld = [Select 
              id,customer_Id__c,Email,Phone,City,IsConverted,Sales_Manager__c,Sales_Manager_Email__c,Assigned_To_Resi_ASM__c,Requested_Call_Back__c,
              WT_Agent__c,WT_Agent__r.name,WT_Agent__r.Cloud_Agent_Campaign_Name__c,WT_Agent__r.Email,WT_Agent__r.Profile.Name
              From Lead limit 1];
        WTAUser = [Select id,Profile.Name,Name from User limit 1];
        System.debug('WTAUser: '+WTAUser);
        System.debug('WTAUser.Profile.Name: '+WTAUser.Profile.Name);
        try{
            intSetting = TestData_Factory.createIntegrationSetting('OzoneTel addCamapaignData API','https://api1.cloudagent.in/cloudAgentRestAPI/index.php/CloudAgent/CloudAgentAPI/addCamapaignData?','u$r132fe08ce31d4b4f','application/json','KK1974dd56933b4c69602c063d589e19ab');
        	CallBackAPI_Controller.pushLeadToOzonetelPriorityAgentQueue(ld, 'OzoneTel addCamapaignData API',Label.Call_Back_Priority_Agent_Campaign_Name,'Test@mailnator.com');
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void UpdateCallBackRequestDetailsTest(){
        Test.startTest();
        try{
        	CallBackAPI_Controller.UpdateCallBackRequestDetails(null, null);
            Lead ld = new Lead();
            CallBackAPI_Controller.UpdateCallBackRequestDetails(ld, 'null');
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    
}