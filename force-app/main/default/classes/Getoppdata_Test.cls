@IsTest
private class Getoppdata_Test{
    @isTest static void getopprec() {
          RestRequest request = new RestRequest();
          request.addParameter('Oppemail','cameron.j@homelane.com');
          request.requestUri='/setup/build/getopprec/cameron.j@homelane.com';
          request.httpMethod='GET';
          RestContext.request = request;
          //List<Lead> leadList =Getleadapi.getLeaddata();
          list<Getoppdata.FinalWrapper>ledList = Getoppdata.getopprec();      
   }  
}