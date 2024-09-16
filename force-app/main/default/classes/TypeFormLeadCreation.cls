// Used to Create a Lead from Type Form 
// Create a salesforce site add the rest class to site
// In TYpe form Give the URL  https://SiteURL/services/apexrest/TypeFormLeadCreation


@RestResource(urlMapping='/TypeFormLeadCreation/*')
global class TypeFormLeadCreation{
    @HttpPost
    global static void Typeform() {
        RestRequest req = RestContext.request;
        System.debug(' REQUEST IS : '+req);
        String type = req.requestBody.toString();
        System.debug('******type*******'+type ); 
        try{
            LeadCreationTypeFormJson typeResponse = (LeadCreationTypeFormJson) System.JSON.deserialize(type , LeadCreationTypeFormJson.class);  
            
            if(typeResponse != NULL){
                if(String.isNotBlank(typeResponse.form_response.answers[0].text) &&
                   String.isNotBlank(typeResponse.form_response.hidden.city) && String.isNotBlank(typeResponse.form_response.hidden.email) &&
                   String.isNotBlank(typeResponse.form_response.hidden.interiordesigneremail) && String.isNotBlank(typeResponse.form_response.hidden.phone)){
                    Lead objlead = new Lead();
                    List<Interior_Designer__c> intDesginer = [Select id from  Interior_Designer__c 
                                                        where Email__c =: typeResponse.form_response.hidden.interiordesigneremail limit 1];
                                                        
                    Map<String,Id> mapMaster = new Map<String,Id>();
                    List<Master__c> maList = [select id,name from Master__c where name = 'TEST33' or  name = 'Test Showroom'];
                    for(Master__c m : maList) {
                        mapMaster.put(m.Name,m.Id);
                    }
                                                                            
                    System.debug('Name +++'+ typeResponse.form_response.answers[0].text);
                    objlead.lastName = typeResponse.form_response.answers[0].text;
                    objlead.email = typeResponse.form_response.hidden.email;
                    objLead.Phone = typeResponse.form_response.hidden.phone;
                    objLead.City = typeResponse.form_response.hidden.city;
                    if(!intDesginer.isEmpty()){
                        objLead.Interior_Designer__c = intDesginer[0].id;
                    }    
                    objLead.LeadSource = 'Test Source';
                    objLead.Status = 'DP Assigned';
                    objLead.Sub_Status__c = 'DP Assigned';
                    objLead.Property_Type__c = 'Apartment';
                    objLead.Property_Config__c = '1 BHK';
                    objLead.Property_Status__c = 'New';
                    objLead.Interior_Start_Date__c = date.today();
                    objLead.Possession_Date__c = Date.today();
                    objLead.Kitchen__c = 'Yes';
                    objLead.Wardrobes__c = '0';
                    objLead.Entertainment_Unit__c = 'Yes';
                    objLead.Foyer_Shoe_Rack__c  = 'Yes';
                    objLead.Crockery_Unit__c = 'Yes';
                    objLead.Study_Table_Book_Shelf__c = 'Yes';
                    objLead.Pooja__c = 'Yes';
                    objLead.Appointment_Time__c = system.now();    
                    objLead.Appointment_Type__c = 'Square Showroom Visit';   
                    objLead.Appointment_Venue_Square__c = mapMaster.get('Test Showroom');     
                    objLead.Property__c = mapMaster.get('TEST33');        
                    
                    //insert objLead;
                    
                    RestResponse res = RestContext.response;
                    res.statusCode = 200; //Signifies OK
                    String jsonResponse = '{"response": {"Success": "Ok","ErrorMsg":""}}';
                    res.responseBody = blob.valueOf(jsonResponse);
                    return;
                }
            }
        }
        catch(Exception e){
            system.debug('Exception e'+e.getStackTraceString()+''+e.getMessage());
            RestResponse res = RestContext.response;
            res.statusCode = 200; //Signifies OK
            String jsonResponse = '{"response": {"Success": "False","ErrorMsg":"e.getMessage()"}}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }    
    }  
}