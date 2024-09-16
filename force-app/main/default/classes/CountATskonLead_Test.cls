@isTest
public class CountATskonLead_Test{
    
    static testMethod void countTaskonLead3(){
        test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Call_Attempts__c objCallAttemps = new Call_Attempts__c();
        objCallAttemps.Number_of_Calls__c = 1;
        objCallAttemps.Name = 'Lead Calls';
        insert objCallAttemps;
        
        ByPassValidation__c mc = new ByPassValidation__c();
        mc.isTrue__c=true;
        insert mc;
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
         User wta_user = new User(alias = 'ameyo', email='ameyousertest@homelane.com',
                emailencodingkey='UTF-8', lastname='Cloud Agent',Cloud_Agent_Campaign_Name__c = 'abc', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertest@homelane.com');
        insert wta_user;
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Noida';
        insert objRA;
        system.RunAs(wta_user){
        lead leadRec1=leadUtil_Test.insertLead('parinitha@gmail.com','1234567899');
         leadRec1.PostalCode='561284';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.WT_Agent__c = wta_user.Id;
         leadRec1.Ameyo_Call_Attempts__c = 1;
         leadRec1.Attempts_since_last_connection__c = 10;
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.leadSource = 'Toll-free';
         insert leadRec1;
         system.debug('---------Test Class Lead Owner--------'+leadRec1.OwnerId);
         
             Whatsapp_Message__c w = new Whatsapp_Message__c();
        w.Name='WA - Unable to Contact';
            w.Lead__c=leadRec1.Id;
        insert w;
            
        Task t1=new Task();
        t1.subject='Follow Up';
        t1.OwnerId=leadRec1.OwnerId;
        t1.Priority='Normal';
        t1.Status='Open';
        t1.WhoId=leadRec1.Id;
        t1.CallDisposition = 'Follow_Up_Later';
        insert t1;
          //  t1.UUI__c = String.valueOf(w.Id);
        update t1;
        }
        test.stopTest();
    }
    
    static testMethod void countTaskonLead4(){
        test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Call_Attempts__c objCallAttemps = new Call_Attempts__c();
        objCallAttemps.Number_of_Calls__c = 1;
        objCallAttemps.Name = 'Lead Calls';
        insert objCallAttemps;
        
        ByPassValidation__c mc = new ByPassValidation__c();
        mc.isTrue__c=true;
        insert mc;
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
         User wta_user = new User(alias = 'ameyo', email='ameyousertest@homelane.com',
                emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',Cloud_Agent_Campaign_Name__c = 'abc',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertest@homelane.com');
        insert wta_user;
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Noida';
        insert objRA;
        system.RunAs(wta_user){
        lead leadRec1=leadUtil_Test.insertLead('parinitha@gmail.com','1234567899');
         leadRec1.PostalCode='561284';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='New';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.WT_Agent__c = wta_user.Id;
         leadRec1.Ameyo_Call_Attempts__c = 1;
         leadRec1.Attempts_since_last_connection__c = 10;
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.leadSource = 'Toll-free';
         insert leadRec1;
         system.debug('---------Test Class Lead Owner--------'+leadRec1.OwnerId);
         
             Whatsapp_Message__c w = new Whatsapp_Message__c();
        w.Name='WA - Unable to Contact';
            w.Lead__c=leadRec1.Id;
        insert w;
            
        Task t1=new Task();
        t1.subject='Follow Up';
        t1.OwnerId=leadRec1.OwnerId;
        t1.Priority='Normal';
        t1.Status='Open';
        t1.WhoId=leadRec1.Id;
        t1.Disposition_Type__c = 'Dead Lead';
        insert t1;
        //   t1.UUI__c = String.valueOf(w.Id);
        update t1;
        }
        test.stopTest();
    }
    
    static testMethod void countTaskonLead5(){
        test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Call_Attempts__c objCallAttemps = new Call_Attempts__c();
        objCallAttemps.Number_of_Calls__c = 1;
        objCallAttemps.Name = 'Lead Calls';
        insert objCallAttemps;
        
        ByPassValidation__c mc = new ByPassValidation__c();
        mc.isTrue__c=true;
        insert mc;
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
         User wta_user = new User(alias = 'ameyo', email='ameyousertest@homelane.com',
                emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US',Cloud_Agent_Campaign_Name__c = 'abc', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertest@homelane.com');
        insert wta_user;
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Noida';
        insert objRA;
        system.RunAs(wta_user){
        lead leadRec1=leadUtil_Test.insertLead('parinitha@gmail.com','1234567899');
         leadRec1.PostalCode='561284';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='New';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.WT_Agent__c = wta_user.Id;
         leadRec1.Ameyo_Call_Attempts__c = 1;
         leadRec1.Attempts_since_last_connection__c = 10;
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.leadSource = 'Toll-free';
         insert leadRec1;
         system.debug('---------Test Class Lead Owner--------'+leadRec1.OwnerId);
         
             Whatsapp_Message__c w = new Whatsapp_Message__c();
        w.Name='WA - Unable to Contact';
            w.Lead__c=leadRec1.Id;
        insert w;
            
        Task t1=new Task();
        t1.subject='Follow Up';
        t1.OwnerId=leadRec1.OwnerId;
        t1.Priority='Normal';
        t1.Status='Open';
        t1.WhoId=leadRec1.Id;
        t1.Disposition_Type__c = 'Couldn\'t Contact';
          //  t1.UUI__c = String.valueOf(w.Id);
        insert t1;
        update t1;
        }
        test.stopTest();
    }
    
    static testMethod void countTaskonLead6(){
        test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Call_Attempts__c objCallAttemps = new Call_Attempts__c();
        objCallAttemps.Number_of_Calls__c = 1;
        objCallAttemps.Name = 'Lead Calls';
        insert objCallAttemps;
        
        ByPassValidation__c mc = new ByPassValidation__c();
        mc.isTrue__c=true;
        insert mc;
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
         User wta_user = new User(alias = 'ameyo', email='ameyousertest@homelane.com',
                emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US', Cloud_Agent_Campaign_Name__c = 'abc',profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertest@homelane.com');
        insert wta_user;
        
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Noida';
        insert objRA;
       
       system.RunAs(wta_user){
        lead leadRec1=leadUtil_Test.insertLead('parinitha@gmail.com','1234567899');
         leadRec1.PostalCode='561284';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Call back in 2 hrs';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.WT_Agent__c = wta_user.Id;
         leadRec1.Ameyo_Call_Attempts__c = 1;
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.leadSource = 'Toll-free';
         insert leadRec1;
         system.debug('---------Test Class Lead Owner--------'+leadRec1.OwnerId);
         
            Whatsapp_Message__c w = new Whatsapp_Message__c();
        w.Name='WA - Unable to Contact';
           w.Lead__c=leadRec1.Id;
        insert w;
           
        Task t1=new Task();
        t1.subject='Follow Up - 123';
        t1.monitorUCID__c = '123';
        t1.OwnerId=leadRec1.OwnerId;
        t1.Priority='Normal';
        t1.Status='Open';
        t1.WhoId=leadRec1.Id;
        t1.Disposition_Type__c = 'Couldn\'t Contact';
           t1.UUI__c = String.valueOf(w.Id);
            t1.AgentStatus__c = 'abcd';
            t1.CustomerStatus__c = 'abc';
            t1.callDisposition = 'abc';
        insert t1;
        update t1;
        }
        test.stopTest();
    }  
    
    static testMethod void countTaskonLead7(){
        test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Call_Attempts__c objCallAttemps = new Call_Attempts__c();
        objCallAttemps.Number_of_Calls__c = 1;
        objCallAttemps.Name = 'Lead Calls';
        insert objCallAttemps;
        
        ByPassValidation__c mc = new ByPassValidation__c();
        mc.isTrue__c=true;
        insert mc;
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
         User wta_user = new User(alias = 'ameyo', email='ameyousertest@homelane.com',
                emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US',Cloud_Agent_Campaign_Name__c = 'abc', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertest@homelane.com');
        insert wta_user;
        
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Noida';
        insert objRA;
       
       system.RunAs(wta_user){
        lead leadRec1=leadUtil_Test.insertLead('parinitha@gmail.com','1234567899');
         leadRec1.PostalCode='561284';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Call back in 2 hrs';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.WT_Agent__c = wta_user.Id;
         leadRec1.Ameyo_Call_Attempts__c = 1;
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.leadSource = 'Toll-free';
         insert leadRec1;
         system.debug('---------Test Class Lead Owner--------'+leadRec1.OwnerId);
         
            Whatsapp_Message__c w = new Whatsapp_Message__c();
        w.Name='WA - Unable to Contact';
           w.Lead__c=leadRec1.Id;
        insert w;
           
        Task t1=new Task();
        t1.subject='Follow Up - 123';
        t1.monitorUCID__c = '123';
        t1.OwnerId=leadRec1.OwnerId;
        t1.Priority='Normal';
        t1.Status='Open';
        t1.WhoId=leadRec1.Id;
        t1.Disposition_Type__c = 'Couldn\'t Contact';
         /*  t1.UUI__c = String.valueOf(w.Id);
            t1.AgentStatus__c = 'abcd';
            t1.CustomerStatus__c = 'abc';
            t1.callDisposition = 'abc';*/
        insert t1;
        update t1;
        }
        test.stopTest();
    }
    
    static testMethod void countTaskonLead8(){
        test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Call_Attempts__c objCallAttemps = new Call_Attempts__c();
        objCallAttemps.Number_of_Calls__c = 1;
        objCallAttemps.Name = 'Lead Calls';
        insert objCallAttemps;
        
        ByPassValidation__c mc = new ByPassValidation__c();
        mc.isTrue__c=true;
        insert mc;
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
         User wta_user = new User(alias = 'ameyo', email='ameyousertest@homelane.com',
                emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US',Cloud_Agent_Campaign_Name__c = 'abc', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertest@homelane.com');
        insert wta_user;
        
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Noida';
        insert objRA;
        
         Master__c m = new Master__c(type__c='Showroom',name='Gopalan Showroom');
        insert m;
       lead leadRec1;
       system.RunAs(wta_user){
         leadRec1=leadUtil_Test.insertLead('parinitha@gmail.com','1234567899');
         leadRec1.PostalCode='561284';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Call back in 2 hrs';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.WT_Agent__c = wta_user.Id;
         leadRec1.Ameyo_Call_Attempts__c = 1;
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.leadSource = 'Toll-free';
         insert leadRec1;
           System.debug('leadRec1.Owner.Name  '+leadRec1.Owner.Name);
         system.debug('---------Test Class Lead Owner--------'+leadRec1.OwnerId);
       }   
        leadRec1.Status='Appointment Fixed';
           leadRec1.Sub_Status__c ='Appointment Fixed';
        //   leadRec1.OwnerId = wta_user.Id;
      //   leadRec1.WT_Agent__c = wta_user.Id;
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.LeadSource='website';
        leadRec1.Vanity_Unit__c='Yes';
        leadRec1.Wardrobes__c='1';
        leadRec1.Utility_Unit__c='Yes';
        leadRec1.Study_Table_Book_Shelf__c='Yes';
        leadRec1.Property__c=m.Id;
        leadRec1.Appointment_Type__c = 'Square Showroom Visit';
       leadRec1.City = 'Bengaluru';
       leadRec1.Interior_Start_Date__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Property_Type__c  = 'Villa';
       leadRec1.Property_Config__c = '1 BHK';
       leadRec1.Property_Status__c = 'New';
       leadRec1.Property_Move_In_Date__c= Date.valueOf('2019-12-06T00:00:00.000Z');
       leadRec1.Kitchen__c = 'Yes';
       leadRec1.Vanity_Unit__c = 'Yes';
       leadRec1.Utility_Unit__c = 'Yes';
       leadRec1.Crockery_Unit__c = 'Yes';
       leadRec1.Entertainment_Unit__c = 'Yes';
       leadRec1.Pooja__c = 'Yes';
       leadRec1.How_did_you_hear_about_us__c = 'Email';
       leadRec1.Study_Table_Book_Shelf__c = 'Yes';
       leadRec1.Foyer_Shoe_Rack__c = 'Yes';
       leadRec1.Appointment_Time__c = System.now();
       leadRec1.Time_of_Actual_Appointment_Start__c = Date.valueOf('2017-12-06T00:00:00.000Z');  
       leadRec1.Appointment_Venue_Square__c = m.Id;
       leadRec1.Possession_Date__c = Date.valueOf('2019-12-06T00:00:00.000Z');  
       leadRec1.Whatsapp_UCL_Call_Attempts_Chk__c = false;
           System.debug('leadRec1.Owner.Name  '+leadRec1.Owner.Name);
           update leadRec1;
         
            Whatsapp_Message__c w = new Whatsapp_Message__c();
        w.Name='WA - Unable to Contact';
           w.Lead__c=leadRec1.Id;
        insert w;
           
        Task t1=new Task();
        t1.subject='Follow Up - 123';
        t1.monitorUCID__c = '123';
        t1.OwnerId=leadRec1.OwnerId;
        t1.Priority='Normal';
        t1.Status='Open';
        t1.WhoId=leadRec1.Id;
        t1.Disposition_Type__c = 'Couldn\'t Contact';
           t1.UUI__c = String.valueOf(w.Id);
            t1.AgentStatus__c = 'abcd';
            t1.CustomerStatus__c = 'abc';
            t1.callDisposition = 'abc';
        insert t1;
        update t1;
        
        test.stopTest();
    }
    
    static testMethod void countTaskonLead9(){
        test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Call_Attempts__c objCallAttemps = new Call_Attempts__c();
        objCallAttemps.Number_of_Calls__c = 1;
        objCallAttemps.Name = 'Lead Calls';
        insert objCallAttemps;
        
        ByPassValidation__c mc = new ByPassValidation__c();
        mc.isTrue__c=true;
        insert mc;
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
         User wta_user = new User(alias = 'ameyo', email='ameyousertest@homelane.com',
                emailencodingkey='UTF-8', lastname='Cloud Agent', languagelocalekey='en_US',localesidkey='en_US',Cloud_Agent_Campaign_Name__c = 'abc', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertest@homelane.com');
        insert wta_user;
        
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Noida';
        insert objRA;
        
         Master__c m = new Master__c(type__c='Showroom',name='Gopalan Showroom');
        insert m;
       lead leadRec1;
       system.RunAs(wta_user){
         leadRec1=leadUtil_Test.insertLead('parinitha@gmail.com','1234567899');
         leadRec1.PostalCode='561284';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Call back in 2 hrs';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.WT_Agent__c = wta_user.Id;
         leadRec1.Ameyo_Call_Attempts__c = 1;
         leadRec1.Attempts_since_last_connection__c = null;
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.leadSource = 'Toll-free';
         insert leadRec1;
           System.debug('leadRec1.Owner.Name  '+leadRec1.Owner.Name);
         system.debug('---------Test Class Lead Owner--------'+leadRec1.OwnerId);
       }   
        leadRec1.Status='Appointment Fixed';
           leadRec1.Sub_Status__c ='Appointment Fixed';
        //   leadRec1.OwnerId = wta_user.Id;
      //   leadRec1.WT_Agent__c = wta_user.Id;
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.LeadSource='website';
        leadRec1.Vanity_Unit__c='Yes';
        leadRec1.Wardrobes__c='1';
        leadRec1.Utility_Unit__c='Yes';
        leadRec1.Study_Table_Book_Shelf__c='Yes';
        leadRec1.Property__c=m.Id;
        leadRec1.Appointment_Type__c = 'Square Showroom Visit';
       leadRec1.City = 'Bengaluru';
       leadRec1.Interior_Start_Date__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Property_Type__c  = 'Villa';
       leadRec1.Property_Config__c = '1 BHK';
       leadRec1.Property_Status__c = 'New';
       leadRec1.Property_Move_In_Date__c= Date.valueOf('2019-12-06T00:00:00.000Z');
       leadRec1.Kitchen__c = 'Yes';
       leadRec1.Vanity_Unit__c = 'Yes';
       leadRec1.Utility_Unit__c = 'Yes';
       leadRec1.Crockery_Unit__c = 'Yes';
       leadRec1.Entertainment_Unit__c = 'Yes';
       leadRec1.Pooja__c = 'Yes';
       leadRec1.How_did_you_hear_about_us__c = 'Email';
       leadRec1.Study_Table_Book_Shelf__c = 'Yes';
       leadRec1.Foyer_Shoe_Rack__c = 'Yes';
       leadRec1.Appointment_Time__c = System.now();
       leadRec1.Time_of_Actual_Appointment_Start__c = Date.valueOf('2017-12-06T00:00:00.000Z');  
       leadRec1.Appointment_Venue_Square__c = m.Id;
       leadRec1.Possession_Date__c = Date.valueOf('2019-12-06T00:00:00.000Z');  
       leadRec1.Whatsapp_UCL_Call_Attempts_Chk__c = false;
           System.debug('leadRec1.Owner.Name  '+leadRec1.Owner.Name);
           update leadRec1;
         
            Whatsapp_Message__c w = new Whatsapp_Message__c();
        w.Name='WA - Unable to Contact';
           w.Lead__c=leadRec1.Id;
        insert w;
           
        Task t1=new Task();
        t1.subject='Follow Up - 123';
        t1.monitorUCID__c = '123';
        t1.OwnerId=leadRec1.OwnerId;
        t1.Priority='Normal';
        t1.Status='Open';
        t1.WhoId=leadRec1.Id;
        t1.Disposition_Type__c = 'Couldn\'t Contact';
         /*  t1.UUI__c = String.valueOf(w.Id);
            t1.AgentStatus__c = 'abcd';
            t1.CustomerStatus__c = 'abc';
            t1.callDisposition = 'abc'; */
        insert t1;
        update t1;
        
        test.stopTest();
    }
}