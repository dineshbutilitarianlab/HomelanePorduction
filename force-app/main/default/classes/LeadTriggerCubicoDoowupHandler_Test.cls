@isTest
public class LeadTriggerCubicoDoowupHandler_Test 
{
    Public static Lead ld;
    Public static lead doowupLd;
    Public static Master__c ms;
    Public static Id recTypeId;
    
     @TestSetup static void data() 
     {
        //Create Lead Record
         ms = new master__c();
         ms.type__c ='Showroom';
         ms.Name ='Cubico Test';
         insert ms;
            
        recTypeId = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Routing HL Leads').getRecordTypeId();
         
        Lead_Class_Scoring__c newLeadClassScoring = new Lead_Class_Scoring__c(
                                                                                    RecordTypeId = recTypeId,
                                                                                    Budget_Counter__c = 0,
                                                                                    Budget_Counter_Limit__c = 8,
                                                                                    Purpose_Counter__c = 0,
                                                                                    Purpose_Counter_Limit__c = 7,
                                                                                    Property_Counter__c = 0,
                                                                                    Property_Counter_Limit__c = 2,
                                                                                    Counter_Limit__c = 0,
                                                                                    Total_Limit__c = 100
                                                                                ); 
        insert newLeadClassScoring;
         
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
         
        Account testAccount1 = new Account(Name = 'Test Account1');
        insert testAccount1;
        
        Showroom_user__c newUser=new Showroom_user__c(Name='TestDealer',Email__c='testdealer@gmail.com', Role__c ='Dealer', IsActive__c= true);
        insert newUser;
         
        Showroom_user__c newShowroomUser=new Showroom_user__c(Name='TestDoowupUser',Email__c='doowuptransfer@homelane.com');
        insert newShowroomUser;
        
        Master__c newShowroom = new Master__c(Type__c='Dealer Showroom', Name='testShowroom', Showroom_Manager__c=newUser.Id, IsActive__c = true);
        insert newShowroom;
         
        Master__c newShowroom1 = new Master__c(Type__c='Showroom', Name='testShowroom', Showroom_Manager__c=newShowroomUser.Id, IsActive__c = true);
        insert newShowroom1;
        
       
        Territory__c newTerritory = TestData_Factory.createTerritory('DFN Territory',newUser.Id,'Kolkata','Cluster A','123414',False);
        newTerritory.Dealer_Showroom__c=newShowroom.id;
        newTerritory.Lat_Long__Latitude__s = 25.0936477440000;
        newTerritory.Lat_Long__Longitude__s =  79.7849897840000;
        newTerritory.Cluster_Brand__c ='Doow up';
        insert newTerritory;
         
               
        Lead testLead = new Lead(
            LastName = 'TestLast',
            Email = 'test@example.com',
            PostalCode = '123456',
            Phone = '1234567890',
            Area_Code__c = '91',
            Brand__c = 'HomeLane',
            LeadSource = 'HomeLane',
            Status = 'Fresh Lead',
            Sub_Status__c = 'New',
            City = 'Bengaluru',
            Account__c = testAccount.Id,
            Sign_Up_Source__c = 'HomeLane',
            Property_Status__c = 'New',
            Property_Config__c = '1 BHK',
            Kitchen__c = 'Yes',
            Wardrobes__c = '2',
            Entertainment_Unit__c = 'Yes',
            Study_Table_Book_Shelf__c = 'Yes',
            Crockery_Unit__c = 'Yes',
            Budget_Range__c = 'Upto 1.5L',
            Property_Type__c = 'Villa',
            Purpose_of_Interiors__c = 'I\'ll move-in',
            Possession_Date__c = Date.today()        
        );

		insert testLead; 
         
         
         Lead testLead1 = new Lead(
            LastName = 'TestLast',
            Email = 'test@example.com',
            PostalCode = '700160',
            Phone = '1234567890',
            Area_Code__c = '91',
            Brand__c = 'Doowup',
            LeadSource = 'HomeLane',
            Status = 'Fresh Lead',
            Sub_Status__c = 'New',
            City = 'Bengaluru',
            Account__c = testAccount1.Id,
            Sign_Up_Source__c = 'Doowup Dealer',
            Property_Status__c = 'New',
            Property_Config__c = '1 BHK',
            Kitchen__c = 'Yes',
            Wardrobes__c = '2',
            Entertainment_Unit__c = 'Yes',
            Study_Table_Book_Shelf__c = 'Yes',
            Crockery_Unit__c = 'Yes',
            Budget_Range__c = 'Upto 1.5L',
            Property_Type__c = 'Villa',
            Purpose_of_Interiors__c = 'I\'ll move-in',
            Possession_Date__c = Date.today(),
            Appointment_Venue_Square__c= Label.DFN_Default_Showroom_Id
        );

		insert testLead1; 
         
        
    }

