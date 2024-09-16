/*
         * $Author: Aditya Saini
         * $Date: 30/05/2016 
         * Version: 5
         */

@RestResource(urlMapping='/Updateopportunity/*')
    global class UpdateOpportunity{
            public Static String strBody= '';
            @HttpPost
            global Static Void UpdateOpportunity(){

                List<Master__c> showroom = new List<Master__c>();
                List<Lead> leadList = new List<Lead>();
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
                if((String)JSON_Input.get('OpportunityOrderID') != null){

                    opportunityList = [Select Id,Name,VM_Sub_Status__c,Last_VM_Time__c,Follow_Up_Time__c from Opportunity Where Customer_Id__C = :(String)JSON_Input.get('OpportunityOrderID')];
                }
                
                    ResponseOpportunity objResponse = new ResponseOpportunity();
                    String strResponse = '';
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
                    if((String)JSON_Input.get('DPemail') != null){
                    dpuser = [Select id,name,Email__c from Interior_Designer__c where Email__c =: (String)JSON_Input.get('DPemail')];
                    system.debug('dpuser ---------------------->'+dpuser);
                        if(dpuser.size() ==0){
                            objResponse.message = 'opportunity Update Failed, DP Not Present In SF';
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.toAddresses = new String[] { 'nitin.b@homelane.com','nitin.b@homelane.com' }; 
                            message.optOutPolicy = 'FILTER';
                            message.subject = 'DP Not Found[Acuity Scheduling]';
                            message.plainTextBody = 'Salesforce - This is to inform you that DP with the name ='+(String)JSON_Input.get('DPName')+'and email as = '+(String)JSON_Input.get('DPemail')+'is not present in SF, Please do the needful';
                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                            strResponse = 'DP Not Present In SF';
                        }
                   }
                    if(!isDuplicate){
                        Opportunity objNew = new Opportunity();
                        if(dpuser.size() >0){
                             objNew.Interior_Design_Partner__c = dpuser[0].Id;
                            // objNew.OwnerId = dpuser[0].Id;
                        }
                        if((String)JSON_Input.get('VM_SubStatus') != null){
                           objNew.VM_Sub_Status__c = (String)JSON_Input.get('VM_SubStatus');
                        }
                        if((String)JSON_Input.get('cancel_reason') != null){
                           objNew.Cx_obstacles_for_Meetings__c = (String)JSON_Input.get('cancel_reason');
                        }
                        if((String)JSON_Input.get('Followup_Time') != null){
                           objNew.Follow_Up_Time__c = Datetime.valueOf((String)JSON_Input.get('Followup_Time'));
                        }
                        if((String)JSON_Input.get('Last_VMTime') != null){
                           objNew.Last_VM_Time__c = Datetime.valueOf((String)JSON_Input.get('Last_VMTime'));
                        }
                        objNew.Id = objResponse.OpportunityId;
                        try{
                            update objNew;
                            if(strResponse =='')
                                objResponse.message = 'Opportunity Update Sucessfully.';
                            else
                                objResponse.message = strResponse;
                        }catch(Exception exp){
                            objResponse.message = exp.getmessage();
                        }
                    }
                    if(!Test.isRunningTest()){
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(json.serialize(objResponse));
                    }                   
                //}
                

            }
                      
            Private class ResponseOpportunity{
                String message;
                String OpportunityId;
                String OpportunityName;
            }
        }