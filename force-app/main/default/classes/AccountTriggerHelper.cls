public class AccountTriggerHelper {
    
    public static void updateAccoutFieldsInOppAndLead(Map<Id,Account> mapOfAccounts){
        try{
            LeadSelector ls= new LeadSelector();
            Map<Id,Lead> listOfLeadsToUpdate =(Map<Id,Lead>) ls.querryleadFromAccIdSet(mapOfAccounts.keySet());
            OpportunitySelector os= new OpportunitySelector();
            
            Map<Id,Opportunity> listOfOppToUpdate =(Map<Id,Opportunity>) os.querryOppFromAccIdSet(mapOfAccounts.keySet());
            
            for(Lead eachLead : listOfLeadsToUpdate.values()){
                eachLead.FirstName = mapOfAccounts.get(eachLead.Account__c).FirstName;
                eachLead.LastName = mapOfAccounts.get(eachLead.Account__c).Lastname;
                eachLead.MiddleName =  mapOfAccounts.get(eachLead.Account__c).MiddleName;
                eachLead.Phone = mapOfAccounts.get(eachLead.Account__c).Phone;
                if(mapOfAccounts.get(eachLead.Account__c).PersonEmail != null)
                    eachLead.Email = mapOfAccounts.get(eachLead.Account__c).PersonEmail;
                eachLead.Alt_Email_ID__c = mapOfAccounts.get(eachLead.Account__c).Alt_Email__c;
                eachLead.Alt_Phone_Number__c =  mapOfAccounts.get(eachLead.Account__c).Alt_Phone_Number__c;
                eachLead.Whatsapp_Opt_in__c = mapOfAccounts.get(eachLead.Account__c).Whatsapp_Opt_in__c;
                eachLead.Found_On_TC__C = mapOfAccounts.get(eachLead.Account__c).Found_On_TC__C;
                eachLead.OTP_Verified__C = mapOfAccounts.get(eachLead.Account__c).OTP_Verified__C;
                
            }
            
            if(!listOfLeadsToUpdate.values().isEmpty()){
                update listOfLeadsToUpdate.values();
            }
            
            List<Opportunity> listOfOppToUpdateVal = new List<Opportunity>();
            for(Opportunity opp : listOfOppToUpdate.values()){
                Opportunity oppr = new Opportunity();
                oppr.Id = opp.Id;
                if(String.isBlank(mapOfAccounts.get(opp.AccountId).FirstName) && String.isBlank(mapOfAccounts.get(opp.AccountId).MiddleName)){
                    oppr.Name = mapOfAccounts.get(opp.AccountId).lastName; 
                    oppr.Full_Name__c = mapOfAccounts.get(opp.AccountId).lastName; 
                }
                else if(String.isBlank(mapOfAccounts.get(opp.AccountId).FirstName)){
                    oppr.Name = mapOfAccounts.get(opp.AccountId).Middlename +' ' + mapOfAccounts.get(opp.AccountId).LastName;
                    oppr.Full_Name__c = mapOfAccounts.get(opp.AccountId).Middlename + mapOfAccounts.get(opp.AccountId).LastName;
                }
                else if(String.isBlank(mapOfAccounts.get(opp.AccountId).MiddleName)){
                    oppr.Name = mapOfAccounts.get(opp.AccountId).FirstName +' ' + mapOfAccounts.get(opp.AccountId).LastName;
                    oppr.Full_Name__c = mapOfAccounts.get(opp.AccountId).FirstName +' ' + mapOfAccounts.get(opp.AccountId).LastName;
                }
                else{
                    oppr.Name = mapOfAccounts.get(opp.AccountId).FirstName +' ' + mapOfAccounts.get(opp.AccountId).Middlename +' ' + mapOfAccounts.get(opp.AccountId).LastName;
                    oppr.Full_Name__c = mapOfAccounts.get(opp.AccountId).FirstName +' ' + mapOfAccounts.get(opp.AccountId).Middlename +' ' + mapOfAccounts.get(opp.AccountId).LastName;
                }
                if(mapOfAccounts.get(opp.AccountId).PersonEmail != null){
                    oppr.Customer_Email__c = mapOfAccounts.get(opp.AccountId).PersonEmail;
                }
                
                //oppr.Alt_Email__c = mapOfAccounts.get(opp.AccountId).Alt_Email__c;
                oppr.Alt_Email_ID__c = mapOfAccounts.get(opp.AccountId).Alt_Email__c;
                oppr.Alt_Phone_Number__c = mapOfAccounts.get(opp.AccountId).Alt_Phone_Number__c;
                
                listOfOppToUpdateVal.add(oppr);
            }
            if(!listOfOppToUpdateVal.isEmpty()){
                update listOfOppToUpdateVal;
            }
            
        }catch(Exception e){
            Logger.log('AccountTriggerHelper','Change Lead and Opp values on account','Change Lead and Opp values on account',e.getMessage(),e.getStackTraceString(),NULL);
        }
    }
    
}