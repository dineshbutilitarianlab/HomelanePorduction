@isTest
public class SendNpsToRoster_Test{
    public static testMethod void testSuccess() {

        List<Opportunity> oppList = new List<Opportunity>();
        Map<Id,Opportunity> mapopp = new Map<Id,Opportunity>();

        Integration_Setting__c intSetting = new Integration_Setting__c();
        intSetting.Name = 'Roster NPS';
        intSetting.End_Point__c = 'https://rosters.homelane.com/apis/ops/trigger_payment_emailonnps/test';
        intSetting.ContentType__c = 'application/json';
        insert intSetting;        
         

        Integration_Setting__c intSetting1 = new Integration_Setting__c();
        intSetting1.Name = 'Spacecraft Opportunity API';
        intSetting1.End_Point__c = 'http://sc-backend-qa.homelane.com/';
        intSetting1.Authorization__c= 'Authorization';
        insert intSetting1;              
         
        Master__c m = new Master__c();
        m.Type__c = 'Showroom';
        m.Avg_Conversion__c = 10;
        m.Total_Opportunities__c = 10;
        m.Total_Won_Opportunity__c = 6;
        m.Avg_Opportunites_Month__c = 20;
        insert m;
            
        Account a = new Account();
        a.name= 'Test User';
        a.Customer_ID__c = 'ABC-TK-2000011832';
        insert a;
             
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
        opp1.Lead_Customer_Quote_Number__c =' 123';
        //oppList.add(opp1);
        System.debug('****opp1  '+opp1);
        mapopp.put(opp1.id,opp1);
         //insert opp1;
        
        Opportunity opp2 = TestData_Factory.createOpportunity(a.id,false);
                opp2.Customer_Satisfaction__c = 9;
        insert opp2;

        
        
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
      
       
        
        test.starttest();

        System.debug('****updating the custmer satisfaction'+opp1.Customer_Satisfaction__c);
          opp2.Customer_Satisfaction__c = 8;
          update opp2;


        opportunity opp3 = [select id,Customer_Satisfaction__c,Customer_ID__c from opportunity where id =: opp2.id];
        System.enqueueJob(new SendNpsToRoster(new list<Opportunity>{opp3}));
        
        
        test.stopTest();
        
    }
}