@isTest
public class DPTypeConversionCalc_Test {
    public testmethod static void setup() {
        List<Interior_Designer__c> intDesigner = new List<Interior_Designer__c>();
        List<Opportunity> oppList = new List<Opportunity>();
        
        Interior_Designer__c inte = new Interior_Designer__c();
        inte.name = 'test';
        inte.Email__c = 'test@23.com';
        inte.Active__c   = true;
        inte.Available_at_Showroom__c = null;
        insert inte;               
        
        Master__c m = new Master__c();
        m.Name = 'Test howwroomm';
        m.Type__c = 'Showroom';
        m.Avg_Conversion__c = 10;
        m.Total_Opportunities__c = 10;
        m.Total_Won_Opportunity__c = 6;
        m.Avg_Opportunites_Month__c = 20;
        m.N_8_to_N_2_Total_Opportunities__c = 1;
        m.N_8_to_N_2_Total_Won_Opportunities__c = 2;
        m.N_9_to_N_3_Total_Opportunities__c = 3;
        m.N_9_to_N_3_Total_Won_Opportunities__c = 4;
        m.N_10_to_N_4_Total_Opportunities__c = 5;
        m.N_10_to_N_4_Total_Won_Opportunities__c = 6;
        insert m;      
        
        Master__c m1 = new Master__c();
        m1.Name = 'Test wwroomm';
        m1.Type__c = 'Showroom';
        m1.Avg_Conversion__c = 10;
        m1.Total_Opportunities__c = 10;
        m1.Total_Won_Opportunity__c = 6;
        m1.Avg_Opportunites_Month__c = 20;
        m1.N_8_to_N_2_Total_Opportunities__c = 10;
        m1.N_8_to_N_2_Total_Won_Opportunities__c = 20;
        m1.N_9_to_N_3_Total_Opportunities__c = 30;
        m1.N_9_to_N_3_Total_Won_Opportunities__c = 40;
        m1.N_10_to_N_4_Total_Opportunities__c = 50;
        m1.N_10_to_N_4_Total_Won_Opportunities__c = 60;
        insert m1;
        
        Opportunity opp1 = new Opportunity();
        opp1.name = 'first';
        opp1.StageName='Won';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Interior_Design_Partner__c = inte.id;
        opp1.Amount = 1000;
        opp1.Appointment_Venue_Square__c = m.Id;
        opp1.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-5);
        insert opp1;
     
        Interior_Designer__c inte2 = new Interior_Designer__c();
        inte2.name = 'test1235353';
        inte2.Email__c = 'test@231afa34.com';
        inte2.Active__c   = true;
        insert inte2;      
        
        for(Integer i=0; i<=15;i++) {
            Opportunity opp3 = new Opportunity();
            opp3.name = 'first3[i]';
            opp3.StageName='Won';
            opp3.Opportunity_Stage__c = 'Won';
            opp3.CloseDate = Date.Today();
            opp3.Interior_Design_Partner__c = inte2.id;
            opp3.Amount = 500000;
            opp3.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-5);
            opp3.Appointment_Venue_Square__c = m1.Id;
            oppList.add(opp3);
        }     
        insert oppList;
        
        Test.startTest();
        DPTypeConversionCalc.DPTypeConversion();
        Test.stopTest();
    }
}