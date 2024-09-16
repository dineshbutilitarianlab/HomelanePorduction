public class LeadTriggerHelper {
    
    
    
    public static void setGreenLeadScore(List<lead> listOfLeads)
    {
        
        Id GoldPlusRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Gold_Plus_RECID).getRecordTypeId();
        Id GoldRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Gold_RECID).getRecordTypeId();
        Id SilverRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Silver_RECID).getRecordTypeId();
       // Id BronzeRTID = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get(genericConstants.Bronze_Plus_RECID).getRecordTypeId();
      
        system.debug('GoldRTID');
        Lead_Class_Scoring__c  leadScoringResult = new Lead_Class_Scoring__c ();
        List<lead> updateLeadList = new List<lead>();
        boolean checkGoldplus =false;
        boolean checkGold =false;
        boolean checksilver= false;
		boolean checkbronze= false;
          
        integer setLeadScore=0;
        
        
        for(Lead ld :listOfLeads)
        {
            	if(ld.LeadSource=='Walk-In' || ld.LeadSource=='Referral')
                {
                        system.debug('goldplus');
                        setLeadScore = GenericConstants.Lead_Gold_Plus_Score;
                }
                else if(ld.Status == GenericConstants.LEAD_PRE_APPOINTMENT_STATUS || ld.Meeting_Source__c == GenericConstants.Customer_PreAppt_Meeting_Source ||
                   ld.Status == GenericConstants.WhatsApp_Pre_Appointment)
                {                                       	
                    
                    	if(ld.Status == GenericConstants.WhatsApp_Pre_Appointment)
                        {
                             system.debug('Whatsapp Lead Made Silver');
                             setLeadScore = GenericConstants.Lead_Silver_Score;                          
                        }
                    
                        else if(ld.Property_Status__c != GenericConstants.Property_Status_Renovation && 
                          (ld.Budget_Range__c!=GenericConstants.Lead_Budget_1L && ld.Budget_Range__c!=GenericConstants.Lead_Budget_4L && 
                           ld.Budget_Range__c!=GenericConstants.Lead_Budget_NA1 && ld.Budget_Range__c!= GenericConstants.Lead_Budget_NA2))                                          
                        {
                            if(ld.Bulk_Upload__c==False)
                            {
                                if(ld.City==GenericConstants.LD_City_Mumbai || ld.City==GenericConstants.LD_City_Coimbatore || ld.City==GenericConstants.LD_City_Bengaluru || 
                            	   ld.City==GenericConstants.LD_City_Hyderabad || ld.City==GenericConstants.LD_City_Kolkata || ld.City==GenericConstants.LD_City_NewDelhi || 
                                   ld.City==GenericConstants.LD_City_Gurgaon || ld.City==GenericConstants.LD_City_Noida || ld.City==GenericConstants.LD_City_Ghaziabad ||
                                   ld.City==GenericConstants.LD_City_Chennai || ld.City==GenericConstants.LD_City_Pune || ld.City == GenericConstants.LD_City_Ahm || 
                                   ld.City == GenericConstants.LD_City_Bhubaneswar || ld.City == GenericConstants.LD_City_Jaipur || ld.City == GenericConstants.LD_City_Kochi || 
                                   ld.City == GenericConstants.LD_City_Lucknow || ld.City == GenericConstants.LD_City_Mysore || ld.City == GenericConstants.LD_City_Visakhapatnam ||
                                   ld.City == GenericConstants.LD_City_Nagpur || ld.City == GenericConstants.LD_City_Ranchi || ld.City == GenericConstants.LD_City_Salem || 
                                   ld.City == GenericConstants.LD_City_Surat || ld.City == GenericConstants.LD_City_Thane || ld.City == GenericConstants.LD_City_Trichy ) 
                                {
                                    system.debug('Gold');
                                	setLeadScore = GenericConstants.Lead_Gold_Score; 
                                }
                                
                                else if(ld.City == GenericConstants.LD_City_Madurai)
                                {
                                    system.debug('Silver');
                                    setLeadScore = GenericConstants.Lead_Silver_Score;  
                                }
                                
                                else 
                                {
                                     system.debug('Bronze');
                                     setLeadScore = GenericConstants.Lead_Bronze_Score;
                                }
                            }
                            else
                            {
                                	System.debug('Entered else part');
                                	if(ld.Budget_Range__c!=GenericConstants.Lead_Budget_8L && !ld.Is_Blitz_builder_lead__c)
                                    {
                                        system.debug('Gold');
                            			setLeadScore = GenericConstants.Lead_Gold_Score;  
                                    }
                                    else
                                    {
                                        system.debug('Silver');
                                    	setLeadScore = GenericConstants.Lead_Silver_Score;
                                    }                                
                            }
                        }
                    
                    	else
                        {
                            if(ld.Bulk_Upload__c==False)
                            {
                                if(ld.City==GenericConstants.LD_City_Pune || ld.City==GenericConstants.LD_City_Coimbatore || ld.City==GenericConstants.LD_City_Bengaluru || 
                            	   ld.City==GenericConstants.LD_City_Chennai || ld.City==GenericConstants.LD_City_Kolkata || ld.City==GenericConstants.LD_City_Hyderabad || 
                                   ld.City==GenericConstants.LD_City_Gurgaon || ld.City==GenericConstants.LD_City_Noida || ld.City==GenericConstants.LD_City_Mumbai ||
                                   ld.City == GenericConstants.LD_City_Ahm || ld.City == GenericConstants.LD_City_Bhubaneswar || ld.City == GenericConstants.LD_City_Kochi || 
                                   ld.City == GenericConstants.LD_City_Lucknow || ld.City == GenericConstants.LD_City_Mysore || ld.City == GenericConstants.LD_City_Nagpur || 
                                   ld.City == GenericConstants.LD_City_Surat || ld.City == GenericConstants.LD_City_Thane)
                                {
                                        system.debug('Gold');
                                        setLeadScore = GenericConstants.Lead_Gold_Score; 
                                }
                                else if(ld.City==GenericConstants.LD_City_NewDelhi || ld.City==GenericConstants.LD_City_Ghaziabad || ld.City == GenericConstants.LD_City_Visakhapatnam ||  
                                        ld.City == GenericConstants.LD_City_Ranchi || ld.City == GenericConstants.LD_City_Trichy || ld.City == GenericConstants.LD_City_Madurai)
                                {
                                        system.debug('Silver');
                                        setLeadScore = GenericConstants.Lead_Silver_Score;
                                }
                                else 
                                {
                                        system.debug('Bronze');
                                        setLeadScore = GenericConstants.Lead_Bronze_Score;                               
                                }    
                            }
                            else 
                            {
                                  	system.debug('Bronze');
                                    setLeadScore = GenericConstants.Lead_Bronze_Score;                               
                            }                            
                        }
                    
                    
                }
                    
            
                if(setLeadScore ==0) 
                {
                    checkGoldplus = ld.LeadSource=='Walk-In' || ld.LeadSource=='Referral' ? True : False;
                    if(!checkGoldplus)
                    {                
                        checkGold=  LeadTriggerHelper.getScore(GoldRTID,ld);
                        system.debug('gold');
                        
                        if(!checkGold)
                        {                   
                            checksilver = LeadTriggerHelper.getScore(SilverRTID,ld);
                            system.debug('Silver');
                            if(!checksilver)
                            {                       
                                system.debug('Bronze');
                                setLeadScore = GenericConstants.Lead_Bronze_Score;
                            }
                            else
                            {
                                system.debug('Silver');
                                setLeadScore = GenericConstants.Lead_Silver_Score;                                
                            }
                            
                        }
                        else
                        {
                            setLeadScore=GenericConstants.Lead_Gold_Score; 
                        }
                        
                    }
                    else
                    {
                        system.debug('goldplus');
                        setLeadScore = GenericConstants.Lead_Gold_Plus_Score;
                    }
                }
            
        
                system.debug('Green_Lead_Class__c '+ ld.Green_Lead_Class__c);
                
            	System.debug('setLeadScore '+setLeadScore+' & ld.Lead_Score_for_Assignment__c ' +ld.Lead_Score_for_Assignment__c);
            	if(setLeadScore > ld.Lead_Score_for_Assignment__c || ld.Lead_Score_for_Assignment__c==null || ld.Lead_Score_for_Assignment__c==0)
                {
                    ld.Lead_Score_for_Assignment__c = setLeadScore;
                }             
            
        }
    }   
    
    
    public  static boolean  getScore(id RecId,lead ld)
    {
        
        List<Lead_Class_Scoring__c>  leadscoringResult = new List<Lead_Class_Scoring__c>();
        List<String> leadSourceList = new List<String>();
        List<string> signupSourceList = new List<String>();
        List<string> leadAndSignupList = new List<String>();
        List<string> pincodeList = new List<String>();
        List<string> LeadSignupPincodeList = new List<String>();
        List<string> preAppointmentSourceList = new List<String>();
        List<string> preAppointmentSourceOTPList = new List<String>();
        List<String> LeadSourceSignupPincodeOTPList= new List<String>();
        List<String> LeadSourceAndPincodeList = new List<String>();
        List<String> LeadSourceAndPincodeOTPList = new List<String>();
        List<String> pincodeAndOTPList = new List<String>();
        List<String> pincodeAndSignUpList = new List<String>();
        List<String> pincodeSignUpAndOTPList = new List<String>();
        List<String> leadSourceAndOTPList = new List<String>();
        //Added to implement Campaign Logic
        List<String> PaidSearch_OTPVerified_LeadSources_List = new List<String>();
        List<String> PaidSearch_OTPNotVerified_LeadSources_List = new List<String>();
        List<String> FaceBookAd_OTPVerified_LeadSources_List = new List<String>();
        List<String> FaceBookAd_OTPNotVerified_LeadSources_List = new List<String>();
        List<String> discovery_OTPVerified_LeadSources_List = new List<String>();
        List<String> discovery_OTPNotVerified_LeadSources_List = new List<String>();

        Boolean setLeadScoreFlag = false;
        Boolean CampaignFlag = false;
        Set<String> greenChannelCity = new Set<String>();
        try
        {
        
            
                 System.debug('ldCity null '+ld.City);
              	 String Bengaluru_City = GenericConstants.LD_City_Bengaluru;
            	 String NewDelhi_City = GenericConstants.LD_City_NewDelhi;
                 String Noida_City = GenericConstants.LD_City_Noida;
            	 String Mumbai_City = GenericConstants.LD_City_Mumbai;
              	 
            
            	 if(ld.City == GenericConstants.LD_City_Kolkata || ld.City == GenericConstants.LD_City_Hyderabad || ld.City == GenericConstants.LD_City_Chennai || 
                    ld.City == GenericConstants.LD_City_Pune || ld.City == GenericConstants.LD_City_Coimbatore || ld.City == GenericConstants.LD_City_NewDelhi || 
                    ld.City == GenericConstants.LD_City_Gurgaon || ld.City == GenericConstants.LD_City_Ghaziabad || ld.City == GenericConstants.LD_City_Noida ||
                    ld.City == GenericConstants.LD_City_Mumbai || ld.City == GenericConstants.LD_City_Thane || ld.City == GenericConstants.LD_City_Ahm || 
					ld.City == GenericConstants.LD_City_Bhubaneswar || ld.City == GenericConstants.LD_City_Jaipur || ld.City == GenericConstants.LD_City_Kochi || 
                    ld.City == GenericConstants.LD_City_Lucknow || ld.City == GenericConstants.LD_City_Madurai || ld.City == GenericConstants.LD_City_Mysore || 
                    ld.City == GenericConstants.LD_City_Nagpur || ld.City == GenericConstants.LD_City_Ranchi || ld.City == GenericConstants.LD_City_Salem || 
                    ld.City == GenericConstants.LD_City_Surat || ld.City == GenericConstants.LD_City_Thane || ld.City == GenericConstants.LD_City_Trichy || 
                    ld.City == GenericConstants.LD_City_Visakhapatnam)
                 {                    
                     leadscoringResult =[Select Lead_Source_List__c,Pincode_and_OTP_List__c,Pincode_and_Signup_Source_List__c, 
                                        Lead_Signup_and_Pincode_List__c,Lead_and_Signup_List__c,Pincode_List__c,Signup_Source_List__c,PreAppointment_Lead_Source_List__c,City__c,
                                        PreAppointment_Lead_Source_OTPList__c,LeadSource_SignUpSource_Pincode_OTP_List__c,LeadSource_Pincode_List__c,LeadSource_Pincode_OTP_List__c,
                                        Pincode_Signup_Source_and_OTP_List__c,LeadSource_and_OTP_List__c,Paid_Search_OTP_Campaign_List__c, Paid_Search_Campaign_List__c, 
                                        Facebook_Ad_OTP_Campaign_List__c,Facebook_Ad_Campaign_List__c,discovery_OTP_Campaign_List__c, discovery_Campaign_List__c
                                        from Lead_Class_Scoring__c where recordTypeId=:RecId  and City__c =:ld.City limit 1]; 
                 }
            	
            	 else
                 {
                     leadscoringResult =[Select Lead_Source_List__c,Pincode_and_OTP_List__c,Pincode_and_Signup_Source_List__c, 
                                        Lead_Signup_and_Pincode_List__c,Lead_and_Signup_List__c,Pincode_List__c,Signup_Source_List__c,PreAppointment_Lead_Source_List__c,City__c,
                                        PreAppointment_Lead_Source_OTPList__c,LeadSource_SignUpSource_Pincode_OTP_List__c,LeadSource_Pincode_List__c,LeadSource_Pincode_OTP_List__c,
                                        Pincode_Signup_Source_and_OTP_List__c,LeadSource_and_OTP_List__c,Paid_Search_OTP_Campaign_List__c, Paid_Search_Campaign_List__c, 
                                        Facebook_Ad_OTP_Campaign_List__c,Facebook_Ad_Campaign_List__c,discovery_OTP_Campaign_List__c, discovery_Campaign_List__c
                                        from Lead_Class_Scoring__c where recordTypeId=:RecId  and City__c =:Bengaluru_City limit 1]; 
                 }
                             
                                
                    
            System.debug('leadscoringResult after '+leadscoringResult);          
            if(leadScoringResult!=null)
            {
                
                if(String.isNotBlank(leadScoringResult[0].Lead_Source_List__c))
                {
                    leadSourceList=  leadScoringResult[0].Lead_Source_List__c.split(';'); 
                }
                system.debug('leadSourceList'+ leadSourceList);
                if(String.isNotBlank(leadScoringResult[0].Signup_Source_List__c))
                {
                    signupSourceList = leadScoringResult[0].Signup_Source_List__c.split(';');
                }
                if(String.isNotBlank(leadScoringResult[0].Pincode_List__c))
                {
                    pincodeList = leadScoringResult[0].Pincode_List__c.split(';');
                }
                if(String.isNotBlank(leadScoringResult[0].Lead_and_Signup_List__c))
                {
                    leadAndSignupList=leadScoringResult[0].Lead_and_Signup_List__c.split(';');
                }
                if(String.isNotBlank(leadScoringResult[0].Lead_Signup_and_Pincode_List__c))
                {
                    LeadSignupPincodeList = leadScoringResult[0].Lead_Signup_and_Pincode_List__c.split(';');
                }
                
                if(String.isNotBlank(leadScoringResult[0].PreAppointment_Lead_Source_List__c))
                {
                    preAppointmentSourceList=leadScoringResult[0].PreAppointment_Lead_Source_List__c.split(';');
                    
                }
                if(String.isNotBlank(leadScoringResult[0].LeadSource_and_OTP_List__c))
                {
                    leadSourceAndOTPList=leadScoringResult[0].LeadSource_and_OTP_List__c.split(';');                    
                }
                
                
                
                system.debug('preAppointmentSourceList'+ preAppointmentSourceList);
                if(String.isNotBlank(leadScoringResult[0].PreAppointment_Lead_Source_OTPList__c))
                {
                    preAppointmentSourceOTPList =leadScoringResult[0].PreAppointment_Lead_Source_OTPList__c.split(';');                    
                }
                
                if(String.isNotBlank(leadScoringResult[0].LeadSource_Pincode_List__c))
                {
                    LeadSourceAndPincodeList =leadScoringResult[0].LeadSource_Pincode_List__c.split(';');
                }
                if(String.isNotBlank(leadScoringResult[0].LeadSource_Pincode_OTP_List__c))
                {
                    LeadSourceAndPincodeOTPList =leadScoringResult[0].LeadSource_Pincode_OTP_List__c.split(';');
                }
                if(String.isNotBlank(leadScoringResult[0].LeadSource_SignUpSource_Pincode_OTP_List__c))
                {
                    LeadSourceSignupPincodeOTPList =leadScoringResult[0].LeadSource_SignUpSource_Pincode_OTP_List__c.split(';');
                }
                
                system.debug('LeadSourceSignupPincodeOTPList'+ LeadSourceSignupPincodeOTPList);
                if(string.isNotBlank(leadScoringResult[0].Pincode_and_OTP_List__c))
                {
                    pincodeAndOTPList= leadScoringResult[0].Pincode_and_OTP_List__c.split(';');
                }
                if(string.isNotBlank(leadScoringResult[0].Pincode_and_Signup_Source_List__c))
                {
                  pincodeAndSignUpList =leadScoringResult[0].Pincode_and_Signup_Source_List__c.split(';');
                }
                if(string.isNotBlank(leadScoringResult[0].Pincode_Signup_Source_and_OTP_List__c))
                {
                  pincodeSignUpAndOTPList =leadScoringResult[0].Pincode_Signup_Source_and_OTP_List__c.split(';');
                }
                
                
                system.debug('CampaignLeadSourceList');
                if(String.isNotBlank(leadScoringResult[0].Paid_Search_OTP_Campaign_List__c)) 
                {
                    PaidSearch_OTPVerified_LeadSources_List = leadScoringResult[0].Paid_Search_OTP_Campaign_List__c.split(';');
                    for(String CampaignSubString : PaidSearch_OTPVerified_LeadSources_List)
                    {
                        	system.debug('Paid Search OTP '+CampaignSubString);
                    		if(ld.LeadSource == 'Paid Search' && ld.Utm_Campaign__c.contains(CampaignSubString) && ld.OTP_Verified__c)
                            {
                                	CampaignFlag = true;
                            }
                    }
                }                
                if(String.isNotBlank(leadScoringResult[0].Paid_Search_Campaign_List__c)) 
                {
                    PaidSearch_OTPNotVerified_LeadSources_List = leadScoringResult[0].Paid_Search_Campaign_List__c.split(';');
                    for(String CampaignSubString : PaidSearch_OTPNotVerified_LeadSources_List)
                    {
                        	system.debug('Paid Search '+CampaignSubString);
                    		if(ld.LeadSource == 'Paid Search' && ld.Utm_Campaign__c.contains(CampaignSubString))
                            {
                                	CampaignFlag = true;
                            }
                    }
                }                
                if(String.isNotBlank(leadScoringResult[0].Facebook_Ad_OTP_Campaign_List__c)) 
                {
                    FaceBookAd_OTPVerified_LeadSources_List = leadScoringResult[0].Facebook_Ad_OTP_Campaign_List__c.split(';');
                    for(String CampaignSubString : FaceBookAd_OTPVerified_LeadSources_List)
                    {
                        	system.debug('Facebook Ad OTP ' +CampaignSubString);
                    		if(ld.LeadSource == 'Facebook Ad' && ld.Utm_Campaign__c.contains(CampaignSubString) && ld.OTP_Verified__c)
                            {
                                	CampaignFlag = true;
                            }
                    }
                }                
                if(String.isNotBlank(leadScoringResult[0].Facebook_Ad_Campaign_List__c)) 
                {
                    FaceBookAd_OTPNotVerified_LeadSources_List = leadScoringResult[0].Facebook_Ad_Campaign_List__c.split(';');
                    for(String CampaignSubString : FaceBookAd_OTPNotVerified_LeadSources_List)
                    {
                        	system.debug('Facebook Ad '+ CampaignSubString);
                    		if(ld.LeadSource == 'Facebook Ad' && ld.Utm_Campaign__c.contains(CampaignSubString))
                            {
                                	CampaignFlag = true;
                            }
                    }
                }                
                if(String.isNotBlank(leadScoringResult[0].discovery_OTP_Campaign_List__c)) 
                {
                    discovery_OTPVerified_LeadSources_List = leadScoringResult[0].discovery_OTP_Campaign_List__c.split(';');
                    for(String CampaignSubString : discovery_OTPVerified_LeadSources_List)
                    {
                        	system.debug('discovery OTP '+ CampaignSubString);
                    		if(ld.LeadSource == 'discovery' && ld.Utm_Campaign__c.contains(CampaignSubString) && ld.OTP_Verified__c)
                            {
                                	CampaignFlag = true;
                            }
                    }
                }                
                if(String.isNotBlank(leadScoringResult[0].discovery_Campaign_List__c)) 
                {
                    discovery_OTPNotVerified_LeadSources_List = leadScoringResult[0].discovery_Campaign_List__c.split(';');
                    for(String CampaignSubString : discovery_OTPNotVerified_LeadSources_List)
                    {
                        	system.debug('discovery '+ CampaignSubString);
                    		if(ld.LeadSource == 'discovery' && ld.Utm_Campaign__c.contains(CampaignSubString))
                            {
                                	CampaignFlag = true;
                            }
                    }
                }
                system.debug('CampaignFlag :'+ CampaignFlag);

            }
            
            
            
                 system.debug('oninsert');
                 if((leadSourceList.contains(ld.LeadSource))
                    || signupSourceList.contains(ld.Sign_Up_Source__c)
                    || pincodeList.contains(ld.PostalCode)
                    || (leadAndSignupList.contains(ld.LeadSource)&&leadAndSignupList.contains(ld.Sign_Up_Source__c))
                    || (LeadSignupPincodeList.contains(ld.LeadSource)&& LeadSignupPincodeList.contains(ld.Sign_Up_Source__c)&& LeadSignupPincodeList.contains(ld.PostalCode))
                    || (LeadSourceSignupPincodeOTPList.contains(ld.LeadSource)&& LeadSourceSignupPincodeOTPList.contains(ld.PostalCode)&& LeadSourceSignupPincodeOTPList.contains(ld.Sign_Up_Source__c) && ld.OTP_Verified__c)
                    || (LeadSourceAndPincodeList.contains(ld.PostalCode)&& LeadSourceAndPincodeList.contains(ld.LeadSource)) 
                    || (LeadSourceAndPincodeOTPList.contains(ld.LeadSource) && LeadSourceAndPincodeOTPList.contains(ld.PostalCode)&& ld.OTP_Verified__c )
                    || (pincodeAndOTPList.contains(ld.postalCode)&& ld.OTP_Verified__c )
                    || (pincodeAndSignUpList.contains(ld.PostalCode))&& pincodeAndSignUpList.contains(ld.Sign_Up_Source__c)
                    || (pincodeSignUpAndOTPList.contains(ld.PostalCode) && pincodeSignUpAndOTPList.contains(ld.Sign_Up_Source__c) && ld.OTP_Verified__c)
                    || (leadSourceAndOTPList.contains(ld.LeadSource) && ld.OTP_Verified__c)
                    || CampaignFlag )
                   
                 {
                    setLeadScoreFlag = true; 
                 }            
          
        }
        Catch(Exception e)
        {
            system.debug('error'+ e.getMessage());
            system.debug('err'+e.getLineNumber()+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHelper Class','getScore method',e.getMessage(),e.getStackTraceString(),null);
        }
        
        
        return setLeadScoreFlag;
    }
    
    
}