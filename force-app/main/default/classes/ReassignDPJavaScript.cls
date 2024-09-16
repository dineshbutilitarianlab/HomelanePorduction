global class ReassignDPJavaScript {
    
    webservice static void NoShowButton(Id Leadid)
    {    
    try {   
        System.debug('Lead id value --> '+leadid);
        Lead ld = [select id, name, Interior_Designer__c, Customer_Score__c, Property__c, Interior_Designer__r.Email__c, Appointment_Time__c, city, Email_For_Communication__c, Property__r.Name,Meeting_Status__c, Appointment_Venue_Square__c, Appointment_Venue_Square__r.Name, Preferred_Language__c,DP_Stack_Rank__c, Regional_Language_Preference__c, Budget_Range__c from Lead where id=:Leadid];
        ld.Interior_Designer__c = null;
        update ld;
        DateTime gst = ld.Appointment_Time__c.addHours(-5).addMinutes(-30);
        String con = '{"dp_email":"'+ld.Interior_Designer__r.email__c+'","showroom_name":"'+ld.Appointment_Venue_Square__r.Name+'","meeting_start":"'+gst+'","customer_email":"'+ld.Email_For_Communication__c+'"}';
        System.debug('-----con   '+con ); 
        callNoShow(con);
        }
        catch(Exception e) {}
        
    }
    @future(callout=true)
    global static void callNoShow(String con)  {
        DPAssignment__c noShow = DPAssignment__c.getValues('NoShow');
        String noShow1 = noShow.API__c;
        
        Http http = new http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(noShow1);
        request.setMethod('POST');
        request.setBody(con);
        request.setTimeout(120000);
        System.debug('-----request  '+request); 
        HttpResponse response = http.send(request);  
        System.debug('-----response  '+response ); 
        System.debug('-----response body '+response.getBody()); 
        Map<String, Object> json_req_input = (Map<String, Object>)JSON.deserializeUntyped(response.getBody()); 
        system.debug('******json_req_input ReassignDPJavaScript*******'+json_req_input );
    }
}