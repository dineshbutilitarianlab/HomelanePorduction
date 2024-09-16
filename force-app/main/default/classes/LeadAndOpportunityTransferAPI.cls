@RestResource(urlMapping='/LeadAndOpportunityTransferAPI/*')
Global class LeadAndOpportunityTransferAPI {
    @HttpPost
    global static void leadOrOpportunityUpdate() {
        RestResponse res = new RestResponse();
        RestRequest req = RestContext.request;
        ResponseWrapper respWrap = new ResponseWrapper();        
        String inputData = req.requestBody.toString();
        String Nimbus_Offline_Email= 'nimbus_offline@doowup.co';
        String Nimbus_HL_Email= 'nimbus_hl@doowup.co';
        list<String> leadId = new List<String>();
       
        boolean checkReqEmail = false;
        Set<String> leadSourceSet = new Set<String>{GenericConstants.Lead_Source_HomeLane,GenericConstants.Lead_Source_HomeLane_DeadLead,
            										GenericConstants.Lead_Source_HomeLane_Opportunity,GenericConstants.Lead_Source_HomeLane_ScopeUndetermined,
            										GenericConstants.Lead_Source_Offline_DeadLead};
        Set<String> NimbusTransferSet = new Set<string>{GenericConstants.NIMBUS_TRANSFER,GenericConstants.Nimbus_DL_Offline_Transfer,GenericConstants.Nimbus_DL_Digital_Transfer,
                										GenericConstants.Nimbus_Relanded_Transfer,GenericConstants.Nimbus_Hindi_Transfer,GenericConstants.Nimbus_Telugu_Transfer,
            											GenericConstants.NIMBUS_DOOWUP_OFFLINE_TRANSFER,GenericConstants.NIMBUS_HL_MISSEDCALL_TRANSFER,
            											GenericConstants.Globiva_Offline_RL_Transfer, GenericConstants.Globiva_Offline_PB_Transfer, 
            											GenericConstants.Globiva_Relanded_Transfer, GenericConstants.Globiva_Feedback_Digital_Transfer, 
            											GenericConstants.Globiva_Digital_North_Transfer, GenericConstants.Globiva_Digital_South_Transfer, 
            											GenericConstants.Globiva_Digital_East_Transfer, GenericConstants.Globiva_Digital_West_Transfer, 
            											GenericConstants.Globiva_Digital_Centre_Transfer};
        Set<String> roleSet = new Set<String>{GenericConstants.ROLE_PreSalesFreelancer,GenericConstants.Doowup_PreSales_Role,GenericConstants.ROLE_TeleCallerAgent};
        Set<String> deadStatusSet = new Set<String>{GenericConstants.LEAD_DEAD_STATUS,GenericConstants.LEAD_NOT_ACTIVELY_PURSUED_STATUS};
        Set<id> deadLeadSet = new Set<id>();
        Set<String> imClassSet = new Set<String>{GenericConstants.IM_Class_Gold,GenericConstants.IM_Class_Silver,GenericConstants.IM_Class_Bronze};
        List<ResponseWrapperResult> listOfResponseWrapperResult = new List<ResponseWrapperResult>();
        try
        {
            if(String.isNotBlank(inputData))
            {
                System.debug('inputdata'+ inputData);
                List<RequestWrapper> reqWrap = (List<RequestWrapper>)Json.deserialize(inputData, List<RequestWrapper>.Class);
                List<Setup_Configuration__c> setUpConfigList = new List<Setup_Configuration__c>();
                
                set<String> emailSet = new set<String>();
                set<id> idSet = new Set<id>();
                
                if(!reqWrap.isEmpty()){
                    for(RequestWrapper requestItem : reqWrap){
                        system.debug('requestItem '+ requestItem);
                        if(!String.isBlank(requestItem.Sales_Manager_Email)&&!String.isBlank(requestItem.SF_Lead_Opportunity_ID)){
                            emailSet.add(requestItem.Sales_Manager_Email);
                            idSet.add(requestItem.SF_Lead_Opportunity_ID);
                        }
                    }
                }
                system.debug('email set '+ emailSet );
                List <Showroom_User__C> listOfIMQueried = new List <Showroom_User__C>();
                List <Showroom_User__C> listOfIMIds = new List <Showroom_User__C>();
                List<User> listofUser = new List<User>();                            
                map<string,Showroom_User__C> mapofshowroomuser = new map<string,Showroom_User__C> ();
                
                map<string,User> mapOfUser = new map<string,User> ();
                listOfIMQueried = [select Id,Name,Email__c,Role__c from Showroom_User__C where Email__c IN :emailSet ];
                
                listofUser =[select Id,Name,email from User where Email IN :emailSet ];
                system.debug('listOfIMQueried '+ listOfIMQueried);
                if(!listOfIMQueried.isEmpty()){
                    for(Showroom_User__C showroomuser :listOfIMQueried){
                        mapofshowroomuser.put(showroomuser.Email__c,showroomuser);
                    }  
                }
                
                
                
                
                //Added on 7th December 2023 for DFN showroom allotment
                List<Master__c> listOfShowrooms=new List<Master__c>([SELECT Id, Name ,Showroom_Manager__c 
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
                
                
                
                
                //Showroom user data query this is used for updating Irm class
                listOfIMIds =[select Id,Name,Email__c,Role__c from Showroom_User__C where id In:idSet];
                map<id,Showroom_User__C> mapofIMIds = new map<id,Showroom_User__C> ();
                if(!listOfIMIds.isEmpty()){
                    for(Showroom_User__C showroomuser :listOfIMIds){
                       
                        mapofIMIds.put(showroomuser.id,showroomuser);
                    }
                }
                if(!listofUser.isEmpty()) {
                    for(User us :listofUser){
                        mapOfUser.put(us.Email , us);
                    }
                }else{
                    system.debug('user email is not present');
                }
                system.debug('mapofshowroomuser '+ mapofshowroomuser);
                
                
                // nimbus status check if lead is already send to nimbus
                List <Lead> listOfIdQueried = new List <Lead>();
                map<id,Lead> mapofLeaduser = new map<id,Lead> ();
                if(!idSet.isEmpty()){
                    listOfIdQueried = [select Id,lastName,Nimbus_Status__c,Brand__c,Status,Transfer_Status__c from Lead where id IN :idSet ];
                }else{
                    system.debug('id is not present');
                }
                
                system.debug('listOfIMQueried '+ listOfIMQueried);
                
                if(!listOfIdQueried.isEmpty()){
                    for(Lead ld :listOfIdQueried){
                        mapofLeaduser.put(ld.id,ld);
                        if(deadStatusSet.contains(ld.Status)){
                            deadLeadSet.add(ld.id);
                        }
                    }  
                }else{
                    system.debug('List of Lead has no records');
                }
                system.debug('mapofLeaduser '+mapofLeaduser);
                
                
                
                //Opportunity ids 
                List <Opportunity> listOfoppIdQueried = new List <Opportunity>();
                map<id,Opportunity> oppMap = new map<id,Opportunity> ();
                
                // For Nimbus Doowup Opp transfer we need to check if doowup lead exist and also figure out duplicate in same sheet
                Set<String> oppEmailSet = new Set<String>();
                Set<String> oppPhoneSet = new Set<String>();
                Set<id> oppAccountIdSet = new Set<id>();
                
                if(!idSet.isEmpty())
                {
                    listOfoppIdQueried = [select Id,Name,Brand__c,Email_For_Communication__c,Customer_Phone_Number__c,AccountId from Opportunity where id IN :idSet ];
                }
                else
                { 
                    system.debug('id is not present');
                }
                system.debug('listOfoppIdQueried '+ listOfoppIdQueried);
                if(!listOfoppIdQueried.isEmpty())
                {
                    for(Opportunity opp:listOfoppIdQueried)
                    {
                        oppMap.put(opp.id,opp);
                        oppEmailSet.add(opp.Email_for_Communication__c);
                        oppPhoneSet.add(opp.Customer_Phone_Number__c);
                        oppAccountIdSet.add(opp.AccountId);
                    }  
                }
                else
                {
                    system.debug('List of Opportunity has no records');
                }
                system.debug('oppMap'+oppMap );
                
                List<lead> doowupLeadListfromOpportunity = [Select id,email,phone,Brand__c from lead where(email IN :oppEmailSet or phone IN:oppPhoneSet)and Brand__c =:'Doowup'];
                system.debug('doowupLeadListfromOpportunity'+doowupLeadListfromOpportunity);
                map<String,String> mapofdoowupLeadFromOpportunity = new map<String,String>();
                
                if (!doowupLeadListfromOpportunity.isEmpty())
                {
                    for(lead ld :doowupLeadListfromOpportunity)
                    {
                        mapofdoowupLeadFromOpportunity.put(ld.Email,(String)ld.id); 
                        mapofdoowupLeadFromOpportunity.put(ld.Phone,(String)ld.id);
                    }
                }
                system.debug('mapofdoowupLeadFromOpportunity'+mapofdoowupLeadFromOpportunity);
                set<string> oppExcludedEmailSet = new set<string>(); 
                set<string> oppExcludedPhoneSet = new set<string>(); 
                Set<id> oppExcludeAccountIdSet = new Set<Id>();
                
                
                ///////////////////////////////////////////////////////////////////////////////////
                // For Doowup transfer need to check if doowup lead exist and also figure out duplicate in same sheet
                Set<String> emailSetld = new Set<String>();
                Set<String> phoneSet = new Set<String>();
                Set<id> accountIdSet = new Set<id>();
                
                List <lead> ldLists = [select Id,PostalCode,HL_Referrer_Phone__c,City,FirstName,LastName,email,phone,Budget_Range__c,Purpose_of_Interiors__c,Transfer_Status__c,Property_Status__c,Property_Type__c,Property__c,Property_Config__c,Account__c,Brand__c,LeadSource from Lead where id IN :idSet];
                //List <Lead> listOfLeadQueried =[Select id,email,phone from lead where(email=:ld.Email or phone=:ld.Phone)and Brand__c =:'Doowup'];
                system.debug('ldLists'+ldLists);
                map<id,lead> leadMap = new map<id,Lead>();
              
                if(!ldLists.isEmpty())
                {
                    for(lead ld :ldLists)
                    {
                        leadMap.put(ld.id,ld);
                        emailSetld.add(ld.email);
                        phoneSet.add(ld.phone);
                        accountIdSet.add(ld.Account__c);
                    }
                }
                system.debug('leadMap '+leadMap);
                system.debug('emailSetld '+emailSetld);
                List<lead> leadlist = [Select id,email,phone,Brand__c,Transfer_Status__c from lead where(email IN :emailSetld or phone IN:phoneSet)and Brand__c =:'Doowup'];
                system.debug('leadlist'+leadlist);
                map<String,String> mapofdoowupLead = new  map<String,String>();
                
                if (!leadlist.isEmpty())
                {
                    for(lead ld :leadlist)
                    {
                        mapofdoowupLead.put(ld.Email,(String)ld.id); 
                        mapofdoowupLead.put(ld.Phone,(String)ld.id);
                    }
                }
                system.debug('mapofdoowupLead'+mapofdoowupLead);
                set<string> excludedEMailSet = new set<string>(); 
                set<string> excludedPhoneSet = new set<string>(); 
                Set<id> excludeAccountIdSet = new Set<Id>();
               ///////////////////////////////////////////////////////////////////////////////////////////           
                
                //  Cubico and Wrapzap lead check
                system.debug('accountIdSet '+ accountIdSet);
                List<Account> cubicoWrapZapAccList= [SELECT Id ,(select id,Brand__c,Sign_Up_Source__c from leads__r) FROM Account where Id IN :accountIdSet];
                system.debug('cubicoWrapZapAccList '+ cubicoWrapZapAccList);
                map<id, String> cubicoAccMap = new map<id, String>();
                map<id, String> wrapzapAccMap = new map<id, String>();

                if(!cubicoWrapZapAccList.isEmpty()){
                    for(Account cb : cubicoWrapZapAccList)
                    {
                        for(lead cbld : cb.Leads__r)
                        {
                            if(cbld.Sign_Up_Source__c==GenericConstants.Brand_Cubico)
                            {
                               cubicoAccMap.put(cb.id,cbld.id);
                               system.debug('cubicoAccMap '+ cubicoAccMap);
                            }
                            if(cbld.Sign_Up_Source__c==GenericConstants.Brand_Wrapzap)
                            {
                               wrapzapAccMap.put(cb.id,cbld.id);
                               system.debug('wrapzapAccMap '+ wrapzapAccMap);
                            }
                        }
                        
                    }  
                }
                
                
                if(!reqWrap.isEmpty())
                {
                    for(RequestWrapper requestItem : reqWrap)
                    {
                        Boolean checkDoowup = false;
                        String email = null;
                        String phone =null;
                        String opp_email = null;
                        String opp_phone =null;
                        //setUpUpdate.Type_Of_Transfer__c = 'IM Transfer';
                        if(!String.isBlank(requestItem.SF_Lead_Opportunity_ID) &&!String.isBlank(requestItem.Sales_Manager_Email) && !String.isBlank(requestItem.Type_Of_Transfer) && !String.isBlank(requestItem.Initiator_Email ))
                        {
                            
                            if(mapofLeaduser.containsKey(requestItem.SF_Lead_Opportunity_ID)||oppMap.containsKey(requestItem.SF_Lead_Opportunity_ID)|| mapofIMIds.containsKey(requestItem.SF_Lead_Opportunity_ID))
                            {
                                system.debug('id verified'+requestItem.SF_Lead_Opportunity_ID);
                                if(mapofshowroomuser.containsKey(requestItem.Sales_Manager_Email)|| mapOfUser.containsKey(requestItem.Sales_Manager_Email)|| 
                                   mapOfShowroomName.containskey(requestitem.Sales_Manager_Email) || (requestitem.Sales_Manager_Email).equals(Nimbus_offline_Email) || (requestitem.Sales_Manager_Email).equals(Nimbus_HL_Email) )
                                {
                                    system.debug('email prsent');
                                    if(requestItem.Type_Of_Transfer == GenericConstants.DOOWUP_TRANSFER)
                                    {
                                        if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.LEAD_ID))
                                        {
                                            System.debug('requestItem.Lead_Source '+ requestItem.Lead_Source);
                                            System.debug('leadSourceSet '+ leadSourceSet);
                                            if(leadSourceSet.contains(requestItem.Lead_Source))
                                            {
                                                
                                               	if(mapofshowroomuser.containsKey(requestItem.Sales_Manager_Email))
                                                {
                                                    String role = mapofshowroomuser.get(requestItem.Sales_Manager_Email).Role__c;
                                                    system.debug('role'+ role);
                                                    
                                                    
                                                    if(role == GenericConstants.ROLE_ProductConsultant||role == GenericConstants.Doowup_PreSales_Role || role == GenericConstants.Inside_Sales_Team_Agent ||  role == GenericConstants.ROLE_TeleCallerAgent)
                                                    {
                                                        try{
                                                            
                                                            system.debug('listOfLeadQueried');
                                                            if(leadMap.containsKey(requestItem.SF_Lead_Opportunity_ID))
                                                            {
                                                                system.Debug('doowup');
                                                                email =leadMap.get(requestItem.SF_Lead_Opportunity_ID).email;
                                                                phone =leadMap.get(requestItem.SF_Lead_Opportunity_ID).phone;
                                                                system.debug('email'+email);
                                                                system.debug('phone'+phone);
                                                                if((!excludedEMailSet.contains(email)||!excludedPhoneSet.contains(phone))  && (mapofdoowupLead.containskey(email)||mapofdoowupLead.containskey(phone)))
                                                                {
                                                                    system.debug('email present');
                                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                                    respresult.Status = 'FAILURE';
                                                                    respresult.Message ='Doowup Lead already exist for this Homelane lead' ;
                                                                    listOfResponseWrapperResult.add(respresult);
                                                                    excludedEMailSet.add(email);
                                                                    excludedPhoneSet.add(phone);
                                                                    
                                                                }
                                                                else if((!excludedEMailSet.contains(email)||!excludedPhoneSet.contains(phone)) && (!mapofdoowupLead.containskey(email)||!mapofdoowupLead.containskey(phone)))
                                                                {
                                                                    system.debug('email not present');
                                                                    //email =leadMap.get(requestItem.SF_Lead_Opportunity_ID).email;
                                                                    Setup_Configuration__c setUpLead = createSetUpConfig(requestItem);
                                                                    
                                                                    setUpConfigList.add(setUpLead);
                                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                                    respresult.Status = 'SUCCESS';
                                                                    respresult.Message ='Doowup lead creation is Processed Successfully' ;
                                                                    listOfResponseWrapperResult.add(respresult);
                                                                    excludedEMailSet.add(email);
                                                                    excludedPhoneSet.add(phone);
                                                                    
                                                                    
                                                                }
                                                                else if(excludedEMailSet.contains(email)||excludedPhoneSet.contains(phone))
                                                                {
                                                                    system.Debug ('email check');
                                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                                    respresult.Status = 'FAILURE';
                                                                    respresult.Message ='Doowup lead with this email ID has been already processed.' ;
                                                                    listOfResponseWrapperResult.add(respresult);
                                                                }
                                                                
                                                                
                                                            }
                                                                     
                                                        }
                                                        catch(Exception e){
                                                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                            respresult.Status = 'Failure';
                                                            respresult.Message = e.getMessage() ;
                                                            listOfResponseWrapperResult.add(respresult);
                                                        }
                                                    }
                                                    else
                                                    {
                                                        ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                        respresult.Status = 'FAILURE';
                                                        respresult.Message ='Role of Sales Manager Should be Product Consultant/Doowup Presales/Inside Sales Agent/Tele Caller Agent for Doow up transfer' ;
                                                        listOfResponseWrapperResult.add(respresult);
                                                    }
                                                }
                                                
                                                else if(mapOfUser.containsKey(requestItem.Sales_Manager_Email) || mapOfShowroomName.containskey(requestItem.Sales_Manager_Email)|| 
                                                        (requestitem.Sales_Manager_Email).equals(Nimbus_offline_Email) || (requestitem.Sales_Manager_Email).equals(Nimbus_HL_Email))
                                                {
                                                    try
                                                    {
                                                        
                                                        system.debug('listOfLeadQueried');
                                                        if(leadMap.containsKey(requestItem.SF_Lead_Opportunity_ID))
                                                        {
                                                            system.Debug('doowup');
                                                            email =leadMap.get(requestItem.SF_Lead_Opportunity_ID).email;
                                                            phone =leadMap.get(requestItem.SF_Lead_Opportunity_ID).phone;
                                                            system.debug('email'+email);
                                                            system.debug('phone'+phone);
                                                            if((!excludedEMailSet.contains(email)||!excludedPhoneSet.contains(phone))  && (mapofdoowupLead.containskey(email)||mapofdoowupLead.containskey(phone)))
                                                            {
                                                                system.debug('email present');
                                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                                respresult.Status = 'FAILURE';
                                                                respresult.Message ='Doowup Lead already exist for this Homelane lead' ;
                                                                listOfResponseWrapperResult.add(respresult);
                                                                excludedEMailSet.add(email);
                                                                excludedPhoneSet.add(phone);
                                                                
                                                            }
                                                            else if((!excludedEMailSet.contains(email)||!excludedPhoneSet.contains(phone)) && (!mapofdoowupLead.containskey(email)||!mapofdoowupLead.containskey(phone))){
                                                                system.debug('email not present');
                                                                //email =leadMap.get(requestItem.SF_Lead_Opportunity_ID).email;
                                                                Setup_Configuration__c setUpLead = createSetUpConfig(requestItem);
                                                                setupLead.Lead__c = requestItem.SF_Lead_Opportunity_ID;
                                                                setupLead.Type_Of_Transfer__c='Doowup Transfer';
                                                                setupLead.Lead_Source__c=requestItem.Lead_Source;
                                                                setUpConfigList.add(setUpLead);
                                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                                respresult.Status = 'SUCCESS';
                                                                respresult.Message ='Doowup lead creation is Processed Successfully' ;
                                                                listOfResponseWrapperResult.add(respresult);
                                                                excludedEMailSet.add(email);
                                                                excludedPhoneSet.add(phone);
                                                                
                                                                
                                                            }
                                                            else if(excludedEMailSet.contains(email)||excludedPhoneSet.contains(phone))
                                                            {
                                                                system.Debug ('email check');
                                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                                respresult.Status = 'FAILURE';
                                                                respresult.Message ='Doowup lead with this email ID has been already processed.' ;
                                                                listOfResponseWrapperResult.add(respresult);
                                                            }
                                                        }
                                                        else
                                                        {
                                                            system.debug('maplead null');
                                                        }
                                                        
                                                    }
                                                    catch(Exception e)
                                                    {
                                                        ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                        respresult.Status = 'Failure';
                                                        respresult.Message = e.getMessage() ;
                                                        listOfResponseWrapperResult.add(respresult);
                                                    }
                                                }                                                  
                                                else
                                                {
                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                    respresult.Status = 'FAILURE';
                                                    respresult.Message ='WT- Agent email is not present' ;
                                                    listOfResponseWrapperResult.add(respresult);
                                                }
                                            }
                                            else
                                            {
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                respresult.Status = 'FAILURE';
                                                respresult.Message ='Please enter a valid lead Source .' ;
                                                listOfResponseWrapperResult.add(respresult);
                                            }                                           
                                            
                                        }
                                        
                                        else
                                        {
                                            System.debug('Doowup Tranfer are only applicable for leads whose id start from 00Q');
                                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                                            respresult.Status = 'FAILURE';
                                            respresult.Message = 'Doowup Tranfer are only applicable for leads whose id start from 00Q';
                                            listOfResponseWrapperResult.add(respresult); 
                                            
                                        }
                                        
                                    }
                                    else if(requestItem.Type_Of_Transfer == GenericConstants.IM_TRANSFER)
                                    {
                                        String role;
                                        if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.OPPORTUNITY_ID))
                                        {
                                            if(mapofshowroomuser.containsKey(requestItem.Sales_Manager_Email))
                                            {
                                                role = mapofshowroomuser.get(requestItem.Sales_Manager_Email).Role__c;
                                            }
                                            if(roleSet.contains(role)){
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                respresult.Status = 'FAILURE';
                                                respresult.Message = 'IM transfer is not Applicable for '+ mapofshowroomuser.get(requestItem.Sales_Manager_Email).Role__c+' role ';
                                                listOfResponseWrapperResult.add(respresult); 
                                            }else{
                                                Setup_Configuration__c setupOpportunity = createSetUpConfig(requestItem);
                                                //setupOpportunity.Name = requestItem.SF_Lead_Opportunity_ID;
                                                
                                                setupOpportunity.Opportunity__c = requestItem.SF_Lead_Opportunity_ID;
                                                setUpConfigList.add(setUpOpportunity);
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                respresult.Status = 'SUCCESS';
                                                respresult.Message ='The Opportunity record got processed successfully.' ;
                                                listOfResponseWrapperResult.add(respresult); 
                                                
                                            }
                                            
                                        }
                                        
                                        //isResponseSent = true;*/
                                        
                                        
                                        else if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.LEAD_ID)){
                                            
                                            
                                            if(mapofshowroomuser.containsKey(requestItem.Sales_Manager_Email)){
                                                role = mapofshowroomuser.get(requestItem.Sales_Manager_Email).Role__c;
                                            }
                                            if(roleSet.contains(role)){
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                respresult.Status = 'FAILURE';
                                                respresult.Message = 'IM transfer is not Applicable for '+ mapofshowroomuser.get(requestItem.Sales_Manager_Email).Role__c+' role ';
                                                listOfResponseWrapperResult.add(respresult); 
                                            }
                                            
                                            else{
                                                Setup_Configuration__c setUpLead = createSetUpConfig(requestItem);
                                                
                                                setUpConfigList.add(setUpLead);
                                                system.Debug(setUpLead);
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                respresult.Status = 'SUCCESS';
                                                respresult.Message = 'The Lead record got processed successfully.';
                                                listOfResponseWrapperResult.add(respresult); 
                                            } 
                                            
                                        }
                                        
                                        
                                        //isResponseSent = true;
                                        
                                        
                                        else{
                                            //SF_Lead_Opportunity_ID Starts neither with 006 nor with 00Q then Error.
                                            System.debug('SF_Lead_Opportunity_ID Starts neither with 006 nor with 00Q. So it is not of a lead or an opportunity.');
                                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                                            respresult.Status = 'FAILURE';
                                            respresult.Message = 'SF_Lead_Opportunity_ID Starts neither with 006 nor with 00Q. So it is not of a lead or an opportunity.';
                                            listOfResponseWrapperResult.add(respresult); 
                                            
                                            
                                        }
                                        
                                    }                                    
                                    else if(requestItem.Type_Of_Transfer == GenericConstants.FREELANCER_TRANSFER){
                                        
                                        if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.LEAD_ID))
                                        {
                                            String role = mapofshowroomuser.get(requestItem.Sales_Manager_Email).Role__c;
                                            system.debug('role'+ role);
                                            if(role ==GenericConstants.ROLE_PreSalesFreelancer){
                                                Setup_Configuration__c setUpLeadFreelancer = createSetUpConfig(requestItem);
                                                
                                                setUpConfigList.add(setUpLeadFreelancer);
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();  
                                                respresult.status = 'SUCCESS';
                                                respresult.Message = 'The Lead record got processed successfully.';
                                                listOfResponseWrapperResult.add(respresult); 
                                            }else{
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();  
                                                respresult.status = 'FAILURE';
                                                respresult.Message = 'The role of showroom user is not Pre-sales freelancer';
                                                listOfResponseWrapperResult.add(respresult); 
                                            }
                                            
                                        }
                                        else
                                        {
                                            System.debug('Freelancer Tranfer are only applicable for leads whose id start from 00Q');
                                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                                            respresult.Status = 'FAILURE';
                                            respresult.Message = 'Freelancer Tranfer are only applicable for leads whose id start from 00Q';
                                            listOfResponseWrapperResult.add(respresult); 
                                            
                                        }
                                        
                                    }
                                    else if(requestItem.Type_Of_Transfer == GenericConstants.TELECALLER_TRANSFER){
                                        
                                        if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.LEAD_ID)){
                                          //  if( mapofLeaduser.get(requestItem.SF_Lead_Opportunity_ID).Brand__c!= GenericConstants.LEAD_DOOWUP)
                                          //  {
                                                String role = mapofshowroomuser.get(requestItem.Sales_Manager_Email).Role__c;
                                                system.debug('role'+ role);
                                                if(role ==GenericConstants.ROLE_TeleCallerAgent){
                                                    Setup_Configuration__c setUpLeadTeleCaller = createSetUpConfig(requestItem);
                                                    
                                                    setUpConfigList.add(setUpLeadTeleCaller);
                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();  
                                                    respresult.status = 'SUCCESS';
                                                    respresult.Message = 'The Lead record got processed successfully.';
                                                    listOfResponseWrapperResult.add(respresult);
                                                }else{
                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();  
                                                    respresult.status = 'FAILURE';
                                                    respresult.Message = 'The role of Salesmanager is not Tele caller Agent';
                                                    listOfResponseWrapperResult.add(respresult);
                                                } 
                                         //   }
                                        /*    else{
                                                System.debug('Telecaller Transfer are only applicable for Homelane leads');
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                respresult.Status = 'FAILURE';
                                                respresult.Message = 'Telecaller Transfer are only applicable for Homelane leads';
                                                listOfResponseWrapperResult.add(respresult); 
                                            }*/
                                            
                                        }else{
                                            System.debug('Telecaller Transfer are only applicable for leads whose id start from 00Q');
                                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                                            respresult.Status = 'FAILURE';
                                            respresult.Message = 'Telecaller Transfer are only applicable for leads whose id start from 00Q';
                                            listOfResponseWrapperResult.add(respresult); 
                                            
                                        }
                                        
                                    }
                                    else if(nimbusTransferSet.contains(requestItem.Type_Of_Transfer))
                                    {
                                        if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.LEAD_ID))
                                        {
                                            //List<lead> ldList = [Select id,Nimbus_Status__c from Lead where id =:requestItem.SF_Lead_Opportunity_ID];
                                            
                                           /* if(mapofLeaduser.get(requestItem.SF_Lead_Opportunity_ID).Nimbus_Status__c == GenericConstants.SENT_TO_NIMBUS)
                                            {
                                                system.debug('Sent to Nimbus');
                                                system.debug('The Lead is already sent to Nimbus');
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();  
                                                respresult.status = 'FAILURE';
                                                respresult.Message = 'The Lead is already sent to Nimbus';
                                                listOfResponseWrapperResult.add(respresult);
                                            }
                                            else
                                            { */  
                                            	system.debug('mapofLeaduser.get(requestItem.SF_Lead_Opportunity_ID).Nimbus_Status__c '+mapofLeaduser.get(requestItem.SF_Lead_Opportunity_ID).Nimbus_Status__c);
                                                Setup_Configuration__c setUpLeadTeleCaller = createSetUpConfig(requestItem);
                                                system.debug('setUpLeadTeleCaller '+setUpLeadTeleCaller);
                                                setUpConfigList.add(setUpLeadTeleCaller);
                                            	system.debug('setUpConfigList '+setUpConfigList);
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();  
                                                respresult.status = 'SUCCESS';
                                                respresult.Message = 'The Lead record got processed successfully.';                                             	
                                                listOfResponseWrapperResult.add(respresult);
                                            //}
                                        }
                                        else
                                        {
                                            System.debug('Nimbus Transfer are only applicable for leads whose id start from 00Q');
                                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                                            respresult.Status = 'FAILURE';
                                            respresult.Message = 'Nimbus Transfer are only applicable for leads whose id start from 00Q';
                                            listOfResponseWrapperResult.add(respresult);                                             
                                        }
                                    }
                                    
                                    else if(requestItem.Type_Of_Transfer == GenericConstants.Nimbus_Doowup_Opp_Transfer)
                                    {
                                        	if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.OPPORTUNITY_ID))
                                        	{
                                            
                                            		try
                                                	{                                                            
                                                            system.debug('listOfOppQueried');
                                                            if(oppMap.containsKey(requestItem.SF_Lead_Opportunity_ID))
                                                            {
                                                                system.Debug('Transfer Lead Created from Opportunity to Doowup opp Campaign');
                                                                opp_email =oppMap.get(requestItem.SF_Lead_Opportunity_ID).Email_For_Communication__c;
                                                                opp_phone =oppMap.get(requestItem.SF_Lead_Opportunity_ID).Customer_phone_number__c;
                                                                system.debug('opp_email'+opp_email);
                                                                system.debug('opp_phone'+opp_phone);
                                                                if((!oppExcludedEmailSet.contains(opp_email)||!oppExcludedPhoneSet.contains(opp_phone))  && 
                                                                   (mapofdoowupLeadFromOpportunity.containskey(opp_email)||mapofdoowupLeadFromOpportunity.containskey(opp_phone)))
                                                                {
                                                                    system.debug('email/phone present');
                                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                                    respresult.Status = 'FAILURE';
                                                                    respresult.Message ='Doowup Lead already exist for this Opportunity' ;
                                                                    listOfResponseWrapperResult.add(respresult);
                                                                    oppExcludedEmailSet.add(opp_email);
                                                                    oppExcludedPhoneSet.add(opp_phone);                                                                    
                                                                }
                                                                else if((!oppExcludedEmailSet.contains(opp_email)||!oppExcludedPhoneSet.contains(opp_phone)) && 
                                                                        (!mapofdoowupLeadFromOpportunity.containskey(opp_email)||!mapofdoowupLeadFromOpportunity.containskey(opp_phone)))
                                                                {
                                                                    system.debug('email not present');
                                                                    system.debug('Opportunity for Nimbus_Doowup_Opp_Transfer');
                                                                    Setup_Configuration__c setUpLead = createSetUpConfig(requestItem);
                                                                    
                                                                    setUpConfigList.add(setUpLead);
                                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                                    respresult.Status = 'SUCCESS';
                                                                    respresult.Message ='The Opportunity record got processed successfully.' ;
                                                                    listOfResponseWrapperResult.add(respresult);
                                                                    oppExcludedEmailSet.add(opp_email);
                                                                    oppExcludedPhoneSet.add(opp_phone);    
                                                                }
                                                                else if(oppExcludedEmailSet.contains(opp_email)||oppExcludedPhoneSet.contains(opp_phone))
                                                                {
                                                                    system.Debug ('email check');
                                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                                    respresult.Status = 'FAILURE';
                                                                    respresult.Message ='Doowup lead with this email ID has been already processed.' ;
                                                                    listOfResponseWrapperResult.add(respresult);
                                                                }
                                                            }
                                                                     
                                                        }
                                                        catch(Exception e)
                                                        {
                                                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                            respresult.Status = 'Failure';
                                                            respresult.Message = e.getMessage() ;
                                                            listOfResponseWrapperResult.add(respresult);
                                                        }                                                                                     
                                        	}
                                        	else
                                        	{
                                            	System.debug('Nimbus Doowup Opp Transfer are only applicable for Opportunity whose id start from 006');
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                respresult.Status = 'FAILURE';
                                                respresult.Message = 'Nimbus Doowup Opp Transfer is only applicable for Opportunity whose id start from 006';
                                                listOfResponseWrapperResult.add(respresult);  
                                        	}
                                    }
                                    
                                    else if(requestItem.Type_Of_Transfer == GenericConstants.Doowup_Presales_Transfer)
                                    {
                                        if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.LEAD_ID))
                                        {
                                            if( mapofLeaduser.get(requestItem.SF_Lead_Opportunity_ID).Brand__c=='Doowup')
                                            {
                                                if(mapofshowroomuser.containsKey(requestItem.Sales_Manager_Email))
                                                {
                                                    String role = mapofshowroomuser.get(requestItem.Sales_Manager_Email).Role__c;
                                                    system.debug('role'+ role);
                                                    if(role==genericConstants.Doowup_PreSales_Role)
                                                    {
                                                        Setup_Configuration__c setUpLead = createSetUpConfig(requestItem);                                                        
                                                        setUpConfigList.add(setUpLead);
                                                        ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                        respresult.Status = 'SUCCESS';
                                                        respresult.Message = 'The Lead record got processed successfully.';
                                                        listOfResponseWrapperResult.add(respresult); 
                                                    }
                                                    else
                                                    {
                                                        System.debug('Role of IM should be product consultant for Doowup Brand leads ');
                                                        ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                        respresult.Status = 'FAILURE';
                                                        respresult.Message = 'Role of IM should be Doowup Presales for Doowup Brand leads';
                                                        listOfResponseWrapperResult.add(respresult);   
                                                        
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                System.debug('Role of IM should be product consultant for Doowup Brand leads ');
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                respresult.Status = 'FAILURE';
                                                respresult.Message = 'Doowup Presales Transfer only applicable for Doowup lead';
                                                listOfResponseWrapperResult.add(respresult);
                                            }
                                            
                                        }
                                        else
                                        {
                                            System.debug('Presales Transfer are only applicable for leads whose id start from 00Q');
                                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                                            respresult.Status = 'FAILURE';
                                            respresult.Message = 'Doowup Presales Transfer are only applicable for leads whose id start from 00Q';
                                            listOfResponseWrapperResult.add(respresult); 
                                            
                                        }
                                    }
                                    else if(requestItem.Type_Of_Transfer == GenericConstants.Offline_Relanded_Transfer)
                                    {
                                        if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.LEAD_ID))
                                        {
                                           // if(deadLeadSet.contains(requestItem.SF_Lead_Opportunity_ID))
                                           // {
                                                Setup_Configuration__c setUpLead = createSetUpConfig(requestItem);
                                                
                                                setUpConfigList.add(setUpLead);
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                respresult.Status = 'SUCCESS';
                                                respresult.Message = 'The Lead record got processed successfully.';
                                                listOfResponseWrapperResult.add(respresult);
                                          /*  }
                                            else
                                            {
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                respresult.Status = 'FAILURE';
                                                respresult.Message = 'Offline Relanded Transfer is only applicable for Dead/Not actively pursued lead status';
                                                listOfResponseWrapperResult.add(respresult);  
                                            }*/
                                        }
                                        else{
                                            System.debug('Offline relanded Transfer are only applicable for leads whose id start from 00Q');
                                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                                            respresult.Status = 'FAILURE';
                                            respresult.Message = 'Offline Relanded Transfer are only applicable for leads whose id start from 00Q';
                                            listOfResponseWrapperResult.add(respresult); 
                                        }
                                    }
                                    else if(requestItem.Type_Of_Transfer == GenericConstants.IM_Classification_Transfer){
                                        if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.Showroom_user_Id))
                                        {
                                            if(!imClassSet.contains(requestItem.Lead_Source))
                                            {
                                                requestItem.Lead_Source=GenericConstants.IM_Class_Bronze; 
                                            } 
                                            
                                            Setup_Configuration__c setUpIM = createSetUpConfig(requestItem);
                                            setUpConfigList.add(setUpIM);
                                            
                                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                                            respresult.Status = 'SUCCESS';
                                            respresult.Message = 'The User record got processed successfully.';
                                            listOfResponseWrapperResult.add(respresult); 
                                            
                                        }
                                        else
                                        {
                                            System.debug('IM Classification Transfer are only applicable for ShowroomUser whose id start from a1F');
                                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                                            respresult.Status = 'FAILURE';
                                            respresult.Message = 'IM Classification Transfer are only applicable for ShowroomUser whose id start from a1F';
                                            listOfResponseWrapperResult.add(respresult); 
                                        }
                                    }
                                    else if(requestItem.Type_Of_Transfer == GenericConstants.Inside_Sales_Transfer){
                                        if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.LEAD_ID))
                                        {
                                            
                                            if(mapofshowroomuser.containsKey(requestItem.Sales_Manager_Email))
                                            {
                                                String role = mapofshowroomuser.get(requestItem.Sales_Manager_Email).Role__c;
                                                system.debug('role'+ role);
                                                if(role==genericConstants.Inside_Sales_Team_Agent)
                                                {
                                                    Setup_Configuration__c setUpLead = createSetUpConfig(requestItem);
                                                    setUpConfigList.add(setUpLead);
                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                    respresult.Status = 'SUCCESS';
                                                    respresult.Message = 'The Lead record got processed successfully.';
                                                    listOfResponseWrapperResult.add(respresult); 
                                                }
                                                else
                                                {
                                                    System.debug('Role of IM should be product consultant for Doowup Brand leads ');
                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                    respresult.Status = 'FAILURE';
                                                    respresult.Message = 'Role of IM should be Inside Sales agent for Inside Sales Transfer';
                                                    listOfResponseWrapperResult.add(respresult);                                                       
                                                }
                                            }
                                            
                                        }
                                        else{
                                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                                            respresult.Status = 'FAILURE';
                                            respresult.Message = 'Inside Sales Transfer is only applicable to leads';
                                            listOfResponseWrapperResult.add(respresult); 
                                        }
                                    }
                                    
                                                                   
                                    else if(requestItem.Type_Of_Transfer == GenericConstants.Cubico_Transfer)
                                    {
                                        if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.LEAD_ID))
                                        {  
                                            Id accId =null;
                                            if(leadMap.containsKey(requestItem.SF_Lead_Opportunity_ID))
                                            {
                                                accId = leadMap.get(requestItem.SF_Lead_Opportunity_ID).Account__c;
                                                System.debug('accId'+accId);
                                            }
                                            
                                            if(cubicoAccMap.containsKey(accId) && !excludeAccountIdSet.contains(accId))
                                            {
   													system.debug('Cubico lead Account present');
                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                    respresult.Status = 'FAILURE';
                                                    respresult.Message ='Cubico Lead already exist for this Homelane lead' ;
                                                    listOfResponseWrapperResult.add(respresult);
                                                    excludeAccountIdSet.add(accId);
                                            }
                                            else if(!cubicoAccMap.containsKey(accId) && !excludeAccountIdSet.contains(accId))
                                            {                                                
                                                    Setup_Configuration__c setUpLead = createSetUpConfig(requestItem);
                                                    setUpConfigList.add(setUpLead);
                                                    System.debug('Setup Config Record'+setUpLead);
                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                    respresult.Status = 'SUCCESS';
                                                    respresult.Message = 'The Lead record got processed successfully.';
                                                    listOfResponseWrapperResult.add(respresult); 
                                                    excludeAccountIdSet.add(accId);
                                            }
                                            else if(excludeAccountIdSet.contains(accId))
                                            {
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                respresult.Status = 'FAILURE';
                                                respresult.Message = 'Cubico Lead is already processed under this account';
                                                listOfResponseWrapperResult.add(respresult);  
                                            }
                                            
                                        }
                                        else
                                        {
                                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                                            respresult.Status = 'FAILURE';
                                            respresult.Message = 'Cubico Transfer is only applicable to leads';
                                            listOfResponseWrapperResult.add(respresult); 
                                        }
                                    }
                                    
                             /*       else if(requestItem.Type_Of_Transfer == GenericConstants.Wrapzap_Transfer)
                                    {
                                        if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.LEAD_ID))
                                        {  
                                            Id accId =null;
                                            if(leadMap.containsKey(requestItem.SF_Lead_Opportunity_ID))
                                            {
                                                accId = leadMap.get(requestItem.SF_Lead_Opportunity_ID).Account__c;
                                                System.debug('accId'+accId);
                                            }
                                            
                                            if(wrapzapAccMap.containsKey(accId) && !excludeAccountIdSet.contains(accId))
                                            {
   													system.debug('Wrapzap lead Account present');
                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                    respresult.Status = 'FAILURE';
                                                    respresult.Message ='Wrapzap Lead already exist for this Homelane lead' ;
                                                    listOfResponseWrapperResult.add(respresult);
                                                    excludeAccountIdSet.add(accId);
                                            }
                                            else if(!wrapzapAccMap.containsKey(accId) && !excludeAccountIdSet.contains(accId))
                                            {                                                
                                                    Setup_Configuration__c setUpLead = createSetUpConfig(requestItem);
                                                    setUpConfigList.add(setUpLead);
                                                    System.debug('Setup Config Record'+setUpLead);
                                                    ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                    respresult.Status = 'SUCCESS';
                                                    respresult.Message = 'The Lead record got processed successfully.';
                                                    listOfResponseWrapperResult.add(respresult); 
                                                    excludeAccountIdSet.add(accId);
                                            }
                                            else if(excludeAccountIdSet.contains(accId))
                                            {
                                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                                respresult.Status = 'FAILURE';
                                                respresult.Message = 'Wrapzap Lead is already processed under this account';
                                                listOfResponseWrapperResult.add(respresult);  
                                            }                                            
                                        }
                                        
                                        else
                                        {
                                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                                            respresult.Status = 'FAILURE';
                                            respresult.Message = 'Wrapzap Transfer is only applicable to leads';
                                            listOfResponseWrapperResult.add(respresult); 
                                        }
                                    }*/
                                    
                                    else{
                                        System.debug('Value of Type_Of_Transfer is not supported.');
                                        
                                        ResponseWrapperResult respresult = new ResponseWrapperResult();
                                        respresult.Status = 'FAILURE';
                                        respresult.Message = 'Value of Type_Of_Transfer is not IM Transfer/Freelancer Transfer/Telecaller Transfer/Nimbus/Doowup/Doowup Presales. Currently only these value are supported.';
                                        listOfResponseWrapperResult.add(respresult); 
                                        system.debug('respresult'+respresult);
                                        //isResponseSent = true;
                                    }
                                }
                                else
                                {
                                    ResponseWrapperResult respresult = new ResponseWrapperResult();
                                    respresult.Status = 'FAILURE';
                                    respresult.Message = ' Email field data is not present';
                                    listOfResponseWrapperResult.add(respresult); 
                                }
                                
                            }else{
                                ResponseWrapperResult respresult = new ResponseWrapperResult();
                                respresult.Status = 'FAILURE';
                                respresult.Message ='Lead Or Opportunity or IM id  is not a valid id '+ requestItem.SF_Lead_Opportunity_ID ;
                                listOfResponseWrapperResult.add(respresult);
                            }
                            
                            
                            
                        }
                        
                        else
                        {
                            System.debug('Either SF_Lead_Opportunity_ID,Sales_Manager_Email,Initiator_Email or Type_Of_Transfer is blank.');
                            
                            ResponseWrapperResult respresult = new ResponseWrapperResult();
                            respresult.Status = 'FAILURE';
                            respresult.Message = 'Either SF_Lead_Opportunity_ID,Sales_Manager_Email,Initiator_Email or Type_Of_Transfer is blank.';
                            listOfResponseWrapperResult.add(respresult); 
                        }
                        
                        
                        system.debug('setUpConfigList '+setUpConfigList);
                        
                        
                        
                        
                    }
                             
                    if(!setUpConfigList.isEmpty()){
                        system.debug('setUpConfigList '+setUpConfigList);
                        insert setUpConfigList;
                        
                        
                        Batch_Processing_Check__c batchInProgressCheck = Batch_Processing_Check__c.getInstance(GenericConstants.IM_TRANSFER_CHECK);
                        system.debug(' batchInProgressCheck.IsExecuting__c'+batchInProgressCheck.IsExecuting__c );
                        try{
                            if(!batchInProgressCheck.IsExecuting__c){
                                LeadAndOpportunityTransferBatch leadOppBatch = new LeadAndOpportunityTransferBatch();
                                Database.executeBatch(leadOppBatch,1);
                                batchInProgressCheck.IsExecuting__c = true;
                                update batchInProgressCheck;
                            }  
                        }catch(Exception e){
                            system.debug('-------exp finish-----------'+e.getmessage());
                        }
                        
                        respWrap.Status = 'SUCCESS';
                        respWrap.Message = 'The record got processed successfully.';
                        respWrap.result = listOfResponseWrapperResult;
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
                    }
                    else{
                        respWrap.Status = 'SUCCESS';
                        respWrap.Message = ' Set up record  list is empty';
                        respWrap.result = listOfResponseWrapperResult;
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
                    }
                }
                
                else{
                    System.debug('Request Wrapper list is Empty');
                    respWrap.Status = 'FAILURE';
                    respWrap.Message = 'Request Wrapper list is empty';
                    respWrap.result = listOfResponseWrapperResult;
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
                    
                    
                }
            }
            
            else{
                System.debug('InputData is blank or empty.');
                respWrap.Status = 'FAILURE';
                respWrap.Message = 'InputData string in the request is blank or empty.';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
                
            }
            
            
            
        }catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            respWrap.Status = 'SUCCESS';
            ResponseWrapperResult respresult = new ResponseWrapperResult();
            respresult.Status = 'FAILURE';
            respresult.Message = e.getMessage();
            listOfResponseWrapperResult.add(respresult); 
            respWrap.result = listOfResponseWrapperResult;
            respWrap.Message = 'Exception in Salesforce. Excption Message: '+e.getMessage() +' .Stack Trace:'+e.getStackTraceString();
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
            //isResponseSent = true;
            Logger.log('Exception','LeadAndOpportunityTransferAPI Class','leadOrOpportunityUpdate Method',e.getMessage(),e.getStackTraceString(),null);
            
        }
    }
    Public class RequestWrapper{
        Public String SF_Lead_Opportunity_ID;
        Public String Sales_Manager_Email;
        Public String Type_Of_Transfer;
        public String Initiator_Email;
        public String Lead_Source;
        
    }
    Public class ResponseWrapper{
        Public String Message;
        Public String Status;
        Public List<ResponseWrapperResult> result;
    }
    Public class ResponseWrapperResult {
        Public String Message;
        Public String Status;
        
    }
    public static Setup_Configuration__c createSetUpConfig(RequestWrapper requestItem)
    {
        Id recordTypeId = Schema.SObjectType.Setup_Configuration__c.getRecordTypeInfosByDeveloperName().get(GenericConstants.LEAD_OPPORTUNITY_TRANSFER).getRecordTypeId();
        system.debug('recId '+recordTypeId);
        Setup_Configuration__c setUpUpdate = new  Setup_Configuration__c();
        //setUpUpdate.Name = requestItem.SF_Lead_Opportunity_ID;
        setUpUpdate.Initiator_Email__c = requestItem.Initiator_Email;
        setUpUpdate.Sales_Manager_Email__c = requestItem.Sales_Manager_Email;
        setUpUpdate.Operation_Status__c =  GenericConstants.SETUP_CONFIG_OPEN_STATUS;
        setUpUpdate.RecordTypeId = recordTypeId;
        setUpUpdate.Request_JSON__c = String.valueOf(requestItem);
        
        if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.LEAD_ID))
        {
            setUpUpdate.Lead__c= requestItem.SF_Lead_Opportunity_ID; 
        }
        else if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.OPPORTUNITY_ID))
        {
            setUpUpdate.Opportunity__c=  requestItem.SF_Lead_Opportunity_ID;
        }
        else if(requestItem.SF_Lead_Opportunity_ID.startsWithIgnoreCase(GenericConstants.Showroom_user_Id))
        {
            setUpUpdate.Showroom_User__c = requestItem.SF_Lead_Opportunity_ID;
        }
        
        setUpUpdate.Type_Of_Transfer__c=requestItem.Type_Of_Transfer;
        setUpUpdate.Lead_Source__c=requestItem.Lead_Source;
        return setUpUpdate;
    }
    
}