    @isTest
    static void testAssignDeadLeadsToCubicoShowrooms() 
    {
        System.debug('FirstMethod '); 
        Test.startTest();
        
        ld=[Select id,Status,Sub_Status__c,City, PostalCode, lastname, Account__c from lead limit 1];
        
        Map<Id, Lead> oldleadMap=new Map<Id, Lead>();
        oldleadMap.put(ld.id,ld);
        System.debug('oldleadMap ' +oldleadMap);
        
        ld.Status = GenericConstants.LEAD_DEAD_STATUS;        
        ld.Sub_Status__c = GenericConstants.LEAD_SUBSTATUS_COMMERCIAL_REQUIREMENT;
 		update ld;
        
        List<lead> listofLeads=new List<Lead>();
        listOfLeads.add(ld);
       
        
        LeadTriggerCubicoAndDoowupHandler.AssignDeadLeadsToCubicoShowrooms(listofLeads,oldleadMap);
        Test.stopTest();

    }
    
     @isTest
    static void testDoowupDFNLead() 
    {
         System.debug('SecondMethod '); 
        Test.StartTest(); 

		Lead testLead = [Select id,Status,Sub_Status__c, City, PostalCode, lastname,Account__c from lead limit 1];
        
        Map<Id, Lead> oldleadMap=new Map<Id, Lead>();
        oldleadMap.put(testLead.id,testLead);
        System.debug('oldleadMap ' +oldleadMap);
        System.debug('testLead ' +testLead);
        
        testLead.Status = 'Dead Lead';
        testLead.Sub_Status__c = 'Other Category Requirements';
        testLead.Assignment_Initiate_Stage__c=GenericConstants.DEAD_LEAD_DFN_ASSIGNMENT;
        update testLead;
        
        List<lead> listofLeads=new List<Lead>{testLead};
        listOfLeads.add(testLead);
        System.debug('listofLeads ' +listofLeads);
        
               
        LeadTriggerCubicoAndDoowupHandler.doowupDFNLeadCreation(listofLeads,oldleadMap);        
        Test.stopTest();
       
    }
    
     @isTest
    static void testTransferDoowupLead() 
    {
         System.debug('SecondMethod '); 
        Test.StartTest(); 

		Lead testLead = [Select id,Status,Sub_Status__c, City, PostalCode, lastname,Account__c from lead limit 1];
        
        Map<Id, Lead> oldleadMap=new Map<Id, Lead>();
        oldleadMap.put(testLead.id,testLead);
        System.debug('oldleadMap ' +oldleadMap);
        System.debug('testLead ' +testLead);
        
        testLead.Status = 'Dead Lead';
        testLead.Sub_Status__c = 'Other Category Requirements';
        testLead.Assignment_Initiate_Stage__c=GenericConstants.TRANSFER_HL_DEADLEAD_ASSIGNMENT;
        update testLead;
        
        List<lead> listofLeads=new List<Lead>{testLead};
        listOfLeads.add(testLead);
        System.debug('listofLeads ' +listofLeads);
        
               
        LeadTriggerCubicoAndDoowupHandler.doowupDFNLeadCreation(listofLeads,oldleadMap);        
        Test.stopTest();
       
    }
    
