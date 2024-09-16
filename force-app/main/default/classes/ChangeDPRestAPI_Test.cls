@isTest(SeeAllData = TRUE)
private class ChangeDPRestAPI_Test{
    
    static testMethod void checkCallout(){
        Test.startTest();
        
      list<string> dpoldemail = new list<string>();
          dpoldemail.add('aditya.saini@kvpcorp.com');
          list<string> dpnewemail = new list<string>();
          dpnewemail.add('aditya.saini@kvpcorp.com');
          list<string> cusemail = new list<string>();
          cusemail.add('aditya.saini@kvpcorp.com');
        
      // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
         // Call the method that invokes a callout
          ChangeDPRestAPI.handleDPchange(dpoldemail , dpnewemail , cusemail );
          
        
        Test.stopTest();
    }
    static testMethod void checkCallout2(){
        Test.startTest();
        
      list<string> dpoldemail = new list<string>();
          dpoldemail.add('aditya.saini@kvpcorp.com');
          list<string> dpnewemail = new list<string>();
          dpnewemail.add('aditya.saini@kvpcorp.com');
          list<string> cusemail = new list<string>();
          cusemail.add('aditya.saini@kvpcorp.com');
        
         Map<String,Object> mapResponse = (Map<String, Object>)JSON.deserializeUntyped('{"status":"error","message":"Given Designer kishore.p@homelane.com do not have any project "}');
          //ChangeDPRestAPI.SendEmailToManager(dpoldemail[0], mapResponse );

        Test.stopTest();
    }
   }