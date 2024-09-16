@isTest
public Class SC_NextStageValidation_Test{
 public static testMethod void SC_NextStageValidation(){
        
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
        
        SC_Section__c objSc = new SC_Section__c(Opportunity_Sub_Status__c='IQ Follow Up - Follow Up Later');
        insert objsc;
        SC_Section__c objSc1 = new SC_Section__c(Opportunity_Sub_Status__c='IQ Follow Up - Follow Up Later',Parent_Section__c=objsc.Id);
        insert objsc1;
        SC_Item__c objItem = new SC_Item__c(Is_Active__c=true,Item__c='Test');
        insert objItem;
        
        SC_Section__c objScc = new SC_Section__c();
        insert objscc;
        SC_Section__c objScc1 = new SC_Section__c(Opportunity_Sub_Status__c='IQ Follow Up - Follow Up Later',Parent_Section__c=objscc.Id);
        insert objscc1;
        
        SC_Item__c objsItem = new SC_Item__c(Is_Active__c=true,Item__c='Test');
        insert objsItem;
        SC_Section_Item__c objscItem1 = new SC_Section_Item__c(Section__c=objSc1.Id,Item__c=objItem.Id );
        insert objscItem1;
        SC_Section_Item__c objscItem2 = new SC_Section_Item__c(Section__c=objSc1.Id,Item__c=objItem.Id );
        insert objscItem2;
        SC_Section_Item__c objscItem3 = new SC_Section_Item__c(Section__c=objSc1.Id,Item__c=objItem.Id );
        insert objscItem3;
        SC_Section_Item__c objscItem4 = new SC_Section_Item__c(Section__c=objScc1.Id,Item__c=objsItem.Id );
        insert objscItem4;
        
        perOpp.Sub_Status__c='Site Measurement Meeting Confirmed';
        update perOpp;
        
        test.stopTest();
    }
}