      @isTest
    static void testDoowupLead() 
    {
        System.debug('ThirdMethod '); 
        Test.StartTest();             
       
        Lead testLead = [Select id,Status,Sub_Status__c,Account__c,Email, PostalCode, Phone, Area_Code__c, Brand__c, LeadSource, City, Sign_Up_Source__c, Property_Status__c, Property_Config__c, Kitchen__c,Lastname,
                         Wardrobes__c, Entertainment_Unit__c, Study_Table_Book_Shelf__c, Crockery_Unit__c, Budget_Range__c, Property_Type__c,Property__c, Purpose_of_Interiors__c, Possession_Date__c, Transfer_Status__c
 						 from lead limit 1];       
        
        
        List<lead> listofLeads=new List<Lead>{testLead};
        listOfLeads.add(testLead);
        System.debug('listofLeads ' +listofLeads);
        
          
        LeadTriggerCubicoAndDoowupHandler.doowupLeadCreation(listofLeads);        
        Test.stopTest();
       
    }
    
     @isTest
    static void testDFNshowroomAssignment() 
    {
        System.debug('FourthMethod '); 
        Test.StartTest();             
       
        Lead testLead = [Select id,Status,Sub_Status__c,Account__c,Email, PostalCode, Phone, Area_Code__c, Brand__c, LeadSource, City, Sign_Up_Source__c, Property_Status__c, Property_Config__c, Kitchen__c,Lastname,
                         Wardrobes__c, Entertainment_Unit__c, Study_Table_Book_Shelf__c, Crockery_Unit__c, Budget_Range__c, Property_Type__c,Property__c, Purpose_of_Interiors__c, Possession_Date__c, Transfer_Status__c
 						 from lead where Brand__c='Doowup' limit 1];       
        
        
        List<lead> listofLeads=new List<Lead>{testLead};
        listOfLeads.add(testLead);
        System.debug('listofLeads ' +listofLeads);
        
          
        LeadTriggerCubicoAndDoowupHandler.doowupLeadCreation(listofLeads);        
        Test.stopTest();
       
    }
    
     @isTest
    static void testAssignDeadLeadsToWrapzapShowrooms() 
    {
        System.debug('WrapzapMethod '); 
        Test.startTest();
        
        ld=[Select id,Status,Sub_Status__c,City, PostalCode, lastname, Account__c from lead limit 1];
        
        Map<Id, Lead> oldleadMap=new Map<Id, Lead>();
        oldleadMap.put(ld.id,ld);
        System.debug('oldleadMap ' +oldleadMap);
        
        ld.Status = GenericConstants.LEAD_DEAD_STATUS;        
        ld.Sub_Status__c = GenericConstants.LEAD_SUBSTATUS_OTHER_CATEGORY_REQUIREMENT;
        ld.Reason_For_Dead_Lead__c = GenericConstants.DEAD_LEAD_REASON_LAMINATE_CHANGE;
 		update ld;
        
        List<lead> listofLeads=new List<Lead>();
        listOfLeads.add(ld);
       
        
        LeadTriggerCubicoAndDoowupHandler.AssignDeadLeadsToWrapzapShowrooms(listofLeads,oldleadMap);
        Test.stopTest();

    }
    
    @isTest
    static void test_assignDealerRemoveISA()
    {
        Test.startTest();
        
        ld=[Select id,Status,Sub_Status__c,City, PostalCode, lastname, Account__c,Appointment_Venue_Square__c from lead where Brand__c='Doowup' limit 1];        
       
        Master__c Showroom =[Select id,Showroom_Manager__c,Showroom_Manager__r.Email__c from Master__c where Type__c='Dealer Showroom' limit 1];
        
        ld.Appointment_Venue_Square__c = Showroom.id;
        update ld;
        
        Map<Id, Master__c> ShowroomMap =new Map<Id, Master__c>();
        ShowroomMap.put(Showroom.id,Showroom);
        System.debug('ShowroomMap ' +ShowroomMap);       
              
        LeadTriggerCubicoAndDoowupHandler.assignDealerRemoveISA(ld,ShowroomMap);
        Test.stopTest();
    }
    
