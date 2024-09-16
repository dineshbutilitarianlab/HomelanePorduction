Global Class Rest_Update_SCVM_To_Roster{
    Webservice static void updateMeeting(id LeadID){  
        system.debug('objLeadID'+LeadID);
        if(String.isNotBlank(LeadID)){
            try{
                Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                Integration_Setting__c integrationDetail = allEndPoint.get('UpdateSCVM API');
                
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(integrationDetail.End_Point__c+'?id='+LeadID);
                request.setMethod('GET');
                System.debug('REQUEST   '+request );
                
                 HttpResponse response = http.send(request);
                 System.debug('RESPONSE   '+response.getBody()); 
                 
            }
            catch(Exception e){System.debug('Exception '+e);}
        }
    }
}