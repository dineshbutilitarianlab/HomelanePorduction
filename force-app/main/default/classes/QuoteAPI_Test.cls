@isTest(SeeAllData = TRUE)
private class QuoteAPI_Test{
    
    static testMethod void checkCallout(){
        Test.startTest();
        
      
        
      // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
         // Call the method that invokes a callout
      //  String res = AWSCallout.getS3URL('oppNum'); 
         String res = AWSCallout.getS3URL('0000'); 
        Test.stopTest();
    }

   /* static testMethod void checkQuote(){
       
        Test.startTest(); 
        
     //   SC_MI_TestHandler.insertIsTriggerExecute();
      //  SC_MI_TestHandler.insertCustomDate();
        
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Person Account'];
        Account personAcc=new Account(LastName='prathap',recordTypeId=recType.Id,PersonEmail='prathap@gmail.com',phone='045612541');
        insert personAcc;
        
        Opportunity opp=new Opportunity(Name='prathik',AccountId=personAcc.Id,stageName='Quote Required',
                                        closeDate=system.today(),Amount=5000);
        insert opp;

        List<Opportunity>  OpportunityList = [select id,name,AutoNumber_For_Quote_Creation__c from Opportunity where id =:opp.id ];
       // Integer oppNum=Integer.valueOf(OpportunityList[0].AutoNumber_For_Quote_Creation__c);
       String oppNum=OpportunityList[0].AutoNumber_For_Quote_Creation__c;
        System.debug(oppNum); 
        Product2 prod = new Product2(Name = 'applinces', Family = 'Hardware');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
       PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 5000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 5000, IsActive = true);
        insert customPrice;
        
        Project_Name__c proj=new Project_Name__c();
        proj.Name='jp builders';
        proj.Start_Date__c=system.today();
        insert proj;
        string projid=proj.id;
        
        Quote quoteId=new Quote();
        quoteId.Name='oppquote';
        quoteId.projectId__c=proj.id;
        quoteId.OpportunityId=opp.id;
        insert quoteId;
        system.debug('**********quoteId*************'+quoteId); 
        
        List<Opportunity> opptyList = new List<Opportunity>([select id,name,AutoNumber_For_Quote_Creation__c from Opportunity limit 1 ]);
        String opptynum = opptyList[0].AutoNumber_For_Quote_Creation__c;
       
       // String JSONMsg='{"name": "test","opptynumber": "0280","projectId":"1466497460896","priceVersion": "0802-Bengaluru","customerEmail": "derek@homelane.comx","version": 10,"rooms": [{"id": "56017cfc9de1cee85601e692","rooms": [{"name": "Kitchen_","roomType": "56017cfc9de1cee85601e692","roomTypeName": "Kitchen","woodWorks": [{"productName": "Gola Profile","productId": "560197b79de1cee85601e7a9","internalMaterial": "L Gola for Hinged Shutters / Top Drawers - Width in Running MM","width": "","height": "","area": 0,"price": 0,"qty": 100,"unit": null,"wall": null,"price": 1000,"qty": 100}],"accessories": [],"applinces": [{"category": "Sinks & Taps","categoryId": "55f11ae10526b7c67cbbc60c","applianceType": "Tap","applianceTypeId": "55f11b120526b7c67cbbc6e1","applianceProductType": "SINK MOUNTED","applianceProductTypeId": "55f11b260526b7c67cbbc6e8","appliance": "Florentine - Single Inlet Single Lever Swinging Spout: Sink Mounted","applianceId": "55f11b3b0526b7c67cbbc710","quantity": "1","price": 5000,"unit": "no.s","amount": 5000,"code": "FLR_5357ND"}],"hds": []},{"name": "Kitchen_2","roomType": "56017cfc9de1cee85601e692","roomTypeName": "Kitchen","woodWorks": [],"accessories": [],"applinces": [],"hds": []}]}],"city": "bengaluru","typeOfWork": ["Civil Work", "Electrical Work", "Plumbing", "Others"],"otherDetails": {"discount": 0},"versions": null,"comparison": [],"codeValidity": "1472541241362","designerEmail": "tanuj@homelane.com","basic": {},"premium": {},"summary":{"total": 1074737,"roomDetails": [{"roomType": "Kitchen","name": "Kitchen_","wwPrice": 3586,"wwTax": 605,"wwTotal": 4191,"accPrice": 0,"accTax": 0,"accTotal": 0,"appPrice": 0,"appTax": 0,"appTotal": 0,"hdsPrice": 1014928,"roomTotal": 1019119},{"roomType": "Utility","name": "Utility_","wwPrice": 46732,"wwTax": 7886,"wwTotal": 54618,"accPrice": 0,"accTax": 0,"accTotal": 0,"appPrice": 0,"appTax": 0,"appTotal": 0,"hdsPrice": 0,"roomTotal": 54618}],"otherServices": [{"price": 1000,"selectedWorkTypeIdx": "0","workTextValue": "civil"}],"discount": 10}}';
        String JSONMsg='{"name": "new project","projectId": "14178","priceVersion": "0802-Bengaluru","customerEmail": "roshi.rai@kvpcorp.com","opptynumber": "14178","designerEmail": "kvpcorp4@gmail.com","version": 7,"summary":{"total": 1074737,"roomDetails": [{"roomType": "Kitchen","name": "Kitchen_","wwPrice": 3586,"wwTax": 605,"wwTotal": 4191,"accPrice": 0,"accTax": 0,"accTotal": 0,"appPrice": 0,"appTax": 0,"appTotal": 0,"hdsPrice": 1014928,"roomTotal": 1019119}],"otherServices": [{"price": 1000,"selectedWorkTypeIdx": "0","workTextValue": "civil"}],"discount": 10}}';
       
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
       // req.addHeader('Content-Type', 'application/json');
        
        req.requestURI = '/services/apexrest/QuoteAPI';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST  
                   
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerate());
      //  Quote quoteRec= QuoteAPI.createQuote('applinces','1466497460896','0802-Bengaluru',10,OpportunityList[0].id,customPrice.Pricebook2Id );
      //  system.debug('**********quoteRec********'+quoteRec);
        
       // QuoteAPI.QuoteAPI();
       // QuoteAPI.createQuote('applinces','1466497460896','0802-Bengaluru',10,OpportunityList[0].id,customPrice.Pricebook2Id );
       // QuoteAPI.createQuoteLineItem(prod.id,customPrice.id,quoteId.id,'item',5000,100,95,89,36);
                  
      //  QuoteAPI.priceTotalSummation(5000,5000);
        
        
         
        Test.stopTest();
    }
    */
     static testMethod void checkQuote1(){
       
        Test.startTest(); 
        
     //   SC_MI_TestHandler.insertIsTriggerExecute();
      //  SC_MI_TestHandler.insertCustomDate();
        
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Person Account'];
        Account personAcc=new Account(LastName='prathap',recordTypeId=recType.Id,PersonEmail='prathap66@gmail.com',phone='0456125413');
        insert personAcc;
        
       Opportunity opp=new Opportunity(Name='prathik',AccountId=personAcc.Id,stageName='Quote Required',
                                        closeDate=system.today(),Amount=5000);
        insert opp;

        List<Opportunity>  OpportunityList = [select id,name,AutoNumber_For_Quote_Creation__c from Opportunity where id =:opp.id ];
       // Integer oppNum=Integer.valueOf(OpportunityList[0].AutoNumber_For_Quote_Creation__c);
       String oppNum=OpportunityList[0].AutoNumber_For_Quote_Creation__c;
        System.debug(oppNum); 
        Product2 prod = new Product2(Name = 'applinces', Family = 'Hardware');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
       PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 5000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 5000, IsActive = true);
        insert customPrice;
        
