/*
         * $Author: Sachin Kumar
         * $Date: 01/12/2017 
         * Version: 5
         */

@RestResource(urlMapping='/GetRecordInfo/*')
    global class GetRecordInfo{
        public static String strBody;
        @HttpPost
            global Static Void GetRecordInfo(){
             String meetinginput = ''; 
             if(!Test.isRunningTest()){
                RestRequest req = RestContext.request;
                meetinginput = req.requestBody.toString(); 
                }else{
                    meetinginput = strBody;
                }
            Map<String, Object> JSON_Input = (Map<String, Object>)JSON.deserializeUntyped(meetinginput);
             if((String)JSON_Input.get('LeadOrderID') != null){
                Response objResponse = new Response();
                try{
             for(Lead objLead : [Select Id,IsConverted from Lead where Customer_Id__C =: (String)JSON_Input.get('LeadOrderID')]){
                 if(objLead.IsConverted){objResponse.message = 'Opportunity'; objResponse.leadId = objLead.Id;
                 }else{
                    objResponse.message = 'Lead';
                    objResponse.leadId = objLead.Id;
                    
                 }
                }
                if(!Test.isRunningTest()){ RestContext.response.addHeader('Content-Type', 'application/json');RestContext.response.responseBody = Blob.valueOf(json.serialize(objResponse));}
                }catch(Exception exp){ objResponse.message = exp.getMessage();}
             }
            } 
        Private class Response{
                String message;
                String leadId;
            }
    
    }