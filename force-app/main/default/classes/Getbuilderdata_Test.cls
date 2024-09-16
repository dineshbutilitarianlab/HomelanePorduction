@IsTest
private class Getbuilderdata_Test{
    @isTest static void getLeaddata() {
          RestRequest request = new RestRequest();
          request.requestUri='/setup/build/Getbuilderdata';
          request.httpMethod='GET';
          RestContext.request = request;
          list<Getbuilderdata.FinalWrapper>builList = Getbuilderdata.getbuilderrec();
          
   }
   
}