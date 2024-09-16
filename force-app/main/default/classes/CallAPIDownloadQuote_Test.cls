@isTest(SeeAllData = TRUE)
private class CallAPIDownloadQuote_Test{
    
    static testMethod void checkCallout(){
        
        
          RecordType recType=[SELECT Id FROM RecordType WHERE Name='Person Account'];
        Account personAcc=new Account(LastName='prathap',recordTypeId=recType.Id,PersonEmail='prathap55@gmail.com',phone='04561254155');
        insert personAcc;
        
        Opportunity opp=new Opportunity(Name='prathik',AccountId=personAcc.Id,stageName='Quote Required',
                                        closeDate=system.today(),Amount=5000);
        insert opp;
        
        EmailMessage emailMsg=new EmailMessage();
        emailMsg.Subject='Initial Quote Confirmation';
        emailMsg.RelatedToId=opp.Id;
        insert emailMsg;
       Test.startTest();
      // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
         // Call the method that invokes a callout
      //  String res = AWSCallout.getS3URL('oppNum'); 
         String res = AWSCallout.getS3URL('0000'); 
         apexpages.currentpage().getparameters().put('elementId' , 'https://phoenixartifacts-dev.s3.amazonaws.com/customers/15702/quotations/15702-initial-quote-draft-7.pdf?ppp');
         
       //  apexpages.currentpage().getparameters().put('elementId','https://hmlqa--hlqa--c.cs6.visual.force.com/apex/CallApiDownloadQuote?elementId=');
         CallApiDownloadQuote calApiDloadQuote=new CallApiDownloadQuote();
         calApiDloadQuote.CallApiDownloadAction();
        Test.stopTest();
    }
}