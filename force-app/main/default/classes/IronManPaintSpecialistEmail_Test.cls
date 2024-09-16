@isTest 
public class IronManPaintSpecialistEmail_Test {
     public static testMethod void execute() {
        Test.startTest();
        IronManPaintSpecialistScheduleEmail ss = new IronManPaintSpecialistScheduleEmail ();
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, ss);
        Test.stopTest();
    }
public static testMethod Void execute1(){
       Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.Threashold__c = 10;
        objShowroom1.Backlogs__c = 2;
        objShowroom1.Daily_Assignment__c = 8;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 8;
        objShowroom1.Monthly_Assignment_Limit__c = 10;
        objShowroom1.WT_Leads_Daily_Assignment__c = 0;
        objShowroom1.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom1.Specialisation__c='Paint';
        insert ObjShowroom1;
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
        objShowroom2.Threashold__c = 10;
        objShowroom2.Backlogs__c = 2;
        objShowroom2.Daily_Assignment__c = 9;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true; 
        objShowroom2.Monthly_Assignment__c = 8;
        objShowroom2.Monthly_Assignment_Limit__c = 10;
        objShowroom2.WT_Leads_Daily_Assignment__c = 0;
        objShowroom2.WT_Leads_Daily_Assignment_Limit__c = 100;
         objShowroom2.Specialisation__c='Paint';
        insert ObjShowroom2;
       List<Showroom_User__c> showroomUserList = new  List<Showroom_User__c>();
       Decimal cumulativeValue =10;
       showroomUserList.add(ObjShowroom1);
       showroomUserList.add(ObjShowroom2);
     
       list<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
     String  htmlBody = '<table border="1" style="border-collapse: collapse"><caption>Request Summary Data</caption><tr><th>Name</th><th>Daily Assignment</th><th>Daily Assignment limit</th><th>Monthly Assignment</th><th>Daily Assignment limit</th></tr>';
        List<String> toAddresses = new List<String>(); 
         toAddresses.add('testemail@test.com');
        mail.setToAddresses(toAddresses);
        mail.setSubject('Daily limit exceeds');
       mail.setHtmlBody(HTMLBody);
       String subject = 'Daily/Monthly limit for Pronto Paint has reached '+ cumulativeValue +'% utilization';
                String messageBody = '<html><body> Team,<br>The daily/monthly cumulative assignment for the Pronto Paint specialist has reached '+ cumulativeValue +'%. Please check if the limit needs to be changed.<br>Thanks </body></html>';
                
                mail.setSubject(subject);
                mail.setHtmlBody(messageBody+htmlBody);
                mailList.add(mail); 
        Test.startTest();
        
      IronManPaintSpecialistScheduleEmail ss = new IronManPaintSpecialistScheduleEmail ();
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, ss);
        Test.stopTest();
    }
    public static testMethod Void execute2(){
       Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.Threashold__c = 10;
        objShowroom1.Backlogs__c = 2;
        objShowroom1.Daily_Assignment__c = 8;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = false; 
        objShowroom1.Monthly_Assignment__c = 8;
        objShowroom1.Monthly_Assignment_Limit__c = 10;
        objShowroom1.WT_Leads_Daily_Assignment__c = 0;
        objShowroom1.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom1.Specialisation__c='Paint';
        insert ObjShowroom1;
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
        objShowroom2.Threashold__c = 10;
        objShowroom2.Backlogs__c = 2;
        objShowroom2.Daily_Assignment__c = 8;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = false; 
        objShowroom2.Monthly_Assignment__c = 8;
        objShowroom2.Monthly_Assignment_Limit__c = 10;
        objShowroom2.WT_Leads_Daily_Assignment__c = 0;
        objShowroom2.WT_Leads_Daily_Assignment_Limit__c = 100;
         objShowroom2.Specialisation__c='Paint';
        insert ObjShowroom2;
       List<Showroom_User__c> showroomUserList = new  List<Showroom_User__c>();
       
       list<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        List<String> toAddresses = new List<String>(); 
         toAddresses.add('testemail@test.com');
        mail.setToAddresses(toAddresses);
        mail.setSubject('No Im is active');
        Test.startTest();
        
      IronManPaintSpecialistScheduleEmail ss = new IronManPaintSpecialistScheduleEmail ();
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, ss);
        Test.stopTest();
}
}