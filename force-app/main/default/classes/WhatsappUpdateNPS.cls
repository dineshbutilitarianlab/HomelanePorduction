@RestResource(urlMapping='/WhatsappUpdateNPS/*')
global class WhatsappUpdateNPS{

    @HTTPPost
    global static void updateNPS() {
        ResponseWrapper wrapper = new ResponseWrapper();
        try {
            RestRequest req = RestContext.request;
            String input = req.requestBody.toString();
            system.debug('******input *******  '+input );
            Map<String,Object> json_input = (Map<String,Object>)JSON.deserializeUntyped(input);
            system.debug('******json_input*******  '+json_input);
            
            String OpporuntiyNumber = (String)json_input.get('UniqueOpporunityID');
            //String OpporunityPhone = (String)json_input.get('Phone');
            if(String.isNotBlank(OpporuntiyNumber)){
                String l = 'select id, Customer_Satisfaction__c, Final_Customer_Response__c from Opportunity  where Customer_ID__c =: OpporuntiyNumber order by createdDate desc limit 1';
                system.debug('+++ String +++'+l);
                Opportunity Opp = Database.query(l);
                system.debug('******Opp *******  '+Opp );
                if(Opp != NULL){

                    // Update NPS
                    String NPS = (String)json_input.get('NPS');
                    Opp.Customer_Satisfaction__c = (String.isNotBlank(NPS)) ? Integer.valueOf(NPS):Opp.Customer_Satisfaction__c;

                    // Update the Response from customer 

                    String CustomerResponse = (String)json_input.get('CustomerResponse');
                    Opp.Final_Customer_Response__c = String.isNotBlank(CustomerResponse) ? CustomerResponse : Opp.Final_Customer_Response__c;

                    system.debug('******Opp *******  '+Opp );
                    String opptyID =  opp.id;
                    list<Whatsapp_Message__c> lstwhats = new list<Whatsapp_Message__c>();
                    lstwhats = [select id, name, Call_Back_Request__c, Delivered__c, Read__c, Responded__c, Responded_First_Time__c, Responded_Last_Time__c, Response_Msg__c, Sent__c 
                                from Whatsapp_Message__c 
                                where Opportunity__c =: Opp.id and name = 'WA - NPS Request Sent'  order by createdDate desc limit 1];
                     system.debug('******lstwhats *******  '+lstwhats );
                    if(lstwhats!= NULL && !lstwhats.isEmpty()){
                        lstwhats[0].Responded__c = 'Yes';
                        if( lstwhats[0].Responded_First_Time__c == null){
                            lstwhats[0].Responded_First_Time__c = System.now();
                        }     
                        lstwhats[0].Responded_Last_Time__c = System.now();  
                        lstwhats[0].Final_NPS_Score__c = Opp.Customer_Satisfaction__c;
                        lstwhats[0].Final_Customer_Response__c = Opp.Final_Customer_Response__c;
                    
                        System.debug('lstwhats'+lstwhats);
                        System.debug('=======Opp====='+Opp);
                        update lstwhats;
                    }
                    Update Opp;    
                        
                    wrapper.status_code = '201';
                    wrapper.message = 'Success';
                }
                else{
                    wrapper.status_code = '501';
                    wrapper.message = 'UniqueOpporunityID Doesn\'t exists in SF' ;
                }
            }
            else{
                wrapper.status_code = '501';
                wrapper.message = 'Empty UniqueOpporunityID';
            }
        }
        catch(Exception e) {
            system.debug('---- Exception occured----'+e.getStackTraceString());
            wrapper.status_code = '501';
            wrapper.message = 'Failure';
        }
        
        String json = json.serialize(wrapper);
        RestContext.response.addHeader('Content-Type','application/json');
        RestContext.response.responseBody = Blob.valueOf(json);
    }
    global class ResponseWrapper 
    {
        String status_code;
        String message;
    }
}