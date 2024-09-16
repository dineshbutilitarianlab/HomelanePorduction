@isTest
public class UpdateOpportunity_test{
    static testMethod void testUpdateOpportunityMethod(){
         Interior_Designer__c objIDP = new Interior_Designer__c();
        objIDP.Name = 'testData';
        objIDP.Email__c = 'TestDesighP@hfltest.com';
        insert objIDP;
        leadUtil_Test.InsertUserData('@hfltest.com','testab@tester.com'); 
        UpdateOpportunity.strBody = '{"customeremail":"testab@tester.com","DPemail": "TestDesighP@hfltest.com"}';
        UpdateOpportunity.UpdateOpportunity();
        
    }
    static testMethod void testUpdateOpportunityMethodDup(){
        leadUtil_Test.InsertUserData('@h2ltest.com','testab@tester.com'); 
        UpdateOpportunity.strBody = '{"customeremail":"testab@tester.com","VM_SubStatus":"Reschedule Meeting"}';
        UpdateOpportunity.UpdateOpportunity();
        
    }
    static testMethod void testUpdateOpportunityMethod2(){
        leadUtil_Test.InsertUserData('@hltest.com','testab1@tester.com'); 
        Opportunity ObjOpp1 = new Opportunity();
        ObjOpp1.Name = 'TestOpp2';
        ObjOpp1.Customer_Email__c = 'testab1@tester.com';
        ObjOpp1.StageName = 'Quote Required';
        ObjOpp1.CloseDate = Date.valueOf('2017-12-06T00:00:00.000Z');
        Insert ObjOpp1;
        UpdateOpportunity.strBody = '{"customeremail":"testab1@tester.com","VM_SubStatus":"Reschedule Meeting"}';
        UpdateOpportunity.UpdateOpportunity();
    }
}