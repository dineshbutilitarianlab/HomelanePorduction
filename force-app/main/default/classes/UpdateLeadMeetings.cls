/*
         * $Author: Aditya Saini
         * $Date: 30/05/2016 
         * Version: 5
         */

@RestResource(urlMapping='/UpdateLeadMeetings/*')
 global class UpdateLeadMeetings{
           Public Static Boolean opportunityupdated = FALSE;
            Public Static Boolean opportunitypriority = FALSE;
            public static String strBody;
            
            @HttpPost
            global Static Void UpdateLeadMeetings(){
              try{
                List<Master__c> showroom = new List<Master__c>();
                List<Lead> leadList = new List<Lead>();
                List<Lead> listOfLeadsToUpDate = new List<Lead>();
                Lead leadToUpdate = new Lead();
                List<Opportunity> opportunityList = new List<Opportunity>();
                List<Interior_Designer__c> dpuser = new List<Interior_Designer__c>();
                String meetinginput = '';
                if(!Test.isRunningTest()){
                 RestRequest req = RestContext.request;
                 meetinginput = req.requestBody.toString(); 
                }else{
                    meetinginput = strBody;
                }
                
                Map<String, Object> JSON_Input = (Map<String, Object>)JSON.deserializeUntyped(meetinginput);

                system.debug(' ** JSON_Input  is?'+JSON_Input);

                system.debug('dpname ----------------- '+(String)JSON_Input.get('DPName') );
                if((String)JSON_Input.get('Customer_Id') != null ){
                Response response =new Response();
                leadList = [Select id,name,Priority_Lead__c,Priority_Type__c,Appointment_Time__c,Appointment_Type__c,Appointment_Venue_Square__c,Status,Sub_Status__c,Design_Partner__c,Interior_Designer__c,Email,Schedule_a_Meeting_on_Acuity__c from Lead
                                          where Customer_Id__c =: (String)JSON_Input.get('Customer_Id')]; 
                    if(!leadList.isEmpty()){
                        leadToUpdate.id = leadList[0].Id;
                        listOfLeadsToUpDate.add(leadToUpdate);
                    }
                if((String)JSON_Input.get('DPName') != null && (String)JSON_Input.get('DPemail') != null && (String)JSON_Input.get('Status') != 'Appointment Cancelled'){
                    dpuser = [Select id,name,email__c from Interior_Designer__c where email__c =: (String)JSON_Input.get('DPemail')];
                    system.debug('dpuser ---------------------->'+dpuser);
                        if(dpuser.size() ==0){
                            response.message = 'Meeting Update Failed, DP Not Present In SF';
                            opportunityupdated = TRUE;
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.toAddresses = new String[] { 'nitin.b@homelane.com','nitin.b@homelane.com' }; 
                            message.optOutPolicy = 'FILTER';
                            message.subject = 'DP Not Found[Acuity Scheduling]';
                            message.plainTextBody = 'Salesforce - This is to inform you that DP with the name ='+(String)JSON_Input.get('DPName')+'and email as = '+(String)JSON_Input.get('DPemail')+'is not present in SF, Please do the needful';
                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        }else{
                            leadToUpdate.Interior_Designer__c = dpuser[0].Id;
                        }
                    
                }
                 if((String)JSON_Input.get('showroomvenue') != null){
                    showroom = [Select id from Master__c where Type__c ='Showroom' AND Name=:(String)JSON_Input.get('showroomvenue') AND IsActive__c = true];
                    system.debug('customer Email ---------------------->'+(String)JSON_Input.get('customeremail'));
                    system.debug('leadList size ------------------------------->'+leadList.size()); 
                    if(showroom.Size() > 0){
                        leadToUpdate.Appointment_Venue_Square__c = showroom[0].Id;
                        
                    }else{
                        response.message = 'Meeting Update Failed, Showroom Not Present In SF';
                        opportunityupdated = TRUE;
                    } 
                 }
                if(leadList.size()==1){
                        system.debug('leadList[0].Interior_Designer__c ------------------->'+leadList[0].Interior_Designer__c);
                        system.debug('dpuser[0].Id ------------------->'+dpuser);
                        if((String)JSON_Input.get('Meetingdateandtime') != null)
                            leadToUpdate.Appointment_Time__c = Datetime.valueOf((String)JSON_Input.get('Meetingdateandtime'));
                        if((String)JSON_Input.get('Status') != null)
                            leadToUpdate.Status = (String)JSON_Input.get('Status');
                        if((String)JSON_Input.get('Schedule_a_Meeting_on_Acuity__c') != null)
                            leadToUpdate.Schedule_a_Meeting_on_Acuity__c = (String)JSON_Input.get('Schedule_a_Meeting_on_Acuity__c');
                        if((String)JSON_Input.get('Meeting_Status') != null)
                            leadToUpdate.Meeting_Status__c = (String)JSON_Input.get('Meeting_Status');
                        if((String)JSON_Input.get('Sub-status') != null)
                            leadToUpdate.Sub_Status__c = (String)JSON_Input.get('Sub-status');
                        if((String)JSON_Input.get('cancel_reason') != null)
                            leadToUpdate.Cx_obstacles_for_Meetings__c = (String)JSON_Input.get('cancel_reason');
                        //leadList[0].Appointment_Type__c ='Virtual Meeting';
                    }else if(leadList.size() == 0){
                         response.message = 'Meeting Update Failed, No Customer Found';
                         opportunityupdated = TRUE;
                    }else if(leadList.size() > 1){
                         response.message = 'Meeting Update Failed, More Than One Customer With Same Email';
                         opportunityupdated = TRUE;
                    } 
                    if(leadList.size()==1 && (String)JSON_Input.get('priority_lead') != null && (String)JSON_Input.get('priority_type') != null){
                        leadToUpdate.Priority_Lead__c = (String)JSON_Input.get('priority_lead');
                        leadToUpdate.Priority_Type__c = (String)JSON_Input.get('priority_type');
                       
                    }
                    if(leadList.size()==1 && (Decimal)JSON_Input.get('estimate_value') != null){
                        leadToUpdate.Estimate_Value__c = (Decimal)JSON_Input.get('estimate_value');
                       
                    }
                       leadToUpdate.Appointment_Type__c = 'Virtual Meeting';

                try{
                    if(opportunityupdated != TRUE && !listOfLeadsToUpDate.isEmpty()){
                        update listOfLeadsToUpDate;
                        response.message = 'Meeting Deatils For The Lead Requested Is Updated';
                        response.leadId = listOfLeadsToUpDate[0].id;
                        /*Log__c log= new Log__c();
                        log.Type__c = 'Update meeting Test';
                        log.lead__c=listOfLeadsToUpDate[0].Id;
                        Insert log;*/
                    }
                    } catch(DMLException Dmlex){response.message = 'Error Occured--'+Dmlex.getmessage();response.leadId = listOfLeadsToUpDate[0].id;
                        system.debug('*** Lead record falied to update '+Dmlex.getmessage());
                    }
                    //response.leadId = leadList[0].id;
                    system.debug('----response message-------'+response);
                    string json_data = json.serialize(response);
                    if(!Test.isRunningTest()){RestContext.response.addHeader('Content-Type', 'application/json');RestContext.response.responseBody = Blob.valueOf(json_data);
                    }                   
                    
                }
               /* if(JSON_Input.get('VM_SubStatus') != null && JSON_Input.get('VM_SubStatus') != ''){
                    opportunityList = [Select Id,Name,VM_Sub_Status__c from Opportunity Where Customer_Email__c = :(String)JSON_Input.get('customeremail')];
                    ResponseOpportunity objResponse = new ResponseOpportunity();
                    boolean isDuplicate = false;
                    for(Integer i=0; i<opportunityList.size(); i++){
                        if(i == 0){
                            objResponse.OpportunityId = opportunityList[i].Id;
                            objResponse.OpportunityName = opportunityList[i].Name;
                        }else{
                            objResponse.OpportunityId = objResponse.OpportunityId+', '+opportunityList[i].Id;
                            objResponse.OpportunityName = objResponse.OpportunityName+', '+opportunityList[i].Name;
                            isDuplicate = true;
                            objResponse.message = 'Duplicate opportunity found';
                        }
                    }
                   /* if(!isDuplicate){
                        Opportunity objNew = new Opportunity();
                        objNew.VM_Sub_Status__c = (String)JSON_Input.get('VM_SubStatus');
                        objNew.Id = objResponse.OpportunityId;
                        try{
                            update objNew;
                            objResponse.message = 'VM Sub Status Update Sucessfully.';
                        }catch(Exception exp){
                            objResponse.message = exp.getmessage();
                        }
                    }
                    if(!Test.isRunningTest()){
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(json.serialize(objResponse)); 
                    }
                }*/
              }catch(Exception Exp){ Response errorMsg = new Response();errorMsg.message = 'Error Occured---'+Exp.getMessage();if(!Test.isRunningTest()){RestContext.response.addHeader('Content-Type', 'application/json');RestContext.response.responseBody = Blob.valueOf(json.serialize(errorMsg)); 
                system.debug('-------Error Message-----'+Exp.getMessage());  
                system.debug('-------Error Message-----'+Exp.getStackTraceString());
                system.debug('-------Error Message-----'+Exp.getCause());
                system.debug('-------Error Message-----'+Exp.getLineNumber());
               
                
                }                
             }   

            }
            Private class Response{
                String message;
                String leadId;
            }
            
           /* Private class ResponseOpportunity{
                String message;
                String OpportunityId;
                String OpportunityName;
            }*/
        }