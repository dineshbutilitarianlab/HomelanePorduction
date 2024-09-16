@isTest
public class NextStep_OpportunityController_Test{
    static testMethod void NextStpOppTest(){
        
        Test.startTest();
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Initial Quote Sent';
        insert oppNxtStp;
        system.debug('===oppNxtStp==='+oppNxtStp);
        Account personAcc=new Account(LastName='John',PersonEmail='John@gmail.com');
        insert personAcc;
        
        Opportunity opp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='Initial Quote Sent',
                                         closeDate=system.today());
        insert opp;
        
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        NextStep_OpportunityController nxtStp = new NextStep_OpportunityController(sc);
        
        Test.stopTest();
    }
}