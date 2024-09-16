@IsTest
private class Getleadapi_Test{
    @isTest static void getLeaddata() {
          RestRequest request = new RestRequest();
          request.addParameter('SobjectApiName','Lead');
          request.requestUri='/setup/build/getLeaddata/Lead';
          request.httpMethod='GET';
          RestContext.request = request;
          //List<Lead> leadList =Getleadapi.getLeaddata();
          //Modified code to cover the the code to reduce the numbers of fields
          list<Getleadapi.FinalWrapper>ledList = Getleadapi.getLeaddata();
          
          
   }
   
}