@IsTest
private class GetoppdatawithCID_Test{
    @isTest static void getopprec() {
          RestRequest request = new RestRequest();
          request.addParameter('Oppemail','Che-TC-2000001610');// Che-TC-2000001610
          request.requestUri='/setup/build/getopprec/Che-TC-2000001610';
          request.httpMethod='GET';
          RestContext.request = request;
          list<GetoppdatawithCID.FinalWrapper>ledList = GetoppdatawithCID.getopprec();      
   }  
}