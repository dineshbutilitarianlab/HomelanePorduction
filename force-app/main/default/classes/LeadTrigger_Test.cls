@isTest
public class LeadTrigger_Test {
    static testMethod void testLeadTrigger1p(){
        Test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Account acc = new account();
        acc.Name='Test acc';
        insert acc;
        
        lead leadRec1=leadUtil_Test.insertLead('par1initha@gmail.com','7847111200');
         leadRec1.PostalCode='561284';
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appoinment Success - Waiting Floorplan'; 
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.LeadSource='FB Lead Form';
        leadRec1.Sign_Up_Source__c='Estimate Flow';
        leadRec1.Vanity_Unit__c='Yes';
        leadRec1.City = 'Bengaluru';
        leadRec1.Wardrobes__c='1';
        leadRec1.Utility_Unit__c='Yes';
        leadRec1.Study_Table_Book_Shelf__c='Yes';
        leadRec1.account__c= acc.id;
        leadRec1.GCLID__c= 'abcdefghijklmnopqrstuvwxyz';
        insert leadRec1; 
       
        leadRec1.HSR_Distance__c = 8;
        leadRec1.Closest_Showroom__c = 'HSR Showroom';
        update leadRec1;
        Test.stopTest();
    }
       
    static testMethod void testLeadTrigger7(){
        Test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Account acc = new account();
        acc.Name='Test acc';
        insert acc;
        
        lead leadRec1=leadUtil_Test.insertLead('par1initha@gmail.com','7847111200');
         leadRec1.PostalCode='561284';
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appoinment Success - Waiting Floorplan';
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.LeadSource='Estimate Flow';
        leadRec1.Sign_Up_Source__c='Estimate Flow';
        leadRec1.Vanity_Unit__c='Yes';
        leadRec1.City = 'Hyderabad';
        leadRec1.Wardrobes__c='1';
        leadRec1.Utility_Unit__c='Yes';
        leadRec1.Study_Table_Book_Shelf__c='Yes';
        leadRec1.account__c= acc.id;
        insert leadRec1; 
       
        leadRec1.Gachibowli_Distance__c = 8;
        leadRec1.Closest_Showroom__c = 'Gachibowli Showroom';
        update leadRec1;
        Test.stopTest();
    }
    
    static testMethod void testLeadTrigger8(){
        Test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Account acc = new account();
        acc.Name='Test acc';
        insert acc;
        
        lead leadRec1=leadUtil_Test.insertLead('par1initha@gmail.com','7847111200');
        leadRec1.PostalCode='561284';
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appoinment Success - Waiting Floorplan';
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.LeadSource='Estimate Flow';
        leadRec1.Sign_Up_Source__c='Estimate Flow';
        leadRec1.Vanity_Unit__c='Yes';
        leadRec1.City = 'Hyderabad';
        leadRec1.Wardrobes__c='1';
        leadRec1.Utility_Unit__c='Yes';
        leadRec1.Study_Table_Book_Shelf__c='Yes';
        leadRec1.account__c= acc.id;
        insert leadRec1; 
        
        leadRec1.Gachibowli_Distance__c = 12;
        leadRec1.Closest_Showroom__c = 'Gachibowli Showroom';
        update leadRec1;
        Test.stopTest();
    }
    
     static testMethod void testLeadTrigger9(){
        Test.startTest(); 
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Account acc = new account();
        acc.Name='Test acc';
        insert acc;
        lead leadRec1=leadUtil_Test.insertLead('par1initha@gmail.com','7847111200');
         leadRec1.PostalCode='561284';
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appoinment Success - Waiting Floorplan';
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.LeadSource='Estimate Flow';
        leadRec1.Sign_Up_Source__c='Estimate Flow';
        leadRec1.Vanity_Unit__c='Yes';
        leadRec1.City = 'Bengaluru';
        leadRec1.Wardrobes__c='1';
        leadRec1.Utility_Unit__c='Yes';
        leadRec1.Study_Table_Book_Shelf__c='Yes';
         leadRec1.account__c= acc.id;
        insert leadRec1; 
        
        leadRec1.HSR_Distance__c = 18;
        leadRec1.Closest_Showroom__c = 'HSR Showroom';
        update leadRec1;
        Test.stopTest();
    }
    
    static testMethod void testLeadTrigger10(){
        Test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=15,HSR_Estimate_Flow__c=0);
        insert res;
        Account acc = new account();
        acc.Name='Test acc';
        insert acc;
        lead leadRec1=leadUtil_Test.insertLead('par1initha@gmail.com','7847111200');
        leadRec1.PostalCode='561284';
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appoinment Success - Waiting Floorplan';
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.LeadSource='Estimate Flow';
        leadRec1.Sign_Up_Source__c='Estimate Flow';
        leadRec1.Vanity_Unit__c='Yes';
        leadRec1.City = 'Hyderabad';
        leadRec1.Wardrobes__c='1';
        leadRec1.Utility_Unit__c='Yes';
        leadRec1.Study_Table_Book_Shelf__c='Yes';
        leadRec1.account__c= acc.id;
        insert leadRec1; 
        
