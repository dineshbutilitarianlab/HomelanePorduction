global class LeadAndOpportunityTransferBatch implements Database.Batchable<sObject> 
{
   Public Set<Id> setOfIds = new Set<Id>();
   public boolean check = false;
    global LeadAndOpportunityTransferBatch (Set<Id> setOfIds)
    {
        this.setOfIds = setOfIds;
    }
    global LeadAndOpportunityTransferBatch ()
    {
        
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        Id recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        system.debug('recTypeId' +recTypeId);
        String query = 'Select Id, Initiator_Email__c,Opportunity__c,Sales_Manager_Email__c,Type_Of_Transfer__c,Lead__c,Operation_Status__c,RecordTypeId,Lead_Source__c,Showroom_User__c from Setup_Configuration__c where Operation_Status__c=\'Open\' AND RecordTypeId =: recTypeId ';
        if(!setOfIds.isEmpty())
        {
            query += ' and id=:setOfIds';
        }
        System.debug('query '+query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Setup_Configuration__c> setUpList)
    {
        boolean isSentToNimbus=false;
        system.debug('setUpList '+setUpList);
        system.debug(setUpList.size());
        set<String> emailSet = new set<String>();
        Map<id,Lead> updateLeadList = new Map<id,Lead>();
        Map<id,Opportunity> updateOppList = new Map<id,Opportunity>();
        Map<id,Showroom_User__c> updateIMList = new Map<id,Showroom_User__c>();
        List<lead> insertLeadList = new List<Lead>();
        Map<id,Setup_Configuration__c> setUpConfigList = new Map<id,Setup_Configuration__c>();
        set<id> idSet = new Set<id>();
        set<id> oppIdSet = new Set<id>();
        String Nimbus_Offline_Email= 'nimbus_offline@doowup.co';
        String Nimbus_HL_Email= 'nimbus_hl@doowup.co';
        Map<id, List<String>> showroomCityMap = new Map<id, List<String>>();
        Set<String> NimbusTransferSet = new Set<string>{GenericConstants.NIMBUS_TRANSFER,GenericConstants.Nimbus_DL_Offline_Transfer,GenericConstants.Nimbus_DL_Digital_Transfer,
                										GenericConstants.Nimbus_Relanded_Transfer,GenericConstants.Nimbus_Hindi_Transfer,GenericConstants.Nimbus_Telugu_Transfer,
            											GenericConstants.NIMBUS_DOOWUP_OFFLINE_TRANSFER,GenericConstants.NIMBUS_HL_MISSEDCALL_TRANSFER,
            											GenericConstants.Globiva_Offline_RL_Transfer, GenericConstants.Globiva_Offline_PB_Transfer, 
            											GenericConstants.Globiva_Relanded_Transfer, GenericConstants.Globiva_Feedback_Digital_Transfer, 
            											GenericConstants.Globiva_Digital_North_Transfer, GenericConstants.Globiva_Digital_South_Transfer, 
            											GenericConstants.Globiva_Digital_East_Transfer, GenericConstants.Globiva_Digital_West_Transfer, 
            											GenericConstants.Globiva_Digital_Centre_Transfer};
            											
        try
        {
            if(!setUpList.isEmpty())
         	{
                    for(Setup_Configuration__c setUpConfigRecord :setUpList )
                    {
                        if(setUpConfigRecord.Sales_Manager_Email__c !=null)
                        {
                            emailSet.add(setUpConfigRecord.Sales_Manager_Email__c);
                            idSet.add(setUpConfigRecord.Lead__c);
                            OppIdset.add(setUpConfigRecord.Opportunity__c);
                        }
                    }
                    
                    List <Showroom_User__c> listOfIMQueried = new List <Showroom_User__c>();
                    map<string,Showroom_User__C> mapofshowroomuser = new map<string,Showroom_User__c> ();
                    List<User> listofUser = new List<User>(); 
                    map<string,id> mapOfUser = new map<string,id> ();
                     
                    listOfIMQueried = [select Id,Name,Email__c,Role__c,Showroom_Name__c from Showroom_User__C where Email__c IN :emailSet ];
                    listofUser =[select Id,Name,email from User where Email IN :emailSet ];
                        if(!listOfIMQueried.isEmpty())
                        {
                            for(Showroom_User__c showroomuser :listOfIMQueried)
                            {
                                mapofshowroomuser.put(showroomuser.Email__c,showroomuser);
                            }  
                        }
                        if(!listofUser.isEmpty()) 
                        {
                            for(User us :listofUser)
                            {
                                mapOfUser.put(us.Email , us.id);
                            }
                        }
                		else
                        {
                            system.debug('user email is not present');
                        }
                        system.debug('mapofshowroomuser '+ mapofshowroomuser);
                     
                      //Added on 7th December 2023
                        List<Master__c> listOfShowrooms=new List<Master__c>([SELECT Id, Name,Showroom_Manager__c ,Showroom_Manager__r.Email__c
                                                                             FROM Master__c where Name IN :emailSet and Type__c='Dealer Showroom' and IsActive__c=true]);
                        map<String,Master__c> mapOfShowroomName = new map<String,Master__c> ();
                        
                        if(!listOfShowrooms.isEmpty())
                        {
                            for(Master__c showroom :listOfShowrooms)
                            {
                                mapOfShowroomName.put(showroom.Name,showroom);
                            }  
                        }
                        system.debug('mapOfShowroomName '+ mapOfShowroomName);
                    
                    	List <lead> ldLists = [select Id,PostalCode,HL_Referrer_Phone__c,City,FirstName,LastName,email,phone,Budget_Range__c,Property_Status__c,Property_Type__c,Property__c,Transfer_Status__c,
                                                   Property_Config__c,Account__c,Area_Code__c,Kitchen__c,Wardrobes__c,Entertainment_Unit__c,Study_Table_Book_Shelf__c,Crockery_Unit__c,Brand__c,LeadSource,Purpose_of_Interiors__c 
                                                   from Lead where id IN :idSet];
                        //List <Lead> listOfLeadQueried =[Select id,email,phone from lead where(email=:ld.Email or phone=:ld.Phone)and Brand__c =:'Doowup'];
                        system.debug('ldLists'+ldLists);
                        map<id,lead> leadMap = new map<id,Lead>();
                        Set<String> emailSetld = new Set<String>();
                        Set<String> phoneSet = new Set<String>();
                        if(!ldLists.isEmpty())
                        {
                            for(lead ld :ldLists)
                            {
                                leadMap.put(ld.id,ld);
                                emailSetld.add(ld.email);
                            }
                        }
                     
                        // Added on 12th June for Nimbus Doowup Opp Transfer
                        list<Opportunity> oppList = [SELECT Id, Full_Name__c, Name, Email_For_Communication__c, Lead_Postal_Code__c, Customer_Phone_Number__c, CityfromLead__c, AccountId, 
                                                     Property_Status__c, Property_Config__c, Kitchen__c, Wardrobes__c, Entertainment_Unit__c, Study_Table_Book_Shelf__c, Crockery_Unit__c, 
                                                     Property_Type__c, Property_Name__c, Purpose_of_Interiors__c, When_is_the_actual_possession_date__c, Budget_Range__c 
                                                     FROM Opportunity 
                                                     WHERE Id IN :OppIdset];
                     
                        map<id,Opportunity> oppMap = new map<id,Opportunity>();
                        if(!oppList.isEmpty())
                        {
                            for(Opportunity opp :oppList)
                            {
                                oppMap.put(opp.id,opp);
                            }
                        }
                     
                        system.debug('leadMap '+leadMap);
                        system.debug('emailSetld '+emailSetld);
                        List<lead> leadlist = [Select id,email,phone from lead where(email IN :emailSetld)and Brand__c =:'Doowup'];
                        system.debug('leadlist'+leadlist);
                        map<String,String> mapofdoowupLead = new  map<String,String>();
                        if (!leadlist.isEmpty())
                        {
                            for(lead ld :leadlist)
                            {
                               mapofdoowupLead.put(ld.Email,(String)ld.id);
                            }
                        }
                        system.debug('mapofdoowupLead'+mapofdoowupLead);
                        system.debug('setUpList '+setUpList);
                    
                    for(Setup_Configuration__c setUpConfigRecord :setUpList)
                    {
                            if(mapofshowroomuser.containsKey(setUpConfigRecord.Sales_Manager_Email__c)||mapOfUser.containsKey(setUpConfigRecord.Sales_Manager_Email__c)||
                               mapOfShowroomName.containskey(setUpConfigRecord.Sales_Manager_Email__c) || (setUpConfigRecord.Sales_Manager_Email__c).equals(Nimbus_offline_Email) || (setUpConfigRecord.Sales_Manager_Email__c).equals(Nimbus_HL_Email))
                            {
                                        if(setUpConfigRecord.Type_Of_Transfer__c == GenericConstants.IM_TRANSFER)
                                        {
                                            if(setUpConfigRecord.Lead__c!=null)
                                            {
                                                Lead leadToUpdate = new Lead();
                                                leadToUpdate.Id = setUpConfigRecord.Lead__c;
                                                LeadAndOpportunityTransferBatch.setLeadFields(leadToUpdate);
                                                leadToUpdate.Sales_Manager_Email__c = setUpConfigRecord.Sales_Manager_Email__c;
                                                leadToUpdate.Sales_Manager__c = mapofshowroomuser.get(setUpConfigRecord.Sales_Manager_Email__c).id;
                                                leadToUpdate.Assigned_to_Resi_ASM__c = true;
                                                leadToUpdate.Transfer_Status__c = GenericConstants.IM_TRANSFER;
                                                updateLeadList.put(leadToUpdate.id,leadToUpdate) ;
                                            //    setUpConfigRecord.Operation_Status__c = GenericConstants.SETUP_CONFIG_CLOSED_STATUS;
                                            }
                                            else if(setUpConfigRecord.Opportunity__c != null)
                                            {
                                                Opportunity opportunityToUpdate = new Opportunity();
                                                opportunityToUpdate.Id = setUpConfigRecord.Opportunity__c;
                                                opportunityToUpdate.Sales_Manager_Email__c = setUpConfigRecord.Sales_Manager_Email__c;
                                                opportunityToUpdate.Sales_Manager__c   = mapofshowroomuser.get(setUpConfigRecord.Sales_Manager_Email__c).id;
                                                opportunityToUpdate.Assigned_to_Resi_ASM__c = True;
                                                opportunityToUpdate.OwnerId = Label.HomelaneAPIUserID;
                                                opportunityToUpdate.Welcome_Team_Agent__c = Label.HomelaneAPIUserID;
                                                updateOppList.put(opportunityToUpdate.id,opportunityToUpdate);
                                                //setUpConfigRecord.Operation_Status__c = GenericConstants.SETUP_CONFIG_CLOSED_STATUS;
                                            }
                                        }
                                        
                                        else if(setUpConfigRecord.Type_Of_Transfer__c == GenericConstants.FREELANCER_TRANSFER)
                                        {
                                            if(setUpConfigRecord.Lead__c!=null)
                                            {
                                                Lead leadToUpdate = new Lead();
                                                leadToUpdate.Id = setUpConfigRecord.Lead__c;
                                                //leadToUpdate.Nimbus_Status__c=GenericConstants.NOT_A_NIMBUS_LEAD;
                                                leadToUpdate.Freelancer_User__c = mapofshowroomuser.get(setUpConfigRecord.Sales_Manager_Email__c).id;
                                                //setUpConfigRecord.Operation_Status__c = GenericConstants.SETUP_CONFIG_CLOSED_STATUS;
                                                 updateLeadList.put(leadToUpdate.id,leadToUpdate) ;
                                            }                                                                
                                        }
                                        
                                        else if(setUpConfigRecord.Type_Of_Transfer__c == GenericConstants.TELECALLER_TRANSFER)
                                        {
                                            if(setUpConfigRecord.Lead__c!=null)
                                            {
                                                Lead leadToUpdate = new Lead();
                                                leadToUpdate.Id = setUpConfigRecord.Lead__c;
                                                LeadAndOpportunityTransferBatch.setLeadFields(leadToUpdate);
                                                leadToUpdate.Assigned_To_TLC__c = true;
                                                leadToUpdate.Tele_caller__c =mapofshowroomuser.get(setUpConfigRecord.Sales_Manager_Email__c).id;
                                                leadToUpdate.Telecaller_Email__c=setUpConfigRecord.Sales_Manager_Email__c;
                                                //setUpConfigRecord.Operation_Status__c = GenericConstants.SETUP_CONFIG_CLOSED_STATUS;
                                                 updateLeadList.put(leadToUpdate.id,leadToUpdate) ;
                                            }
                                        }
                                        
                                        else if(setUpConfigRecord.Type_Of_Transfer__c == GenericConstants.Nimbus_Doowup_Opp_Transfer)
                                        {
                                            if(setUpConfigRecord.Opportunity__c!=null)
                                            {
                                                    lead createLdRec = new lead();
                                                    createLdRec = LeadTriggerCubicoAndDoowupHandler.createDoowupLeadFromOpportunity(oppMap.get(setUpConfigRecord.Opportunity__c));
                                                    CreateLdRec.Bulk_Upload__c= true;     
                                                    System.debug('CreateLdRec'+CreateLdRec);
                                                    insertLeadList.add(createLdRec) ;
                                                    oppMap.get(setUpConfigRecord.Opportunity__c).Transfer_Status__c = 'Doowup Transfer';
                                                    updateOppList.put(oppMap.get(setUpConfigRecord.Opportunity__c).id,oppMap.get(setUpConfigRecord.Opportunity__c));
                                            }
                                        }
                                        
                                        else if(nimbusTransferSet.contains(setUpConfigRecord.Type_Of_Transfer__c))
                                        {                        
                                            if(setUpConfigRecord.Lead__c!=null)
                                            {
                                                //isSentToNimbus = LeadAndOpportunityTransferBatch.previousStatusCheck(setUpConfigRecord.Lead__c);
                                                system.debug('isSentToNimbus '+isSentToNimbus);
                                                
                                                if(!isSentToNimbus)
                                                {
                                                    Lead leadToUpdate = new Lead();
                                                   
                                                    leadToUpdate.Id = setUpConfigRecord.Lead__c;
                                                    if(setUpConfigRecord.Type_Of_Transfer__c == GenericConstants.NIMBUS_TRANSFER )
                                                    {
                                                        LeadAndOpportunityTransferBatch.setLeadFields(leadToUpdate);                                      
                                                    }
                                                     
                                                    leadToUpdate.Nimbus_Assignment_Date__c= system.now();
                                                    leadToUpdate.Nimbus_Campaign__c= setUpConfigRecord.Type_Of_Transfer__c;
                                                    leadToUpdate.Nimbus_Status__c = GenericConstants.ASSIGNED_TO_NIMBUS;
                                                    //setUpConfigRecord.Operation_Status__c = GenericConstants.SETUP_CONFIG_CLOSED_STATUS;
                                                    updateLeadList.put(leadToUpdate.id,leadToUpdate) ;                                
                                                }
                                                else
                                                {
                                                    system.debug('lead already sent to nimbus');
                                                 //   setUpConfigRecord.Operation_Status__c = GenericConstants.SETUP_CONFIG_CLOSED_STATUS;
                                                     setUpConfigRecord.Error_Message__c ='Lead is already send to Nimbus';
                                                     check = true;
                                                 }                            
                                            }
                                        }
                                        
                                        else if(setUpConfigRecord.Type_Of_Transfer__c == GenericConstants.DOOWUP_TRANSFER)
                                        {
                                            System.debug('Doowup');
                                            if(setUpConfigRecord.Lead__c!=null)
                                            {
                                                lead createLdRec = new lead();
                                              
                                                createLdRec.LastName=leadMap.get(setUpConfigRecord.Lead__c).LastName;
                                                createLdRec.Email=leadMap.get(setUpConfigRecord.Lead__c).email;
                                                createLdRec.Phone = leadMap.get(setUpConfigRecord.Lead__c).phone;
                                                createLdRec.PostalCode = leadmap.get(setUpConfigRecord.Lead__c).postalCode;
                                                createLdRec.City=leadmap.get(setUpConfigRecord.Lead__c).City;                            
                                                createLdRec.Account__c =leadmap.get(setUpConfigRecord.Lead__c).Account__c;
                                                createLdRec.Property_Config__c = leadmap.get(setUpConfigRecord.Lead__c).Property_Config__c;
                                                createLdRec.Property__c = leadmap.get(setUpConfigRecord.Lead__c).Property__c;
                                                createLdRec.Property_Status__c=leadmap.get(setUpConfigRecord.Lead__c).Property_Status__c;
                                                createLdRec.Property_Type__c = leadmap.get(setUpConfigRecord.Lead__c).Property_Type__c;
                                                // Added Purpose_of_Interiors__c on 23rd August 2024
                                                createLdRec.Purpose_of_Interiors__c = leadmap.get(setUpConfigRecord.Lead__c).Purpose_of_Interiors__c;
                                                createLdRec.LeadSource= setUpConfigRecord.Lead_Source__c;
                                                createLdRec.Brand__c='Doowup';
                                                CreateLdRec.Bulk_Upload__c= true;                            
                                                
                                                if(leadmap.get(setUpConfigRecord.Lead__c).Budget_Range__c !=null)
                                                {
                                                    String budget=leadmap.get(setUpConfigRecord.Lead__c).Budget_Range__c;
                                                    if(budget == GenericConstants.Lead_Budget_1L)
                                                    {
                                                        createLdRec.Budget_Range__c='50K - 1.5L';                                    
                                                    }                                
                                                    else if(budget == GenericConstants.Lead_Budget_4L)	
                                                    {
                                                        createLdRec.Budget_Range__c='1.5L - 3L';                                    
                                                    }
                                                    else if(budget == GenericConstants.Lead_Budget_8L)	
                                                    {
                                                        createLdRec.Budget_Range__c='5L - 8L';                                    
                                                    }
                                                    else if(budget == '8L - 12L'|| budget == '12L - 20L' || budget == '20L+')	
                                                    {
                                                        createLdRec.Budget_Range__c='8L+';                                    
                                                    }
                                                    else
                                                    {
                                                        createLdRec.Budget_Range__c=leadmap.get(setUpConfigRecord.Lead__c).Budget_Range__c;
                                                    }
                                                }
                                                
                                                
                                                if(!mapofshowroomuser.isEmpty() && mapofshowroomuser.containsKey(setUpConfigRecord.Sales_Manager_Email__c))
                                                {
                                                    if(mapofshowroomuser.get(setUpConfigRecord.Sales_Manager_Email__c).Role__c =='Doowup Presales')
                                                    {
                                                        createLdRec.Assigned_to_Doowup_Presales__c= true;
                                                        createLdRec.Doowup_Presales__c=mapofshowroomuser.get(setUpConfigRecord.Sales_Manager_Email__c).id;                                            
                                                    }
                                                    else if(mapofshowroomuser.get(setUpConfigRecord.Sales_Manager_Email__c).Role__c =='Inside Sales Agent')
                                                    {
                                                        createLdRec.Assigned_To_Inside_Sales_Agent__c  = true;
                                                        createLdRec.Inside_Sales_Agent__c = mapofshowroomuser.get(setUpConfigRecord.Sales_Manager_Email__c).id;                                            
                                                    }
                                                    else if(mapofshowroomuser.get(setUpConfigRecord.Sales_Manager_Email__c).Role__c =='Tele Caller Agent')
                                                    {
                                                        createLdRec.Assigned_To_TLC__c   = true;
                                                        createLdRec.Tele_caller__c  = mapofshowroomuser.get(setUpConfigRecord.Sales_Manager_Email__c).id;                                            
                                                    }
                                                    else
                                                    {
                                                        createLdRec.Assigned_to_Resi_ASM__c=true;                                    
                                                        createLdRec.Sales_Manager__c=mapofshowroomuser.get(setUpConfigRecord.Sales_Manager_Email__c).id;
                                                        createLdRec.Appointment_Venue_Square__c =mapofshowroomuser.get(setUpConfigRecord.Sales_Manager_Email__c).Showroom_Name__c;
                                                    }
                                                    createLdRec.OwnerId=Label.HomelaneAPIUserID;
                                                    createLdRec.WT_Agent__c=Label.HomelaneAPIUserID;                                        
                                                }                           
                                                
                                                else if(!mapOfUser.isEmpty() && mapOfUser.containsKey(setUpConfigRecord.Sales_Manager_Email__c))
                                                {
                                                    createLdRec.OwnerId=mapOfUser.get(setUpConfigRecord.Sales_Manager_Email__c);
                                                    createLdRec.WT_Agent__c = mapOfUser.get(setUpConfigRecord.Sales_Manager_Email__c);
                                                }
                                                
                                                // If showroom name is present in EMail field
                                                else if(!mapOfShowroomName.isEmpty() && mapOfShowroomName.containskey(setUpConfigRecord.Sales_Manager_Email__c))
                                                {
                                                    createLdRec.Appointment_Venue_Square__c = mapOfShowroomName.get(setUpConfigRecord.Sales_Manager_Email__c).id;
                                                    createLdRec.Dealer__c= mapOfShowroomName.get(setUpConfigRecord.Sales_Manager_Email__c).Showroom_Manager__c;
                                                    createLdRec.Assigned_to_Dealer__c= true;
                                                    createLdRec.Dealer_Email__c =mapOfShowroomName.get(setUpConfigRecord.Sales_Manager_Email__c).Showroom_Manager__r.Email__c;
                                                    //createLdRec.Doowup_Presales_Email__c=ShowroomUser[0].Email__c;
                                                }     
                                                
                                                else if(setUpConfigRecord.Sales_Manager_Email__c.equals(Nimbus_offline_Email))
                                                {
                                                     CreateLdRec.Nimbus_Campaign__c = GenericConstants.NIMBUS_DOOWUP_OFFLINE_TRANSFER;
                                                }
                                                
                                                else if(setUpConfigRecord.Sales_Manager_Email__c.equals(Nimbus_HL_Email))
                                                {
                                                     CreateLdRec.Nimbus_Campaign__c = GenericConstants.NIMBUS_DOOWUP_HL_TRANSFER;
                                                }
                                                
                                                System.debug('CreateLdRec'+CreateLdRec);
                                                insertLeadList.add(createLdRec) ;
                                            }
                                        }
                                        
                                        else if(setUpConfigRecord.Type_Of_Transfer__c == GenericConstants.Doowup_Presales_Transfer)
                                        {
                                            if(setUpConfigRecord.Lead__c!=null)
                                            {
                                                Lead leadToUpdate = new Lead();
                                                leadToUpdate.Id = setUpConfigRecord.Lead__c;
                                                LeadAndOpportunityTransferBatch.setLeadFields(leadToUpdate);
                                                leadToUpdate.Doowup_Presales__c = mapofshowroomuser.get(setUpConfigRecord.Sales_Manager_Email__c).id;
                                                leadToUpdate.Assigned_to_Doowup_Presales__c= true;
                                                leadToUpdate.Doowup_Presales_Email__c =setUpConfigRecord.Sales_Manager_Email__c;
                                                //setUpConfigRecord.Operation_Status__c = GenericConstants.SETUP_CONFIG_CLOSED_STATUS;
                                                updateLeadList.put(leadToUpdate.id,leadToUpdate) ;
                                            }
                                        }
                                        
                                        else if(setUpConfigRecord.Type_Of_Transfer__c == GenericConstants.Offline_Relanded_Transfer)
                                        {
                                            if(setUpConfigRecord.Lead__c!=null)
                                            {
                                                Lead leadToUpdate = new Lead();
                                                leadToUpdate.Id = setUpConfigRecord.Lead__c;
                                             //   leadToUpdate.Bulk_Upload__c= true;
                                                leadToUpdate.Status= GenericConstants.LEAD_FRESH_STATUS;
                                                leadToUpdate.Sub_Status__c= GenericConstants.LEAD_RELANDED_SUBSTATUS;
                                                leadToUpdate.Relanded_Date__c= system.now();
                                                leadToUpdate.Relanded_Source__c = GenericConstants.Sales_Team_Redialing;
                                                //setUpConfigRecord.Operation_Status__c = GenericConstants.SETUP_CONFIG_CLOSED_STATUS;
                                                 updateLeadList.put(leadToUpdate.id,leadToUpdate) ;                                    
                                            }
                                        }
                                        
                                        else if(setUpConfigRecord.Type_Of_Transfer__c == GenericConstants.IM_Classification_Transfer)
                                        {
                                            if(setUpConfigRecord.Showroom_User__c!=null)
                                            {
                                                Showroom_User__C  shToUpdate = new Showroom_User__C();
                                                shToUpdate.Id = setUpConfigRecord.Showroom_User__c;
                                                shtoUpdate.IM_Class__c = setUpConfigRecord.Lead_Source__c;
                                                //setUpConfigRecord.Operation_Status__c = GenericConstants.SETUP_CONFIG_CLOSED_STATUS;
                                                updateIMList.put(shtoUpdate.id,shtoUpdate) ;                                    
                                            }
                                        }
                                        
                                        else if(setUpConfigRecord.Type_Of_Transfer__c == GenericConstants.Inside_Sales_Transfer)
                                        {
                                            if(setUpConfigRecord.Lead__c!=null)
                                            {
                                               	Lead leadToUpdate = new Lead();
                            					leadToUpdate.Id = setUpConfigRecord.Lead__c;
                            					LeadAndOpportunityTransferBatch.setLeadFields(leadToUpdate);                                                
                                                leadToUpdate.Inside_Sales_Agent__c = mapofshowroomuser.get(setUpConfigRecord.Sales_Manager_Email__c).id;
                                                leadToUpdate.Assigned_To_Inside_Sales_Agent__c = true;
                                                leadToUpdate.Inside_Sales_Agent_Email__c = setUpConfigRecord.Sales_Manager_Email__c;
                                                //setUpConfigRecord.Operation_Status__c = GenericConstants.SETUP_CONFIG_CLOSED_STATUS;
                                                 updateLeadList.put(leadToUpdate.id,leadToUpdate) ;
                                            }
                                        }
                                        
                                        else if(setUpConfigRecord.Type_Of_Transfer__c == GenericConstants.Cubico_Transfer) 
                                        {
                                                if(setUpConfigRecord.Lead__c!=null)
                                                {
                                                        showroomCityMap = LeadTriggerCubicoAndDoowupHandler.getcubicoShowroomMetadata();
                                                        lead createLdRec = LeadTriggerCubicoAndDoowupHandler.cubicolead(leadMap.get(setUpConfigRecord.Lead__c));                                    
                                                        insertLeadList.add(createLdRec) ;                            
                                                }                                   
                                        }
                                        
                                        
                                            /*	else if(setUpConfigRecord.Type_Of_Transfer__c == GenericConstants.Wrapzap_Transfer) 
                                                {
                                                    if(setUpConfigRecord.Lead__c!=null)
                                                    {
                                                         lead createLdRec = LeadTriggerCubicoAndDoowupHandler.wrapzaplead(leadMap.get(setUpConfigRecord.Lead__c));
                                                        
                                                         insertLeadList.add(createLdRec) ;                            
                                                    }                                  
                                                    
                                                }*/
                                                
                                              
                                        else
                                        {
                                            system.debug('Value of Type_Of_Transfer is not IM Transfer/Freelancer/Telecaller/Nimbus Transfer/Doowup Presales Transfer. Currently only these value are supported');
                                            setUpConfigRecord.Error_Message__c = 'Value of Type_Of_Transfer is not IM Transfer/Freelancer Transfer. Currently only these value are supported';
                                            setUpConfigRecord.Operation_Status__c = GenericConstants.SETUP_CONFIG_FAILED_STATUS;
                                        }
                               }
                               else
                               {
                                    system.debug('IM EMail is not Present');
                                    setUpConfigRecord.Error_Message__c = 'There is no Ironman with this email address. Please check the Sales_Manager_Email properly.';
                                    setUpConfigRecord.Operation_Status__c = GenericConstants.SETUP_CONFIG_FAILED_STATUS;
                               }
	
                        		setUpConfigList.put(setUpConfigRecord.id,setUpConfigRecord);
                    }
                    
                    system.debug('setUpConfigList '+setUpConfigList);
                    system.debug('updateOppList '+updateOppList);
                    system.debug('updateLeadList '+updateLeadList);
                    system.debug('insertLeadList'+insertLeadList);
                    system.debug('size of insert'+insertLeadList.size());
                     
                    List<Database.SaveResult> results = null;
                     
                     
                        if(!updateLeadList.isEmpty())
                        {
                          results = database.update(updateLeadList.values(),false);
                        }
                        
                        if(!updateOppList.isEmpty())
                        {
                         results = database.update (updateOppList.values(),false);
                        }
                        
                        if(!insertLeadList.isEmpty())
                        {
                            
                          results = database.insert (insertLeadList,false);
                        } 
                        if(!updateIMList.isEmpty())
                        {
                          results  = database.update (updateIMList.values(),false);
                        }
                        for (Database.SaveResult result : results) 
                        {
                            if (!result.isSuccess())
                            {
                                for (Database.Error err : result.getErrors())
                                {
                                    System.debug('Error: '+ err.getStatusCode() + ' ' + err.getMessage());
                                    setUpList[0].Error_Message__c = err.getMessage();
                                    setUpList[0].Operation_Status__c = GenericConstants.SETUP_CONFIG_FAILED_STATUS;
                                    setUpConfigList.put(setUpList[0].id,setUpList[0]);
                                }
                            }
                            else
                            {
                                setUpList[0].Operation_Status__c = GenericConstants.SETUP_CONFIG_CLOSED_STATUS;
                            }
                        }
                }
             
                 else
                 {
                     system.debug('setup list is empty');
                 }   
        
    }
        catch(Exception e)
        {
            Logger.log('Exception','LeadAndOpportunityTransferBatch Class','Execute Method',e.getMessage(),e.getStackTraceString(),null);
            
            setUpList[0].Error_Message__c = e.getMessage();
            setUpList[0].Operation_Status__c = GenericConstants.SETUP_CONFIG_FAILED_STATUS;
            setUpConfigList.put(setUpList[0].id,setUpList[0]);
        }
        
             if(!setUpConfigList.isEmpty())
             {
                 database.update (setUpConfigList.values(),false);
             }          
    }
    
    public void finish(Database.BatchableContext BC)
    {
        Id recTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        List<Setup_Configuration__c> setUpConfigList = [Select Id,Initiator_Email__c,Opportunity__c,Sales_Manager_Email__c,Type_Of_Transfer__c,Lead__c,Operation_Status__c,RecordTypeId,Lead_Source__c from Setup_Configuration__c where Operation_Status__c='Open' AND RecordTypeId =:recTypeId];
        System.debug('setUpConfigList '+setUpConfigList);
        if(!setUpConfigList.isEmpty())
        {
            LeadAndOpportunityTransferBatch leadAndOpportunityTransfer = new LeadAndOpportunityTransferBatch();
            database.executeBatch(leadAndOpportunityTransfer,1);
        }
        else
        {
            System.debug('No Record to Prcessed further');
            try
            {
                Batch_Processing_Check__c batchInProgressCheck = Batch_Processing_Check__c.getInstance(GenericConstants.IM_TRANSFER_CHECK);
                batchInProgressCheck.IsExecuting__c = false;
                update batchInProgressCheck;
            }
            catch(exception e)
            {
                system.debug('-------exp finish-----------'+e.getmessage());
            }
            
        }
        
        
    }
    
    public Static boolean previousStatusCheck(Id leadID)
    {
        boolean isSentToNimbusCheck= false;
        if(leadID!=null)
        {
            lead ld= [select id,Nimbus_Status__c from lead where id=:leadID ];
            if(ld!=null)
            {
                if (ld.Nimbus_Status__c == 'Sent to Nimbus')
                {
                    isSentToNimbusCheck =true;
                }
            }
        }
        system.debug('isSentToNimbusCheck');
        return isSentToNimbusCheck;
    }
    public static lead setLeadFields(Lead leadToUpdate)
    {
        system.debug('checkupdate');
        leadToUpdate.OwnerId = Label.HomelaneAPIUserID;
        leadToUpdate.WT_Agent__c = Label.HomelaneAPIUserID;
        leadToUpdate.Assigned_to_Central_Team__c=false;
        leadToUpdate.Assigned_to_Doowup_Presales__c=false;
        leadToUpdate.Assigned_To_Inside_Sales_Agent__c=false;
        leadToUpdate.Assigned_To_TLC__c=false;
        leadToupdate.Assigned_to_Resi_ASM__c=false;
        leadToupdate.Sales_Manager__c = null;
        leadToUpdate.Sales_Manager_Email__c=null;
    //  leadToUpdate.Inside_Sales_Agent__c = null;
    //  leadToUpdate.Inside_Sales_Agent_Email__c=null;
        leadToUpdate.Doowup_Presales__c= null;
        leadToUpdate.Doowup_Presales_Email__c = null;
        leadToUpdate.Tele_caller__c = null;
        leadToUpdate.Telecaller_Email__c = null;
        leadToUpdate.Central_Team_Agent__c=null;
        leadToUpdate.Central_Team_Agent_Email__c=null;
        
        //leadToUpdate.Nimbus_Status__c= GenericConstants.NOT_A_NIMBUS_LEAD;
        system.debug('leadToUpdate'+ leadToUpdate.Sales_Manager__c);
        return leadToUpdate;
    }
    
    
}