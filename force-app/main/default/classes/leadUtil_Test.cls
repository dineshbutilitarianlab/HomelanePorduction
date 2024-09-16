public class leadUtil_Test {
    
    public static lead insertLead(String email,String Phone){
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Bangalore';
        insert objRA;
        Lead leadRec=new lead(
            firstName='Vani',
            lastName='Sowmya',
            email=email,
            Phone=Phone,
            city='Bangalore',
            Area_Of_Residence__c = objRA.id,Floorplan_Received__c = 'No'
        );
        return leadRec;
    }
    
     public static User inserUser(String email,String aliasName,String AccountId,String profileId){
       if(AccountId != null && AccountId !=''){
            Contact con = new Contact(LastName =aliasName,AccountId = AccountId );
            insert con;          
            User user = new User(alias = aliasName, email=email,emailencodingkey='UTF-8', lastname=aliasName,languagelocalekey='en_US',localesidkey='en_US', profileid = profileId, country='United States',IsActive =true,ContactId = con.id,
                timezonesidkey='America/Los_Angeles', username=email);
                return user;
         }else{
           User user = new User(alias = aliasName, email=email,
                emailencodingkey='UTF-8', lastname=aliasName, languagelocalekey='en_US',localesidkey='en_US', profileid = profileId, country='United States',IsActive =true,timezonesidkey='America/Los_Angeles', username=email);
          return user;
         }
       
        
     } 
     
     public static void insertLeadData(String userEmail, String LeadEmail){
         Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        User wta_user=leadUtil_Test.inserUser('VMWta1'+userEmail,'VMWT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        User agent_user=leadUtil_Test.inserUser('VMSP1'+userEmail,'VMSSP1',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('VMP1'+userEmail,'VMSP1',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('TestDesighP'+userEmail,'Design Partner Test',ac.Id,profileData.get('Design Partner Profile'));
        dp_prof.alias = 'VMDP1';        
        insert dp_prof;
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Builder'];
        master__c master1=new master__c(Name='Gopalan Builders',RecordTypeId=recType.Id);
        insert master1;
        
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Mumbai';
        insert objRA;
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Property'];
        master__c master2=new master__c(Name='Gopalan Showroom',Property_City__c='Bangalore',Property_Landmark__c='Coffee Day',Property_Locality__c='Brigade Road',
            Property_Postal_Code__c=560032.0,Property_State__c='Karnataka',Property_Type__c='Midori',Street__c='JP Nagar 1st Cross',Type__c='Showroom',RecordTypeId=recType1.Id,
                           Builder_Name__c=master1.Id,SSM__c=managerUser.id);
        insert master2;
        lead leadRec1=leadUtil_Test.insertLead(LeadEmail,'7845111200');
        leadRec1.Lead_Assingment__c=false;
        leadRec1.Appointment_Venue_Square__c=master2.Id;
        leadRec1.Square_Showroom_Agent__c=agent_user.Id;
        leadRec1.Square_Showroom_Manager__c=managerUser.id;
        leadRec1.Appointment_Time__c=System.now();
        leadRec1.Appointment_Type__c='Site Visit';
        leadRec1.Status='Appointment Fixed';
        leadRec1.Entertainment_Unit__c='Yes';
        leadRec1.Kitchen__c='Yes';
        leadRec1.Pooja__c='Yes';
        leadRec1.Crockery_Unit__c='Yes';
        leadRec1.Foyer_Shoe_Rack__c='Yes';
        leadRec1.Area_Of_Residence__c = objRA.id;
        leadRec1.LeadSource='website';
        leadRec1.Floorplan_Received__c = 'No';
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
       leadRec1.Phone = '8978675678';
       leadRec1.Possession_Date__c = Date.valueOf('2018-12-06T00:00:00.000Z');
       leadRec1.OwnerId = agent_user.Id;
       leadRec1.Wt_Agent__c= agent_user.Id;
       Insert leadRec1;
     }
     
     public static void InsertUserData(String userEmail, String oppEmail){
          SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
       
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('PM Profile','SMM Profile','Square Sales Profile','Square Profile','Factory Coordinator Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        User pm_user=leadUtil_Test.inserUser('pmOu1'+userEmail,'PM1',ac.Id,profileData.get('PM Profile')); 
        insert pm_user;
        User smm_user=leadUtil_Test.inserUser('Smmou1'+userEmail,'SMM1',ac.Id,profileData.get('SMM Profile')); 
        insert smm_user;
        User fac_coordinator=leadUtil_Test.inserUser('FCou1'+userEmail,'SMM1',ac.Id,profileData.get('Factory Coordinator Profile')); 
        insert fac_coordinator;
        User agent_user=leadUtil_Test.inserUser('SSPou1'+userEmail,'eSSP1',ac.Id,profileData.get('Square Sales Profile')); 
        insert agent_user;
        User managerUser=leadUtil_Test.inserUser('SPou1'+userEmail,'USP1',ac.Id,profileData.get('Square Profile')); 
        insert managerUser;
        User dp_prof=leadUtil_Test.inserUser('UDou1'+userEmail,'UDP1',ac.Id,profileData.get('Design Partner Profile'));
        insert dp_prof;
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Test Opportunity',CloseDate  = System.Today(),Amount = 10000,stageName='D1 Initiated',NextStep = 'test step',AccountId = acc.Id);
        //Opportunity opp = SC_MI_TestHandler.insertOpportunity('Test Opportunity',System.Today(),'Initial Quote Sent',100,System.Today()+1); 
        opp.SMM__c=smm_user.id;
        opp.PM__c=pm_user.id;
        opp.Square_Showroom_Agent__c=agent_user.Id;
        opp.Square_Showroom_Manager__c=managerUser.Id;
        opp.Factory_Co_ordinator__c=fac_coordinator.id;
        opp.Customer_Email__c = oppEmail;
        opp.design_partner__c=dp_prof.id;
        insert opp;
        
        opp.sub_status__c='Site Measurement Meeting Confirmed';
        update opp;
        
        SC_Item__c itm = SC_MI_TestHandler.insertItem('Test Itm',TRUE,'Picklist','Record Type D1'); 
        insert itm;        
        SC_Section__c sec = SC_MI_TestHandler.insertSection('Test Sec','Design Presentation Completed',10,NULL);       
        insert sec;
        SC_Section__c subSec = SC_MI_TestHandler.insertSection('Test SubSec',NULL,10,sec.Id);       
        insert subSec;
        SC_Response__c res = SC_MI_TestHandler.insertResponse('Test Answer1',itm.Id,5,TRUE,TRUE);
        insert res;
        SC_Response__c res2 = SC_MI_TestHandler.insertResponse('Test Answer2',itm.Id,1,TRUE,FALSE);
        insert res2;
        list<SC_Section_Item__c> listSecItem=new list<SC_Section_Item__c>();
            SC_Section_Item__c secItm = SC_MI_TestHandler.insertSectionItem(itm.Id,sec.Id,10);
            listSecItem.add(secItm);
        if(!listSecItem.isEmpty())
            insert listSecItem;
        SC_User_Response__c usrRsp = SC_MI_TestHandler.insertUsrResponse(itm.Id,res2.Answer__c,'Design Presentation Completed',opp.Id,1);
        insert usrRsp; 
        
     } 
}