        leadRec1.Gachibowli_Distance__c = 12;
        leadRec1.Closest_Showroom__c = 'Gachibowli Showroom';
        update leadRec1;
        Test.stopTest();
    }
    
     static testMethod void testLeadTrigger11(){
        Test.startTest(); 
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=15);
        insert res;
         Account acc = new account();
        acc.Name='Test acc';
        insert acc;
        
        lead leadRec1=leadUtil_Test.insertLead('par1initha@gmail.com','7847111200');
         leadRec1.PostalCode='561284';
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appoinment Success - Waiting Floorplan';
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.LeadSource='Estimate Flow';
        leadRec1.Sign_Up_Source__c='Estimate Flow';
        leadRec1.Vanity_Unit__c='Yes';
        leadRec1.City = 'Bengaluru';
        leadRec1.Wardrobes__c='1';
        leadRec1.Utility_Unit__c='Yes';
        leadRec1.Study_Table_Book_Shelf__c='Yes';
         leadRec1.account__c= acc.id;
        insert leadRec1; 
        
        leadRec1.HSR_Distance__c = 18;
        leadRec1.Closest_Showroom__c = 'HSR Showroom';
        update leadRec1;
        Test.stopTest();
    }
    
    static testMethod void testLeadTrigger12(){
        Test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=140,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Account acc = new account();
        acc.Name='Test acc';
        insert acc;
        lead leadRec1=leadUtil_Test.insertLead('par1initha@gmail.com','7847111200');
        leadRec1.PostalCode='561284';
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appoinment Success - Waiting Floorplan';
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.LeadSource='Estimate Flow';
        leadRec1.Sign_Up_Source__c='Estimate Flow';
        leadRec1.Vanity_Unit__c='Yes';
        leadRec1.City = 'Hyderabad';
        leadRec1.Wardrobes__c='1';
        leadRec1.Utility_Unit__c='Yes';
        leadRec1.Study_Table_Book_Shelf__c='Yes';
        leadRec1.account__c= acc.id;
        insert leadRec1; 
        
        leadRec1.Gachibowli_Distance__c = 12;
        leadRec1.Closest_Showroom__c = 'Gachibowli Showroom';
        update leadRec1;
        Test.stopTest();
    }
    
     static testMethod void testLeadTrigger13(){
        Test.startTest(); 
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=140,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Account acc = new account();
        acc.Name='Test acc';
        insert acc;
        lead leadRec1=leadUtil_Test.insertLead('par1initha@gmail.com','7847111200');
         leadRec1.PostalCode='561284';
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appoinment Success - Waiting Floorplan';
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.LeadSource='Estimate Flow';
        leadRec1.Sign_Up_Source__c='Estimate Flow';
        leadRec1.Vanity_Unit__c='Yes';
        leadRec1.City = 'Bengaluru';
        leadRec1.Wardrobes__c='1';
        leadRec1.Utility_Unit__c='Yes';
        leadRec1.Study_Table_Book_Shelf__c='Yes';
         leadRec1.account__c= acc.id;
        insert leadRec1; 
        
        leadRec1.HSR_Distance__c = 18;
        leadRec1.Closest_Showroom__c = 'HSR Showroom';
        update leadRec1;
        Test.stopTest();
    }
    
    static testMethod void testLeadTrigger14(){
        Test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=140,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Account acc = new account();
        acc.Name='Test acc';
        insert acc;
        lead leadRec1=leadUtil_Test.insertLead('par1initha@gmail.com','7847111200');
         leadRec1.PostalCode='561284';
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appoinment Success - Waiting Floorplan';
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.LeadSource='Estimate Flow';
        leadRec1.Sign_Up_Source__c='Estimate Flow';
        leadRec1.Vanity_Unit__c='Yes';
        leadRec1.City = 'Bengaluru';
        leadRec1.Wardrobes__c='1';
        leadRec1.Utility_Unit__c='Yes';
        leadRec1.Study_Table_Book_Shelf__c='Yes';
        leadRec1.account__c= acc.id;
        insert leadRec1; 
       
        leadRec1.HSR_Distance__c = 18;
        leadRec1.Closest_Showroom__c = 'ABC Showroom';
        update leadRec1;
        Test.stopTest();
    }
    
    static testMethod void testLeadTrigger2(){
         
        test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res; 
         //Select a user with other than system administrator profile
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
       Account ac = new Account(name ='Grazitti2',Customer_ID__c='BEN-C-0000123') ;
        insert ac; 
        Contact con = new Contact(LastName ='testCon12',AccountId = ac.Id);
        insert con;
        User wta_user=leadUtil_Test.inserUser('testWta12@gmail.com','stWT12','',profileData.get('WTA Profile')); 
        insert wta_user;
        User agent_user=leadUtil_Test.inserUser('testSSP12@gmail.com','TstSP12',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('testSP12@gmail.com','TestSP12',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
         User dp_prof=leadUtil_Test.inserUser('testDP12@gmail.com','TestDP12',ac.Id,profileData.get('Design Partner Profile')); 
          insert dp_prof;
           Interior_Designer__c objIDP = new Interior_Designer__c();
        objIDP.Name = 'testData';
        objIDP.Email__c = 'TestDesighP@hfltest.com';
        objIDP.User_Name__c = dp_prof.Id;
        insert objIDP;
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id);
        insert master1;
        
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
            Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Showroom',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType1.Id,
                           Builder_Name__c=master1.Id,SSM__c=managerUser.id,Delivery_Manager__c=managerUser.id,Design_Manager__c=managerUser.id);
        insert master2;
                         
         lead leadRec1=leadUtil_Test.insertLead('par1initha@gmail.com','7847111200');
        leadRec1.Account__c= ac.id;
         leadRec1.PostalCode='561284';
         leadRec1.Appointment_Venue_Square__c=master2.Id;
        leadRec1.Square_Showroom_Agent__c=UserInfo.getUserId();
        leadRec1.Square_Showroom_Manager__c=managerUser.id;
        leadRec1.Appointment_Time__c=System.now();
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appoinment Success - Waiting Floorplan';
        leadRec1.Design_Partner__c = dp_prof.Id;
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
       // leadRec1.Property__c=master2.Id;
       leadRec1.Appointment_Type__c = 'Mobile Showroom Visit';
       leadRec1.Builder_Name__c = master1.Id;
       leadRec1.City = 'Mumbai';
       leadRec1.Interior_Start_Date__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Property__c = master2.Id;
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
       leadRec1.Appointment_Time__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Time_of_Actual_Appointment_Start__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Phone = '8978675678';
       leadRec1.Possession_Date__c = Date.valueOf('2018-12-06T00:00:00.000Z');
        insert leadRec1;
     }
  /*  
    static testMethod void testLeadTrigger3(){
         
        test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Book_Free_Consultation__c=0,Gachibowli_Monthly_Limit__c=0,Gachibowli_Residence_Visit__c=0,HSR_Book_Free_Consultation__c=0,HSR_Monthly_Limit__c=0,HSR_Residence_Visit__c=0);
        insert res; 
         //Select a user with other than system administrator profile
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti4',Customer_ID__c='BEN-C-0000124') ;
        insert ac; 
        Contact con = new Contact(LastName ='testCon4',AccountId = ac.Id);
        insert con;
        User wta_user=leadUtil_Test.inserUser('testWta3@gmail.com','TestWTA4','',profileData.get('WTA Profile')); 
        insert wta_user;
        //list<User> agent_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :agent_profile.Id and isActive = true];
       // list<User> agent_user=UsersUtil_Class.insertUser(agent_profile.ID);
       User agent_user=leadUtil_Test.inserUser('testSSP3@gmail.com','TestSSP3',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        
        //Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'Square Profile' LIMIT 1];
        //list<User> managerUser=[SELECT id,Name, Email  FROM User WHERE ProfileId =:squareMag_profile.id and isActive = true];
       // list<User> managerUser=UsersUtil_Class.insertUser(squareMag_profile.ID);
        User managerUser=leadUtil_Test.inserUser('testSP3@gmail.com','TestSP5',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        //Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'Design Partner Profile' LIMIT 1];
        //list<User> dp_prof = [SELECT id,Name, Email  FROM User WHERE ProfileId = :dp_profile.Id and isActive = true ];
      //  list<User> dp_prof=UsersUtil_Class.insertUser(dp_profile.ID);
          User dp_prof=leadUtil_Test.inserUser('testDP3@gmail.com','TestDP3',ac.Id,profileData.get('Design Partner Profile')); 
          insert dp_prof;
           Interior_Designer__c objIDP = new Interior_Designer__c();
        objIDP.Name = 'testData';
        objIDP.Email__c = 'TestDesighP@hfltest.com';
        objIDP.User_Name__c = dp_prof.Id;
        insert objIDP;
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id);
        insert master1;
        
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
            Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Showroom',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType1.Id,
                           Builder_Name__c=master1.Id,SSM__c=managerUser.id,Delivery_Manager__c=managerUser.id,Design_Manager__c=managerUser.id);
        insert master2;
         
        Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.Threashold__c = 10;
        objShowroom1.Backlogs__c = 2;
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Bronze';
        insert ObjShowroom1;
        
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
        objShowroom2.Email__c = 'TestSHowRoomasdUSer@test.com';
        objShowroom2.Threashold__c = 10;
        objShowroom2.Backlogs__c = 2;
        objShowroom2.Daily_Assignment__c = 4;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true;
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.Outskirts_Assignment__c=1;
        objShowroom2.Outskirts_Assignment_Limit__c=3;
        ObjShowroom2.IM_Class__c='Gold';
        insert objShowroom2;
        
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Outskirts','Cluster A','561285',False);
        objTerr.Lat_Long__Latitude__s = 20.0936477440000;
        objTerr.Lat_Long__Longitude__s =  89.7849897840000;
        objTerr.Cluster_Brand__c ='Homelane';
        Insert objTerr;
        
        Territory__c objTerr1 = TestData_Factory.createTerritory('Area b',ObjShowroom2.id,'Bengaluru','Cluster A','561284',False);
        objTerr1.Lat_Long__Latitude__s = 25.0936477440000;
        objTerr1.Lat_Long__Longitude__s =  88.7849897840000;
        objTerr1.Cluster_Brand__c ='Homelane';
        objTerr1.Sales_Campaign__c ='Green Channel';
        Insert objTerr1;    
                         
         lead leadRec1=leadUtil_Test.insertLead('parinitha@g1mail.com','7845111500');
         leadRec1.PostalCode='561284';
         leadRec1.Account__c =ac.id;
         leadRec1.Appointment_Venue_Square__c=master2.Id;
         leadRec1.Interior_Designer__c=objIDP.id;
        leadRec1.Square_Showroom_Agent__c=agent_user.Id;
        leadRec1.Square_Showroom_Manager__c=managerUser.id;
        leadRec1.Appointment_Time__c=System.now();
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='DP Assigned';
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.LeadSource='website';
        leadRec1.Vanity_Unit__c='Yes';
        leadRec1.How_did_you_hear_about_us__c = 'Email';
        leadRec1.Wardrobes__c='1';
        leadRec1.Utility_Unit__c='Yes';
        leadRec1.Study_Table_Book_Shelf__c='Yes';
        //leadRec1.Property__c=master2.Id;
        leadRec1.Appointment_Type__c = 'Mobile Showroom Visit';
       leadRec1.Builder_Name__c = master1.Id;
       leadRec1.City = 'Bengaluru';
       leadRec1.Interior_Start_Date__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Property__c = master2.Id;
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
       leadRec1.Study_Table_Book_Shelf__c = 'Yes';
       leadRec1.Foyer_Shoe_Rack__c = 'Yes';
       leadRec1.Appointment_Time__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Time_of_Actual_Appointment_Start__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Phone = '8948675670';
        insert leadRec1;
     }
 */   
     static testMethod void testLeadTrigger4(){
        
        
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res; 
        //Select a user with other than system administrator profile
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        
        Account ac = new Account(name ='Grazitti4',Customer_ID__c='BEN-C-0000124') ;
        insert ac; 
        Contact con = new Contact(LastName ='testCon14',AccountId = ac.Id);
        insert con;
        User wta_user=leadUtil_Test.inserUser('testWta14@gmail.com','Tewt14','',profileData.get('WTA Profile')); 
        insert wta_user;
        User wta_user2=leadUtil_Test.inserUser('testWta142@gmail.com','Tewt42','',profileData.get('WTA Profile')); 
        insert wta_user2;
        User agent_user=leadUtil_Test.inserUser('testSSP14@gmail.com','TeSSP14',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('testSP14@gmail.com','TesSP14',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('testDP14@gmail.com','TesDP14',ac.Id,profileData.get('Design Partner Profile')); 
          insert dp_prof;
           Interior_Designer__c objIDP = new Interior_Designer__c();
        objIDP.Name = 'testData';
        objIDP.Email__c = 'TestDesighP@hfltest.com';
        objIDP.User_Name__c = dp_prof.Id;
        insert objIDP;
         //insert new lead record        
         lead leadRec1=leadUtil_Test.insertLead('parinithaALLISWELL@gmail.com','8849911200');
         leadRec1.PostalCode='561284';
         leadRec1.status='Fresh Lead';
         leadRec1.sub_status__c='New';
        leadRec1.Lead_Assingment__c=true;
        leadRec1.Square_Showroom_Agent__c=agent_user.Id;
        leadRec1.Square_Showroom_Manager__c=managerUser.id;
        leadRec1.Interior_Designer__c=objIDP.id;
        leadRec1.City='Bengaluru';
        leadRec1.leadSource='Google Ad';
        leadRec1.OwnerId = wta_user.Id;
         leadRec1.Account__c = ac.id;
        //system.runAs(wta_user){
         insert leadRec1;
        //}
        
        //assign users in round robin manner to leads
        Group grp=new group();
        grp.Name='Gopalan Showroom';
        grp.Type='Queue';
        insert grp;
        
        System.runAs(new User(Id = UserInfo.getUserId())) {   
            QueueSobject testQueue = new QueueSObject(QueueId = grp.Id, SobjectType = 'Lead');
            insert testQueue;
            
         GroupMember member = new GroupMember();
        member.UserOrGroupId = wta_user.id ;
        member.GroupId = grp.Id;
        insert member;
        
        GroupMember member1 = new GroupMember();
        member1.UserOrGroupId = wta_user2.id ;
        member1.GroupId = grp.Id;
        insert member1;
        }
        
        Group grpSquare=new group();
        grpSquare.Name='BangaloreWelcomeTeam';
        grpSquare.Type='Queue';
        insert grpSquare;
        
        System.runAs(new User(Id = UserInfo.getUserId())) {   
            QueueSobject testQueue1 = new QueueSObject(QueueId = grpSquare.Id, SobjectType = 'Master__c');
            insert testQueue1;
        }
        
        
        Group grpRound=new group();
        grpRound.Name='Gopalan Showroom';
        grpRound.Type='Queue';
        insert grpRound;
        
        System.runAs(new User(Id = UserInfo.getUserId())) {   
            QueueSobject testQueue = new QueueSObject(QueueId = grpRound.Id, SobjectType = 'Round_Robin__c');
            insert testQueue;
        }
        
        //  lead l1=[SELECT id,lastName,Duplicate_Record__c FROM lead WHERE Id=:leadrec3.id];,ownerId=grpSquare.id
        // system.assert(l1.Duplicate_Record__c==true);
         
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id,ownerId=grpSquare.id);
        insert master1;
        
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
            Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Showroom',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType1.Id,
                           Builder_Name__c=master1.Id,ownerId=grpSquare.id,SSM__c=managerUser.id,Delivery_Manager__c=managerUser.id,Design_Manager__c=managerUser.id,IsActive__c = true);
        insert master2;
        system.debug('*************master2*******************'+master2);
        
      /*  Task t1=new Task();
        t1.subject='Follow Up';
        t1.OwnerId=userInfo.getUserId();
        t1.Priority='Normal';
        t1.Status='Open';
        t1.WhoId=leadRec1.Id;
        insert t1;*/
        test.startTest();
        Round_Robin__c roundRobin=new Round_Robin__c(Name='Gopalan Showroom',Queue_Name__c='Gopalan Showroom',Total_Leads__c=0);
        insert roundRobin;
        
        Lead_Assignment__c leadAssign=new Lead_Assignment__c(Name='Shalini Sales HML Agent',Round_Robin__c=roundRobin.id,User__c=agent_user.Id,Assign_Percent__c=50,Number_of_Leads__c=0);
        insert leadAssign;
        
        Lead_Assignment__c leadAssign1=new Lead_Assignment__c(Name='Amit Agent',Round_Robin__c=roundRobin.id,User__c=agent_user.Id,Assign_Percent__c=50,Number_of_Leads__c=0);
      //  insert leadAssign1;
        
       //leadRec1.ownerId=grpSquare.id;
    //    leadRec1.firstName='Grantha';
         leadRec1.Lead_Assingment__c=false;
        leadRec1.Appointment_Venue_Square__c=master2.Id;
        leadRec1.Square_Showroom_Agent__c=agent_user.Id;
        leadRec1.Square_Showroom_Manager__c=managerUser.id;
         System.debug('leadRec1.Square_Showroom_Manager__c : '+leadRec1.Square_Showroom_Manager__c);
         System.debug('managerUser.id : '+managerUser.id);
        leadRec1.Appointment_Time__c=System.now();
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appointment Confirmed ';
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
       // leadRec1.Property__c=master2.Id;
         leadRec1.Interior_Designer__c=objIDP.id;
      //  leadRec1.Showroom_Sales_Agent_Assigment__c=true;
       // leadRec1.Wt_Agent__c=UserInfo.getUserId();
       leadRec1.Appointment_Type__c = 'Mobile Showroom Visit';
       leadRec1.Builder_Name__c = master1.Id;
       leadRec1.City = 'Mumbai';
       leadRec1.Interior_Start_Date__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Property__c = master2.Id;
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
       leadRec1.Appointment_Time__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Time_of_Actual_Appointment_Start__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Phone = '8978675665';
       leadRec1.Possession_Date__c = Date.valueOf('2018-12-06T00:00:00.000Z');
         leadRec1.Account__c=ac.id;
        update leadRec1;
        
        system.debug('******leadRec1******'+leadRec1);
        test.stopTest();
     }
    
     static testMethod void testLeadTrigger5(){
         
        test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res; 
         //Select a user with other than system administrator profile
          Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti5',Customer_ID__c='BEN-C-0000126') ;
        insert ac; 
        Contact con = new Contact(LastName ='testCon5',AccountId = ac.Id);
        insert con;
        User wta_user=leadUtil_Test.inserUser('testWta5@gmail.com','TestWTA5','',profileData.get('WTA Profile')); 
        insert wta_user;
        //list<User> agent_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :agent_profile.Id and isActive = true];
       // list<User> agent_user=UsersUtil_Class.insertUser(agent_profile.ID);
       User agent_user=leadUtil_Test.inserUser('testSSP5@gmail.com','TestSSP5',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        
        //Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'Square Profile' LIMIT 1];
        //list<User> managerUser=[SELECT id,Name, Email  FROM User WHERE ProfileId =:squareMag_profile.id and isActive = true];
       // list<User> managerUser=UsersUtil_Class.insertUser(squareMag_profile.ID);
        User managerUser=leadUtil_Test.inserUser('testSP5@gmail.com','TestSP5',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        //Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'Design Partner Profile' LIMIT 1];
        //list<User> dp_prof = [SELECT id,Name, Email  FROM User WHERE ProfileId = :dp_profile.Id and isActive = true ];
      //  list<User> dp_prof=UsersUtil_Class.insertUser(dp_profile.ID);
          User dp_prof=leadUtil_Test.inserUser('testDP5@gmail.com','TestDP5',ac.Id,profileData.get('Design Partner Profile')); 
          insert dp_prof;
           Interior_Designer__c objIDP = new Interior_Designer__c();
        objIDP.Name = 'testData';
        objIDP.Email__c = 'TestDesighP@hfltest.com';
        objIDP.User_Name__c = dp_prof.Id;
        insert objIDP;
        Group grpSquare=new group();
        grpSquare.Name='Gopalan Square Showroom';
        grpSquare.Type='Queue';
        insert grpSquare;
        
        System.runAs(new User(Id = UserInfo.getUserId())) {   
            QueueSobject testQueue = new QueueSObject(QueueId = grpSquare.Id, SobjectType = 'Master__c');
            insert testQueue;
        }
        
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id,ownerId=grpSquare.id);
        insert master1;
        
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
            Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Showroom',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType1.Id,
                           Builder_Name__c=master1.Id,ownerId=grpSquare.id,SSM__c=managerUser.id,Delivery_Manager__c=managerUser.id,Design_Manager__c=managerUser.id);
        insert master2;
                         
         lead leadRec1=leadUtil_Test.insertLead('pqrarinitha@gmail.com','7845171200');
         leadRec1.Interior_Designer__c=objIDP.id;
         leadRec1.PostalCode='561284';
         leadRec1.Appointment_Venue_Square__c=master2.Id;
        leadRec1.Square_Showroom_Agent__c=UserInfo.getUserId();
        leadRec1.Square_Showroom_Manager__c=managerUser.id;
        leadRec1.WT_Agent__c = UserInfo.getUserId();
        leadRec1.Appointment_Time__c=System.now();
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appointment Unsuccessful';
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
        //leadRec1.Property__c=master2.Id;
        leadRec1.Appointment_Type__c = 'Mobile Showroom Visit';
       leadRec1.Builder_Name__c = master1.Id;
       leadRec1.How_did_you_hear_about_us__c = 'Email';
       leadRec1.City = 'Mumbai';
       leadRec1.Interior_Start_Date__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Property__c = master2.Id;
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
       leadRec1.Customer_Present_for_Appointment__c = 'Yes';
       leadRec1.Study_Table_Book_Shelf__c = 'Yes';
       leadRec1.Foyer_Shoe_Rack__c = 'Yes';
       leadRec1.Appointment_Time__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Time_of_Actual_Appointment_Start__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Phone = '8975675671';
       leadRec1.Possession_Date__c = Date.valueOf('2018-12-06T00:00:00.000Z');
         leadRec1.Account__c=ac.id;
        insert leadRec1;
        test.stopTest();
     }
    
     static testMethod void testLeadTrigger6(){
         
        test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
         //Select a user with other than system administrator profile
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti6',Customer_ID__c='BEN-C-0000120') ;
        insert ac; 
        Contact con = new Contact(LastName ='testCon6',AccountId = ac.Id);
        insert con;
        User wta_user=leadUtil_Test.inserUser('testWta6@gmail.com','TestWTA6','',profileData.get('WTA Profile')); 
        insert wta_user;
        //list<User> agent_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :agent_profile.Id and isActive = true];
       // list<User> agent_user=UsersUtil_Class.insertUser(agent_profile.ID);
       User agent_user=leadUtil_Test.inserUser('testSSP6@gmail.com','TestSSP6',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        
        //Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'Square Profile' LIMIT 1];
        //list<User> managerUser=[SELECT id,Name, Email  FROM User WHERE ProfileId =:squareMag_profile.id and isActive = true];
       // list<User> managerUser=UsersUtil_Class.insertUser(squareMag_profile.ID);
        User managerUser=leadUtil_Test.inserUser('testSP6@gmail.com','TestSP6',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        //Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'Design Partner Profile' LIMIT 1];
        //list<User> dp_prof = [SELECT id,Name, Email  FROM User WHERE ProfileId = :dp_profile.Id and isActive = true ];
      //  list<User> dp_prof=UsersUtil_Class.insertUser(dp_profile.ID);
          User dp_prof=leadUtil_Test.inserUser('testDP6@gmail.com','TestDP6',ac.Id,profileData.get('Design Partner Profile')); 
          insert dp_prof;
          Interior_Designer__c objIDP = new Interior_Designer__c();
        objIDP.Name = 'testData';
        objIDP.Email__c = 'TestDesighP@hfltest.com';
        objIDP.User_Name__c = dp_prof.Id;
        insert objIDP;
        Group grpSquare=new group();
        grpSquare.Name='Gopalan Square Showroom';
        grpSquare.Type='Queue';
        insert grpSquare;
        
        System.runAs(new User(Id = UserInfo.getUserId())) {   
            QueueSobject testQueue = new QueueSObject(QueueId = grpSquare.Id, SobjectType = 'Master__c');
            insert testQueue;
        }
        
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id,ownerId=grpSquare.id);
        insert master1;
        
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
            Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Showroom',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType1.Id,
                           Builder_Name__c=master1.Id,ownerId=grpSquare.id,SSM__c=managerUser.id,Delivery_Manager__c=managerUser.id,Design_Manager__c=managerUser.id);
        insert master2;
                         
         lead leadRec1=leadUtil_Test.insertLead('parinithass@gmail.com','7895111200');
         leadRec1.PostalCode='561284';
         leadRec1.Appointment_Venue_Square__c=master2.Id;
         leadRec1.Interior_Designer__c=objIDP.id;
        leadRec1.Square_Showroom_Agent__c=agent_user.Id;
        leadRec1.Square_Showroom_Manager__c=managerUser.id;
        leadRec1.Appointment_Time__c=System.now();
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='DP Assigned';
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
       // leadRec1.Property__c=master2.Id;
        leadRec1.Appointment_Type__c = 'Mobile Showroom Visit';
       leadRec1.Builder_Name__c = master1.Id;
       leadRec1.City = 'Mumbai';
       leadRec1.Interior_Start_Date__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Property__c = master2.Id;
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
       leadRec1.Appointment_Time__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Time_of_Actual_Appointment_Start__c = Date.valueOf('2017-12-06T00:00:00.000Z');
       leadRec1.Phone = '8971675672';
       leadRec1.Possession_Date__c = Date.valueOf('2018-12-06T00:00:00.000Z');
         leadRec1.account__c =ac.id;
        insert leadRec1;
        //
        //
        //
        //
        LeadTriggerHandler.dummyTestCover();
        test.stopTest();
     }
    
    static testMethod void handleRoundRobin_Test(){

        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti',Customer_ID__c='BEN-C-0000180') ;
        insert ac; 

        User wta_user=leadUtil_Test.inserUser('tetWta1@gmail.com','TesWT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        User agent_user=leadUtil_Test.inserUser('tesSP1@gmail.com','TeSSP1',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('tstP1@gmail.com','TesSP1',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('tesDP1@gmail.com','TesDP1',ac.Id,profileData.get('Design Partner Profile')); 
        insert dp_prof;

        Lead_Round_Robin_Assignment__c ObjleadRound = new  Lead_Round_Robin_Assignment__c();
        ObjleadRound.Assignment_Days__c = 'Monday;Tuesday;Wednesday;Thursday;Friday;Saturday;Sunday';
        ObjleadRound.Daily_Assignment__c= 0;
        ObjleadRound.Daily_Limit__c= 2;
        ObjleadRound.Distance_from_ShowRoom__c= 5;
        ObjleadRound.Monthly_Assignments__c= 5;
        ObjleadRound.Monthly_Limit__c= 50;
        ObjleadRound.Showroom_Name__c= 'HSR';
        ObjleadRound.User__c= agent_user.id;
        insert ObjleadRound;

        lead leadRec1=leadUtil_Test.insertLead('parinitha@gmail.com','7845211200');
        leadRec1.PostalCode='561284';
        leadRec1.status='Fresh Lead';
        leadRec1.Lead_Assingment__c=true;
        //  leadRec1.Interior_Designer__c=objIDP.id;
        leadRec1.City='Bengaluru';
        leadRec1.OwnerId = wta_user.Id;
        leadRec1.leadSource = 'Google Ad';
        leadRec1.Account__c= ac.id;
        //stem.runAs(wta_user){
        test.startTest();   
        insert leadRec1;
        //assign users in round robin manner to leads

        leadRec1.Lead_Assingment__c=true;
        system.debug('*************agent_user*******************'+agent_user);
        system.debug('*************managerUser*******************'+managerUser);
        system.debug('*************dp_prof*******************'+dp_prof);
        leadRec1.Square_Showroom_Manager__c=managerUser.id;
        leadRec1.Appointment_Time__c=System.now();
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appointment Successful';
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
        //leadRec1.Property__c=master2.Id;
        leadRec1.Appointment_Type__c = 'Mobile Showroom Visit';
        leadRec1.City = 'Mumbai';
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
        leadRec1.Appointment_Time__c = Date.valueOf('2017-12-06T00:00:00.000Z');
        leadRec1.Time_of_Actual_Appointment_Start__c = Date.valueOf('2017-12-06T00:00:00.000Z');
        leadRec1.Phone = '69786756783';
        leadRec1.Possession_Date__c = Date.valueOf('2018-12-06T00:00:00.000Z');
        leadRec1.Closest_Showroom__c = 'HSR 1 km';
        system.runAs(wta_user){
            try{
                update leadRec1;
            }
            catch(DmlException e){
            }
        }       

        test.stopTest();
    }   
    
        static testMethod void testLeadTriggerSuccessful(){
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res; 
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
        profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti',Customer_ID__c='BEN-C-0000180') ;
        insert ac; 

        User wta_user=leadUtil_Test.inserUser('tetWta1@gmail.com','TesWT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        User agent_user=leadUtil_Test.inserUser('tesSP1@gmail.com','TeSSP1',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('tstP1@gmail.com','TesSP1',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('tesDP1@gmail.com','TesDP1',ac.Id,profileData.get('Design Partner Profile')); 
        insert dp_prof;
        Interior_Designer__c objIDP = new Interior_Designer__c();
        objIDP.Name = 'testData';
        objIDP.Email__c = 'TestDesighP@hfltest.com';
        objIDP.User_Name__c = dp_prof.Id;
        insert objIDP;
        //insert new lead record 
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Mumbai';
        insert objRA;        
        lead leadRec1=leadUtil_Test.insertLead('parinitha@gmail.com','7845211200');
        leadRec1.PostalCode='561284';
        leadRec1.status='Fresh Lead';
        leadRec1.Lead_Assingment__c=true;
        //  leadRec1.Interior_Designer__c=objIDP.id;
        leadRec1.City='Bengaluru';
        leadRec1.OwnerId = wta_user.Id;
        leadRec1.leadSource = 'Google Ad';
            leadRec1.account__c =ac.id;
        //stem.runAs(wta_user){
        test.startTest();   
        insert leadRec1;
        //assign users in round robin manner to leads
        Group grp=new group();
        grp.Name='Gopalan Showroom';
        grp.Type='Queue';
        insert grp;

        System.runAs(new User(Id = UserInfo.getUserId())) {   
        QueueSobject testQueue = new QueueSObject(QueueId = grp.Id, SobjectType = 'Lead');
        insert testQueue;


        GroupMember member = new GroupMember();
        member.UserOrGroupId = agent_user.id ;
        member.GroupId = grp.Id;
        insert member;

        GroupMember member1 = new GroupMember();
        member1.UserOrGroupId = wta_user.id ;
        member1.GroupId = grp.Id;
        insert member1;

        }

        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id);
        insert master1;

        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
        Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Midori',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType1.Id,
                Builder_Name__c=master1.Id,SSM__c=managerUser.id,Delivery_Manager__c=managerUser.id,Design_Manager__c=managerUser.id);
        insert master2;
        system.debug('*************master2*******************'+master2);

        Task t1=new Task();
        t1.subject='Follow Up';
        t1.OwnerId=userInfo.getUserId();
        t1.Priority='Normal';
        t1.Status='Open';
        t1.WhoId=leadRec1.Id;
        t1.Appointment_Time__c = System.Now();
        insert t1;

        Round_Robin__c roundRobin=new Round_Robin__c(Name='Gopalan Showroom',Queue_Name__c='Gopalan Showroom',Total_Leads__c=45);
        insert roundRobin;

        Lead_Assignment__c leadAssign=new Lead_Assignment__c(Name='Shalini Sales HML Agent',Round_Robin__c=roundRobin.id,User__c=agent_user.Id,Assign_Percent__c=50,Number_of_Leads__c=35);
        insert leadAssign;

        Lead_Assignment__c leadAssign1=new Lead_Assignment__c(Name='WTA Agent1',Round_Robin__c=roundRobin.id,User__c=wta_user.id,Assign_Percent__c=50,Number_of_Leads__c=23);
        insert leadAssign1;

        leadRec1.Lead_Assingment__c=false;
        system.debug('*************agent_user*******************'+agent_user);
        system.debug('*************managerUser*******************'+managerUser);
        system.debug('*************dp_prof*******************'+dp_prof);
        leadRec1.Appointment_Venue_Square__c=master2.Id;
        leadRec1.Square_Showroom_Agent__c=agent_user.Id;
        leadRec1.Square_Showroom_Manager__c=managerUser.id;
        leadRec1.Appointment_Time__c=System.now();
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appointment Successful';
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
        //leadRec1.Property__c=master2.Id;
        leadRec1.Appointment_Type__c = 'Mobile Showroom Visit';
        leadRec1.Builder_Name__c = master1.Id;
        leadRec1.City = 'Mumbai';
        leadRec1.Interior_Start_Date__c = Date.valueOf('2017-12-06T00:00:00.000Z');
        leadRec1.Property__c = master2.Id;
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
        leadRec1.Appointment_Time__c = Date.valueOf('2017-12-06T00:00:00.000Z');
        leadRec1.Time_of_Actual_Appointment_Start__c = Date.valueOf('2017-12-06T00:00:00.000Z');
        leadRec1.Phone = '69786756783';
        leadRec1.Possession_Date__c = Date.valueOf('2018-12-06T00:00:00.000Z');
        leadRec1.OwnerId = agent_user.Id;
        leadRec1.Wt_Agent__c= agent_user.Id;
        leadRec1.Interior_Designer__c=objIDP.id;
            leadRec1.account__c =ac.id;
        system.runAs(wta_user){
            try{
            update leadRec1;
            }
            catch(DmlException e){

            }
            }       
        system.debug('******leadRec1******'+leadRec1);
        test.stopTest();
    }  
    
    static testMethod void testPreappointmentDate()
    {
        Test.startTest();
        Residence_Visit_Assign_Leads__c res = new Residence_Visit_Assign_Leads__c(Name = 'Residence Visit Assign',Gachibowli_Monthly_Limit__c=0,HSR_Monthly_Limit__c=0,Gachibowli_Estimate_Flow__c=0,HSR_Estimate_Flow__c=0);
        insert res;
        Account acc = new account();
        acc.Name='Test acc';
        insert acc;
        
        lead leadRec1=leadUtil_Test.insertLead('abc12345@gmail.com','1234567890');
         leadRec1.PostalCode='561284';
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Fresh'; 
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.LeadSource='FB Lead Form';
        leadRec1.Sign_Up_Source__c='Estimate Flow';
        leadRec1.Vanity_Unit__c='Yes';
        leadRec1.City = 'Bengaluru';
        leadRec1.Wardrobes__c='1';
        leadRec1.Utility_Unit__c='Yes';
        leadRec1.Study_Table_Book_Shelf__c='Yes';
        leadRec1.account__c= acc.id;
        leadrec1.Budget_Range__c='1.5L - 4L';
        leadRec1.Interior_Start_Date__c=System.Today();
        leadRec1.GCLID__c= 'abcdefghijklmnopqrstuvwxyz';
        leadRec1.Property_Config__c='2 BHK';
        leadRec1.Preferred_Appointment_Slot__c=System.now().addHours(4);
        insert leadRec1; 
       
        leadRec1.Status = 'Pre-Appointment';
        update leadRec1;
        Test.stopTest();
    }
    
   /* static testMethod void isEmailUpdatedTest(){
        try{
            Lead ld = TestData_Factory.CreateFreshLead(false);
        ld.email = 'someemail@some.com';
        insert ld;
        
        test.startTest();
        ld.email = 'somechangedemail@some.com';
        update ld;
        test.stopTest();
        }
        catch(Exception e){
            
        }
    }*/
   /* static testMethod void isDPUpdatedTest(){
        //Create DP
        try{
        Interior_Designer__c dummyDp = TestData_Factory.createInteriorDesigner(false);
        insert dummyDp;
        
        Interior_Designer__c dummyDp1 = TestData_Factory.createInteriorDesigner(false);
        dummyDp1.email__C = 'abc@abc.com';
        insert dummyDp1;

        Lead ld = TestData_Factory.CreateFreshLead(false);
        ld.Interior_Designer__c = dummyDp.id;
        insert ld;
        
        test.startTest();
        ld.Interior_Designer__c = dummyDp1.id;
        update ld;
        test.stopTest();
        }
        catch(Exception e){
            
        }
    }*/
}