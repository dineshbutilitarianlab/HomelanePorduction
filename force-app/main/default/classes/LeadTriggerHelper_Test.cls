@isTest
public class LeadTriggerHelper_Test 
{
    public testMethod static void generateLeadScore() 
    {
        test.startTest();
        Id leadSourceScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Gold Plus Score Leads').getRecordTypeId();
        Id leadSignUpSourceScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Gold Score Leads').getRecordTypeId();
        Id leadPostalCodeScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Silver Score Leads').getRecordTypeId();
        Lead_Class_Scoring__c lcs = new Lead_Class_Scoring__c();
        lcs.Lead_Source_List__c ='bing';
        lcs.RecordTypeId=leadSourceScoreRTID;
        insert lcs;
        Account acc =new account();
        acc.Name ='Test Score acc';
        insert acc;
        Lead ld= new Lead();
        ld.Account__c= acc.id;
        ld.LeadSource='bing';
        ld.LastName='ldscore';
        ld.City='Bengaluru';
        ld.Status='Fresh Lead';
        Ld.Sub_Status__c='New';
        ld.Email='hdd@gmail.com';
        ld.Phone='9860578901';
        insert ld;
        Test.stopTest();
        
    }
    public testMethod static void generateLeadScore2() 
    {
        Test.startTest();
        Id leadSourceScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Gold Plus Score Leads').getRecordTypeId();
        Id leadSignUpSourceScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Gold Score Leads').getRecordTypeId();
        Id leadPostalCodeScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Silver Score Leads').getRecordTypeId();
        Lead_Class_Scoring__c lcs1 = new Lead_Class_Scoring__c();
        lcs1.Lead_Source_List__c ='Walk-In';
        lcs1.RecordTypeId=leadSourceScoreRTID;
        insert lcs1;
        Account acc =new account();
        acc.Name ='Test Score acc';
        insert acc;
        Lead ld= new Lead();
        ld.Account__c= acc.id;
        ld.LeadSource='Walk-In';
        ld.LastName='ldscore';
        ld.City='Bengaluru';
        ld.Status='Fresh Lead';
        Ld.Sub_Status__c='New';
        ld.Email='hdd@gmail.com';
        ld.Phone='9860578901';
        insert ld;
        Test.stopTest();
        
    }
    public testMethod static void generateLeadScore3() 
    {
        Test.startTest();
        Id leadSourceScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Gold Plus Score Leads').getRecordTypeId();
        Id leadSignUpSourceScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Gold Score Leads').getRecordTypeId();
        Id leadPostalCodeScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Silver Score Leads').getRecordTypeId();
        
        Lead_Class_Scoring__c lcs1 = new Lead_Class_Scoring__c();
        lcs1.Lead_Source_List__c ='Walk-In';
        lcs1.RecordTypeId=leadSourceScoreRTID;
        lcs1.City__c='Bengaluru';
        insert lcs1;
         Lead_Class_Scoring__c lcs = new Lead_Class_Scoring__c();
        lcs.Lead_Source_List__c ='bing';
        lcs.RecordTypeId=leadSignUpSourceScoreRTID;
        lcs.City__c='Bengaluru';
        insert lcs;
        
        Lead_Class_Scoring__c lcs2 = new Lead_Class_Scoring__c();
        lcs2.Lead_Source_List__c='instagram';
        //lcs2.Lead_and_Signup_List__c='google seo';
        lcs2.Pincode_List__c ='560109';
        lcs2.RecordTypeId=leadPostalCodeScoreRTID;
        lcs2.City__c='Bengaluru';
        insert lcs2;
        Account acc =new account();
        acc.Name ='Test Score acc';
        insert acc;
        Lead ld= new Lead();
        ld.Account__c= acc.id;
        ld.LeadSource='google seo';
        ld.LastName='ldscore';
        ld.City='Bengaluru';
        ld.Status='Fresh Lead';
        Ld.Sub_Status__c='New';
        ld.Email='hdd1@gmail.com';
        ld.Phone='9860578901';
        ld.Sign_Up_Source__c='Estimate Flow';
        insert ld;
        Test.stopTest();
        
    }
     public testMethod static void generateLeadScore4() 
     {
        Test.startTest();
        Id leadSourceScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Gold Plus Score Leads').getRecordTypeId();
        Id leadSignUpSourceScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Gold Score Leads').getRecordTypeId();
        Id  SilverRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Silver Score Leads').getRecordTypeId();
        Lead_Class_Scoring__c lcs = new Lead_Class_Scoring__c();
         lcs.Lead_Source_List__c='instagram';
        lcs.City__c='Bengaluru';
        lcs.RecordTypeId= SilverRTID;
        insert lcs;
         Lead_Class_Scoring__c lcs1 = new Lead_Class_Scoring__c();
        lcs1.Lead_Source_List__c ='Walk-In';
        lcs1.RecordTypeId=leadSourceScoreRTID;
        insert lcs1;
         Lead_Class_Scoring__c lcs2 = new Lead_Class_Scoring__c();
        lcs2.Lead_Source_List__c ='bing';
        lcs2.RecordTypeId=leadSignUpSourceScoreRTID;
         lcs.City__c='Bengaluru';
        insert lcs2;
        Account acc =new account();
        acc.Name ='Test Score acc';
        insert acc;
        Lead ld= new Lead();
        ld.Account__c= acc.id;
        ld.LeadSource='instagram';
        ld.LastName='ldscore';
        ld.City='Bengaluru';
        ld.Status='Fresh Lead';
        Ld.Sub_Status__c='New';
        ld.Email='hdd@gmail.com';
        ld.Phone='9860578901';
        //ld.Sign_Up_Source__c='Estimate Flow';
        //ld.PostalCode='560109';
        insert ld;
        Test.stopTest();
        
    }
    public testMethod static void generateLeadScore5() 
    {
        Test.startTest();
        Id  SilverRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Silver_RECID).getRecordTypeId();
        Id  SilverMinusRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Silver_Minus_RECID).getRecordTypeId();
        Id  BronzePlusRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Bronze_Plus_RECID).getRecordTypeId();
        Lead_Class_Scoring__c lcs = new Lead_Class_Scoring__c();
         
        lcs.LeadSource_Pincode_List__c='560008;Facebook Ad';
        lcs.RecordTypeId=SilverMinusRTID ;
        lcs.City__c='Bengaluru';
        insert lcs;
         
        Account acc =new account();
        acc.Name ='Test Score acc';
        insert acc;
        Lead ld= new Lead();
        ld.Account__c= acc.id;
        ld.LeadSource='Facebook Ad';
        ld.LastName='ldscore';
        ld.City='Bengaluru';
        ld.Status='Fresh Lead';
        Ld.Sub_Status__c='New';
        ld.Email='hdd@gmail.com';
        ld.Phone='9860578901';
        
        //ld.Sign_Up_Source__c='Estimate Flow';
        ld.PostalCode='560008';
        insert ld;
        
        ld=[select id,OTP_Verified__c from Lead where id=:ld.id];
        ld.OTP_Verified__c =true;
        update ld;
        Test.stopTest();
        
    }
    public testMethod static void generateLeadScore6() 
    {
        Test.startTest();
        Id  SilverRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Silver_RECID).getRecordTypeId();
        Id  SilverMinusRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Silver_Minus_RECID).getRecordTypeId();
        Id  BronzePlusRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Bronze_Plus_RECID).getRecordTypeId();
        Lead_Class_Scoring__c lcs = new Lead_Class_Scoring__c();
         
        lcs.LeadSource_Pincode_List__c='560008;Facebook Ad';
        lcs.RecordTypeId=SilverMinusRTID ;
        lcs.City__c='Bengaluru';
        insert lcs;
         
        Account acc =new account();
        acc.Name ='Test Score acc';
        insert acc;
        Lead ld= new Lead();
        ld.Account__c= acc.id;
        ld.LeadSource='SEO';
        ld.LastName='ldscore';
        ld.City='Bengaluru';
        ld.Status='Fresh Lead';
        Ld.Sub_Status__c='New';
        ld.Email='hdd@gmail.com';
        ld.Phone='9860578901';
        
        //ld.Sign_Up_Source__c='Estimate Flow';
        ld.PostalCode='123456';
        insert ld;
        
        ld=[select id,OTP_Verified__c,Property_Status__c,Green_Lead_class__c,Lead_Score_for_Assignment__c,Budget_Range__c,Is_Blitz_builder_lead__c,Bulk_Upload__c,City from Lead where id=:ld.id];
        ld.OTP_Verified__c =true;
        ld.Meeting_Source__c='Customer';
        ld.Property_Status__c ='Renovation';
        ld.Status ='Pre-Appointment';
        ld.Sub_Status__c='Pre-Appointment';
        ld.Kitchen__c='yes';
        ld.Interior_Start_Date__c=system.today();
        ld.Entertainment_Unit__c='yes';
        ld.Utility_Unit__c='yes';
        ld.Study_Table_Book_Shelf__c='yes';
        ld.Foyer_Shoe_Rack__c='yes';
        ld.Crockery_Unit__c='yes';
        ld.Property_Config__c='1 BHK';
        ld.Budget_Range__c='Upto 1.5L';
        ld.Preferred_Appointment_Slot__c = System.today() + 1;
        ld.LeadSource = 'Walk-In';
        update ld;
        List<lead> listOfLeads = new list<lead>();
        listOfLeads.add(ld);
        
        LeadTriggerHelper.setGreenLeadScore(listOfLeads);
        Test.stopTest();
        
    }
    public testMethod static void generateLeadScore7() 
    {
        Test.startTest();
        Id GoldPlusRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Gold_Plus_RECID).getRecordTypeId();
        Id GoldRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Gold_RECID).getRecordTypeId();
        Id  SilverRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Silver_RECID).getRecordTypeId();
        Id  SilverMinusRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Silver_Minus_RECID).getRecordTypeId();
        Id  BronzePlusRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Bronze_Plus_RECID).getRecordTypeId();
        Lead_Class_Scoring__c lcs = new Lead_Class_Scoring__c();
         
     //   lcs.PreAppointment_Lead_Source_List__c='Paid Search';
        lcs.RecordTypeId = SilverRTID  ;
        lcs.City__c='Bengaluru';
        lcs.Paid_Search_Campaign_List__c = '_Brand';
        insert lcs;
        
        Lead_Class_Scoring__c lcs2 = new Lead_Class_Scoring__c();
        lcs2.RecordTypeId = GoldRTID  ;
        lcs2.discovery_OTP_Campaign_List__c = '_ID';
        insert lcs2;
         
        Account acc =new account();
        acc.Name ='Test Score acc';
        insert acc;
        Lead ld= new Lead();
        ld.Account__c= acc.id;
        ld.LeadSource='Paid Search';
        ld.LastName='ldscore';
        ld.City='Bengaluru';
        ld.Status='Fresh Lead';
        Ld.Sub_Status__c='New';
        ld.Email='hdd@gmail.com';
        ld.Phone='9860578901';
        ld.Utm_Campaign__c = 'test_Brand';
        ld.LeadSource = 'HomeLane';
        //ld.Sign_Up_Source__c='Estimate Flow';
        ld.PostalCode='123456';
        insert ld;
        
        ld=[select id,OTP_Verified__c,Property_Status__c,Green_Lead_class__c,Lead_Score_for_Assignment__c,Budget_Range__c,Is_Blitz_builder_lead__c,Bulk_Upload__c,LeadSource,PostalCode,City from Lead where id=:ld.id];
        //ld.OTP_Verified__c =true;
        ld.Meeting_Source__c='Customer';
        //ld.Property_Status__c ='Renovation';
        ld.Status ='Pre-Appointment';
        ld.Sub_Status__c='Pre-Appointment';
        ld.Kitchen__c='yes';
        ld.Interior_Start_Date__c=system.today();
        ld.Entertainment_Unit__c='yes';
        ld.Utility_Unit__c='yes';
        ld.Study_Table_Book_Shelf__c='yes';
        ld.Foyer_Shoe_Rack__c='yes';
        ld.Crockery_Unit__c='yes';
        ld.Property_Config__c='1 BHK';
        ld.Budget_Range__c='Upto 1.5L';
        ld.Preferred_Appointment_Slot__c = System.today() + 1;
        ld.Utm_Campaign__c = 'test_ID';
        update ld;
        List<lead> listOfLeads = new list<lead>();
        listOfLeads.add(ld);
        
        LeadTriggerHelper.setGreenLeadScore(listOfLeads);
        Test.stopTest();
        
    }
    
    public testMethod static void generateLeadScore8() 
    {
        Test.startTest();
         Id GoldRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Gold_RECID).getRecordTypeId();
       	 Id  SilverRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Silver_RECID).getRecordTypeId();
         
        Lead_Class_Scoring__c lcs = new Lead_Class_Scoring__c();
         
        lcs.RecordTypeId = SilverRTID  ;
        lcs.City__c='Bengaluru';
        lcs.Facebook_Ad_Campaign_List__c = '_Others';
        insert lcs;
        
        Lead_Class_Scoring__c lcs2 = new Lead_Class_Scoring__c();
        lcs2.RecordTypeId = GoldRTID  ;
        lcs2.Facebook_Ad_OTP_Campaign_List__c = '_any';        
        insert lcs2;
         
        Account acc =new account();
        acc.Name ='Test Score acc';
        insert acc;
        Lead ld= new Lead();
        ld.Account__c= acc.id;
        ld.LeadSource='Facebook Ad';
        ld.LastName='ldscore';
        ld.City='Salem';
        ld.Status='Fresh Lead';
        Ld.Sub_Status__c='New';
        ld.Email='hdd@gmail.com';
        ld.Phone='9860578901';
        ld.Utm_Campaign__c = 'test_Others';
        ld.Sign_Up_Source__c='WhatsAppHaptik';
        
        //ld.Sign_Up_Source__c='Estimate Flow';
        ld.PostalCode='123456';
        insert ld;
        
        Master__c master2=new master__c(Name='Gopalan Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',Type__c='Showroom',IsActive__c=true);
        insert master2;
        
        ld=[select id,OTP_Verified__c,Property_Status__c,Green_Lead_class__c,Lead_Score_for_Assignment__c,Budget_Range__c,Is_Blitz_builder_lead__c,Bulk_Upload__c,LeadSource,PostalCode,City from Lead where id=:ld.id];
        ld.OTP_Verified__c =true;
        ld.Meeting_Source__c='Customer';
        //ld.Property_Status__c ='Renovation';
        ld.Status ='WhatsApp Pre-Appointment';
        ld.Sub_Status__c='WhatsApp Pre-Appointment';
        ld.Kitchen__c='yes';
        ld.Interior_Start_Date__c=system.today();
        ld.Entertainment_Unit__c='yes';
        ld.Utility_Unit__c='yes';
        ld.Study_Table_Book_Shelf__c='yes';
        ld.Foyer_Shoe_Rack__c='yes';
        ld.Crockery_Unit__c='yes';
        ld.Property_Config__c='1 BHK';
        ld.Budget_Range__c='Upto 1.5L';
      //  ld.Preferred_Appointment_Slot__c = System.today() + 1;
        ld.Utm_Campaign__c = 'test_any';
        ld.Appointment_Type__c ='Others';
        ld.Appointment_Venue_Square__c=master2.Id;
        ld.Appointment_Time__c = System.now() + 1;
        ld.Preferred_Appointment_Slot__c = System.now() + 1;
        update ld;
        List<lead> listOfLeads = new list<lead>();
        listOfLeads.add(ld);
        
        LeadTriggerHelper.setGreenLeadScore(listOfLeads);
        Test.stopTest();
        
    }
    
    public testMethod static void generateLeadScore9() 
    {
        Test.startTest();
         Id GoldRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Gold_RECID).getRecordTypeId();
       	 Id  SilverRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Silver_RECID).getRecordTypeId();
         
        Lead_Class_Scoring__c lcs = new Lead_Class_Scoring__c();
         
        lcs.RecordTypeId = SilverRTID  ;
        lcs.City__c='Bengaluru';
        lcs.discovery_Campaign_List__c = '_MK';
        insert lcs;
       
        Account acc =new account();
        acc.Name ='Test Score acc';
        insert acc;
        Lead ld= new Lead();
        ld.Account__c= acc.id;
        ld.LeadSource='discovery';
        ld.LastName='ldscore';
        ld.City='Bengaluru';
        ld.Status='Fresh Lead';
        Ld.Sub_Status__c='New';
        ld.Email='hdd@gmail.com';
        ld.Phone='9860578901';
        ld.Utm_Campaign__c = 'test_MK';
        
        //ld.Sign_Up_Source__c='Estimate Flow';
        ld.PostalCode='123456';
        insert ld;
        
        ld=[select id,OTP_Verified__c,Property_Status__c,Green_Lead_class__c,Lead_Score_for_Assignment__c,Budget_Range__c,Is_Blitz_builder_lead__c,Bulk_Upload__c,LeadSource,PostalCode,City from Lead where id=:ld.id];
        ld.OTP_Verified__c =true;
        ld.Meeting_Source__c='Customer';
        //ld.Property_Status__c ='Renovation';
        ld.Status ='Pre-Appointment';
        ld.Sub_Status__c='Pre-Appointment';
        ld.City='Hyderabad';
        ld.Kitchen__c='yes';
        ld.Interior_Start_Date__c=system.today();
        ld.Entertainment_Unit__c='yes';
        ld.Utility_Unit__c='yes';
        ld.Study_Table_Book_Shelf__c='yes';
        ld.Foyer_Shoe_Rack__c='yes';
        ld.Crockery_Unit__c='yes';
        ld.Property_Config__c='1 BHK';
        ld.Budget_Range__c='Upto 1.5L';
        ld.Preferred_Appointment_Slot__c = System.today() + 1;
        ld.Utm_Campaign__c = 'test_any';
        update ld;
        List<lead> listOfLeads = new list<lead>();
        listOfLeads.add(ld);
        
        LeadTriggerHelper.setGreenLeadScore(listOfLeads);
        Test.stopTest();
        
    }
    
    public testMethod static void generateLeadScore10() 
    {
        Test.startTest();
         Id GoldRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Gold_RECID).getRecordTypeId();
       	 Id  SilverRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Silver_RECID).getRecordTypeId();
         
        Lead_Class_Scoring__c lcs = new Lead_Class_Scoring__c();
         
        lcs.RecordTypeId = SilverRTID  ;
        lcs.City__c='New Delhi';
        lcs.discovery_OTP_Campaign_List__c = '_MK';
        insert lcs;
       
        Account acc =new account();
        acc.Name ='Test Score acc';
        insert acc;
        Lead ld= new Lead();
        ld.Account__c= acc.id;
        ld.LeadSource='discovery';
        ld.LastName='ldscore';
        ld.City='New Delhi';
        ld.Status='Fresh Lead';
        Ld.Sub_Status__c='New';
        ld.Email='hdd@gmail.com';
        ld.Phone='9860578901';
        ld.Utm_Campaign__c = 'test_MK';
        
        //ld.Sign_Up_Source__c='Estimate Flow';
        ld.PostalCode='123456';
        insert ld;
        
        ld=[select id,OTP_Verified__c,Property_Status__c,Green_Lead_class__c,Lead_Score_for_Assignment__c,Budget_Range__c,Is_Blitz_builder_lead__c,Bulk_Upload__c,LeadSource,PostalCode,City from Lead where id=:ld.id];
        ld.OTP_Verified__c =true;
        ld.Meeting_Source__c='Customer';
        //ld.Property_Status__c ='Renovation';
        ld.Status ='Pre-Appointment';
        ld.Sub_Status__c='Pre-Appointment';
        ld.City='New Delhi';
        ld.Kitchen__c='yes';
        ld.Interior_Start_Date__c=system.today();
        ld.Entertainment_Unit__c='yes';
        ld.Utility_Unit__c='yes';
        ld.Study_Table_Book_Shelf__c='yes';
        ld.Foyer_Shoe_Rack__c='yes';
        ld.Crockery_Unit__c='yes';
        ld.Property_Config__c='1 BHK';
        ld.Budget_Range__c='4L - 8L';
        ld.Preferred_Appointment_Slot__c = System.today() + 1;
        ld.Utm_Campaign__c = 'test_MK';
        update ld;
        List<lead> listOfLeads = new list<lead>();
        listOfLeads.add(ld);
        
        LeadTriggerHelper.setGreenLeadScore(listOfLeads);
        Test.stopTest();
        
    }
    
    public testMethod static void generateLeadScore11() 
    {
        Test.startTest();
         Id GoldRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Gold_RECID).getRecordTypeId();
       	 Id  SilverRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Silver_RECID).getRecordTypeId();
         
        Lead_Class_Scoring__c lcs = new Lead_Class_Scoring__c();
         
        lcs.RecordTypeId = SilverRTID  ;
        lcs.City__c='Bengaluru';
        lcs.Facebook_Ad_OTP_Campaign_List__c = '_MK';
        insert lcs;
       
        Account acc =new account();
        acc.Name ='Test Score acc';
        insert acc;
        Lead ld= new Lead();
        ld.Account__c= acc.id;
        ld.LeadSource='Facebook Ad';
        ld.LastName='ldscore';
        ld.City='Salem';
        ld.Status='Fresh Lead';
        Ld.Sub_Status__c='New';
        ld.Email='hdd@gmail.com';
        ld.Phone='9860578901';
        ld.Utm_Campaign__c = 'test_MK';
        
        //ld.Sign_Up_Source__c='Estimate Flow';
        ld.PostalCode='123456';
        insert ld;
        
        ld=[select id,OTP_Verified__c,Property_Status__c,Green_Lead_class__c,Lead_Score_for_Assignment__c,Budget_Range__c,Is_Blitz_builder_lead__c,Bulk_Upload__c,LeadSource,PostalCode,City from Lead where id=:ld.id];
        ld.OTP_Verified__c =true;
        ld.Meeting_Source__c='Customer';
        //ld.Property_Status__c ='Renovation';
        ld.Status ='Pre-Appointment';
        ld.Sub_Status__c='Pre-Appointment';
        ld.City='Salem';
        ld.Kitchen__c='yes';
        ld.Interior_Start_Date__c=system.today();
        ld.Entertainment_Unit__c='yes';
        ld.Utility_Unit__c='yes';
        ld.Study_Table_Book_Shelf__c='yes';
        ld.Foyer_Shoe_Rack__c='yes';
        ld.Crockery_Unit__c='yes';
        ld.Property_Config__c='1 BHK';
        ld.Budget_Range__c='4L - 8L';
        ld.Preferred_Appointment_Slot__c = System.today() + 1;
        ld.Utm_Campaign__c = 'test_MK';
        update ld;
        List<lead> listOfLeads = new list<lead>();
        listOfLeads.add(ld);
        
        LeadTriggerHelper.setGreenLeadScore(listOfLeads);
        Test.stopTest();
        
    }
}