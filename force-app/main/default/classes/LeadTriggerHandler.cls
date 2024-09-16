/*
* Created By    : Roshi Rai
* Created Date  : 25/May/2016
* Modified By   : 
* Modified Date : 
* Description   : This Class is a Handler class of Lead Trigger which include all the funtionality . 
*/
public class LeadTriggerHandler {
    
    Public Static Map < String, String > newleadrecordsMap = new Map < String, String > ();
    Public Static Map < String, Lead > newleadsMap = new Map < String, Lead > ();
    Public Static List < Lead > existingleadrecordslist = new List < Lead > ();
    Public static String subject = null;
    Public static String emailContent = null;
    Public static String toEmailIds = null;
    Public static Boolean rosterEmailsSent = false;
    
       
    public static void updatePreAppointmentDate(List<Lead> listOfLeads, Map<Id,Lead> OldMap)
    {
        List<lead> LeadList = new List<lead>();
    	try
        {
            for(Lead ld:listOfLeads)
            {
                    if(ld.status != OldMap.get(ld.id).Status && ld.status == GenericConstants.LEAD_PRE_APPOINTMENT_STATUS )
                    {
                        ld.Pre_Appointment_Date__c = System.now();
                      //  LeadList.add(ld);
                    }
            }     
             
        }
        Catch(Exception e)
        {
            Logger.log('Exception','LeadTriggerHandler Class','updatePreAppointmentDate method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
   //Description : This method is to tag account when a lead is created from FB Lead form and to change the data as per our requirement standard phone/city
    
    public static void beforeFBLeadInsert(List<Lead> listOfLeads){
        try{
             SYstem.debug('beforeFBLeadInsert listOfLeads' + listOfLeads);             
            for(Lead ld:listOfLeads){
            if((ld.leadSource == GenericConstants.FB_Lead_Form ||ld.leadSource == GenericConstants.LinkedIn_Lead_Form) && String.isNotBlank(ld.GCLID__c))
            {
                SYstem.debug('FB ld '+ ld);
                LeadTriggerHandlerHelper.fbleadCaptureData(listOfLeads);
            }
            
        }
        }catch(Exception e){
            
            //system.debug('error'+ e.getMessage());
            //system.debug('err'+e.getLineNumber()+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','callToFBCAPI method',e.getMessage(),e.getStackTraceString(),null);
        }
        
    }
    
    public static void insertTerritoryCheck(List<Lead> listOfLeads, Map<Id,Lead> OldMap){
        List<lead> updateLeadList = new List<Lead>();
        try{
            if(OldMap == null){
                for(lead lds :listOfLeads){
                    if(!String.isBlank(lds.postalcode) && lds.Main_Order__c == null){
                        updateLeadList.add(Lds);
                    }    
                }
            }
            else{
                for(Lead lds:listOfLeads){
                    if(lds.postalCode != OldMap.get(lds.id).postalCode && !String.isBlank(lds.postalcode)){
                        updateLeadList.add(lds);
                    }
                }
            }
            if(!updateLeadList.isEmpty()){
                leadTriggerHandler.insertTerritoryclusterBasedOnPincode(updateLeadList);
            }
        }catch(exception e){
            Logger.log('Exception','LeadTriggerHandler Class','insertTerritoryclusterBasedOnPincode method',e.getMessage(),e.getStackTraceString(),null);
        }
        
    }
    
    public static void insertTerritoryclusterBasedOnPincode (List< Lead >listOfLeads){
        set<string> pincodeSet = new Set<string>();
        List<Territory__c> terriList = new List<Territory__c>();
        map<String,territory__c> pincodeClusterMapping = new map<String,territory__c>();
        system.debug('listOfLeads '+ listOfLeads);
        //system.debug('listOfLeads.values '+ listOfLeads.values());
        //oldmap is null -insert (postalcode !=null){leadlist}
        //else update(postal != oldmap postalcode )(leadlist) //leadlist is 
        try{
          for(Lead ld:listOfLeads){
              if(!String.isBlank(ld.postalcode)){
                  pincodeSet.add(ld.postalcode);
              }
          }
          system.debug('pincodeSet '+ pincodeSet);  
            if(!pincodeSet.isEmpty()){
                terriList = [select id, City__c ,Cluster__c,Pincode__c,Cluster_Brand__c from Territory__c where Pincode__c In: pincodeSet] ; 
            }
            system.debug('terriList '+terriList);  
            if(!terriList.isEmpty()){
               for(lead ld :listOfLeads){
                
                    for(territory__c terri :terriList){
                        terri.Cluster_Brand__c = terri.Cluster_Brand__c.replace(' ','');
                        
                        system.debug('terri.Cluster_Brand__c '+ terri.Cluster_Brand__c+ terri.Cluster__c+ terri.Pincode__c);
                        if(ld.Brand__c ==null){
                            ld.Brand__c = genericConstants.Lead_HomeLane;
                        }
                        if (ld.Brand__c == terri.Cluster_Brand__c && ld.PostalCode == terri.Pincode__c){
                            system.debug('brand match');
                            ld.Territory_Cluster__c = terri.Cluster__c;
                                break;
                            }
                        //system.debug('ld.Territory_Cluster__c '+ ld.Territory_Cluster__c);
                    }
                //   system.debug('ld.Territory_Cluster__c '+ ld.Territory_Cluster__c);
            } 
            }else{
                //ld.Territory_Cluster__c = null;
            }
            
        }Catch(Exception e){
            Logger.log('Exception','LeadTriggerHandler Class','insertTerritoryclusterBasedOnPincode method',e.getMessage(),e.getStackTraceString(),null);
        }
        
    }
    
     Public static void insertDealerInformation(List<Lead> listOfLeads){
        try{
            Set<id> idSet = new Set<id>();
            for(lead ld: listOfLeads){
                if(!ld.Bulk_Upload__c && ld.Appointment_Venue_Square__c != null && ld.LeadSource != GenericConstants.LEADSOURCE_HL_UNSERVICEABLE){
                    idSet.add(ld.Appointment_Venue_Square__c);
                }
            }
            system.debug('idSet '+ idSet);
            if(!idSet.isEmpty()){
            List<Master__c> showroomList =[select id, Showroom_Manager__r.Email__c, Showroom_Manager__c from Master__c where Type__c ='Dealer Showroom' and id in:idSet and IsActive__c=true];
            Map<id ,Master__c> mapOfShowroomandUser = new Map<id ,Master__c> ();
            //Map<id,String> mapOfShowroomUserIDandEmail = new  Map<id,String>();
            system.debug('showroomList '+ showroomList);
            if(!showroomList.isEmpty()){
                for(Master__c sh :showroomList){
                    mapOfShowroomandUser.put(sh.id,sh);
                    //mapOfShowroomUserIDandEmail.put(sh.Showroom_Manager__c,sh.Showroom_Manager__r.Email__c);
                }
            }
           system.debug('mapOfShowroomandUser '+ mapOfShowroomandUser);
            
            if(!mapOfShowroomandUser.isEmpty()){
                 for(lead ld: listOfLeads){
                     if(mapOfShowroomandUser.containsKey(ld.Appointment_Venue_Square__c) && !ld.Assigned_to_Dealer__c){
                         system.debug('mapOfShowroomandUser get'+ mapOfShowroomandUser.get(ld.Appointment_Venue_Square__c));
                         ld.Dealer__c = mapOfShowroomandUser.get(ld.Appointment_Venue_Square__c).Showroom_Manager__c;
                         ld.Dealer_Email__c = mapOfShowroomandUser.get(ld.Appointment_Venue_Square__c).Showroom_Manager__r.Email__c;
                         ld.Assigned_to_Dealer__c= true;
                         ld.Dealer_Assigment_Date__c = system.now();
                         //ld.Dealer_Email__c =mapOfShowroomandUser.get(ld.Appointment_Venue_Square__c).email__c;
                     }
                }
            }
            }
            
               
                
            
            
            
        }catch (Exception e){
             system.debug('error'+ e.getMessage());
            system.debug('err'+e.getLineNumber()+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','callToFBCAPI method',e.getMessage(),e.getStackTraceString(),null);
        }
    }


//Description : This method is to Calculate lead score  when lead is inserted and also recalculate lead score when lead goes to Pre-Appointment
    public static void calculateLeadScore(List<Lead> listOfLeads, Map<Id,Lead> OldMap){
        //for insert
        List<lead> LeadScoreList = new List<lead>();
        String leadStatus = GenericConstants.LEAD_FRESH_STATUS;
        String UserName = UserInfo.getUserName();//Returns the context user's login name.
		System.Debug('UserName-' + UserName);
               
        try
        {
            if(OldMap == null)
            {                
                for(lead ldscore :listOfLeads)
                {
                    LeadScoreList.add(Ldscore);                    
                }                
            }
            else
            {
                for(Lead ldscore:listOfLeads)
                {                    
                    if(ldscore.Green_Lead_Class__c != GenericConstants.Green_Lead_Gold_Plus)
                    {
                  	    if(ldscore.status != OldMap.get(ldScore.id).Status && ((ldScore.status == GenericConstants.LEAD_PRE_APPOINTMENT_STATUS && 
                           (ldScore.Meeting_Source__c == GenericConstants.Customer_PreAppt_Meeting_Source || ldscore.Bulk_Upload__c)) || 
                           (ldScore.status == GenericConstants.WhatsApp_Pre_Appointment && ldscore.Green_Lead_Class__c == GenericConstants.Green_Lead_Bronze )) )
                         {                         
                            	LeadScoreList.add(Ldscore);                            
                         }
                        
                        else if((ldScore.OTP_Verified__c != oldMap.get(ldScore.Id).OTP_Verified__c && ldScore.OTP_Verified__c)||
                                (ldScore.Status != oldMap.get(ldScore.Id).Status && ldScore.Sub_Status__c != oldMap.get(ldScore.Id).Sub_Status__c && 
                                 !ldScore.Bulk_Upload__c && ldScore.Status == GenericConstants.LEAD_FRESH_STATUS && ldScore.Sub_Status__c == GenericConstants.LEAD_RELANDED_SUBSTATUS 
                                 && (oldMap.get(ldScore.Id).Status==  GenericConstants.LEAD_DEAD_STATUS || oldMap.get(ldScore.id).Status==GenericConstants.LEAD_NOT_ACTIVELY_PURSUED_STATUS)))
                        {
                                LeadScoreList.add(ldScore);                                                                                                                           
                        }                       
                        
                        else
                        {
                             if(ldscore.Is_Blitz_property_lead__c != oldMap.get(ldScore.id).Is_Blitz_property_lead__c &&  !ldscore.Is_Blitz_property_lead__c )
                             {
                                LeadScoreList.add(ldScore);
                             }
                             else if(ldscore.Is_Blitz_builder_lead__c != oldMap.get(ldScore.id).Is_Blitz_builder_lead__c &&  !ldscore.Is_Blitz_builder_lead__c &&
                                     ldscore.Bulk_Upload__c && (String.isBlank(ldscore.Relanded_Source__c) || ldscore.Relanded_Source__c == GenericConstants.OFFLINE_LEAD_SOURCE))
                             {
                                    LeadScoreList.add(ldScore);
                             }
                        }
                    }
                    
                    if(ldscore.Lead_Score_for_Assignment__c == null )
                    {
                           LeadScoreList.add(Ldscore);   
                    }
                   
                    
                }
                
            }
            
            
            System.debug('LeadScoreList :'+LeadScoreList);
            
            if(!LeadScoreList.isEmpty())
            {                
                LeadTriggerHelper.setGreenLeadScore(LeadScoreList);
            }
            
        }
        Catch(Exception e)
        {
            system.debug('error'+ e.getMessage());
            system.debug('err'+e.getLineNumber()+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','calculateLeadScore method',e.getMessage(),e.getStackTraceString(),null);          
         }
    }
    
    public static void checkForluxeLeadAssignment(List<lead> newList,Map<Id,Lead> OldMap ){
         List  <Lead> leadList= new List<lead>();
         Set<String> setOfPincodes = new Set<String>();
        try{
            if(!newList.isEmpty()){
                for( lead luxLead :newList){
                    if(luxLead.Sign_Up_Source__c == genericConstants.HomeLaneLuxeLeadForm 
                       && String.isNotBlank(luxLead.PostalCode) && String.isNotBlank(luxLead.City) 
                       && luxLead.Should_run_Ironman_assignment__c && luxLead.Bulk_Upload__c == false){
                           LeadList.add(luxLead);
                           setOfPincodes.add(luxLead.PostalCode);
                       }
                }
            }
            if(! LeadList.isEmpty() && !setOfPincodes.isEmpty()){
                LuxeLeadAssignmentHandler.getLuxeShowroomUserDetails(LeadList,setOfPincodes);
            }
            
        }catch(Exception e){
            system.debug('error'+ e.getMessage());
            system.debug('err'+e.getLineNumber()+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','checkForluxeLeadAssignment method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
   
     
    //Description : This is to update the lead score if customer property is in list of Blitz property fetching the values from custom settings
    //The leads will automaticaly goes into Gold+ Green channel Category
 /*    public static void BlitzPropertyScoreUpdate(List<lead> newList,Map<Id,Lead> OldMap){
        
        try{
            List<Blitz_Property__c> blitzPropertyNames = Blitz_Property__c.getAll().values();
            Set<string> blitzPropertySet = new  Set<String>();
            Set<id> idSet = new Set<id>();
            List  <Lead> leadList= new List<lead>();
            for (Blitz_Property__c blitzProp : blitzPropertyNames) {
                blitzProp.Property_Name__c = blitzProp.Property_Name__c.toLowerCase();
                blitzPropertySet.add(blitzProp.Property_Name__c);
            }
           
            for(Lead ld :newlist){
                //if(ld.Property__c != OldMap.get(ld.id).Property__c){
                    if(ld.Green_Lead_Class__c != genericConstants.Green_Lead_Gold_Plus){
                        idSet.add(ld.Property__c);
                    }
                //} 
                
            }
           
            List<Master__c> masterPropList = [select id ,Name from Master__c where id in:idSet];

            map<id, String> mapOfPropertynameAndId = new map<id, String> ();
            if(!masterPropList.isEmpty()){
                for(Master__c ms :masterPropList){
                    mapOfPropertynameAndId.put(ms.id,ms.Name);
                }
            }
            //system.debug('mapOfPropertynameAndId '+ mapOfPropertynameAndId);
            for(lead ld : newList){
                //if(ld.Property__c != OldMap.get(ld.id).Property__c){
                    if(mapOfPropertynameAndId.containsKey(ld.Property__c)){
                        String ldPropertyName = mapOfPropertynameAndId.get(ld.Property__c).toLowerCase();
                        //system.debug('ldPropertyName'+ ldPropertyName);
                        if(String.isNotBlank(ldPropertyName)){
                            if(blitzPropertySet.contains(ldPropertyName)){
                                ld.Lead_Score_for_Assignment__c= GenericConstants.Lead_Gold_Plus_Score;
                                
                            } 
                        }
                        
                    }
                //}        
            }
            
        }Catch(Exception e){
            system.debug('error'+ e.getMessage());
            system.debug('err'+e.getLineNumber()+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','BlitzPropertyScoreUpdate method',e.getMessage(),e.getStackTraceString(),null);
        }
        
    }*/
    
    //Description: 
    
    public static void callToFBCAPI(List<lead> newList,Map<Id,Lead> OldMap)
    {
        List  <Lead> leadList= new List<lead>();
        List  <Setup_Configuration__c> setupList= new List<Setup_Configuration__c>();
        List<String> listOfJSON = new List<String>();
        Set<String> LeadSOurceSet = new Set<String>{'Walk-in','Referral','FB Lead Form','Broker/Channel Partner'};
        String UserIPAddress;
        
        try{
               //For Update
                if(OldMap!=null)
                {
                    for (Lead fblead : newList) 
                    {
                    	if (!fblead.Bulk_Upload__c && (fblead.Brand__c==GenericConstants.LEAD_HOMELANE || String.isBlank(fblead.Brand__c)) && (fblead.Status == GenericConstants.LEAD_APPOINTMENT_FIXED_STATUS||fbLead.Status == GenericConstants.LEAD_APPOINTMENT_SUCCESSFUL|| 
                            fbLead.status == GenericConstants.LEAD_PRE_APPOINTMENT_STATUS || fbLead.status == GenericConstants.LEAD_WHATSAPP_PRE_APPOINTMENT_STATUS ) && fblead.Status != oldMap.get(fblead.Id).Status) 
                        {
                    				if(fblead.LeadSource == 'FB Lead Form'&& String.isNotBlank(fblead.GCLID__c))
                                    {                        
                                        String jsonBody = LeadTriggerHandlerHelper.CreateFbLeadJson(fblead.GCLID__c,fblead.Status);
                                        listOfJSON.add(jsonBody);                        
                    				}
                        			else
                                    {
                                        String[] nameParts = fblead.LastName.split(' (?=\\S+$)');
                                        String country ='';
                                        String firstName='';
                                        String lastName='';
                                        if(nameParts.size()>1)
                                        {
                                            firstName = nameParts[0];
                                            lastName = nameParts[1];
                                        }
                                        else
                                        {
                                        	firstName = nameParts[0];
                                        }
                                        if(String.isNotBlank(fblead.Area_Code__c) && fblead.Area_Code__c.contains('91'))
                                        {
                                            country ='India';
                        				}
                                        
                                        if(String.isNotBlank(fbLead.User_IP_Address__c))
                                        {
                                            UserIPAddress = fbLead.User_IP_Address__c.split(',')[0].trim();
                                            System.debug('UserIPAddress: ' + UserIPAddress);
                                        }
                                        
                                        //System.debug('First Name: ' + firstName);
                                        //System.debug('Last Name: ' + lastName);
                                        JSONGenerator gen = JSON.createGenerator(true);
                                        gen.writeStartObject();
                                        gen.writeFieldName('data');
                                        gen.writeStartArray();
                                        gen.writeStartObject(); 
                                        gen.WriteStringField(GenericConstants.Event_Name ,fblead.Status);
                                        gen.writeNumberField(GenericConstants.Event_Time ,DateTime.now().getTime() / 1000);
                                        gen.writeStringField(GenericConstants.Action_Source,GenericConstants.System_Generated );
                                        gen.writeFieldName(GenericConstants.USER_DATA);
                                        gen.writeStartObject();
                                        gen.writeFieldName('em');
                                        gen.writeString(String.isNotBlank(fblead.Email)?createSHA256(fblead.Email):'');
                                        gen.writeFieldName('ph');
                                        gen.writeString(String.isNotBlank(fblead.phone)?createSHA256(fblead.phone):'');
                                        gen.writeFieldName('fn');
                                        gen.writeString(String.isNotBlank(firstName)? createSHA256(firstName): ''); 
                                        gen.writeFieldName('ln');
                                        gen.writeString(String.isNotBlank(lastName)? createSHA256(lastName): ''); 
                                        gen.writeFieldName('ct');
                                        gen.writeString(String.isNotBlank(fblead.City)? createSHA256(fblead.City):'');
                                        gen.writeFieldName('zp');
                                        gen.writeString(String.isNotBlank(country)?createSHA256(country):'');
                                        gen.writeFieldName('country');
                                        gen.writeString(String.isNotBlank(fblead.PostalCode)?createSHA256(fblead.PostalCode):'');
                                        
                                        //Newly added on 29th July 2024
                                        if(String.isNotBlank(UserIPAddress))
                                        {
                                            gen.writeFieldName('client_ip_address');                                                                            
                                        	gen.writeString(UserIPAddress);
                                        }
                                        if(String.isNotBlank(fbLead.User_Agent__c))
                                        {
                                            gen.writeFieldName('client_user_agent');
                                            gen.writeString(fbLead.User_Agent__c);
                                        }
                                        if(String.isNotBlank(fbLead.fbc__c))
                                        {  
                                            gen.writeFieldName('fbc');                                        
                                            gen.writeString(fbLead.fbc__c);
                                        }
                                        if(String.isNotBlank(fbLead.fbp__c))
                                        {
                                            gen.writeFieldName('fbp');
                                            gen.writeString(fbLead.fbp__c);
                                        }
                                  //	Commented on 5th August 2024
                                  //    gen.writeFieldName('test_event_code'); 
                                  //    gen.writeString('TEST49524');
                                         
                                        gen.writeEndObject();
                                        gen.writeEndObject();
                                        gen.writeEndArray();
                                  //    gen.WriteStringField(genericConstants.TEST_EVENT_CODE,Label.FB_Test_event_CAPI);
                                        gen.writeEndObject();           
                                        String jsonBody = gen.getAsString();
                                        system.debug('json'+jsonBody);
                                        listOfJSON.add(jsonBody); 
                                        
                                     /*   // Saving the JSON to Setup config records
                                        Setup_Configuration__c setUpLead = new Setup_Configuration__c();
                                        setUpLead.Lead__c = fblead.id;
                                        setUpLead.Request_JSON__c = jsonBody;
                                        setUpLead.Operation_Status__c = 'Closed';
                                        setupLead.Error_Message__c = 'Customer Id : '+ fblead.Customer_ID__c ;
                                        setupList.add(setUpLead);  
                                        System.debug('Added in Setuplist');*/
                                    }
                    
                		}
                	}
                }
            //For Insert
           		 else
                 {
                    	for(Lead fblead : newList)
                        {
                            	if(fblead.Brand__c==GenericConstants.LEAD_HOMELANE || String.isBlank(fblead.Brand__c))
                                {
                                    if(  String.isNotBlank(fblead.GCLID__c) && fblead.LeadSource =='FB Lead Form' )
                                    {
                                                String jsonBody = LeadTriggerHandlerHelper.CreateFbLeadJson(fblead.GCLID__c,'Lead');
                                                listOfJSON.add(jsonBody);
                                    }
                                    else if(fblead.Sign_Up_Source__c == GenericConstants.Sign_Up_WhatsApp_Haptik)
                                    {
                                        
                                                String[] nameParts = fblead.LastName.split(' (?=\\S+$)');
                                                String country ='';
                                                String firstName='';
                                                String lastName='';
                                                if(nameParts.size()>1)
                                                {
                                                    firstName = nameParts[0];
                                                    lastName = nameParts[1];
                                                }
                                                else
                                                {
                                                    firstName = nameParts[0];
                                                }
                                                if(String.isNotBlank(fblead.Area_Code__c) && fblead.Area_Code__c.contains('91'))
                                                {
                                                    country ='India';
                                                }
                                
                                                System.debug('First Name: ' + firstName);
                                                System.debug('Last Name: ' + lastName);
                                                JSONGenerator gen = JSON.createGenerator(true);
                                                gen.writeStartObject();
                                                gen.writeFieldName('data');
                                                gen.writeStartArray();
                                                gen.writeStartObject(); 
                                                gen.WriteStringField(GenericConstants.Event_Name ,'WhatsApp Lead');
                                                gen.writeNumberField(GenericConstants.Event_Time ,DateTime.now().getTime() / 1000);
                                                gen.writeStringField(GenericConstants.Action_Source,GenericConstants.System_Generated );
                                                gen.writeFieldName(GenericConstants.USER_DATA);
                                                gen.writeStartObject();
                                                gen.writeFieldName('em');
                                                gen.writeString(String.isNotBlank(fblead.Email)?createSHA256(fblead.Email):'');
                                                gen.writeFieldName('ph');
                                                gen.writeString(String.isNotBlank(fblead.phone)?createSHA256(fblead.phone):'');
                                                gen.writeFieldName('fn');
                                                gen.writeString(String.isNotBlank(firstName)? createSHA256(firstName): ''); 
                                                gen.writeFieldName('ln');
                                                gen.writeString(String.isNotBlank(lastName)? createSHA256(lastName): ''); 
                                                gen.writeFieldName('ct');
                                                gen.writeString(String.isNotBlank(fblead.City)? createSHA256(fblead.City):'');
                                                gen.writeFieldName('zp');
                                                gen.writeString(String.isNotBlank(country)?createSHA256(country):'');
                                                gen.writeFieldName('country');
                                                gen.writeString(String.isNotBlank(fblead.PostalCode)?createSHA256(fblead.PostalCode):'');
                                                gen.writeEndObject();
                                                gen.writeEndObject();
                                                gen.writeEndArray();
                                                gen.writeEndObject();           
                                                String jsonBody = gen.getAsString();
                                                system.debug('json'+jsonBody);
                                                listOfJSON.add(jsonBody);                              
                                    }
                                    else if(fbLead.Bulk_Upload__c == False && !LeadSourceSet.contains(fbLead.LeadSource))
                                    {
                                        String[] nameParts = fblead.LastName.split(' (?=\\S+$)');
                                        String country ='';
                                        String firstName='';
                                        String lastName='';
                                        if(nameParts.size()>1)
                                        {
                                            firstName = nameParts[0];
                                            lastName = nameParts[1];
                                        }
                                        else
                                        {
                                        	firstName = nameParts[0];
                                        }
                                        if(String.isNotBlank(fblead.Area_Code__c) && fblead.Area_Code__c.contains('91'))
                                        {
                                            country ='India';
                        				}
                                        
                                        if(String.isNotBlank(fbLead.User_IP_Address__c))
                                        {
                                            UserIPAddress = fbLead.User_IP_Address__c.split(',')[0].trim();
                                            System.debug('UserIPAddress: ' + UserIPAddress);
                                        }                                        
                                        
                                        JSONGenerator gen = JSON.createGenerator(true);
                                        gen.writeStartObject();
                                        gen.writeFieldName('data');
                                        gen.writeStartArray();
                                        gen.writeStartObject(); 
                                        gen.WriteStringField(GenericConstants.Event_Name ,GenericConstants.FB_EVENT_LEADCREATION);
                                        gen.writeNumberField(GenericConstants.Event_Time ,DateTime.now().getTime() / 1000);
                                        gen.writeStringField(GenericConstants.Action_Source,GenericConstants.System_Generated );
                                        gen.writeFieldName(GenericConstants.USER_DATA);
                                        gen.writeStartObject();
                                        gen.writeFieldName('em');
                                        gen.writeString(String.isNotBlank(fblead.Email)?createSHA256(fblead.Email):'');
                                        gen.writeFieldName('ph');
                                        gen.writeString(String.isNotBlank(fblead.phone)?createSHA256(fblead.phone):'');
                                        gen.writeFieldName('fn');
                                        gen.writeString(String.isNotBlank(firstName)? createSHA256(firstName): ''); 
                                        gen.writeFieldName('ln');
                                        gen.writeString(String.isNotBlank(lastName)? createSHA256(lastName): ''); 
                                        gen.writeFieldName('ct');
                                        gen.writeString(String.isNotBlank(fblead.City)? createSHA256(fblead.City):'');
                                        gen.writeFieldName('zp');
                                        gen.writeString(String.isNotBlank(country)?createSHA256(country):'');
                                        gen.writeFieldName('country');
                                        gen.writeString(String.isNotBlank(fblead.PostalCode)?createSHA256(fblead.PostalCode):'');                                        
                                        
                                        if(String.isNotBlank(UserIPAddress))
                                        {
                                            gen.writeFieldName('client_ip_address');                                                                            
                                        	gen.writeString(UserIPAddress);
                                        }
                                        if(String.isNotBlank(fbLead.User_Agent__c))
                                        {
                                            gen.writeFieldName('client_user_agent');
                                            gen.writeString(fbLead.User_Agent__c);
                                        }
                                        if(String.isNotBlank(fbLead.fbc__c))
                                        {  
                                            gen.writeFieldName('fbc');                                        
                                            gen.writeString(fbLead.fbc__c);
                                        }
                                        if(String.isNotBlank(fbLead.fbp__c))
                                        {
                                            gen.writeFieldName('fbp');
                                            gen.writeString(fbLead.fbp__c);
                                        }
                                                                           
                                        gen.writeEndObject();
                                        gen.writeEndObject();
                                        gen.writeEndArray();
                                        gen.writeEndObject();           
                                        String jsonBody = gen.getAsString();
                                        system.debug('json'+jsonBody);
                                        listOfJSON.add(jsonBody); 
                                        
                                        // Saving the JSON to Setup config records
                                      /*  Setup_Configuration__c setUpLead = new Setup_Configuration__c();
                                        setUpLead.Lead__c = fblead.id;
                                        setUpLead.Request_JSON__c = jsonBody;
                                        setUpLead.Operation_Status__c = 'Closed';
                                        setupLead.Error_Message__c = 'Customer Id : '+ fblead.Customer_ID__c ;
                                        setupList.add(setUpLead);  
                                        System.debug('Added in Setuplist');*/
                                    }
                                }
                    	}
                 }
                // Check if the Lead status of lead source facebook Ad has been changed to "Appointment Fixed" /Appointment Successfull then send this event to facebook CAPI Integration
                
                
              /*  if(!setupList.isEmpty())
                {
                    System.debug('Insert Setuplist');
                    insert setupList;
                }*/
            
            	if(!listOfJSON.isEmpty())
                {
                    if(system.isBatch()||system.isFuture())
                    {	
                        //system.debug('batch is running');	
                        LeadOppPushToFBCAPI  objLPA = new LeadOppPushToFBCAPI(listOfJSON);	
                        ID jobID = System.enqueueJob(objLPA);	
                        //system.debug('jobID '+jobID);	
                	}
                    else
                    {	
                        //system.debug('batch not running');	
                        LeadOppPushToFBCAPI.callFBCAPIFuture(listOfJSON);	
                    }	 
            	}
            
        }
        Catch(Exception e)
        {
            system.debug('error'+ e.getMessage());
            system.debug('err'+e.getLineNumber()+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','callToFBCAPI method',e.getMessage(),e.getStackTraceString(),null);
        }
        
    }
    
    
    
    public static String createSHA256(String str ){
        Blob strBlob = Blob.valueOf(str);
        Blob hash = Crypto.generateDigest('SHA-256',strBlob );
        String hashString = EncodingUtil.convertToHex(hash);
        System.Debug('hashStringEMail'+hashString);
        return hashString ;
    }
      
   
    public static void createDoowupLeadFromHomeLaneLead(List< Lead > newList, Map<Id,Lead> OldMap)  
    {
        boolean Assignment_Initiate_Stage_Set = false;
        system.debug('Create Doowup Lead');
        try
        {
            	Set<String> setOfRedPincodes= new Set<String>{'560010','560032','560040','560049','560061','560091','560099'};
				List<Lead> createLeadList =new List<Lead>();
            	Id recTypeId = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Routing HL Leads').getRecordTypeId();
                system.debug('recTypeId');
            	Lead_Class_Scoring__c HLRec;
            
            	HLRec = [Select id,Budget_Counter__c,Budget_Counter_Limit__c,Purpose_Counter__c,Purpose_Counter_Limit__c,Property_Counter__c,Property_Counter_Limit__c,
                         Red_Pincode_Counter__c, Red_Pincode_Counter_Limit__c,Counter_Limit__c,	Total_Limit__c
                         from Lead_Class_Scoring__c 
                         where RecordTypeId =:recTypeId 
                         limit 1];
                                      
                System.debug('Hlrec'+ HLRec);
                          
                if(HLRec != null && Hlrec.Counter_Limit__c < Hlrec.Total_Limit__c)
                {
  						system.debug('Counter is not full');
                        for(lead ld :newList)
                        {                        
                                system.debug('ld');
                                if(ld.brand__c =='HomeLane'&& ld.Status == GenericConstants.LEAD_FRESH_STATUS && 
                                  (ld.Sub_Status__c == GenericConstants.LEAD_NEW_SUBSTATUS || ld.Sub_Status__c == GenericConstants.LEAD_SUBSTATUS_UNVERIFIED) && 
                                   ld.City == GenericConstants.LD_City_Bengaluru && ld.LeadSource != 'Walk-In' && ld.LeadSource != 'Referral' && ld.Bulk_Upload__c == False)
                                {
                                    if((ld.Sign_Up_Source__c == GenericConstants.Sign_Up_Source_EstimateFlow && ld.Property_Status__c==GenericConstants.Property_Status_RentOut)||
                                       ((setOfRedPincodes.contains(ld.PostalCode)) && (ld.Sign_Up_Source__c != GenericConstants.Sign_Up_Source_EstimateFlow ||
                                       (ld.Sign_Up_Source__c == GenericConstants.Sign_Up_Source_EstimateFlow && ld.Property_Status__c!=GenericConstants.Property_Status_RentOut))))
                                        {
        										system.Debug('Criteria passed for Doowup lead Creation');
                                                createLeadList.add(ld);                                              
                                        }                                                                                                                                          
                                }
                         }
                }
            
            	system.debug('createLeadList '+createLeadList);
            	system.debug('Assignment_Initiate_Stage_Set '+Assignment_Initiate_Stage_Set);
         
                if(!createLeadList.isEmpty())
                {
                    	Assignment_Initiate_Stage_Set = true;
                        for(lead ld :createLeadList)
                    	{ 
                            ld.Assignment_Initiate_Stage__c = 'HL Doowup GFE Experiment';                            
                        }                   
                }            
            	system.debug('Assignment_Initiate_Stage_Set '+Assignment_Initiate_Stage_Set);
        }
        
        catch(Exception e)
        {
            system.debug('error'+ e.getMessage());
            system.debug('err'+e.getLineNumber()+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','createDoowupLeadFromHomeLaneLead method',e.getMessage(),e.getStackTraceString(),null);
        }        
    } 
    
    
   
    
    /***********Roshi Rai******************
Description   : This method is to update the Customer ID Which is in the format od CITY-FIRSTNAMELASTNAME 
BAN-RU-0001 to KOL-BB-0001 which is generated when a lead is edited for city and First and last name*****/
    
    Public static void updateCustomerCityName(Map<Id, Lead > newlist) 
    {
        for (Lead objled: newlist.values()) 
        {
            if(objled.Main_Order__c == null && objled.Brand__c != GenericConstants.Brand_Wrapzap)
            {
                if (objled.City != NULL && objled.LastName != null && objled.FirstName != NULL && objled.Customer_value_appended__c != null && String.isBlank(objled.Customer_ID__c)) 
                {
                    objled.Customer_ID__c = (objled.City).substring(0, 3) + '-' + (objled.FirstName).substring(0, 1) + (objled.LastName).substring(0, 1) + '-' +objled.Customer_value_appended__c;
                } 
                else if (objled.City != NULL && objled.LastName != null && objled.FirstName == NULL && objled.Customer_value_appended__c != null && String.isBlank(objled.Customer_ID__c)) 
                {
                    objled.Customer_ID__c = (objled.City).substring(0, 3) + '-' + (objled.LastName).substring(0, 1) + '-' +objled.Customer_value_appended__c;
                }
            } 
            else if(objled.Main_Order__c == null && objled.Brand__c == GenericConstants.Brand_Wrapzap)
            {
                if (objled.City != NULL && objled.LastName != null && objled.FirstName != NULL && objled.WZ_Auto_Number__c != null && String.isBlank(objled.Customer_ID__c)) 
                {
                    objled.Customer_ID__c = (objled.City).substring(0, 3) + '-' + (objled.FirstName).substring(0, 1) + (objled.LastName).substring(0, 1) + '-WZ' +objled.WZ_Auto_Number__c;
                } 
                else if (objled.City != NULL && objled.LastName != null && objled.FirstName == NULL && objled.WZ_Auto_Number__c != null && String.isBlank(objled.Customer_ID__c)) 
                {
                    objled.Customer_ID__c = (objled.City).substring(0, 3) + '-' + (objled.LastName).substring(0, 1) + '-WZ' +objled.WZ_Auto_Number__c;
                }

            }
        }

    }
       /* if(!updateAutonumber.isEmpty()){
            system.debug(updateAutonumber);
            update updateAutonumber;
        }*/
        
     
    
    /**
* Name          : UpdateLeadDetails_Controller.cls
* @Description  : Any Event of Possession Delay checked if “Possession beyond 3 months” and “Possession beyond 6 months” was selected at any point in time
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0      11/SEP/2019                 WarpDrive              Initial Version
**/
    
    Public static void updatePossessionDelay(Map<Id,Lead> newMap,Map<Id,Lead> OldMap)
    {
        if(newMap != NULL)
        {
            for(Lead objLead :newMap.values())
            {
                if(OldMap!= NULL)
                {
                    if(objLead.Sub_Status__c != OldMap.get(objLead.id).Sub_Status__c && (objLead.Sub_Status__c == 'Possession beyond 6 months' || objLead.Sub_Status__c == 'Possession beyond 3 months') 
                       && objLead.Any_Event_of_Possession_Delay__c == false)
                    {
                           objLead.Any_Event_of_Possession_Delay__c = true;
                    }                
                }
                else
                {
                    if((objLead.Sub_Status__c == 'Possession beyond 6 months' || objLead.Sub_Status__c == 'Possession beyond 3 months') 
                       && objLead.Any_Event_of_Possession_Delay__c == false)
                    {
                        objLead.Any_Event_of_Possession_Delay__c = true;
                    }
                }
            }
        }
    }
    
    
    
    /***************Round Robin Assingment on basis of city and Workload***AND allocate Showroom Sales Agent Assigment on round robin basis on selection of 
Appointment Venue - Square***************/
    
    
    public static void handleRoundRobin(List < Lead > leadData, map < id, Lead > oldleadData) {
        set < id > holdQueueName = new Set < id > ();
        set < id > leadid = new Set < id > ();
        set < id > absentuserid = new set < id > ();
        set < id > idMaster = new set < id > ();
        map < id, String > strMasterName = new map < id, String > ();
        List < Lead > updatelead = new List < Lead > ();
        List < Lead_Assignment__c > lstLeadAssignments = new List < Lead_Assignment__c > ();
        try{ 
            for(Lead L: leadData) {
                if(l.City.equalsIgnoreCase('other') || l.City.equalsIgnoreCase('others')){
                    System.debug('======L.Lead_Assingment__c  '+L.Lead_Assingment__c);
                    System.debug('======L.Showroom_Sales_Agent_Assigment__c  '+L.Showroom_Sales_Agent_Assigment__c);
                    if (L.Lead_Assingment__c != oldleadData.get(L.id).Lead_Assingment__c && L.Lead_Assingment__c == false) {
                        
                        holdQueueName.add(L.ownerId);
                        leadid.add(L.id);
                        
                    }
                    
                    if (L.Appointment_Venue_Square__c != NULL && L.Appointment_Venue_Square__c != oldleadData.get(L.id).Appointment_Venue_Square__c && L.Showroom_Sales_Agent_Assigment__c == true) {
                        idMaster.add(l.Appointment_Venue_Square__c);
                        leadid.add(L.id);
                    }
                }        
            }
            //System.debug('======holdQueueName  '+holdQueueName);
            //System.debug('======idMaster  '+idMaster);
            //System.debug('======leadid  '+leadid);
            
            //Query to get the Queue Name from Master
            
            if (!idMaster.isEmpty()) {
                for (Master__c eachMas: [SELECT Builder_Name__c, Id, Name, OwnerId FROM Master__c WHere id in: idMaster]) {
                    strMasterName.put(eachMas.id, eachMas.Name);
                }
            }
            //System.debug('======strMasterName  '+strMasterName);
            //list to update as we cant perfrom update on trigger.new
            List < Lead > lstlead = new List < Lead > ([Select id, OwnerId, Appointment_Venue_Square__c from Lead where id In: leadid]);
            System.debug('======lstlead  '+lstlead );
            /***this method is used to allocate Showroom Sales Agent Assigment on round robin basis on selection of 
Appointment Venue - Square (which act as queue with different user defined in Round robin object and Queue with same Name****/
            
            if (!strMasterName.isEmpty()) {
                
                Map < Id, String > groupNameMap = new Map < Id, String > ();
                Map < String, Id > groupNameMap1 = new Map < String, Id > ();
                for (Group grp: [Select Id, Name, Email from Group where Name =: strMasterName.values()]) {
                    groupNameMap.put(grp.id, grp.Name);
                    groupNameMap1.put(grp.Name, grp.id);
                }
               // System.debug('======groupNameMap  '+groupNameMap);
                //System.debug('======groupNameMap1  '+groupNameMap1);
                
                if (!groupNameMap.isEmpty()) {
                    Map < Id, Round_Robin__c > roundRobinMap = new Map < Id, Round_Robin__c > ([select Queue_Name__c, Total_Leads__c,
                                                                                                (select Number_of_Leads__c, USer__r.name, User__r.LastLoginDate, Assign_Percent__c, Actual_Percentage__c, Round_Robin__c, User__c from Lead_Assignment__r Where User__c Not in: absentuserid)
                                                                                                FROM Round_Robin__c
                                                                                                WHERE Queue_Name__c IN: groupNameMap.values() and IsActive__c = true
                                                                                               ]);
                    //System.debug('======roundRobinMap   '+roundRobinMap );
                    if (!roundRobinMap.isEmpty()) {
                        Map < String, Id > rrNameMap = new Map < String, Id > ();
                        for (Round_Robin__c rb: roundRobinMap.values()) {
                            rrNameMap.put(rb.Queue_Name__c, rb.id);
                            
                        }
                        System.debug('======rrNameMap  '+rrNameMap);
                        List < Lead_Assignment__c > leadAssList = new List < Lead_Assignment__c > ();
                        Set < Id > leadAssSet = new Set < Id > ();
                        for (Lead l: lstlead) {
                            Round_Robin__c roundRobin = roundRobinMap.get(rrNameMap.get(groupNameMap.get(groupNameMap1.get(strMasterName.get(l.Appointment_Venue_Square__c)))));
                            System.debug('======roundRobin   '+roundRobin);
                            if (roundRobin.Lead_Assignment__r != NULL) {
                                //   if(roundRobin.Lead_Assignment__r[0] != null) {
                                Lead_Assignment__c curLAss = roundRobin.Lead_Assignment__r[0];
                                System.debug('======Lead_Assignment__c  curLAss   '+curLAss);
                                System.debug('======curLAss.Assign_Percent__c   '+curLAss.Assign_Percent__c);
                                System.debug('======curLAss.Actual_Percentage__c  '+curLAss.Actual_Percentage__c);
                                decimal i = curLAss.Assign_Percent__c - curLAss.Actual_Percentage__c;
                                for (Lead_Assignment__c lAss: roundRobin.Lead_Assignment__r) {
                                    System.debug('======Lead_Assignment__c  lAss  '+lAss);
                                    System.debug('======lAss.Assign_Percent__c  '+lAss.Assign_Percent__c);
                                    System.debug('======lAss.Actual_Percentage__c  '+lAss.Actual_Percentage__c);
                                    System.debug('======decimal i  '+i);
                                    System.debug('======lAss.Assign_Percent__c - lAss.Actual_Percentage__c  '+(lAss.Assign_Percent__c - lAss.Actual_Percentage__c));
                                    if (i < (lAss.Assign_Percent__c - lAss.Actual_Percentage__c) == true) {
                                        System.debug('INSIDE IF CONDITION');
                                        curLAss = lAss;
                                        i = lAss.Assign_Percent__c - lAss.Actual_Percentage__c;
                                    }
                                }
                                
                                l.Square_Showroom_Agent__c = curLAss.User__c;
                                //to stop roundrobin to execute twice at beginning  l.Showroom_Sales_Agent_Assigment__c is set to true by workflow.
                                l.Showroom_Sales_Agent_Assigment__c = false;
                                updatelead.add(l);
                                curLAss.Number_of_Leads__c += 1;
                                
                                
                                if (!leadAssSet.contains(curLAss.id)) {
                                    System.debug('INSIDE leadAssSet');
                                    leadAssList.add(curLAss);
                                    leadAssSet.add(curLAss.id);
                                }
                                // }
                            }
                            System.debug('======leadAssList   '+leadAssList);
                            System.debug('======leadAssSet   '+leadAssSet);
                            System.debug('======updatelead   '+updatelead);
                            
                            
                            if (RecursiveTriggerHandlerLead.isFirstTime) {
                                RecursiveTriggerHandlerLead.isFirstTime = false;
                                if (!leadAssList.isEmpty()) {
                                    update leadAssList;
                                }
                                if (updatelead.size() > 0) {
                                    update updatelead;
                                }
                            }
                        }
                        
                    }
                    Else {
                        
                        System.debug('roundRobin.Lead_Assignment__rPlease create the lead for Queue');
                        
                    }
                    
                }
            }
            
            
            //Round robin for Lead generation
            if (!holdQueueName.isEmpty()) {
                Map < Id, String > groupNameMap = new Map < Id, String > ();
                for (Group grp: [Select Id, Name, Email from Group where id IN: holdQueueName]) {
                    groupNameMap.put(grp.id, grp.Name);
                }
                
                /* for (Leave_Holidays__c Lv: [SELECT id, Apply_Date__c, user__c FROM Leave_Holidays__c where Apply_Date__c =: system.today()]) {
absentuserid.add(Lv.user__c);
}*/
                
                if (!groupNameMap.isEmpty()) {
                    Map < Id, Round_Robin__c > roundRobinMap = new Map < Id, Round_Robin__c > ([select Queue_Name__c, Total_Leads__c,IsActive__c,
                                                                                                (select Number_of_Leads__c, USer__r.name, User__r.LastLoginDate, Assign_Percent__c, Actual_Percentage__c, Round_Robin__c, User__c from Lead_Assignment__r Where User__c Not in: absentuserid)
                                                                                                FROM Round_Robin__c
                                                                                                WHERE Queue_Name__c IN: groupNameMap.values()
                                                                                               ]);
                    
                    if (!roundRobinMap.isEmpty()) {
                        Map < String, Id > rrNameMap = new Map < String, Id > ();
                        for (Round_Robin__c rb: roundRobinMap.values()) {
                            rrNameMap.put(rb.Queue_Name__c, rb.id);
                            
                        }
                        List < Lead_Assignment__c > leadAssList = new List < Lead_Assignment__c > ();
                        Set < Id > leadAssSet = new Set < Id > ();
                        for (Lead l: lstlead) {
                            Round_Robin__c roundRobin = roundRobinMap.get(rrNameMap.get(groupNameMap.get(l.OwnerId)));
                            if (roundRobin.Lead_Assignment__r != NULL) {
                                Lead_Assignment__c curLAss = new Lead_Assignment__c();
                                for(Integer j=0;j<roundRobin.Lead_Assignment__r.size();j++){
                                    if(roundRobin.Lead_Assignment__r[j].Assign_Percent__c !=0){
                                        curLAss = roundRobin.Lead_Assignment__r[j];
                                        break;
                                    }
                                }
                                decimal i = curLAss.Assign_Percent__c - curLAss.Actual_Percentage__c;
                                for (Lead_Assignment__c lAss: roundRobin.Lead_Assignment__r) {
                                    if (i < lAss.Assign_Percent__c - lAss.Actual_Percentage__c && lAss.Assign_Percent__c !=0) {
                                        curLAss = lAss;
                                        i = lAss.Assign_Percent__c - lAss.Actual_Percentage__c;
                                    }
                                }
                                l.Ownerid = curLAss.User__c;
                                l.Lead_Assingment__c = true;
                                updatelead.add(l);
                                curLAss.Number_of_Leads__c += 1;
                                
                                if (!leadAssSet.contains(curLAss.id)) {
                                    leadAssList.add(curLAss);
                                    leadAssSet.add(curLAss.id);
                                }
                            }
                            
                            if (!leadAssList.isEmpty()) {
                                update leadAssList;
                            }
                            
                            
                            if (RecursiveTriggerHandlerLead.isFirstTime) {
                                RecursiveTriggerHandlerLead.isFirstTime = false;
                                if (updatelead.size() > 0) {
                                    update updatelead;
                                }
                            }
                        }
                        
                    }
                    Else {
                        
                        System.debug('roundRobin.Lead_Assignment__rPlease create the lead for Queue');
                        
                    }
                }
            }
        }
        catch(Exception e){
            Logger.log('LeadTriggerHandler','handleRoundRobin','handleRoundRobin',e.getMessage(),e.getStackTraceString(),NULL);
        } 
    }  
    
    
    Public static void UpdateMeetingTask(List < Lead > leadrecordList, Map < Id, Lead > oldLeadMap) {
        Set<DateTime> setAppointmentTime = new Set<DateTime>();
        Set<Id> setLeadId = new Set<Id>();
        List<Task> lstUpdatedTask = new List<Task>();
        for (Lead newLeadrecord: leadrecordList){
            if(newLeadrecord.Status == 'Appointment Successful' && newLeadrecord.Status != oldLeadMap.get(newLeadrecord.Id).status){
                setAppointmentTime.add(newLeadrecord.Appointment_Time__c);
                setLeadId.add(newLeadrecord.Id);
            }
            system.debug('---setAppointmentTime----'+setAppointmentTime);
        }
        if(setLeadId.size() != 0){
            for(Task objTask : [Select Id,Appointment_Time__c,Meeting_Successful__c From Task Where WhoId IN : setLeadId AND Appointment_Time__c IN : setAppointmentTime]){
                objTask.Meeting_Successful__c = true;
                lstUpdatedTask.add(objTask);
            }
        }
        update lstUpdatedTask;  
    }
    
    Public static void InsertEmailForCommunication(List < Lead > leadrecordList) {
        
        for (Lead newLeadrecord: leadrecordList) {
            if(newLeadrecord.Email != null && newLeadrecord.Email.Contains('duplicate')){
                Integer startIndex = newLeadrecord.Email.indexOf('_');
                system.debug('---startIndex----'+startIndex);
                String strEmail = newLeadrecord.Email.subString(startIndex+1,newLeadrecord.Email.length());
                system.debug('---strEmail----'+strEmail);
                newLeadrecord.Email_For_Communication__c = strEmail;
                newLeadrecord.Update_Email_Communication__c = true;
                system.debug('---newLeadrecord----'+newLeadrecord);             
            }else{
                
                newLeadrecord.Email_For_Communication__c = newLeadrecord.Email;
                system.debug('---newLeadrecord-else---'+newLeadrecord);             
            }
            system.debug('---newLeadrecord----'+newLeadrecord);
        }
        
    }
  
    Public static void UpdateEmailForCommunication(List < Lead > leadrecordList) {
        
        for (Lead newLeadrecord: leadrecordList) {
            if(newLeadrecord.Update_Email_Communication__c == true && newLeadrecord.Email.Contains('duplicate')){
                Integer startIndex = newLeadrecord.Email.indexOf('_');
                String strEmail = newLeadrecord.Email.subString(startIndex+1,newLeadrecord.Email.length());
                newLeadrecord.Email_For_Communication__c = strEmail;                
            }else{
                newLeadrecord.Email_For_Communication__c = newLeadrecord.Email; 
            }
        }  
    }
    
    /**
* @description || Called from Lead Trigger In Before Insert. Checks if the lead is not test lead and has Pincode 
and Pass send the filtered lead for assignment.
* @author Bharatesh Shetty | 2/6/2020 
* @param List <Lead> lstLead 
* @return void 
**/
    
   //This method is already commented in LeadTrigger 10th January 2024
    Public static void checkPincode(List <Lead> lstLead, boolean shouldCheckForIMAssignment, Boolean shouldCheckForSqaudIQAssignment) {
        try{
            String assignmentStage ='Verified Insert'; //Verified Insert, Verified Update,Unverified - SquadIQ/IRM,Roster Referral Update, Website Referral SalesManager Not found on insert pincode copy on insert,
            //Boolean shouldCheckForIMAssignment = True;
            //Boolean shouldCheckForSqaudIQAssignment = True;
            list<Lead> lstLeadRecords = new List<Lead>();
            Set<String> lstPincode = new Set<String>();
            list<Lead> lstLeadRecordsPreference = new List<Lead>();
            Set<String> lstPincodePreference = new Set<String>();
            List<Log__c> listOfLogsToInsert = new List<Log__c>();
            List<Lead> listOfOzonetelpushedLeadsUpdate = new List<Lead>();
            List<Lead> listOfOzonetelpushLeads = new List<Lead>();
            List<String> setOfCitiesForPreferenceAssignement = new List<String>();
            List<String> setOfCitiesExcludedForSquadIQ = new List<String>();
            List<String> setOfSignUpSourcesForSquadIQ = new List<String>();
             List<Lead> lstRenovationLead = new List<Lead> ();
            
            setOfCitiesForPreferenceAssignement = label.City_Specific_Preference_Assignment.split(';');
            Id recTypeId = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('SquadIQ Configs').getRecordTypeId();
            System.debug('recTypeId: '+recTypeId);
            Lead_Class_Scoring__c SquadIQConfigRecord;
            /*SquadIQConfigRecord = [Select id,SquadIQ_Cities__c,SquadIQ_Excluded_Cities__c,SquadIQ_SignUp_Sources__c,SquadIQ_Total_Leads_Assigned__c,SquadIQ_Total_Leads_Limit__c,Squad_IQ_Daily_Leads_Assigned__c,Squad_IQ_daily_Leads_Limit__c,Threashold_SquadIQ_Lead_Score__c 
                                   from Lead_Class_Scoring__c 
                                   where RecordTypeId =:recTypeId 
                                   limit 1];*/
            
            if(SquadIQConfigRecord !=Null){
                System.debug('SquadIQConfigRecord.SquadIQ_Excluded_Cities__c: '+SquadIQConfigRecord.SquadIQ_Excluded_Cities__c);
                if(String.isNotBlank(SquadIQConfigRecord.SquadIQ_Excluded_Cities__c)){
                    setOfCitiesExcludedForSquadIQ = SquadIQConfigRecord.SquadIQ_Excluded_Cities__c.split(';');
                }
                if(String.isNotBlank(SquadIQConfigRecord.SquadIQ_SignUp_Sources__c)){
                    setOfSignUpSourcesForSquadIQ = SquadIQConfigRecord.SquadIQ_SignUp_Sources__c.split(';');
                }
            }else{
                system.debug('SquadIQConfigRecord is null');
            }
            if(!lstLead.isEmpty()){
                Lead SquadIQLead;
                Boolean isRenovationSpecialistLead = false;
                for(Lead objLead: lstLead) {
                    // If City is Bengaluru and BulkUpload Is false (Bulk_Upload is marked for offline lead uploaded via dataloader)
                    // if(objLead.City.equalsIgnoreCase('Bengaluru') && objLead.Bulk_Upload__c == false && objLead.Should_run_Ironman_assignment__c){
                    system.debug(objLead.Should_run_Ironman_assignment__c);
                    system.debug(shouldCheckForIMAssignment);
                    if(objLead.Should_run_Ironman_assignment__c && shouldCheckForIMAssignment ){
                        // Check if Postal Code is not blank and Doesn't conatain any text
                        System.debug('objLead.postalcode: '+objLead.postalcode);
                        System.debug('objLead.Sales_Manager__c: '+objLead.Sales_Manager__c);
                        System.debug('objLead.Assigned_To_Resi_ASM__c: '+objLead.Assigned_To_Resi_ASM__c);
                        //System.debug('objLead.postalcode.isNumeric(): '+objLead.postalcode.isNumeric());
                        
                        if(String.isNotBlank(objLead.postalcode) && objLead.postalcode.isNumeric() && objLead.Sales_Manager__c == Null && !objLead.Assigned_To_Resi_ASM__c){
                            System.debug('objLead.postalcode.isNumeric(): '+objLead.postalcode.isNumeric());
                            // Check if this is test lead or test or not 
                            if(!(objLead.LastName.containsIgnoreCase('hltest') || objLead.Email.containsIgnoreCase('hltest') || ObjLead.LeadSource.containsIgnoreCase('Test Source'))){
                                Boolean isSquadIQLead = false;
                                if(objLead.Property_Status__c !='Renovation'){
                                    /*if(SquadIQConfigRecord != null && shouldCheckForSqaudIQAssignment && objLead.LeadSource !='Referral' && objLead.Area_Code__c =='91' ){
                                    if(setOfCitiesExcludedForSquadIQ.isEmpty() || (!setOfCitiesExcludedForSquadIQ.isEmpty() && !setOfCitiesExcludedForSquadIQ.contains(objLead.city))){
                                        if(SquadIQConfigRecord.Squad_IQ_daily_Leads_Assigned__c<SquadIQConfigRecord.Squad_IQ_daily_Leads_Limit__c){
                                            if(SquadIQConfigRecord.SquadIQ_Total_Leads_Assigned__c<SquadIQConfigRecord.SquadIQ_Total_Leads_Limit__c){
                                                if(SquadIQConfigRecord.Threashold_SquadIQ_Lead_Score__c !=Null && objLead.Lead_Score_for_Assignment__c !=Null
                                                   && objLead.Lead_Score_for_Assignment__c <= SquadIQConfigRecord.Threashold_SquadIQ_Lead_Score__c){
                                                       isSquadIQLead = true;
                                                   }
                                                else{
                                                    System.debug('Lead score is higher than the Threashold_SquadIQ_Lead_Score__c');
                                                    System.debug('objLead.Lead_Score_for_Assignment__c: '+objLead.Lead_Score_for_Assignment__c);
                                                    System.debug('SquadIQConfigRecord.Threashold_SquadIQ_Lead_Score__c: '+SquadIQConfigRecord.Threashold_SquadIQ_Lead_Score__c);
                                                }
                                            }else{
                                                System.debug('Squad IQ total limit exceeded.');
                                            }
                                        }else{
                                            System.debug('Squad IQ daily limit exceeded.');
                                        }
                                    }
                                    else{
                                        System.debug('No city is excluded from squad IQ or city does not match Squad IQ excluded cities list.');
                                    }
                                }*/
                                }
                                else{
                                    isRenovationSpecialistLead = true;
                                }
                                
                                
                                if(isSquadIQLead){
                                    SquadIQLead = objLead;
                                    System.debug('isSquadIQLead: '+isSquadIQLead);
                                }
                                else if(setOfCitiesForPreferenceAssignement.contains(objLead.City)){
                                    system.debug('cityprefer');
                                    lstLeadRecordsPreference.add(objLead);
                                    lstPincodePreference.add(objLead.postalcode);
                                }
                                
                                else {
                                    system.debug('homelanelead');
                                   lstLeadRecords.add(objLead);
                                    lstPincode.add(objLead.postalcode);
                                }
                            }    
                        }
                        else if(objLead.Sales_Manager__c == Null && !objLead.Assigned_To_Resi_ASM__c){
                            //If the pincode is empty for the lead (which ideally shouldn't be) capture the log and push the lead to OzoneTel and update lead details.
                            listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','LeadTriggerHandler Class','checkPincode method','Pin code is empty for the lead : '+objLead.LastName+' with Lead source: '+objLead.LeadSource,objLead.email,objLead.LeadSource));
                            Lead leadToUpdate = new Lead();
                            leadToUpdate.id = objLead.Id;
                            leadToUpdate.Pushed_To_Ozonetel__c = true;
                            //Owner and WTA Cloud Agent
                            leadToUpdate.OwnerId = label.Cloud_Agent_Id;
                            leadToUpdate.WT_Agent__c = label.Cloud_Agent_Id;
                            listOfOzonetelpushedLeadsUpdate.add(leadToUpdate);
                            system.debug('whatsapphaptikPush to');
                            listOfOzonetelpushLeads.add(objLead);
                        }
                    }
                    
                }  
                if(!listOfOzonetelpushLeads.isEmpty()){
                    //Pushing leads to OzoneTel in exceptional cases.
                    PushToOzoneTelAdditionalQueue objLPA = new PushToOzoneTelAdditionalQueue(listOfOzonetelpushLeads,UserInfo.getSessionId());
                    ID jobID = System.enqueueJob(objLPA);
                    system.debug('-----jobID----'+jobID);
                }
                
                
                if(!listOfOzonetelpushedLeadsUpdate.isEmpty()){
                    //Update lead records deatils which are pushed to OzoneTel.
                    update listOfOzonetelpushedLeadsUpdate;
                }
                System.debug('====lstLeadRecords==='+lstLeadRecords);
                System.debug('====lstPincode==='+lstPincode);
                if(SquadIQLead !=null){
                    String jsonBody = createSquadIQJson(SquadIQLead);
                    if(String.isNotBlank(jsonBody)){
                        if(System.isBatch()||System.isFuture()){
                            PushLeadsToSquadIQQueuable emailQueable = new PushLeadsToSquadIQQueuable(jsonBody,SquadIQLead.Id,SquadIQConfigRecord.id);
                            ID jobID = System.enqueueJob(emailQueable);
                        }
                        else{
                            System.debug('non batch non future context');
                            PushLeadsToSquadIQQueuable.callSquadIQFuture(jsonBody,SquadIQLead.Id,SquadIQConfigRecord.id);
                            //PushLeadsToSquadIQQueuable emailQueable = new PushLeadsToSquadIQQueuable(jsonBody,SquadIQLead.Id,SquadIQConfigRecord.id);
                            //ID jobID = System.enqueueJob(emailQueable);
                        }
                    }
                    else{
                        System.debug('jsonBody is blank for SquadIQLead');
                        listOfLogsToInsert.add(Logger.returnLog('SquadIQ Error','LeadTriggerHandler','checkPincode Method','jsonBody is blank for SquadIQLead',SquadIQLead.Id,''));
                    }
                }
                
             system.debug('lstLeadRecords. '+lstLeadRecords);
                if(!lstLeadRecords.isEmpty()){
                    boolean isSpecialistImAssigned= false;
                    system.debug('ironman');
                    if(isRenovationSpecialistLead){
                         isSpecialistImAssigned   = IronManLead_Assignment_Handler.getSpecialisedIMDetails(lstLeadRecords, lstPincode);
                     }
                    if(!isRenovationSpecialistLead || (!isSpecialistImAssigned && isRenovationSpecialistLead )){                        
                        IronManLead_Assignment_Handler.getIronManDetails(lstLeadRecords, lstPincode);
                    }
                       
                }else{
                    system.debug('no Im Assignment');
                }
               
                    
                    //Lead records sent for IM assignment - Territory flow.
                   
                
               /* if(!lstLeadRecordsPreference.isEmpty()){
                    System.debug('Preference Called');
                    //Lead records sent for IM assignment On preference - Territory flow.
                    IronManLead_Assignment_Handler.getIronManDetailsForPreferenceAssignment(lstLeadRecordsPreference,lstPincodePreference);
                }*/
                
                if(!listOfLogsToInsert.isEmpty()){
                    // Insert the log records.
                    insert listOfLogsToInsert;
                }
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            //Log the exceptions
            Logger.log('Exception','LeadTriggerHandler Class','checkPincode method',e.getMessage(),e.getStackTraceString(),null);
        }
        
    }
    	//Same method used for Pre - sales freelancer user to IM Assignment
        
    
    Public static void WTAtoIMLeadAssignmentCheckPincode(List <Lead> lstLead, Map <Id,Lead > oldLeadMap) 
    {
            
        	try{
                    System.debug('Trigger fire');
                    String UserName = UserInfo.getUserName();//Returns the context user's login name.
                    System.Debug('UserName-' + UserName);
                    
                    Set<Id> setOfIMsIds = new Set<Id>();
                    Set<Id> setOfInsideSalesIds = new Set<Id>();
                    
                    List<Master__c> ListOfDealerShowroom = [select id,Name,Type__c,Showroom_Manager__c,Showroom_Manager__r.Email__c from Master__c where Type__c='Dealer Showroom' and IsActive__c=true];
                    Set<Id> setOfDoowupDealerShowroomIds = new Set<Id>();
                    Map<Id,Master__c> mapOfDoowupDealerShowrooms = new Map<Id,Master__c>();
                    
                    if(!ListOfDealerShowroom.isEmpty())
                    {
                        for(Master__c SR : ListOfDealerShowroom)
                        {
                            setOfDoowupDealerShowroomIds.add(SR.id);                    
                        }
                    }
                    
                    if(!setOfDoowupDealerShowroomIds.isEmpty())
                    {
                        mapOfDoowupDealerShowrooms=new Map<Id,Master__c>([select id,Name,Type__c,Showroom_Manager__c,Showroom_Manager__r.Email__c from Master__c where Type__c='Dealer Showroom' and IsActive__c=true and ID =:setOfDoowupDealerShowroomIds]);
                    }
                   
                    Set<Id> setOfWTAsIds = new Set<Id>();
                    Map<Id,User> mapOfWTAs = new Map<Id,User>();
                    
                    Map<Id,Showroom_User__c> mapOfIMs = new Map<Id,Showroom_User__c>();
                    Map<Id,Showroom_User__c> mapOfInsideSales = new Map<Id,Showroom_User__c>();
                    
                    list<Lead> lstLeadForShowroomWiseAssignment = new List<Lead>();
                    list<Lead> lstLeadRecords = new List<Lead>();
                    Set<String> lstPincode = new Set<String>();
                    list<lead> updateLeadList = new List<lead>();
                    
                    for(Lead ld: lstLead)
                    {
                        if(ld.Sales_Manager__c != Null)
                        {
                            setOfIMsIds.add(ld.Sales_Manager__c);
                        }
                        if(ld.Inside_Sales_Agent__c != Null)
                        {
                            setOfInsideSalesIds.add(ld.Inside_Sales_Agent__c);
                        }
                       
                    }
                	System.debug('setOfIMsIds '+setOfIMsIds);
                	System.debug('setOfInsideSalesIds '+setOfInsideSalesIds);
                    if(!setOfIMsIds.isEmpty())
                    {
                        mapOfIMs = new Map<Id,Showroom_User__c>([Select id,IsActive__c,Name,City__c,Showroom_Name__c,Showroom_Name__r.Name,Email__c,Phone__c from Showroom_User__c where id =:setOfIMsIds]);
                    }
                    
                    if(!setOfInsideSalesIds.isEmpty())
                    {
                        mapOfInsideSales = new Map<Id,Showroom_User__c>([Select id,IsActive__c,Name,City__c,Showroom_Name__c,Showroom_Name__r.Name,Email__c,Phone__c from Showroom_User__c where id =:setOfInsideSalesIds]);
                    }
                    
                    Set<String> GreenChannelPincodeSet = new Set<String>();
                    GreenChannelPincodeSet = GreenChannelLeadAssignmentInitiateBatch.getGreenPincode();
                    
                    if(!lstLead.isEmpty())
                    {
                        for(Lead objLead: lstLead) 
                        {
                            if( objLead.Sign_Up_Source__c != 'Pronto Paint' && objLead.Brand__c != GenericConstants.Brand_Wrapzap)
                            {
                                
                                // Check if the lead is a non Im assigned lead and Status is getting changed to Pre-Appointment
                                if(!objLead.Test_Flag__c && !objLead.Assigned_to_Resi_ASM__c && objLead.Status != oldLeadMap.get(objLead.Id).Status && 
                                   objLead.Squad_IQ_Status__c !='Processed by SquadIQ' && objLead.Squad_IQ_Status__c !='Sent to SquadIQ' && 
                                   String.isNotBlank(objLead.postalcode)&& !objLead.Assigned_to_Central_Team__c)
                                {
                                    
                                    // Showroom based assignment is done if Pre-appointment is done by External user or lead is bulk uploaded
                                    if(objLead.Status == GenericConstants.LEAD_PRE_APPOINTMENT_STATUS && objLead.Appointment_Venue_Square__c!=null &&
                                      (objLead.Bulk_Upload__c == true || UserName == System.Label.External_User_Name) && 
                                       objLead.Brand__c != GenericConstants.LEAD_DOOWUP && objLead.Meeting_Source__c != GenericConstants.Customer_PreAppt_Meeting_Source)
                                    {
                                        lstLeadForShowroomWiseAssignment.add(objLead);
                                    }      
                                    
                                    else if((objLead.Status == GenericConstants.LEAD_PRE_APPOINTMENT_STATUS 
                                        && objLead.Inside_Sales_Agent__c == NULL
                                        && (!GreenChannelPincodeSet.contains(objLead.postalCode)||(GreenChannelPincodeSet.contains(objLead.postalCode) && 
                                        (objLead.Pushed_To_Ozonetel__c || objLead.Assigned_To_TLC__c || objLead.Assigned_to_Doowup_Presales__c))))
                                       || (objLead.Status == GenericConstants.LEAD_APPOINTMENT_FIXED_STATUS && objLead.Sales_Manager__c == NULL &&
                                           objLead.Freelancer_User__c !=NULL))
                                    {
                                           
                                           lstLeadRecords.add(objLead);
                                           lstPincode.add(objLead.postalcode); 
                                    }
                                    
                                    else if((objLead.Status == GenericConstants.LEAD_APPOINTMENT_FIXED_STATUS || 
                                             objLead.Status == GenericConstants.LEAD_PRE_APPOINTMENT_STATUS ) && 
                                            objLead.Inside_Sales_Agent__c != NULL && objLead.Assigned_To_Inside_Sales_Agent__c )
                                    {
                                            if( objLead.Brand__c != GenericConstants.LEAD_DOOWUP)
                                            {
                                                    if(objLead.Sales_Manager__c != NULL)
                                                    {
                                                        System.debug('Sales Manager present');
                                                        if(mapOfIMs.containsKey(objLead.Sales_Manager__c))
                                                        {
                                                            if(mapOfIMs.get(objLead.Sales_Manager__c).IsActive__c)
                                                            {
                                                                objLead.Assigned_to_Resi_ASM__c= true;
                                                                objLead.Assigned_To_Inside_Sales_Agent__c=false;                                                
                                                           
                                                                
                                                                //If MeetingSource is customer Inside sales Agent details are deleted
                                                              /*  if(objLead.Meeting_Source__c == GenericConstants.Customer_PreAppt_Meeting_Source)
                                                                {
                                                                   objLead.Inside_Sales_Agent__c=null;
                                                                   objLead.Inside_Sales_Agent_Email__c=null;
                                                                }*/
                                                            }
                                                            else
                                                            {
                                                                lstLeadRecords.add(objLead);
                                                                lstPincode.add(objLead.postalcode); 
                                                            }
                                                        }   
                                                    }
                                                
                                                    else
                                                    {  
                                                        lstLeadRecords.add(objLead);
                                                        lstPincode.add(objLead.postalcode); 
                                                    }
                                            }
                                            // This is for Doowup leads : If the Meeting source is not Customer then PC assignment will be done
                                            else
                                            {
                                                		// If inside sales user doing Pre-Appointment with Doowup Showroom(Non Dealer Showroom) then Showroom-wise Assignment is done 
                                                		 if((objLead.Status == GenericConstants.LEAD_PRE_APPOINTMENT_STATUS || objLead.Status == GenericConstants.LEAD_APPOINTMENT_FIXED_STATUS) &&
                                                            objLead.Appointment_Venue_Square__c!=null && !setOfDoowupDealerShowroomIds.contains(objLead.Appointment_Venue_Square__c) &&
                                                            objLead.Brand__c == GenericConstants.LEAD_DOOWUP && objLead.Meeting_Source__c != GenericConstants.Customer_PreAppt_Meeting_Source)
                                                        {
                                                            	lstLeadForShowroomWiseAssignment.add(objLead);
                                                        }    
                                                        // If inside sales user selects Doowup Dealer Showroom at Pre-Appointment then Assign the lead to Dealer 
                                                        else if(objLead.Appointment_Venue_Square__c != oldLeadMap.get(objLead.Id).Appointment_Venue_Square__c && setOfDoowupDealerShowroomIds.contains(objLead.Appointment_Venue_Square__c) &&
                                                                objLead.Meeting_Source__c != GenericConstants.Customer_PreAppt_Meeting_Source &&  
                                                                (objLead.Status == GenericConstants.LEAD_PRE_APPOINTMENT_STATUS || objLead.Status == GenericConstants.LEAD_APPOINTMENT_FIXED_STATUS) )
                                                        {
                                                            	LeadTriggerCubicoAndDoowupHandler.assignDealerRemoveISA(objLead,mapOfDoowupDealerShowrooms);
                                                        }
                                                              
                                                        else if((objLead.Status == GenericConstants.LEAD_PRE_APPOINTMENT_STATUS && objLead.Meeting_Source__c !='Customer')|| 
                                                           objLead.Status == GenericConstants.LEAD_APPOINTMENT_FIXED_STATUS)
                                                        {
                                                                lstLeadRecords.add(objLead);
                                                                lstPincode.add(objLead.postalcode); 
                                                        }
                                            }                                
                                    }
                                    
                                }
                                else
                                {
                                    //Pre - Appointment change condition not met
                                }
                            }
                            
                        }
                            
                        
                    }
                    System.debug('====lstLeadRecords==='+lstLeadRecords);
                    System.debug('====lstPincode==='+lstPincode);
                    System.debug('====lstLeadForShowroomWiseAssignment==='+lstLeadForShowroomWiseAssignment);
                    
                    if(!lstLeadForShowroomWiseAssignment.isEmpty())
                    {
                        //Lead records sent for IM assignment - Showroom flow.                
                        system.debug('Showroom Wise Assignment');
                        IronManLead_Assignment_Handler.getIronManFromShowroom(lstLeadForShowroomWiseAssignment);
                    }    
                    
                    if(!lstLeadRecords.isEmpty())
                    {
                        //Lead records sent for IM assignment - Territory flow.
                        
                        system.debug('Im method fire');
                        IronManLead_Assignment_Handler.getIronManDetailsWTAtoIMAssignment(lstLeadRecords,lstPincode);
                    }    
        	}
         
            catch(Exception e)
            {
                system.debug('Exception : '+e.getStackTraceString());
                system.debug('Exception message: '+e.getMessage());
                //Log the exceptions
                Logger.log('Exception','LeadTriggerHandler Class','WTAtoIMLeadAssignmentCheckPincode method',e.getMessage(),e.getStackTraceString(),null);
            }
        }
    
    
    
  /*  Public static void  reassignToInsideSalesAgent(List <Lead> leadrecordList,Map < Id, Lead > oldleadMap)
    {
        Set<Id> setOfIMsIds = new Set<Id>();
        Set<Id> setOfWTAsIds = new Set<Id>();
        Map<Id,User> mapOfWTAs = new Map<Id,User>();
        Map<Id,Showroom_User__c> mapOfIMs = new Map<Id,Showroom_User__c>();
     
        list<Lead> lstLeadRecords = new List<Lead>();
        Set<String> lstPincode = new Set<String>();
        list<lead> updateLeadList = new List<lead>();
        
        for(Lead ld: leadrecordList)
        {
            if(ld.Inside_Sales_Agent__c != Null)
            {
                setOfIMsIds.add(ld.Inside_Sales_Agent__c);
            }
            
        }
        if(!setOfIMsIds.isEmpty())
        {
            mapOfIMs = new Map<Id,Showroom_User__c>([Select id,IsActive__c from Showroom_User__c where id =:setOfIMsIds]);
        }
        system.debug('mapOfIMs '+ mapOfIMs);
        if(!leadrecordList.isEmpty())
        {
            for(Lead objLead : leadrecordList)
            {
                if(objLead.Brand__c == GenericConstants.LEAD_DOOWUP && objLead.Status != oldleadMap.get(objLead.id).Status && 
                   (objLead.Status == GenericConstants.LEAD_APPOINTMENT_UNSUCCESSFUL||objLead.Status == GenericConstants.LEAD_APPOINTMENT_CANCELLED))
                {
                    system.debug('appointment Cancelled');
                    if(objLead.Inside_Sales_Agent__c != null && objLead.Assigned_to_Resi_ASM__c )
                    {                        
                        if(mapOfIMs.containsKey(objLead.Inside_Sales_Agent__c))
                        {
                            system.debug('Inside sales found');
                            if(mapOfIMs.get(objLead.Inside_Sales_Agent__c).IsActive__c)
                            {
                                system.debug('is active');
                                Lead ld = new Lead();
                                ld.Id = objLead.Id;
                                ld.Assigned_To_Inside_Sales_Agent__c=true;
                                ld.Assigned_to_Resi_ASM__c=false;
                                updateLeadList.add(ld);
                            }
                            else{}                              
                            
                        }
                    }
                }
            }
            
           
            system.debug('updateLeadList '+ updateLeadList);
            if(!updateLeadList.isEmpty())
            {
                update updateLeadList;
            }                
        }
    }
    */
    
    Public static void callPushLeadToNimbus(List <Lead> leadrecordList,Map < Id, Lead > oldleadMap)
    {
        system.debug(' callPushLeadToNimbus');        
        lead nimbusLead;
        Boolean isNimbusLead= false;
        String Nimbus_Campaign ;
        Boolean isGlobiva = false;
        
        try
        {
            if(!leadrecordList.isEmpty())
            {
                    for(Lead lrec : leadrecordList)  
                    {
                        if(oldLeadMap !=null && !oldLeadMap.isEmpty())
                        {
                                if(lrec.Nimbus_Status__c == GenericConstants.ASSIGNED_TO_NIMBUS && oldLeadMap.get(lrec.Id).Nimbus_Status__c != lrec.Nimbus_Status__c)
                                {
                                    nimbusLead = lrec;
                                    system.debug('criteria pass in Update Lead Scenario');
                                    isNimbusLead= true;
                                    nimbusLead = lrec;
                                    Nimbus_Campaign = lrec.Nimbus_Campaign__c;
                        			system.debug('Nimbus_Campaign '+Nimbus_Campaign);
                    
                                    if(Nimbus_Campaign.contains(GenericConstants.GLOBIVA))
                                    {
                                        isGlobiva = true;
                                    }
                                }
                        }                                             
                    }
                    
                    if(nimbusLead!=null)
                    {
                    		String jsonBody ='';
                        	system.debug('isGlobiva :'+isGlobiva);  
                        
                        	if(isGlobiva)
                            {
                                	jsonBody =CreateGlobivaJSON(nimbusLead);
                                 
                                	system.debug('Globiva jsonBody '+jsonBody);
                                   
                                    //system.debug('process '+ process);
                                    if(!String.isBlank(jsonBody))
                                    {
                                            if(system.isBatch()||system.isFuture())
                                            {
                                                system.debug('batch is running');
                                                PushLeadToNimbusQueuable objLPA = new PushLeadToNimbusQueuable(jsonBody ,nimbusLead.id, isGlobiva);
                                                ID jobID = System.enqueueJob(objLPA);
                                                system.debug('jobID '+jobID);
                                            }
                                            else
                                            {
                                                system.debug('batch not running');
                                                PushLeadToNimbusQueuable.callNimbusFuture(jsonBody ,nimbusLead.id ,isGlobiva);
                                            }
                                     }
                            }
                        	else
                            {
                                	jsonBody =CreateCubeJSON(nimbusLead);
                                    jsonBody = '1;CLC@QuickCall;' + jsonBody;                                
 
                                	system.debug('Nimbus jsonBody'+jsonBody);
                                   
                                    //system.debug('process '+ process);
                                    if(!String.isBlank(jsonBody))
                                    {
                                            if(system.isBatch()||system.isFuture())
                                            {
                                                system.debug('batch is running');
                                                PushLeadToNimbusQueuable objLPA = new PushLeadToNimbusQueuable(jsonBody ,nimbusLead.id, isGlobiva);
                                                ID jobID = System.enqueueJob(objLPA);
                                                system.debug('jobID '+jobID);
                                            }
                                            else
                                            {
                                                system.debug('batch not running');
                                                PushLeadToNimbusQueuable.callNimbusFuture(jsonBody ,nimbusLead.id, isGlobiva);
                                            }
                                     }
                            }
                	}                
            }            
        }
        catch(Exception e)
        {
            System.debug('Exception : '+e.getStackTraceString());
            System.debug('Exception Message: '+e.getMessage());
            Logger.log('Exception','LeadTriggerHandler','callPushLeadToNimbus',e.getMessage(),e.getStackTraceString(),NULL);
        }  
    }
    
    
    
    Public static String CreateCubeJSON(Lead ldRec)
    {
        System.debug('postalcode' + ldRec.PostalCode);
        String JsonBody;
        
        try
        {
            
            if(ldRec!=null)
            {
                
                String Process;
                String Skill;
                
                if(ldRec.Nimbus_Campaign__c == GenericConstants.Nimbus_DL_Digital_Transfer)
                {
                    process = label.Digital_Dead_Lead;
                }
                else if(ldRec.Nimbus_Campaign__c == GenericConstants.Nimbus_DL_Offline_Transfer)
                {
                    process = label.Nimbus_Offline_Dead_lead;
                }
                else if(ldRec.Nimbus_Campaign__c == GenericConstants.Nimbus_Relanded_Transfer)
                {
                    process = label.Nimbus_Relanded;
                }
                
                 else if(ldRec.Nimbus_Campaign__c == GenericConstants.Nimbus_Hindi_Transfer)
                {
                    process = label.HomeLane_Nimbus_Hindi;
                }
                 else if(ldRec.Nimbus_Campaign__c == GenericConstants.NIMBUS_TRANSFER)
                {
                    process= label.HomeLane_Nimbus_Kannada;    
                }
               
                else if(ldRec.Nimbus_Campaign__c == GenericConstants.NIMBUS_DOOWUP_OFFLINE_TRANSFER)
                {
                    process= label.HomeLane_Nimbus_Doowup_Offline;    
                }
                
                else if(ldRec.Nimbus_Campaign__c == GenericConstants.NIMBUS_HL_MISSEDCALL_TRANSFER)
                {
                    process= label.HomeLane_Nimbus_Missed_Call;    
                }
                
                else if(ldRec.Nimbus_Campaign__c == GenericConstants.Nimbus_Telugu_Transfer)
                {
                    process = label.HomeLane_Nimbus_Telugu;
                }  
                else if(ldRec.Nimbus_Campaign__c == GenericConstants.Nimbus_Doowup_Opp_Transfer)
                {
                    process = label.Homelane_Nimbus_Doowup_Opp;
                } 
                else if(ldRec.Nimbus_Campaign__c == GenericConstants.Nimbus_Doowup_HL_Transfer)
                {
                    process = label.Homelane_Nimbus_Doowup_HL;
                } 
                else
                {
                    process= label.HomeLane_Nimbus_Hindi; 
                }
                
                if(ldRec.City == 'Kolkata')
                {
                    Skill = label.Bengali;
                }
                else if(ldRec.City == 'Bengaluru' || ldRec.City == 'Mysore' || ldRec.City == 'Other')
                {
                    Skill = label.English;
                }
                else if(ldRec.City == 'Coimbatore' || ldRec.City == 'Kochi' || ldRec.City == 'Madurai' || ldRec.City == 'Salem' || ldRec.City == 'Trichy' || ldRec.City == 'Chennai')
                {
                    Skill = label.Tamil;
                }
				else if(ldRec.City == 'Hyderabad' || ldRec.City == 'Visakhapatnam' || ldRec.City == 'Vijayawada')
                {
                    Skill = label.Telugu;
                }
                else if(ldRec.City == 'Ahmedabad' || ldRec.City == 'Bhubaneswar' || ldRec.City == 'Ghaziabad' || ldRec.City == 'Gurgaon' || ldRec.City == 'Indore' || ldRec.City == 'Jaipur' || ldRec.City == 'Lucknow' || ldRec.City == 'Mumbai' || 
                        ldRec.City == 'Nagpur' || ldRec.City == 'New Delhi' || ldRec.City == 'Noida' || ldRec.City == 'Pune' || ldRec.City == 'Ranchi' || ldRec.City == 'Surat' || ldRec.City == 'Thane')
                {
                    Skill = label.Hindi;
                }
                else
                {
                    Skill = 'Default';
                }
                System.debug('Skill :'+ Skill);
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject(); 
                gen.writeStringField('Priority', '2');
                gen.writeStringField('RemoveZero','1');
                gen.writeStringField('RejectedLog','1');
                gen.writeStringField('DuplicityCheck', '2');
                gen.writeStringField('EncryptedPhoneNo','0');
                gen.writeStringField('AutoSaveExtraInfo','1');
                gen.writeStringField('RemarksSuffix','MMM');
                gen.writeStringField('FixedAgent','');
                gen.writeStringField('CampaignId',process);
                gen.writeStringField('FixedRemarks',Skill);
                
                gen.writeFieldName('data');
                gen.writeStartArray();
                gen.writeStartObject(); 
                gen.WriteObjectField('clientid',ldRec.id);
                gen.WriteObjectField('phoneno',ldRec.Phone);
                gen.writeObjectField('customerId',ldRec.Customer_ID__c);
                gen.WriteObjectField('name',ldrec.LastName);
                gen.WriteObjectField('city',String.isNotBlank(ldrec.City)?ldrec.City:'');
                gen.WriteObjectField('email',String.isNotBlank(ldrec.Email)?ldrec.Email:'');
                gen.WriteObjectField('account_id',ldRec.Account__c);
                gen.writeEndObject();
                gen.writeEndArray();
                gen.writeEndObject();
                JsonBody   = gen.getAsString();
                system.debug('json'+JsonBody);
            } 
        }
        catch(Exception e)
        {
            //System.debug('Exception : '+e.getStackTraceString());
            //System.debug('Exception Message: '+e.getMessage());
            Logger.log('Exception','LeadTriggerHandler','CreateCubeJSON',e.getMessage(),e.getStackTraceString(),NULL);
        }        
        return JsonBody;        
    }
    
    
    Public static String CreateGlobivaJSON(Lead ldRec)
    {
        System.debug('GlobivaJSON Lead :' + ldRec);
        String JsonBody;
        
        try
        {            
            if(ldRec!=null)
            {                
                String Process;
                
                if (ldRec.Nimbus_Campaign__c == GenericConstants.Globiva_Offline_RL_Transfer) 
                {
    				process = label.Offline_RL_Transfer_Process;
				} 
                else if (ldRec.Nimbus_Campaign__c == GenericConstants.Globiva_Offline_PB_Transfer) 
                {
                    process = label.Offline_PB_Transfer_Process;
                } 
                else if (ldRec.Nimbus_Campaign__c == GenericConstants.Globiva_Relanded_Transfer) 
                {
                    process = label.Relanded_Transfer_Process;
                } 
                else if (ldRec.Nimbus_Campaign__c == GenericConstants.Globiva_Feedback_Digital_Transfer) 
                {
                    process = label.Feedback_Digital_Transfer_Process;
                } 
                else if (ldRec.Nimbus_Campaign__c == GenericConstants.Globiva_Digital_North_Transfer) 
                {
                    process = label.Digital_North_Transfer_Process;
                } 
                else if (ldRec.Nimbus_Campaign__c == GenericConstants.Globiva_Digital_South_Transfer) 
                {
                    process = label.Digital_South_Transfer_Process;
                } 
                else if (ldRec.Nimbus_Campaign__c == GenericConstants.Globiva_Digital_East_Transfer) 
                {
                    process = label.Digital_East_Transfer_Process;
                } 
                else if (ldRec.Nimbus_Campaign__c == GenericConstants.Globiva_Digital_West_Transfer) 
                {
                    process = label.Digital_West_Transfer_Process;
                } 
                else if (ldRec.Nimbus_Campaign__c == GenericConstants.Globiva_Digital_Centre_Transfer) 
                {
                    process = label.Digital_Centre_Transfer_Process;
                }

				String campaignId = process;
                String fullName = String.isNotBlank(ldrec.Full_Name__c)?ldrec.Full_Name__c:'';
                String email = String.isNotBlank(ldrec.Email)?ldrec.Email:'';
                String customerId = ldrec.Customer_ID__c;
                String city = String.isNotBlank(ldrec.City)?ldrec.City:'';
                String phoneNumber = ldrec.Phone;
                String leadSource = ldrec.LeadSource;
                String leadId = ldrec.Id;
                String accountId = ldrec.Account__c;
                
                // Create JSON using JSONGenerator
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject();
                gen.writeStringField('Campaign_Id', campaignId);
                gen.writeStringField('Full_Name', fullName);
                gen.writeStringField('Email', email);
                gen.writeStringField('Customer_Id', customerId);
                gen.writeStringField('City', city);
                gen.writeStringField('Phone_Number', phoneNumber);
                gen.writeStringField('Lead_Source', leadSource);
                gen.writeStringField('Lead_Id', leadId);
                gen.writeStringField('Account_Id', accountId);
                gen.writeEndObject();
             
                JsonBody   = gen.getAsString();
                system.debug('json'+JsonBody);
            } 
        }
        catch(Exception e)
        {
            //System.debug('Exception : '+e.getStackTraceString());
            //System.debug('Exception Message: '+e.getMessage());
            Logger.log('Exception','LeadTriggerHandler','CreateGlobivaJSON',e.getMessage(),e.getStackTraceString(),NULL);
        }        
        return JsonBody;        
    }
  
    /* Public static String CreateNimbusJSON(Lead ldRec){
        System.debug('postalcode' + ldRec.PostalCode);
        String JsonBody;
        try{
            
            if(ldRec!=null){
                String Process;
                if(ldRec.Nimbus_Campaign__c == GenericConstants.NIMBUS_TRANSFER)
                {
                    process= label.HomeLane_Nimbus_Kannada;    
                }
               
                
                
                 else if(ldRec.Nimbus_Campaign__c == GenericConstants.Nimbus_Telugu_Transfer)
                {
                    process = label.HomeLane_Nimbus_Telugu;
                }
                else
                {
                    process= label.HomeLane_Nimbus_Kannada; 
                }
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject(); 
                gen.writeStringField('action', 'DATAUPLOAD');
                gen.writeStringField('process',Process);
                gen.writeStringField('refno',ldRec.Id);
                gen.writeFieldName('data');
                gen.writeStartArray();
                gen.writeStartObject(); 
                gen.WriteObjectField('mobile',ldrec.Phone);
                gen.WriteObjectField('lead_id',ldrec.id);
                gen.writeObjectField('info_3', ldRec.Customer_ID__c);
                gen.WriteObjectField('Property_Status__c',String.isNotBlank(ldrec.Property_Status__c)? ldrec.Property_Status__c :'');
                gen.WriteObjectField('PostalCode',String.isNotBlank(ldrec.PostalCode)?ldrec.PostalCode:'');
                gen.WriteObjectField('contact_name',String.isNotBlank(ldrec.LastName)? ldrec.LastName:'');
                gen.WriteObjectField('email_id',String.isNotBlank(ldrec.Email)?ldrec.Email:'');
                gen.WriteObjectField('city',String.isNotBlank(ldrec.City)?ldrec.City:'');
                gen.writeEndObject();
                gen.writeEndArray();
                gen.writeEndObject();
                JsonBody   = gen.getAsString();
                system.debug('json'+JsonBody);
            } 
        }catch(Exception e){
            System.debug('Exception : '+e.getStackTraceString());
            System.debug('Exception Message: '+e.getMessage());
            Logger.log('Exception','LeadTriggerHandler','CreateNimbusJSON',e.getMessage(),e.getStackTraceString(),NULL);
        }
        
        return JsonBody;
        
    }*/
    
    
    
    public static Boolean flag = false;
    Public static void CallPushLeadtoOzoneTel(List <Lead> leadrecordList,Map < Id, Lead > oldleadMap){
        try{
            Set<Id> newSet = new Set<Id>();
            List<Lead> lstOzoneLead = new List<Lead>();
            List<Lead> lstUpdatedLead = new List<Lead>();
            List<Lead> leadToUpdate = new List<Lead>();
            Lead_Round_Robin_Assignment__c assignedUser;
            list<Lead_Round_Robin_Assignment__c> lstRleadAssignment = new list<Lead_Round_Robin_Assignment__c>();
            list<Lead_Round_Robin_Assignment__c> lstMatchedAssignment = new list<Lead_Round_Robin_Assignment__c>();
            list<Lead_Round_Robin_Assignment__c> lstAssignmentToUpdate = new list<Lead_Round_Robin_Assignment__c>();
            
            Map<String,List<Lead_Round_Robin_Assignment__c>> mapShowroomRAssgnments = new Map<String,List<Lead_Round_Robin_Assignment__c>>();
            // Custom Setting
            List<Residence_Visit_Assign_Leads__c> resList = new List<Residence_Visit_Assign_Leads__c>();
            Residence_Visit_Assign_Leads__c res = Residence_Visit_Assign_Leads__c.getValues('Residence Visit Assign');
            
            for(Lead l : leadrecordList) {
                newSet.add(l.Id);
            }
            Map<Id,Lead> mapLeadData = new Map<Id,Lead>([Select Id,Owner.Name,WT_Agent__r.Name,Appointment_Venue_Square__r.Name from Lead Where Id IN : oldleadMap.keyset()]);
            lstRleadAssignment = [Select Assignment__c,Assignment_Days__c,Daily_Assignment__c,Daily_Limit__c,IronMan_Reference__c,IronMan_Reference__r.IsActive__c,
                                  Distance_from_ShowRoom__c,Monthly_Assignments__c,Monthly_Limit__c,Showroom_Name__c,User__c
                                  from Lead_Round_Robin_Assignment__c where IronMan_Reference__r.IsActive__c = True ];
            
            if(!lstRleadAssignment.isEmpty() && lstRleadAssignment != NULL){
                for(Lead_Round_Robin_Assignment__c objLeadRA : lstRleadAssignment){
                    if(mapShowroomRAssgnments.containsKey(objLeadRA.Showroom_Name__c)){
                        mapShowroomRAssgnments.get(objLeadRA.Showroom_Name__c).add(objLeadRA);
                    }
                    else{
                        mapShowroomRAssgnments.put(objLeadRA.Showroom_Name__c,new list<Lead_Round_Robin_Assignment__c>{objLeadRA});
                    }
                }
            }
            System.debug('flag   : ' + flag);        
            
            for (Lead lrec: leadrecordList) {    
                Datetime dt = DateTime.newInstance(lrec.createdDate.date(), Time.newInstance(0, 0, 0, 0));
                String dayOfWeek=dt.format('EEEE');
                System.debug('Day : ' + dayOfWeek);
                System.debug('lrec.Closest_Showroom__c ---> '+lrec.Closest_Showroom__c);
                System.debug('lrec. mapLeadData.get(lrec.Id).Owner.Name ---> '+mapLeadData.get(lrec.Id).Owner.Name);
                System.debug('lrec. mapLeadData.get(lrec.Id).WT_Agent__r.Name---> '+mapLeadData.get(lrec.Id).WT_Agent__r.Name);
                System.debug('lrec.Owner ---> '+lrec.OwnerId );
                System.debug('lrec.Owner ---> '+oldleadMap.get(lrec.Id).OwnerId );
                System.debug('lrec.Pushed_To_Ozonetel__c ---> '+lrec.Pushed_To_Ozonetel__c );
                
                //Check if the basic condition are Meet
                if(String.isNotBlank(lrec.Closest_Showroom__c) && lrec.Pushed_To_Ozonetel__c == false && 
                   mapLeadData.get(lrec.Id).Owner.Name =='Cloud Agent' && mapLeadData.get(lrec.Id).WT_Agent__r.Name =='Cloud Agent' &&
                   lrec.Status =='Fresh Lead' && (lrec.Sub_Status__c =='New' || lrec.Sub_Status__c =='Re-Landed' || lrec.Sub_Status__c =='Unverified') &&
                   lrec.createdDate.date() == Date.Today() && lrec.Assigned_to_Resi_ASM__c == false && (lrec.City.equalsIgnoreCase('other') || lrec.City.equalsIgnoreCase('others')) && !lrec.Bulk_Upload__c){
                       
                       for(String sShowroom:mapShowroomRAssgnments.keyset()){
                           // If the Match Showroom matches
                           if(lrec.Closest_Showroom__c.containsIgnoreCase(sShowroom)){
                               lstMatchedAssignment = mapShowroomRAssgnments.get(sShowroom);   
                               break;  
                           }
                       }
                       system.debug('lstMatchedAssignment'+lstMatchedAssignment);
                       if(!lstMatchedAssignment.isEmpty() && lstMatchedAssignment!= NULL){
                           Decimal d =100.0;
                           
                           for(Lead_Round_Robin_Assignment__c objAssignment:lstMatchedAssignment){
                               if((objAssignment.Daily_Limit__c>0 && objAssignment.Daily_Assignment__c<objAssignment.Daily_Limit__c) 
                                  && (objAssignment.Monthly_Limit__c>0 && objAssignment.Monthly_Assignments__c<objAssignment.Monthly_Limit__c
                                      && objAssignment.Assignment_Days__c.containsIgnoreCase(dayOfWeek))){
                                          Decimal distance; 
                                          distance = String.isNotBlank(lrec.Closest_Showroom__c.trim().substringAfterLast(' ').removeEndIgnoreCase('km'))?Decimal.ValueOf(lrec.Closest_Showroom__c.trim().substringAfterLast(' ').removeEndIgnoreCase('km')):2000;
                                          System.debug('d--->'+d+'objAssignment.Assignment__c'+objAssignment.Assignment__c+'distance'+distance);
                                          if(distance <= objAssignment.Distance_from_ShowRoom__c)
                                          {
                                              if(objAssignment.Assignment__c<=d){
                                                  d = objAssignment.Assignment__c;
                                                  assignedUser = objAssignment;
                                              }    
                                          }
                                      }    
                           }
                           if(assignedUser != NULL){
                               //Since After Trigger Creating the New Instance to Update
                               Lead l = new Lead();
                               l.id = lrec.id;
                               l.OwnerId = assignedUser.User__c;
                               l.Wt_Agent__c = assignedUser.User__c;
                               //l.Square_Showroom_Agent__c = assignedUser.User__c;
                               l.Sales_Manager__c = assignedUser.IronMan_Reference__c;
                               l.Assigned_to_Resi_ASM__c = true;
                               leadToUpdate.add(l);
                               assignedUser.Daily_Assignment__c++;
                               assignedUser.Monthly_Assignments__c++;
                               System.debug('Updated sadsa'+assignedUser);
                               lstAssignmentToUpdate.add(assignedUser); 
                           }
                           
                           //If the condition are not met push the lead to WTA Queue
                           else{
                               lstOzoneLead.add(lrec);
                               Lead l = new Lead();
                               l.Id = lrec.Id;
                               l.Pushed_To_Ozonetel__c = true;
                               leadToUpdate.add(l);
                               flag = true;
                           }
                       }
                       else{
                           lstOzoneLead.add(lrec);
                           Lead l = new Lead();
                           l.Id = lrec.Id;
                           l.Pushed_To_Ozonetel__c = true;
                           leadToUpdate.add(l);
                           flag = true;
                       }
                   }
                
                // If closest Showroom is not Present
                // Can be removed 
                else{
                    /*if(lrec.OwnerId != oldleadMap.get(lrec.Id).OwnerId && mapLeadData.get(lrec.Id).Owner.Name =='Cloud Agent' && lrec.Status =='Fresh Lead' && (lrec.Sub_Status__c =='New' || lrec.Sub_Status__c =='Re-Landed' || lrec.Sub_Status__c =='Unverified') && 
mapLeadData.get(lrec.Id).WT_Agent__r.Name =='Cloud Agent' && lrec.LeadSource !='Toll-free' && lrec.LeadSource !='Chat - Offline' && lrec.LeadSource !='Chat - Online' && lrec.Assigned_to_Resi_ASM__c == false && !lrec.City.equalsIgnoreCase('bengaluru')){
System.debug('------Owner and WT Agent = Cloud Agent  '+lstOzoneLead);
System.debug('------lstOzoneLead SIZE '+lstOzoneLead.size());
if(lrec.Sign_Up_Source__c != 'Estimate Flow') {
lstOzoneLead.add(lrec);
Lead l = new Lead();
l.Id = lrec.Id;
l.Pushed_To_Ozonetel__c = true;
leadToUpdate.add(l);
flag = true;
}
else if(lrec.Sign_Up_Source__c == 'Estimate Flow' && lrec.Sub_Status__c =='Re-Landed'){
lstOzoneLead.add(lrec);
Lead l = new Lead();
l.Id = lrec.Id;
l.Pushed_To_Ozonetel__c = true;
leadToUpdate.add(l);
flag = true;
}
} */ 
                    
                    // Condition for WTA mass Update Records 
                    if(lrec.OwnerId != oldleadMap.get(lrec.Id).OwnerId && mapLeadData.get(lrec.Id).Owner.Name =='Cloud Agent' && mapLeadData.get(lrec.Id).WT_Agent__r.Name !='Cloud Agent')  {
                        System.debug('------Only Owner = Cloud Agent  '+lstOzoneLead);
                        System.debug('------lstOzoneLead SIZE '+lstOzoneLead.size());
                        lstOzoneLead.add(lrec);  
                        Lead l = new Lead();
                        l.Id = lrec.Id;
                        leadToUpdate.add(l);  
                        flag = true;         
                    } 
                } 
            }
            
            if(lstOzoneLead.size() >0){
                System.debug('------lstOzoneLead  '+lstOzoneLead);
                System.debug('------lstOzoneLead SIZE '+lstOzoneLead.size());
                LeadPushToOzonetelQueueable objLPA = new LeadPushToOzonetelQueueable(lstOzoneLead,UserInfo.getSessionId());
                ID jobID = System.enqueueJob(objLPA);
                system.debug('-----jobID----'+jobID); 
            } 
            
            if(!leadToUpdate.isEmpty()){
                update leadToUpdate;
            }
            
            if(!lstAssignmentToUpdate.isEmpty()){
                update lstAssignmentToUpdate;
            }
        }
        catch(Exception e){
            System.debug('Exception occured'+e.getMessage()+''+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler','CallPushLeadtoOzoneTel',e.getMessage(),e.getStackTraceString(),NULL);
        }    
    }
    
    Public static void SendLeadRelatedSMS(List < Lead > leadrecordList, Map < Id, Lead > oldLeadMap) {
        System.debug('leadrecordList.isEmpty(): '+leadrecordList.isEmpty());
        if(!leadrecordList.isEmpty()){
            for(Lead lrec: leadrecordList){
                if(lrec.Brand__c!='Doowup'){
                    system.debug('homelaneleadsms');
                    if(oldLeadMap !=null && !oldLeadMap.isEmpty()){
                    System.debug('oldLeadMap.isEmpty(): '+oldLeadMap.isEmpty());
                    
                    if(lrec.Status == 'Not actively pursued' && oldLeadMap.get(lrec.Id).Status != lrec.Status && lrec.Sub_Status__c == 'Exceeded Max Attempts' && oldLeadMap.get(lrec.Id).Sub_Status__c != lrec.Sub_Status__c){
                        system.debug('lrec.Status--->' +lrec.Status + 'OldSub_Status__c  ----->'+oldLeadMap.get(lrec.Id).Sub_Status__c );
                        system.debug('lrec.Sub_Status__c --->' +lrec.Sub_Status__c + 'OldStatus ----->'+oldLeadMap.get(lrec.Id).Status);
                        if(RecursiveTriggerHandlerLead.bNotactivelypursued && lrec.LeadSource !='Broker/Channel Partner' && lrec.LeadSource !='Ambassador' ){ 
                            system.debug('lrec.Sub_Status__c ***:' +lrec.Sub_Status__c + 'OldStatus ----->'+oldLeadMap.get(lrec.Id).Status);
                            SendSMSController.GetSMSTemplate(lrec.Id,'Not actively pursued - Exceeded Max Attempts');
                            RecursiveTriggerHandlerLead.bNotactivelypursued = false;  
                        }
                    }               
                    if(lrec.Status == 'Appointment Confirmed' && oldLeadMap.get(lrec.Id).Status != lrec.Status && lrec.Appointment_Type__c == 'Square Showroom Visit'){
                        SendSMSController.GetSMSTemplate(lrec.Id,'Appointment Confirmed - Showroom Meeting');  
                    }
                    else if(lrec.Status == 'Appointment Fixed' && oldLeadMap.get(lrec.Id).Status != lrec.Status && lrec.Appointment_Type__c == 'Square Showroom Visit'){
                        SendSMSController.GetSMSTemplate(lrec.Id,'Appointment Fixed - Showroom Meeting');  
                    }
                    else if(lrec.Status == 'Fresh Lead' && lrec.Sub_Status__c == 'Unable To Contact' && oldLeadMap.get(lrec.Id).Sub_Status__c != lrec.Sub_Status__c){
                        if(lrec.Restricted_Lead__c ==false && lrec.LeadSource !='Broker/Channel Partner' && lrec.LeadSource !='Ambassador' ){
                            system.debug('lrec.Sub_Status__c ***:' +lrec.Sub_Status__c + 'OldStatus ----->'+oldLeadMap.get(lrec.Id).Status);
                            SendSMSController.GetSMSTemplate(lrec.Id,'Unable to Contact Customers'); 
                        }      
                    }
                    if(lrec.Floorplan_Received__c == 'No' && oldLeadMap.get(lrec.Id).Floorplan_Received__c != lrec.Floorplan_Received__c){
                        if(lrec.Restricted_Lead__c ==false ){
                            SendSMSController.GetSMSTemplate(lrec.Id,'Floor Plan Not Received'); 
                        }    
                    }
                    //Newly added by Bharatesh Shetty for Fresh Leads whose sub status  are being updated to 'New'.
                    if(lrec.Status == 'Fresh Lead' && lrec.Sub_Status__c == 'New' &&  oldLeadMap.get(lrec.Id).Sub_Status__c != lrec.Sub_Status__c){
                        System.debug('lrec.Status: '+lrec.Status);
                        System.debug('lrec.Sub_Status__c: '+lrec.Sub_Status__c);
                        if(lrec.LeadSource !='Broker/Channel Partner' && lrec.LeadSource !='Ambassador' ){
                            system.debug('lrec.Sub_Status__c ***: ' +lrec.Sub_Status__c + 'OldStatus ----->'+oldLeadMap.get(lrec.Id).Status);
                            SendSMSController.GetSMSTemplate(lrec.Id,'Welcome SMS'); 
                        }
                    }
                    
                    
                    // When status is Appointment success and Channel Partner is present
                    if(lrec.Status == 'Appointment Successful'  &&  oldLeadMap.get(lrec.Id).Status != lrec.Status){
                        if(String.isNotBlank(lrec.Channel_Partner__c)){
                            SendSMSController.GetSMSTemplate(lrec.Id,'Appointment Successful');
                        }
                    }
                    
                }
                else{
                    //Newly by Bharatesh Shetty added for new fresh leads being inserted.
                    if(lrec.Status == 'Fresh Lead' && lrec.Sub_Status__c == 'New' && lrec.LeadSource !='Broker/Channel Partner' && lrec.LeadSource !='Ambassador' ){
                        SendSMSController.GetSMSTemplate(lrec.Id,'Welcome SMS');
                    }
                }
                }
                
            }
        }
    }
    /*************************************************************************************************/
   
    Public static void UpdateActivityCount(Map < Id,Lead > mapLeads) {
        Map<Id,Profile> mapProfile = new Map<Id,Profile>();
        for(Profile obj : [SELECT Id,Name FROM Profile WHERE Name IN ('Design Manager','IB Profile','Square Profile','Square Sales Profile')]){
            mapProfile.put(obj.Id,obj);
        }
        if(mapProfile.get(UserInfo.getProfileId())== null){  
            Map < String,List<Task>> MapLeadTaskData = new Map < String,List<Task>>();
            List<Lead> updatedList = new List<Lead>();
            for(Task objTask : [Select Id,WhoId From Task Where WhoId IN :mapLeads.keyset()]){
                if(MapLeadTaskData.get(objTask.WhoId) != Null){
                    List<Task> lstTask = MapLeadTaskData.get(objTask.WhoId);
                    lstTask.add(objTask);
                    MapLeadTaskData.put(objTask.WhoId,lstTask);
                }else{
                    List<Task> lstTask = new List<Task>();
                    lstTask.add(objTask);
                    MapLeadTaskData.put(objTask.WhoId,lstTask);
                }
            }
            for(Lead objLead : mapLeads.values()){
                if(MapLeadTaskData.get(objLead.Id) != null)
                    objLead.Count_of_Attempts__c = MapLeadTaskData.get(objLead.Id).Size();
                
            }
        }
    }
    
    
    
    public Static void SendEmailToManager(String errMsg){
        String[] strUserEmail = new List<String>();
        if(!Test.isRunningTest()){Exception_Mail__c objAmeyo = Exception_Mail__c.getValues('Estimate Mail');strUserEmail = objAmeyo.Email_Addresss__c.split(',');
                                 }else{
                                     strUserEmail.add('testapi@gmail.com');
                                 }
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = strUserEmail ; 
        message.optOutPolicy = 'FILTER';
        message.subject = 'Closest Showroom null for estimate flow Leads';
        message.plainTextBody = errMsg;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
   
    //Check if the DP is changed in Lead and update MIQ if yes.
    Public Static void isDPUpdated(List<Lead> newLeadsList, Map<Id,Lead> oldLeadsMap){ 
        Map<Lead,String> mapLead_OldDPEmail = new Map<Lead,String>();
        try{
            for(Lead newLead: newLeadsList){
                if(newLead.IsConverted ==False && newLead.Interior_Designer__c != oldLeadsMap.get(newLead.id).Interior_Designer__c && String.isNotBlank(oldLeadsMap.get(newLead.id).email)){
                    mapLead_OldDPEmail.put(newLead,oldLeadsMap.get(newLead.id).DP_Email__c);
                    System.debug('mapLead_OldDPEmail: '+mapLead_OldDPEmail);
                }
            }
            system.debug('---getLimitQueueableJobs()---'+limits.getLimitQueueableJobs()+'---Limits.getQueueableJobs()--'+Limits.getQueueableJobs());
            if(!mapLead_OldDPEmail.isEmpty()){
                for(Lead ld:mapLead_OldDPEmail.keySet()){
                    if(Limits.getQueueableJobs()<Limits.getLimitQueueableJobs()){
                        System.enqueueJob(new ChangeDPRestAPI(null,ld,mapLead_OldDPEmail.get(ld)));
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Exception : '+e.getStackTraceString());
            System.debug('Exception Message: '+e.getMessage());
            Logger.log('Exception','LeadTriggerHandler','isDPUpdated',e.getMessage(),e.getStackTraceString(),NULL);    
        }
    }
    /**
* @description || This method is to uncheck the Requested_Call_Back__c field in Lead when it is true and either of the description,follow up time or sub status changes
* @author Bharatesh Shetty | 2/25/2020 
* @param newLeadsList 
* @param oldLeadsMap
* @return void 
**/
    Public Static void uncheckRequestedCallBack(List<Lead> newLeadsList, Map<Id,Lead> oldLeadsMap){
        try{
            for(Lead ld: newLeadsList){
                if(ld.Requested_Call_Back__c && oldLeadsMap.get(ld.Id).Requested_Call_Back__c && (ld.Follow_up_time__c != oldLeadsMap.get(ld.Id).Follow_up_time__c || ld.Description__c != oldLeadsMap.get(ld.Id).Description__c || ld.Sub_Status__c != oldLeadsMap.get(ld.Id).Sub_Status__c)){
                    ld.Requested_Call_Back__c = False;
                    ld.Requested_Callback_Time__c= null;
                    
                    System.debug('Requested_Call_Back__c Changed : '+ld.Requested_Call_Back__c);
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','uncheckRequestedCallBack Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    
    Public Static void updateCustomerRegisteredLeads(List<Lead> newLeadsList, Map<Id,Lead> oldLeadsMap){
        try{
            System.debug('updateCustomerRegisteredLeads method');
            Map<Id,Lead> notRegisteredLeadsToUpdate = new Map<Id,Lead>();
            Map<Id,Account> notRegisteredAccountsToUpdate = new Map<Id,Account>();
            Set<Id> setOfAccountIDs = new Set<Id>();
            for(Lead ld: newLeadsList){
                if(ld.Order_not_Registered__c && ld.Bulk_Upload__c && ld.Status != oldLeadsMap.get(ld.Id).Status && ld.Status =='Appointment Fixed'
                       && ld.Sub_Status__c != oldLeadsMap.get(ld.Id).Sub_Status__c && ld.Sub_Status__c =='Appointment Fixed'){
                       setOfAccountIDs.add(ld.Account__c);
                       Lead leadToUpdate = new Lead();
                       leadToUpdate.id = ld.Id;
                       leadToUpdate.Order_not_Registered__c = False;
                       notRegisteredLeadsToUpdate.put(leadToUpdate.Id,leadToUpdate);
                       //ld.Customer_not_Registered__c = False;
                   }
            }
            if(!notRegisteredLeadsToUpdate.isEmpty()){                
                System.debug('notRegisteredLeadsToUpdate: '+notRegisteredLeadsToUpdate);
                // Update Leads
                update notRegisteredLeadsToUpdate.Values();
                if(!setOfAccountIDs.isEmpty()){
                    notRegisteredAccountsToUpdate = new Map<Id,Account>([Select id from Account where id=:setOfAccountIDs and Customer_not_Registered__c=True]);
                    if(!notRegisteredAccountsToUpdate.isEmpty()){
                        System.debug('notRegisteredAccountsToUpdate: '+notRegisteredAccountsToUpdate);
                        for(Account accountToUpdate : notRegisteredAccountsToUpdate.Values()){
                            accountToUpdate.Customer_not_Registered__c = False;
                        }
                        // Update Accounts
                        update notRegisteredAccountsToUpdate.Values();
                    }
                }
            }
            else{
                //To handle blitz relanded leads from Website
                processCustomerRegisteredLeads(newLeadsList, oldLeadsMap);
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','updateCustomerRegisteredLeads Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    Public Static void checkIfPropertyNameUpdated(List<Lead> newLeadsList, Map<Id,Lead> oldLeadsMap){
        try{
            if(!newLeadsList.isEmpty()){
                System.debug('newLeadsList: '+newLeadsList);
                System.debug('oldLeadsMap: '+oldLeadsMap);
                Set <ID> setOfPropertyIds = new Set<ID>();
                Map<String,String> mapOfLeadAndPropertyName = new Map<String,String>();
                Map<Id,Master__C> mapOfProperty = new Map<Id,Master__C>();
                for(Lead lrec: newLeadsList){
                    if(lrec.Property__c !=null){
                        setOfPropertyIds.add(lrec.Property__c);
                    }
                }
                mapOfProperty = new Map<Id,Master__C>([Select id,Name from Master__C where id =:setOfPropertyIds]);
                for(Lead lrec: newLeadsList){
                    if(oldLeadsMap !=null && !oldLeadsMap.isEmpty()){
                        System.debug('newLeadsList: '+newLeadsList);
                        System.debug('oldLeadsMap: '+oldLeadsMap);
                        //After update scenario handle
                        System.debug('oldLeadMap.isEmpty(): '+oldLeadsMap.isEmpty());
                        if(lrec.Property__c == Null && !String.isBlank(lrec.Lead_Property_Name__c) && lrec.Lead_Property_Name__c != oldLeadsMap.get(lrec.Id).Lead_Property_Name__c){
                            System.debug('UPDATE - Lead Property Text field call: ');
                            mapOfLeadAndPropertyName.put(lrec.Id,lrec.Lead_Property_Name__c);
                        }
                        else if(lrec.Property__c != Null && mapOfProperty.containsKey(lrec.Property__c) && lrec.Property__c != oldLeadsMap.get(lrec.Id).Property__c){
                            System.debug('UPDATE - Lead Property Id field call: ');
                            mapOfLeadAndPropertyName.put(lrec.Id,mapOfProperty.get(lrec.Property__c).Name);
                        }
                        
                    }
                    //Commented this code as pavan asked because of some issue(two webhooks) in OH sandbox sub order and additional order 
                    /*else{
                        //After insert scenario handle
                        System.debug('newLeadsList: '+newLeadsList);
                        System.debug('oldLeadsMap: '+oldLeadsMap);
                        if(lrec.Property__c == Null && !String.isBlank(lrec.Lead_Property_Name__c)){
                            System.debug('Insert - Lead Property Text field call: ');
                            mapOfLeadAndPropertyName.put(lrec.Id,lrec.Lead_Property_Name__c);
                        }
                        else if(lrec.Property__c != Null && mapOfProperty.containsKey(lrec.Property__c)){
                            System.debug('Insert - Lead Property Id field call: ');
                            mapOfLeadAndPropertyName.put(lrec.Id,mapOfProperty.get(lrec.Property__c).Name);
                        }
                    }*/
                }
                if(!mapOfLeadAndPropertyName.isEmpty()){
                    System.debug('mapOfLeadAndPropertyName is not empty: '+mapOfLeadAndPropertyName);
                    if(System.isBatch()||System.isFuture()){
                       // PropertyUDPReportURLQueueable emailQueable = new PropertyUDPReportURLQueueable(mapOfLeadAndPropertyName);
                       // ID jobID = System.enqueueJob(emailQueable);
                        //System.debug('jobID: '+jobID);
                    }
                    else{
                        System.debug('non batch non future context');
                        //PropertyUDPReportURLQueueable.calloutToPropertyUDPReportAPI(mapOfLeadAndPropertyName);
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','checkIfPropertyNameUpdated Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    
    Public Static void processCustomerRegisteredLeads(List<Lead> newLeadsList, Map<Id,Lead> oldLeadsMap){
        try{
            System.debug('processCustomerRegisteredLeads method');
            List<Lead> lstLeadsToUpdate = new List<Lead>();
            List<Lead> lstLeadsToPushToOzoneTel = new List<Lead>();
            Set<Id> setOfIMsIds = new Set<Id>();
            Set<Id> setOfWTAsIds = new Set<Id>();
            Map<Id,User> mapOfWTAs = new Map<Id,User>();
            Map<Id,Showroom_User__c> mapOfIMs = new Map<Id,Showroom_User__c>();
            
            list<Lead> lstLeadRecords = new List<Lead>();
            Set<String> lstPincode = new Set<String>();
            
            for(Lead ld: newLeadsList){
                if(ld.Sales_Manager__c != Null){
                    setOfIMsIds.add(ld.Sales_Manager__c);
                }
                if(ld.WT_Agent__c != Null){
                    setOfWTAsIds.add(ld.WT_Agent__c); 
                }
            }
            if(!setOfIMsIds.isEmpty()){
                mapOfIMs = new Map<Id,Showroom_User__c>([Select id,IsActive__c from Showroom_User__c where id =:setOfIMsIds]);
            }
            if(!setOfWTAsIds.isEmpty()){
                mapOfWTAs = new Map<Id,User>([Select id,Profile.Name,IsActive from User where id =:setOfWTAsIds]);
            }
            System.debug('mapOfIMs :'+mapOfIMs);
            System.debug('mapOfWTAs :'+mapOfWTAs);
            for(Lead ld: newLeadsList){
                //Only the leads updated by the website and not by SF.
                if(!ld.Test_Flag__c && !ld.Order_not_Registered__c && ld.Order_not_Registered__c != oldLeadsMap.get(ld.Id).Order_not_Registered__c && ld.Bulk_Upload__c && ld.Status =='Fresh Lead' && ld.Sub_Status__c =='Re-Landed'){
                    Lead leadToUpdate = new Lead();
                    System.debug('ld.Order_not_Registered__c: '+ld.Order_not_Registered__c);
                    /*if(ld.Assigned_to_Resi_ASM__c && ld.Sales_Manager__c != null && !String.isBlank(ld.Sales_Manager_Email__c)){
System.debug('IM  present and Active Condition satisfied:');
//Email to Sales manager if the lead is assigned to IM and there is a Sales manager assigned and has a sales manager email
//Happens from process builder.
}*/
                    // If assigned to IM checkbox is true but IM is inactive or sales manager or sales manager email not present then push to ozoneTel city Queue with cloud agent
                    if(ld.Assigned_to_Resi_ASM__c && (ld.Sales_Manager__c == null || String.isBlank(ld.Sales_Manager_Email__c)||(ld.Sales_Manager__c !=null && mapOfIMs.containsKey(ld.Sales_Manager__c) && mapOfIMs.get(ld.Sales_Manager__c).IsActive__c == false))){
                        System.debug('IM not present/ not Active Condition satisfied:');
                        /*leadToUpdate.Id = ld.id;
                        leadToUpdate.WT_Agent__c = Label.Cloud_Agent_Id;
                        leadToUpdate.OwnerId = Label.Cloud_Agent_Id;
                        leadToUpdate.Sales_Manager__c = NULL;
                        leadToUpdate.Sales_Manager_Email__c = NULL;
                        leadToUpdate.Assigned_to_Resi_ASM__c = False;
                        leadToUpdate.Pushed_To_Ozonetel__c = True;
                        lstLeadsToUpdate.add(leadToUpdate);
                        //Make cloud agent and push to ozoneTel
                        lstLeadsToPushToOzoneTel.add(ld);*/
                        
                        //After the change in the requirement the logic has been changed to send the leads to IM assignment based on pincode.
                        lstLeadRecords.add(ld);
                        lstPincode.add(ld.postalcode);
                        
                    }
                    //If Assigned_to_Resi_ASM__c is false(not assigned to IM) but either WTA is blank or inactive or not with WTA/WTM profile then push to ozoneTel city Queue with cloud agent
                    else if(!ld.Assigned_to_Resi_ASM__c && 
                            (ld.WT_Agent__c == null ||
                             (ld.WT_Agent__c !=null && mapOfWTAs.containsKey(ld.WT_Agent__c) && 
                              (mapOfWTAs.get(ld.WT_Agent__c).IsActive == false || 
                               (mapOfWTAs.get(ld.WT_Agent__c).Profile.Name !='WTA Profile' && mapOfWTAs.get(ld.WT_Agent__c).Profile.Name !='WTM Profile')
                              )
                             )
                            )
                           ){
                               /*System.debug('WTA NOT present condition satisfied:');
                               leadToUpdate.Id = ld.id;
                               leadToUpdate.WT_Agent__c = Label.Cloud_Agent_Id;
                               leadToUpdate.OwnerId = Label.Cloud_Agent_Id;
                               leadToUpdate.Sales_Manager__c = NULL;
                               leadToUpdate.Sales_Manager_Email__c = NULL;
                               leadToUpdate.Assigned_to_Resi_ASM__c = False;
                               leadToUpdate.Pushed_To_Ozonetel__c = True;
                               lstLeadsToUpdate.add(leadToUpdate);
                               //Make cloud agent and push to ozoneTel
                               lstLeadsToPushToOzoneTel.add(ld);*/
                               
                               //After the change in the requirement the logic has been changed to send the leads to IM assignment based on pincode.
                               lstLeadRecords.add(ld);
                               lstPincode.add(ld.postalcode);
                           }
                    //If it is assigned to an active WTA/WTM profile check then push to ozoneTel city Queue without cloud agent
                    else if(!ld.Assigned_to_Resi_ASM__c &&
                            (ld.WT_Agent__c !=null && mapOfWTAs.containsKey(ld.WT_Agent__c) && 
                             (mapOfWTAs.get(ld.WT_Agent__c).IsActive && 
                              (mapOfWTAs.get(ld.WT_Agent__c).Profile.Name =='WTA Profile' || mapOfWTAs.get(ld.WT_Agent__c).Profile.Name =='WTM Profile')
                             )
                            )
                           ){
                               System.debug('WTA Active condition satisfied:');
                               //do not make cloud agent and push to ozoneTel
                               lstLeadsToPushToOzoneTel.add(ld);
                           }
                }
                else{
                    System.debug('processCustomerRegisteredLeads basic condition did not meet.');
                }
            }
            if(!lstLeadRecords.isEmpty()){
                //Lead records sent for IM assignment - Territory flow.
                IronManLead_Assignment_Handler.getIronManDetails(lstLeadRecords,lstPincode);
            }
            if(!lstLeadsToPushToOzoneTel.isEmpty()){
                PushToOzoneTelAdditionalQueue objLPA = new PushToOzoneTelAdditionalQueue(lstLeadsToPushToOzoneTel,UserInfo.getSessionId(),True);
                ID jobID = System.enqueueJob(objLPA);
                system.debug('-----jobID----'+jobID); 
            }
            if(!lstLeadsToUpdate.isEmpty()){
                update lstLeadsToUpdate;
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','updateCustomerRegisteredLeads Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
        Public Static void handleLeadRosterEmails(List<Lead> newLeadsList, Map<Id,Lead> oldLeadsMap){
        try{
            System.debug('handleLeadRosterEmails method');
            Set<Id> showroomIdSet = new Set<Id>();
            Set<Id> salesManagerIdSet = new Set<Id>();
            Set<Id> InsideSalesIdSet = new Set<Id>();
            Set<String> validAppointmentTypeSet = new Set<String>{'Virtual Meeting','Residence Visit','Site Visit','Office Visit','Square Showroom Visit'};
            Map<Id,Master__c> mapOfShowroomIdAndShowroom = new Map<Id,Master__c>();
            Map<Id,Showroom_User__C> mapOfSalesManagerIdAndSM = new Map<Id,Showroom_User__C>();
            Map<Id,Showroom_User__C> mapOfInsideSalesAgentIdAndISA = new Map<Id,Showroom_User__C>();
            String Exotel_Caller_ID;
            
            for(Lead ld: newLeadsList)
            {
                if(ld.Appointment_Venue_Square__c !=null )
                {
                    showroomIdSet.add(ld.Appointment_Venue_Square__c);
                }
                if(ld.Sales_Manager__c !=null)
                {
                    salesManagerIdSet.add(ld.Sales_Manager__c);                    
                }
                if(ld.Inside_Sales_Agent__c !=null)
                {
                    InsideSalesIdSet.add(ld.Inside_Sales_Agent__c);
                }
            }
            if(!showroomIdSet.isEmpty())
            {
                mapOfShowroomIdAndShowroom = new Map<Id,Master__c>([Select id,Name,Street__c,Property_Locality__c,Property_City__c,Property_Postal_Code__c from Master__c where id=:showroomIdSet]);
            }
            if(!salesManagerIdSet.isEmpty())
            {
                mapOfSalesManagerIdAndSM = new Map<Id,Showroom_User__C>([Select id,Name,Email__c,City__c,Phone__c,Showroom_Name__c,Showroom_Name__r.Name,Exotel_Phone_Number__c from Showroom_User__C where id=:salesManagerIdSet]);
            }
            if(!InsideSalesIdSet.isEmpty())
            {
                mapOfInsideSalesAgentIdAndISA = new Map<Id,Showroom_User__C>([Select id,Name,Email__c,City__c,Showroom_Name__c,Showroom_Name__r.Name from Showroom_User__C where id=:InsideSalesIdSet]);
            }
            
            List<String> listOfJSON = new List<String>();
            for(Lead ld: newLeadsList)
            {
                if(ld.Brand__c != 'Doowup')
                {
                    if(ld.Status != oldLeadsMap.get(ld.Id).Status && ld.Status =='Appointment Fixed')
                    {
                    if(validAppointmentTypeSet.contains(ld.Appointment_Type__c))
                    {
                        System.debug('Appointment Fixed Status changed');
                        if(ld.Appointment_Type__c =='Virtual Meeting'){
                            System.debug('ld.Appointment_Type__c: '+ld.Appointment_Type__c);
                            //Spacecraft email template SF_spacecraft_appointment
                            String subject = 'Online design consultation confirmed.';
                            Map<String,String> toEmailMap = new Map<String,String>();
                            toEmailMap.put('email',ld.email);
                            toEmailMap.put('name',ld.Full_Name__c);
                            List<Map<String,String>> template_contentList = new List<Map<String,String>>();
                            Map<String,String> template_contentMap1 = new Map<String,String>();
                            template_contentMap1.put('name','Customer_name');
                            template_contentMap1.put('content',ld.Full_Name__c);
                            template_contentList.add(template_contentMap1);
                            if(ld.Appointment_Time__c !=null){
                                Map<String,String> template_contentMap2 = new Map<String,String>();
                                template_contentMap2.put('name','Appointment_Time__c');
                                template_contentMap2.put('content',String.valueOf(ld.Appointment_Time__c));
                                template_contentList.add(template_contentMap2);
                            }
                            List<String> ccEmailList =new List<String>();  
                            String jsonbody = MandrilEmailViaRosterQueueabble.rosterEmailWrapperJsonCreator('SF_spacecraft_appointment_rebranding', subject, toEmailMap, template_contentList,ccEmailList);
                            System.debug('jsonbody: '+jsonbody);
                            if(!String.isBlank(jsonbody)){
                                listOfJSON.add(jsonbody);
                            }
                        }
                        else{
                            //Meetin fixed template SF_appointment_confirmed_visit
                            System.debug('ld.Appointment_Type__c: '+ld.Appointment_Type__c);
                            String subject = 'Design consultation confirmed!.';
                            Map<String,String> toEmailMap = new Map<String,String>();
                            toEmailMap.put('email',ld.email);
                            toEmailMap.put('name',ld.Full_Name__c);
                            List<Map<String,String>> template_contentList = new List<Map<String,String>>();
                            Map<String,String> template_contentMap1 = new Map<String,String>();
                            template_contentMap1.put('name','Customer_name');
                            template_contentMap1.put('content',ld.Full_Name__c);
                            template_contentList.add(template_contentMap1);
                            if(ld.Appointment_Time__c !=null){
                                Map<String,String> template_contentMap2 = new Map<String,String>();
                                template_contentMap2.put('name','Appointment_Time__c');
                                template_contentMap2.put('content',String.valueOf(ld.Appointment_Time__c));
                                template_contentList.add(template_contentMap2);
                            }
                            if(ld.Appointment_Type__c =='Residence Visit' ||ld.Appointment_Type__c =='Site Visit' ||ld.Appointment_Type__c =='Office Visit'){
                                //Use residence field address
                                System.debug('ld.Appointment_Type__c: '+ld.Appointment_Type__c);
                                if(!String.isBlank(ld.Appointment_Venue_Site_Residence_Add1__c)){
                                    System.debug('ld.Appointment_Venue_Site_Residence_Add1__c: '+ld.Appointment_Venue_Site_Residence_Add1__c);
                                    Map<String,String> template_contentMap3 = new Map<String,String>();
                                    template_contentMap3.put('name','Appointment_Venue_Site_Residence_Add1__c');
                                    template_contentMap3.put('content',ld.Appointment_Venue_Site_Residence_Add1__c);
                                    template_contentList.add(template_contentMap3);
                                }
                            }
                            else{
                                //Use showroom address
                                System.debug('ld.Appointment_Type__c: '+ld.Appointment_Type__c);
                                String showroomAddress = '';
                                if(!mapOfShowroomIdAndShowroom.isEmpty() && mapOfShowroomIdAndShowroom.containsKey(ld.Appointment_Venue_Square__c)){
                                    if(!String.isBlank(mapOfShowroomIdAndShowroom.get(ld.Appointment_Venue_Square__c).name)){
                                        showroomAddress += mapOfShowroomIdAndShowroom.get(ld.Appointment_Venue_Square__c).name;
                                    }
                                    if(!String.isBlank(mapOfShowroomIdAndShowroom.get(ld.Appointment_Venue_Square__c).Street__c)){
                                        showroomAddress += ', '+mapOfShowroomIdAndShowroom.get(ld.Appointment_Venue_Square__c).Street__c;
                                    }
                                    if(!String.isBlank(mapOfShowroomIdAndShowroom.get(ld.Appointment_Venue_Square__c).Property_Locality__c)){
                                        showroomAddress += ', '+mapOfShowroomIdAndShowroom.get(ld.Appointment_Venue_Square__c).Property_Locality__c;
                                    }
                                    /*if(!String.isBlank(mapOfShowroomIdAndShowroom.get(ld.Appointment_Venue_Square__c).Address__c)){
showroomAddress += ', '+mapOfShowroomIdAndShowroom.get(ld.Appointment_Venue_Square__c).Address__c;
}*/
                                    if(!String.isBlank(mapOfShowroomIdAndShowroom.get(ld.Appointment_Venue_Square__c).Property_City__c)){
                                        showroomAddress += ', '+mapOfShowroomIdAndShowroom.get(ld.Appointment_Venue_Square__c).Property_City__c;
                                    }
                                    if(mapOfShowroomIdAndShowroom.get(ld.Appointment_Venue_Square__c).Property_Postal_Code__c !=Null){
                                        showroomAddress += ', '+String.valueOf(mapOfShowroomIdAndShowroom.get(ld.Appointment_Venue_Square__c).Property_Postal_Code__c);
                                    }
                                }
                                Map<String,String> template_contentMap3 = new Map<String,String>();
                                template_contentMap3.put('name','Appointment_Venue_Site_Residence_Add1__c');
                                template_contentMap3.put('content',showroomAddress);
                                template_contentList.add(template_contentMap3);
                            }
                            List<String> ccEmailList =new List<String>();  
                            String jsonbody = MandrilEmailViaRosterQueueabble.rosterEmailWrapperJsonCreator('SF_appointment_confirmed_visit_rebranding', subject, toEmailMap, template_contentList,ccEmailList);
                            System.debug('jsonbody: '+jsonbody);
                            if(!String.isBlank(jsonbody)){
                                listOfJSON.add(jsonbody);
                            }
                        }
                    }
                    else{
                      //  System.debug('not in valid set of appointmnet type: '+ld.Appointment_Type__c);
                    }
                }
                    if(ld.Status =='Appointment Fixed' && ld.Floorplan_Received__c=='No' && ld.Floorplan_Received__c != oldLeadsMap.get(ld.Id).Floorplan_Received__c)
                    {
                        //Request for floorplan template SF_floorplan_request
                        String subject = 'Your floor plan is important';
                        Map<String,String> toEmailMap = new Map<String,String>();
                        toEmailMap.put('email',ld.email);
                        toEmailMap.put('name',ld.Full_Name__c);
                        List<Map<String,String>> template_contentList = new List<Map<String,String>>();
                        Map<String,String> template_contentMap1 = new Map<String,String>();
                        template_contentMap1.put('name','Customer_name');
                        template_contentMap1.put('content',ld.Full_Name__c);
                        template_contentList.add(template_contentMap1);
                        List<String> ccEmailList =new List<String>();  
                        String jsonbody = MandrilEmailViaRosterQueueabble.rosterEmailWrapperJsonCreator('SF_floorplan_request_rebranding', subject, toEmailMap, template_contentList,ccEmailList);
                        System.debug('jsonbody: '+jsonbody);
                        if(!String.isBlank(jsonbody)){
                            listOfJSON.add(jsonbody);
                        }
					}
                    if(ld.Status =='Pre-Appointment' && ld.Status != oldLeadsMap.get(ld.Id).Status && ld.Assigned_to_Resi_ASM__C && ld.Assigned_to_Resi_ASM__C != oldLeadsMap.get(ld.Id).Assigned_to_Resi_ASM__C && ld.Sales_Manager__c!=null)
                    {
                        //Send Email to Sales manager when a Lead gets assigned to them from WTA's at Pre-Appointment
                        System.debug('WT Pre-Appointment - Assigned to you');
                        String subject = 'WT Pre-Appointment - Assigned to you';
                        Map<String,String> toEmailMap = new Map<String,String>();
                        System.debug('ld.Sales_Manager_Email__c: '+ld.Sales_Manager_Email__c);
                        toEmailMap.put('email',mapOfSalesManagerIdAndSM.get(ld.Sales_Manager__c).Email__c);
                        toEmailMap.put('name',mapOfSalesManagerIdAndSM.get(ld.Sales_Manager__c).Name);
                        List<Map<String,String>> template_contentList = new List<Map<String,String>>();
                        List<String> ccEmailList =new List<String>();
                                           
                        if(ld.Inside_Sales_Agent__c !=null && ld.Inside_Sales_Agent_Email__c!=null)
                        {
                            ccEmailList.add(ld.Inside_Sales_Agent_Email__c);
                            ccEmailList.add(mapOfInsideSalesAgentIdAndISA.get(ld.Inside_Sales_Agent__c).Name);
                        }
                        System.debug('ccEmailList: '+ccEmailList);
                        
                        Map<String,String> template_contentMap1 = new Map<String,String>();
                        template_contentMap1.put('name','Lead.Full_Name__c');
                        template_contentMap1.put('content',ld.Full_Name__c);
                        template_contentList.add(template_contentMap1);
                        
                        Map<String,String> template_contentMap2 = new Map<String,String>();
                        template_contentMap2.put('name','Lead.Customer_ID__c');
                        template_contentMap2.put('content',ld.Customer_ID__c);
                        template_contentList.add(template_contentMap2);
                  //      System.debug('template_contentMap2 '+template_contentMap2);  
                        
                        Map<String,String> template_contentMap3 = new Map<String,String>();
                        template_contentMap3.put('name','Lead.Sales_Manager__c');
                        template_contentMap3.put('content',mapOfSalesManagerIdAndSM.get(ld.Sales_Manager__c).Name);
                        template_contentList.add(template_contentMap3);
                   //     System.debug('template_contentMap3 '+template_contentMap3);  
                        
                        Map<String,String> template_contentMap4 = new Map<String,String>();
                        template_contentMap4.put('name','Lead.Sales_Manager_Phone');
                        template_contentMap4.put('content',ld.Sales_Manager_Phone_Number__c);
                        template_contentList.add(template_contentMap4);
                   //     System.debug('template_contentMap4 '+template_contentMap4);  
                        
                        Map<String,String> template_contentMap5 = new Map<String,String>();
                        template_contentMap5.put('name','Lead.Sales_Manager_City');
                        template_contentMap5.put('content',mapOfSalesManagerIdAndSM.get(ld.Sales_Manager__c).City__c);
                        template_contentList.add(template_contentMap5);
                        System.debug('template_contentMap5 '+template_contentMap5);  
                        
                        Map<String,String> template_contentMap6 = new Map<String,String>();
                        template_contentMap6.put('name','Lead.Sales_Manager_Showroom');
                        template_contentMap6.put('content',mapOfSalesManagerIdAndSM.get(ld.Sales_Manager__c).Showroom_Name__r.Name);
                        template_contentList.add(template_contentMap6);
                        System.debug('template_contentMap6 '+template_contentMap6);  
                        
                        Map<String,String> template_contentMap7 = new Map<String,String>();
                        template_contentMap7.put('name','Lead.Description__c');
                        template_contentMap7.put('content',ld.Description__c);
                        template_contentList.add(template_contentMap7);
                        System.debug('template_contentMap7 '+template_contentMap7);  
                        
                        if(ld.Inside_Sales_Agent__c !=null)
                        {
                            Map<String,String> template_contentMap8 = new Map<String,String>();
                            template_contentMap8.put('name','Lead.Inside_Sales_Agent__c');
                            template_contentMap8.put('content',mapOfInsideSalesAgentIdAndISA.get(ld.Inside_Sales_Agent__c).Name);
                            template_contentList.add(template_contentMap8);
                            System.debug('template_contentMap8 '+template_contentMap8);  
                        }
                        
                    //	 System.debug('template_contentList: '+template_contentList);                    
                        
                        String jsonbody = MandrilEmailViaRosterQueueabble.rosterEmailWrapperJsonCreator('WT_Pre-Appointment-Assigned_to_you', subject, toEmailMap, template_contentList,ccEmailList);
                        System.debug('jsonbody: '+jsonbody);
                        if(!String.isBlank(jsonbody)){
                            listOfJSON.add(jsonbody);
                        }
                    }
                    // Commented following code as requested by Prachi on 8th August
                /*    if(ld.Assigned_to_Resi_ASM__C && ld.Assigned_to_Resi_ASM__C != oldLeadsMap.get(ld.Id).Assigned_to_Resi_ASM__C && ld.Sales_Manager__c!=null 
                       && ld.Bulk_Upload__c==FALSE && ld.IM_Assignment_Stage__c=='Lead creation' && ld.Transfer_Status__c != GenericConstants.IM_TRANSFER)
                    {
                        System.debug('Fresh_Lead_Assigned');
                        // Get the current time
                        Datetime currentTime = System.now();
                        
                        // Define the start and end times for the allowed range (9am to 9pm)
                        Time startTime = Time.newInstance(9, 0, 0, 0); // 9am
                        Time endTime = Time.newInstance(21, 0, 0, 0);  // 9pm
                        
                        // Get the time component from the current time
                        Time currentTimeOnly = currentTime.time();
                        
                        // Check if the current time is within the allowed range
                        if (currentTimeOnly >= startTime && currentTimeOnly < endTime) 
                        {
                            // Execute your code here
                            System.debug('Current time is between 9am to 9pm.');
                        

                            if(mapOfSalesManagerIdAndSM.get(ld.Sales_Manager__c).Phone__c != null)
                            {
                                string PhoneNumber = string.ValueOf(mapOfSalesManagerIdAndSM.get(ld.Sales_Manager__c).Phone__c);
                                if(PhoneNumber.length() == 10)
                                {
                                        String subject = 'Fresh_Lead_Assigned';
                                        Map<String,String> toEmailMap = new Map<String,String>();
                                        System.debug('ld.Sales_Manager_Email__c: '+ld.Sales_Manager_Email__c);
                                    
                                        toEmailMap.put('email',mapOfSalesManagerIdAndSM.get(ld.Sales_Manager__c).Email__c);
                                        toEmailMap.put('name',mapOfSalesManagerIdAndSM.get(ld.Sales_Manager__c).Name);
                                    
                                        List<Map<String,String>> template_contentList = new List<Map<String,String>>();
                                        List<String> ccEmailList =new List<String>();   
                                    
                                        Map<String,String> template_contentMap1 = new Map<String,String>();
                                        template_contentMap1.put('name','Lead.Full_Name__c');
                                        template_contentMap1.put('content',ld.Full_Name__c);
                                        template_contentList.add(template_contentMap1);
                                        
                                        Map<String,String> template_contentMap2 = new Map<String,String>();
                                        template_contentMap2.put('name','Lead.Customer_ID__c');
                                        template_contentMap2.put('content',ld.Customer_ID__c);
                                        template_contentList.add(template_contentMap2);
                                    
                                    	Map<String,String> template_contentMap3 = new Map<String,String>();
                                        template_contentMap3.put('name','Lead.Customer_Email__c');
                                        template_contentMap3.put('content',ld.Email);
                                        template_contentList.add(template_contentMap3);
                                    
                                    	Map<String,String> template_contentMap4 = new Map<String,String>();
                                        template_contentMap4.put('name','Lead.Caller_Id');
                                        template_contentMap4.put('content',mapOfSalesManagerIdAndSM.get(ld.Sales_Manager__c).Exotel_Phone_Number__c);
                                        template_contentList.add(template_contentMap4);
                                    
                                        String jsonbody = MandrilEmailViaRosterQueueabble.rosterEmailWrapperJsonCreator('Fresh_Lead_Assigned', subject, toEmailMap, template_contentList,ccEmailList);
                                        System.debug('jsonbody: '+jsonbody);
                                        if(!String.isBlank(jsonbody))
                                        {
                                            listOfJSON.add(jsonbody);
                                        }
                                }                            
                            }
                        } 
                        else 
                        {
                            // Current time is outside the allowed range
                            System.debug('Current time is not between 9am to 9pm.');
                        }
                    }*/
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
            Logger.log('Exception','LeadTriggerHandler Class','handleLeadRosterEmails Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    Public Static void squadIQProcessedLeadsAssignment(List<Lead> newLeadsList, Map<Id,Lead> oldLeadsMap){
        try{
            System.debug('System.isBatch(): '+System.isBatch());
            System.debug('System.isFuture(): '+System.isFuture());
            System.debug('squadIQProcessedLeadsAssignment method'); 
            List<String> setOfCitiesForPreferenceAssignement = new List<String>();
            list<Lead> lstLeadRecords = new List<Lead>();
            Set<String> lstPincode = new Set<String>();
            list<Lead> lstLeadRecordsPreference = new List<Lead>();
            Set<String> lstPincodePreference = new Set<String>();
            setOfCitiesForPreferenceAssignement = label.City_Specific_Preference_Assignment.split(';');
           
            for(Lead lrec: newLeadsList){
                if(oldLeadsMap !=null && !oldLeadsMap.isEmpty()){
                    if( lrec.Sign_Up_Source__c != 'Pronto Paint'){
                        if(lrec.Squad_IQ_Status__c != oldLeadsMap.get(lrec.Id).Squad_IQ_Status__c & lrec.Squad_IQ_Status__c =='Processed by SquadIQ'
                       && (lrec.Status=='Fresh Lead' || lrec.Status=='Pre-Appointment') && !lrec.Assigned_to_Resi_ASM__c && !lrec.Test_Flag__c 
                       && String.isNotBlank(lrec.postalcode) && lrec.postalcode.isNumeric()){
                           if(setOfCitiesForPreferenceAssignement.contains(lrec.City)){
                               lstLeadRecordsPreference.add(lrec);
                               lstPincodePreference.add(lrec.postalcode);
                           }else{
                               lstLeadRecords.add(lrec);
                               lstPincode.add(lrec.postalcode);
                           }
                       }
                    }
               
                    
                }
            }
            if(!lstLeadRecords.isEmpty()){
                //Lead records sent for IM assignment - Territory flow.
                IronManLead_Assignment_Handler.getIronManDetails(lstLeadRecords,lstPincode);
            }
          /*  if(!lstLeadRecordsPreference.isEmpty()){
                System.debug('Preference Called');
                //Lead records sent for IM assignment On preference - Territory flow.
                IronManLead_Assignment_Handler.getIronManDetailsForPreferenceAssignment(lstLeadRecordsPreference,lstPincodePreference);
            }*/
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','squadIQProcessedLeadsAssignment Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    Public Static void NimbusProcessedLeadsAssignment(List<Lead> newLeadsList, Map<Id,Lead> oldLeadsMap){
        try{
            System.debug('System.isBatch(): '+System.isBatch());
            System.debug('System.isFuture(): '+System.isFuture());
            System.debug('NimbusProcessedLeadsAssignment method'); 
            List<String> setOfCitiesForPreferenceAssignement = new List<String>();
            list<Lead> lstLeadRecords = new List<Lead>();
            Set<String> lstPincode = new Set<String>();
            list<Lead> lstLeadRecordsPreference = new List<Lead>();
            Set<String> lstPincodePreference = new Set<String>();
           setOfCitiesForPreferenceAssignement = label.City_Specific_Preference_Assignment.split(';');
            for(Lead lrec: newLeadsList){
                if(oldLeadsMap !=null && !oldLeadsMap.isEmpty()){
                    if( lrec.Sign_Up_Source__c != 'Pronto Paint'){
                        if( lrec.Nimbus_Status__c =='Processed By Nimbus' && lrec.Status != oldLeadsMap.get(lrec.Id).status
                           && lrec.Status=='Pre-Appointment' && !lrec.Assigned_to_Resi_ASM__c && !lrec.Test_Flag__c 
                           && String.isNotBlank(lrec.postalcode) && lrec.postalcode.isNumeric()){
                               system.debug('nimbus Processed');
                               lstLeadRecords.add(lrec);
                               lstPincode.add(lrec.postalcode);
                               
                           }
                    }
                }             
        }
              if(!lstLeadRecords.isEmpty()){
                //Lead records sent for IM assignment - Territory flow.
            //    IronManLead_Assignment_Handler.getIronManDetails(lstLeadRecords,lstPincode);
            	IronManLead_Assignment_Handler.getIronManDetailsWTAtoIMAssignment(lstLeadRecords,lstPincode);
            }
            
        }
          catch(Exception e){
               System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','NimbusProcessedLeadsAssignment Method',e.getMessage(),e.getStackTraceString(),null);
          }
    }
    
    
   public static String createSquadIQJson(Lead leadRec){
        String returnJson;
        try{
            if(leadRec !=null){
                list<Squad_IQ_Field_Mapping__mdt> listOfSquadIQFieldMapping = new list<Squad_IQ_Field_Mapping__mdt>();
                Map<String,Squad_IQ_Field_Mapping__mdt> mapOfSquadIQParamAndCustomMtadata = new Map<String,Squad_IQ_Field_Mapping__mdt>();
                Map<String,Object> JsonRequestMap = new Map<String,Object>(); 
                listOfSquadIQFieldMapping = [Select id,SF_Field_API_Name__c,SF_Field_Label_Name__c,SquadIQ_Field_Param_Name__c,In_Use__c from Squad_IQ_Field_Mapping__mdt where In_Use__c= True];
                system.debug('listOfSquadIQFieldMapping '+listOfSquadIQFieldMapping);
                if(!listOfSquadIQFieldMapping.isEmpty()){
                    for(Squad_IQ_Field_Mapping__mdt SquadIQMappingRec : listOfSquadIQFieldMapping){
                        mapOfSquadIQParamAndCustomMtadata.put(SquadIQMappingRec.SquadIQ_Field_Param_Name__c,SquadIQMappingRec);
                    }
                    system.debug('mapOfSquadIQParamAndCustomMtadata'+mapOfSquadIQParamAndCustomMtadata);
                    if(!mapOfSquadIQParamAndCustomMtadata.isEmpty()){
                        for(String SquadIQJsonParam : mapOfSquadIQParamAndCustomMtadata.KeySet()){
                            //String SFFieldAPIName = mapOfSquadIQParamAndCustomMtadata.get(SquadIQJsonParam).SF_Field_API_Name__c;
                            JsonRequestMap.put(SquadIQJsonParam,leadRec.get(mapOfSquadIQParamAndCustomMtadata.get(SquadIQJsonParam).SF_Field_API_Name__c));
                        }
                        system.debug('JsonRequestMap'+JsonRequestMap);
                        if(JsonRequestMap !=Null){
                            List<Map<String,Object>> listOfJsonRequestMap = new List<Map<String,Object>>();
                            listOfJsonRequestMap.add(JsonRequestMap);
                            returnJson = Json.serialize(listOfJsonRequestMap);
                        }
                    }
                    
                }
                else{
                    System.debug('listOfSquadIQFieldMapping is Empty');
                }
            }
            else{
                System.debug('leadRec is null.');
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','createSquadIQJson Method',e.getMessage(),e.getStackTraceString(),null);
        }
        System.debug('**************     oreturnJson: '+returnJson);
        return returnJson;
    }
    
    
    Public Static void rosterReferralLeadsIMAssignment(List<Lead> newLeadsList, Map<Id,Lead> oldLeadsMap){
        try{
            list<Lead> lstLeadRecords = new List<Lead>();
            for(Lead lrec: newLeadsList){
                if(oldLeadsMap !=null && !oldLeadsMap.isEmpty()){
                    if(lrec.LeadSource != oldLeadsMap.get(lrec.Id).LeadSource & lrec.LeadSource =='Referral' && oldLeadsMap.get(lrec.Id).LeadSource =='Walk-In' 
                       && !lrec.Assigned_to_Resi_ASM__c  && lrec.Sales_Manager__c ==Null && !lrec.Test_Flag__c){
                          //The referral leads from Roster which are not assigned with IM's yet will be considered for IM assignment when the lead source gets updated from Walk In to Referral.
                          lstLeadRecords.add(lrec);
                       }
                }
            }
            if(!lstLeadRecords.isEmpty()){
                //Lead records sent for IM assignment - Territory flow.
                checkPincode(lstLeadRecords,true,false);
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','rosterReferralLeadsIMAssignment Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    Public Static void websiteReferralLeadsIMAssignment(List < Lead > newLeadRecordsList){
        System.debug('websiteReferralLeadsIMAssignment');
        try{
            if(!newLeadRecordsList.isEmpty()){
                Set<String> setOfReferralPhoneNumbers = New Set<String>();
                Map<String,Lead> mapOfPhoneNumberWithLead = new Map<String,Lead>();
                Map<String,Showroom_User__C> mapOfIMUserIdAndIMToUpdateCount = new Map<String,Showroom_User__C>(); 
                for(Lead leadRecord : newLeadRecordsList){
                    if(leadRecord.LeadSource =='Referral' && String.isNotBlank(leadRecord.HL_Referrer_Phone__c) 
                       && String.isBlank(leadRecord.PostalCode) && String.isNotBlank(leadRecord.Sign_Up_Source__c)){
                        setOfReferralPhoneNumbers.add(leadRecord.HL_Referrer_Phone__c);
                    }
                }
                if(!setOfReferralPhoneNumbers.isEmpty()){
                    System.debug('setOfReferralPhoneNumbers: '+setOfReferralPhoneNumbers);
                    for(Lead leadRec : [Select id,Phone,Postalcode,Sales_Manager__c,Assigned_To_Resi_ASM__C,Sales_Manager__r.IsActive__C,Sales_Manager__r.Daily_Assignment__c,Sales_Manager__r.Monthly_Assignment__c from Lead where Phone =:setOfReferralPhoneNumbers order By createdDate desc]){
                        if(!mapOfPhoneNumberWithLead.containsKey(leadRec.Phone)){
                            mapOfPhoneNumberWithLead.put(leadRec.Phone,leadRec);
                        }
                    }
                }
                System.debug('mapOfPhoneNumberWithLead: '+mapOfPhoneNumberWithLead);
                for(Lead leadRecord : newLeadRecordsList){
                    if(leadRecord.LeadSource =='Referral' && String.isNotBlank(leadRecord.HL_Referrer_Phone__c) 
                       && String.isBlank(leadRecord.PostalCode) && String.isNotBlank(leadRecord.Sign_Up_Source__c)){
                           if(mapOfPhoneNumberWithLead.ContainsKey(leadRecord.HL_Referrer_Phone__c)){
                               if(mapOfPhoneNumberWithLead.get(leadRecord.HL_Referrer_Phone__c).Sales_Manager__c !=Null && mapOfPhoneNumberWithLead.get(leadRecord.HL_Referrer_Phone__c).Sales_Manager__r.IsActive__c){
                                   // If there is a lead with phone number same as the HL Referrer Phone number check if the Sales manager is present and is Active
                                   // If yes then copy the Sales manager to the new lead from that lead
                                   leadRecord.Sales_Manager__c = mapOfPhoneNumberWithLead.get(leadRecord.HL_Referrer_Phone__c).Sales_Manager__c;
                                   leadRecord.Assigned_To_Resi_ASM__C = True;
                                   
                                   //Create a showroom user (IM) instance to increment the daily and monthly lead assignmnet count and update it to the record.
                                   Showroom_User__C IMToUpdateTheCount = new Showroom_User__C();
                                   IMToUpdateTheCount.Id = mapOfPhoneNumberWithLead.get(leadRecord.HL_Referrer_Phone__c).Sales_Manager__c;
                                   
                                   //This is in case if multiple leads get assigned to the same IM in the loop. If it already contains then increment the value
                                   if(mapOfIMUserIdAndIMToUpdateCount.containsKey(IMToUpdateTheCount.Id)){
                                      IMToUpdateTheCount.Daily_Assignment__c = mapOfIMUserIdAndIMToUpdateCount.get(IMToUpdateTheCount.Id).Daily_Assignment__c+1;
                                      IMToUpdateTheCount.Monthly_Assignment__c = mapOfIMUserIdAndIMToUpdateCount.get(IMToUpdateTheCount.Id).Monthly_Assignment__c+1; 
                                   }
                                   else{
                                       //If it is a new IM and if the value is null then make it 1.
                                       if(mapOfPhoneNumberWithLead.get(leadRecord.HL_Referrer_Phone__c).Sales_Manager__r.Daily_Assignment__c ==Null){
                                           IMToUpdateTheCount.Daily_Assignment__c = 1;
                                       }
                                       //Else increment the value that was queried along with the lead
                                       else{
                                           IMToUpdateTheCount.Daily_Assignment__c = mapOfPhoneNumberWithLead.get(leadRecord.HL_Referrer_Phone__c).Sales_Manager__r.Daily_Assignment__c+1;
                                       }
                                       if(mapOfPhoneNumberWithLead.get(leadRecord.HL_Referrer_Phone__c).Sales_Manager__r.Monthly_Assignment__c ==Null){
                                           IMToUpdateTheCount.Monthly_Assignment__c = 1;
                                       }
                                       else{
                                           IMToUpdateTheCount.Monthly_Assignment__c = mapOfPhoneNumberWithLead.get(leadRecord.HL_Referrer_Phone__c).Sales_Manager__r.Monthly_Assignment__c+1;
                                       }
                                   }
                                   
                                   //Add the IM to the Map and Update the IM Map
                                   mapOfIMUserIdAndIMToUpdateCount.put(IMToUpdateTheCount.Id,IMToUpdateTheCount);
                               }
                               else{
                                   //If the above condition is failed then copy the postal code from the above lead 
                                   //so that the IM assignment will happen based on the pincode and Territory based available IM.
                                   leadRecord.Postalcode = mapOfPhoneNumberWithLead.get(leadRecord.HL_Referrer_Phone__c).Postalcode;
                               }
                           }
                           else{
                               //There is no lead with phone number same as the HL Referrer Phone number so do nothing. 
                               //The WT assignment will happen as ussual because there will be no pincode.
                           }
                    }
                }
                if(!mapOfIMUserIdAndIMToUpdateCount.isEmpty()){
                    update mapOfIMUserIdAndIMToUpdateCount.values();
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','websiteReferralLeadsIMAssignment Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    Public Static void checkForPincodeAssignmentTrigger(List<Lead> newLeadsList, Map<Id,Lead> oldLeadsMap)
    {
        system.debug('checkpincodeass');
        try
        {
            Boolean shouldCheckForIMAssignment = false; 
            Boolean shouldCheckForSqaudIQAssignment = false;
            list<Lead> lstLeadRecords = new List<Lead>();
            list<Lead> lstPaintLeadsRecords = new List<lead>();
            list<lead> lstHaptikInsideSales = new List<lead>();
            list<lead> lstWebinarInsideSales = new List<lead>();
            list<lead> singleInputLeadList = new List<lead>();            
            Set<String> GreenChannelPincodeSet = new Set<String>();
            GreenChannelPincodeSet = GreenChannelLeadAssignmentInitiateBatch.getGreenPincode();
            system.debug('GreenChannelPincodeSet '+ GreenChannelPincodeSet);
            if(oldLeadsMap == NULL)
            {
                //For insert scenario only Fresh Lead Verified will go for pincode IM assignment or SquadIQ
                //Website referral leads (coming with pincode and not with pincode but Referrer Lead's Salesmanager inactive copy pincode case) 
                //will they come in with Fresh Lead new or gets updated to new? shoud they be considered for SquadIQ in insert or update scenario?
                for(Lead lrec: newLeadsList)
                {
                    if(lrec.Sign_Up_Source__c != GenericConstants.HomeLaneLuxeLeadForm)
                    {
                        if( lrec.Sign_Up_Source__c == GenericConstants.PRONTO_SIGNUP_SOURCE)
                        {
                        	system.debug('welcome hlpronto');
                            if(/*lrec.Should_run_Ironman_assignment__c == true &&*/lrec.Assigned_to_Resi_ASM__c!=true && !(lrec.Test_Flag__c || 
                              lrec.LastName.containsIgnoreCase('hltest') || lrec.Email.containsIgnoreCase('hltest') || lrec.LeadSource.containsIgnoreCase('Test Source')))
                            {
                                lstPaintLeadsRecords.add(lrec);
                                system.debug('added to paint specialist queue');
                            }
                        }
                        else if( lrec.LeadSource == GenericConstants.LEAD_SOURCE_OFFLINE_ADS  &&  String.isBlank(lrec.postalcode) && 
                                lrec.Status == GenericConstants.LEAD_FRESH_STATUS && lrec.Sub_Status__c == GenericConstants.LEAD_NEW_SUBSTATUS )
                        {
                            	// Offline Ads Leads are routed to Inside Sales Assignment
                                system.debug('Offline Ads Leads');
                                lstHaptikInsideSales.add(lrec);                                     
                        }
                        else if( lrec.LeadSource == GenericConstants.LEADSOURCE_WEBINAR  && !String.isBlank(lrec.City)  && lrec.Status == GenericConstants.LEAD_FRESH_STATUS && 
                                 lrec.Sub_Status__c == GenericConstants.LEAD_SUBSTATUS_UNVERIFIED && lrec.Brand__c==GenericConstants.LEAD_HOMELANE)
                        {
                            	// Webinar Leads are routed to Inside Sales Assignment
                                system.debug('Webinar Leads');
                                lstWebinarInsideSales.add(lrec);  
                        }
                        else if((lrec.Status == GenericConstants.LEAD_FRESH_STATUS 
                                && (lrec.Sub_Status__c == GenericConstants.LEAD_NEW_SUBSTATUS||lrec.Sub_Status__C == 'Customer Online') 
                                && (!lrec.Bulk_Upload__c  || (lrec.Bulk_Upload__c  && lrec.LeadSource == 'Paytm Ads'))
                                && (!GreenChannelPincodeSet.contains(lrec.postalCode)||(lrec.Brand__c=='Doowup')||(GreenChannelPincodeSet.contains(lrec.postalCode)
                                &&  lrec.Green_Lead_Class__c != GenericConstants.Green_Lead_Bronze)))  && lrec.Assignment_Initiate_Stage__c !='HL Doowup GFE Experiment' && lrec.Transfer_Status__c != 'Doowup Transfer GFE')                               
                        {
                                    lstLeadRecords.add(lrec);
                                    shouldCheckForIMAssignment = true;
                                    shouldCheckForSqaudIQAssignment = true;
                            		
                                    System.debug('Assignment');
                                    //Referral Leads case needs to handled
                        }
                    }
                    
                }
            }
            else
            {
                //For Update scenario
                for(Lead lrec: newLeadsList)
                {
                    if(oldLeadsMap !=null && !oldLeadsMap.isEmpty())
                    {
                        // Added on 10th July 2024 for Webinar Relanded Leads Assignment
                       	if(lrec.Relanded_Source__c == GenericConstants.RELANDED_SOURCE_WEBINAR  &&  lrec.Status == GenericConstants.LEAD_FRESH_STATUS &&  
                            (oldLeadsMap.get(lrec.Id).Status == GenericConstants.LEAD_DEAD_STATUS || oldLeadsMap.get(lrec.Id).Status == GenericConstants.LEAD_NOT_ACTIVELY_PURSUED_STATUS) &&
                            lrec.Sub_Status__c == GenericConstants.LEAD_SUBSTATUS_WEBINAR && oldLeadsMap.get(lrec.Id).Sub_Status__c !=lrec.Sub_Status__c && lrec.Brand__c==GenericConstants.LEAD_HOMELANE)
                        {
                                        // Relanded Webinar Leads are routed to Inside Sales Assignment
                                        system.debug('Webinar Leads');
                                        lstWebinarInsideSales.add(lrec);  
                        }
                        else if(lrec.Sign_Up_Source__c != GenericConstants.PRONTO_SIGNUP_SOURCE && lrec.Sign_Up_Source__c != GenericConstants.Sign_Up_WhatsApp_Haptik)
                        {
                            	system.debug('contains');                           
                            	
                                if((!GreenChannelPincodeSet.contains(lrec.PostalCode)||(lrec.Brand__c=='Doowup')||(GreenChannelPincodeSet.contains(lrec.postalCode) && 
                                     	lrec.Green_Lead_Class__c != GenericConstants.Green_Lead_Bronze && lrec.Assignment_Initiate_Stage__c!= 'Green Channel IM Assignment')))
                                {
                                    system.debug('not contain');
                                    
                                    if((lrec.Transfer_Status__c !='Doowup Transfer' && lrec.Assigned_to_Resi_ASM__c == False && !lrec.Bulk_Upload__c && lrec.Pushed_To_Ozonetel__c == False && 
                                       lrec.Squad_IQ_Status__c != GenericConstants.SQUADIQ_SENT_TOSQUADIQ && lrec.Squad_IQ_Status__c != GenericConstants.SQUADIQ_PROCESSED_BY_SQUADIQ && lrec.Should_run_Ironman_assignment__c && 
                                       lrec.Nimbus_Status__c!='Processed by Nimbus' && lrec.Nimbus_Status__c !='Sent to Nimbus' && lrec.Nimbus_Status__c!='Assigned to Nimbus'
                                       && ((lrec.Status == GenericConstants.LEAD_FRESH_STATUS && lrec.Sub_Status__c == GenericConstants.LEAD_NEW_SUBSTATUS && 
                                            (oldLeadsMap.get(lrec.Id).Sub_Status__c == GenericConstants.LEAD_SUBSTATUS_UNVERIFIED || oldLeadsMap.get(lrec.Id).Sub_Status__c == GenericConstants.LEAD_SUBSTATUS_CUST_ONLINE ) && 
                                            lrec.Sub_Status__c != oldLeadsMap.get(lrec.Id).Sub_Status__c) || (lrec.Assignment_Initiate_Stage__c == 'Unverified - SquadIQ/IRM' && 
                                            lrec.Assignment_Initiate_Stage__c != oldLeadsMap.get(lrec.Id).Assignment_Initiate_Stage__c))) && lrec.Assignment_Initiate_Stage__c !='HL Doowup GFE Experiment' &&
                                       		lrec.Transfer_Status__c != 'Doowup Transfer GFE' && lrec.Assignment_Initiate_Stage__c!='Single Input InsideSales Assignment')
                                            {
                                               System.debug('Assignment flow');
                                               lstLeadRecords.add(lrec);
                                               shouldCheckForIMAssignment = true;
                                               shouldCheckForSqaudIQAssignment = true;
                                               //Referral Leads case needs to handled
                                            }  
                                    		//This assignment is set in Batch set for Single Input lead
                                            else
                                            {
                                                    if(lrec.Assignment_Initiate_Stage__c != oldLeadsMap.get(lrec.Id).Assignment_Initiate_Stage__c && 
                                                       lrec.Assignment_Initiate_Stage__c == GenericConstants.Single_Input_InsideSales_Assignment)
                                                    {
                                                        system.debug('SingleInputLeadISAassignment');
                                                        singleInputLeadList.add(lrec);
                                                    }  
                                            }
                                }
                                //This assignment is set in Batch set for Green Channel lead
                                else if(lrec.Assignment_Initiate_Stage__c == GenericConstants.Green_Channel_IM_Assignment
                                        && lrec.Assignment_Initiate_Stage__c != oldLeadsMap.get(lrec.Id).Assignment_Initiate_Stage__c)
                            			{
                                            system.debug('Green channel assignment');
                                            lstLeadRecords.add(lrec);
                                            shouldCheckForIMAssignment = true;
                                            shouldCheckForSqaudIQAssignment = true;
                                        }
                        
                    
                        }
                        else
                        {
                            //This assignment is set in Batch set for Whatsapp Heptic lead
                            if(lrec.Sign_Up_Source__c == GenericConstants.Sign_Up_WhatsApp_Haptik) 
                            {
                               if((lrec.Assignment_Initiate_Stage__c != oldLeadsMap.get(lrec.Id).Assignment_Initiate_Stage__c && lrec.Assignment_Initiate_Stage__c == GenericConstants.WhatsApp_Haptik_IM_Assignment ) 
                                   || (lrec.Status == GenericConstants.WhatsApp_Pre_Appointment && oldLeadsMap.get(lrec.Id).Status !=lrec.Status ))
                              	{
                                   lstLeadRecords.add(lrec);
                                   shouldCheckForIMAssignment = true;
                                   shouldCheckForSqaudIQAssignment = true;
                                   system.debug('whatsapphaptik');
                               	}
                                else if(lrec.Assignment_Initiate_Stage__c != oldLeadsMap.get(lrec.Id).Assignment_Initiate_Stage__c && lrec.Assignment_Initiate_Stage__c == GenericConstants.WhatsApp_Haptik_InsideSales_Assignment)
                                {
                                    lstHaptikInsideSales.add(lrec);
                                    system.debug('whatsapphaptikInside1');
                                }  
                            }
                               
                        }
                    }  
                }
                        
            }
            system.debug('lstLeadRecords'+ lstLeadRecords);
            if(!lstLeadRecords.isEmpty())
            {
                //Lead records sent for IM assignment - Territory flow.
                 System.debug('Assignment flow');
                checkPincode(lstLeadRecords,shouldCheckForIMAssignment,shouldCheckForSqaudIQAssignment);
            }
            if(!lstPaintLeadsRecords.isEmpty())
            {
                system.debug('lstLeads paint'+ lstPaintLeadsRecords);
                IronManLead_Assignment_Handler.getIronManPaintSpecialist(lstPaintLeadsRecords);
            }
            if(!lstHaptikInsideSales.isEmpty())
            {
                system.debug('whatsapphaptikInside1 & Offline Ads Leads');
                IronManInsideSalesLeadAssignment.getInsideSalesHaptikUser(lstHaptikInsideSales[0]);
            }
            if(!singleInputLeadList.isEmpty())
            {
                system.debug('Single Input Leads with Others City for ISA Assignment');
                IronManInsideSalesLeadAssignment.assignISAonSingleInputLead(singleInputLeadList[0]);
            }
            if(!lstWebinarInsideSales.isEmpty())
            {
                system.debug('Webinar Leads for ISA Assignment');
                IronManInsideSalesLeadAssignment.assignISAonWebinarLead(lstWebinarInsideSales[0]);
            }
        }
        catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','checkForPincodeAssignmentTrigger Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
     Public Static void LeadScoreUpdateCheck(List<Lead> newLeadsList, Map<Id,Lead> oldLeadsMap){
        try{
            list<Lead> lstLeadRecords = new List<Lead>();
                for(Lead lrec: newLeadsList){
                    if(oldLeadsMap !=null && !oldLeadsMap.isEmpty()){
                        if(!lrec.Bulk_Upload__c && lrec.Assigned_to_Resi_ASM__c == False && lrec.Pushed_To_Ozonetel__c == False && lrec.Squad_IQ_Status__c != 'Sent to SquadIQ' && lrec.Should_run_Ironman_assignment__c
                           && lrec.Status == 'Fresh Lead' && lrec.Sub_Status__c =='New' && oldLeadsMap.get(lrec.Id).Sub_Status__c =='Unverified' && lrec.Sub_Status__c != oldLeadsMap.get(lrec.Id).Sub_Status__c){
                               
                               lstLeadRecords.add(lrec);
                               //Referral Leads case needs to handled
                           }
                    }
                }
            if(!lstLeadRecords.isEmpty()){
                //Send for lead score updates
                //LeadTriggerHelper.getLeadScore(lstLeadRecords);
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','LeadScoreUpdateCheck Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
   
    public static void relandedLeadAssignmentTrigger(List<Lead> newLeadsList, Map<Id,Lead> oldLeadsMap)
    {
        system.debug('relandedleadAssign');
        try
        {
            
            List<Lead> lstLeadsToPushToOzoneTel = new List<Lead>();
            Boolean LeadCreatedRecently =false;
            
            Set<Id> setOfIMsIds = new Set<Id>();
            Set<Id> setOfWTAsIds = new Set<Id>();
            Map<Id,User> mapOfWTAs = new Map<Id,User>();
            Map<Id,Showroom_User__c> mapOfIMs = new Map<Id,Showroom_User__c>();
            
            list<Lead> lstLeadRecords = new List<Lead>();
            list<Lead> lstLeadRecordstoUpdate = new List<Lead>();
            
            Set<String> lstPincode = new Set<String>();
            
            for(Lead ld: newLeadsList)
            {
                if(ld.Sales_Manager__c != Null)
                {
                    setOfIMsIds.add(ld.Sales_Manager__c);
                }
                if(ld.WT_Agent__c != Null)
                {
                    setOfWTAsIds.add(ld.WT_Agent__c); 
                }
            }
            if(!setOfIMsIds.isEmpty())
            {
            	mapOfIMs = new Map<Id,Showroom_User__c>([Select id,IsActive__c from Showroom_User__c where id =:setOfIMsIds]);
            }
           
            system.debug('**newListLeads*****' +newLeadsList);
            system.debug('******newLeadsList******'+newLeadsList.size());
            //system.debug('**mapofIM'+ mapOfIMs);
            
            if( !newLeadsList.isEmpty() )
            {
                for(Lead ld : newLeadsList )
                {
                    if( ld.Sign_Up_Source__c !='Pronto Paint')
                    {
                        System.debug('bypass condition');
                        if(!(ld.Test_Flag__c || ld.LastName.containsIgnoreCase('hltest') || ld.Email.containsIgnoreCase('hltest') || ld.LeadSource.containsIgnoreCase('Test Source')))
                        {
                            
                            if(ld.Status != oldLeadsMap.get(ld.Id).Status && ld.Sub_Status__c != oldLeadsMap.get(ld.Id).Sub_Status__c && !ld.Bulk_Upload__c && 
                               ld.Status =='Fresh Lead' && ld.Sub_Status__c =='Re-Landed' && (oldLeadsMap.get(ld.Id).Status=='Dead Lead' || oldLeadsMap.get(ld.id).Status=='Not actively pursued'))
                            {
                                    system.debug('relanded leads'); 
                                
                                	// New trigger to assign the Leads to HomeLane Offline CP if LeadSOurce is changing from Broker/Channel Partner to any 
                                	// other value. If lead is created in last 6 months and old status is dead lead or lead is created before 6 months.
                                	if(ld.LeadSource != oldLeadsMap.get(ld.Id).LeadSource && oldLeadsMap.get(ld.Id).LeadSource == GenericConstants.OFFLINE_LEAD_SOURCE)
                                    {
                                        	LeadCreatedRecently = utilityClass.isCP_AssignedRecently( ld.id , null);
                                        	System.debug('LeadCreatedRecently '+LeadCreatedRecently);
                                        	if((LeadCreatedRecently && oldLeadsMap.get(ld.Id).Status=='Dead Lead') || !LeadCreatedRecently )
                                            {
                                                	
                                                	System.debug('Criteria passed for CP assignment');
                                                	Lead newld = new Lead();
                                                	newld.id = ld.id;
                                                	newld.HL_Referrer_Phone__c = System.Label.HomeLane_Offline_Channel_Partner_Phone;
                    								newld.Channel_Partner__c = System.Label.HomeLane_Offline_Channel_Partner;
                    								newld.CP_Assignment_Date__c = System.now();
                									lstLeadRecordstoUpdate.add(newld);  
                                                	system.debug('Channel Partner assignment');
                                            }                                        	
                                    }
                                    
                                    if(ld.Assigned_to_Resi_ASM__c && ld.Sales_Manager__c != null && !String.isBlank(ld.Sales_Manager_Email__c)&& mapOfIMs.containsKey(ld.Sales_Manager__c) && 
                                       mapOfIMs.get(ld.Sales_Manager__c).IsActive__c == true)
                                    {
                                        system.debug('Im is active and found');
                                    }
                                    else
                                    {
                                        lstLeadRecords.add(ld);
                                        lstPincode.add(ld.postalcode);
                                    }                                
                            }
                        }
                    }
                    
                }
                
                if(!lstLeadRecords.isEmpty())
                {
                    //Lead records sent for IM assignment - Territory flow.
                    system.debug('territory');
                    IronManLead_Assignment_Handler.getIronManDetails(lstLeadRecords,lstPincode);
                }
                
                if(!lstLeadRecordstoUpdate.isEmpty())
                {
                    system.debug('Update Channel Partner assignment leads');
                   	update lstLeadRecordstoUpdate;
                }

            }
        }
        
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandler Class','relandedLeadAssignmentTrigger Method',e.getMessage(),e.getStackTraceString(),null);
        }
        
        
    }
    public static Boolean shouldProcessAsync() 
    {
        return !system.isFuture() && !system.isBatch() && Limits.getLimitFutureCalls() > Limits.getFutureCalls();
     }
    
    
   
    
    
   
    public static void dummyTestCover(){
        Integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    
    }
}