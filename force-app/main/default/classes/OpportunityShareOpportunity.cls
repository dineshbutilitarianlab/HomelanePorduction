@isTest(seeAllData = True)
public Class OpportunityShareOpportunity{
   /* public static testMethod void testShareOpportunity(){
        
     //    SC_MI_TestHandler.insertIsTriggerExecute();
     //   SC_MI_TestHandler.insertCustomDate();
        
        dummy1 test = new dummy1();
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent1';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
         Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'Project Manager Profile' LIMIT 1];
        list<User> pm_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :pm_profile.Id and isActive=true];
       //  list<User> pm_user=UsersUtil_Class.insertUser(pm_profile.ID); 
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'SMM Profile' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :smm_profile.Id and isActive=true];
      //  list<User> smm_user=UsersUtil_Class.insertUser(smm_profile.ID); 
        
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'Square Sales Profile' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :agent_profile.Id and isActive=true];
      //   list<User> agent_user=UsersUtil_Class.insertUser(agent_profile.ID);
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'Factory Coordinator Profile' LIMIT 1];
        list<User> fac_coordinator = [SELECT id,Name, Email  FROM User WHERE ProfileId = :fac_profile.Id and isActive=true];
      //   list<User> fac_coordinator=UsersUtil_Class.insertUser(fac_profile.ID);
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'Design Partner Profile' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email  FROM User WHERE ProfileId = :dp_profile.Id];
     //   list<User> dp_prof=UsersUtil_Class.insertUser(dp_profile.ID);
        
        Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'Square Profile' LIMIT 1];
       list<User> managerUser=[SELECT id,Name, Email  FROM User WHERE ProfileId =:squareMag_profile.id ];
      //   list<User> managerUser=UsersUtil_Class.insertUser(squareMag_profile.ID);
      
      SC_Section__c sec = SC_MI_TestHandler.insertSection('Process Checklist','Site Measurement Meeting Confirmed',10,NULL);       
        insert sec;        
        
        SC_Section__c secc = SC_MI_TestHandler.insertSection('Date of Move in','Site Measurement Meeting Confirmed',10,NULL);       
        insert secc;        
        
        
        
        List<SC_Item__c> listItems = new List<SC_Item__c>();
        SC_Item__c itm1 = SC_MI_TestHandler.insertItem('Inspect each area within the client’s requirement',TRUE,'Picklist','Record Type D1;Record Type D2;Record Type D3'); 
        listItems.add(itm1);
        SC_Item__c itm2 = SC_MI_TestHandler.insertItem('Check, record & notify client about construction anomalies',TRUE,'Picklist','Record Type D1;Record Type D2;Record Type D3'); 
        listItems.add(itm2);
        SC_Item__c itm3 = SC_MI_TestHandler.insertItem('Measure floor-to-ceiling & all elevations of room (DP & SME)',TRUE,'Picklist','Record Type D1;Record Type D2;Record Type D3'); 
        listItems.add(itm3);
  SC_Item__c itm4 = SC_MI_TestHandler.insertItem('Photograph each area to be designed, to compare with measurement drawing & to align rendered images to similar views',TRUE,'Picklist','Record Type D1;Record Type D2;Record Type D3'); 
        listItems.add(itm4);
        SC_Item__c itm5 = SC_MI_TestHandler.insertItem('Photograph each area to be designed, to compare with measurement drawing & to align rendered images to similar views',TRUE,'Picklist','Record Type D1;Record Type D2;Record Type D3'); 
        listItems.add(itm5);
        SC_Item__c itm6 = SC_MI_TestHandler.insertItem('Apprise the client of the HomeLane installation process',TRUE,'Picklist','Record Type D1;Record Type D1;Record Type D1'); 
        listItems.add(itm6);
        SC_Item__c itm7 = SC_MI_TestHandler.insertItem('Core cutting location finalized by builder / builder approves location suggested by designer',TRUE,'Picklist','Record Type D1;Record Type D2;Record Type D3'); 
        listItems.add(itm7);
       /* SC_Item__c itm8 = SC_MI_TestHandler.insertItem('Test Itm check','TRUE','Picklist','Record Type D1'); 
        listItems.add(itm8);
        SC_Item__c itm9 = SC_MI_TestHandler.insertItem('Test Itm check','TRUE','Picklist','Record Type D1'); 
        listItems.add(itm9);*/
     /*   SC_Item__c itm10 = SC_MI_TestHandler.insertItem('Expected Move In',TRUE,'Date','Record Type D1;Record Type D2;Record Type D3'); 
        listItems.add(itm10);
        insert listItems;
        
        
        
        
         List<SC_Response__c> listResponse = new List<SC_Response__c>();
        
        SC_Response__c res1 = SC_MI_TestHandler.insertResponse('Y',itm1.Id,5,TRUE,TRUE);
        listResponse.add(res1);
        SC_Response__c res2 = SC_MI_TestHandler.insertResponse('Y',itm2.Id,10,TRUE,TRUE);
        listResponse.add(res2);
  SC_Response__c res3 = SC_MI_TestHandler.insertResponse('Y',itm3.Id,20,TRUE,TRUE);
        listResponse.add(res3);
  SC_Response__c res4 = SC_MI_TestHandler.insertResponse('Y',itm4.Id,30,TRUE,TRUE);
        listResponse.add(res4);
  SC_Response__c res5 = SC_MI_TestHandler.insertResponse('Y',itm5.Id,40,TRUE,TRUE);
        listResponse.add(res5);
  SC_Response__c res6 = SC_MI_TestHandler.insertResponse('Y',itm6.Id,50,TRUE,TRUE);
        listResponse.add(res6);
  SC_Response__c res7 = SC_MI_TestHandler.insertResponse('Y',itm7.Id,60,TRUE,TRUE);
        listResponse.add(res7);
 /* SC_Response__c res8 = SC_MI_TestHandler.insertResponse('Y',itm8.Id,70,TRUE,TRUE);
        listResponse.add(res8);
  SC_Response__c res9 = SC_MI_TestHandler.insertResponse('Y',itm9.Id,80,TRUE,TRUE);
        listResponse.add(res9);*/
/*  SC_Response__c res10 = SC_MI_TestHandler.insertResponse('Dec 14, 2016',itm10.Id,10,TRUE,TRUE);
        listResponse.add(res10);
        insert listResponse;
        
        List<SC_Response__c> listResponses = new List<SC_Response__c>();
        
        SC_Response__c ress1 = SC_MI_TestHandler.insertResponse('Y',itm1.Id,5,TRUE,TRUE);
        listResponses.add(ress1);
        SC_Response__c ress2 = SC_MI_TestHandler.insertResponse('Y',itm2.Id,10,TRUE,TRUE);
        listResponses.add(ress2);
  SC_Response__c ress3 = SC_MI_TestHandler.insertResponse('Y',itm3.Id,20,TRUE,TRUE);
        listResponses.add(ress3);
  SC_Response__c ress4 = SC_MI_TestHandler.insertResponse('Y',itm4.Id,30,TRUE,TRUE);
        listResponses.add(ress4);
  SC_Response__c ress5 = SC_MI_TestHandler.insertResponse('Y',itm5.Id,40,TRUE,TRUE);
        listResponses.add(ress5);
  SC_Response__c ress6 = SC_MI_TestHandler.insertResponse('Y',itm6.Id,50,TRUE,TRUE);
        listResponses.add(ress6);
  SC_Response__c ress7 = SC_MI_TestHandler.insertResponse('Y',itm7.Id,60,TRUE,TRUE);
        listResponses.add(ress7);
 /* SC_Response__c res8 = SC_MI_TestHandler.insertResponse('Y',itm8.Id,70,TRUE,TRUE);
        listResponse.add(res8);
  SC_Response__c res9 = SC_MI_TestHandler.insertResponse('Y',itm9.Id,80,TRUE,TRUE);
        listResponse.add(res9);*/
     /*     SC_Response__c ress10 = SC_MI_TestHandler.insertResponse('Dec 14, 2016',itm10.Id,10,TRUE,TRUE);
        listResponses.add(ress10);
        insert listResponses;

        
        List<SC_Section_Item__c> listSecItem = new List<SC_Section_Item__c>();
        SC_Section_Item__c secItm1 = SC_MI_TestHandler.insertSectionItem(itm1.Id,sec.Id,5);
        listSecItem.add(secItm1);
        SC_Section_Item__c secItm2 = SC_MI_TestHandler.insertSectionItem(itm2.Id,sec.Id,20);
        listSecItem.add(secItm2);
        SC_Section_Item__c secItm3 = SC_MI_TestHandler.insertSectionItem(itm3.Id,sec.Id,30);
        listSecItem.add(secItm3);
        SC_Section_Item__c secItm4 = SC_MI_TestHandler.insertSectionItem(itm4.Id,sec.Id,40);
        listSecItem.add(secItm4);
        SC_Section_Item__c secItm5 = SC_MI_TestHandler.insertSectionItem(itm5.Id,sec.Id,50);
        listSecItem.add(secItm5);
        SC_Section_Item__c secItm6 = SC_MI_TestHandler.insertSectionItem(itm6.Id,sec.Id,60);
        listSecItem.add(secItm6);
        SC_Section_Item__c secItm7 = SC_MI_TestHandler.insertSectionItem(itm7.Id,sec.Id,70);
        listSecItem.add(secItm7);
        SC_Section_Item__c secItm10 = SC_MI_TestHandler.insertSectionItem(itm10.Id,secc.Id,10);
        listSecItem.add(secItm10);
        insert listSecItem ; 
       
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='Quote Required',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id);
        insert perOpp;
        
        Element__c e = new Element__c();
        e.Name = 'Test';
        e.Type__c = 'File';
        e.Related_Object_ID__c  = perOpp.id;
        Insert e;*/
        
        
      /*  perOpp.Stage_Name__c = 'D1 Initiated';
        Update oppNxtStp;*/
        
       /*  perOpp.StageName='D1 Initiated';
        perOpp.sub_status__c='Site Measurement Meeting Confirmed';
        update perOpp;
        
         List<SC_User_Response__c> listUsrResp = new List<SC_User_Response__c>();
        SC_User_Response__c usrRsp1 = SC_MI_TestHandler.insertUsrResponse(itm1.Id,'Y','Site Measurement Meeting Confirmed',perOpp.Id,5);
        listUsrResp.add(usrRsp1);  
        SC_User_Response__c usrRsp2 = SC_MI_TestHandler.insertUsrResponse(itm2.Id,'Y','Site Measurement Meeting Confirmed',perOpp.Id,5);
        listUsrResp.add(usrRsp2); 
  
          SC_User_Response__c usrRsp3 = SC_MI_TestHandler.insertUsrResponse(itm3.Id,'Y','Site Measurement Meeting Confirmed',perOpp.Id,5);
        listUsrResp.add(usrRsp3);
          SC_User_Response__c usrRsp4 = SC_MI_TestHandler.insertUsrResponse(itm4.Id,'Y','Site Measurement Meeting Confirmed',perOpp.Id,5);
        listUsrResp.add(usrRsp4);
          SC_User_Response__c usrRsp5 = SC_MI_TestHandler.insertUsrResponse(itm5.Id,'Y','Site Measurement Meeting Confirmed',perOpp.Id,5);
        listUsrResp.add(usrRsp5);
          SC_User_Response__c usrRsp6 = SC_MI_TestHandler.insertUsrResponse(itm6.Id,'Y','Site Measurement Meeting Confirmed',perOpp.Id,5);
        listUsrResp.add(usrRsp6);
          SC_User_Response__c usrRsp7 = SC_MI_TestHandler.insertUsrResponse(itm7.Id,'Y','Site Measurement Meeting Confirmed',perOpp.Id,5);
        listUsrResp.add(usrRsp7);
          SC_User_Response__c usrRsp10 = SC_MI_TestHandler.insertUsrResponse(itm10.Id,'2016-12-09','Site Measurement Meeting Confirmed',perOpp.Id,5);
        listUsrResp.add(usrRsp10);
        insert listUsrResp; 
       
        
        
        system.debug('status'+perOpp.Sub_Status__c);
        //perOpp.name = 'JA';
        perOpp.Sub_Status__c = 'Site Measurements Uploaded';
        //perOpp.stageName = 'D1 Initiated';
        
        update perOpp;
    }*/
    public static testMethod void testShareOpportunityTwo(){
        
     //    SC_MI_TestHandler.insertIsTriggerExecute();
     //   SC_MI_TestHandler.insertCustomDate();
        
        dummy1 test = new dummy1();
        Opportunity_NextStep__c oppNxtStp = new Opportunity_NextStep__c();
        oppNxtStp.Next_Step__c = 'DP Follow up for Customer Reviews';
        oppNxtStp.Name= 'Initial Quote Sent1';
        oppNxtStp.Stage_Name__c = 'Quote Required';
        insert oppNxtStp;
        
         Profile pm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> pm_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :pm_profile.Id and isActive=true];
       //  list<User> pm_user=UsersUtil_Class.insertUser(pm_profile.ID); 
        
        Profile smm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> smm_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :smm_profile.Id and isActive=true];
      //  list<User> smm_user=UsersUtil_Class.insertUser(smm_profile.ID); 
        
        Profile agent_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> agent_user = [SELECT id,Name, Email  FROM User WHERE ProfileId = :agent_profile.Id and isActive=true];
      //   list<User> agent_user=UsersUtil_Class.insertUser(agent_profile.ID);
        
        Profile fac_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> fac_coordinator = [SELECT id,Name, Email  FROM User WHERE ProfileId = :fac_profile.Id and isActive=true];
      //   list<User> fac_coordinator=UsersUtil_Class.insertUser(fac_profile.ID);
        
        Profile dp_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        list<User> dp_prof = [SELECT id,Name, Email  FROM User WHERE ProfileId = :dp_profile.Id];
     //   list<User> dp_prof=UsersUtil_Class.insertUser(dp_profile.ID);
        
        Profile squareMag_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
       list<User> managerUser=[SELECT id,Name, Email  FROM User WHERE ProfileId =:squareMag_profile.id ];
      //   list<User> managerUser=UsersUtil_Class.insertUser(squareMag_profile.ID);
       
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya@gmail.com');
        insert con;
        
        Contact pmcon=new Contact(LastName='Group',FirstName='Pm',AccountId=businessAcc.Id,Email='priya@gmail.com');
        insert pmcon;
        
        Contact smcon=new Contact(LastName='Group',FirstName='Smm',AccountId=businessAcc.Id,Email='smOwner@gmail.com');
        insert smcon;
        
        Account personAcc=new Account(LastName='John',PersonEmail='John44@gmail.com');
        insert personAcc;
        
        Opportunity perOpp=new Opportunity(Name='John Arjun',AccountId=personAcc.Id,stageName='Quote Required',
                                                closeDate=system.today(),SMM__c=smm_user[0].id,PM__c=pm_user[0].id,
                                        Square_Showroom_Agent__c=agent_user[0].id,Square_Showroom_Manager__c=managerUser[0].id,
                                        Factory_Co_ordinator__c=fac_coordinator[0].id,design_partner__c=dp_prof[0].id);
        insert perOpp;
        
        Element__c e = new Element__c();
        e.Name = 'Test';
        e.Type__c = 'File';
        e.Related_Object_ID__c  = perOpp.id;
        Insert e;
       
        perOpp.StageName='D1 Initiated';
        perOpp.sub_status__c='Site Measurement Meeting Confirmed';
        update perOpp;
        
        SC_Section__c sec = SC_MI_TestHandler.insertSection('Process Checklist','Site Measurement Meeting Confirmed',10,NULL);       
        insert sec;        
        
        SC_Section__c secc = SC_MI_TestHandler.insertSection('Date of Move in','Site Measurement Meeting Confirmed',10,NULL);       
        insert secc;
        
        list<SC_Item__c> itemList=[SELECT Item__c,Response_Type__c FROM SC_Item__c];
        list<SC_Response__c> respList=[SELECT Answer__c,Item__c,Required_for_Next_Stage__c,Is_Active__c FROM SC_Response__c];
        
        list<SC_Section_Item__c> secItemsList=[SELECT id,Item__c,Section__r.Opportunity_Sub_Status__c,Section__r.Parent_Section__r.Opportunity_Sub_Status__c FROM SC_Section_Item__c WHERE Section__r.Section__c =:'Process Checklist' limit 50 ];
        list<SC_Section_Item__c> seccItemsList=[SELECT id,Item__c,Section__r.Opportunity_Sub_Status__c,Section__r.Parent_Section__r.Opportunity_Sub_Status__c FROM SC_Section_Item__c WHERE Section__r.Section__c =:'Date of Move in' limit 50];
        
        system.debug('*******secItemsList**********'+secItemsList);
        system.debug('*********seccItemsList********'+seccItemsList);
        
        List<SC_User_Response__c> listUsrResp = new List<SC_User_Response__c>();
        /*SC_User_Response__c usrRsp1 = SC_MI_TestHandler.insertUsrResponse(secItemsList[0].Item__c,'Y',secItemsList[0].Section__r.Parent_Section__r.Opportunity_Sub_Status__c,perOpp.Id,5);
        listUsrResp.add(usrRsp1);  
        SC_User_Response__c usrRsp2 = SC_MI_TestHandler.insertUsrResponse(secItemsList[1].Item__c,'Y',secItemsList[0].Section__r.Parent_Section__r.Opportunity_Sub_Status__c,perOpp.Id,5);
        listUsrResp.add(usrRsp2); 
  
      SC_User_Response__c usrRsp3 = SC_MI_TestHandler.insertUsrResponse(secItemsList[2].Item__c,'Y',secItemsList[0].Section__r.Parent_Section__r.Opportunity_Sub_Status__c,perOpp.Id,5);
        listUsrResp.add(usrRsp3);
      SC_User_Response__c usrRsp4 = SC_MI_TestHandler.insertUsrResponse(secItemsList[3].Item__c,'Y',secItemsList[0].Section__r.Parent_Section__r.Opportunity_Sub_Status__c,perOpp.Id,5);
        listUsrResp.add(usrRsp4);
      SC_User_Response__c usrRsp5 = SC_MI_TestHandler.insertUsrResponse(secItemsList[4].Item__c,'Y',secItemsList[0].Section__r.Parent_Section__r.Opportunity_Sub_Status__c,perOpp.Id,5);
        listUsrResp.add(usrRsp5);
      SC_User_Response__c usrRsp6 = SC_MI_TestHandler.insertUsrResponse(secItemsList[5].Item__c,'Y',secItemsList[0].Section__r.Parent_Section__r.Opportunity_Sub_Status__c,perOpp.Id,5);
        listUsrResp.add(usrRsp6);
      SC_User_Response__c usrRsp7 = SC_MI_TestHandler.insertUsrResponse(secItemsList[6].Item__c,'Y',secItemsList[0].Section__r.Parent_Section__r.Opportunity_Sub_Status__c,perOpp.Id,5);
        listUsrResp.add(usrRsp7);
      SC_User_Response__c usrRsp10 = SC_MI_TestHandler.insertUsrResponse(seccItemsList[0].Item__c,'2016-12-09',secItemsList[0].Section__r.Parent_Section__r.Opportunity_Sub_Status__c,perOpp.Id,5);
        listUsrResp.add(usrRsp10);
        insert listUsrResp; */
       // system.debug('*********secItemsList***********'+secItemsList);
        
        perOpp.Sub_Status__c = 'Site Measurements Uploaded';
        //perOpp.stageName = 'D1 Initiated';
        
       // update perOpp;
   }
}