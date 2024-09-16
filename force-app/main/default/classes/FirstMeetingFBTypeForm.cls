@RestResource(urlMapping='/FirstMeetingFBTypeForm/*')
global class FirstMeetingFBTypeForm{
    /*@HttpPost
    global static void Typeform() {
        RestRequest req = RestContext.request;
        System.debug(' REQUEST IS : '+req);
        String type = req.requestBody.toString();
        type = type.replace('"number":', '"number_Z":').replace('"text":', '"type_Z":');
        System.debug('******type*******'+type ); 
        FirstMeetingJSON2Apex typeResponse = (FirstMeetingJSON2Apex ) System.JSON.deserialize(type , FirstMeetingJSON2Apex.class); 
        system.debug('******typeResponse*******'+ typeResponse);  
        
        try {
              
            Decimal typeScore = typeResponse.form_response.answers[0].number_Z;
            List<String> multiSel;
            String descr = '';
            
            // All scenarios are taken care of with this nested try-catch. When cx answers either 1st, 2nd, 3rd questions respectively.
            
            try {
            try {
                if(typeResponse.form_response.answers[1].choices.labels != null)
                multiSel = typeResponse.form_response.answers[1].choices.labels;                           
            }
            catch(NullPointerException e) {
                try {   
                    if(typeResponse.form_response.answers[2].type_Z != null)          
                    descr = typeResponse.form_response.answers[2].type_Z; 
                }
                catch(ListException e1) {}
                
                try {
                    if(typeResponse.form_response.answers[1].type_Z != null) 
                    descr = typeResponse.form_response.answers[1].type_Z;
                }
                catch(ListException e2) {}                  
            } 
            }
            catch(ListException e) {
                             
            }  
            
            try {  
                if(typeResponse.form_response.answers[2].type_Z != null)  
                descr = typeResponse.form_response.answers[2].type_Z; 
            }
            catch(ListException e1) {}
            
            try {    
                if(typeResponse.form_response.answers[1].type_Z != null)
                descr = typeResponse.form_response.answers[1].type_Z; 
            }
            catch(ListException e1) {}
            
            String multi1;
            
            String strstDate = typeResponse.form_response.landed_at;
            String strenDate = typeResponse.form_response.submitted_at;
            
            List<String> strListstDate1 = strstDate.split('-');
            List<String> remT1 = strListstDate1[2].split('T');
            List<String> strListstDate2 = remT1[1].split(':');
            String remZ1 = strListstDate2[2].remove('Z');
            System.debug('----remT1 '+remT1 +'  -----strListstDate2  '+strListstDate2 +'  -----remZ1  '+remZ1 );
            DateTime stDate = DateTime.newInstance(Integer.valueOf(strListstDate1[0]), Integer.valueOf(strListstDate1[1]), Integer.valueOf(remT1[0]), Integer.valueOf(strListstDate2[0]), Integer.valueOf(strListstDate2[1]), Integer.valueOf(remZ1));
            System.debug('----stDate  '+stDate );
            
            List<String> strListenDate1 = strstDate.split('-');
            List<String> remT2 = strListenDate1[2].split('T');
            List<String> strListenDate2 = remT2[1].split(':');
            String remZ2 = strListenDate2[2].remove('Z');
            System.debug('----remT2 '+remT2 +'  -----strListenDate2  '+strListenDate2 +'  -----remZ2  '+remZ2 );
            DateTime enDate = DateTime.newInstance(Integer.valueOf(strListenDate1[0]), Integer.valueOf(strListenDate1[1]), Integer.valueOf(remT2[0]), Integer.valueOf(strListenDate2[0]), Integer.valueOf(strListenDate2[1]), Integer.valueOf(remZ2));
            System.debug('----enDate  '+enDate );
            
            List<Opportunity> oppUpdate = new List<Opportunity>();
            try {
                if(multiSel.size() > 0) {
                    multi1 = string.join(multiSel,';');
                }
            }
            catch(NullPointerException  e1) {
            
            }
            
            try {
                List<Opportunity> oppList = [select id, name, First_Meeting_Typeform_Score__c, Typeform_Comments__c, What_went_well_Typeform__c from Opportunity where Customer_Email__c =: typeResponse.form_response.hidden.email];            
                if(oppList.size() > 0) {
                    for(Opportunity opp : oppList) {
                        opp.First_Meeting_Typeform_Score__c = typeScore;
                        opp.What_went_well_Typeform__c = multi1;
                        opp.Typeform_Comments__c = descr;
                        opp.Typeform_Start_Time__c = stDate;
                        opp.Typeform_End_Time__c = enDate;
                        System.debug('--typescore  '+opp.First_Meeting_Typeform_Score__c+'  -----multi1----  '+opp.What_went_well_Typeform__c+'  -----descr-----  '+opp.Typeform_Comments__c+'  -----stDate-----  '+stDate+'  -----enDate-----  '+enDate);
                        oppUpdate.add(opp);
                    }
                }
                
                if(!oppUpdate.isEmpty())
                update oppUpdate;
                }
                catch(DMLException e) {
                    System.debug('INSIDE CATCH 1');
                }   
            }
            catch(NullPointerException  e) {
                System.debug('INSIDE CATCH 2');
            } 
    }*/
}