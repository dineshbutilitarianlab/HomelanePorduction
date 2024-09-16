@isTest
public class DripEmailsSend_Test {
    public static void cs() {
        Drip_Emails__c d = new Drip_Emails__c();
        d.Name = 'Drip Email';
        d.No_of_days__c = 3;
        d.No_of_Email_Templates__c = 12;
        insert d;
    }
    public testMethod static void test1() {
        cs();
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.email = 'sakf@dfjkc.com';
         leadRec1.phone = '6291029375';
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Calculated_WT_allocated_time__c = null;
         leadRec1.Description__c = 'ehllo';
         leadRec1.Ameyo_Call_Attempts__c = 0;
         leadRec1.WT_Agent_Allocated_Time__c = null;
         insert leadRec1;  
         Test.setCreatedDate(leadRec1.Id, Date.Today().addDays(-3));
         List<Lead> leadList = new List<Lead>();
         leadList.add(leadRec1);
         Test.startTest();
         Database.executeBatch(new DripEmailsSend());
      //   Id batchJobId = 
      //   System.abortJob(batchJobId);
         Test.stopTest();
    }
    
    public testMethod static void test2() {
        cs();
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.email = 'sakf1@dfjkc.com';
         leadRec1.phone = '6291029301';
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Calculated_WT_allocated_time__c = null;
         leadRec1.Description__c = 'ehllo';
         leadRec1.Ameyo_Call_Attempts__c = 0;
         leadRec1.WT_Agent_Allocated_Time__c = null;
         insert leadRec1;  
         Test.setCreatedDate(leadRec1.Id, Date.Today().addDays(-6));
         List<Lead> leadList = new List<Lead>();
         leadList.add(leadRec1);
         Test.startTest();
         Database.executeBatch(new DripEmailsSend());
      //   Id batchJobId = 
      //   System.abortJob(batchJobId);
         Test.stopTest();
    }
    
    public testMethod static void test3() {
        cs();
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.email = 'sakf3@dfjkc.com';
         leadRec1.phone = '6291029303';
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Calculated_WT_allocated_time__c = null;
         leadRec1.Description__c = 'ehllo';
         leadRec1.Ameyo_Call_Attempts__c = 0;
         leadRec1.WT_Agent_Allocated_Time__c = null;
         insert leadRec1;  
         Test.setCreatedDate(leadRec1.Id, Date.Today().addDays(-9));
         List<Lead> leadList = new List<Lead>();
         leadList.add(leadRec1);
         Test.startTest();
         Database.executeBatch(new DripEmailsSend());
      //   Id batchJobId = 
      //   System.abortJob(batchJobId);
         Test.stopTest();
    }
    
    public testMethod static void test4() {
        cs();
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.email = 'sakf4@dfjkc.com';
         leadRec1.phone = '6291029304';
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Calculated_WT_allocated_time__c = null;
         leadRec1.Description__c = 'ehllo';
         leadRec1.Ameyo_Call_Attempts__c = 0;
         leadRec1.WT_Agent_Allocated_Time__c = null;
         insert leadRec1;  
         Test.setCreatedDate(leadRec1.Id, Date.Today().addDays(-12));
         List<Lead> leadList = new List<Lead>();
         leadList.add(leadRec1);
         Test.startTest();
         Database.executeBatch(new DripEmailsSend());
      //   Id batchJobId = 
      //   System.abortJob(batchJobId);
         Test.stopTest();
    }
    
    public testMethod static void test5() {
        cs();
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.email = 'sakf5@dfjkc.com';
         leadRec1.phone = '6291029305';
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Calculated_WT_allocated_time__c = null;
         leadRec1.Description__c = 'ehllo';
         leadRec1.Ameyo_Call_Attempts__c = 0;
         leadRec1.WT_Agent_Allocated_Time__c = null;
         insert leadRec1;  
         Test.setCreatedDate(leadRec1.Id, Date.Today().addDays(-15));
         List<Lead> leadList = new List<Lead>();
         leadList.add(leadRec1);
         Test.startTest();
         Database.executeBatch(new DripEmailsSend());
      //   Id batchJobId = 
      //   System.abortJob(batchJobId);
         Test.stopTest();
    }
    
    public testMethod static void test6() {
        cs();
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.email = 'sakf6@dfjkc.com';
         leadRec1.phone = '6291029306';
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Calculated_WT_allocated_time__c = null;
         leadRec1.Description__c = 'ehllo';
         leadRec1.Ameyo_Call_Attempts__c = 0;
         leadRec1.WT_Agent_Allocated_Time__c = null;
         insert leadRec1;  
         Test.setCreatedDate(leadRec1.Id, Date.Today().addDays(-18));
         List<Lead> leadList = new List<Lead>();
         leadList.add(leadRec1);
         Test.startTest();
         Database.executeBatch(new DripEmailsSend());
      //   Id batchJobId = 
      //   System.abortJob(batchJobId);
         Test.stopTest();
    }
    
