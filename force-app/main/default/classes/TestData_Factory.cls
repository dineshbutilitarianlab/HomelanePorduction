@isTest
public class TestData_Factory{
    
    public Static Lead CreateFreshLead(Boolean bInsert){
        Lead l = new Lead();
        l.FirstName = 'Balaji';
        l.LastName = 'S';
        l.Email = 'Bala@asdaf.com';
        l.Phone = '9000000000';
        l.City = 'Bengaluru';
        l.LeadSource = 'Google Ad';
        l.Status = 'Fresh Lead';
        l.Sub_Status__c = 'New';
        if(bInsert){
            insert l;
            return l;
        }
        return l;
    }
    
    
     public Static Lead CreateFreshDoowupLead(Boolean bInsert){
        Lead l = new Lead();
        l.FirstName = 'Balaji';
        l.LastName = 'S';
        l.Email = 'Bala@asdaf11.com';
        l.Phone = '9000000011';
        l.City = 'Bengaluru';
        l.LeadSource = 'Google Ad';
        l.Status = 'Fresh Lead';
        l.Sub_Status__c = 'New';
        if(bInsert){
            insert l;
            return l;
        }
        return l;
    }
    
    public Static Lead MarkAsAppointmentFixed(Lead ObjectLead){
        
        if(ObjectLead != NULL){
            ObjectLead.Status = 'Appointment Fixed';
            ObjectLead.Sub_Status__c = 'Appointment Fixed';
            ObjectLead.Appointment_Time__c= Datetime.now()+2;
            ObjectLead.Appointment_Type__c = 'Virtual Meeting';
            ObjectLead.Kitchen__c= 'Yes';
            ObjectLead.Crockery_Unit__c= 'No';
            ObjectLead.Wardrobes__c= '0';
            ObjectLead.Entertainment_Unit__c= 'No';
            ObjectLead.Pooja__c= 'No';
            ObjectLead.Study_Table_Book_Shelf__c= 'No';
            ObjectLead.Foyer_Shoe_Rack__c= 'No';
            ObjectLead.Interior_Start_Date__c = date.today()+14;
            ObjectLead.Possession_Date__c = date.today()+24;
            ObjectLead.Property_Status__c = 'New';
            ObjectLead.Property_Config__c = '1 BHK';
            ObjectLead.Property_Type__c = 'Apartment';
            return ObjectLead;
        }
        return NULL;
    }
    
    Public Static Master__C CreateShowRoom(Boolean bInsert){
        
        Master__c m = new Master__c();
        m.isActive__c = true;
        m.Type__c = 'ShowRoom';
        m.Name = 'Test ShowRoom';
        if(bInsert){
            insert m;
            return m;
        }
        return m;
    }
    
