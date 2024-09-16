@isTest
public class ResetResiASMFlag_Test {
 
    Public static Lead ld;
    @TestSetup static void data() { 
        //Create showroom User
        //

        ld = TestData_Factory.CreateFreshLead(false);
        ld.Status = 'Fresh Lead';
        ld.Sub_Status__c = 'Unverified';
        insert ld;
        
    }
    
   public testMethod static void ResetResiASMTest1(){
       Lead ld = [select id from lead limit 1];{
           ld.Assigned_to_Resi_ASM__c = true;
           ld.Transfer_Status__c= 'Doowup Transfer';
           update ld;
           Test.startTest();
        Database.executeBatch(new ResetResiASMFlag());
        test.stopTest();
               
       }
   }
}