        Project_Name__c proj=new Project_Name__c();
        proj.Name='jp builders';
        proj.Start_Date__c=system.today();
        insert proj;
        string projid=proj.id;
        
        Quote quoteId=new Quote();
        quoteId.Name='oppquote';
        quoteId.projectId__c=proj.id;
        quoteId.OpportunityId=opp.id;
        insert quoteId;
        system.debug('**********quoteId*************'+quoteId);
        
       // List<Opportunity> opptyList = new List<Opportunity>([select id,name,AutoNumber_For_Quote_Creation__c from Opportunity limit 1 ]);
        //String opptynum = opptyList[0].AutoNumber_For_Quote_Creation__c; 
        //system.debug(' *** opptynum  '+opptynum );
       
       // String JSONMsg='{"name": "test","opptynumber": "0280","projectId":"1466497460896","priceVersion": "0802-Bengaluru","customerEmail": "derek@homelane.comx","version": 10,"rooms": [{"id": "56017cfc9de1cee85601e692","rooms": [{"name": "Kitchen_","roomType": "56017cfc9de1cee85601e692","roomTypeName": "Kitchen","woodWorks": [{"productName": "Gola Profile","productId": "560197b79de1cee85601e7a9","internalMaterial": "L Gola for Hinged Shutters / Top Drawers - Width in Running MM","width": "","height": "","area": 0,"price": 0,"qty": 100,"unit": null,"wall": null,"price": 1000,"qty": 100}],"accessories": [],"applinces": [{"category": "Sinks & Taps","categoryId": "55f11ae10526b7c67cbbc60c","applianceType": "Tap","applianceTypeId": "55f11b120526b7c67cbbc6e1","applianceProductType": "SINK MOUNTED","applianceProductTypeId": "55f11b260526b7c67cbbc6e8","appliance": "Florentine - Single Inlet Single Lever Swinging Spout: Sink Mounted","applianceId": "55f11b3b0526b7c67cbbc710","quantity": "1","price": 5000,"unit": "no.s","amount": 5000,"code": "FLR_5357ND"}],"hds": []},{"name": "Kitchen_2","roomType": "56017cfc9de1cee85601e692","roomTypeName": "Kitchen","woodWorks": [],"accessories": [],"applinces": [],"hds": []}]}],"city": "bengaluru","typeOfWork": ["Civil Work", "Electrical Work", "Plumbing", "Others"],"otherDetails": {"discount": 0},"versions": null,"comparison": [],"codeValidity": "1472541241362","designerEmail": "tanuj@homelane.com","basic": {},"premium": {},"summary":{"total": 1074737,"roomDetails": [{"roomType": "Kitchen","name": "Kitchen_","wwPrice": 3586,"wwTax": 605,"wwTotal": 4191,"accPrice": 0,"accTax": 0,"accTotal": 0,"appPrice": 0,"appTax": 0,"appTotal": 0,"hdsPrice": 1014928,"roomTotal": 1019119},{"roomType": "Utility","name": "Utility_","wwPrice": 46732,"wwTax": 7886,"wwTotal": 54618,"accPrice": 0,"accTax": 0,"accTotal": 0,"appPrice": 0,"appTax": 0,"appTotal": 0,"hdsPrice": 0,"roomTotal": 54618}],"otherServices": [{"price": 1000,"selectedWorkTypeIdx": "0","workTextValue": "civil"}],"discount": 10}}';
        String JSONMsg='{"name": "new project","projectId": "14178","priceVersion": "0802-Bengaluru","customerEmail": "roshi.rai@kvpcorp.com","opptynumber": "14178","designerEmail": "kvpcorp4@gmail.com","version": 7,"summary":{"total": 1074737,"roomDetails": [{"roomType": "Kitchen","name": "Venkat__KVP","wwPrice": 3586,"wwTax": 605,"wwTotal": 4191,"accPrice": 0,"accTax": 0,"accTotal": 0,"appPrice": 0,"appTax": 0,"appTotal": 0,"hdsPrice": 1014928,"roomTotal": 1019119}],"otherServices": [{"price": 1000,"selectedWorkTypeIdx": "0","workTextValue": "civil"}],"discount": 10}}';
       
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
       // req.addHeader('Content-Type', 'application/json');
        
        req.requestURI = '/services/apexrest/QuoteAPI';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST  
                   
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerate());
      //  Quote quoteRec= QuoteAPI.createQuote('applinces','1466497460896','0802-Bengaluru',10,OpportunityList[0].id,customPrice.Pricebook2Id );
      //  system.debug('**********quoteRec********'+quoteRec);
        QuoteAPI kk = new QuoteAPI();
        kk.dummy();
       // QuoteAPI.SendEmailToManager('Test Class error');
       // QuoteAPI.createQuote('applinces','1466497460896','0802-Bengaluru',10,OpportunityList[0].id,customPrice.Pricebook2Id );
       // QuoteAPI.createQuoteLineItem(prod.id,customPrice.id,quoteId.id,'item',5000,100,95,89,36);
                  
      //  QuoteAPI.priceTotalSummation(5000,5000);
        
        
         
        Test.stopTest();
    }
}