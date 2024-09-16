@isTest
public class BulkOfflineLeadCreation_Controller_Test {
    Public static Lead ld1;
    Public static Lead ld2;
    Public static lead ld3;
    Public static Opportunity Op1;
    Public static Account acc1;
    Public static Account acc2;
    public static List<Bulk_Offline_Lead_Creation_Fields__c> listOfCustomSetting;
    @TestSetup static void data() {
        acc1=TestData_Factory.createAccount(false);
        acc1.name = 'aa';
        acc1.Phone = '1234567891';
        
        insert acc1;
        
        acc2=TestData_Factory.createAccount(false);
        acc2.name = 'aas';
        acc2.Phone = '1234567892';
        
        insert acc2;        
        //Create Lead Record
        ld1 = TestData_Factory.CreateFreshLead(false);
        ld2 = TestData_Factory.CreateFreshLead(false);
        ld3 = TestData_Factory.CreateFreshLead(false);
        
        
        ld2.Email ='someOtherEmail@check.com';
        ld2.Phone ='7892944602';
        ld1.status = 'Dead Lead';
        ld2.status = 'Dead Lead';
        Showroom_User__c sh1= new Showroom_User__c();
        sh1.Name='testshow';
        sh1.Role__c='Tele Caller Agent';
        sh1.IsActive__c= true;
        sh1.Email__c='email1@gmail.com';
        insert sh1;
        ld1.Tele_caller__c= sh1.id;
        ld1.Assigned_To_TLC__c= true;
        ld1.Account__c=acc1.id;
        Op1=TestData_Factory.createOpportunity(acc1.id, true);
        //Op1.Customer_Phone_Number__c =ac.Phone;
            
        
        ld1.Telecaller_Email__c=sh1.Email__c;
        Showroom_User__c sh2= new Showroom_User__c();
        sh2.Name='testshow2';
        sh2.Email__c='email2@gmail.com';
        sh2.Role__c='Iron man';
        sh2.IsActive__c= true;
        insert sh2;
        ld2.Sales_Manager__c= sh2.id;
        ld2.Account__c=acc2.id;
        ld2.Assigned_to_Resi_ASM__c = true;
        
        
        List<Lead> listOfLeadsToInsert = new List<Lead>();
        listOfLeadsToInsert.add(ld1);
        listOfLeadsToInsert.add(ld2);
        insert listOfLeadsToInsert;
        
        //Create custom setting records for dynamic wrapper
        listOfCustomSetting = new List<Bulk_Offline_Lead_Creation_Fields__c>();
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 1', 'LeadSource', 'Picklist', 'Lead Source', True, False,False,false));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 2', 'FirstName', 'Text', 'FirstName', True, False,False,true));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 3', 'LastName', 'Text', 'LastName', True, False,False,true));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 4', 'Email', 'Email', 'Email', True, False,False,true));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 5', 'Phone', 'Phone', 'Phone', True, False,False,true));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 6', 'Lead_Property_Name__c', 'Text', 'Lead Property Name', True, True,False,false));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 7', 'City', 'Text', 'City', True, False,False,false));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 8', 'PostalCode', 'Text', 'Zip/Postal Code', True, False,False,false));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 9', 'HL_Referrer_Phone__c', 'Text', 'HL Referrer Phone', True, True,False,false));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 10', 'Bulk_Upload__c', 'Checkbox', 'Bulk Upload', True, True,False,false));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 11', 'Status', 'Picklist', 'Status', True, False,False,false));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 12', 'Sub_Status__c', 'Picklist', 'Sub Status', True, False,False,false));
        insert listOfCustomSetting;
        
        //Create Channel Partner
       	TestData_Factory.createChannelPartner('CP NAME', '9840823833', 'Broker/Channel Partner', True);
    }
   /* public static testMethod void bulkOfflineLeadCreationTest5A(){
        
        List<Lead> listOfLeadsToUpdate = new List<Lead>();
        Account ac=TestData_Factory.createAccount(false);
        ac.name = 'aa';
        ac.Phone = '9840823833';
        insert ac;
        for(lead ld: [Select id,Email,Phone from Lead]){
            ld.Status = 'Dead Lead';
            ld.Sub_Status__c = 'Dead Lead';
            listOfLeadsToUpdate.add(ld);
            ld.Account__c = ac.Id;
        }
        update listOfLeadsToUpdate;
        
        if(listOfLeadsToUpdate[0] !=null){
            ld1 = listOfLeadsToUpdate[0];
        }
        if(listOfLeadsToUpdate[1] !=null){
            ld2 = listOfLeadsToUpdate[1];
        }
        Test.startTest();
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"'+ac.Phone+'","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","Brand__c" ="Doowup"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }*/
    
     public static testMethod void bulkOfflineLeadCreationTestWrapzap(){
        delete [Select id from Channel_Partner__c];
        
        Test.startTest();
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"2324343535","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","Verification":"True","Brand__c":"Wrapzap"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation(); 
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    
    
    public static testMethod void bulkOfflineLeadCreationTestCubico(){
        delete [Select id from Channel_Partner__c];
        
        Test.startTest();
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"2324343535","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","Verification":"True","Brand__c":"Cubico"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation(); 
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    
    public static testMethod void bulkOfflineLeadCreationTest1A(){
        delete [Select id from Channel_Partner__c];
        
        Test.startTest();
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"2324343535","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","Verification":"True","Brand__c":"Doowup"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation(); 
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTest1B(){
        Test.startTest();
        ld1 = [Select id,Email,Phone from Lead limit 1];
        Account acc = TestData_Factory.createAccount(false);
        //acc.email = ld1.Email;
        acc.Phone = ld1.Phone;
        insert acc;
        
        ld1.Status ='Dead Lead';
        ld1.Account__c = acc.Id;
        update ld1;
        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"2324343555","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Dead Lead","Sub_Status__c":"New","verification":"","Brand__c":"HomeLane"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            //req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            //BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":'+ld1.Phone+',"Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"true","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTest2(){
        Test.startTest();
        ld1 = [Select id,Email,Phone from Lead limit 1];
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"2324343555","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Dead Lead","Sub_Status__c":"New","verification":"true","Brand__c":"HomeLane"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343666","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"true","Brand__c":"Doowup"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"true","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTest3(){
        Test.startTest();
        ld1 = [Select id,Email,Phone from Lead limit 1];
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"2324343555","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343666","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTest4(){
        Integration_Setting__c is = new Integration_Setting__c();
        is.Name = 'UDP_Property_Report_URL_API';
        is.End_Point__c = 'ss';
        is.ContentType__c = 'Auth';
        is.Authorization__c = 'Key';
        Insert is;
        Test.startTest();
        ld1 = [Select id,Email,Phone from Lead limit 1];
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkoOfflineAPIcheck@check.com","Phone":"2324343555","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"abc@gmail.ccom","Phone":"2324343666","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"test@gmail.commn","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTest5B(){
        Test.startTest();
        List<Lead> listOfLeads = new List<Lead>();
        listOfLeads = [Select id,Email,Phone from Lead limit 2];
        Account ac = [Select id,phone from Account limit 1];
        for(Lead ld:listOfLeads){
            ld.Account__c = ac.id;
            ld.phone = ac.phone;
        }
        update listOfLeads;
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"'+ac.phone+'","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation(); 
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
   /* public static testMethod void bulkOfflineLeadCreationTest3(){
       
        ld1 = [Select id,Email,Phone from Lead limit 1];
        ld1.Status = 'Dead Lead';
        ld1.Sub_Status__c = 'Dead Lead';
        update ld1;
         Test.startTest();
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"2324343535","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343535","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343536","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTest4(){
        
        ld1 = [Select id,Email,Phone from Lead limit 1];
        List<Lead> listOfLeadsToUpdate = new List<Lead>();
        for(lead ld: [Select id,Email,Phone from Lead]){
            ld.Status = 'Dead Lead';
            ld.Sub_Status__c = 'Dead Lead';
            listOfLeadsToUpdate.add(ld);
        }
        update listOfLeadsToUpdate;
        Test.startTest();
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"2324343535","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343535","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343536","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }*/
    
    public static testMethod void createLeadRecordTest1(){
        Test.startTest();
        try{
            listOfCustomSetting = new List<Bulk_Offline_Lead_Creation_Fields__c>();
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 1', 'LeadSource', 'Picklist', 'Lead Source', True, False,False,false));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 2', 'FirstName', 'Text', 'FirstName', True, False,False,true));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 3', 'LastName', 'Text', 'LastName', True, False,False,true));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 4', 'Email', 'Email', 'Email', True, False,False,true));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 5', 'Phone', 'Phone', 'Phone', True, False,False,true));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 6', 'Lead_Property_Name__c', 'Text', 'Lead Property Name', True, True,False,false));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 7', 'City', 'Text', 'City', True, False,False,false));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 8', 'PostalCode', 'Text', 'Zip/Postal Code', True, False,False,false));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 9', 'HL_Referrer_Phone__c', 'Text', 'HL Referrer Phone', True, True,False,false));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 10', 'Bulk_Upload__c', 'Checkbox', 'Bulk Upload', True, True,False,false));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 11', 'Status', 'Picklist', 'Status', True, False,False,false));
        listOfCustomSetting.add(TestData_Factory.createBulkOfflineLeadCreationFileds('Field 12', 'Sub_Status__c', 'Picklist', 'Sub Status', True, False,False,false));
        insert listOfCustomSetting;
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"2324343535","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Dead Lead","Sub_Status__c":"New"}';
            Map<String,Bulk_Offline_Lead_Creation_Fields__c> mapOfFieldNameAndMappingsRecord = new Map<String,Bulk_Offline_Lead_Creation_Fields__c>();
            System.debug('ListOf Cutom Sett'+listOfCustomSetting);
            for(Bulk_Offline_Lead_Creation_Fields__c bfl :listOfCustomSetting){
               mapOfFieldNameAndMappingsRecord.put(bfl.Field_Api_Name__c,bfl); 
            }
            Account ac=TestData_Factory.createAccount(true);
            Map<String,Object> mapOfLeadFieldsAndValues = new Map<String,Object>();
            mapOfLeadFieldsAndValues = (Map<String,Object>)Json.deserializeUntyped(JSONMsg);
            System.debug('0000000');
            BulkOfflineLeadCreation_Controller.createLeadRecord(mapOfFieldNameAndMappingsRecord,mapOfLeadFieldsAndValues,'INSERT',ac.Id);
            System.debug('11111111');
            BulkOfflineLeadCreation_Controller.createLeadRecord(mapOfFieldNameAndMappingsRecord,mapOfLeadFieldsAndValues,'UPDATE',ac.Id);
            System.debug('22222222');
            BulkOfflineLeadCreation_Controller.createLeadRecord(mapOfFieldNameAndMappingsRecord,mapOfLeadFieldsAndValues,'INSERT',null);
            System.debug('33333333');
        }
        catch(exception e){
            system.debug('exception'+e.getmessage() + 'Line'+e.getLineNumber());
        }
        Test.stopTest();
    }
    public static testMethod void exceptionTest2(){
        Test.startTest();
        try{
            BulkOfflineLeadCreation_Controller.createAccountRecord(null, null);
            BulkOfflineLeadCreation_Controller.createLeadRecord(null, null, null, null);
            
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"2324343555","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Dead Lead","Sub_Status__c":"New"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation(); 
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"","Phone":"","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg = '';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg = '{}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception'+e.getmessage() + 'Line'+e.getLineNumber());
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTest8(){
        
        Integration_Setting__c is = new Integration_Setting__c();
        is.Name = 'UDP_Property_Report_URL_API';
        is.End_Point__c = 'ss';
        is.ContentType__c = 'Auth';
        is.Authorization__c = 'Key';
        Insert is;
        Showroom_User__c sh= new Showroom_User__c();
        sh.Name='abc';
        sh.Email__c='abc@email.com';
        sh.IsActive__c= true;
        sh.Role__c='Tele Caller Agent';
        insert sh;
        Test.startTest();
        ld1 = [Select id,Email,Phone from Lead limit 1];
        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkoOfflineAPIcheck@check.com","Phone":"2324343555","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"abc@gmail.ccom","Phone":"2324343666","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"test@gmail.commn","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTestAcc(){
        Test.startTest();
       Acc1= [select id,Phone from Account limit 1];
        Op1 =[select id ,Customer_Phone_Number__c from Opportunity];
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"1234567891","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343666","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
  public static testMethod void bulkOfflineLeadCreationTestAcc1(){
        Test.startTest();
       Acc2= [select id,Phone from Account limit 1];
        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"1234567892","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"abgshh@gmail.com","Phone":"1234567892","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTestAcc2(){
        Test.startTest();
       acc2= [select id,Phone from Account limit 1];
        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"1234567892","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"True","Brand__c":"HomeLane"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343666","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
  public static testMethod void bulkOfflineLeadCreationTestAcc3(){
       Test.startTest();
      Account acc3 = new Account();
      acc3.Name='test acc3';
      acc3.Phone ='8793867890';
      insert acc3;
       
       
        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"8793867890","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"True","Brand__c":"HomeLane"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343666","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTestAcc4(){
       Test.startTest();
      Account acc3 = new Account();
      acc3.Name='test acc3';
      acc3.Phone ='8793867890';
      insert acc3;
       
       
        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"8793867890","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"False","Brand__c":"HomeLane"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343666","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTestAcc5(){
       Test.startTest();
      Account acc3 = new Account();
      acc3.Name='test acc3';
      acc3.Phone ='8793867891';
      insert acc3;
        Showroom_User__c sh = new Showroom_User__c();
        sh.name='TestShow';
        sh.Email__c='email@gmail.com';
        sh.IsActive__c= true;
        insert sh;
        Lead ld = new lead();
        ld.LastName='test ld';
        ld.leadSource='Direct';
        ld.Phone= '8793867891';
        ld.Account__c=acc3.id;
        ld.City='Bengaluru';
        ld.Sales_Manager__c = sh.Id;
        ld.Assigned_to_Resi_ASM__c = True;
        insert ld;
        
        
        
       
       
        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"8793867891","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"False","Brand__c":"HomeLane"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343666","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTestAcc6(){
       Test.startTest();
      Account acc3 = new Account();
      acc3.Name='test acc3';
      acc3.Phone ='8793867891';
      insert acc3;
        Opportunity op=TestData_Factory.createOpportunity(acc3.id, true);
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"8793867891","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"False","Brand__c":"HomeLane"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343666","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTestAcc7(){
       Test.startTest();
      Account acc3 = new Account();
      acc3.Name='test acc3';
      acc3.Phone ='8793867891';
      insert acc3;
        Showroom_User__c sh = new Showroom_User__c();
        sh.name='TestShow';
        sh.Email__c='email@gmail.com';
        sh.IsActive__c= true;
        sh.Role__c='Tele Caller Agent';
        insert sh;
        Lead ld = new lead();
        ld.LastName='test ld';
        ld.leadSource='Direct';
        ld.Phone= '8793867891';
        ld.Account__c=acc3.id;
        ld.City='Bengaluru';
        
        ld.Tele_caller__c = sh.Id;
        ld.Assigned_To_TLC__c = True;
        insert ld;
        lead ldUpdate = [select id,Status,Sub_Status__c,Sales_Manager__c,Assigned_to_Resi_ASM__c ,Tele_caller__c,Assigned_To_TLC__c,Sales_Manager_Email__c from lead where id=:ld.id];
        ldUpdate.Status ='Dead Lead';
        ldUpdate.Sub_Status__c ='Job Seeker';
        update ldUpdate;
       // Leadhistory lh = new Leadhistory(LeadId=ld.id);
        //lh.NewValue ='Dead lead';
        
        
           //insert lh;
        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"8793867891","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"False","Brand__c":"Doowup"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343666","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"Doowup"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
     public static testMethod void bulkOfflineLeadCreationTestAcc9(){
       Test.startTest();
      Account acc3 = new Account();
      acc3.Name='test acc4';
      acc3.Phone ='8793867800';
      insert acc3;
        Showroom_User__c sh = new Showroom_User__c();
        sh.name='TestShow';
        sh.Email__c='email@gmail.com';
        sh.IsActive__c= true;
        sh.Role__c='Tele Caller Agent';
        insert sh;
        Lead ld = new lead();
        ld.LastName='test ld';
        ld.leadSource='Direct';
        ld.Phone= '8793867800';
        ld.Account__c=acc3.id;
        ld.City='Bengaluru';
        
        ld.Tele_caller__c = sh.Id;
        ld.Assigned_To_TLC__c = True;
        insert ld;
         Lead lds = new lead();
        lds.LastName='test ld';
        lds.leadSource='Direct';
        lds.Phone= '8793867800';
        lds.Account__c=acc3.id;
        lds.City='Bengaluru';
        
        lds.Tele_caller__c = sh.Id;
        lds.Assigned_To_TLC__c = True;
        insert lds;

        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"8793867800","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"False","Brand__c":"HomeLane"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343666","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
   /*public static testMethod void bulkOfflineLeadCreationTestAcc10(){
       
      Account acc3 = new Account();
      acc3.Name='test acc4';
      acc3.Phone ='8793867800';
      insert acc3;
        Showroom_User__c sh = new Showroom_User__c();
        sh.name='TestShow';
        sh.Email__c='email@gmail.com';
        sh.IsActive__c= true;
        sh.Role__c='Iron man';
        insert sh;
        Lead ld = new lead();
        ld.LastName='test ld';
        ld.leadSource='Direct';
        ld.Phone= '8793867800';
        ld.Account__c=acc3.id;
        ld.City='Bengaluru';
        
        
        insert ld;
         Test.startTest();
         lead ldUpdate =  [select id,Status,Sub_Status__c,Sales_Manager__c,Assigned_to_Resi_ASM__c ,Tele_caller__c,Assigned_To_TLC__c,Sales_Manager_Email__c from lead where id=:ld.id];
        ldUpdate.status=  'Dead Lead';
        ld.Sales_Manager__c = sh.Id;
        ld.Assigned_to_Resi_ASM__c = True;
        //ld.Sales_Manager_Email__c =sh.Email__c;
        ldUpdate.Sub_Status__c ='Job Seeker';
        update ldUpdate;
        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"8793867800","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"False","Brand__c":"HomeLane"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343666","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }*/
    /*public static testMethod void bulkOfflineLeadCreationTestAccdoowup10(){
       
      Account acc3 = new Account();
      acc3.Name='test acc4';
      acc3.Phone ='8793867800';
      insert acc3;
        Showroom_User__c sh = new Showroom_User__c();
        sh.name='TestShow';
        sh.Email__c='email@gmail.com';
        sh.IsActive__c= true;
        sh.Role__c='Product Consultant';
        insert sh;
        Lead ld = new lead();
        ld.LastName='test ld';
        ld.leadSource='Direct';
        ld.Phone= '8793867800';
        ld.Account__c=acc3.id;
        ld.City='Bengaluru';
        ld.Brand__c='Doowup';
        
        
        insert ld;
         Test.startTest();
         lead ldUpdate = [select id,Status,Sub_Status__c,Sales_Manager__c,Assigned_to_Resi_ASM__c ,Tele_caller__c,Assigned_To_TLC__c,Sales_Manager_Email__c from lead where id=:ld.id];
        ldUpdate.status=  'Dead Lead';
        ld.Sales_Manager__c = sh.Id;
        ld.Assigned_to_Resi_ASM__c = True;
        //ld.Sales_Manager_Email__c =sh.Email__c;
        ldUpdate.Sub_Status__c ='Job Seeker';
        update ldUpdate;
        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"8793867800","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"False","Brand__c":"Doowup"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343666","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
            
            JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"'+ld1.Email+'","Phone":"2324343777","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"false","Brand__c":"HomeLane"}';
            req.requestBody = Blob.valueof(JSONMsg);
            System.debug('Leaddds'+[Select Id, Status, phone from Lead]);
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }*/
    /*public static testMethod void bulkOfflineLeadCreationTestAcc11(){
       
      Account acc3 = new Account();
      acc3.Name='test acc4';
      acc3.Phone ='8793867800';
      insert acc3;
        Showroom_User__c sh = new Showroom_User__c();
        sh.name='TestShow';
        sh.Email__c='email@gmail.com';
        sh.IsActive__c= False;
        sh.Role__c='Iron man';
        insert sh;
        Lead ld = new lead();
        ld.LastName='test ld';
        ld.leadSource='Direct';
        ld.Phone= '8793867800';
        ld.Account__c=acc3.id;
        ld.City='Bengaluru';
        
        
        insert ld;
         Test.startTest();
         lead ldUpdate = [select id,Status,Sub_Status__c,Sales_Manager__c,Assigned_to_Resi_ASM__c from lead where id=:ld.id];
        ldUpdate.status=  'Dead Lead';
        ld.Sales_Manager__c = sh.Id;
        ld.Assigned_to_Resi_ASM__c = True;
        //ld.Sales_Manager_Email__c =sh.Email__c;
        ldUpdate.Sub_Status__c ='Job Seeker';
        update ldUpdate;
        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"8793867800","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"False","Brand__c":"HomeLane"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }*/
    public static testMethod void bulkOfflineLeadCreationTestAcc12(){
       Test.startTest();
      Account acc3 = new Account();
      acc3.Name='test acc4';
      acc3.Phone ='8793867800';
      insert acc3;
        Showroom_User__c sh = new Showroom_User__c();
        sh.name='TestShow';
        sh.Email__c='email@gmail.com';
        sh.IsActive__c= false;
        sh.Role__c='Tele Caller Agent';
        insert sh;
        Lead ld = new lead();
        ld.LastName='test ld';
        ld.leadSource='Direct';
        ld.Phone= '8793867800';
        ld.Account__c=acc3.id;
        ld.City='Bengaluru';
        
        ld.Tele_caller__c = sh.Id;
        ld.Assigned_To_TLC__c = True;
        insert ld;
         Lead lds = new lead();
        lds.LastName='test ld';
        lds.leadSource='Direct';
        lds.Phone= '8793867800';
        lds.Account__c=acc3.id;
        lds.City='Bengaluru';
        
        lds.Tele_caller__c = sh.Id;
        lds.Assigned_To_TLC__c = True;
        insert lds;

        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"8793867800","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"False","Brand__c":"Doowup"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTestAcc13(){
       Test.startTest();
      Account acc3 = new Account();
      acc3.Name='test acc4';
      acc3.Phone ='8793867800';
      insert acc3;
        Showroom_User__c sh = new Showroom_User__c();
        sh.name='TestShow';
        sh.Email__c='email@gmail.com';
        sh.IsActive__c= false;
        sh.Role__c='Tele Caller Agent';
        insert sh;
        Lead ld = new lead();
        ld.LastName='test ld';
        ld.leadSource='Direct';
        ld.Phone= '8793867800';
        ld.Account__c=acc3.id;
        ld.City='Bengaluru';
        ld.Brand__c='Doowup';
        ld.Tele_caller__c = sh.Id;
        ld.Assigned_To_TLC__c = True;
        insert ld;
         Lead lds = new lead();
        lds.LastName='test ld';
        lds.leadSource='Direct';
        lds.Phone= '8793867800';
        lds.Account__c=acc3.id;
        lds.City='Bengaluru';
        lds.Brand__c='Doowup';
        
        lds.Tele_caller__c = sh.Id;
        lds.Assigned_To_TLC__c = True;
       
        insert lds;
        list<lead> ldlist = new list<lead>();
        
        List<lead> leadList = [select id,Status,Sub_Status__c,Sales_Manager__c,Assigned_to_Resi_ASM__c ,Tele_caller__c,Assigned_To_TLC__c,Telecaller_Email__c,Sales_Manager_Email__c from lead ];
        for(lead ld1:leadList){
            ld1.Status ='Dead Lead';
            ld1.Sub_Status__c='Job Seeker';
            ldlist.add(ld1);
        }
        update ldlist;
        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"8793867800","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"False","Brand__c":"Doowup"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTestAcc14(){
       Test.startTest();
      Account acc3 = new Account();
      acc3.Name='test acc4';
      acc3.Phone ='8793867800';
      insert acc3;
        Showroom_User__c sh = new Showroom_User__c();
        sh.name='TestShow';
        sh.Email__c='email@gmail.com';
        sh.IsActive__c= True;
        sh.Role__c='Tele Caller Agent';
        insert sh;
        Lead ld = new lead();
        ld.LastName='test ld';
        ld.leadSource='Direct';
        ld.Phone= '8793867800';
        ld.Account__c=acc3.id;
        ld.City='Bengaluru';
        ld.Brand__c='Doowup';
        ld.Tele_caller__c = sh.Id;
        ld.Assigned_To_TLC__c = True;
        insert ld;
         Lead lds = new lead();
        lds.LastName='test ld';
        lds.leadSource='Direct';
        lds.Phone= '8793867800';
        lds.Account__c=acc3.id;
        lds.City='Bengaluru';
        lds.Brand__c='Doowup';
        
        lds.Tele_caller__c = sh.Id;
        lds.Assigned_To_TLC__c = True;
       
        insert lds;
        list<lead> ldlist = new list<lead>();
        
        List<lead> leadList = [select id,Status,Sub_Status__c,Sales_Manager__c,Assigned_to_Resi_ASM__c ,Tele_caller__c,Assigned_To_TLC__c,Telecaller_Email__c,Sales_Manager_Email__c from lead ];
        for(lead ld1:leadList){
            ld1.Status ='Dead Lead';
            ld1.Sub_Status__c='Job Seeker';
            ldlist.add(ld1);
        }
        update ldlist;
        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"8793867800","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"False","Brand__c":"Doowup"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
    public static testMethod void bulkOfflineLeadCreationTestAcc15(){
       Test.startTest();
      Account acc3 = new Account();
      acc3.Name='test acc4';
      acc3.Phone ='8793867800';
      insert acc3;
        Showroom_User__c sh = new Showroom_User__c();
        sh.name='TestShow';
        sh.Email__c='email@gmail.com';
        sh.IsActive__c= True;
        sh.Role__c='Tele Caller Agent';
        insert sh;
        Lead ld = new lead();
        ld.LastName='test ld';
        ld.leadSource='Direct';
        ld.Phone= '8793867800';
        ld.Account__c=acc3.id;
        ld.City='Bengaluru';
        ld.Brand__c='Doowup';
        ld.Tele_caller__c = sh.Id;
        ld.Assigned_To_TLC__c = True;
        insert ld;
         Lead lds = new lead();
        lds.LastName='test ld';
        lds.leadSource='Direct';
        lds.Phone= '8793867800';
        lds.Account__c=acc3.id;
        lds.City='Bengaluru';
        lds.Brand__c='Doowup';
        
        lds.Tele_caller__c = sh.Id;
        lds.Assigned_To_TLC__c = True;
       
        insert lds;
        list<lead> ldlist = new list<lead>();
        
        List<lead> leadList = [select id,Status,Sub_Status__c,Sales_Manager__c,Assigned_to_Resi_ASM__c ,Tele_caller__c,Assigned_To_TLC__c,Telecaller_Email__c,Sales_Manager_Email__c from lead ];
        for(lead ld1:leadList){
            ld1.Status ='Dead Lead';
            ld1.Sub_Status__c='No Immediate Requirement';
            ldlist.add(ld1);
        }
        update ldlist;
        
        try{
            String JSONMsg='{"LeadSource":"Broker/Channel Partner","FirstName":"bulkOffline","LastName":"APIcheck","Email":"bulkOfflineAPIcheck@check.com","Phone":"8793867800","Lead_Property_Name__c":"someProperty","City":"Bengaluru","PostalCode":"560056","HL_Referrer_Phone__c":"9840823833","Bulk_Upload__c":true,"Status":"Fresh Lead","Sub_Status__c":"New","verification":"False","Brand__c":"Doowup"}';
            RestRequest req = new RestRequest(); // Build the REST Request for testing
            RestResponse res = new RestResponse(); // Build the REST Response for testing
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
            req.requestURI = '/services/apexrest/BulkOfflineLeadCreationAPI';
            req.httpMethod = 'POST';        // Perform a POST
            req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
            RestContext.request = req;
            RestContext.response = res;
            BulkOfflineLeadCreation_Controller.bulkOfflineLeadCreation();  
            
            
            
        }
        catch(exception e){
            system.debug('exception');
        }
        Test.stopTest();
    }
}