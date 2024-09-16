@isTest
public class WorksContractController_Test{
    
    
    Public static Integration_Setting__c intSetting;
    static testMethod void WorksContractController_TestMethod(){
        
        try{
            intSetting = TestData_Factory.createIntegrationSetting('Roster_SOW_Approved_Check_API','https://sandbox-rosters-oh.homelane.com/apis/ops/getWorksContractStatus/','','application/json','');
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
            SC_MI_TestHandler.insertIsTriggerExecute();
            SC_MI_TestHandler.insertCustomDate();
            Account personAcc=new Account(LastName='John',PersonEmail='aditya.saini@kvpcorp.com');
            insert personAcc;
            Opportunity opp=new Opportunity(Customer_Email__c ='abc@gmail.com',Name='John Arjun',AccountId=personAcc.Id,stageName='D3 Initiated',sub_Status__c='Final Drawings, Quote & Works Contract Sent',
                                            closeDate=system.today(),Address_Of_Instalation__c ='test',Date_Of_Completion__c=system.today(),Works_Contract_Comments__c ='Test Works Contact',Scope_Of_Work__c='test',Customer_Satisfaction__c=10,Customer_Feedback_Suggestion__c='test class',Opportunity_Stage__c='Won');
            
            insert opp;
            
            id oppId = opp.Id;
            
            
            PageReference pref = Page.CustomerSatisfaction;
            pref.getParameters().put('id',oppId);
            Test.setCurrentPage(pref);
            
            
            
            
            //PageReference pageRef = new PageReference('http://www.homelane.com/');
            //Test.setCurrentPage(pageRef);
            //System.currentPageReference().getParameters().put('id', opp.Id);
            
            WorksContractController.getOpportunityRecord(oppId);
            
            
            WorksContractController workContract= new WorksContractController();
            
            workContract.getcustomernumber();
            workContract.getcustomerpicklistresponse();
            workContract.customerpicklistInput = 'Design - Unhappy with the design / designer';
            workContract.customerInput = '10';
            workContract.redirect=True;
            workContract.customerAggrement = True;
            // workContract.Accepted();
            //workContract.Rejected();
            workContract.Submitfeedback();
            system.debug('opp ------------------------->'+opp.Customer_Feedback_Suggestion__c);
            Test.startTest();
            ApexPages.currentPage().getParameters().put('interiorValue','Love it');
            ApexPages.currentPage().getParameters().put('recommandValue','5');
            ApexPages.currentPage().getParameters().put('designhmlValue','test');
            ApexPages.currentPage().getParameters().put('NPSqueshmlValue','test');
            ApexPages.currentPage().getParameters().put('suggestionboxValue','test');
            workContract.customerAggrement = False;
            //workContract.Accepted();
            //workContract.Rejected();
            workContract.sendWarrantyDocument();
            workContract.getWarrantydata();
            workContract.UpdatefeedbackOnOpportunity();
            VisualforceException exp = new VisualforceException();
            workContract.exceptionEmail(exp);
            workContract.Homelanehomepage();
            workContract.feadbackPage(oppId);
            workContract.RedirectToMain();
            workContract.checkNps();
            workContract.reDirectToNPS();
            workContract.Recordpage();
            workContract.sendRating();
            //workContract.AcceptedEdited();
            Test.stopTest();
        }
        catch(Exception e){
            System.debug('e.getStackTraceString: '+e.getStackTraceString());
        }
    }
    static testMethod void WorksContractController_TestMethod1(){
        
        try{
            intSetting = TestData_Factory.createIntegrationSetting('Roster_SOW_Approved_Check_API','https://sandbox-rosters-oh.homelane.com/apis/ops/getWorksContractStatus/','','application/json','');
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
            SC_MI_TestHandler.insertIsTriggerExecute();
            SC_MI_TestHandler.insertCustomDate();
            Account personAcc=new Account(LastName='John',PersonEmail='aditya.saini@kvpcorp.com');
            insert personAcc;
            Opportunity opp=new Opportunity(Customer_Email__c ='abc@gmail.com',Name='John Arjun',AccountId=personAcc.Id,stageName='D3 Initiated',sub_Status__c='Final Drawings, Quote & Works Contract Sent',
                                            closeDate=system.today(),Address_Of_Instalation__c ='test',Date_Of_Completion__c=system.today(),Works_Contract_Comments__c ='Test Works Contact',Scope_Of_Work__c='test',Customer_Satisfaction__c=10,Customer_Feedback_Suggestion__c='test class',Opportunity_Stage__c='Won');
            
            insert opp;
            
            id oppId = opp.Id;
            
            
            PageReference pref = Page.CustomerSatisfaction;
            pref.getParameters().put('id',oppId);
            Test.setCurrentPage(pref);

            WorksContractController.getOpportunityRecord(oppId);
            
            
            WorksContractController workContract= new WorksContractController();
            
            Test.startTest();
            workContract.Homelanehomepage();
            workContract.feadbackPage(oppId);	
            workContract.checkNps();
            workContract.reDirectToNPS();
            workContract.Recordpage();
            workContract.AcceptedEdited();
            //VisualforceException exp = new VisualforceException();
            //workContract.exceptionEmail(exp);
            Test.stopTest();
        }
        catch(Exception e){
            System.debug('e.getStackTraceString: '+e.getStackTraceString());
        }
    }
    static testMethod void WorksContractController_TestMethod2(){
        
        try{
            intSetting = TestData_Factory.createIntegrationSetting('Roster_SOW_Approved_Check_API','https://sandbox-rosters-oh.homelane.com/apis/ops/getWorksContractStatus/','','application/json','');
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
            SC_MI_TestHandler.insertIsTriggerExecute();
            SC_MI_TestHandler.insertCustomDate();
            Account personAcc=new Account(LastName='John',PersonEmail='aditya.saini@kvpcorp.com');
            insert personAcc;
            Opportunity opp=new Opportunity(Customer_Email__c ='abc@gmail.com',Name='John Arjun',AccountId=personAcc.Id,stageName='D3 Initiated',sub_Status__c='Final Drawings, Quote & Works Contract Sent',
                                            closeDate=system.today(),Address_Of_Instalation__c ='test',Date_Of_Completion__c=system.today(),Works_Contract_Comments__c ='Test Works Contact',Scope_Of_Work__c='test',Customer_Satisfaction__c=10,Customer_Feedback_Suggestion__c='test class',Opportunity_Stage__c='Won');
            
            insert opp;
            id oppId = opp.Id;
            
            
            PageReference pref = Page.CustomerSatisfaction;
            pref.getParameters().put('id',oppId);
            Test.setCurrentPage(pref);

            WorksContractController.getOpportunityRecord(oppId);
            
            
            WorksContractController workContract= new WorksContractController();
            
            Test.startTest();
            System.debug('opp.Id: '+opp.Id);
            workContract.CheckAndUncheckWhatsappOptIn();
            workContract.sendRating();
            workContract.RedirectToMain();    
            WorksContractController.calloutToRosterToGetCurrentStatus(opp.Id,'BEN-B-10000');
            Test.stopTest();
        }
        catch(Exception e){
            System.debug('e.getStackTraceString: '+e.getStackTraceString());
        }
    }
    static testMethod void WorksContractController_TestMethod3(){
        
        try{
            intSetting = TestData_Factory.createIntegrationSetting('Roster_SOW_Approved_Check_API','https://sandbox-rosters-oh.homelane.com/apis/ops/getWorksContractStatus/','','application/json','');
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
            SC_MI_TestHandler.insertIsTriggerExecute();
            SC_MI_TestHandler.insertCustomDate();
            Account personAcc=new Account(LastName='John',PersonEmail='aditya.saini@kvpcorp.com');
            insert personAcc;
            Opportunity opp=new Opportunity(Customer_Email__c ='abc@gmail.com',Name='John Arjun',AccountId=personAcc.Id,stageName='D3 Initiated',sub_Status__c='Final Drawings, Quote & Works Contract Sent',
                                            closeDate=system.today(),Address_Of_Instalation__c ='test',Date_Of_Completion__c=system.today(),Works_Contract_Comments__c ='Test Works Contact',Scope_Of_Work__c='test',Customer_Satisfaction__c=10,Customer_Feedback_Suggestion__c='test class',Opportunity_Stage__c='Won');
            
            opp.Whatsapp_Opt_in__c = True;
            opp.Works_Contract_Sign_Off_Done__c = True;
            insert opp;
            id oppId = opp.Id;
            
            
            PageReference pref = Page.CustomerSatisfaction;
            pref.getParameters().put('id',oppId);
            Test.setCurrentPage(pref);

            WorksContractController.getOpportunityRecord(oppId);
            
            
            WorksContractController workContract= new WorksContractController();
            
            Test.startTest();
            pref.getParameters().put('id','');
            Test.setCurrentPage(pref);
            Test.stopTest();
        }
        catch(Exception e){
            System.debug('e.getStackTraceString: '+e.getStackTraceString());
        }
    }
}