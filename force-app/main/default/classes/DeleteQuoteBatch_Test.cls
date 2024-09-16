@isTest
public class DeleteQuoteBatch_Test  
{

        Public static Account accountRec;
        Public static Opportunity opportunityRec;
         
        public testMethod static void DeleteQuoteBatch_Test1()
        {
            Datetime yesterday = Datetime.now().addDays(-1);
            
            RecordType recType=[SELECT Id FROM RecordType WHERE Name='Person Account'];
            Account personAcc=new Account(LastName='prathap',recordTypeId=recType.Id,PersonEmail='prathap66@gmail.com',phone='0456125413');
            insert personAcc;
            
            Opportunity opp=new Opportunity(Name='prathik',AccountId=personAcc.Id,stageName='Quote Required',
                                            closeDate=system.today(),Amount=5000);
            insert opp;
            Test.setCreatedDate(personAcc.Id, DateTime.newInstance(2018,01,05));     
            Test.setCreatedDate(opp.Id,DateTime.newInstance(2018,01,05));
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
            quoteId.Pricebook2Id = customPB.id;
            quoteId.X10_Quote__c = false;
            quoteId.X40_Quote__c = false;
            quoteId.X50_Quote__c = false;
            quoteId.CreatedDate = Date.today().addDays(-400);
            insert quoteId;
            
            QuoteLineItem Q1 = new QuoteLineItem();
            Q1.QuoteId = quoteId.id;
            Q1.Product2Id = standardPrice.Product2Id;
            Q1.PricebookEntryId = customPrice.Id;
            Q1.Quantity = 100;
            Q1.UnitPrice = 1000;
            Q1.CreatedDate = Date.today().addDays(-400);
            insert Q1;
            
            Set<id> setofIDs = new Set<id>();
            List<Quote> ListofQL = [SELECT Id FROM Quote where Id = :quoteId.id LIMIT 1];
            
            setOfIds.add(ListofQL[0].id);
            
            Test.startTest();
            Database.executeBatch(new DeleteQuoteBatch(setOfIds));
            Test.stopTest();
        }
    
    	public testMethod static void DeleteQuoteBatch_Test2()
        {
            Test.startTest();
            Database.executeBatch(new DeleteQuoteBatch());
            test.stopTest();
        }
    
    	public testMethod static void DeleteQuoteBatch_Test3() 
        {
            // Schedule the job
            DeleteQuoteBatch scheduledJob = new DeleteQuoteBatch();
            String jobId = System.schedule('Test DeleteQuoteBatch_Test', '0 0 * * * ?', scheduledJob);
    
            // Verify the job was scheduled successfully
            System.assertNotEquals(null, jobId, 'Job was not scheduled successfully');
        }
    
}