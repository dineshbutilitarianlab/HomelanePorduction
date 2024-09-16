Public class OpportunityTriggerHandler{
    
    
    /* @Description  : This Method is called from before insert trigger of opportunity and update the 
*                  Customer_Email__c,Customer_Phone_Lead_Square__c from account(Person Account)
*                  Since we can't map phone,email from lead to opportunity
* @param         : list<Opportunity> opplist

*=====================================================================================================
**/
    Public static Boolean rosterEmailsSent = false;
    Public static void updateCustomerEmail_Phone(List<Opportunity > opplist){
        try{
            System.debug('updateCustomerEmail method called');
            map < id, Account > mapAccountDetails = new map < id, Account > ();
            map < id, Opportunity > mapAccountOpp = new map < id, Opportunity > ();
            
            //Check if opplist is not Empty
            if(!opplist.isEmpty()){
                for(Opportunity Opp:opplist){
                    if (opp.AccountId != NULL){
                        mapAccountOpp.put(opp.AccountId, opp); 
                    }
                }
            }
            
            system.debug('%%%%%mapAccountOpp%%%'+mapAccountOpp);
            //If account is associated with the Opportunity get the email and Phone
            if(!mapAccountOpp.isEmpty()){
                for (Account objAcc: [SELECT id, PersonEmail,Phone from Account Where id In: mapAccountOpp.keyset()]) {
                    mapAccountDetails.put(objAcc.id,objAcc);
                }
            }
            
            system.debug('%%%%%mapAccountDetails%%%'+mapAccountDetails);
            
            //If account list is not empty copy the email and Phone
            if(!mapAccountDetails.isEmpty()){
                for(Opportunity opp: mapAccountOpp.values()){
                    if(mapAccountDetails.containskey(opp.AccountId)){
                        opp.Customer_Email__c = String.IsNotBlank(mapAccountDetails.get(opp.AccountId).PersonEmail)?mapAccountDetails.get(opp.AccountId).PersonEmail:NULL;
                        opp.Customer_Phone_Lead_Square__c = String.IsNotBlank(mapAccountDetails.get(opp.AccountId).Phone)?mapAccountDetails.get(opp.AccountId).Phone:NULL;
                    }
                }
            } 
        }
        catch(Exception e){Logger.log('Exception','OpportunityTriggerHandler','updateCustomerEmail_Phone',e.getMessage(),e.getStackTraceString(),null);}        
    }  
    
    /* @Description  : This Method is called from after Update trigger check.
*                  Check if the Email Is Updated if Yes, Send the data to future class to make call out
* @param         : Map<id,Opportunity> trigger.newMap ,map<id,Opportunity> trigger.oldMap
*=====================================================================================================
**/
    //This should be commented as the communication will happen through the Order specific unique id and 
    //not the customer email id going forward as per the Order Hierarchy implementation.
    /*Public static void IsEmailUpdated(map<id,Opportunity> newMap,map<id,Opportunity> oldMap){
system.debug('IsEmailUpdated--->');
try{
Map<String,String> mapNewOldEmails = new Map<String,String>();

//Check if opplist is not Empty
if( !newMap.isEmpty() && !oldMap.isEmpty()){
for(Opportunity Opp:newMap.values()){
if (String.isNotBlank(opp.Customer_Email__c)){
if(Opp.Customer_Email__c != oldMap.get(opp.id).Customer_Email__c ){
mapNewOldEmails.put(oldMap.get(opp.id).Customer_Email__c,opp.Customer_Email__c);
}
}
}
}

if(!mapNewOldEmails .isEmpty()){
if( System.isBatch() && Limits.getQueueableJobs() == 0) {
Rest_ChangeCustomerEmail.customeremailChange(mapNewOldEmails);
}
else if(System.isBatch()==false){
Rest_ChangeCustomerEmail.customeremailChange(mapNewOldEmails);
}
else{
//limit as exceeded don't call API 
}
}
}
catch(Exception e){Logger.log('Exception','OpportunityTriggerHandler','IsEmailUpdated',e.getMessage(),e.getStackTraceString(),null);}        
}   */
    /* @Description  : This Method is called from before Update trigger 
*                  Customer Emai for Communication will get update when Customer_Email_c
*                  is updated.(Not sure why this Used)
* @param         : Map<id,Opportunity> trigger.newMap ,map<id,Opportunity> trigger.oldMap
*=====================================================================================================
**/
    Public static void UpdateEmailForCommunication(Map<Id,Opportunity> oldMap,Map<Id,Opportunity> newMap){ 
        try{
            if(!oldMap.isEmpty() && !newMap.isEmpty()){ 
                for (Opportunity newopprecord: newMap.values()){
                    if(newopprecord.Customer_Email__c != oldMap.get(newopprecord.id).Customer_Email__c){
                        if(newopprecord.Update_Email_Communication__c == true && newopprecord.Customer_Email__c.Contains('duplicate')){
                            Integer startIndex = newopprecord.Customer_Email__c.indexOf('_');
                            String strEmail = newopprecord.Customer_Email__c.subString(startIndex+1,newopprecord.Customer_Email__c.length());
                            newopprecord.Email_For_Communication__c = strEmail;             
                        }else{
                            newopprecord.Email_For_Communication__c = newopprecord.Customer_Email__c; 
                        }
                    }       
                }
            }
        }
        catch(Exception e){Logger.log('Exception','OpportunityTriggerHandler','UpdateEmailForCommunication',e.getMessage(),e.getStackTraceString(),null);}        
    }
    
    /*******************************************************************
// function to update the DP information on IQ by hitting the IQ API.
*********************************************************************/
    Public Static void updateDP(List<Opportunity> newOpptyList, Map<Id,Opportunity> oldOpptyMap){ 
        Map<Opportunity,String> mapOpportunity_OldDPEmail = new Map<Opportunity,String>();
        try{
            for(Opportunity newOpp: newOpptyList){
                if(newopp.Interior_Design_Partner__c != oldOpptyMap.get(newOpp.id).Interior_Design_Partner__c){
                    
                    mapOpportunity_OldDPEmail.put(newOpp,oldOpptyMap.get(newOpp.id).Design_Partner_Email__c);
                }
            }
            system.debug('---getLimitQueueableJobs()---'+limits.getLimitQueueableJobs()+'---Limits.getQueueableJobs()--'+Limits.getQueueableJobs());
            if(!mapOpportunity_OldDPEmail.isEmpty()){
                for(Opportunity Opp:mapOpportunity_OldDPEmail.keySet()){
                    if(Limits.getQueueableJobs()<Limits.getLimitQueueableJobs()){
                        System.enqueueJob(new ChangeDPRestAPI(Opp,null,mapOpportunity_OldDPEmail.get(Opp)));
                    }
                }
            }
        }
        catch(Exception e){
            Logger.log('Exception','OpportunityTriggerHandler','updateDP',e.getMessage(),e.getStackTraceString(),NULL);    
        }
    }
    
    /* @Description  : When Lead is converted to Opportunity if the First Name is not present 
*                  it is replaced with NULL this method remove 'NULL ' from Opportunity Name 
*                  during the insertion 
* @param         : List<Opportunity> trigger.new
*=====================================================================================================
**/
    
    Public Static void RemoveNullFromName(List<Opportunity> lstOpp){
        try{
            for(opportunity ObjOpp : lstOpp ){
                if(String.IsNotBlank(ObjOpp.Name)){
                    system.debug('ObjOpp.Name----->'+ObjOpp.Name);
                    if((ObjOpp.Name.containsIgnoreCase('null '))){
                        ObjOpp.Name = ObjOpp.Name.removeStartIgnoreCase('null ');
                    }
                    system.debug('ObjOpp.Name after Change----->'+ObjOpp.Name);
                }
            }
            
        }
        catch(Exception e){
            Logger.log('Exception','OpportunityTriggerHandler','RemoveNullFromName',e.getMessage(),e.getStackTraceString(),NULL);    
        }
    }
    
    /**
* @description || This method is to uncheck the Requested_Call_Back__c field in Opportunity when it is true and either of the description or follow up time changes
* @author Bharatesh Shetty | 2/25/2020 
* @param newOppList 
* @param oldOppsMap
* @return void 
**/
    Public Static void uncheckRequestedCallBack(List<Opportunity> newOppList, Map<Id,Opportunity> oldOppsMap){
        try{
            for(Opportunity op: newOppList){
                if(op.Requested_Call_Back__c && oldOppsMap.get(op.Id).Requested_Call_Back__c && (op.Follow_up_time__c != oldOppsMap.get(op.Id).Follow_up_time__c || op.Sales_Description__c != oldOppsMap.get(op.Id).Sales_Description__c)){
                    op.Requested_Call_Back__c = False;
                    System.debug('Requested_Call_Back__c Changed : '+op.Requested_Call_Back__c);
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','OpportunityTriggerHandler Class','uncheckRequestedCallBack Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    
    /*=================================================================================================== 
* @Description  : Send SMS when Opportunity is closed When order is closed (10% received) 
* @param         : trigger.new,trigger.OldMap 
*=====================================================================================================
**/
    
    Public static void sendOpportunityRelatedSMS(List <Opportunity> OpportunityrecordList, Map <Id,Opportunity> oldOpportunityMap) {
        try{
            list<String> lstOpportunity = new list<String>();
            if(!OpportunityrecordList.isEmpty() && !oldOpportunityMap.isEmpty()){
                for(Opportunity ObjOpp : OpportunityrecordList){
                    if(ObjOpp.Brand__c != 'Doowup'){
                     if(ObjOpp.Amount_Collected__c != NULL && String.isNotBlank(ObjOpp.Channel_Partner__c)){
                        system.debug('Integer.Valueof(oldOpportunityMap.get(ObjOpp.id).Amount_Collected__c)'+Integer.Valueof(oldOpportunityMap.get(ObjOpp.id).Amount_Collected__c));
                        if( Integer.Valueof(ObjOpp.Amount_Collected__c) > 48000 && (Integer.Valueof(oldOpportunityMap.get(ObjOpp.id).Amount_Collected__c) <= 48000 || oldOpportunityMap.get(ObjOpp.id).Amount_Collected__c == null )){
                            lstOpportunity.add(ObjOpp.id);
                        }
                    }   
                    }
                    
                }
            }
            system.debug('lstOpportunity--->'+lstOpportunity);
            if(!lstOpportunity.isEmpty()){
                SendOpportunitySMSController.getSMSTemplate(lstOpportunity,'Order Close');
            }
        }
        catch(Exception e){
        }  
    }
    
    Public Static void opptyChangeStage(List<Opportunity> newOpptyList, Map<Id,Opportunity> oldOpptyMap) {
        
        for (Opportunity oppty: newOpptyList) {
            if(oppty.StageName == 'Quote Required' && oppty.StageName != oldOpptyMap.get(oppty.id).StageName){
                oppty.Opportunity_Stage__c = 'Appointment Successful'; 
            }else if(oppty.StageName == 'Initial Quote Sent' && oppty.StageName != oldOpptyMap.get(oppty.id).StageName){
                oppty.Opportunity_Stage__c = 'Initial Quote Sent'; 
            }else if(oppty.Opportunity_Stage__c == 'IQ Follow up - Done' && oppty.Opportunity_Stage__c != oldOpptyMap.get(oppty.id).Opportunity_Stage__c){
                oppty.StageName = 'IQ Follow Up'; 
            }else if(oppty.Opportunity_Stage__c == 'Lost' && oppty.Opportunity_Stage__c != oldOpptyMap.get(oppty.id).Opportunity_Stage__c){
                oppty.StageName = 'Opportunity Lost'; 
            }
            
            if(oppty.SCVM_Incentive__c != null && oppty.SCVM_Incentive__c != oldOpptyMap.get(oppty.Id).SCVM_Incentive__c){
                String strMeetingDate = String.valueOf(Date.valueOf(oppty.Time_of_Actual_Appointment_Start__c));
                // Stopped as per the request from Roster team (Pavan)
                //SendFeedBackToRoasterAPI.SendDPIncentive(oppty.Customer_Email__c,oppty.Quote_Sent_DP__c,strMeetingDate,String.valueOf(oppty.SCVM_Incentive__c));
            }
        }
    }
    // This field EBP__c was introduced to calculate the New_Opportunity_Stage__c formula field during CORONA lockdowns.
    Public static void updateEBPApplicableCheckbox(List<Opportunity> newOpptyList,Map<Id,Opportunity> oldMap){ 
        try{
            if(!oldMap.isEmpty() && !newOpptyList.isEmpty()){ 
                Map<String,EBP_Showrooms__mdt> mapOfShowroomIdandEBPMdt = new Map<String,EBP_Showrooms__mdt>();
                for(EBP_Showrooms__mdt obj :[Select 
                                             id,End_Date__c,Showroom_Name__c,Showroom_SF_18_Digit_ID__c,Start_Date__c
                                             From EBP_Showrooms__mdt])
                {
                    mapOfShowroomIdandEBPMdt.put(obj.Showroom_SF_18_Digit_ID__c,obj);
                }
                System.debug('mapOfShowroomIdandEBPMdt: '+mapOfShowroomIdandEBPMdt);
                for (Opportunity newopprecord: newOpptyList){
                    /*System.debug('newopprecord.Order_Book_Date__c: '+newopprecord.Order_Book_Date__c);
System.debug('Old.Order_Book_Date__c: '+oldMap.get(newopprecord.id).Order_Book_Date__c);
System.debug('newopprecord.Appointment_Venue_Square__c: '+newopprecord.Appointment_Venue_Square__c);
System.debug('Old.Appointment_Venue_Square__c: '+oldMap.get(newopprecord.id).Appointment_Venue_Square__c);*/
                    if(newopprecord.Order_Book_Date__c != Null && newopprecord.Appointment_Venue_Square__c != Null && 
                       (newopprecord.Order_Book_Date__c != oldMap.get(newopprecord.id).Order_Book_Date__c || newopprecord.Appointment_Venue_Square__c != oldMap.get(newopprecord.id).Appointment_Venue_Square__c)){
                           if(!mapOfShowroomIdandEBPMdt.isEmpty()){
                               if(mapOfShowroomIdandEBPMdt.containsKey(newopprecord.Appointment_Venue_Square__c)){
                                   if(newopprecord.Order_Book_Date__c >= mapOfShowroomIdandEBPMdt.get(newopprecord.Appointment_Venue_Square__c).Start_Date__c && 
                                      newopprecord.Order_Book_Date__c <= mapOfShowroomIdandEBPMdt.get(newopprecord.Appointment_Venue_Square__c).End_Date__c){
                                          newopprecord.EBP__c = True;
                                          System.debug('newopprecord.EBP__c: '+newopprecord.EBP__c);
                                      }
                                   else{
                                       newopprecord.EBP__c = False;
                                       System.debug('Opp order book is not in the showroom EBP start and end date range.');
                                   }
                               }
                               else{
                                   newopprecord.EBP__c = False;
                                   System.debug('mapOfShowroomIdandEBPMdt does not contain this opps appointment venue square Id.');
                               }
                           }
                           else{
                               System.debug('mapOfShowroomIdandEBPMdt empty.');
                           }
                       }
                    else{
                        System.debug('Either order book date or showroom is null or not changed.');
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','OpportunityTriggerHandler','updateEBPApplicableCheckbox method',e.getMessage(),e.getStackTraceString(),null);
        }        
    }
    
    public static void afterInsert(Map<Id,Opportunity> mapOfOpportunity){
        OpportunityTriggerHelper.assignParentOpporutnityForSubOrders(mapOfOpportunity.keySet());
    }
    Public Static void handleOpportunityRosterEmails(List<Opportunity> newOppsList, Map<Id,Opportunity> oldOppsMap){
        try{
            System.debug('handleOpportunityRosterEmails method');
            Set<Id> showroomIdSet = new Set<Id>();
            Set<Id> channelPartnerIdSet = new Set<Id>();
            Map<Id,Master__c> mapOfShowroomIdAndShowroom = new Map<Id,Master__c>();
            Map<Id,Channel_Partner__c> mapOfChannelPartnerIdAndCP = new Map<Id,Channel_Partner__c>();
            List<String> listOfJSON = new List<String>();
            
            for(Opportunity oppty: newOppsList){
                if(oppty.Appointment_Venue_Square__c !=null){
                    showroomIdSet.add(oppty.Appointment_Venue_Square__c);
                }
                if(oppty.Channel_partner__C !=null){
                    channelPartnerIdSet.add(oppty.Channel_partner__C);
                }
            }
            if(!showroomIdSet.isEmpty()){
                mapOfShowroomIdAndShowroom = new Map<Id,Master__c>([Select id,Name,Street__c,Property_Locality__c,Property_City__c,Property_Postal_Code__c from Master__c where id=:showroomIdSet]);
            }
            if(!channelPartnerIdSet.isEmpty()){
                mapOfChannelPartnerIdAndCP = new Map<Id,Channel_partner__C>([Select id,Name from Channel_partner__C where id=:channelPartnerIdSet]);
            }
             for (Opportunity oppty: newOppsList) {
                 if(oppty.Brand__c!= 'Doowup'){
                     if(oppty.X40_Payment_Rec_Date__c != NULL && oppty.X40_Payment_Rec_Date__c != oldOppsMap.get(oppty.id).X40_Payment_Rec_Date__c
                   && (oppty.LeadSource.EqualsIgnoreCase('Broker/Channel Partner') || oppty.LeadSource.EqualsIgnoreCase('Ambassador'))){
                       String subject = 'Blitz customer '+oppty.Customer_ID__c+' has completed 40% payment.';
                       Map<String,String> toEmailMap = new Map<String,String>();
                       toEmailMap.put('name','Arun Yadav');
                       toEmailMap.put('email','arun.y@homelane.com ');

                       List<Map<String,String>> template_contentList = new List<Map<String,String>>();
                       
                       Map<String,String> template_contentMap1 = new Map<String,String>();
                       template_contentMap1.put('name','customer_name');
                       template_contentMap1.put('content',oppty.Full_Name__c);
                       template_contentList.add(template_contentMap1);
                       
                       Map<String,String> template_contentMap2 = new Map<String,String>();
                       template_contentMap2.put('name','customer_id');
                       template_contentMap2.put('content',oppty.customer_id__c);
                       template_contentList.add(template_contentMap2);
                       
                       Map<String,String> template_contentMap3 = new Map<String,String>();
                       template_contentMap3.put('name','payment_date');
                       template_contentMap3.put('content',String.valueOf(oppty.X40_Payment_Rec_Date__c));
                       template_contentList.add(template_contentMap3);
                       
                       Map<String,String> template_contentMap4 = new Map<String,String>();
                       template_contentMap4.put('name','showroom_name');
                       template_contentMap4.put('content',mapOfShowroomIdAndShowroom.get(oppty.Appointment_Venue_Square__c).name);
                       template_contentList.add(template_contentMap4);
                       
                       Map<String,String> template_contentMap5 = new Map<String,String>();
                       template_contentMap5.put('name','channel_partner_name');
                       template_contentMap5.put('content',mapOfChannelPartnerIdAndCP.get(oppty.Channel_Partner__c).name);
                       template_contentList.add(template_contentMap5);
                       
                       Map<String,String> template_contentMap6 = new Map<String,String>();
                       template_contentMap6.put('name','customer_phone');
                       template_contentMap6.put('content',oppty.Customer_Phone_Number__c);
                       template_contentList.add(template_contentMap6);
                       
                       Map<String,String> template_contentMap7 = new Map<String,String>();
                       template_contentMap7.put('name','customer_email');
                       template_contentMap7.put('content',oppty.Customer_Email__c);
                       template_contentList.add(template_contentMap7);
                       
                       String jsonbody = MandrilEmailViaRosterQueueabble.rosterEmailWrapperJsonCreator('40%_payment_email_for_broker', subject, toEmailMap, template_contentList,null);
                            System.debug('jsonbody: '+jsonbody);
                            if(!String.isBlank(jsonbody)){
                                listOfJSON.add(jsonbody);
                            }
                 }
                 }
                 
             }
            if(!listOfJSON.isEmpty() && !rosterEmailsSent){
                System.debug('listOfJSON is not empty: '+listOfJSON);
                if(System.isBatch()||System.isFuture()){
                    MandrilEmailViaRosterQueueabble emailQueable = new MandrilEmailViaRosterQueueabble(listOfJSON);
                    ID jobID = System.enqueueJob(emailQueable);
                    rosterEmailsSent = True;
                    System.debug('jobID: '+jobID);
                }
                else{
                    System.debug('non batch non future context');
                    MandrilEmailViaRosterQueueabble.callRosterEmailAPI(listOfJSON);
                    rosterEmailsSent = True;
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','OpportunityTriggerHandler Class','handleOpportunityRosterEmails Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    Public static void updateProbabilityOfClosure(List<Opportunity> newOpptyList,Map<Id,Opportunity> oldMap){ 
        try{
            if(!oldMap.isEmpty() && !newOpptyList.isEmpty()){ 
                Map<String,Opp_Funnel_SubStatus_Probability_Mapping__mdt> mapOfSubStatusAndOFSPMMdt = new Map<String,Opp_Funnel_SubStatus_Probability_Mapping__mdt>();
                for(Opp_Funnel_SubStatus_Probability_Mapping__mdt metadataObj :[Select 
                                             id,Sub_Status__c,Probability_of_Closure__c
                                             From Opp_Funnel_SubStatus_Probability_Mapping__mdt])
                {
                    mapOfSubStatusAndOFSPMMdt.put(metadataObj.Sub_Status__c,metadataObj);
                }
                if(!mapOfSubStatusAndOFSPMMdt.isEmpty()){
                    for (Opportunity op: newOpptyList){
                        if((op.Opportunity_Funnel_Status__c != oldMap.get(op.Id).Opportunity_Funnel_Status__c || op.Opportunity_Funnel_Sub_Status__c != oldMap.get(op.Id).Opportunity_Funnel_Sub_Status__c) 
                           && (op.Opportunity_Funnel_Status__c =='Follow-up Meeting Fixed' || op.Opportunity_Funnel_Status__c =='Followup Meeting Successful')
                           && mapOfSubStatusAndOFSPMMdt.containsKey(op.Opportunity_Funnel_Sub_Status__c)){
                               op.Probability_of_Closure_1__c = mapOfSubStatusAndOFSPMMdt.get(op.Opportunity_Funnel_Sub_Status__c).Probability_of_Closure__c;
                           }
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','OpportunityTriggerHandler','updateProbabilityOfClosure method',e.getMessage(),e.getStackTraceString(),null);
        }        
    }
    
    
    public static void callOppToFBCAPI(List<Opportunity> newList,Map<Id,Opportunity> OldMap){
        List  <Opportunity> leadList= new List<Opportunity>();
        system.debug('method entry');
        List<String> listOfJSON = new List<String>();
        try{
            for (Opportunity fbOpp : newList) {
                // Check if the Lead status of lead source facebook Ad has been changed to "Appointment Fixed" /Appointment Successfull then send this event to facebook CAPI Integration
                if ( fbOpp.StageName == GenericConstants.Opp_Payment_Stage_A_Reached &&   fbOpp.StageName != oldMap.get(fbOpp.Id).StageName) {
                    if(fbOpp.LeadSource =='FB Lead Form' && String.isNotBlank(fbOpp.Lead_FB_Id__c)){
                        String jsonBody = LeadTriggerHandlerHelper.CreateFbLeadJson(fbOpp.Lead_FB_Id__c,'Order Booked');
                        listOfJSON.add(jsonBody);
                    }else{
                        String[] nameParts = fbOpp.Name.split(' (?=\\S+$)');
                        String firstName='';
                        String lastName='';
                        if(nameParts.size()>1){
                            firstName = nameParts[0];
                            lastName = nameParts[1];
                        }else{
                            firstName = nameParts[0];
                        }
                        Lead ld = [select id, Area_Code__c ,postalcode from lead where id=:fbOpp.LeadId__c limit 1];
                        JSONGenerator gen = JSON.createGenerator(true);
                        gen.writeStartObject();
                        gen.writeFieldName('data');
                        gen.writeStartArray();
                        gen.writeStartObject(); 
                        gen.WriteStringField(GenericConstants.Event_Name ,'Order Booked');
                        gen.writeNumberField(GenericConstants.Event_Time ,DateTime.now().getTime() / 1000);
                        gen.writeStringField(GenericConstants.Action_Source,GenericConstants.System_Generated );
                        gen.writeFieldName(GenericConstants.USER_DATA);
                        gen.writeStartObject();
                        gen.writeFieldName('em');
                        gen.writeString(String.isNotBlank(fbOpp.Customer_Email__c)?LeadTriggerHandler.createSHA256(fbOpp.Customer_Email__c):'');
                        gen.writeFieldName('ph');
                        gen.writeString(String.isNotBlank(fbOpp.Customer_Phone_Number__c)?LeadTriggerHandler.createSHA256(fbOpp.Customer_Phone_Number__c):'');
                        gen.writeFieldName('fn');
                        gen.writeString(String.isNotBlank(firstName)? LeadTriggerHandler.createSHA256(firstName): ''); 
                        gen.writeFieldName('ln');
                        gen.writeString(String.isNotBlank(lastName)? LeadTriggerHandler.createSHA256(lastName): ''); 
                        gen.writeFieldName('ct');
                        gen.writeString(String.isNotBlank(fbOpp.CityfromLead__c)? LeadTriggerHandler.createSHA256(fbOpp.CityfromLead__c):'');
                        gen.writeFieldName('zp');
                        gen.writeString(ld!=null && String.isNotBlank(ld.PostalCode)? LeadTriggerHandler.createSHA256(ld.PostalCode):'');
                        gen.writeFieldName('country');
                        gen.writeString(ld!=null && String.isNotBlank(ld.Area_Code__c)&& ld.Area_Code__c.contains('91') ? LeadTriggerHandler.createSHA256('India'):'');                        
                        gen.writeEndObject();
                        gen.writeEndObject();
                        gen.writeEndArray();
                        gen.WriteStringField(genericConstants.TEST_EVENT_CODE,Label.FB_Test_event_CAPI);
                        gen.writeEndObject();           
                        String jsonBody = gen.getAsString();
                        system.debug('json'+jsonBody);
                        listOfJSON.add(jsonBody);
                    }
                    
                }
                
                
            }
            if(!listOfJSON.isEmpty()){
                if(system.isBatch()||system.isFuture()){	
                    system.debug('batch is running');	
                    LeadOppPushToFBCAPI  objLPA = new LeadOppPushToFBCAPI(listOfJSON);	
                    ID jobID = System.enqueueJob(objLPA);	
                    system.debug('jobID '+jobID);	
                }else{	
                    system.debug('batch not running');	
                    LeadOppPushToFBCAPI.callFBCAPIFuture(listOfJSON);	
                }	 
            }
            
            
        }Catch(Exception e){
            system.debug('error'+ e.getMessage());
            system.debug('err'+e.getLineNumber()+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','callToFBCAPI method',e.getMessage(),e.getStackTraceString(),null);
        }
        
    }
    
    public static void updateFollowupTimeOnNewCloseDateChange(List<Opportunity> newList,Map<Id,Opportunity> OldMap)
    {
        System.debug('updateFollowupTimeOnNewCloseDateChange');
        List <Opportunity> oppList= new List<Opportunity>();
        try
        {   
             
        	for (Opportunity record : newList) 
            {
              //  System.debug('Old Close Date for Opportunity Id ' + record.Id + ': ' + OldMap.get(record.Id).New_Close_Date__c);
        	  //	System.debug('New Close Date for Opportunity Id ' + record.Id + ': ' + record.New_Close_Date__c);
            	if (record.New_Close_Date__c != OldMap.get(record.Id).New_Close_Date__c && record.New_Close_Date__c !=null && record.Follow_Up_Time__c==null) 
                {             
                   

                    // Calculate DateTime value before one day of Specific Date value
                    DateTime newDateTimeValue = record.New_Close_Date__c.addDays(-1);
                    
                 //   System.debug('New DateTime Value before one day: ' + newDateTimeValue);
                    // Set time to 11 AM
                    newDateTimeValue = DateTime.newInstance(newDateTimeValue.year(), newDateTimeValue.month(), newDateTimeValue.day(), 11, 0, 0);
                    
               //     System.debug('New DateTime Value with time set to 11 AM: ' + newDateTimeValue);

                    record.Follow_Up_Time__c = newDateTimeValue;
                    oppList.add(record);
            	}
            }      
        	System.debug('Opportunity List to be Updated: ' + oppList);
            
            // Update records
            if(!oppList.isEmpty())
            {
                update oppList;
            }      

        }
        Catch(Exception e)
        {
            system.debug('error'+ e.getMessage());
            system.debug('err'+e.getLineNumber()+e.getStackTraceString());
            Logger.log('Exception','OpportunityTriggerHandler Class','updateFollowupTimeOnNewCloseDateChange method',e.getMessage(),e.getStackTraceString(),null);
        }
   		
    }
    
    public static void updateFollowupTimeOnFreshOpportunity(List<Opportunity> newList)
    {
        System.debug('updateFollowupTimeOnFreshOpportunity');
        List <Opportunity> oppList= new List<Opportunity>();
        try
        {   
             
        	for (Opportunity record : newList) 
            {
                	if (record.Opportunity_Funnel_Status__c == 'Fresh Opportunity')
                    {
                                      
                        // Calculate DateTime value before one day of Specific Date value
                        DateTime newDateTimeValue = System.today().addDays(1);
                        
                    //    System.debug('New DateTime Value after one day: ' + newDateTimeValue);
                        // Set time to 11 AM
                        newDateTimeValue = DateTime.newInstance(newDateTimeValue.year(), newDateTimeValue.month(), newDateTimeValue.day(), 11, 0, 0);
                        
                    //    System.debug('New DateTime Value with time set to 11 AM: ' + newDateTimeValue);
    
                        record.Follow_Up_Time__c = newDateTimeValue;
                         System.debug('record.Follow_Up_Time__c : ' + record.Follow_Up_Time__c );
                    }
            }  
         
        }
        Catch(Exception e)
        {
            system.debug('error'+ e.getMessage());
            system.debug('err'+e.getLineNumber()+e.getStackTraceString());
            Logger.log('Exception','OpportunityTriggerHandler Class','updateFollowupTimeOnFreshOpportunity method',e.getMessage(),e.getStackTraceString(),null);
        }
   		
    }
    
        
    /*******************************************************************
// function to update the GST information on all Opportunities.
*********************************************************************/
    Public Static void updateGSTinfo(List<Opportunity> newOpptyList, Map<Id,Opportunity> oldOpptyMap)
    { 
        system.debug('updateGSTinfo Method Entry');
        List<Opportunity> listOfOpp = new List<Opportunity>();
        List<Id> listOfLeadIDs = new List<Id>();
        List<Lead> listOfMainOrders1 = new List<Lead>();
        List<Lead> listOfSubordersAndMainOrders = new List<Lead>();
        List<Lead> listOfSuborders = new List<Lead>();
        List<Id> listOfMainOrders2 = new List<Id>();
        List<Opportunity> listOfOpportunity = new List<Opportunity>();
       
        
        try
        {            
            if(oldOpptyMap == null)
            {
                for(Opportunity newOpp: newOpptyList)
                {
                    system.debug('Criteria Pass: Opportunity Created');
                    listOfOpp.add(newOpp);
                    listOfLeadIDs.add(newOpp.LeadId__c);
                }
            }
            else
            {
                for(Opportunity newOpp: newOpptyList)
                {
                    if(newopp.Customer_GSTIN__c != oldOpptyMap.get(newOpp.id).Customer_GSTIN__c)
                    {                    
                        listOfOpp.add(newOpp);
                        listOfLeadIDs.add(newOpp.LeadId__c);
                        system.debug('Criteria Pass: Opportunity Updated');
                    }
                }
            }
            
            system.debug('listOfOpp :'+listOfOpp);
            system.debug('listOfLeadIDs :'+listOfLeadIDs);
            
            if(!listOfLeadIDs.isEmpty())
            {
            
                    // 1.Main Order : Find main order first. Find all suborders on those main orders and their opportunities to delete GST value
                    
                    listOfMainOrders1 = [SELECT Id,Brand__c,Account__c,Number_of_Sub_Orders_Created__c, Main_Order__c FROM Lead WHERE Main_Order__c=null and Id IN :listOfLeadIDs];
                    system.debug('listOfMainOrders1 '+ listOfMainOrders1);                      
                  
                   // 2.Suborder : Find all suborders and their main orders. Then find all suborders and their opportunities to delete GST value
                    
                    listOfSuborders = [SELECT Id,Brand__c,Account__c,Number_of_Sub_Orders_Created__c, Main_Order__c FROM Lead WHERE Main_Order__c!=null and Id IN :listOfLeadIDs];
                    system.debug('listOfSuborders '+ listOfSuborders);  
                    
                    for(Lead rec : listOfSuborders)
                    {
                            listOfMainOrders2.add(rec.Main_Order__c);
                    }                
                    system.debug('listOfMainOrders2 '+ listOfMainOrders2);                
                    
                    listOfSubordersAndMainOrders = [SELECT Id,Brand__c,Account__c,Number_of_Sub_Orders_Created__c, Main_Order__c FROM Lead 
                                                    WHERE (Main_Order__c IN :listOfMainOrders1 OR Main_Order__c IN :listOfMainOrders2) 
                                                    OR (Id IN :listOfMainOrders1 OR Id IN :listOfMainOrders2)];
                    
                    system.debug('listOfSubordersAndMainOrders '+ listOfSubordersAndMainOrders); 
                    
                    listOfOpportunity =  [Select id,Customer_GSTIN__c,Account.Customer_GSTIN__c from Opportunity where LeadId__c IN :listOfSubordersAndMainOrders];
                    system.debug('listOfOpportunity '+ listOfOpportunity);
                    
                    if(!listOfOpportunity.isEmpty())
                    {
                            for(Opportunity record : listOfOpportunity)
                            {
                                system.debug('Customer_GSTIN__c '+ record.Customer_GSTIN__c);
                                record.Customer_GSTIN__c = record.Account.Customer_GSTIN__c;
                            }
                        	if(oldOpptyMap != null)
                            {
                                update listOfOpportunity ;
                            }
                            
                    }    	
            }
            
        }
        catch(Exception e)
        {
            Logger.log('Exception','OpportunityTriggerHandler','updateGSTinfo',e.getMessage(),e.getStackTraceString(),NULL);    
        }
    }
    
}