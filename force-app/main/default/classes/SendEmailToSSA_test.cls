@isTest
public class SendEmailToSSA_test {
    @isTest static void send() {
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('System Administrator')]){
            profileData.put(obj.Name,obj.Id);
        }
        User wta_user = new User(alias = 'ozone12', email='oztdfsfdjkhjljlaest@homelane.com',
                emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('System Administrator'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='oztdfsfdjkhjljlaest@homelane.com');
        insert wta_user;
        
        List<Interior_Designer__c> intDesigner = new List<Interior_Designer__c>();
        Interior_Designer__c inte = new Interior_Designer__c();
        inte.Name = 'Test Int';
        inte.Email__c = 'test@google.com';
        inte.X0_4_Won_Opportunities__c = 1;
        inte.X4_8_Won_Opportunities__c = 2;
        inte.X8_Won_Opportunities__c = 3;
        inte.Total_Wins__c = 10;
        inte.Total_Opportunities__c = 50;
        inte.Available_at_Showroom__c = 'Test Showroom';
        inte.Property_Exp_Data__c = 'Test Showroom';
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
        inte2.Available_at_Showroom__c = 'Test Showroom';
        inte2.Property_Exp_Data__c = 'Test Showroom';
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
        inte3.Available_at_Showroom__c = 'Test Showroom';
        inte3.Property_Exp_Data__c = 'Test Showroom';
        inte3.City__c = 'Bengaluru';
      //  inte3.Languages_Known__c = 'Hindi';
        intDesigner.add(inte3);
        
        insert intDesigner;  
        System.debug('@@@@@@@  '+intDesigner);
        
        Master__c m = new Master__c();
        m.Name = 'Test Showroom';
        m.Type__c = 'Showroom';
        m.WalkIn_SSA__c = wta_user.Id;
        m.IsActive__c = true;
        insert m;  
        
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='New';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.email = 'sakf@dfjkc.com';
         leadRec1.phone = '6291029375';
         leadRec1.Budget_Range__c = '6L - 8L';
         leadRec1.Appointment_Type__c = 'Square Showroom Visit';
        System.debug('leadRec1 BEFORE insert--------- '+leadRec1);
         insert leadRec1;  
        System.debug('leadRec1 AFTER insert--------- '+leadRec1);
       
        Customer_Profiling_Session__c cx1 = new Customer_Profiling_Session__c();
        cx1.name = 'test';
        cx1.Answer_now_later__c = 'Answer Now';
        cx1.Appointment_Booked__c = 'Yes';
        cx1.Appointment_Date__c = date.today();
       // cx1.Appointment_Time__c = System.now();
        cx1.BR_1_Primary_User__c = 'test';
        cx1.BR_1_Study_Table__c = 'Glass Unit';
        cx1.BR_1_TV_Unit__c = 'Wall Paneling';
        cx1.BR_1_Wardrobe_Type__c = 'test';
        cx1.BR_2_Primary_User__c = 'test';
        cx1.BR_2_Study_Table__c = 'Glass Unit';
        cx1.BR_2_TV_Unit__c = 'Glass Unit';
        cx1.BR_2_Wardrobe_Type__c = 'test';
        cx1.BR_3_Primary_User__c = 'test';
        cx1.BR_3_Study_Table__c = 'Glass Unit';
        cx1.BR_3_TV_Unit__c = 'Glass Unit';
        cx1.BR_3_Wardrobe_Type__c = 'test';
        cx1.Family_members_age_traits__c = 'abc';
        cx1.Budget_Range__c = '1.5L - 4L';
        cx1.Feature_Preference_1__c = 'Storage and Ease of Use';
        cx1.Feature_Preference_2__c = 'Storage and Ease of Use';
        cx1.Feature_Preference_3__c = 'Storage and Ease of Use';
        cx1.First_home__c = 'Yes';
        cx1.Interiors_Required__c = 'Kitchen';
        cx1.Interior_Start_Date__c = Date.today();
        cx1.Kitchen_Accessories__c = 'abc';
        cx1.Kitchen_appliances__c = 'Hob and Chimney';
        cx1.Kitchen_Color__c = 'test';
        cx1.Kitchen_Finish__c = 'test';
        cx1.Kitchen_Layout__c = 'test';
        cx1.Kitchen_Material__c = 'test';
        cx1.Regional_Language_Preference__c = 'English';
        cx1.LR_Crockery__c = 'Simple';
        cx1.LR_Foyer__c = 'Seating';
        cx1.LR_Pooja__c = 'Attribute 1';
        cx1.LR_TV_Unit__c = 'Wall Paneling';
        cx1.Possession_Status__c = 'Yes';
        cx1.Possession_Date__c = date.today();
        
        cx1.Property_Config__c = 'Wall Paneling';
        cx1.Property__c = 'Wall Paneling';
        cx1.Property_Status__c = 'Wall Paneling';
        cx1.Property_Type__c = 'Wall Paneling';
        cx1.Purpose_of_Interiors__c = 'Rent out';
        cx1.Related_Lead__c = leadRec1.Id;
        cx1.Showroom__c = 'Rent out';
        cx1.Start_Source__c = 'Rent out';
        cx1.Style_Preference__c = 'Traditional';
        insert cx1;
        System.debug('CPS IS : '+cx1);
       
       leadRec1.Status='Appointment Fixed';
       leadRec1.Sub_Status__c ='Appointment Fixed';  
       leadRec1.Kitchen__c = 'Yes';
       leadRec1.Vanity_Unit__c = 'Yes';
       leadRec1.Utility_Unit__c = 'Yes';
       leadRec1.Crockery_Unit__c = 'Yes';
       leadRec1.Entertainment_Unit__c = 'Yes';
       leadRec1.Pooja__c = 'Yes';
       leadRec1.How_did_you_hear_about_us__c = 'Email';
       leadRec1.Study_Table_Book_Shelf__c = 'Yes';
       leadRec1.Foyer_Shoe_Rack__c = 'Yes';
       leadRec1.Interior_Start_Date__c = Date.Today();
       leadRec1.Square_Showroom_Manager__c = wta_user.Id;
       leadRec1.Appointment_Time__c = Date.today().addDays(2);
        leadRec1.Appointment_Venue_Square__c = m.Id;
        leadRec1.Possession_Date__c = date.today();
        leadRec1.Design_Q_Completed__c = 100;
        leadRec1.Property_Status__c = 'New';
        leadRec1.Property_Config__c = '1 BHK';
        leadRec1.Property__c = m.Id;
        leadRec1.Property_Type__c = 'Apartment';
        leadRec1.Interior_Designer__c = inte3.Id;
        System.debug('leadRec1 BEFORE update--------- '+leadRec1);
       update leadRec1;
        System.debug('leadRec1 AFTER update--------- '+leadRec1);
        
        List<String> strList = new List<String>();
        strList.add(wta_user.Email); 
        
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
        
          PageReference pref = Page.SendEmailToSSAPDF;
    pref.getParameters().put('id',leadRec1.Id);
        pref.getParameters().put('lang','English');
    Test.setCurrentPage(pref);
     Blob bodyy;
    
    bodyy = blob.valueof('TEST');
     
      //  SendEmailToSSA.attachment('a@a.com','a@a.com','a@a.com',leadRec1.Id,'a','a','a','aa','a','a','a','aa','a','a',strList);
        
      //  ApexPages.currentPage().getParameters().put('lang','English');
      //  ApexPages.currentPage().getParameters().put('family','abc');
      //  ApexPages.currentPage().getParameters().put('adstr',String.valueOf(date.today()));
     //   ApexPages.currentPage().getParameters().put('atstr',String.valueOf(System.now()));
      //  ApexPages.currentPage().getParameters().put('firstHome','Yes'); 
                
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('CustomerProfilingSessions.pdf');
            attach.setInline(false);
            attach.Body = bodyy; 
            
            
        Messaging.SingleEmailMessage Message = new Messaging.SingleEmailMessage(); 
        message.setTargetObjectId(UserInfo.getUserId());
        message.setSaveAsActivity(false);
        message.setSubject('dear diary');
        message.setPlainTextBody('he who controls the spice');
        message.toAddresses = strList;
        Messaging.sendEmail(new List<Messaging.Email>{Message}); 
        test.startTest();
        SendEmailToSSA s = new SendEmailToSSA();
      //  SendEmailToSSA.dummyTestCover();
        s.SendEmailButton();
        test.stopTest();
        
    }
    
     @isTest static void send2() {
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('System Administrator')]){
            profileData.put(obj.Name,obj.Id);
        }
        User wta_user = new User(alias = 'ozone12', email='oztdfsfdjkhjljlaest@homelane.com',
                emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('System Administrator'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='oztdfsfdjkhjljlaest@homelane.com');
        insert wta_user;
        
        List<Interior_Designer__c> intDesigner = new List<Interior_Designer__c>();
        Interior_Designer__c inte = new Interior_Designer__c();
        inte.Name = 'Test Int';
        inte.Email__c = 'test@google.com';
        inte.X0_4_Won_Opportunities__c = 1;
        inte.X4_8_Won_Opportunities__c = 2;
        inte.X8_Won_Opportunities__c = 3;
        inte.Total_Wins__c = 10;
        inte.Total_Opportunities__c = 50;
        inte.Available_at_Showroom__c = 'Test Showroom';
        inte.Property_Exp_Data__c = 'Test Showroom';
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
        inte2.Available_at_Showroom__c = 'Test Showroom';
        inte2.Property_Exp_Data__c = 'Test Showroom';
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
        inte3.Available_at_Showroom__c = 'Test Showroom';
        inte3.Property_Exp_Data__c = 'Test Showroom';
        inte3.City__c = 'Bengaluru';
         intDesigner.add(inte3);
        Interior_Designer__c inte4 = new Interior_Designer__c();
        inte4.Name = 'Test Int3';
        inte4.Email__c = 'test4@google.com';
        inte4.X0_4_Won_Opportunities__c = 7;
        inte4.X4_8_Won_Opportunities__c = 8;
        inte4.X8_Won_Opportunities__c = 9;
        inte4.Total_Wins__c = 8;
        inte4.Total_Opportunities__c = 50;
        inte4.Available_at_Showroom__c = 'Test Showroom';
        inte4.Property_Exp_Data__c = 'Test Showroom';
        inte4.City__c = 'Bengaluru';
         intDesigner.add(inte4);
         Interior_Designer__c inte5 = new Interior_Designer__c();
        inte5.Name = 'Test Int3';
        inte5.Email__c = 'test5@google.com';
        inte5.X0_4_Won_Opportunities__c = 7;
        inte5.X4_8_Won_Opportunities__c = 8;
        inte5.X8_Won_Opportunities__c = 9;
        inte5.Total_Wins__c = 8;
        inte5.Total_Opportunities__c = 50;
        inte5.Available_at_Showroom__c = 'Test Showroom';
        inte5.Property_Exp_Data__c = 'Test Showroom';
        inte5.City__c = 'Bengaluru';
        intDesigner.add(inte5);
        
        insert intDesigner;  
        System.debug('@@@@@@@  '+intDesigner);
        
        Master__c m = new Master__c();
        m.Name = 'Test Showroom';
        m.Type__c = 'Showroom';
        m.WalkIn_SSA__c = wta_user.Id;
         m.IsActive__c = true;
        insert m;  
        
         lead leadRec1 = new Lead();
         leadRec1.lastName='checking this';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='New';
         leadRec1.LeadSource = 'Google Ad';
         leadRec1.City='Bengaluru';
         leadRec1.email = 'sakf@dfjkc.com';
         leadRec1.phone = '6291029375';
         leadRec1.Budget_Range__c = '8L - 10L';
         leadRec1.Appointment_Type__c = 'Square Showroom Visit';
         leadRec1.Interior_Designer__c = inte4.Id;
        System.debug('leadRec1 BEFORE insert--------- '+leadRec1);
         insert leadRec1;  
        System.debug('leadRec1 AFTER insert--------- '+leadRec1);
       
        Customer_Profiling_Session__c cx1 = new Customer_Profiling_Session__c();
        cx1.name = 'test';
        cx1.Answer_now_later__c = 'Answer Now';
        cx1.Appointment_Booked__c = 'Yes';
        cx1.Appointment_Date__c = date.today();
       // cx1.Appointment_Time__c = System.now();
        cx1.BR_1_Primary_User__c = 'test';
        cx1.BR_1_Study_Table__c = 'Glass Unit';
        cx1.BR_1_TV_Unit__c = 'Wall Paneling';
        cx1.BR_1_Wardrobe_Type__c = 'test';
        cx1.BR_2_Primary_User__c = 'test';
        cx1.BR_2_Study_Table__c = 'Glass Unit';
        cx1.BR_2_TV_Unit__c = 'Glass Unit';
        cx1.BR_2_Wardrobe_Type__c = 'test';
        cx1.BR_3_Primary_User__c = 'test';
        cx1.BR_3_Study_Table__c = 'Glass Unit';
        cx1.BR_3_TV_Unit__c = 'Glass Unit';
        cx1.BR_3_Wardrobe_Type__c = 'test';
        cx1.Family_members_age_traits__c = 'abc';
        cx1.Budget_Range__c = '1.5L - 4L';
        cx1.Feature_Preference_1__c = 'Storage and Ease of Use';
        cx1.Feature_Preference_2__c = 'Storage and Ease of Use';
        cx1.Feature_Preference_3__c = 'Storage and Ease of Use';
        cx1.First_home__c = 'Yes';
        cx1.Interiors_Required__c = 'Kitchen';
        cx1.Interior_Start_Date__c = Date.today();
        cx1.Kitchen_Accessories__c = 'abc';
        cx1.Kitchen_appliances__c = 'Hob and Chimney';
        cx1.Kitchen_Color__c = 'test';
        cx1.Kitchen_Finish__c = 'test';
        cx1.Kitchen_Layout__c = 'test';
        cx1.Kitchen_Material__c = 'test';
        cx1.Regional_Language_Preference__c = 'English';
        cx1.LR_Crockery__c = 'Simple';
        cx1.LR_Foyer__c = 'Seating';
        cx1.LR_Pooja__c = 'Attribute 1';
        cx1.LR_TV_Unit__c = 'Wall Paneling';
        cx1.Possession_Status__c = 'Yes';
        cx1.Possession_Date__c = date.today();
        
        cx1.Property_Config__c = 'Wall Paneling';
        cx1.Property__c = 'Wall Paneling';
        cx1.Property_Status__c = 'Wall Paneling';
        cx1.Property_Type__c = 'Wall Paneling';
        cx1.Purpose_of_Interiors__c = 'Rent out';
        cx1.Related_Lead__c = leadRec1.Id;
        cx1.Showroom__c = 'Rent out';
        cx1.Start_Source__c = 'Rent out';
        cx1.Style_Preference__c = 'Traditional';
        insert cx1;
        System.debug('CPS IS : '+cx1);
       
       leadRec1.Status='Appointment Fixed';
       leadRec1.Sub_Status__c ='Appointment Fixed';  
       leadRec1.Kitchen__c = 'Yes';
       leadRec1.Vanity_Unit__c = 'Yes';
       leadRec1.Utility_Unit__c = 'Yes';
       leadRec1.Crockery_Unit__c = 'Yes';
       leadRec1.Entertainment_Unit__c = 'Yes';
       leadRec1.Pooja__c = 'Yes';
       leadRec1.How_did_you_hear_about_us__c = 'Email';
       leadRec1.Study_Table_Book_Shelf__c = 'Yes';
       leadRec1.Foyer_Shoe_Rack__c = 'Yes';
       leadRec1.Interior_Start_Date__c = Date.Today();
       leadRec1.Square_Showroom_Manager__c = wta_user.Id;
       leadRec1.Appointment_Time__c = Date.today().addDays(2);
        leadRec1.Appointment_Venue_Square__c = m.Id;
        leadRec1.Possession_Date__c = date.today();
        leadRec1.Design_Q_Completed__c = 100;
        leadRec1.Property_Status__c = 'New';
        leadRec1.Property_Config__c = '1 BHK';
        leadRec1.Property__c = m.Id;
        leadRec1.Property_Type__c = 'Apartment';
        leadRec1.Interior_Designer__c = inte3.Id;
        System.debug('leadRec1 BEFORE update--------- '+leadRec1);
       update leadRec1;
        System.debug('leadRec1 AFTER update--------- '+leadRec1);
         leadRec1.Interior_Designer__c = inte4.Id;
       update leadRec1;
        
        List<String> strList = new List<String>();
        strList.add(wta_user.Email); 
        
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
        
          PageReference pref = Page.SendEmailToSSAPDF;
    pref.getParameters().put('id',leadRec1.Id);
        pref.getParameters().put('lang','English');
    Test.setCurrentPage(pref);
     Blob bodyy;
    
    bodyy = blob.valueof('TEST');
    
      //  SendEmailToSSA.attachment('a@a.com','a@a.com','a@a.com',leadRec1.Id,'a','a','a','aa','a','a','a','aa','a','a',strList);
        
      //  ApexPages.currentPage().getParameters().put('lang','English');
      //  ApexPages.currentPage().getParameters().put('family','abc');
      //  ApexPages.currentPage().getParameters().put('adstr',String.valueOf(date.today()));
     //   ApexPages.currentPage().getParameters().put('atstr',String.valueOf(System.now()));
      //  ApexPages.currentPage().getParameters().put('firstHome','Yes'); 
                
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('CustomerProfilingSessions.pdf');
            attach.setInline(false);
            attach.Body = bodyy; 
            
            
        Messaging.SingleEmailMessage Message = new Messaging.SingleEmailMessage(); 
        message.setTargetObjectId(UserInfo.getUserId());
        message.setSaveAsActivity(false);
        message.setSubject('dear diary');
        message.setPlainTextBody('he who controls the spice');
        message.toAddresses = strList;
        Messaging.sendEmail(new List<Messaging.Email>{Message}); 
        test.startTest();
        SendEmailToSSA s = new SendEmailToSSA();
        SendEmailToSSA.dummyTestCover();
        s.SendEmailButton();
        test.stopTest();
        
    }
}