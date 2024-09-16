@isTest
public class IronmenBacklogsUpdateBatchHandler_Test {
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
        showroomUser = [Select id from Showroom_User__c limit 1];
        Set<Id> setOfIronmenId = new Set<Id>();
        setOfIronmenId.add(showroomUser.id);
        Showroom_User__c dummyShowroomUser = TestData_Factory.createShowroomUser(True);
        setOfIronmenId.add(dummyShowroomUser.id);
        Map<Id,AggregateResult> mapOfIronmanWithAggregateResult = new Map<Id,AggregateResult>();
        mapOfIronmanWithAggregateResult = new Map<Id,AggregateResult>([SELECT Sales_Manager__r.Id Id,Count(Id) 
                                                                       FROM Lead 
                                                                       WHERE Sales_Manager__r.Id =:setOfIronmenId and Assigned_To_Resi_ASM__c =True 
                                                                       and Status='Fresh Lead' and (Sub_Status__c='New' or Sub_Status__c='Unverified') 
                                                                       GROUP BY Sales_Manager__r.Id]);
        IronmenBacklogsUpdateBatchHandler.updateBackLogsCount(setOfIronmenId, mapOfIronmanWithAggregateResult);
        IronmenBacklogsUpdateBatchHandler.updateBackLogsCount(null, null);
        test.stopTest();
    }
}