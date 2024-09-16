@isTest
public class WhatsappUpdateNPS_Test{

  @isTest 
  static void testSucess() 
  {
       Account personAcc=new Account(LastName='John',PersonEmail='Johnsdas@gmail.com',Customer_ID__c='Ben-d-2000027174');
        insert personAcc;
        
         Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),amount=200,
                                                Opportunity_Stage__c ='Appointment Successful'
                                        );
                                                insert perOpp;
                                                
        Whatsapp_Message__c whats = new  Whatsapp_Message__c(
                                                    Name='WA - NPS Request Sent',Opportunity__c=perOpp.id
                                    );       
        insert whats;
        
        test.starttest();
            String json = '{"UniqueOpporunityID":"Ben-d-2000027174","NPS":"8","CustomerResponse":"Good"}';
            
            RestRequest req = new RestRequest();
            req.addHeader('Content-Type','application/json');
            req.RequestURI = '/services/apexrest/WhatsappUpdateNPS';
            req.HTTPMethod = 'POST';
            req.requestBody = Blob.valueOf(json);
            
            RestResponse res = new RestResponse();
            RestContext.Request = req;
            RestContext.Response = res;  
            WhatsappUpdateNPS.updateNPS();     
        test.stoptest();
  }
  
  @isTest 
  static void testFailure(){
        Account personAcc=new Account(LastName='John',PersonEmail='Johnsdas@gmail.com',Customer_ID__c='Ben-d-2000027174');
        insert personAcc;
        
         Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),amount=200,
                                                Opportunity_Stage__c ='Appointment Successful'
                                        );
                                                insert perOpp;
        
        
        
        test.starttest();
            String json = '{"UniqueOpporunityID":"Ben-d-200007174","NPS":"8","CustomerResponse":"Good"}';
            
            RestRequest req = new RestRequest();
            req.addHeader('Content-Type','application/json');
            req.RequestURI = '/services/apexrest/WhatsappUpdateNPS';
            req.HTTPMethod = 'POST';
            req.requestBody = Blob.valueOf(json);
            
            RestResponse res = new RestResponse();
            RestContext.Request = req;
            RestContext.Response = res;  
            WhatsappUpdateNPS.updateNPS();     
        test.stoptest();
  }
  
}