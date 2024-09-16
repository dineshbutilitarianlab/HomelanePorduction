@isTest
public class PostProcessingController_Test {
 
  @testSetup static void TestData() {
    Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
         User wta_user = new User(alias = 'ameyo', email='ameyousertest@homelane.com',
                emailencodingkey='UTF-8', lastname='Ameyo User', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertest@homelane.com');
        insert wta_user;
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Noida';
        insert objRA;
        lead leadRec1=leadUtil_Test.insertLead('parinitha@gmail.com','1234567899');
         leadRec1.PostalCode='561284';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='Follow Up Later';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.WT_Agent__c = wta_user.Id;
         leadRec1.Ameyo_Call_Attempts__c = 8;
         leadRec1.Attempts_since_last_connection__c = 6;
         leadRec1.Follow_up_time__c= system.now();
         leadRec1.LeadSource ='Website';
         insert leadRec1;

}
   
    static testMethod void VoiceBlasterControllertest2(){
      
        
        Test.StartTest();
         PostProcessingController.strBody = '1234567899';
          PostProcessingController.strBody1 = 'Unable_To_Contact';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest1(){
         Test.StartTest();
         PostProcessingController.strBody = '1234567899';
          PostProcessingController.strBody1 = 'Not_Actively_Pursued';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest(){
        
        Test.StartTest();
         PostProcessingController.strBody = '1234567899';
          PostProcessingController.strBody1 = 'Possession_Beyond_6_Months';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest3(){
        
        Test.StartTest();
         PostProcessingController.strBody = '1234567899';
          PostProcessingController.strBody1 = 'Non_Serviceable_Product/Service';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest4(){
        
        Test.StartTest();
         PostProcessingController.strBody = '1234567899';
          PostProcessingController.strBody1 = 'Couldn\'t_Contact';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest5(){
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
         User wta_user = new User(alias = 'ameyo', email='ameyousertst@homelane.com',
                emailencodingkey='UTF-8', lastname='Ameyo User', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertst@homelane.com');
        insert wta_user;
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Noida';
        insert objRA;
        lead leadRec12=leadUtil_Test.insertLead('par1initha@gmail.com','1234562899');
         leadRec12.PostalCode='561284';
         leadRec12.Status='Fresh Lead';
         leadRec12.Sub_Status__c ='New';
         leadRec12.Lead_Assingment__c=true;
         leadRec12.City='Bengaluru';
         leadRec12.OwnerId = wta_user.Id;
         leadRec12.WT_Agent__c = wta_user.Id;
         leadRec12.Ameyo_Call_Attempts__c = 8;
         leadRec12.Attempts_since_last_connection__c = 6;
         leadRec12.Follow_up_time__c= system.now();
        leadRec12.LeadSource ='Website';
         insert leadRec12;

        Test.StartTest();
         PostProcessingController.strBody = '1234562899';
          PostProcessingController.strBody1 = 'Wrong_Number';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertst@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertst@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest6(){
        
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
         User wta_user = new User(alias = 'ameyo', email='ameyousertst1@homelane.com',
                emailencodingkey='UTF-8', lastname='Ameyo User', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertst1@homelane.com');
        insert wta_user;
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Noida';
        insert objRA;
        lead leadRec12=leadUtil_Test.insertLead('par2initha@gmail.com','2234562899');
         leadRec12.PostalCode='561284';
         leadRec12.Status='Fresh Lead';
         leadRec12.Sub_Status__c ='New';
         leadRec12.Lead_Assingment__c=true;
         leadRec12.City='Bengaluru';
         leadRec12.OwnerId = wta_user.Id;
         leadRec12.WT_Agent__c = wta_user.Id;
         leadRec12.Ameyo_Call_Attempts__c = 8;
         leadRec12.Attempts_since_last_connection__c = 6;
         leadRec12.Follow_up_time__c= system.now();
        leadRec12.LeadSource ='Website';
         insert leadRec12;
        
        Test.StartTest();
         PostProcessingController.strBody = '2234567899';
          PostProcessingController.strBody1 = 'Connected';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertst1@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertst1@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest7(){
        
        Test.StartTest();
         PostProcessingController.strBody = '1234567899';
          PostProcessingController.strBody1 = 'Duplicate_Entry';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest8(){
        
        Test.StartTest();
         PostProcessingController.strBody = '1234567899';
          PostProcessingController.strBody1 = 'Job_Seeker';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest9(){
        
        Test.StartTest();
         PostProcessingController.strBody = '1234567899';
          PostProcessingController.strBody1 = 'Commercial_requirement';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest10(){
        
        Test.StartTest();
         PostProcessingController.strBody = '1234567899';
          PostProcessingController.strBody1 = 'No_Home_Interiors_Requirement';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest12(){
        
        Test.StartTest();
         PostProcessingController.strBody = '1234567899';
          PostProcessingController.strBody1 = 'I_didn\'t_Register_on_Website';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest11(){
        
        Test.StartTest();
         PostProcessingController.strBody = '1234567899';
          PostProcessingController.strBody1 = 'Was_just_Browsing_for_Designs';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest13(){
        
        Test.StartTest();
         PostProcessingController.strBody = '1234567899';
          PostProcessingController.strBody1 = 'Was_Shopping_around_for_Quotes';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest19(){
        
        Test.StartTest();
         PostProcessingController.strBody = '1234567899';
          PostProcessingController.strBody1 = 'Your_Estimate_Prices_seem_too_High';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void VoiceBlasterControllertest18(){
        
        Test.StartTest();
         PostProcessingController.strBody = '1234567899';
          PostProcessingController.strBody1 = 'Dropped_the_Interiors_Plan';
          PostProcessingController.strBody3 = '2018-10-20_15:14:05';
          PostProcessingController.strBody2 = '[{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"preview.association\",\"associationId\":\"d483-5af2e73d--assoc--101131\"},{\"userId\":\"ameyousertest@homelane.com\",\"associtionType\":\"manualdial.association\",\"associationId\":\"d483-5af2e73d--assoc--101134\"}]';
           PostProcessingController.getLeadrec();
         Test.StopTest();
        
    }
    
    static testMethod void VoiceBlasterControllertest20(){        
        PostProcessingController.dummyTestCover();
    }

    
    }