@isTest(SeeAllData = TRUE)
private class ChangecustumeremailAPI_Test{
    
    static testMethod void checkCallout(){
        Test.startTest();
        
      list<string> oldcustomeremail = new list<string>();
          oldcustomeremail.add('aditya.saini@kvpcorp.com');
          list<string> newcustomeremail= new list<string>();
          newcustomeremail.add('aditya.saini@kvpcorp.com');
        
      // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
         // Call the method that invokes a callout
          Changecustomeremail.customeremailChange(newcustomeremail, oldcustomeremail);

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
          Changecustomeremail.SendEmailToManager(dpoldemail[0],dpnewemail[0], mapResponse );

        Test.stopTest();
    }
   }