    public testMethod static void test7() {
        cs();
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.email = 'sak7f@dfjkc.com';
         leadRec1.phone = '6291029307';
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Calculated_WT_allocated_time__c = null;
         leadRec1.Description__c = 'ehllo';
         leadRec1.Ameyo_Call_Attempts__c = 0;
         leadRec1.WT_Agent_Allocated_Time__c = null;
         insert leadRec1;  
         Test.setCreatedDate(leadRec1.Id, Date.Today().addDays(-21));
         List<Lead> leadList = new List<Lead>();
         leadList.add(leadRec1);
         Test.startTest();
         Database.executeBatch(new DripEmailsSend());
      //   Id batchJobId = 
      //   System.abortJob(batchJobId);
         Test.stopTest();
    }
    
    public testMethod static void test8() {
        cs();
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.email = 'sakf8@dfjkc.com';
         leadRec1.phone = '6291029308';
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Calculated_WT_allocated_time__c = null;
         leadRec1.Description__c = 'ehllo';
         leadRec1.Ameyo_Call_Attempts__c = 0;
         leadRec1.WT_Agent_Allocated_Time__c = null;
         insert leadRec1;  
         Test.setCreatedDate(leadRec1.Id, Date.Today().addDays(-24));
         List<Lead> leadList = new List<Lead>();
         leadList.add(leadRec1);
         Test.startTest();
         Database.executeBatch(new DripEmailsSend());
      //   Id batchJobId = 
      //   System.abortJob(batchJobId);
         Test.stopTest();
    }
    
    public testMethod static void test9() {
        cs();
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.email = 'sakf9@dfjkc.com';
         leadRec1.phone = '6291029309';
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Calculated_WT_allocated_time__c = null;
         leadRec1.Description__c = 'ehllo';
         leadRec1.Ameyo_Call_Attempts__c = 0;
         leadRec1.WT_Agent_Allocated_Time__c = null;
         insert leadRec1;  
         Test.setCreatedDate(leadRec1.Id, Date.Today().addDays(-27));
         List<Lead> leadList = new List<Lead>();
         leadList.add(leadRec1);
         Test.startTest();
         Database.executeBatch(new DripEmailsSend());
      //   Id batchJobId = 
      //   System.abortJob(batchJobId);
         Test.stopTest();
    }
    
    public testMethod static void test10() {
        cs();
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.email = 'sakf10@dfjkc.com';
         leadRec1.phone = '6291029310';
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Calculated_WT_allocated_time__c = null;
         leadRec1.Description__c = 'ehllo';
         leadRec1.Ameyo_Call_Attempts__c = 0;
         leadRec1.WT_Agent_Allocated_Time__c = null;
         insert leadRec1;  
         Test.setCreatedDate(leadRec1.Id, Date.Today().addDays(-30));
         List<Lead> leadList = new List<Lead>();
         leadList.add(leadRec1);
         Test.startTest();
         Database.executeBatch(new DripEmailsSend());
      //   Id batchJobId = 
      //   System.abortJob(batchJobId);
         Test.stopTest();
    }
    
    public testMethod static void test11() {
        cs();
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.email = 'sakf11@dfjkc.com';
         leadRec1.phone = '6291029311';
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Calculated_WT_allocated_time__c = null;
         leadRec1.Description__c = 'ehllo';
         leadRec1.Ameyo_Call_Attempts__c = 0;
         leadRec1.WT_Agent_Allocated_Time__c = null;
         insert leadRec1;  
         Test.setCreatedDate(leadRec1.Id, Date.Today().addDays(-33));
         List<Lead> leadList = new List<Lead>();
         leadList.add(leadRec1);
         Test.startTest();
         Database.executeBatch(new DripEmailsSend());
      //   Id batchJobId = 
      //   System.abortJob(batchJobId);
         Test.stopTest();
    }
    
    public testMethod static void test12() {
        cs();
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.email = 'sakf12@dfjkc.com';
         leadRec1.phone = '6291029312';
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Calculated_WT_allocated_time__c = null;
         leadRec1.Description__c = 'ehllo';
         leadRec1.Ameyo_Call_Attempts__c = 0;
         leadRec1.WT_Agent_Allocated_Time__c = null;
         insert leadRec1;  
         Test.setCreatedDate(leadRec1.Id, Date.Today().addDays(-36));
         List<Lead> leadList = new List<Lead>();
         leadList.add(leadRec1);
         Test.startTest();
         Database.executeBatch(new DripEmailsSend());
      //   Id batchJobId = 
      //   System.abortJob(batchJobId);
         Test.stopTest();
    }
}