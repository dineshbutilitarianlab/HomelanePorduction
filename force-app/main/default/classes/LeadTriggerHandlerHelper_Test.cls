@isTest
public class LeadTriggerHandlerHelper_Test {
    
 Public static Lead ld;
    Public static Integration_Setting__c intSetting;
    Public static Master__c showRoom;
    Public static Master__c m;
    Public static Account acc;
    
    @TestSetup static void data() { 
       ld= TestData_Factory.CreateFreshLead(false);
        acc = new account();
        acc.Name='testeacc';
        insert acc;
        ld.GCLID__c='16567833900';
        
        ld.account__c =acc.id;
        insert ld;
        
        
    }
    public testMethod static void checkFbLead(){
        Test.startTest();
       lead ld1 = new Lead();
        ld1.LastName='leadCheck';
        ld1.Phone='+917896789678';
        ld1.LeadSource='FB Lead Form';
        ld1.GCLID__c ='1542673893900';
        ld1.Description__c= 'within 3 months';
        ld1.city='bengaluru';
        ld1.Postalcode ='560103';
        insert ld1;
        Test.stopTest();
        
    }
    public testMethod static void checkJSon(){
        Test.startTest();
        ld =[select id,Status,GCLID__c from lead limit 1];
        
        LeadTriggerHandlerHelper.CreateFbLeadJson(ld.GCLID__c,ld.status);
        Test.stopTest();
    }
}