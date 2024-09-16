@RestResource(urlMapping='/CreateEventForOpp/*')
global with sharing class CreateEventForOpp
{
  public Static String strBody{get;set;}
@HttpPost
  global static void getopprec() {
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        String meetinginput = '';
        if(!Test.IsRunningTest()){
          RestRequest req = RestContext.request;    
          meetinginput =  req.requestBody.toString();
        }         
        else
          meetinginput = strBody;  
        List<Opportunity> opplist = new List<Opportunity>();
        List<Lead> leadlist = new List<Lead>();
        List<Event> lstEvent = new List<Event>();
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        //List<sObject> leadlist = new List<sObject>();
        Map<String,object> JSON_Input = (Map<String,object> ) JSON.deserializeUntyped(meetinginput);        
        try{
            opplist = [Select id,name,Appointment_Type__c,SCVM_Showroom_Visit__c,SCVM_Visit_Date__c,Customer_Email__c,OwnerId from Opportunity where Customer_Phone_Number__c = : (String) JSON_Input.get('phone') Limit 1];
             leadlist = [Select id,name,Email,OwnerId from Lead where Phone = : (String) JSON_Input.get('phone') AND IsConverted = false Limit 1];
            system.debug('opplist -------------------->'+opplist);
            system.debug('leadlist -------------------->'+leadlist);
            
            if(!opplist.isEmpty()){
                for(Opportunity ld : opplist){
                    Event objEvt = new Event();
                    objEvt.WhatId=ld.Id;
                    objEvt.OwnerId=ld.OwnerId;
                    objEvt.Subject='Showroom Visit';
                    objEvt.StartDateTime=DateTime.valueOf((String) JSON_Input.get('startTime'));
                    objEvt.EndDateTime=DateTime.valueOf((String) JSON_Input.get('endTime'));
                    lstEvent.add(objEvt);
                    if(ld.Appointment_Type__c == 'Virtual Meeting'){
                        ld.SCVM_Showroom_Visit__c = 'Yes';
                        if(ld.SCVM_Visit_Date__c == null){
                            ld.SCVM_Visit_Date__c = DateTime.valueOf((String) JSON_Input.get('startTime'));
                        }
                        lstOpportunity.add(ld);
                    }
        
                }
                update lstOpportunity;
            }else if(!leadlist.isEmpty()){
               for(Lead ld : leadlist){
                    Event objEvt = new Event();
                    objEvt.WhoId=ld.Id;
                    objEvt.OwnerId=ld.OwnerId;
                    objEvt.Subject='Showroom Visit';
                    objEvt.StartDateTime=DateTime.valueOf((String) JSON_Input.get('startTime'));
                    objEvt.EndDateTime=DateTime.valueOf((String) JSON_Input.get('endTime'));
                    lstEvent.add(objEvt);
                   
                }

            }
            else{
                SendEmailToManager((String) JSON_Input.get('email'),(String) JSON_Input.get('phone'));
            }
            
            Insert lstEvent;
            system.debug('oppoppquery Error lstEvent-------------------->'+lstEvent);
            system.debug('oppoppquery Error lstOpportunity-------------------->'+lstOpportunity);
            FinalWrapper fin = new FinalWrapper();
            fin.errorMsg = '';
            fin.sucessMsg = 'Event Created sucessfully.';
            finalList.add(fin);
        
       }catch(Exception ex){
            FinalWrapper fin = new FinalWrapper();
                    fin.errorMsg = ex.getMessage();
                    SendEmailToManager((String) JSON_Input.get('email'),(String) JSON_Input.get('phone'));
                    finalList.add(fin);
                system.debug('oppoppquery Error-------------------->');
                    }
         if(!Test.isRunningTest()){
              string json_data = json.serialize(finalList);
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(json_data);
                    }    
       }
        global Static void SendEmailToManager(String Email,String strPhone ){
             String[] strUserEmail = new List<String>();
         if(!Test.isRunningTest()){Exception_Mail__c objAmeyo = Exception_Mail__c.getValues('SF Lead Mail');strUserEmail = objAmeyo.Email_Addresss__c.split(',');
         }else{
          strUserEmail.add('testapi@gmail.com');
         }
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.toAddresses = strUserEmail; 
                            message.optOutPolicy  = 'FILTER';
                            message.subject = 'Customer Not Found for Event Creation';
                            message.plainTextBody = 'Salesforce - This is to inform you that Customer with the Email ='+Email+' and Phone = '+strPhone+'is not present in SF, Please do the needful';
                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        }
        
        
        global class FinalWrapper{
            public String sucessMsg{get;set;}
            public String errorMsg{get;set;}
            
        }
        
        
}