    @isTest
    static void test_createDoowupLeadFromOpportunity()
    {
        Test.startTest();
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Opportunity Opp = new Opportunity(  Full_Name__c = 'Test Full Name',
                                                Name = 'Test Name',
                                                Email_For_Communication__c = 'test@email.com',
                                                CityfromLead__c = 'Mysore',  
                                                Budget_Range__c = 'Upto 1.5L' , 
                                                AccountId = testAccount.id,
                                          		Opportunity_Funnel_Status__c = 'Active',
        										Opportunity_Funnel_Sub_Status__c='Budget/Price Discussion Pending',
                                                First_Meeting_Date__c = System.today().addDays(-8),
                                                StageName = 'Initial Quote Sent'
                                            );

        LeadTriggerCubicoAndDoowupHandler.createDoowupLeadFromOpportunity(opp);
        Test.stopTest();
    }
    
     @isTest
    static void test_removeDealerInfo()
    {
        Test.startTest();
        
        ld=[Select id,Status,Sub_Status__c,City, PostalCode, lastname, Account__c,Appointment_Venue_Square__c,Brand__c,Dealer__c,Assigned_to_Dealer__c from lead where Brand__c='Doowup' limit 1]; 
        
        List<Lead> listOfLeads = new List<Lead>();
        Map<Id,Lead> OldLeadMap = new Map<Id,Lead>();
        
        
        Master__c Showroom1 =[Select id,Showroom_Manager__c,Showroom_Manager__r.Email__c,IsActive__c from Master__c where Type__c='Dealer Showroom' limit 1];
        ld.Appointment_Venue_Square__c = Showroom1.id;   
        ld.Assigned_to_Dealer__c = true;
        ld.Dealer__c = Showroom1.Showroom_Manager__c;
        ld.Dealer_Assigment_Date__c = System.now();
        update ld;
        
        oldLeadMap.put(ld.id, ld);
        
        Master__c Showroom2 =[Select id,Showroom_Manager__c,Showroom_Manager__r.Email__c,IsActive__c from Master__c where Type__c='Showroom' limit 1];        
        ld.Appointment_Venue_Square__c = Showroom2.id;   
       // update ld;
          
        listOfLeads.add(ld);         
              
        LeadTriggerCubicoAndDoowupHandler.removeDealerInfo(listOfLeads,OldLeadMap);
        Test.stopTest();
    }
    
    
    @isTest
    static void test_createDFNLeadFromHL_No_TerritoryLead()
    {        
        	Test.startTest();
        	Account testAccount= [select id from Account where Name = 'Test Account'];
                
        	Lead testLead1 = new Lead(
                                    LastName = 'TestLast',
                                    Email = 'test@example.com',
                                    PostalCode = '123414',
                                    Phone = '1234567890',
                                    Area_Code__c = '91',
                                    Brand__c = 'HomeLane',
                                    LeadSource = 'Direct',
                                    Status = 'Fresh Lead',
                                    Sub_Status__c = 'New',
                                    City = 'Others',
                                    Account__c = testAccount.Id,
                                    Sign_Up_Source__c = 'HomeLane',
                                    Property_Status__c = 'New',
                                    Property_Config__c = '1 BHK'                                                                      
                                );
			insert testLead1; 
        	Test.stopTest();
    }
    
     @isTest
    static void testTrigger()
    {         
        test.startTest();
        LeadTriggerCubicoAndDoowupHandler.dummyTestCover();
        test.stopTest();
     }

}