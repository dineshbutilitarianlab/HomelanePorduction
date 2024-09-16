@isTest
public class UpdateOpportunityDetails_Controller_Test {
    
    Public Static Account acc;
    Public Static Opportunity opp;
    Public Static Lead leadrec;
    public Static Master__c propertyrec;
    @TestSetup static void data() { 
        propertyrec = TestData_Factory.CreateShowRoom(false);
        propertyrec.type__c = 'Property';
        propertyrec.Name = 'Property Name manual';
        insert propertyrec;
        
        acc = TestData_Factory.createAccount(True);
        
        leadrec = TestData_Factory.CreateFreshLead(false);
        leadrec.Account__c = acc.id;
        
        opp = TestData_Factory.createOpportunity(acc.Id,false);
        opp.Lost_Opp__c ='Lost';
        opp.LeadId__C = leadrec.Id;
        opp.Property_Name__c = propertyrec.Id;
        opp.Blockers__c='Away;Others';
        opp.Loss_Reason__c = 'Lost to Competitor';
        opp.Lost_To_Player__c ='Livspace';
        insert opp;
        
    }
    public testMethod static void updateOppDetailsController1() {
        Test.StartTest();
        opp = [Select id,Name,Customer_Email__c,Customer_Phone_Number__c,CityfromLead__c,Sales_Description__c,Lost_Opp__c,
               Probability_of_Closure_1__c,New_Close_Date__c,Follow_Up_Time__c
               from Opportunity limit 1];
        System.debug('opp: '+opp);
        ApexPages.currentPage().getParameters().put('id',opp.Id);
        ApexPages.StandardController ap=new ApexPages.StandardController(opp);
        UpdateOpportunityDetails_Controller sp=new UpdateOpportunityDetails_Controller(ap);
        sp.saveRecord();
        test.stoptest();  
    }
    public testMethod static void updateOppDetailsController2() {
        Test.StartTest();
        List<Opportunity> listOfOpportunityQueryied = new List<Opportunity>();
        String queryString = UtilityClass.getQueryString('Opportunity');
        queryString += ',Property_Name__r.Name From Opportunity limit 1';
        listOfOpportunityQueryied = Database.query(queryString);
        if(!listOfOpportunityQueryied.isEmpty()){
            opp = listOfOpportunityQueryied[0];
            opp.Blockers__c = 'Others';
            update opp;
            
            ApexPages.currentPage().getParameters().put('id',opp.Id);
            ApexPages.StandardController ap=new ApexPages.StandardController(opp);
            UpdateOpportunityDetails_Controller sp=new UpdateOpportunityDetails_Controller(ap);
            sp.isPropertyUpdate = True;
            sp.propertyNotFoundInGoogle = true;
            sp.propertyNameManual = 'Some prop ABC';
            sp.possessionDate = System.today().addDays(10);
            sp.propertyMoveInDate = System.today().addDays(10);
            sp.saveRecord();
            //sp.googlePropertySearchDisableToggle();
            sp.getPickValues(opp, 'Property_Status__c','--NONE--');
        }
        test.stoptest();  
    }
    /*public testMethod static void updateOppDetailsController3() {
        Test.StartTest();
        List<Opportunity> listOfOpportunityQueryied = new List<Opportunity>();
        String queryString = UtilityClass.getQueryString('Opportunity');
        queryString += ',Property_Name__r.Name From Opportunity limit 1';
        listOfOpportunityQueryied = Database.query(queryString);
        if(!listOfOpportunityQueryied.isEmpty()){
            opp = listOfOpportunityQueryied[0];
            opp.Blockers__c = 'Others';
            update opp;
            
            ApexPages.currentPage().getParameters().put('id',opp.Id);
            ApexPages.StandardController ap=new ApexPages.StandardController(opp);
            UpdateOpportunityDetails_Controller sp=new UpdateOpportunityDetails_Controller(ap);
            sp.isPropertyUpdate = True;
            sp.propertyNotFoundInGoogle = False;
            sp.googlePropertyDetails = 'Some prop ABC';
            sp.saveRecord();
            //sp.googlePropertySearchDisableToggle();
            sp.getPickValues(opp, 'Property_Status__c','--NONE--');
        }
        test.stoptest();  
    }*/
}