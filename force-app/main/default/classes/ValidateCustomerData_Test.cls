@isTest
private class ValidateCustomerData_Test{
    static{
    }
    static testMethod void testDoGet(){
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Person Account'];
        Account personAcc=new Account(LastName='Anand',recordTypeId=recType.Id,PersonEmail='Anand@gmail.com',phone='0801231541');
        insert personAcc;
        
        Opportunity opp=new Opportunity(Name='Vijay',AccountId=personAcc.Id,stageName='Initial Quote Sent',
                                        closeDate=system.today());
        insert opp;
       
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.params.put('email', 'Anand@gmail.com');
      //  req.params.put('email', '');


        req.requestURI = 'https://cs9.salesforce.com/services/apexrest/validateCustomerData/opportunity';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        //List<validateCustomerData.customerdetails> results = validateCustomerData.getAccountdetails();
        validateCustomerData.getAccountdetails();  
    }
}