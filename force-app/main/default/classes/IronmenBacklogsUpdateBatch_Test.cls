@isTest
public class IronmenBacklogsUpdateBatch_Test {
    Public static Lead ld;
    Public static Showroom_User__c showroomUser;
    @TestSetup static void data() { 
        //Create showroom User
        //
      	showroomUser = TestData_Factory.createShowroomUser(false);
        showroomUser.Backlogs__c = 0;
        showroomUser.Daily_Assignment__c = 2;
        showroomUser.IsActive__c = True;
        showroomUser.IronMan__c = True;
        showroomUser.Threashold__c = 5;
        insert showroomUser;
        
           
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Status = 'Fresh Lead';
        ld.Sub_Status__c = 'New';
        ld.Sales_Manager__c = showroomUser.Id;
        ld.Assigned_to_Resi_ASM__c = True;
        insert ld;
        
    }
    public testMethod static void IronmenBacklogsUpdateBatchTest1(){
        Test.startTest();
        Database.executeBatch(new IronmenBacklogsUpdateBatch());
        test.stopTest();
    }
    public testMethod static void IronmenBacklogsUpdateBatchTest2(){
        Test.startTest();
        showroomUser = [Select id from Showroom_User__c limit 1];
        Set<Id> setOfIds = new Set<Id>();
        setOfIds.add(showroomUser.Id);
        Database.executeBatch(new IronmenBacklogsUpdateBatch(setOfIds));
        test.stopTest();
    }
    public testMethod static void IronmenBacklogsUpdateBatchTest3(){
        Test.startTest();
        String sch = '0 0 23 * * ?';
        System.schedule('IronmenBacklogsUpdateBatch',sch, new IronmenBacklogsUpdateBatch());
        test.stopTest();
    }
}