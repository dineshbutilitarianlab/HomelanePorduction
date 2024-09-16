@isTest
public class WarrantyThankYouController_Test {
    static testMethod void Success(){
        test.startTest();
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        Account personAcc=new Account(LastName='John',PersonEmail='aditya.saini@kvpcorp.com');
        insert personAcc;
        Opportunity opp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D3 Initiated',sub_Status__c='Final Drawings, Quote & Works Contract Sent',
                                        closeDate=system.today(),Address_Of_Instalation__c ='test',Date_Of_Completion__c=system.today(),
                                        Works_Contract_Comments__c ='Test Works Contact',Works_Contract_Sign_Off_Date__c = system.today(),
                                        Scope_Of_Work__c='test',Customer_Satisfaction__c=10,Customer_Feedback_Suggestion__c='test class',Opportunity_Stage__c='Won');
        
        insert opp;
        
        id oppId = opp.Id;
        
        
        PageReference pref = new pagereference('/apex/WarrantyThankYou');
        pref.getParameters().put('id',oppId);
        Test.setCurrentPage(pref);
        WarrantyThankYouController abc = new WarrantyThankYouController();
        abc.Recordpage();
        test.stopTest();
    }
}