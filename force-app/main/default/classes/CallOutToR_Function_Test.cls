@isTest
Public class CallOutToR_Function_Test implements HttpCalloutMock{
    

   Public static String masterID;
   Public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        //String Massterdid = getid();
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
         response.setBody('[{"matchedpropID":"'+masterID+'","matchedpropName":"sai flight test","matchScore":-0.75}]');
        response.setStatusCode(200);
        return response; 
    }

    public static testMethod void TestSuccess() {
     
     Integration_Setting__c intSetting = new Integration_Setting__c();
     intSetting.Name = 'R API';
     intSetting.End_Point__c = 'http://13.228.168.23:3000/search';
     insert intSetting;
     
      Map<String,String> mapRecordType = new Map<String,String>();
      Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
      for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
        mapRecordType.put(reType.getDeveloperName(),reType.getRecordTypeId());
      }
     

      
 

      Master__c m = new Master__c();
      m.isActive__c = true;
      m.Type__c = 'Property';
      m.Name = 'Brigade Palmsprings';
      m.Full_Name__c = 'Brigade Palmsprings';
      m.Total_Won_Opportunity__c = 6;
      m.Avg_Opportunites_Month__c = 20;
      m.Location__latitude__s = 12.971100;
      m.Location__longitude__s = 77.640920;
      m.RecordTypeId = mapRecordType.get('Property');
      m.PlaceId__c = 'qwyriophdiepo';
      insert m;
      
      
        Lead l = new Lead(); 
        l.FirstName = 'Hamsa';
        l.LastName = 'Raj';
        l.Email = 'HamsaRaj@gmail.com';
        l.Phone = '9000000009';
        l.City = 'Bengaluru';
        l.LeadSource = 'Google Ad';
        l.Status = 'Fresh Lead';
        l.property__c = m.id;
        l.Sub_Status__c = 'New';
        insert l;
      System.debug('lead OPropertu'+l.property__c);
      Master__c m1 = new Master__c();
     
      m1.isActive__c = true;
      m1.Type__c = 'Property';
      m1.Name = 'Brigade ';
      m1.Full_Name__c = 'Brigade Palmsprings Property';
      m1.Total_Won_Opportunity__c = 6;
      m1.Avg_Opportunites_Month__c = 8;
      m1.Location__latitude__s = 12.979900;
      m1.Location__longitude__s = 77.640920;
      m1.RecordTypeId = mapRecordType.get('Property');
      m1.PlaceId__c = 'qwyriophdiepo';
      insert m1;
      
      masterID = m1.id;
        System.debug('Master Id'+m1.id+ '  test'+masterID );
      
      test.startTest();
      Test.setMock(HttpCalloutMock.class, new CallOutToR_Function_Test()); 
       CallOutToR_Function.callFunction(l.id);
        test.StopTest();
    }
 }