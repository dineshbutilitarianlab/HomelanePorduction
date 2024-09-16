/**
 * @File Name          : UpdateReferral_Information.cls
 * @Description        : 
 * @Author             : Bharatesh Shetty
 * @Group              : 
 * @Last Modified By   : Bharatesh Shetty
 * @Last Modified On   : 2/18/2020, 12:44:56 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2/18/2020   Bharatesh Shetty     Initial Version
**/
Public class UpdateReferral_Information
{
    
    /*
This Method will Update the Channel_Partner__c field on LEAD depending on the value Present 
in HL_Referrer_Phone__c Phone Number on insert and Update.
*/
    Public static void UpdateReferral(List<Lead> lstLead,Map<Id,Lead> OldMap)
    {
         String HomeLane_Offline_CP = System.Label.HomeLane_Offline_Channel_Partner_Phone;
        list<String> lstHLReferralNumber = new list<String>();
        Map<Lead,String> mapLeadWithReferralPhone = new Map<Lead,String>();
        Map<String,Channel_Partner__c > mapReferralPhoneWithType = new Map<String,Channel_Partner__c>();
        Set<String> setOfValidLeadSources = new Set<String>();
        /*setOfValidLeadSources.add('Broker/Channel Partner');
        setOfValidLeadSources.add('Ambassador');
        setOfValidLeadSources.add('Builder Leads');*/
        system.debug('List of Lead ---->'+lstLead);
        for(Valid_Referral_Lead_Sources__mdt mdtRec :[Select id,Lead_Source_Name__c from Valid_Referral_Lead_Sources__mdt])
        {
            setOfValidLeadSources.add(mdtRec.Lead_Source_Name__c);
        }
        system.debug('setOfValidLeadSources ---->'+setOfValidLeadSources);
        if(!lstLead.isEmpty())
        {
            try
            {
                // for Insert scenario 
                if(OldMap == NULL)
                {
                    for(Lead objLead : lstLead)
                    {
                        if(setOfValidLeadSources.contains(objLead.LeadSource))
                        {
                            if(String.IsNotBlank(objLead.HL_Referrer_Phone__c))
                            {
                                mapLeadWithReferralPhone.put(objLead,objLead.HL_Referrer_Phone__c);
                            }
                        }
                    }
                } 
                // for Update scenario 
                else
                {
                    for(Lead objLead : lstLead)
                    {
                        system.debug('OldMap '+objLead );
                        if(setOfValidLeadSources.contains(objLead.LeadSource) || setOfValidLeadSources.contains(objLead.Relanded_Source__c))
                        {
                            // CP should not be changed to any other CP except HomeLane Offline CP : 24-05-2024
                            
                            if(String.IsNotBlank(objLead.HL_Referrer_Phone__c) && objLead.HL_Referrer_Phone__c!= OldMap.get(objLead.id).HL_Referrer_Phone__c) 
                             //  && objLead.HL_Referrer_Phone__c == HomeLane_Offline_CP)
                            {
                              	mapLeadWithReferralPhone.put(objLead,objLead.HL_Referrer_Phone__c);
                            }
                            
                            // If HL_Referrer_Phone__c is updated to blank
                            if(String.IsBlank(objLead.HL_Referrer_Phone__c) && objLead.HL_Referrer_Phone__c!= OldMap.get(objLead.id).HL_Referrer_Phone__c )
                            {
                                objLead.Channel_Partner__c = NULL;
                                objLead.Referral_Program__c = NULL;
                                objLead.BDM_Name__c=Null;
                            }
                        }
                    }
                }   
                
                system.debug('mapLeadWithReferralPhone---->'+mapLeadWithReferralPhone);
                
                if(!mapLeadWithReferralPhone.isEmpty())
                {                        
                        // Get All the Channel Partner records where Phone Number is present on Lead
                        for(Channel_Partner__c objChannelPartner : [Select id,Name,Phone__c,RecordType.DeveloperName,RecordType.Name,Sub_Source__c,BDM_Name__c
                                                                    from Channel_Partner__c 
                                                                    Where Phone__c IN: mapLeadWithReferralPhone.Values()])
                        {
                            mapReferralPhoneWithType.put(objChannelPartner.Phone__c,objChannelPartner);                                                  
                            
                        }                                                       
                }
                
                system.debug('mapReferralPhoneWithType ---->'+mapReferralPhoneWithType);
                
                //Running Loop on Trigger.New so that we can addError while inseting in dataloader
                for(Lead leadObj: lstLead)
                {
                    if(mapLeadWithReferralPhone.containsKey(leadObj))
                    {
                        if(mapReferralPhoneWithType.containsKey(leadObj.HL_Referrer_Phone__c))
                        {
                            system.debug('leadObj.HL_Referrer_Phone__c---->'+leadObj.HL_Referrer_Phone__c);
                            
                            /*  
                             If the lead source and the channel partner record type matches update the Channel partner and Referral Program fields else throw the validation error.                           
                            */
                            
                            if(leadObj.LeadSource == mapReferralPhoneWithType.get(leadObj.HL_Referrer_Phone__c).RecordType.Name || leadObj.Relanded_Source__c == mapReferralPhoneWithType.get(leadObj.HL_Referrer_Phone__c).RecordType.Name)
                            {                                   
                                leadObj.Channel_Partner__c = mapReferralPhoneWithType.get(leadObj.HL_Referrer_Phone__c).id;
                                
                                if(leadObj.HL_Referrer_Phone__c != HomeLane_Offline_CP )
                                {
                                    leadObj.BDM_Name__c = mapReferralPhoneWithType.get(leadObj.HL_Referrer_Phone__c).BDM_Name__c;
                                }
                                	
                                leadObj.Referral_Program__c = mapReferralPhoneWithType.get(leadObj.HL_Referrer_Phone__c).Sub_Source__c;
                                
                                // Added this date field : 28th May 2024
                                leadObj.CP_Assignment_Date__c = System.now();                                
                            }
                            else
                            {
                                leadObj.addError('There is a mismatch with the lead source and the type of Offline Channel Partner. Lead source is '+leadObj.LeadSource+' and Channel Partner type is '+mapReferralPhoneWithType.get(leadObj.HL_Referrer_Phone__c).RecordType.Name+'.'); 
                            }
                        }
                        // IF Channel Partner with the Phone Number is not present 
                        else
                        {
                            leadObj.addError('There is no Offline Channel Partner record with the phone number '+leadObj.HL_Referrer_Phone__c+'.');
                        }
                    }
                    else
                    {
                        //Error
                    }
                }
            }
            catch(Exception e)
            {
                system.debug('Exception Occured'+e.getStackTraceString());
                Logger.log('Exception','UpdateReferralInformation','UpdateReferral',e.getMessage(),e.getStackTraceString(),NULL);
            }
        }
    }
}