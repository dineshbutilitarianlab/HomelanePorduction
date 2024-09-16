@isTest
public class QuoteTrigger_Test{

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
        
        Quote quote = new Quote();
        quote.Name = 'testQuote';
        quote.OpportunityId = perOpp.id;
        quote.Status = 'Draft';
        insert quote;
        
        quote.Name = 'testQuote12';
        update quote;
    
  }
  
}