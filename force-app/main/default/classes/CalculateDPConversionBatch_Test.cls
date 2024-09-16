@isTest
public class CalculateDPConversionBatch_Test {
      public testmethod static void setup() {
        List<Interior_Designer__c> intDesigner = new List<Interior_Designer__c>();
        List<Opportunity> oppList = new List<Opportunity>();
        
        Stack_DP_Rank__c stack = new Stack_DP_Rank__c();
        stack.Name = 'Stack DP';
        insert stack; 
        
        Account a = new Account(LastName = 'test', firstName = 'test');
        insert a;
        
        Interior_Designer__c inte = new Interior_Designer__c();
        inte.name = 'test';
        inte.Email__c = 'test@23.com';
        inte.Active__c   = true;
       // inte.X0_4_Opportunities__c = 1;
        inte.Available_at_Showroom__c = null;
        insert inte;
        
        SC_Section__c sc = new SC_Section__c();
        insert sc;
        
        SC_Item__c si = new SC_Item__c();
        si.Item__c = 'abc';
        insert si;
        
        SC_Section_Item__c ssi = new SC_Section_Item__c();
        ssi.Item__c = si.Id;
        ssi.Section__c = sc.Id;
        insert ssi;
        
        Master__c m = new Master__c();
        m.Type__c = 'Property';
        m.Avg_Conversion__c = 10;
        m.Total_Opportunities__c = 10;
        m.Total_Won_Opportunity__c = 6;
        m.Avg_Opportunites_Month__c = 20;
        insert m;
        
        Opportunity opp1 = new Opportunity();
        opp1.name = 'first';
        opp1.StageName='Won';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.AccountId = a.id;
        opp1.CloseDate = Date.Today();
        opp1.Interior_Design_Partner__c = inte.id;
        opp1.Amount = 1000;
         opp1.Amount_Collected__c = 50000;
      //  opp1.Appointment_Venue_Square__c = m.Id;
        opp1.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-2);
        oppList.add(opp1);
       // inte.X0_4_Opportunities__c = 1;
        
      //  update inte;
        
        Interior_Designer__c inte2 = new Interior_Designer__c();
        inte2.name = 'test1235353';
        inte2.Email__c = 'test@231afa34.com';
        inte2.Active__c   = true;
       // inte.X0_4_Opportunities__c = 1;
        intDesigner.add(inte2);
        
        Opportunity opp3 = new Opportunity();
        opp3.name = 'first3';
        opp3.StageName='Won';
        opp3.Opportunity_Stage__c = 'Won';
        opp3.AccountId = a.id;
        opp3.CloseDate = Date.Today();
      //  opp3.Appointment_Venue_Square__c = m.Id;
        opp3.Interior_Design_Partner__c = inte.id;
        opp3.Amount = 500000;
         opp3.Amount_Collected__c = 50000;
        opp3.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-3);
        oppList.add(opp3);
       // inte.X0_4_Opportunities__c = 1;
        
        
        
        Interior_Designer__c inte1 = new Interior_Designer__c();
        inte1.name = 'test1';
        inte1.Email__c = 'test@23134.com';
        inte1.Active__c   = true;
       // inte.X0_4_Opportunities__c = 1;
        intDesigner.add(inte1);
        
        Opportunity opp2 = new Opportunity();
        opp2.name = 'first1';
        opp2.StageName='Won';
        opp2.Opportunity_Stage__c = 'Won';
        opp2.AccountId = a.id;
        opp2.CloseDate = Date.Today();
       // opp2.Appointment_Venue_Square__c = m.Id;
        opp2.Interior_Design_Partner__c = inte.id;
        opp2.Amount = 5000000;
         opp2.Amount_Collected__c = 50000;
        opp2.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-4);
        oppList.add(opp2);
       // inte.X0_4_Opportunities__c = 1;
        
       // update inte1;
        
        
        
        Interior_Designer__c inte4 = new Interior_Designer__c();
        inte4.name = 'test1sgd';
        inte4.Email__c = 'test@23134df.com';
        inte4.Active__c   = true;
       // inte.X0_4_Opportunities__c = 1;
        intDesigner.add(inte4);
        
        Opportunity opp4 = new Opportunity();
        opp4.name = 'first1zv';
        opp4.StageName='D1 Initiated';
        opp4.Opportunity_Stage__c = 'Won';
        opp4.AccountId = a.id;
        opp4.CloseDate = Date.Today();
     //   opp4.Appointment_Venue_Square__c = m.Id;
        opp4.Interior_Design_Partner__c = inte.id;
        opp4.Amount = 5000;
        opp4.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-5);
        oppList.add(opp4);
       // update inte4;
        
        Interior_Designer__c inte5 = new Interior_Designer__c();
        inte5.name = 'tesmlt1sgd';
        inte5.Email__c = 'test@23134dmf.com';
        inte5.Active__c   = true;
       // inte.X0_4_Opportunities__c = 1;
        intDesigner.add(inte5);
        
        Opportunity opp5 = new Opportunity();
        opp5.name = 'first1mklzv';
        opp5.StageName='D1 Initiated';
        opp5.Opportunity_Stage__c = 'Won';
        opp5.AccountId = a.id;
        opp5.CloseDate = Date.Today();
        opp5.Interior_Design_Partner__c = inte.id;
        opp5.Amount = 500000;
         opp5.Amount_Collected__c = 50000;
     //   opp5.Appointment_Venue_Square__c = m.Id;
        opp5.Time_of_Actual_Appointment_Start__c = date.today().addMonths(-1);
        oppList.add(opp5);
       // update inte5;
        
        Interior_Designer__c inte6 = new Interior_Designer__c();
        inte6.name = 'tesmlt1sgdm';
        inte6.Email__c = 'teklst@23134dmf.com';
        inte6.Active__c   = true;
       // inte.X0_4_Opportunities__c = 1;
        intDesigner.add(inte6);
        
        
        Opportunity opp6 = new Opportunity();
        opp6.name = 'firstlknk1zv';
        opp6.StageName='D1 Initiated';
        opp6.Opportunity_Stage__c = 'Won';
        opp6.AccountId = a.id;
        opp6.CloseDate = Date.Today();
       // opp6.Appointment_Venue_Square__c = m.Id;
        opp6.Interior_Design_Partner__c = inte.id;
        opp6.Amount = 5000000;
         opp6.Amount_Collected__c = 50000;
        oppList.add(opp6);
        insert intDesigner;
       // update intDesigner;
        
        insert oppList;
        
       // update oppList;
        
      //  CronJobDetail cronJob = new CronJobDetail();
     //   cronJob.Name = 'TestCron';
      //  insert cronJob;
        
        //CronTrigger cron = new CronTrigger();
        //insert cron;
         String CRON_EXP = '0 0 0 3 9 ? 2022';
        
        Test.startTest();
      //  CalculateDPConversionBatch uca = new CalculateDPConversionBatch();
      //  Id jobId = Database.executeBatch(uca);
        String jobId = System.schedule('Test', CRON_EXP, new ScheduleCalculateDPConversionBatch());
        System.debug('******jobId  '+jobId );
        CronTrigger cron1  = [SELECT Id,  CronJobDetail.Name, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger where id = :jobId];
       
    /*  AsyncApexJob async = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
      TotalJobItems, CreatedBy.Email
      FROM AsyncApexJob WHERE Id =
      :batchId ];  
        
       // Schedule the test job
       String jobId = System.schedule('CalculateDPConversionBatch_Test', CRON_EXP, new CalculateDPConversionBatch());
      // Get the information from the CronTrigger API object 
         CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; */
        Test.stopTest();
    }
    
    

}