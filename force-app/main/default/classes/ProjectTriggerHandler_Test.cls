@isTest
public class ProjectTriggerHandler_Test{
    static testMethod void InsertProjectTest(){
        
        Test.startTest();
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email,Internal_buddy__c,Approved_Project__c FROM User WHERE ProfileId = :dp_profile.Id and isActive = True];
        system.debug('dp_prof ='+dp_prof );
        
        Account personAcc=new Account(LastName='John',PersonEmail='John@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='Quote Required',
                                           closeDate=system.today(),design_partner__c=dp_prof[0].id);
        insert perOpp;
        
        Project_Name__c proj = new Project_Name__c(Name = 'Proj1', Start_Date__c = system.today(), Opportunity_Project__c = perOpp.id);
        
        insert proj;
        Test.stopTest(); 
                
    }
}