/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class SendEmailAWSLink_Test {

    static testMethod void myUnitTest() {
        Profile pf1 = [Select Id from Profile where Name = 'Standard User'];
        User u1 = new User();        
        u1.LastName = 'Manager2';
        u1.Email = 'test@gmail.com';
        u1.CompanyName = 'test1.com';
        u1.Title = 'Test User12';
        u1.Username = 'testuser12345612@test133456789.com';
        u1.Alias = 'test1';
        u1.CommunityNickname = 'Test User1';
        u1.TimeZoneSidKey = 'America/Mexico_City';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'ISO-8859-1';
        u1.ProfileId = pf1.Id;            
        u1.LanguageLocaleKey = 'en_US';
        insert u1;
        
        SC_isTriggerExecute__c objCustomSetting = new SC_isTriggerExecute__c(Name = 'Test3',  isTriggerExecute__c = false);
        SC_OpportunityCustDate__c startDate = new SC_OpportunityCustDate__c(Name = 'Test4', SC_StartDate__c = system.today().addDays(-1));
        AWS_Keys__c key = new AWS_Keys__c(Name = 'Test1');
        URL__c url = new URL__c(Name = 'Test2', URL__c = 'hlqa-homelane-qadev.cs6.force.com/Homelaneqadev');
        insert objCustomSetting;
        insert startDate;
        insert key;
        insert url; 
        
        RecordType recType = [SELECT Id FROM RecordType WHERE Name='Person Account']; 
        
        Account objPersonAcc = new Account(LastName='Test Acc', recordTypeId=recType.Id,PersonEmail='Test44@gmail.com', phone='04561254144');
        insert objPersonAcc;
        
        Opportunity objTestOpp = new Opportunity(Name='Test Opp', AccountId=objPersonAcc.Id, StageName='Initial Quote Sent', CloseDate=system.today(), 
                                                Amount=5000, Event_Created_D1__c = true);
        insert objTestOpp ;

        Element__c objElement = new Element__c(Name='TestEle');
        
        insert objElement;

        /*
        EmailTemplate objTemplate = new EmailTemplate();
        objTemplate.isActive = true;
        objTemplate.Name = 'TestName';
        objTemplate.DeveloperName = 'TestDeveloper';
        objTemplate.TemplateType = 'text';
        objTemplate.FolderId = u1.Id;
        objTemplate.Subject = 'Hi Test Demo'; 
        insert objTemplate;
        */
        EmailTemplate objEmailTemp = [Select Id, Name From EmailTemplate  limit 1];        
        
        system.runAs(u1){
            Test.StartTest();
                
                //Standard controller page refernces
                PageReference objPageRef = Page.AWSTreeStructure;
                Test.setCurrentPageReference(objPageRef);
                ApexPages.CurrentPage().getparameters().put('id', objTestOpp.id); 
                ApexPages.CurrentPage().getparameters().put('parentIdForRedirect', objTestOpp.id);
                ApexPages.CurrentPage().getparameters().put('relatedId', objTestOpp.id);
                
                ApexPages.CurrentPage().getparameters().put('template_id', objEmailTemp.id);
                ApexPages.CurrentPage().getparameters().put('emailIds', objElement.id);
                //HierarchyClass objClass = new HierarchyClass(new ApexPages.StandardController(objTestOpp));
                
                //Controller and methods
                SendEmailAWSLink objSendEmailAWSLink = new SendEmailAWSLink();
                Attachment objAttachment  = objSendEmailAWSLink.attachment;
                PageReference objPReference1 = objSendEmailAWSLink.send();
                PageReference objPReference2 = objSendEmailAWSLink.cancel();
                PageReference objPReference3 = objSendEmailAWSLink.populateTemplate();
                
            Test.StopTest();    
        }
    }
}