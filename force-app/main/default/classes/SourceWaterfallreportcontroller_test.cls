@IsTest
public class SourceWaterfallreportcontroller_test{
    @isTest static void starttestSourceWaterfallreportcontroller() {
        Master__c mas = new Master__c();
        mas.Name = 'NewYork Showroom';
        mas.Type__c = 'Showroom';
        insert mas;
        
        List<Lead> toUpdate = new List<Lead>();
         lead h = new lead();
         h.LastName = 'TEST';
         h.Full_Name__c = 'test';
         h.Leadsource = 'Website';        
         h.city = 'Bengaluru';
         h.phone = '8899567876';
         h.Status='Fresh Lead';
         h.Email = 'abc@1.com';
         //h.Appointment_Venue_Square__c = mas.Id;
         h.Creation_Date__c = Date.Today();//Date.valueof('2017-05-27T00:24:09.000Z');
         toUpdate.add(h);
         
         lead hn = new lead();
         hn.LastName = 'AdityaSain';
         hn.Leadsource = 'Website';
         hn.city = 'Noida';
         hn.phone = '8899567877';
         hn.Status='Fresh Lead';
         hn.Email = 'abc@2.com';
         hn.Appointment_Venue_Square__c = mas.Id;
         hn.Creation_Date__c = Date.Today();//Date.valueof('2017-05-27T00:24:09.000Z');
         toUpdate.add(hn);
        
         lead h1 = new lead();
         h1.LastName = 'AdityaSin';
         h1.Leadsource = 'Website';
         h1.city = 'Hyderabad';
         h1.phone = '8899777878';
         h1.Status='Fresh Lead';
         h1.Email = 'abc@3.com';
         h1.Appointment_Venue_Square__c = mas.Id;
         h1.Creation_Date__c = Date.Today();//Date.valueof('2017-05-27T00:24:09.000Z');
         toUpdate.add(h1);
         
         lead h2 = new lead();
         h2.LastName = 'AdiaSain';
         h2.Leadsource = 'Website';
         h2.city = 'Mumbai';
         h2.phone = '8899564479';
         h2.Status='Fresh Lead';
         h2.Email = 'abc@4.com';
         h2.Appointment_Venue_Square__c = mas.Id;
         h2.Creation_Date__c = Date.Today();//Date.valueof('2017-05-27T00:24:09.000Z');
         toUpdate.add(h2);
         
         lead h3 = new lead();
         h3.LastName = 'AdityyyaSain';
         h3.Leadsource = 'Website';
         h3.city = 'Chennai';
         h3.phone = '8899567556';
         h3.Status='Fresh Lead';
         h3.Email = 'abc@5.com';
         h3.Appointment_Venue_Square__c = mas.Id;
         h3.Creation_Date__c = Date.Today();//Date.valueof('2017-05-27T00:24:09.000Z');
         toUpdate.add(h3);
         insert toUpdate;
         System.debug('**************  '+toUpdate.size());
         
         System.debug('@@@@@@@@@@@@@@  '+h.Test_Flag__c);
         System.debug('@@@@@@@@@@@@@@  '+hn.Test_Flag__c);
         System.debug('@@@@@@@@@@@@@@  '+h1.Test_Flag__c);
         
        Test.StartTest();
         
        SourceWaterfallreportcontroller controller = new SourceWaterfallreportcontroller();
        controller.selectedcity = 'Bengaluru'; 
        controller.getReportdata();
        controller.getYears();
        
        SourceWaterfallreportcontroller controller2 = new SourceWaterfallreportcontroller();
        controller2.selectedcity = 'NCR'; 
        controller2.getReportdata();
        controller2.getYears();
        
        SourceWaterfallreportcontroller controller3 = new SourceWaterfallreportcontroller();
        controller3.getReportdata();
        controller3.getYears();
        Test.StopTest();
          
          
   }
   
}