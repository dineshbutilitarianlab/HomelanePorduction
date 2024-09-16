@isTest
public class WorksContractEmailController_Test{
   @testSetup static void TestData() {
      EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'Works_Contract_Attached';
        validEmailTemplate.DeveloperName = 'Works_Contract_Attached';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();

         insert validEmailTemplate; 
   
   }


    static testMethod void WorksContractEmailController_TestMethod(){
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account personAcc=new Account(LastName='John',PersonEmail='aditya.saini@kvpcorp.com',recordTypeId=RecordTypeIdContact);
        insert personAcc;
        Opportunity opp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D3 Initiated',sub_Status__c='Final Drawings, Quote & Works Contract Sent',Works_Contract_Sign_Off_Date__c = system.Now(),
                                        closeDate=system.today(),Address_Of_Instalation__c ='test',Date_Of_Completion__c=system.today(),Works_Contract_Comments__c ='Test Works Contact',Scope_Of_Work__c='test',Customer_Satisfaction__c=10,Customer_Feedback_Suggestion__c='test class',Opportunity_Stage__c='Won');
        
        insert opp;
          
        
       // id oppId = opp.Id;
        
         WorksContractEmailController workContract= new WorksContractEmailController();
         
          Test.startTest();
        ApexPages.currentPage().getParameters().put('id',opp.id);
        workContract.SendWorksContact();
        WorksContractEmailController.SendEmailWorksContact('care@homelane.com',personAcc.id);
         Test.stopTest();
        }
    }