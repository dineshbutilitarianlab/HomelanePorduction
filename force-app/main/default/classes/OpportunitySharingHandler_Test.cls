@isTest
public Class OpportunitySharingHandler_Test{
    //Public static User u;
    Public static Account acc;
    Public static Opportunity opp;
    @TestSetup static void data() { 
        
        //Create account record
        acc = TestData_Factory.createAccount(True);
        
        //Create Opportunity record
        opp = TestData_Factory.createOpportunity(acc.Id,True);
    }
    public static testMethod void testOppOne(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        list<User> pm_user= new list<User>();
            list<User> smm_user= new list<User>();
            list<User> agent_user= new list<User>();
            list<User> fac_coordinator= new list<User>();
            list<User> dp_prof= new list<User>();
            list<User> managerUser= new list<User>();
           Map<String,Id> profileData = new Map<String,Id>();
           for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','Square Sales Profile','Square Profile','Design Partner Profile','SMM Profile','Factory Coordinator Profile')]){
               profileData.put(obj.Name,obj.Id);
            }
            Double d = math.random();
            Integer th = d.intValue();
            
            User wta_user=leadUtil_Test.inserUser('t1etWta1'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('PM Profile'));
            pm_user.add(wta_user);          
            insert pm_user;
            
            User wta_user1=leadUtil_Test.inserUser('t1etWta2'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Sales Profile'));
            agent_user.add(wta_user1);          
            insert agent_user;
            User wta_user2=leadUtil_Test.inserUser('t1etWta6'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Profile'));
            managerUser.add(wta_user2);             
            insert managerUser;
            User wta_user3=leadUtil_Test.inserUser('t1etWta3'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Design Partner Profile'));
            dp_prof.add(wta_user3);             
            insert dp_prof;
            User wta_user4=leadUtil_Test.inserUser('t1etWta4'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('SMM Profile'));
             smm_user.add(wta_user4);           
            insert smm_user;
            User wta_user5=leadUtil_Test.inserUser('t1etWta5'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Factory Coordinator Profile'));
            fac_coordinator.add(wta_user5);             
            insert fac_coordinator;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='Quote Required',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id);
        insert perOpp;
        Opportunity perOpp1=new Opportunity(Name='John Arjun1',AccountId=personAcc.Id,stageName='Quote Required',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Opportunity_Stage__c ='Appointment Successful');
        insert perOpp1;
        
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id);
        insert master1;
        
        RecordType recType2=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Builders Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
            Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Showroom',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType2.Id,
                           Builder_Name__c=master1.Id);
        insert master2;
        
        system.debug('perOpp*********'+perOpp);
        system.debug('RecursiveTriggerHandlerOpp.isFirstTime'+RecursiveTriggerHandlerOpp.isFirstTime);
        
        perOpp.stageName='Initial quote Approved';
        perOpp.Amount=100;
        perOpp.SME1__c=con.id;
        perOpp.Appointment_Venue_Square__c=master2.id;
        perOpp.Appointment_Venue_Site_Resi_State__c='Karnataka';
        perOpp.Appointment_Venue_Site_Residence_City__c='Bangalore';
        perOpp.Appointment_Venue_Site_Resi_Landmark__c='old airport road';
        perOpp.Appointment_Venue_Site_Resi_Locality__c='marathahalli';
        perOpp.Parent_Opportunity__c = perOpp1.Customer_ID__c;
        update perOpp;
        
        test.stopTest();
    }
     public static testMethod void testOppParentone(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
         
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        list<User> pm_user= new list<User>();
            list<User> smm_user= new list<User>();
            list<User> agent_user= new list<User>();
            list<User> fac_coordinator= new list<User>();
            list<User> dp_prof= new list<User>();
            list<User> managerUser= new list<User>();
           Map<String,Id> profileData = new Map<String,Id>();
           for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','Square Sales Profile','Square Profile','Design Partner Profile','SMM Profile','Factory Coordinator Profile')]){
               profileData.put(obj.Name,obj.Id);
            }
            Double d = math.random();
            Integer th = d.intValue();
            User wta_user=leadUtil_Test.inserUser('t1etWta1'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('PM Profile'));
            pm_user.add(wta_user);          
            insert pm_user;
            User wta_user1=leadUtil_Test.inserUser('t1etWta6'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Sales Profile'));
            agent_user.add(wta_user1);          
            insert agent_user;
            User wta_user2=leadUtil_Test.inserUser('t1etWta2'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Profile'));
            managerUser.add(wta_user2);             
            insert managerUser;
            User wta_user3=leadUtil_Test.inserUser('t1etWta3'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Design Partner Profile'));
            dp_prof.add(wta_user3);             
            insert dp_prof;
            User wta_user4=leadUtil_Test.inserUser('t1etWta4'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('SMM Profile'));
             smm_user.add(wta_user4);           
            insert smm_user;
            User wta_user5=leadUtil_Test.inserUser('t1etWta5'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Factory Coordinator Profile'));
            fac_coordinator.add(wta_user5);             
            insert fac_coordinator;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,amount=200,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Opportunity_Stage__c ='Appointment Successful');
        insert perOpp;
        try{      
           perOpp.Parent_Opportunity__c = perOpp.Customer_ID__c;
           update perOpp;
           }catch(Exception exp){}
        
        test.stopTest();
    }
     public static testMethod void testOppParentTwo(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
         
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        list<User> pm_user= new list<User>();
            list<User> smm_user= new list<User>();
            list<User> agent_user= new list<User>();
            list<User> fac_coordinator= new list<User>();
            list<User> dp_prof= new list<User>();
            list<User> managerUser= new list<User>();
           Map<String,Id> profileData = new Map<String,Id>();
           for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','Square Sales Profile','Square Profile','Design Partner Profile','SMM Profile','Factory Coordinator Profile')]){
               profileData.put(obj.Name,obj.Id);
            }
            Double d = math.random();
            Integer th = d.intValue();
            User wta_user=leadUtil_Test.inserUser('t1etWta1'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('PM Profile'));
            pm_user.add(wta_user);          
            insert pm_user;
            User wta_user1=leadUtil_Test.inserUser('t1etWta6'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Sales Profile'));
            agent_user.add(wta_user1);          
            insert agent_user;
            User wta_user2=leadUtil_Test.inserUser('t1etWta2'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Profile'));
            managerUser.add(wta_user2);             
            insert managerUser;
            User wta_user3=leadUtil_Test.inserUser('t1etWta3'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Design Partner Profile'));
            dp_prof.add(wta_user3);             
            insert dp_prof;
            User wta_user4=leadUtil_Test.inserUser('t1etWta4'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('SMM Profile'));
             smm_user.add(wta_user4);           
            insert smm_user;
            User wta_user5=leadUtil_Test.inserUser('t1etWta5'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Factory Coordinator Profile'));
            fac_coordinator.add(wta_user5);             
            insert fac_coordinator;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,amount=200,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Opportunity_Stage__c ='Appointment Successful');
        insert perOpp;
        try{      
           perOpp.Parent_Opportunity__c = 'test';
           update perOpp;
           }catch(Exception exp){}
        
        test.stopTest();
    }
    public static testMethod void testOppTwo(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
         
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        list<User> pm_user= new list<User>();
            list<User> smm_user= new list<User>();
            list<User> agent_user= new list<User>();
            list<User> fac_coordinator= new list<User>();
            list<User> dp_prof= new list<User>();
            list<User> managerUser= new list<User>();
           Map<String,Id> profileData = new Map<String,Id>();
           for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','Square Sales Profile','Square Profile','Design Partner Profile','SMM Profile','Factory Coordinator Profile')]){
               profileData.put(obj.Name,obj.Id);
            }
            Double d = math.random();
            Integer th = d.intValue();
            User wta_user=leadUtil_Test.inserUser('t1etWta1'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('PM Profile'));
            pm_user.add(wta_user);          
            insert pm_user;
            User wta_user1=leadUtil_Test.inserUser('t1etWta6'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Sales Profile'));
            agent_user.add(wta_user1);          
            insert agent_user;
            User wta_user2=leadUtil_Test.inserUser('t1etWta2'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Profile'));
            managerUser.add(wta_user2);             
            insert managerUser;
            User wta_user3=leadUtil_Test.inserUser('t1etWta3'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Design Partner Profile'));
            dp_prof.add(wta_user3);             
            insert dp_prof;
            User wta_user4=leadUtil_Test.inserUser('t1etWta4'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('SMM Profile'));
             smm_user.add(wta_user4);           
            insert smm_user;
            User wta_user5=leadUtil_Test.inserUser('t1etWta5'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Factory Coordinator Profile'));
            fac_coordinator.add(wta_user5);             
            insert fac_coordinator;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,amount=200,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Opportunity_Stage__c ='Appointment Successful');
        insert perOpp;
        
        Event evnt1=new Event();
        evnt1.Subject='Email';
        evnt1.WhatId=perOpp.Id;
        evnt1.DurationInMinutes=15;
        evnt1.ActivityDateTime=system.today();
        evnt1.EventType__c='D1: Site Measurement Proposed';
        evnt1.Event_Location__c='site visit';
        insert evnt1;
        
        perOpp.Sub_Status__c='Site Measurement Meeting Confirmed';
       // perOpp.Parent_Opportunity__c = 'test';
        update perOpp;
        
        test.stopTest();
    }
    public static testMethod void testOpportunityTwo(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
           
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        Double d = math.random();
            Integer th = d.intValue();
        list<User> pm_user= new list<User>();
            list<User> smm_user= new list<User>();
            list<User> agent_user= new list<User>();
            list<User> fac_coordinator= new list<User>();
            list<User> dp_prof= new list<User>();
            list<User> managerUser= new list<User>();
           Map<String,Id> profileData = new Map<String,Id>();
           for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','Square Sales Profile','Square Profile','Design Partner Profile','SMM Profile','Factory Coordinator Profile')]){
               profileData.put(obj.Name,obj.Id);
            }
            User wta_user=leadUtil_Test.inserUser('t1etWta1'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('PM Profile'));
            pm_user.add(wta_user);          
            insert pm_user;
            User wta_user1=leadUtil_Test.inserUser('t1etWta6'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Sales Profile'));
            agent_user.add(wta_user1);          
            insert agent_user;
            User wta_user2=leadUtil_Test.inserUser('t1etWta2'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Profile'));
            managerUser.add(wta_user2);             
            insert managerUser;
            User wta_user3=leadUtil_Test.inserUser('t1etWta3'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Design Partner Profile'));
            dp_prof.add(wta_user3);             
            insert dp_prof;
            User wta_user4=leadUtil_Test.inserUser('t1etWta4'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('SMM Profile'));
             smm_user.add(wta_user4);           
            insert smm_user;
            User wta_user5=leadUtil_Test.inserUser('t1etWta5'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Factory Coordinator Profile'));
            fac_coordinator.add(wta_user5);             
            insert fac_coordinator;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,amount=200,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Opportunity_Stage__c ='Appointment Successful');
        insert perOpp;
        
        Event evnt1=new Event();
        evnt1.Subject='Email';
        evnt1.WhatId=perOpp.Id;
        evnt1.DurationInMinutes=15;
        evnt1.ActivityDateTime=system.today();
        evnt1.EventType__c='D1: Site Measurement Proposed';
        evnt1.Event_Location__c='Remote visit';
        evnt1.If_Remote_Visit_Specify_Addres__c='Bangalore';
        insert evnt1;
        
        perOpp.Sub_Status__c='Site Measurement Meeting Confirmed';
        update perOpp;
        
        test.stopTest();
    }
    public static testMethod void testOpportunityTwo1(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        Double d = math.random();
            Integer th = d.intValue();
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        list<User> pm_user= new list<User>();
            list<User> smm_user= new list<User>();
            list<User> agent_user= new list<User>();
            list<User> fac_coordinator= new list<User>();
            list<User> dp_prof= new list<User>();
            list<User> managerUser= new list<User>();
           Map<String,Id> profileData = new Map<String,Id>();
           for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','Square Sales Profile','Square Profile','Design Partner Profile','SMM Profile','Factory Coordinator Profile')]){
               profileData.put(obj.Name,obj.Id);
            }
            User wta_user=leadUtil_Test.inserUser('t1etWta1'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('PM Profile'));
            pm_user.add(wta_user);          
            insert pm_user;
            User wta_user1=leadUtil_Test.inserUser('t1etWta6'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Sales Profile'));
            agent_user.add(wta_user1);          
            insert agent_user;
            User wta_user2=leadUtil_Test.inserUser('t1etWta2'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Profile'));
            managerUser.add(wta_user2);             
            insert managerUser;
            User wta_user3=leadUtil_Test.inserUser('t1etWta3'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Design Partner Profile'));
            dp_prof.add(wta_user3);             
            insert dp_prof;
            User wta_user4=leadUtil_Test.inserUser('t1etWta4'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('SMM Profile'));
             smm_user.add(wta_user4);           
            insert smm_user;
            User wta_user5=leadUtil_Test.inserUser('t1etWta5'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Factory Coordinator Profile'));
            fac_coordinator.add(wta_user5);             
            insert fac_coordinator;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,amount=200,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Opportunity_Stage__c ='Appointment Successful');
        insert perOpp;
        
        Event evnt1=new Event();
        evnt1.Subject='Email';
        evnt1.WhatId=perOpp.Id;
        evnt1.DurationInMinutes=15;
        evnt1.ActivityDateTime=system.today();
        evnt1.EventType__c='D1: Site Measurement Proposed';
        evnt1.Event_Location__c='Residence Visit';
        evnt1.If_Remote_Visit_Specify_Addres__c='Bangalore';
        insert evnt1;
        
        perOpp.Sub_Status__c='Site Measurement Meeting Confirmed';
        update perOpp;
        
        test.stopTest();
    }
    public static testMethod void testOpportunityTwo2(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        
        list<User> pm_user= new list<User>();
            list<User> smm_user= new list<User>();
            list<User> agent_user= new list<User>();
            list<User> fac_coordinator= new list<User>();
            list<User> dp_prof= new list<User>();
            list<User> managerUser= new list<User>();
           Map<String,Id> profileData = new Map<String,Id>();
           for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','Square Sales Profile','Square Profile','Design Partner Profile','SMM Profile','Factory Coordinator Profile')]){
               profileData.put(obj.Name,obj.Id);
            }
            Double d = math.random();
            Integer th = d.intValue();
            User wta_user=leadUtil_Test.inserUser('t1etWta1'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('PM Profile'));
            pm_user.add(wta_user);          
            insert pm_user;
            User wta_user1=leadUtil_Test.inserUser('t1etWta6'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Sales Profile'));
            agent_user.add(wta_user1);          
            insert agent_user;
            User wta_user2=leadUtil_Test.inserUser('t1etWta2'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Profile'));
            managerUser.add(wta_user2);             
            insert managerUser;
            User wta_user3=leadUtil_Test.inserUser('t1etWta3'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Design Partner Profile'));
            dp_prof.add(wta_user3);             
            insert dp_prof;
            User wta_user4=leadUtil_Test.inserUser('t1etWta4'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('SMM Profile'));
             smm_user.add(wta_user4);           
            insert smm_user;
            User wta_user5=leadUtil_Test.inserUser('t1etWta5'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Factory Coordinator Profile'));
            fac_coordinator.add(wta_user5);             
            insert fac_coordinator;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,amount=200,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Opportunity_Stage__c ='Appointment Successful');
        insert perOpp;
        
        Event evnt1=new Event();
        evnt1.Subject='Email';
        evnt1.WhatId=perOpp.Id;
        evnt1.DurationInMinutes=15;
        evnt1.ActivityDateTime=system.today();
        evnt1.EventType__c='D1: Site Measurement Proposed';
        evnt1.Event_Location__c='Square Showroom Visit';
        evnt1.If_Remote_Visit_Specify_Addres__c='Bangalore';
        insert evnt1;
        
        perOpp.Sub_Status__c='Site Measurement Meeting Confirmed';
        update perOpp;
        
        test.stopTest();
    }
     public static testMethod void testOppThree(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        
        list<User> pm_user= new list<User>();
            list<User> smm_user= new list<User>();
            list<User> agent_user= new list<User>();
            list<User> fac_coordinator= new list<User>();
            list<User> dp_prof= new list<User>();
            list<User> managerUser= new list<User>();
           Map<String,Id> profileData = new Map<String,Id>();
           for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','Square Sales Profile','Square Profile','Design Partner Profile','SMM Profile','Factory Coordinator Profile')]){
               profileData.put(obj.Name,obj.Id);
            }
            Double d = math.random();
            Integer th = d.intValue();
            User wta_user=leadUtil_Test.inserUser('t1etWta1'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('PM Profile'));
            pm_user.add(wta_user);          
            insert pm_user;
            User wta_user1=leadUtil_Test.inserUser('t1etWta6'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Sales Profile'));
            agent_user.add(wta_user1);          
            insert agent_user;
            User wta_user2=leadUtil_Test.inserUser('t1etWta2'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Profile'));
            managerUser.add(wta_user2);             
            insert managerUser;
            User wta_user3=leadUtil_Test.inserUser('t1etWta3'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Design Partner Profile'));
            dp_prof.add(wta_user3);             
            insert dp_prof;
            User wta_user4=leadUtil_Test.inserUser('t1etWta4'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('SMM Profile'));
             smm_user.add(wta_user4);           
            insert smm_user;
            User wta_user5=leadUtil_Test.inserUser('t1etWta5'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Factory Coordinator Profile'));
            fac_coordinator.add(wta_user5);             
            insert fac_coordinator;
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Opportunity_Stage__c ='Appointment Successful');
        insert perOpp;
               
        Event evnt1=new Event();
        evnt1.Subject='Email';
        evnt1.WhatId=perOpp.Id;
        evnt1.DurationInMinutes=15;
        evnt1.ActivityDateTime=system.today();
        evnt1.EventType__c='D2: Design Presentation Proposed';
        evnt1.Event_Location__c='Site Visit';
        evnt1.If_Remote_Visit_Specify_Addres__c='Bengaluru';
        insert evnt1;
        
        perOpp.StageName='D2 initiated';
        //Commented By Bharatesh Shetty
        //perOpp.Sub_Status__c='3D Design & Quote Approved';
        perOpp.Sub_Status__c='Production Drawings Uploaded';
        update perOpp;
        
         //Bharatesh Shetty Changes
        perOpp.StageName = 'D4 Initiated';
        perOpp.sub_status__c = 'Installation Meeting Confirmed';
        update perOpp;
        
      //  perOpp.Sub_Status__c='Design Presentation Confirmed';
      //  update perOpp;
        
        test.stopTest();
    }
    public static testMethod void testOppThree1(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
        
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        list<User> pm_user= new list<User>();
            list<User> smm_user= new list<User>();
            list<User> agent_user= new list<User>();
            list<User> fac_coordinator= new list<User>();
            list<User> dp_prof= new list<User>();
            list<User> managerUser= new list<User>();
           Map<String,Id> profileData = new Map<String,Id>();
           for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','Square Sales Profile','Square Profile','Design Partner Profile','SMM Profile','Factory Coordinator Profile')]){
               profileData.put(obj.Name,obj.Id);
            }
            Double d = math.random();
            Integer th = d.intValue();
            User wta_user=leadUtil_Test.inserUser('t1etWta1'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('PM Profile'));
            pm_user.add(wta_user);          
            insert pm_user;
            User wta_user1=leadUtil_Test.inserUser('t1etWta6'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Sales Profile'));
            agent_user.add(wta_user1);          
            insert agent_user;
            User wta_user2=leadUtil_Test.inserUser('t1etWta2'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Profile'));
            managerUser.add(wta_user2);             
            insert managerUser;
            User wta_user3=leadUtil_Test.inserUser('t1etWta3'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Design Partner Profile'));
            dp_prof.add(wta_user3);             
            insert dp_prof;
            User wta_user4=leadUtil_Test.inserUser('t1etWta4'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('SMM Profile'));
             smm_user.add(wta_user4);           
            insert smm_user;
            User wta_user5=leadUtil_Test.inserUser('t1etWta5'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Factory Coordinator Profile'));
            fac_coordinator.add(wta_user5);             
            insert fac_coordinator;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Opportunity_Stage__c ='Appointment Successful');
        insert perOpp;
        
        Event evnt1=new Event();
        evnt1.Subject='Email';
        evnt1.WhatId=perOpp.Id;
        evnt1.DurationInMinutes=15;
        evnt1.ActivityDateTime=system.today();
        evnt1.EventType__c='D2: Design Presentation Proposed';
        evnt1.Event_Location__c='Square Showroom Visit';
        evnt1.If_Remote_Visit_Specify_Addres__c='Bengaluru';
        insert evnt1;
        
        perOpp.StageName='D2 initiated';
        perOpp.Sub_Status__c='3D Design & Quote Approved';
        update perOpp;
        
    //    perOpp.Sub_Status__c='Design Presentation Confirmed';
    //    update perOpp;
        
        test.stopTest();
    }
    public static testMethod void testOppThree2(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
                
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        list<User> pm_user= new list<User>();
            list<User> smm_user= new list<User>();
            list<User> agent_user= new list<User>();
            list<User> fac_coordinator= new list<User>();
            list<User> dp_prof= new list<User>();
            list<User> managerUser= new list<User>();
           Map<String,Id> profileData = new Map<String,Id>();
           for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','Square Sales Profile','Square Profile','Design Partner Profile','SMM Profile','Factory Coordinator Profile')]){
               profileData.put(obj.Name,obj.Id);
            }
            Double d = math.random();
            Integer th = d.intValue();
            User wta_user=leadUtil_Test.inserUser('t1etWta1'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('PM Profile'));
            pm_user.add(wta_user);          
            insert pm_user;
            User wta_user1=leadUtil_Test.inserUser('t1etWta6'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Sales Profile'));
            agent_user.add(wta_user1);          
            insert agent_user;
            User wta_user2=leadUtil_Test.inserUser('t1etWta2'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Profile'));
            managerUser.add(wta_user2);             
            insert managerUser;
            User wta_user3=leadUtil_Test.inserUser('t1etWta3'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Design Partner Profile'));
            dp_prof.add(wta_user3);             
            insert dp_prof;
            User wta_user4=leadUtil_Test.inserUser('t1etWta4'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('SMM Profile'));
             smm_user.add(wta_user4);           
            insert smm_user;
            User wta_user5=leadUtil_Test.inserUser('t1etWta5'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Factory Coordinator Profile'));
            fac_coordinator.add(wta_user5);             
            insert fac_coordinator;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='Quote Required',
                                                closeDate=system.today(),
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Opportunity_Stage__c ='Appointment Successful');
        insert perOpp;
        
        Event evnt1=new Event();
        evnt1.Subject='Email';
        evnt1.WhatId=perOpp.Id;
        evnt1.DurationInMinutes=15;
        evnt1.ActivityDateTime=system.today();
        evnt1.EventType__c='D2: Design Presentation Proposed';
        evnt1.Event_Location__c='Remote Visit';
        evnt1.If_Remote_Visit_Specify_Addres__c='Bengaluru';
        insert evnt1;
         perOpp.StageName='D1 initiated';
        perOpp.Event_Created_D1__c = true;
       // perOpp.Sub_Status__c='Design Presentation Proposed';
        update perOpp;
        
        perOpp.StageName='D2 initiated';
       // perOpp.Event_Created_D1__c = true;
        perOpp.Sub_Status__c='3D Design & Quote Approved';
        update perOpp;
        
     //   perOpp.Sub_Status__c='Design Presentation Confirmed';
     //   update perOpp;
        
        test.stopTest();
    }
    public static testMethod void testOppThree3(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
                
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        list<User> pm_user= new list<User>();
            list<User> smm_user= new list<User>();
            list<User> agent_user= new list<User>();
            list<User> fac_coordinator= new list<User>();
            list<User> dp_prof= new list<User>();
            list<User> managerUser= new list<User>();
           Map<String,Id> profileData = new Map<String,Id>();
           for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','Square Sales Profile','Square Profile','Design Partner Profile','SMM Profile','Factory Coordinator Profile')]){
               profileData.put(obj.Name,obj.Id);
            }
            Double d = math.random();
            Integer th = d.intValue();
            User wta_user=leadUtil_Test.inserUser('t1etWta1'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('PM Profile'));
            pm_user.add(wta_user);          
            insert pm_user;
            User wta_user1=leadUtil_Test.inserUser('t1etWta6'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Sales Profile'));
            agent_user.add(wta_user1);          
            insert agent_user;
            User wta_user2=leadUtil_Test.inserUser('t1etWta2'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Profile'));
            managerUser.add(wta_user2);             
            insert managerUser;
            User wta_user3=leadUtil_Test.inserUser('t1etWta3'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Design Partner Profile'));
            dp_prof.add(wta_user3);             
            insert dp_prof;
            User wta_user4=leadUtil_Test.inserUser('t1etWta4'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('SMM Profile'));
             smm_user.add(wta_user4);           
            insert smm_user;
            User wta_user5=leadUtil_Test.inserUser('t1etWta5'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Factory Coordinator Profile'));
            fac_coordinator.add(wta_user5);             
            insert fac_coordinator;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Opportunity_Stage__c ='Appointment Successful');
        insert perOpp;
        
        Event evnt1=new Event();
        evnt1.Subject='Email';
        evnt1.WhatId=perOpp.Id;
        evnt1.DurationInMinutes=15;
        evnt1.ActivityDateTime=system.today();
        evnt1.EventType__c='D2: Design Presentation Proposed';
        evnt1.Event_Location__c='Residence Visit';
        evnt1.If_Remote_Visit_Specify_Addres__c='Bengaluru';
        insert evnt1;
        
        perOpp.StageName='D2 initiated';
        perOpp.Sub_Status__c='3D Design & Quote Approved';
        update perOpp;
        
    //    perOpp.Sub_Status__c='Design Presentation Confirmed';
    //    update perOpp;
        
        test.stopTest();
    }
  /*  public static testMethod void testOppFour(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
        
          Map<String,Id> profileData = new Map<String,Id>();for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){profileData.put(obj.Name,obj.Id);}
      list<User> pm_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :pm_profile.Id and isActive=true ];
        //  list<User> pm_user=leadUtil_Test.insertUser(pm_profile.ID); 
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'SMM Profile' LIMIT 1];
       list<User> smm_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :smm_profile.Id and isActive=true ];
      //   list<User> smm_user=leadUtil_Test.insertUser(smm_profile.ID); 
        
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'Square Sales Profile' LIMIT 1];
      list<User> agent_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :agent_profile.Id and isActive=true ];
       //   list<User> agent_user=leadUtil_Test.insertUser(agent_profile.ID);
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'Factory Coordinator Profile' LIMIT 1];
       list<User> fac_coordinator = [SELECT id,Name, Email  FROM User WHERE ProfileId = :fac_profile.Id and isActive=true ];
       //   list<User> fac_coordinator=leadUtil_Test.insertUser(fac_profile.ID);
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'Design Partner Profile' LIMIT 1];
       list<User> dp_prof = [SELECT id,Name, Email  FROM User WHERE ProfileId = :dp_profile.Id and isActive=true ];
      //   list<User> dp_prof=leadUtil_Test.insertUser(dp_profile.ID);
        
        Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'Square Profile' LIMIT 1];
       list<User> managerUser=[SELECT id,Name, Email  FROM User WHERE ProfileId =:squareMag_profile.id and isActive=true ];
      //    list<User> managerUser=leadUtil_Test.insertUser(squareMag_profile.ID);
       
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,customer_email__c='test'+th+'@gmail.com');
        insert perOpp;
        
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id);
        insert master1;
        
        RecordType recType2=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Builders Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
            Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Showroom',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType2.Id,
                           Builder_Name__c=master1.Id);
        insert master2;
        
        perOpp.StageName='D2 initiated';
        update perOpp;
        
        perOpp.StageName='D3 initiated';
        perOpp.Amount=100;
        perOpp.customer_email__c='test'+th+'@gmail.com';
        perOpp.Sub_Status__c='Project kick-off Proposed';
        perOpp.Appointment_Venue_Square__c=master2.id;
        perOpp.Appointment_Venue_Site_Resi_State__c='Karnataka';
        perOpp.Appointment_Venue_Site_Residence_City__c='Bangalore';
        perOpp.Appointment_Venue_Site_Resi_Landmark__c='old airport road';
        perOpp.Appointment_Venue_Site_Resi_Locality__c='marathahalli';
        update perOpp;
        
        Event evnt3=new Event();
        evnt3.Subject='Email';
        evnt3.WhatId=perOpp.Id;
        evnt3.DurationInMinutes=15;
        evnt3.ActivityDateTime=system.today();
        evnt3.EventType__c='D3: Project Kick-off Proposed';
        evnt3.Event_Location__c='Remote Visit';
        evnt3.If_Remote_Visit_Specify_Addres__c='Bangalore';
        insert evnt3;
        
        perOpp.Sub_Status__c='Project kick-off Meeting Confirmed';
        update perOpp;
        
        perOpp.Sub_Status__c='Final Drawings, Quote & Works Contract Approved';
        update perOpp;
        
        test.stopTest();
    }
    public static testMethod void testOppFour1(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
          Map<String,Id> profileData = new Map<String,Id>();for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){profileData.put(obj.Name,obj.Id);}
       list<User> pm_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :pm_profile.Id and isActive=true];
        //  list<User> pm_user=leadUtil_Test.insertUser(pm_profile.ID); 
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'SMM Profile' LIMIT 1];
       list<User> smm_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :smm_profile.Id and isActive=true ];
     //    list<User> smm_user=leadUtil_Test.insertUser(smm_profile.ID); 
        
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'Square Sales Profile' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :agent_profile.Id and isActive=true ];
      //   list<User> agent_user=leadUtil_Test.insertUser(agent_profile.ID);
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'Factory Coordinator Profile' LIMIT 1];
       list<User> fac_coordinator = [SELECT id,Name, Email  FROM User WHERE ProfileId = :fac_profile.Id and isActive=true ];
      //   list<User> fac_coordinator=leadUtil_Test.insertUser(fac_profile.ID);
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'Design Partner Profile' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email  FROM User WHERE ProfileId = :dp_profile.Id and isActive=true ];
     //   list<User> dp_prof=leadUtil_Test.insertUser(dp_profile.ID);
        
        Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'Square Profile' LIMIT 1];
        list<User> managerUser=[SELECT id,Name, Email  FROM User WHERE ProfileId =:squareMag_profile.id and isActive=true ];
     //    list<User> managerUser=leadUtil_Test.insertUser(squareMag_profile.ID);
       
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,customer_email__c='test'+th+'@gmail.com');
        insert perOpp;
        
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id);
        insert master1;
        
        RecordType recType2=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Builders Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
            Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Showroom',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType2.Id,
                           Builder_Name__c=master1.Id);
        insert master2;
        
        perOpp.StageName='D3 initiated';
        perOpp.Amount=100;
        perOpp.customer_email__c='test'+th+'@gmail.com';
        perOpp.Sub_Status__c='Project kick-off Proposed';
        perOpp.Appointment_Venue_Square__c=master2.id;
        perOpp.Appointment_Venue_Site_Resi_State__c='Karnataka';
        perOpp.Appointment_Venue_Site_Residence_City__c='Bangalore';
        perOpp.Appointment_Venue_Site_Resi_Landmark__c='old airport road';
        perOpp.Appointment_Venue_Site_Resi_Locality__c='marathahalli';
        update perOpp;
        
        Event evnt3=new Event();
        evnt3.Subject='Email';
        evnt3.WhatId=perOpp.Id;
        evnt3.DurationInMinutes=15;
        evnt3.ActivityDateTime=system.today();
        evnt3.EventType__c='D3: Project Kick-off Proposed';
        evnt3.Event_Location__c='Site Visit';
        evnt3.If_Remote_Visit_Specify_Addres__c='Bangalore';
        insert evnt3;
        
        perOpp.Sub_Status__c='Project kick-off Meeting Confirmed';
        update perOpp;
        
        perOpp.Sub_Status__c='Final Drawings, Quote & Works Contract Approved';
        update perOpp;
        
        test.stopTest();
    }
    public static testMethod void testOppFour2(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
           Map<String,Id> profileData = new Map<String,Id>();for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){profileData.put(obj.Name,obj.Id);}
       list<User> pm_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :pm_profile.Id and isActive=true ];
      //   list<User> pm_user=leadUtil_Test.insertUser(pm_profile.ID); 
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'SMM Profile' LIMIT 1];
       list<User> smm_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :smm_profile.Id and isActive=true ];
      //  list<User> smm_user=leadUtil_Test.insertUser(smm_profile.ID); 
        
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'Square Sales Profile' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :agent_profile.Id and isActive=true ];
       //  list<User> agent_user=leadUtil_Test.insertUser(agent_profile.ID);
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'Factory Coordinator Profile' LIMIT 1];
        list<User> fac_coordinator = [SELECT id,Name, Email  FROM User WHERE ProfileId = :fac_profile.Id and isActive=true ];
      //   list<User> fac_coordinator=leadUtil_Test.insertUser(fac_profile.ID);
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'Design Partner Profile' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email  FROM User WHERE ProfileId = :dp_profile.Id and isActive=true ];
      //  list<User> dp_prof=leadUtil_Test.insertUser(dp_profile.ID);
        
        Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'Square Profile' LIMIT 1];
       list<User> managerUser=[SELECT id,Name, Email  FROM User WHERE ProfileId =:squareMag_profile.id and isActive=true ];
       //  list<User> managerUser=leadUtil_Test.insertUser(squareMag_profile.ID);
       
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,customer_email__c='test'+th+'@gmail.com');
        insert perOpp;
        
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id);
        insert master1;
        
        RecordType recType2=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Builders Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
            Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Showroom',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType2.Id,
                           Builder_Name__c=master1.Id);
        insert master2;
        
        perOpp.StageName='D3 initiated';
        perOpp.Amount=100;
        perOpp.customer_email__c='test'+th+'@gmail.com';
        perOpp.Sub_Status__c='Project kick-off Proposed';
        perOpp.Appointment_Venue_Square__c=master2.id;
        perOpp.Appointment_Venue_Site_Resi_State__c='Karnataka';
        perOpp.Appointment_Venue_Site_Residence_City__c='Bangalore';
        perOpp.Appointment_Venue_Site_Resi_Landmark__c='old airport road';
        perOpp.Appointment_Venue_Site_Resi_Locality__c='marathahalli';
        update perOpp;
        
        Event evnt3=new Event();
        evnt3.Subject='Email';
        evnt3.WhatId=perOpp.Id;
        evnt3.DurationInMinutes=15;
        evnt3.ActivityDateTime=system.today();
        evnt3.EventType__c='D3: Project Kick-off Proposed';
        evnt3.Event_Location__c='Residence Visit';
        evnt3.If_Remote_Visit_Specify_Addres__c='Bangalore';
        insert evnt3;
        
        perOpp.Sub_Status__c='Project kick-off Meeting Confirmed';
        update perOpp;
        
        perOpp.Sub_Status__c='Final Drawings, Quote & Works Contract Approved';
        update perOpp;
        
        test.stopTest();
    }
    public static testMethod void testOppFour4(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
           Map<String,Id> profileData = new Map<String,Id>();for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){profileData.put(obj.Name,obj.Id);}
        list<User> pm_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :pm_profile.Id and isActive=true ];
       //  list<User> pm_user=leadUtil_Test.insertUser(pm_profile.ID); 
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'SMM Profile' LIMIT 1];
       list<User> smm_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :smm_profile.Id and isActive=true ];
      //  list<User> smm_user=leadUtil_Test.insertUser(smm_profile.ID); 
        
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'Square Sales Profile' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :agent_profile.Id and isActive=true ];
       //  list<User> agent_user=leadUtil_Test.insertUser(agent_profile.ID);
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'Factory Coordinator Profile' LIMIT 1];
       list<User> fac_coordinator = [SELECT id,Name, Email  FROM User WHERE ProfileId = :fac_profile.Id and isActive=true ];
      //   list<User> fac_coordinator=leadUtil_Test.insertUser(fac_profile.ID);
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'Design Partner Profile' LIMIT 1];
       list<User> dp_prof = [SELECT id,Name, Email  FROM User WHERE ProfileId = :dp_profile.Id and isActive=true ];
      //  list<User> dp_prof=leadUtil_Test.insertUser(dp_profile.ID);
        
        Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'Square Profile' LIMIT 1];
        list<User> managerUser=[SELECT id,Name, Email  FROM User WHERE ProfileId =:squareMag_profile.id and isActive=true ];
       //  list<User> managerUser=leadUtil_Test.insertUser(squareMag_profile.ID);
         
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='D1 initiated',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Customer_Email__c='test'+th+'@gmail.com');
        insert perOpp;
        
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id);
        insert master1;
        
        RecordType recType2=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Builders Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
            Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Showroom',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType2.Id,
                           Builder_Name__c=master1.Id);
        insert master2;
        
        perOpp.StageName='D3 initiated';
        perOpp.Amount=100;
        perOpp.customer_email__c='test'+th+'@gmail.com';
        perOpp.Sub_Status__c='Project kick-off Proposed';
        perOpp.Appointment_Venue_Square__c=master2.id;
        perOpp.Appointment_Venue_Site_Resi_State__c='Karnataka';
        perOpp.Appointment_Venue_Site_Residence_City__c='Bangalore';
        perOpp.Appointment_Venue_Site_Resi_Landmark__c='old airport road';
        perOpp.Appointment_Venue_Site_Resi_Locality__c='marathahalli';
        update perOpp;
        
        Event evnt3=new Event();
        evnt3.Subject='Email';
        evnt3.WhatId=perOpp.Id;
        evnt3.DurationInMinutes=15;
        evnt3.ActivityDateTime=system.today();
        evnt3.EventType__c='D3: Project Kick-off Proposed';
        evnt3.Event_Location__c='Square Showroom Visit';
        evnt3.If_Remote_Visit_Specify_Addres__c='Bangalore';
        insert evnt3;
        
        perOpp.Sub_Status__c='Project kick-off Meeting Confirmed';
        update perOpp;
        
        perOpp.Sub_Status__c='Final Drawings, Quote & Works Contract Approved';
        update perOpp;
        
        test.stopTest();
    }*/
   /*  public static testMethod void testOpp3(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
         
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        list<User> pm_user= new list<User>();
            list<User> smm_user= new list<User>();
            list<User> agent_user= new list<User>();
            list<User> fac_coordinator= new list<User>();
            list<User> dp_prof= new list<User>();
            list<User> managerUser= new list<User>();
           Map<String,Id> profileData = new Map<String,Id>();
           for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','Square Sales Profile','Square Profile','Design Partner Profile','SMM Profile','Factory Coordinator Profile')]){
               profileData.put(obj.Name,obj.Id);
            }
            Double d = math.random();
            Integer th = d.intValue();
            User wta_user=leadUtil_Test.inserUser('t1etWta1'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('PM Profile'));
            pm_user.add(wta_user);          
            insert pm_user;
            User wta_user1=leadUtil_Test.inserUser('t1etWta6'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Sales Profile'));
            agent_user.add(wta_user1);          
            insert agent_user;
            User wta_user2=leadUtil_Test.inserUser('t1etWta2'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Profile'));
            managerUser.add(wta_user2);             
            insert managerUser;
            User wta_user3=leadUtil_Test.inserUser('t1etWta3'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Design Partner Profile'));
            dp_prof.add(wta_user3);             
            insert dp_prof;
            User wta_user4=leadUtil_Test.inserUser('t1etWta4'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('SMM Profile'));
             smm_user.add(wta_user4);           
            insert smm_user;
            User wta_user5=leadUtil_Test.inserUser('t1etWta5'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Factory Coordinator Profile'));
            fac_coordinator.add(wta_user5);             
            insert fac_coordinator;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='Quote Required',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Opportunity_Stage__c ='Appointment Successful');
        insert perOpp;
        
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id);
        insert master1;
        
        RecordType recType2=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Builders Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
            Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Showroom',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType2.Id,
                           Builder_Name__c=master1.Id);
        insert master2;
        
        system.debug('perOpp*********'+perOpp);
        system.debug('RecursiveTriggerHandlerOpp.isFirstTime'+RecursiveTriggerHandlerOpp.isFirstTime);
        
        perOpp.stageName='Production & Procurement Complete';
        perOpp.Amount=100;
        perOpp.SME1__c=con.id;
        perOpp.customer_email__c='test'+th+'@gmail.com';
        perOpp.Appointment_Venue_Square__c=master2.id;
        perOpp.Appointment_Venue_Site_Resi_State__c='Karnataka';
        perOpp.Appointment_Venue_Site_Residence_City__c='Bangalore';
        perOpp.Appointment_Venue_Site_Resi_Landmark__c='old airport road';
        perOpp.Appointment_Venue_Site_Resi_Locality__c='marathahalli';
        update perOpp;
        
        Project_Name__c projName=new Project_Name__c(Name='Test Project',Opportunity_Project__c=perOpp.Id,Start_Date__c=system.today());
        insert projName;
        
        system.debug('********projName************'+projName);
        Milestone__c mile = new Milestone__c();
        mile.Title__c= 'Production & Procurement Complete';
        mile.Expected_Start_Date__c = system.Today();
        mile.Expected_End_Date__c = system.Today()+2;
        mile.Lead_Time__c = 1;
        mile.Number_Of_Sub_MileStone_Records__c = 0;
        mile.Project__c=projName.id;
        mile.OpportunityStatus__c='Production & Procurement Complete';
        mile.status__c='Not Completed';
        insert mile;
        
        Milestone__c subMile = new Milestone__c();
        subMile.Title__c= 'Production & Procurement Complete';
        subMile.Milestone__c=mile.id;
        subMile.Expected_Start_Date__c = system.Today();
        subMile.Expected_End_Date__c = system.Today()+2;
        subMile.Lead_Time__c = 1;
        subMile.Number_Of_Sub_MileStone_Records__c = 0;
        subMile.Project__c=projName.id;
        subMile.OpportunityStatus__c='Production & Procurement Complete';
        subMile.status__c='Not Completed';
        insert subMile;
        
        Task__c tsk= new Task__c();
        tsk.Milestone__c=subMile.id;
        tsk.Title__c= 'Production';
        tsk.Expected_Start_Date__c = system.Today();
        tsk.Expected_End_Date__c = system.Today()+2;
        tsk.Lead_Time__c = 1;
        tsk.Project__c=projName.id;
        insert tsk;
        
        test.stopTest();
    }*/
    public static testMethod void testOpp4(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
         
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        Double d = math.random();
            Integer th = d.intValue();
        list<User> pm_user= new list<User>();
            list<User> smm_user= new list<User>();
            list<User> agent_user= new list<User>();
            list<User> fac_coordinator= new list<User>();
            list<User> dp_prof= new list<User>();
            list<User> managerUser= new list<User>();
           Map<String,Id> profileData = new Map<String,Id>();
           for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','Square Sales Profile','Square Profile','Design Partner Profile','SMM Profile','Factory Coordinator Profile')]){
               profileData.put(obj.Name,obj.Id);
            }
            User wta_user=leadUtil_Test.inserUser('t1etWta1'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('PM Profile'));
            pm_user.add(wta_user);          
            insert pm_user;
            User wta_user1=leadUtil_Test.inserUser('t1etWta6'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Sales Profile'));
            agent_user.add(wta_user1);          
            insert agent_user;
            User wta_user2=leadUtil_Test.inserUser('t1etWta2'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Profile'));
            managerUser.add(wta_user2);             
            insert managerUser;
            User wta_user3=leadUtil_Test.inserUser('t1etWta3'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Design Partner Profile'));
            dp_prof.add(wta_user3);             
            insert dp_prof;
            User wta_user4=leadUtil_Test.inserUser('t1etWta4'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('SMM Profile'));
             smm_user.add(wta_user4);           
            insert smm_user;
            User wta_user5=leadUtil_Test.inserUser('t1etWta5'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Factory Coordinator Profile'));
            fac_coordinator.add(wta_user5);             
            insert fac_coordinator;
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='Quote Required',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Opportunity_Stage__c ='Appointment Successful');
        insert perOpp;
        
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id);
        insert master1;
        
        RecordType recType2=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Builders Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
            Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Showroom',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType2.Id,
                           Builder_Name__c=master1.Id);
        insert master2;
        
        system.debug('perOpp*********'+perOpp);
        system.debug('RecursiveTriggerHandlerOpp.isFirstTime'+RecursiveTriggerHandlerOpp.isFirstTime);
        
        perOpp.stageName='Snaglist Rectification Completed';
        perOpp.Customer_Email__c = 'duplicate101_John'+th+'@gmail.com';
        perOpp.Update_Email_Communication__c = true;
        perOpp.Amount=100;
        perOpp.SME1__c=con.id;
        perOpp.Appointment_Venue_Square__c=master2.id;
        perOpp.Appointment_Venue_Site_Resi_State__c='Karnataka';
        perOpp.Appointment_Venue_Site_Residence_City__c='Bangalore';
        perOpp.Appointment_Venue_Site_Resi_Landmark__c='old airport road';
        perOpp.Appointment_Venue_Site_Resi_Locality__c='marathahalli';
        perOpp.Address_Of_Instalation__c  = 'test';
        perOpp.Date_Of_Completion__c = system.Today();
        perOpp.Warranty_Document_Comments__c = 'test';
        perOpp.Scope_Of_Work__c = 'test';
        update perOpp;
        
        test.stopTest();
    }
    
    public static testMethod void testOpp5(){
        
        test.startTest();
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
               
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        
        list<User> pm_user= new list<User>();
            list<User> smm_user= new list<User>();
            list<User> agent_user= new list<User>();
            list<User> fac_coordinator= new list<User>();
            list<User> dp_prof= new list<User>();
            list<User> managerUser= new list<User>();
           Map<String,Id> profileData = new Map<String,Id>();
           for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','Square Sales Profile','Square Profile','Design Partner Profile','SMM Profile','Factory Coordinator Profile')]){
               profileData.put(obj.Name,obj.Id);
            }
            Double d = math.random();
            Integer th = d.intValue();
            User wta_user=leadUtil_Test.inserUser('t1etWta1'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('PM Profile'));
            pm_user.add(wta_user);          
            insert pm_user;
            User wta_user1=leadUtil_Test.inserUser('t1etWta6'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Sales Profile'));
            agent_user.add(wta_user1);          
            insert agent_user;
            User wta_user2=leadUtil_Test.inserUser('t1etWta2'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Square Profile'));
            managerUser.add(wta_user2);             
            insert managerUser;
            User wta_user3=leadUtil_Test.inserUser('t1etWta3'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Design Partner Profile'));
            dp_prof.add(wta_user3);             
            insert dp_prof;
            User wta_user4=leadUtil_Test.inserUser('t1etWta4'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('SMM Profile'));
             smm_user.add(wta_user4);           
            insert smm_user;
            User wta_user5=leadUtil_Test.inserUser('t1etWta5'+th+'@gmail.com','TesWT1',businessAcc.Id,profileData.get('Factory Coordinator Profile'));
            fac_coordinator.add(wta_user5);             
            insert fac_coordinator;
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya'+th+'@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner'+th+'@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John'+th+'@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='Quote Required',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id,Opportunity_Stage__c ='Appointment Successful');
        insert perOpp;
        
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id);
        insert master1;
        
        RecordType recType2=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Builders Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
            Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Showroom',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType2.Id,
                           Builder_Name__c=master1.Id);
        insert master2;
        
        system.debug('perOpp*********'+perOpp);
        system.debug('RecursiveTriggerHandlerOpp.isFirstTime'+RecursiveTriggerHandlerOpp.isFirstTime);
        
        perOpp.stageName='D4 Initiated';
        perOpp.Amount=100;
        perOpp.sub_status__c='Installation Meeting Proposed';
        perOpp.Appointment_Venue_Square__c=master2.id;
        perOpp.Appointment_Venue_Site_Resi_State__c='Karnataka';
        perOpp.Appointment_Venue_Site_Residence_City__c='Bangalore';
        perOpp.Appointment_Venue_Site_Resi_Landmark__c='old airport road';
        perOpp.Appointment_Venue_Site_Resi_Locality__c='marathahalli';
        update perOpp;
        
        Event evnt4=new Event();
        evnt4.Subject='Email';
        evnt4.WhatId=perOpp.Id;
        evnt4.DurationInMinutes=15;
        evnt4.ActivityDateTime=system.today();
        evnt4.EventType__c='D4: Installation Meeting Proposed';
        evnt4.Event_Location__c='Site Visit';
        evnt4.If_Remote_Visit_Specify_Addres__c='Bangalore';
        insert evnt4;
        
        perOpp.stageName='D4 Initiated';
        perOpp.sub_status__c='Installation Meeting Confirmed';
        update perOpp;
        
         
        Project_Name__c projName=new Project_Name__c(Name='Test Project',Opportunity_Project__c=perOpp.Id,Start_Date__c=system.today());
        //insert projName;
        
        system.debug('********projName************'+projName);
        Milestone__c mile = new Milestone__c();
        mile.Title__c= 'Production';
        mile.Expected_Start_Date__c = system.Today();
        mile.Expected_End_Date__c = system.Today()+2;
        mile.Lead_Time__c = 1;
        mile.Number_Of_Sub_MileStone_Records__c = 0;
        mile.Project__c=projName.id;
        mile.status__c='Installation Meeting Confirmed';
       // insert mile;
        
        Task__c tsk= new Task__c();
        tsk.Title__c= 'Production';
        tsk.Expected_Start_Date__c = system.Today();
        tsk.Expected_End_Date__c = system.Today()+2;
        tsk.Lead_Time__c = 1;
        tsk.Project__c=projName.id;
       // insert tsk;
        
        Opportunity opLeadSqTest = new Opportunity();
        opLeadSqTest = [Select id from Opportunity limit 1];
        opLeadSqTest.Lead_Square_Modified_date__c = null;
        update opLeadSqTest;
        
        opLeadSqTest.Check_In_Time__c = System.now();
        opLeadSqTest.Amount = 10000;
        update opLeadSqTest;
        
        test.stopTest();
    }

}