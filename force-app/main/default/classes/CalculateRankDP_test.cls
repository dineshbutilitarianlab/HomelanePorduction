@isTest
public class CalculateRankDP_test{ 
    public static testMethod void calculateRank(){
        Stack_DP_Rank__c stack = new Stack_DP_Rank__c();
        stack.Name = 'Stack DP';
        stack.Project_Score__c = 40;
        stack.Language_Score__c = 20;
        stack.New_Active_0_4__c = 10;
        stack.New_Active_4_8__c = 10;
        stack.New_Active_8__c = 10;
        stack.New_Active_Master__c = 10;
        stack.X10_40_score__c = 20;
        stack.Rank_for_Conversion_Percent__c = 10;
        stack.Rank_for_Won_Opp__c = 30;
        insert stack;
        
        List<Interior_Designer__c> intDesigner = new List<Interior_Designer__c>();
        Interior_Designer__c inte = new Interior_Designer__c();
        inte.Name = 'Test Int';
        inte.Email__c = 'test@google.com';
        inte.X0_4_Won_Opportunities__c = 1;
        inte.X4_8_Won_Opportunities__c = 2;
        inte.X8_Won_Opportunities__c = 3;
        inte.Total_Wins__c = 10;
        inte.Total_Opportunities__c = 50;
        inte.Available_at_Showroom__c = 'Test Showroom 2';
        inte.Property_Exp_Data__c = 'Kanakapura Showroom';
        inte.City__c = 'Bengaluru';
       // inte.Languages_Known__c = 'Hindi';
        intDesigner.add(inte);
        
        Interior_Designer__c inte2 = new Interior_Designer__c();
        inte2.Name = 'Test Int2';
        inte2.Email__c = 'test2@google.com';
        inte2.X0_4_Won_Opportunities__c = 4;
        inte2.X4_8_Won_Opportunities__c = 5;
        inte2.X8_Won_Opportunities__c = 6;
        inte2.Total_Wins__c = 9;
        inte2.Total_Opportunities__c = 50;
        inte2.Available_at_Showroom__c = 'Test Showroom 2';
        inte2.Property_Exp_Data__c = 'Kanakapura Showroom';
        inte2.City__c = 'Bengaluru';
      //  inte2.Languages_Known__c = 'Hindi';
        intDesigner.add(inte2);
        
        Interior_Designer__c inte3 = new Interior_Designer__c();
        inte3.Name = 'Test Int3';
        inte3.Email__c = 'test3@google.com';
        inte3.X0_4_Won_Opportunities__c = 7;
        inte3.X4_8_Won_Opportunities__c = 8;
        inte3.X8_Won_Opportunities__c = 9;
        inte3.Total_Wins__c = 8;
        inte3.Total_Opportunities__c = 50;
        inte3.Available_at_Showroom__c = 'Test Showroom 2';
        inte3.Property_Exp_Data__c = 'Kanakapura Showroom';
        inte3.City__c = 'Bengaluru';
      //  inte3.Languages_Known__c = 'Hindi';
        intDesigner.add(inte3);
        
        insert intDesigner;  
        System.debug('@@@@@@@  '+intDesigner);
        
        
        List<Master__c> master = new List<Master__c>();
        Master__c m = new Master__c();
        m.Name = 'Test Showroom';
        m.Type__c = 'Property';
        master.add(m);
        insert master;
        
        Master__c m1 = new Master__c();
        m1.Name = 'Test Showroom 2';
        m1.Type__c = 'Showroom';
        insert m1;
        
        
        List<Lead> leadList = new List<Lead>();
        lead newLead = new Lead();
        newLead.Email = 'test@test.com';
        newLead.lastName = 'Test';
        newLead.Phone = '1234567890';
        newLead.LeadSource = 'Google Ad';
        newLead.Status = 'Fresh Lead';
        newLead.Property__c = m.Id;
        newLead.Budget_Range__c = '1.5L - 4L';
        newLead.City = 'Bengaluru';
        newLead.Regional_Language_Preference__c = 'Hindi';
        newLead.Appointment_Venue_Square__c = m1.Id;
      //  newLead.Property__c = 'Test Showroom';
        leadList.add(newLead);
        
        lead newLead1 = new Lead();
        newLead1.Email = 'tes3t@test.com';
        newLead1.lastName = 'Test1';
        newLead1.Phone = '1234567800';
        newLead1.LeadSource = 'Google Ad';
        newLead1.Status = 'Fresh Lead';
        newLead1.Regional_Language_Preference__c = 'Hindi';
        newLead1.Property__c = m.Id;
        newLead1.Budget_Range__c = '4L - 6L';
        newLead1.City = 'Bengaluru'; 
        newLead1.Appointment_Venue_Square__c = m1.Id;    
       // newLead1.Property__c = 'Test Showroom';  
        leadList.add(newLead1);
        
        lead newLead2 = new Lead();
        newLead2.Email = 'te89t@test.com';
        newLead2.lastName = 'Test2';
        newLead2.Phone = '1234500000';
        newLead2.LeadSource = 'Google Ad';
        newLead2.Status = 'Fresh Lead';
        newLead2.Regional_Language_Preference__c = 'Hindi';
        newLead2.Property__c = m.Id;
        newLead2.Budget_Range__c = '8L - 10L';
        newLead2.City = 'Bengaluru';  
        newLead2.Appointment_Venue_Square__c = m1.Id;    
       // newLead2.Property__c = 'Test Showroom'; 
        leadList.add(newLead2);
        
        lead newLead3 = new Lead();
        newLead3.Email = 'te89245t@test.com';
        newLead3.lastName = 'Test3';
        newLead3.Phone = '1234567000';
        newLead3.LeadSource = 'Google Ad';
        newLead3.Status = 'Fresh Lead';
        newLead3.Regional_Language_Preference__c = 'Hindi';
        newLead3.Property__c = m.Id;
        newLead3.Budget_Range__c = 'Cx didn\'t disclose';
        newLead3.City = 'Bengaluru'; 
        newLead3.Appointment_Venue_Square__c = m1.Id;  
      //  newLead3.Property__c = 'Test Showroom';    
        leadList.add(newLead3);  
        
        insert leadList; 
        
        CalculateRankDPWrapper cal = new CalculateRankDPWrapper ();
        cal.recordId = inte.Id;
        cal.email = 'test@google.com';
        cal.project = 'Test Master';
        cal.language = 'English';
        cal.languageScore = 20;
        cal.projectScore = 40;
        cal.wonOpp = 1;
        cal.conversionScore = 10;
        cal.rankForConversion = 1;
        cal.conversionPercent = 30;
        cal.wonOppScore = 20;
        cal.rankForWonOpp = 1;
        cal.finalScore = 90;
        cal.finalRank = 1;  
       
       CalculateRankDPWrapper cal2 = new CalculateRankDPWrapper ();
        cal2.recordId = inte2.Id;
        cal2.email = 'test1@google.com';
        cal2.project = 'Test Master';
        cal2.language = 'English';
        cal2.languageScore = 20;
        cal2.projectScore = 40;
        cal2.wonOpp = 1;
        cal2.conversionScore = 10;
        cal2.rankForConversion = 1;
        cal2.conversionPercent = 30;
        cal2.wonOppScore = 10;
        cal2.rankForWonOpp = 1;
        cal2.finalScore = 80;
        cal2.finalRank = 2;        
        
        System.assertEquals(1, cal.finalRank);
        System.assertEquals(2, cal2.finalRank);     
       
       Test.startTest();
       PageReference pageRef = Page.DPButton;       
       Test.setCurrentPage(pageRef);
       pageRef.getParameters().put('id',newLead.id);
       ApexPages.StandardController sc = new ApexPages.standardController(newLead);
       CalculateRankDP  controller = new CalculateRankDP(sc);
       controller.CalculateRank(); 
        
       PageReference pageRef1 = Page.DPButton;       
       Test.setCurrentPage(pageRef1);
       pageRef1.getParameters().put('id',newLead1.id);
       ApexPages.StandardController sc1 = new ApexPages.standardController(newLead1);
       CalculateRankDP  controller1 = new CalculateRankDP(sc1);
       controller1.CalculateRank();
       
       PageReference pageRef2 = Page.DPButton;       
       Test.setCurrentPage(pageRef2);
       pageRef2.getParameters().put('id',newLead2.id);
       ApexPages.StandardController sc2 = new ApexPages.standardController(newLead2);
       CalculateRankDP  controller2 = new CalculateRankDP(sc2);
       controller2.CalculateRank();
       
       PageReference pageRef3 = Page.DPButton;       
       Test.setCurrentPage(pageRef3);
       pageRef3.getParameters().put('id',newLead3.id);
       ApexPages.StandardController sc3 = new ApexPages.standardController(newLead3);
       CalculateRankDP  controller3 = new CalculateRankDP(sc3);
       controller3.CalculateRank(); 
       Test.stopTest();

    }
       
}