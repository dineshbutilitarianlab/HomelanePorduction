@isTest
public class TaskTriggerHelper_Test{
    
    static testMethod void InsertMehod(){
        test.startTest();
            lead objLead = TestData_Factory.CreateFreshLead(false);
            insert objLead;
            
            Task t1=new Task();
            t1.subject='Manual Dialing - UCID -3449158390721311';
            t1.Priority='Normal';
            t1.Status='Open';
            t1.WhoId=objLead.Id;
            
            insert t1;
            
        test.stoptest();
    }
    
    static testMethod void UpdateMehod(){
        test.startTest();
            lead objLead = TestData_Factory.CreateFreshLead(false);
            insert objLead;
            
            Task t1=new Task();
            t1.subject='Manual Dialing - UCID -3449158390721311';
            t1.Priority='Normal';
            t1.Status='Open';
            t1.WhoId=objLead.Id;
            
            insert t1;
            
            t1.status__c = 'success';
            update t1;
            
        test.stoptest();
    }
}