@isTest
public class AccountTriggerHandler_test{
    @isTest static void test1() {
    
        Lead l = TestData_Factory.CreateFreshLead(false);
        Lead l2 = TestData_Factory.CreateFreshLead(false);
        List<Opportunity> oppList = new List<Opportunity>();
        Map<Id,Opportunity> mapopp = new Map<Id,Opportunity>();
        
        Master__c m = new Master__c();
        m.Type__c = 'Showroom';
        m.Avg_Conversion__c = 10;
        m.Total_Opportunities__c = 10;
        m.Total_Won_Opportunity__c = 6;
        m.Avg_Opportunites_Month__c = 20;
        insert m;
        
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account a = new Account();
        a.lastname= 'Test User';
        a.Customer_ID__c = 'BenTest-09';
        a.PersonEmail= 'asd@afad.com' ;
        a.phone= '1234556789';
        a.RecordTypeID=RecTypeId;
        insert a;
        
        Account a2 = new Account();
        a2.firstname= 'Test User';
        a2.LastName = 'test';
        a2.Customer_ID__c = 'BenTest-09';
        a2.PersonEmail= 'asdd@afad.com' ;
        a2.phone= '1234556799';
        a2.RecordTypeID=RecTypeId;
        insert a2;
        
             
        Opportunity opp1 = new Opportunity();
        opp1.AccountId = a.id;
        opp1.name = 'first';
        opp1.StageName='Won';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.Opportunity_Status__c = '6.Won';
        // opp1.AccountId = a.id;
        opp1.Customer_Satisfaction__c = 5;
        opp1.CloseDate = Date.Today();
        // opp1.Interior_Design_Partner__c = inte.id;
        opp1.Order_Book_Date__c = Date.Today();
        opp1.Amount = 1000;
        opp1.Appointment_Venue_Square__c = m.Id;
        opp1.Order_Closed__c = true;
        opp1.Appointment_Type__c = 'Square Showroom Visit';
        opp1.Time_of_Actual_Appointment_Start__c = Date.Today().addmonths(-1);
        opp1.Order_Book_Date__c = Date.Today().addmonths(-1);
        Opportunity opp2 = new Opportunity();
        opp2.AccountId = a2.id;
        opp2.name = 'first';
        opp2.StageName='Won';
        opp2.Opportunity_Stage__c = 'Won';
        opp2.Opportunity_Status__c = '6.Won';
        // opp1.AccountId = a.id;
        opp2.Customer_Satisfaction__c = 5;
        opp2.CloseDate = Date.Today();
        // opp1.Interior_Design_Partner__c = inte.id;
        opp2.Order_Book_Date__c = Date.Today();
        opp2.Amount = 1000;
        opp2.Appointment_Venue_Square__c = m.Id;
        opp2.Order_Closed__c = true;
        opp2.Appointment_Type__c = 'Square Showroom Visit';
        opp2.Time_of_Actual_Appointment_Start__c = Date.Today().addmonths(-1);
        opp2.Order_Book_Date__c = Date.Today().addmonths(-1);
        //oppList.add(opp1);
        System.debug('****opp1  '+opp1);
        insert opp2;
        mapopp.put(opp1.id,opp1);
        insert opp1;
        l.Account__c = a.Id;
        //l.Appointment_Type__c = 'Virtual Meeting';
        //l.Appointment_Venue_Square__c = m.Id;
        //l.Time_of_Actual_Appointment_Start__c = System.now();
        l2.Account__c = a2.Id;
        l2.Appointment_Venue_Square__c = m.Id;
        l2.Appointment_Type__c = 'Virtual Meeting';
         l2.Time_of_Actual_Appointment_Start__c = System.now();
        l2.Status = 'Appointment Successful';
        insert l;
        insert l2;
        a2.PersonEmail = 'sbc@gmail.cc';
        a2.Phone = 'sss@hms.cm';
        update a2;
        test.starttest();
           a.PersonEmail= 'asd@afasd.com' ;
            a.phone= '1234556780';
            update a;
        List<Id> listOfLeadIds = new List<Id>();
        listOfLeadIds.add(l2.id);
        //AutoConvertLeads.LeadAssign(listOfLeadIds);
        test.stoptest();
        
    }
}