    public static User inserWTAUser(String email,String aliasName,Boolean bInsert){
        Profile P =  [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile')];
        User user = new User(alias = aliasName, email=email,
                             emailencodingkey='UTF-8', lastname=aliasName, languagelocalekey='en_US',localesidkey='en_US', 
                             profileid = P.id, country='United States',Cloud_Agent_Campaign_Name__c = 'Test_AutoLead',
                             IsActive =true,timezonesidkey='America/Los_Angeles', username=email);
        if(bInsert){
            
            Insert  user;
            return user;
        }
        return user;
    }
    public static WTA_Assignment__c inserWTAAssignment(User u,String groupName,Boolean bInsert){
        WTA_Assignment__c WTAAssignment = new WTA_Assignment__c();
        WTAAssignment.User__c = u.id;
        WTAAssignment.Daily_Assignment__c = 0;
        WTAAssignment.Weekly_Assignment__c = 0;
        WTAAssignment.Monthly_Assignments__c = 0;
        WTAAssignment.Daily_Limit__c = 15;
        WTAAssignment.Weekly_Limit__c = 50;
        WTAAssignment.Monthly_Limit__c = 100;
        WTAAssignment.IsActive__c = true;
        WTAAssignment.Group__c = groupName;
        WTAAssignment.City__c = 'Bengaluru';
        if(bInsert){
            insert WTAAssignment;
        }
        return WTAAssignment ;
    }
    
    Public static Lead_Round_Robin_Assignment__c createIronMan(User u,Boolean bInsert){
        
        Lead_Round_Robin_Assignment__c objIronMan = new Lead_Round_Robin_Assignment__c();
        objIronMan.Assignment_Days__c = 'Monday;Tuesday;Wednesday;Thursday;Friday;Saturday;Sunday';
        objIronMan.Daily_Assignment__c = 0;
        objIronMan.Daily_Limit__c = 15;
        objIronMan.Distance_from_ShowRoom__c = 20;
        objIronMan.Monthly_Assignments__c = 0;
        objIronMan.Monthly_Limit__c = 105;
        objIronMan.Showroom_Name__c = 'HSR';
        objIronMan.User__c =  u.id;
        
        if(bInsert){
            insert objIronMan;
            return objIronMan;
        }
        return objIronMan;
        
    }
    
    public static Showroom_User__c createShowroomUser(Boolean bInsert){
        
        Showroom_User__c objShowroom = new Showroom_User__c();
        objShowroom.Name = 'TestSHowRoomUSer';
        objShowroom.Email__c = 'TestSHowRoomUSer@test.com';
        if(bInsert){
            insert objShowroom;
            return objShowroom;
        }
        return objShowroom;
        
    }
    public static Opportunity createOpportunity(Id AccId,Boolean bInsert){
        
        Opportunity testOpp = new Opportunity();
        testOpp.AccountId = AccId;
        testOpp.Name = 'Test Opportunity';
        testOpp.CloseDate = System.today().addDays(30);
        testOpp.StageName = 'Quote Required';
        //testOpp.Lead_square_modified_date__c = System.now();
        if(bInsert){
            insert testOpp;   
        }
        return testOpp; 
    }
    public static Account createAccount(Boolean bInsert){
        
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        if(bInsert){
            insert testAccount;   
        }
        return testAccount; 
    }
    public static Integration_Setting__c createIntegrationSetting(String name,String endPoint,String authorization,String contentType,String secretKey){
        Integration_Setting__c intSetting = new Integration_Setting__c();
        intSetting.Name = name;
        intSetting.End_Point__c = endPoint;
        intSetting.Authorization__c = authorization;
        intSetting.ContentType__c = contentType;
        intSetting.Secret_Key__c = secretKey;
        insert intSetting;
        return intSetting;
    }
    public static Lead_Square_Mapping__c createLeadSquareMapping(Boolean isDate,String leadSquareField,String name, String sfLeadField,String sfOppField){
        Lead_Square_Mapping__c leadSquareMap = new Lead_Square_Mapping__c();
        leadSquareMap.IsDateField__c = isDate;
        leadSquareMap.Lead_Square_Field__c = leadSquareField;
        leadSquareMap.SF_Lead_Field__c = sfLeadField;
        leadSquareMap.SF_Opportunity_Field__c = name;
        leadSquareMap.Name = sfOppField;
        insert leadSquareMap;
        return leadSquareMap;
    }
    
    Public static Round_Robin__c createRoundRobin(String sQueueName, Boolean bInsert){
        Round_Robin__c RoundRobin = new Round_Robin__c();
        RoundRobin.Queue_Name__c = sQueueName;
        RoundRobin.IsActive__c = true;
        
        if(bInsert){
            insert RoundRobin ;
            return RoundRobin ;
        }
        return RoundRobin ;
        
    }
    Public static Lead_Assignment__c createLeadAssignment(String name, Id roundRobinId,Id userId, Boolean bInsert){
        Lead_Assignment__c leadAssign = new Lead_Assignment__c();
        leadAssign.Name = name;
        leadAssign.Round_Robin__c = roundRobinId;
        leadAssign.Assign_Percent__c = 100;
        leadAssign.Number_of_Leads__c = 0;
        leadAssign.User__c = userId;
        if(bInsert){
            insert leadAssign ;
        }
        return leadAssign;
    }
    public static Account createPersonAccount(Boolean bInsert){
        
        Account testAccount = new Account();
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        testAccount.RecordTypeid=RecTypeId;
        testAccount.LastName='Test';
        if(bInsert){
            insert testAccount;   
        }
        return testAccount; 
    }
    
    public static Interior_Designer__c createInteriorDesigner(Boolean bInsert){
        
        Interior_Designer__c dummyDp = new Interior_Designer__c();
        dummyDp.Name ='Test DP';
        dummyDp.Email__c = 'TestDp@test.com';
        if(bInsert){
            insert dummyDp;   
        }
        return dummyDp; 
    }
        
    public static WebEngage_Task__c createWebEngageEventTask(Id leadId,Id opportunityId,String eventName,String EventType,Boolean isInsert){
        WebEngage_Task__c webEngageTask = new WebEngage_Task__c();
        webEngageTask.Type__c = EventType;
        webEngageTask.Name = eventName;
        if(leadId !=null && (EventType =='Change Event' || EventType =='User Event')){
            webEngageTask.Lead__c = leadId;
        }
        else if(EventType =='Change' && opportunityId !=null){
            webEngageTask.Lead__c = opportunityId;
        }
        if(isInsert){
            insert webEngageTask;
        }
        return webEngageTask;
    }
    Public static Channel_Partner__c createChannelPartner(String name, String phoneNumber, String Type, Boolean isInsert){
        Channel_Partner__c cp = new Channel_Partner__c();
        Id recordTypeId = Schema.SObjectType.Channel_Partner__c.getRecordTypeInfosByName().get(Type).getRecordTypeId();
        cp.name = name;
        cp.Phone__c = phoneNumber;
        cp.RecordTypeId = recordTypeId;
        if(isInsert){
            insert cp;
        }
        return cp;
    }
    Public static Territory__c createTerritory(String Name,String IronManReference, String City, String Cluster,String Pincode, Boolean isInsert){
        Territory__c objTerritory = new Territory__c ();
       
        objTerritory.name = name;
        objTerritory.Ironman__c = IronManReference;
        objTerritory.City__c = City;
        objTerritory.Cluster__c = Cluster;
        objTerritory.Pincode__c= Pincode;
        if(isInsert){
            insert objTerritory;
        }
        return objTerritory;
    }  
    Public static Bulk_Offline_Lead_Creation_Fields__c createBulkOfflineLeadCreationFileds(String Name,String Field_API_Name, String Field_Data_Type, String Field_Label_Name,Boolean In_Use, Boolean OverRide_InCase_Of_Duplication, Boolean isInsert,boolean UseInAccount){ 
        Bulk_Offline_Lead_Creation_Fields__c returnValue = new Bulk_Offline_Lead_Creation_Fields__c();
        returnValue.Name = Name;
        returnValue.Field_API_Name__c = Field_API_Name;
        returnValue.Field_Data_Type__c = Field_Data_Type;
        returnValue.Field_Label_Name__c = Field_Label_Name;
        returnValue.In_Use__c = In_Use;
        returnValue.OverRide_InCase_Of_Duplication__c = OverRide_InCase_Of_Duplication;
        returnValue.UseInAccount__c = UseInAccount;
        if(isInsert){
            insert returnValue;
        }
        return returnValue;
    } 
    public Static Lead MarkAsPreAppointment(Lead ObjectLead, Boolean isUpdate){
        ObjectLead.Status = 'Pre-Appointment';
        ObjectLead.Sub_Status__c = 'Pre-Appointment';
        //ObjectLead.Appointment_Time__c= Datetime.now()+2;
        //ObjectLead.Appointment_Type__c = 'Virtual Meeting';
        ObjectLead.Kitchen__c= 'Yes';
        ObjectLead.Crockery_Unit__c= 'No';
        ObjectLead.Wardrobes__c= '0';
        ObjectLead.Entertainment_Unit__c= 'No';
        ObjectLead.Pooja__c= 'No';
        ObjectLead.Study_Table_Book_Shelf__c= 'No';
        ObjectLead.Foyer_Shoe_Rack__c= 'No';
        ObjectLead.Interior_Start_Date__c = date.today()+14;
        ObjectLead.Possession_Date__c = date.today()+24;
        ObjectLead.Property_Status__c = 'New';
        ObjectLead.Property_Config__c = '1 BHK';
        ObjectLead.Property_Type__c = 'Apartment';
        ObjectLead.Residence_Visit_Offered__c = 'Yes';
        ObjectLead.Res_Visit_Acceptance__c = 'Accepted for a weekday visit';
        if(isUpdate){
            update ObjectLead;
        }
        return ObjectLead;
    }
}