@isTest
public class ConvertLeadQueueableForDesign_Test {

    public static testMethod void executeBatchs(){
        Lead mainLead = TestData_Factory.CreateFreshLead(true);
    List<Lead> listOfLeads = new List<Lead>();
        Lead l = TestData_Factory.CreateFreshLead(false);
        l.main_Order__c = mainLead.Id;
        insert l;
        listOfLeads.add(l);
    ConvertLeadQueueableForDesignNotRequired clq = new ConvertLeadQueueableForDesignNotRequired(listOfLeads);
    clq.execute(null);
    }
}