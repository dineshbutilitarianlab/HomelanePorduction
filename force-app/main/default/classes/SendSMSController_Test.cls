@isTest
public class SendSMSController_Test {
        static testMethod void SendSMSControllerMethod1(){
             
         //Select a user with other than system administrator profile
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti6') ;
        insert ac; 
        Contact con = new Contact(LastName ='testCon6',AccountId = ac.Id);
        insert con;
        User wta_user=leadUtil_Test.inserUser('testWta6@gmail.com','TestWTA6','',profileData.get('WTA Profile')); 
        insert wta_user;
        //list<User> agent_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :agent_profile.Id and isActive = true];
       // list<User> agent_user=UsersUtil_Class.insertUser(agent_profile.ID);
       //User agent_user=leadUtil_Test.inserUser('testSSP6@gmail.com','TestSSP6',ac.Id,profileData.get('Square Sales Profile')); 
        //insert agent_user;
        
        //Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'Square Profile' LIMIT 1];
        //list<User> managerUser=[SELECT id,Name, Email  FROM User WHERE ProfileId =:squareMag_profile.id and isActive = true];
       // list<User> managerUser=UsersUtil_Class.insertUser(squareMag_profile.ID);
        //User managerUser=leadUtil_Test.inserUser('testSP6@gmail.com','TestSP6',ac.Id,profileData.get('Square Profile')); 
        //insert managerUser;
        //Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'Design Partner Profile' LIMIT 1];
        //list<User> dp_prof = [SELECT id,Name, Email  FROM User WHERE ProfileId = :dp_profile.Id and isActive = true ];
      //  list<User> dp_prof=UsersUtil_Class.insertUser(dp_profile.ID);
          //User dp_prof=leadUtil_Test.inserUser('testDP6@gmail.com','TestDP6',ac.Id,profileData.get('Design Partner Profile')); 
          //insert dp_prof;
          /*Interior_Designer__c objIDP = new Interior_Designer__c();
        objIDP.Name = 'testData';
        objIDP.Email__c = 'TestDesighP@hfltest.com';
        objIDP.User_Name__c = dp_prof.Id;
        insert objIDP; */
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
                           Builder_Name__c=master1.Id);
        insert master2;
                         
         lead leadRec1=leadUtil_Test.insertLead('parinithass@gmail.com','7895111200');
         leadRec1.PostalCode='561284';
         leadRec1.Appointment_Venue_Square__c=master2.Id;
         //leadRec1.Interior_Designer__c=objIDP.id;
        //leadRec1.Square_Showroom_Agent__c=agent_user.Id;
        //leadRec1.Square_Showroom_Manager__c=managerUser.id;
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
        leadRec1.Tiny_URL_Generate__c='tinyurl.com/ewfef';
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
       leadRec1.Phone = '8971675678';
       leadRec1.Possession_Date__c = Date.valueOf('2018-12-06T00:00:00.000Z');
        insert leadRec1;
        SMS_Template__c objSMS = new SMS_Template__c();
        objSMS.SMS_Content__c = 'Test SMS';
        objSMS.Name = 'Test Template';
        objSMS.Template_ID__c = 'someTemplateID123';
        insert objSMS;
        Integration_Setting__c intSetting = TestData_Factory.createIntegrationSetting('MSG91_API','http://api.msg91.com/api/v2/sendsms?dev_mode=1','u$r132fe08ce31d4b4f','application/json','KK1974dd56933b4c69602c063d589e19ab');
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        test.startTest();
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerate());
        SendSMSController.GetSMSTemplate(leadRec1.Id,'Test Template');
        SendSMSController.SendEmailToManager('errMsg');
        test.stopTest();
           
           
}




}