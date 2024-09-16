@isTest
public class DeletecustomerProfileBatch_test {


    
    
    @TestSetup static void data() {
        Customer_Profiling_Session__c lg = new Customer_Profiling_Session__c();
        lg.Name ='webEngageBatchHandler class';
        insert lg;
            
    }
    
    public testMethod static void DeleteLogTest1(){
        
        Test.startTest();
        
        
        DeleteCustomerProfilingsession webTask = new DeleteCustomerProfilingsession();
        database.executeBatch(webTask);
        Test.stopTest();
    }
    
}