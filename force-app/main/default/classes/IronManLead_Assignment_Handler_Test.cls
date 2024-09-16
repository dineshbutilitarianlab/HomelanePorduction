@isTest
Public class IronManLead_Assignment_Handler_Test{
    public static lead objLead ;
    public static lead ld ;
    public static Showroom_User__c objShowroom;
    public static Showroom_User__c showroomUser;
    public static Showroom_User__c showroomUser1;
    public static Showroom_User__c showroomUser2;
    public static Territory__c objTerr;
    public static Lead_and_IM_class_Mapping__mdt leadIMMap;
    public static Master__c Showroom;
    
      @TestSetup static void data() 
      { 
        showroomUser= TestData_Factory.createShowroomUser(false);
        showroomUser.Threashold__c = 10;
        showroomUser.Backlogs__c = 2;
        showroomUser.Daily_Assignment__c = 1;
        showroomUser.Daily_Assignment_Limit__c = 10;
        showroomUser.IsActive__c = true; 
        showroomUser.Monthly_Assignment__c = 0;
        showroomUser.Monthly_Assignment_Limit__c = 100;
        showroomUser.Role__c ='Inside Sales Agent';
        showroomUser.Outskirts_Assignment__c=1;
        showroomUser.Outskirts_Assignment_Limit__c=3;
        showroomUser.IM_Class__c= 'Bronze';
        insert showroomUser;
        
         //Create showroom User
        Account acc = new account();
        acc.Name='acctest';
        insert acc;

        ld = TestData_Factory.CreateFreshLead(false);
        ld.Status = 'Fresh Lead';
        ld.Sub_Status__c = 'Unverified';
        ld.Account__c =acc.id;
        ld.postalcode='123456';
        ld.Inside_Sales_Agent__c=showroomUser.id;
                
        insert ld;
          
          
        Showroom = TestData_Factory.CreateShowRoom(true);
          
        showroomUser1 = TestData_Factory.createShowroomUser(true);
        showroomUser1.Offline_Daily_Assignment__c=0;
        showroomUser1.Offline_Daily_Assignment_Limit__c=10;
        showroomUser1.Offline_Monthly_Assignment__c=2;
        showroomUser1.Offline_Monthly_Assignment_Limit__c=100;
        showroomUser1.Showroom_Name__c=Showroom.id;
        showroomUser1.Daily_Assignment__c = 1;
        showroomUser1.Daily_Assignment_Limit__c = 10;
        showroomUser1.IsActive__c = true; 
        showroomUser1.Monthly_Assignment__c = 0;
        showroomUser1.Monthly_Assignment_Limit__c = 100;
        showroomUser1.WT_Leads_Daily_Assignment__c = 0;
        showroomUser1.WT_Leads_Daily_Assignment_Limit__c = 100;
        showroomUser1.Role__c ='Iron Man';
        showroomUser1.Specialisation__c = 'Paint';
        
        Update showroomUser1;
          
        showroomUser2 = TestData_Factory.createShowroomUser(true);
        showroomUser2.Offline_Daily_Assignment__c=1;
        showroomUser2.Offline_Daily_Assignment_Limit__c=10;
        showroomUser2.Offline_Monthly_Assignment__c=2;
        showroomUser2.Offline_Monthly_Assignment_Limit__c=100;
        showroomUser2.Showroom_Name__c=Showroom.id;
        showroomUser2.Daily_Assignment__c = 1;
        showroomUser2.Daily_Assignment_Limit__c = 10;
        showroomUser2.IsActive__c = true; 
        showroomUser2.Monthly_Assignment__c = 0;
        showroomUser2.Monthly_Assignment_Limit__c = 100;
        showroomUser2.WT_Leads_Daily_Assignment__c = 0;
        showroomUser2.WT_Leads_Daily_Assignment_Limit__c = 100;
        showroomUser2.Role__c ='Iron Man';
        showroomUser2.Specialisation__c = 'Paint';
        Update showroomUser2;        
        
    }  
    
    
   public static testMethod void OfflineCounterAssignment()
    {
        list<Lead> lstLead = [Select Id,email,LastName,LeadSource,Postalcode,city,Assigned_To_Resi_ASM__c,Should_run_Ironman_assignment__c,
                              phone,Squad_IQ_Status__c,Status,Sub_Status__c,Bulk_Upload__C,Brand__c,Meeting_Source__c From Lead Limit 1];
        
        list<Master__c> lstShowroom =[select id from Master__C limit 1];
        
        objLead = lstLead[0];
        
        Test.startTest();
        ld=TestData_Factory.MarkAsPreAppointment(objLead,false);
        ld.Appointment_Venue_Square__c=lstShowroom[0].id;
        ld.Bulk_Upload__c=true;
        ld.Budget_Range__c=GenericConstants.Lead_Budget_1L;
        ld.Preferred_Appointment_Slot__c = System.today() + 1;
        
        Update ld;    
        IronManLead_Assignment_Handler.dummyTestCover();
        
        Test.stopTest();
    }
    
    
    public static testMethod void ProntoPaintAssignment()
    {        
                
        Test.startTest();
        
        Account acc = new account();
        acc.Name='acctest';
        insert acc;

        ld = TestData_Factory.CreateFreshLead(false);
        ld.Status = 'Fresh Lead';
        ld.Sub_Status__c = 'Unverified';
        ld.Account__c =acc.id;
        ld.postalcode='123456';
        ld.Bulk_Upload__c=true;
        ld.Budget_Range__c=GenericConstants.Lead_Budget_1L;
        ld.Sign_Up_Source__c= 'Pronto Paint';      
        
        insert ld;    
        Test.stopTest();
    }
    
    
    public static testMethod void WTAtoIMLeadAssignmentCheckPincodeTest2(){
        
        Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.Threashold__c = 10;
        objShowroom1.Backlogs__c = 2;
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.WT_Leads_Daily_Assignment__c = 0;
        objShowroom1.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Specialisation__c = 'Paint';
        insert ObjShowroom1;
        
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
        objShowroom2.Email__c = 'TestSHowRoomasdUSer2@test.com';
        objShowroom2.Threashold__c = 10;
        objShowroom2.Backlogs__c = 2;
        objShowroom2.Daily_Assignment__c = 4;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true;
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.WT_Leads_Daily_Assignment__c = 0;
        objShowroom2.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom2.Role__c ='Iron Man';
        objShowroom2.Specialisation__c = 'Paint';
        insert objShowroom2;
        
        Showroom_User__c objShowroom3 = TestData_Factory.createShowroomUser(false);
        objShowroom3.Email__c = 'TestSHowRoomasdUSer@test.com';
        objShowroom3.Threashold__c = 10;
        objShowroom3.Backlogs__c = 2;
        objShowroom3.Daily_Assignment__c = 1;
        objShowroom3.Daily_Assignment_Limit__c = 10;
        objShowroom3.IsActive__c = true;
        objShowroom3.Monthly_Assignment__c = 0;
        objShowroom3.Monthly_Assignment_Limit__c = 100;
        objShowroom3.WT_Leads_Daily_Assignment__c = 0;
        objShowroom3.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom3.Role__c ='Iron Man';
        insert objShowroom3;            
        
        
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
        objTerr.Lat_Long__Latitude__s = 25.0936477440000;
        objTerr.Lat_Long__Longitude__s =  79.7849897840000;
        objTerr.Cluster__c ='Homelane';
        Insert objTerr ;
        
        Territory__c objTerr1 = TestData_Factory.createTerritory('Area b',ObjShowroom2.id,'Bengaluru','Cluster A','123457',False);
        objTerr1.Lat_Long__Latitude__s = 23.0936477440000;
        objTerr1.Lat_Long__Longitude__s =  80.7849897840000;
        objTerr1.Cluster_Brand__c = 'Homelane';
        Insert objTerr1;
        
        Territory__c objTerr2 = TestData_Factory.createTerritory('Area b',ObjShowroom3.id,'Bengaluru','Cluster A','123459',False);
        objTerr2.Lat_Long__Latitude__s = 24.0936477440000;
        objTerr2.Lat_Long__Longitude__s =  87.7849897840000;
        objTerr2.Cluster_Brand__c ='Homelane';
        Insert objTerr2;                            
        
        ld = [Select Id,email,LastName,LeadSource,Sign_Up_Source__c,Brand__c,PostalCode From Lead limit 1];       
        
        ld.Brand__c='Homelane';
        ld.Assigned_to_Resi_ASM__c = false;
        ld.Budget_Range__c='Upto 1.5L';
        ld.Inside_Sales_Agent__c = null;
        update ld;
        Test.startTest();
        TestData_Factory.MarkAsPreAppointment(ld, false);
        ld.Budget_Range__c=GenericConstants.Lead_Budget_4L;
        ld.Preferred_Appointment_Slot__c = System.today() + 1;
        ld.Postalcode = '123457';
        update ld;
        Test.stopTest();
    }
    public static testMethod void WTAtoIMLeadAssignmentCheckPincodeTest3(){
        
        Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.Threashold__c = 10;
        objShowroom1.Backlogs__c = 2;
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = false; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.WT_Leads_Daily_Assignment__c = 0;
        objShowroom1.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Product Consultant';
        insert ObjShowroom1;
        
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
        objShowroom2.Email__c = 'TestSHowRoomasdUSer2@test.com';
        objShowroom2.Threashold__c = 10;
        objShowroom2.Backlogs__c = 2;
        objShowroom2.Daily_Assignment__c = 4;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = false;
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.WT_Leads_Daily_Assignment__c = 0;
        objShowroom2.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom2.Role__c ='Product Consultant';
        insert objShowroom2;
        
        Showroom_User__c objShowroom3 = TestData_Factory.createShowroomUser(false);
        objShowroom3.Email__c = 'TestSHowRoomasdUSer@test.com';
        objShowroom3.Threashold__c = 10;
        objShowroom3.Backlogs__c = 2;
        objShowroom3.Daily_Assignment__c = 1;
        objShowroom3.Daily_Assignment_Limit__c = 10;
        objShowroom3.IsActive__c = false;
        objShowroom3.Monthly_Assignment__c = 0;
        objShowroom3.Monthly_Assignment_Limit__c = 100;
        objShowroom3.WT_Leads_Daily_Assignment__c = 0;
        objShowroom3.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom3.Role__c ='Product Consultant';
        
        insert objShowroom3;            
        
        
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
        objTerr.Lat_Long__Latitude__s = 25.0936477440000;
        objTerr.Lat_Long__Longitude__s =  79.7849897840000;
        objTerr.Cluster__c ='Doow up';
        Insert objTerr ;
        
        Territory__c objTerr1 = TestData_Factory.createTerritory('Area b',ObjShowroom2.id,'Bengaluru','Cluster A','123457',False);
        objTerr1.Lat_Long__Latitude__s = 23.0936477440000;
        objTerr1.Lat_Long__Longitude__s =  80.7849897840000;
        objTerr1.Cluster_Brand__c = 'Doow up';
        Insert objTerr1;
        
        Territory__c objTerr2 = TestData_Factory.createTerritory('Area b',ObjShowroom3.id,'Bengaluru','Cluster A','123459',False);
        objTerr2.Lat_Long__Latitude__s = 24.0936477440000;
        objTerr2.Lat_Long__Longitude__s =  87.7849897840000;
        objTerr2.Cluster_Brand__c ='Doow up';
        Insert objTerr2;                            
        
        
         ld = [Select Id,email,LastName,LeadSource,Sign_Up_Source__c,Brand__c,PostalCode From Lead limit 1];       
        
        ld.Brand__c='Doowup';
        ld.Assigned_to_Resi_ASM__c = false;
        ld.Budget_Range__c='Upto 1.5L';
        ld.Inside_Sales_Agent__c = null;
        update ld;
        Test.startTest();
        TestData_Factory.MarkAsPreAppointment(ld, false);
        ld.Budget_Range__c=GenericConstants.Lead_Budget_4L;
        ld.Preferred_Appointment_Slot__c = System.today() + 1;
        ld.Postalcode = '123457';
        update ld;
        Test.stopTest();
        
        //list<Lead> lstLead = [Select Id,email,LastName,LeadSource,Postalcode,city,Assigned_To_Resi_ASM__c,Should_run_Ironman_assignment__c,phone,Squad_IQ_Status__c,Status,Sub_Status__c,Bulk_Upload__C ,Brand__c,Assigned_To_TLC__c From Lead];
        //Set<String>  setString= new set<String>();
        //setString.add(lstLead[0].Postalcode);
        
        //IronManLead_Assignment_Handler.getProductConsultantDetailsWTAtoIMAssignment(lstLead,setString);
        list<Territory__c > lst = [Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Is_Active__c,Cluster_Brand__c  from Territory__c];
        System.debug('+++++++lst ++++'+lst );
    }
    public static testMethod void WTAtoIMLeadAssignmentCheckPincodeTest4(){
        
        Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.Threashold__c = 10;
        objShowroom1.Backlogs__c = 2;
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.WT_Leads_Daily_Assignment__c = 0;
        objShowroom1.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom1.WT_Leads_Monthly_Assignment__c=0;
          objShowroom1.WT_Leads_Monthly_Assignment_Limit__c=100;
        objShowroom1.Role__c ='Product Consultant';
        insert ObjShowroom1;
        
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
        objShowroom2.Email__c = 'TestSHowRoomasdUSer2@test.com';
        objShowroom2.Threashold__c = 10;
        objShowroom2.Backlogs__c = 2;
        objShowroom2.Daily_Assignment__c = 4;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true;
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.WT_Leads_Daily_Assignment__c = 0;
        objShowroom2.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom2.WT_Leads_Monthly_Assignment__c=0;
          objShowroom2.WT_Leads_Monthly_Assignment_Limit__c=100;
        objShowroom2.Role__c ='Product Consultant';
        insert objShowroom2;
        
        Showroom_User__c objShowroom3 = TestData_Factory.createShowroomUser(false);
        objShowroom3.Email__c = 'TestSHowRoomasdUSer@test.com';
        objShowroom3.Threashold__c = 10;
        objShowroom3.Backlogs__c = 2;
        objShowroom3.Daily_Assignment__c = 1;
        objShowroom3.Daily_Assignment_Limit__c = 10;
        objShowroom3.IsActive__c = true;
        objShowroom3.Monthly_Assignment__c = 0;
        objShowroom3.Monthly_Assignment_Limit__c = 100;
        objShowroom3.WT_Leads_Daily_Assignment__c = 0;
        objShowroom3.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom3.WT_Leads_Monthly_Assignment__c=0;
          objShowroom3.WT_Leads_Monthly_Assignment_Limit__c=100;
        objShowroom3.Role__c ='Product Consultant';
        
        insert objShowroom3;            
        
        
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
        objTerr.Lat_Long__Latitude__s = 25.0936477440000;
        objTerr.Lat_Long__Longitude__s =  79.7849897840000;
        objTerr.Cluster__c ='Doow up';
        Insert objTerr ;
        
        Territory__c objTerr1 = TestData_Factory.createTerritory('Area b',ObjShowroom2.id,'Bengaluru','Cluster A','123457',False);
        objTerr1.Lat_Long__Latitude__s = 23.0936477440000;
        objTerr1.Lat_Long__Longitude__s =  80.7849897840000;
        objTerr1.Cluster_Brand__c = 'Doow up';
        Insert objTerr1;
        
        Territory__c objTerr2 = TestData_Factory.createTerritory('Area b',ObjShowroom3.id,'Bengaluru','Cluster A','123459',False);
        objTerr2.Lat_Long__Latitude__s = 24.0936477440000;
        objTerr2.Lat_Long__Longitude__s =  87.7849897840000;
        objTerr2.Cluster_Brand__c ='Doow up';
        Insert objTerr2;                            
        
        
         ld = [Select Id,email,LastName,LeadSource,Sign_Up_Source__c,Brand__c,PostalCode From Lead limit 1];       
        
        ld.Brand__c='Doowup';
        ld.Assigned_to_Resi_ASM__c = false;
        ld.Budget_Range__c='Upto 1.5L';
        ld.Inside_Sales_Agent__c = null;
        update ld;
        Test.startTest();
        TestData_Factory.MarkAsPreAppointment(ld, false);
        ld.Budget_Range__c=GenericConstants.Lead_Budget_4L;
        ld.Preferred_Appointment_Slot__c = System.today() + 1;
        ld.Postalcode = '123457';
        update ld;
        Test.stopTest();
        
        //list<Lead> lstLead = [Select Id,email,LastName,LeadSource,Postalcode,city,Assigned_To_Resi_ASM__c,Should_run_Ironman_assignment__c,phone,Squad_IQ_Status__c,Status,Sub_Status__c,Bulk_Upload__C ,Brand__c,Assigned_To_TLC__c From Lead];
        //Set<String>  setString= new set<String>();
        //setString.add(lstLead[0].Postalcode);
        
        //IronManLead_Assignment_Handler.getProductConsultantDetailsWTAtoIMAssignment(lstLead,setString);
        list<Territory__c > lst = [Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Is_Active__c,Cluster_Brand__c  from Territory__c];
        System.debug('+++++++lst ++++'+lst );
    }
    public static testMethod void PCLeadAssignmentCheckPincodeTest1(){
        
        Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.Threashold__c = 10;
        objShowroom1.Backlogs__c = 2;
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.WT_Leads_Daily_Assignment__c = 0;
        objShowroom1.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom1.WT_Leads_Monthly_Assignment__c=0;
          objShowroom1.WT_Leads_Monthly_Assignment_Limit__c=100;
        objShowroom1.Role__c ='Product Consultant';
        insert ObjShowroom1;
        
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
        objShowroom2.Email__c = 'TestSHowRoomasdUSer2@test.com';
        objShowroom2.Threashold__c = 10;
        objShowroom2.Backlogs__c = 2;
        objShowroom2.Daily_Assignment__c = 4;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true;
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.WT_Leads_Daily_Assignment__c = 0;
        objShowroom2.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom2.WT_Leads_Monthly_Assignment__c=0;
          objShowroom2.WT_Leads_Monthly_Assignment_Limit__c=100;
        objShowroom2.Role__c ='Product Consultant';
        insert objShowroom2;
        
        Showroom_User__c objShowroom3 = TestData_Factory.createShowroomUser(false);
        objShowroom3.Email__c = 'TestSHowRoomasdUSer@test.com';
        objShowroom3.Threashold__c = 10;
        objShowroom3.Backlogs__c = 2;
        objShowroom3.Daily_Assignment__c = 1;
        objShowroom3.Daily_Assignment_Limit__c = 10;
        objShowroom3.IsActive__c = true;
        objShowroom3.Monthly_Assignment__c = 0;
        objShowroom3.Monthly_Assignment_Limit__c = 100;
        objShowroom3.WT_Leads_Daily_Assignment__c = 0;
        objShowroom3.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom3.WT_Leads_Monthly_Assignment__c=0;
          objShowroom3.WT_Leads_Monthly_Assignment_Limit__c=100;
        objShowroom3.Role__c ='Product Consultant';
        
        insert objShowroom3;            
        
        
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
        objTerr.Lat_Long__Latitude__s = 25.0936477440000;
        objTerr.Lat_Long__Longitude__s =  79.7849897840000;
        objTerr.Cluster__c ='Doow up';
        Insert objTerr ;
        
        Territory__c objTerr1 = TestData_Factory.createTerritory('Area b',ObjShowroom2.id,'Bengaluru','Cluster A','123457',False);
        objTerr1.Lat_Long__Latitude__s = 23.0936477440000;
        objTerr1.Lat_Long__Longitude__s =  80.7849897840000;
        objTerr1.Cluster_Brand__c = 'Doow up';
        Insert objTerr1;
        
        Territory__c objTerr2 = TestData_Factory.createTerritory('Area b',ObjShowroom3.id,'Bengaluru','Cluster A','123459',False);
        objTerr2.Lat_Long__Latitude__s = 24.0936477440000;
        objTerr2.Lat_Long__Longitude__s =  87.7849897840000;
        objTerr2.Cluster_Brand__c ='Doow up';
        Insert objTerr2;                            
        
        
         ld = [Select Id,email,LastName,LeadSource,Sign_Up_Source__c,Brand__c,PostalCode From Lead limit 1];
       Test.startTest();
     //   ld.Preferred_Appointment_Slot__c = System.today() + 1;
        ld.Brand__c='Doowup';
        ld.Assigned_to_Resi_ASM__c = false;
        ld.Budget_Range__c='Upto 1.5L';
        ld.Inside_Sales_Agent__c = null;
        ld.Sub_Status__c= 'New';
        ld.PostalCode='123457';
        update ld;
        
        
        Test.stopTest();
        
        //list<Lead> lstLead = [Select Id,email,LastName,LeadSource,Postalcode,city,Assigned_To_Resi_ASM__c,Should_run_Ironman_assignment__c,phone,Squad_IQ_Status__c,Status,Sub_Status__c,Bulk_Upload__C ,Brand__c,Assigned_To_TLC__c From Lead];
        //Set<String>  setString= new set<String>();
        //setString.add(lstLead[0].Postalcode);
        
        //IronManLead_Assignment_Handler.getProductConsultantDetailsWTAtoIMAssignment(lstLead,setString);
        list<Territory__c > lst = [Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Is_Active__c,Cluster_Brand__c  from Territory__c];
        System.debug('+++++++lst ++++'+lst );
    }
    public static testMethod void PCInsideSalesAssignmentCheckPincodeTest1(){
        
        Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.Threashold__c = 10;
        objShowroom1.Backlogs__c = 2;
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = false; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.WT_Leads_Daily_Assignment__c = 0;
        objShowroom1.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom1.WT_Leads_Monthly_Assignment__c=0;
          objShowroom1.WT_Leads_Monthly_Assignment_Limit__c=100;
        objShowroom1.Role__c ='Product Consultant';
        insert ObjShowroom1;
        
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
        objShowroom2.Email__c = 'TestSHowRoomasdUSer2@test.com';
        objShowroom2.Threashold__c = 10;
        objShowroom2.Backlogs__c = 2;
        objShowroom2.Daily_Assignment__c = 4;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true;
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.WT_Leads_Daily_Assignment__c = 0;
        objShowroom2.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom2.WT_Leads_Monthly_Assignment__c=0;
          objShowroom2.WT_Leads_Monthly_Assignment_Limit__c=100;
        objShowroom2.Role__c ='Inside Sales Agent';
        insert objShowroom2;
        
        Showroom_User__c objShowroom3 = TestData_Factory.createShowroomUser(false);
        objShowroom3.Email__c = 'TestSHowRoomasdUSer@test.com';
        objShowroom3.Threashold__c = 10;
        objShowroom3.Backlogs__c = 2;
        objShowroom3.Daily_Assignment__c = 1;
        objShowroom3.Daily_Assignment_Limit__c = 10;
        objShowroom3.IsActive__c = false;
        objShowroom3.Monthly_Assignment__c = 0;
        objShowroom3.Monthly_Assignment_Limit__c = 100;
        objShowroom3.WT_Leads_Daily_Assignment__c = 0;
        objShowroom3.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom3.WT_Leads_Monthly_Assignment__c=0;
          objShowroom3.WT_Leads_Monthly_Assignment_Limit__c=100;
        objShowroom3.Role__c ='Product Consultant';
        
        insert objShowroom3;            
        
        
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
        objTerr.Lat_Long__Latitude__s = 25.0936477440000;
        objTerr.Lat_Long__Longitude__s =  79.7849897840000;
        objTerr.Cluster__c ='Doow up';
        objTerr.Sales_Campaign__c ='Inside Sales';
        objTerr.Inside_Sales_Agent__c =objShowroom2.id;
        objTerr.Inside_Sales_Cluster__c ='insales';
        
        Insert objTerr ;
        
                                  
        
        
         ld = [Select Id,email,LastName,LeadSource,Sign_Up_Source__c,Brand__c,PostalCode From Lead limit 1];
       
     //   ld.Preferred_Appointment_Slot__c = System.today() + 1;
        ld.Brand__c='Doowup';
        ld.Assigned_to_Resi_ASM__c = false;
        ld.Budget_Range__c='Upto 1.5L';
        //ld.Inside_Sales_Agent__c = null;
        ld.Sub_Status__c= 'New';
        ld.PostalCode='123456';
        update ld;
        Test.startTest();
        ld.Sub_Status__c= 'New';
        update ld;
        Test.stopTest();
        
        //list<Lead> lstLead = [Select Id,email,LastName,LeadSource,Postalcode,city,Assigned_To_Resi_ASM__c,Should_run_Ironman_assignment__c,phone,Squad_IQ_Status__c,Status,Sub_Status__c,Bulk_Upload__C ,Brand__c,Assigned_To_TLC__c From Lead];
        //Set<String>  setString= new set<String>();
        //setString.add(lstLead[0].Postalcode);
        
        //IronManLead_Assignment_Handler.getProductConsultantDetailsWTAtoIMAssignment(lstLead,setString);
        list<Territory__c > lst = [Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Is_Active__c,Cluster_Brand__c  from Territory__c];
        System.debug('+++++++lst ++++'+lst );
    }
    
  /*  public static testMethod void getIronManPaintSpecilistTest(){
        Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.Threashold__c = 10;
        objShowroom1.Backlogs__c = 2;
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.WT_Leads_Daily_Assignment__c = 0;
        objShowroom1.WT_Leads_Daily_Assignment_Limit__c = 100;
        objShowroom1.Specialisation__c='Paint';
        insert ObjShowroom1;
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
        objShowroom2.Threashold__c = 10;
        objShowroom2.Backlogs__c = 2;
        objShowroom2.Daily_Assignment__c = 1;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true; 
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.WT_Leads_Daily_Assignment__c = 0;
        objShowroom2.WT_Leads_Daily_Assignment_Limit__c = 100;
         objShowroom2.Specialisation__c='Paint';
        insert ObjShowroom2;
        Account ac= new Account();
        ac.Name='test acc';
        insert ac;
        lead objLead = new Lead();
        objlead = TestData_Factory.CreateFreshLead(false);
        objLead.LeadSource ='HL Pronto';
        objLead.Sign_Up_Source__c='HL Pronto';
        objLead.Account__c=ac.id;
        insert objLead;
        list<Lead> lstLead = [Select Id,email,LastName,LeadSource,Sign_Up_Source__c From Lead];
        Test.startTest();
        IronManLead_Assignment_Handler.getIronManPaintSpecialist(lstLead);
        Test.stopTest();
    }*/
    
    // IronManLead_Assignment_Handler.dummytest();
    public static testMethod void greenLeadAssign1(){
        Test.startTest();
     Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Gold';
        
        insert ObjShowroom1;
     
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
        objTerr.Lat_Long__Latitude__s = 20.0936477440000;
        objTerr.Lat_Long__Longitude__s =  89.7849897840000;
        objTerr.Cluster_Brand__c ='Homelane';
        objTerr.Sales_Campaign__c ='Green Channel';
        
        
        Insert objTerr ;  
      
      
      Account ac = new account();
        ac.Name='testacc';
      insert ac;
       Lead objLead = new Lead();
      objlead = TestData_Factory.CreateFreshLead(false);
      objlead.Postalcode = '123456';
      objLead.Brand__c ='Homelane';
      objLead.City='Bengaluru';
      objLead.IM_Assignment_Stage__c ='Lead Creation';
      objLead.Account__c= ac.id;
      objLead.leadSource ='Website';
      
      Insert objlead;
        Test.stopTest();
    }
    public static testMethod void normalLeadAssign1(){
        Test.startTest();
     Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Gold';
        
        insert ObjShowroom1;
     
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
        objTerr.Lat_Long__Latitude__s = 20.0936477440000;
        objTerr.Lat_Long__Longitude__s =  89.7849897840000;
        objTerr.Cluster_Brand__c ='Homelane';
        objTerr.Sales_Campaign__c =null;
        
        
        Insert objTerr ;  
      
      
      Account ac = new account();
        ac.Name='testacc';
      insert ac;
       Lead objLead = new Lead();
      objlead = TestData_Factory.CreateFreshLead(false);
      objlead.Postalcode = '123456';
      objLead.Brand__c ='Homelane';
      objLead.City='Bengaluru';
      objLead.IM_Assignment_Stage__c ='Lead Creation';
      objLead.Account__c= ac.id;
      objLead.leadSource ='Website';
      
      Insert objlead;
        Test.stopTest();
    }
    public static testMethod void normalLeadOzonetalPCAssign1(){
        Test.startTest();
     Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = false; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Gold';
        objShowroom1.Role__c ='Product Consultant';
        insert ObjShowroom1;
     
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
        objTerr.Lat_Long__Latitude__s = 20.0936477440000;
        objTerr.Lat_Long__Longitude__s =  89.7849897840000;
        objTerr.Cluster_Brand__c ='Doow up';
        objTerr.Sales_Campaign__c =null;
        
        
        Insert objTerr ;  
      
      
      Account ac = new account();
        ac.Name='testacc';
      insert ac;
       Lead objLead = new Lead();
      objlead = TestData_Factory.CreateFreshLead(false);
      objlead.Postalcode = '123456';
      objLead.Brand__c ='Doowup';
      objLead.City='Bengaluru';
      objLead.IM_Assignment_Stage__c ='Lead Creation';
      objLead.Account__c= ac.id;
      objLead.leadSource ='Website';
      
      Insert objlead;
        Test.stopTest();
    }
    public static testMethod void insideSalesAssign1(){
        Test.startTest();
     Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Inside Sales Agent';
        
        
        insert ObjShowroom1;
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
      
        objShowroom2.Daily_Assignment__c = 1;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true; 
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.Role__c ='Iron Man';
        insert objShowroom2;
     
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom2.id,'Bengaluru','Cluster I','654321',False);
        objTerr.Lat_Long__Latitude__s = 20.0936477440000;
        objTerr.Lat_Long__Longitude__s =  89.7849897840000;
        objTerr.Cluster_Brand__c ='Homelane';
        objTerr.Sales_Campaign__c ='Inside Sales';
        objTerr.Inside_Sales_Agent__c = ObjShowroom1.id;
        objTerr.Inside_Sales_Cluster__c ='Inside_Sales_1';
        
        
        Insert objTerr ;  
      
      
      Account ac = new account();
        ac.Name='testacc';
      insert ac;
       Lead objLead = new Lead();
      objlead = TestData_Factory.CreateFreshLead(false);
      objlead.Postalcode = '654321';
      objLead.Brand__c ='Homelane';
      objLead.City='Bengaluru';
      objLead.IM_Assignment_Stage__c ='Lead Creation';
      objLead.Account__c= ac.id;
      objLead.leadSource ='Website';
      
      Insert objlead;
        Test.stopTest();
    }
    
    public static testMethod void insideSalesPCAssign1(){
        Test.startTest();
     Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Inside Sales Agent';
        
        
        insert ObjShowroom1;
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
      
        objShowroom2.Daily_Assignment__c = 1;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true; 
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.Role__c ='Iron Man';
        insert objShowroom2;
     
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom2.id,'Bengaluru','Cluster I','654321',False);
        objTerr.Lat_Long__Latitude__s = 20.0936477440000;
        objTerr.Lat_Long__Longitude__s =  89.7849897840000;
        objTerr.Cluster_Brand__c ='Doow up';
        objTerr.Sales_Campaign__c ='Inside Sales';
        objTerr.Inside_Sales_Agent__c = ObjShowroom1.id;
        objTerr.Inside_Sales_Cluster__c ='Inside_Sales_1';
        
        
        Insert objTerr ;  
      
      
      Account ac = new account();
        ac.Name='testacc';
      insert ac;
       Lead objLead = new Lead();
      objlead = TestData_Factory.CreateFreshLead(false);
      objlead.Postalcode = '654321';
      objLead.Brand__c ='Doowup';
      objLead.City='Bengaluru';
      objLead.IM_Assignment_Stage__c ='Lead Creation';
      objLead.Account__c= ac.id;
      objLead.leadSource ='Website';
      
      Insert objlead;
        Test.stopTest();
    }
    public static testMethod void insideSalesAssign2(){
        Test.startTest();
     Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Inside Sales Agent';
        objShowroom1.Outskirts_Assignment__c=1;
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Gold';
        
        insert ObjShowroom1;
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
      
        objShowroom2.Daily_Assignment__c = 1;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true; 
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.Role__c ='Iron Man';
        objShowroom2.Outskirts_Assignment__c=1;
        objShowroom2.Outskirts_Assignment_Limit__c=3;
        objShowroom2.IM_Class__c= 'Gold';
        insert objShowroom2;
     
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom2.id,'Outskirts','Cluster I','654321',False);
        objTerr.Lat_Long__Latitude__s = 20.0936477440000;
        objTerr.Lat_Long__Longitude__s =  89.7849897840000;
        objTerr.Cluster_Brand__c ='Homelane';
        objTerr.Sales_Campaign__c ='Inside Sales';
        objTerr.Inside_Sales_Agent__c = ObjShowroom1.id;
        objTerr.Inside_Sales_Cluster__c ='Inside_Sales_1';
        
        Insert objTerr ;  
      
      
      Account ac = new account();
        ac.Name='testacc';
      insert ac;
       Lead objLead = new Lead();
      objlead = TestData_Factory.CreateFreshLead(false);
      objlead.Postalcode = '654321';
      objLead.Brand__c ='Homelane';
      objLead.City='Outskirts';
      objLead.IM_Assignment_Stage__c ='Lead Creation';
      objLead.Account__c= ac.id;
      objLead.leadSource ='Website';
      
      Insert objlead;
        Test.stopTest();
    }
    public static testMethod void central1(){
        Test.startTest();
        Id leadSourceScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Gold Plus Score Leads').getRecordTypeId();
        Id leadSignUpSourceScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Gold Score Leads').getRecordTypeId();
        Id leadPostalCodeScoreRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Silver Score Leads').getRecordTypeId();
        Lead_Class_Scoring__c lcs1 = new Lead_Class_Scoring__c();
        lcs1.Lead_Source_List__c ='bing';
        lcs1.RecordTypeId= leadSignUpSourceScoreRTID;
        insert lcs1;
        
     Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Central Team Agent';
        insert ObjShowroom1;
        
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
      
        objShowroom2.Daily_Assignment__c = 1;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = False; 
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.Role__c ='Iron Man';
        objShowroom2.IM_Class__c='Gold';
        insert objShowroom2;
     
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom2.id,'Bengaluru','Cluster CT','789000',False);
        objTerr.Lat_Long__Latitude__s = 20.0936477440000;
        objTerr.Lat_Long__Longitude__s =  89.7849897840000;
        objTerr.Cluster_Brand__c ='Homelane';
        objTerr.Sales_Campaign__c ='Green Channel';
        objTerr.Inside_Sales_Agent__c = ObjShowroom1.id;
        
        
        Insert objTerr ;  
      
      
      Account ac = new account();
        ac.Name='testacc';
      insert ac;
       Lead objLead = new Lead();
      objlead = TestData_Factory.CreateFreshLead(false);
      objlead.Postalcode = '789000';
      objLead.Brand__c ='Homelane';
      objLead.City='Bengaluru';
      objLead.IM_Assignment_Stage__c ='Lead Creation';
      objLead.Account__c= ac.id;
      objLead.leadSource ='bing';
      objLead.Lead_Score_for_Assignment__c =6;      
      Insert objlead;
        Test.stopTest();
    }
    public static testMethod void getIMShowroomUsertest(){
        
          Test.startTest();
          
           Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Gold';
        
        insert ObjShowroom1;
         objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
          objTerr.Lat_Long__Latitude__s = 20.0936477440000;
          objTerr.Lat_Long__Longitude__s =  89.7849897840000;
          objTerr.Cluster_Brand__c ='Homelane';
          objTerr.Sales_Campaign__c ='Green Channel';
        
          
        
        Insert objTerr ;  
        Account ac = new account();
        ac.Name='testacc';
        insert ac;
        objLead = new Lead();
        objlead = TestData_Factory.CreateFreshLead(false);
        objlead.Postalcode = '123457';
        objLead.Brand__c ='Homelane';
        objLead.City='Bengaluru';
        objLead.IM_Assignment_Stage__c ='Lead Creation';
        objLead.Account__c= ac.id;
        objLead.leadSource ='Walk-In';
        
        Insert objlead;
        objLead.Lead_Score_for_Assignment__c =8;
        update objlead;
        
        IronmanDigitalLeadAssignment.getIMShowroomUser('Cluster A',objLead,true);
        test.stopTest();
    }
     public static testMethod void getInsidesalesHaptikUsertest(){
        
          Test.startTest();
          
           Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Gold';
        //objShowroom1.Role__c ='Inside Sales Agent';
        
        insert ObjShowroom1;
         Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
      
        objShowroom2.Daily_Assignment__c = 1;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true; 
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.Role__c ='Iron Man';
        objShowroom2.Outskirts_Assignment__c=1;
        objShowroom2.Outskirts_Assignment_Limit__c=3;
        objShowroom2.IM_Class__c= 'Gold';
        objShowroom2.Role__c ='Inside Sales Agent';
         objShowroom2.WhatsAppHaptik_Team__c = true;
        
        insert ObjShowroom2;
         objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
          objTerr.Lat_Long__Latitude__s = 20.0936477440000;
          objTerr.Lat_Long__Longitude__s =  89.7849897840000;
          objTerr.Cluster_Brand__c ='Homelane';
          //objTerr.Sales_Campaign__c ='Green Channel';
          objTerr.Inside_Sales_Cluster__c='Insales';
         ObjTerr.Inside_Sales_Agent__c=ObjShowroom2.id;
      
          
        
        Insert objTerr ;  
        
                ld=[select id,Inside_Sales_Agent__c,PostalCode, Assignment_Initiate_Stage__c from lead limit 1];
        
        ld.Sign_Up_Source__c= GenericConstants.Sign_Up_WhatsApp_Haptik;
        ld.Assignment_Initiate_Stage__c =GenericConstants.WhatsApp_Haptik_InsideSales_Assignment;
        update ld;
        
        test.stopTest();
    }
    public static testMethod void getInsidesalesswitchUsertest(){
        test.startTest();
          
           Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Gold';
        //objShowroom1.Role__c ='Inside Sales Agent
        //
        
        insert ObjShowroom1;
        
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
      
        objShowroom2.Daily_Assignment__c = 1;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true; 
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.Role__c ='Iron Man';
        objShowroom2.Outskirts_Assignment__c=1;
        objShowroom2.Outskirts_Assignment_Limit__c=3;
        objShowroom2.IM_Class__c= 'Gold';
        objShowroom2.Role__c ='Inside Sales Agent';
        
        insert ObjShowroom2;
        objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
          objTerr.Lat_Long__Latitude__s = 20.0936477440000;
          objTerr.Lat_Long__Longitude__s =  89.7849897840000;
          objTerr.Cluster_Brand__c ='Homelane';
          //objTerr.Sales_Campaign__c ='Green Channel';
          objTerr.Inside_Sales_Cluster__c='Insales';
         ObjTerr.Inside_Sales_Agent__c= ObjShowroom2.id;
        insert ObjTerr;
      
          
        
        ld=[select id,Inside_Sales_Agent__c,PostalCode, Assignment_Initiate_Stage__c from lead limit 1];
        
        ld.Assignment_Initiate_Stage__c = GenericConstants.INSIDE_SALES_SWITCH_BATCH;
        update ld;
          
       
        test.stopTest();
    }
    public static testMethod void getSpecialisedImdetailInsidetest1(){
        test.startTest();
          
           Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Gold';
        objShowroom1.Specialisation__c ='Renovation';
        //objShowroom1.Role__c ='Inside Sales Agent
        //
        
        insert ObjShowroom1;
        
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
      
        objShowroom2.Daily_Assignment__c = 1;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true; 
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.Role__c ='Iron Man';
        objShowroom2.Outskirts_Assignment__c=1;
        objShowroom2.Outskirts_Assignment_Limit__c=3;
        objShowroom2.IM_Class__c= 'Gold';
        objShowroom2.Role__c ='Inside Sales Agent';
        
        insert ObjShowroom2;
        objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
          objTerr.Lat_Long__Latitude__s = 20.0936477440000;
          objTerr.Lat_Long__Longitude__s =  89.7849897840000;
          objTerr.Cluster_Brand__c ='Homelane';
          //objTerr.Sales_Campaign__c ='Green Channel';
          objTerr.Inside_Sales_Cluster__c='Insales';
         ObjTerr.Inside_Sales_Agent__c= ObjShowroom2.id;
        insert ObjTerr;
      
          
        
        ld=[select id,Inside_Sales_Agent__c,PostalCode, Assignment_Initiate_Stage__c from lead limit 1];
        ld.Sub_Status__c = 'New';
        ld.Property_status__c ='Renovation';
        update ld;
          
       
        test.stopTest();
    }
     public static testMethod void getSpecialisedImdetailInsidetest2(){
        test.startTest();
          
           Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
      
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Gold';
        //objShowroom1.Role__c ='Inside Sales Agent
        //
        
        insert ObjShowroom1;
        
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
      
        objShowroom2.Daily_Assignment__c = 1;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true; 
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.Role__c ='Iron Man';
        objShowroom2.Outskirts_Assignment__c=1;
        objShowroom2.Outskirts_Assignment_Limit__c=3;
        objShowroom2.IM_Class__c= 'Gold';
        objShowroom2.Role__c ='Inside Sales Agent';
        
        insert ObjShowroom2;
        objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
          objTerr.Lat_Long__Latitude__s = 20.0936477440000;
          objTerr.Lat_Long__Longitude__s =  89.7849897840000;
          objTerr.Cluster_Brand__c ='Homelane';
          objTerr.Sales_Campaign__c ='Inside Sales';
          objTerr.Inside_Sales_Cluster__c='Insales';
         ObjTerr.Inside_Sales_Agent__c= ObjShowroom2.id;
        insert ObjTerr;
      
          
        
        ld=[select id,Inside_Sales_Agent__c,PostalCode, Assignment_Initiate_Stage__c from lead limit 1];
        ld.Sub_Status__c = 'New';
        ld.Property_status__c ='Renovation';
        update ld;
          
       
        test.stopTest();
    }    
    
    public testMethod static void getdummytest1()
     {
         test.starttest();
         IronManLead_Assignment_Helper.dummyTestCover();
         test.stopTest();
     }
    public testMethod static void getdummytest2()
     {
         test.starttest();
         IronManInsideSalesLeadAssignment.dummyTestCover();
         test.stopTest();
     }
}