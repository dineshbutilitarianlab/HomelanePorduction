@isTest
public class OppFollowUpMeetingCancelledBatch_Test {
Public static Opportunity opp;
    public static Account acc;
    @TestSetup 
    static void data() { 
        //Create Account
        //
        acc = TestData_Factory.createAccount(false);
        insert acc;
        //Create Opportunity
        opp = TestData_Factory.createOpportunity(acc.Id,True);
        opp.Second_meeting_appointment_time__c = System.now().addHours(-50);
        opp.Opportunity_Funnel_Status__c = 'Follow-up Meeting Fixed';
        update opp;
        
        }
   public testMethod static void OppFollowUpMeetingCancelledBatchTest1(){
        Test.startTest();
       //OppFollowUpMeetingCancelled_Batch ofm = new OppFollowUpMeetingCancelled_Batch();
        Database.executeBatch(new OppFollowUpMeetingCancelled_Batch());
        Test.stopTest();
       }
    public testMethod static void OppFollowUpMeetingCancelledBatchTest2(){
        
        opp = [select id,Opportunity_Funnel_Status__c,Second_meeting_appointment_time__c from Opportunity limit 1];
        
        Test.startTest();
        Set<Id> setOfIds = new Set<Id>();
        setOfIds.add(opp.id);
        Database.executeBatch(new OppFollowUpMeetingCancelled_Batch(setOfIds));
        Test.stopTest();
    }
    public testMethod static void OppFollowUpMeetingCancelledBatchTest3(){
        Test.startTest();
        String sch = '0 0 23 * * ?';
        System.schedule('OppFollowUpMeetingCancelled_Batch',sch, new OppFollowUpMeetingCancelled_Batch());
        Test.stopTest();
    }
    
}

//Opportunity op;
        //op =[select Opportunity_Funnel_Status__c,Opportunity_Funnel_Sub_Status__c,Follow_up_time__c from opportunity where id=:opp.id limit 1 ];
       //if(op!= null){
       //system.assertEquals('Followup Meeting Cancelled', op.Opportunity_Funnel_Status__c);
       //system.assertEquals('Meeting Cancelled - Follow Up Later', op.Opportunity_Funnel_Sub_Status__c);
       //system.assertEquals(System.now().addHours(8), op.Follow_Up_Time__c);
       //}