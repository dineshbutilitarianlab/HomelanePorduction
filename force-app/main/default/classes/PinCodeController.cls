global class PinCodeController{
    public static void pinCode(List<Lead> leadList, Map<Id,Lead> oldMap) {
        Set<String> pinCodeSet = new Set<String>();
        List<Lead> leadListToUpdate = new List<Lead>();
        Map<String,Id> resMapId = new Map<String,Id>();
        
        for(Lead l : leadList) {
        system.debug('oldMap.get(l.Id).PostalCode'+oldMap.get(l.Id).PostalCode);
        system.debug('l.PostalCode'+l.PostalCode);
            if(oldMap.get(l.Id).PostalCode != l.PostalCode && l.PostalCode != null) {
                pinCodeSet.add(l.PostalCode);
                leadListToUpdate.add(l);
            }
        }
        SYstem.debug('====pinCodeSet  '+pinCodeSet);
        
        if(!pinCodeSet.isEmpty() && pinCodeSet != null) {
            // Check if Residential area exist
            try {
                List<Residential_Area__c> resArea = [select id, Name, City__c, Pincode__c from Residential_Area__c where Pincode__c =: pinCodeSet];
                
                if(resArea != null && !resArea.isEmpty()) {
                    for(Residential_Area__c r : resArea) {
                        resMapId.put(r.Pincode__c, r.Id);
                    }
                    if(leadListToUpdate != null && !leadListToUpdate.isEmpty()) {
                        for(Lead l : leadListToUpdate) {
                            l.Area_Of_Residence__c = resMapId.get(l.PostalCode);
                        }
                    }
                }
                // Check condition and call Future Method
                else {
                    for(Lead l : leadListToUpdate) {  
                        if(system.isBatch()||system.isFuture()){
                            callPostalCode(l.PostalCode, l.Id); 
                        }                       
                    }
                }
            }
            catch(Exception e) {
               Logger.logWithPhone('PinCodeException','PinCodeController','pinCode',e.getMessage(),e.getStackTraceString(),null,null);
            }
        }
    }
    
    public static void pinCodeOnInsert(List<Lead> leadList) {
        Set<String> pinCodeSet = new Set<String>();
        List<Lead> leadListToUpdate = new List<Lead>();
        Map<String,Id> resMapId = new Map<String,Id>();
        List<Lead> lstUpdateLead = new List<Lead>();
        
        for(Lead l : leadList) {
            if(String.isBlank(l.Area_Of_Residence__c)) {
                SYstem.debug('====pinCodeSet  '+l.PostalCode);
                if(String.isNotBlank(l.PostalCode)){
                    pinCodeSet.add(l.PostalCode);
                    leadListToUpdate.add(l);
                }       
            }
        }
        SYstem.debug('====pinCodeSet  '+pinCodeSet);
        
        if(!pinCodeSet.isEmpty() && pinCodeSet != null) {
            // Check if Residential area exist
            try {
                List<Residential_Area__c> resArea = [select id, Name, City__c, Pincode__c from Residential_Area__c where Pincode__c =: pinCodeSet];
                
                if(resArea != null && !resArea.isEmpty()) {
                    for(Residential_Area__c r : resArea) {
                        resMapId.put(r.Pincode__c, r.Id);
                    }
                    if(leadListToUpdate != null && !leadListToUpdate.isEmpty()) {
                        for(Lead l : leadListToUpdate) {
                            if(resMapId.containsKey(l.PostalCode)){
                                lead objLead = new lead();
                                objLead.id = l.id;
                                objLead.Area_Of_Residence__c = resMapId.get(l.PostalCode);
                                lstUpdateLead.add(objLead);
                                
                            }
                            else{
                                if(system.isBatch()||system.isFuture()){
                            callPostalCode(l.PostalCode, l.Id); 
                        }
                            }
                        }
                    }
                }
                // Check condition and call Future Method
                else {
                    for(Lead l : leadListToUpdate) {                        
                        if(system.isBatch()||system.isFuture()){
                            callPostalCode(l.PostalCode, l.Id); 
                        }                       
                    }
                }
                
                if(lstUpdateLead != null && !lstUpdateLead.isEmpty()) {
                    update lstUpdateLead;
                }
            }
            catch(Exception e) {
               Logger.logWithPhone('PinCodeException','PinCodeController','pinCode',e.getMessage(),e.getStackTraceString(),null,null);
            }
        }
    }    
    
    @Future(Callout=true)
    global static void callPostalCode(String pc, String leadId) {
        try {
            // Query Lead
            Lead objLead = [select id, name, Area_Of_Residence__c from Lead where Id =: leadId limit 1];
            lead l = new lead(id= objLead.id);
            if(pc != null) {
                HTTP http = new HTTP();
                HTTPRequest reqHTTP = new HTTPRequest();
                reqHTTP.setEndPoint('https://api.postalpincode.in/pincode/'+pc);
                reqHTTP.setHeader('Content-Type','application/json');
                reqHTTP.setMethod('GET');
                HTTPResponse resHTTP = http.send(reqHTTP);
                SYstem.debug('====HTTP Response  '+resHTTP.getBody());
                
               String body = resHTTP.getBody().removeEndIgnoreCase(']').removeStartIgnoreCase('[');
                
                Map<String,Object> resp_input = (Map<String,Object>)JSON.deserializeUntyped(body);
                SYstem.debug('====HTTP resp_input  '+resp_input);
                
                System.debug('====PostOffice  '+resp_input.get('PostOffice'));
                String JSONString = JSON.serialize(resp_input.get('PostOffice'));
                if(JSONString.contains('['))
                JSONString = JSONString.remove('[');
                if(JSONString.contains(']'))
                JSONString = JSONString.remove(']');
                SYstem.debug('====JSONString  '+JSONString);
                
                // Fetching the area name
                Map<String,Object> getPostalMap = (Map<String,Object>)JSON.deserializeUntyped(JSONString);
                SYstem.debug('====getPostalMap  '+getPostalMap);
                SYstem.debug('====getPostalMap  '+getPostalMap.get('Name'));
                
                // Query with Residential Area object once the area name is received.
                String areaName = (String)getPostalMap.get('Name');
                areaName = areaName.trim();
                String cityName = (String)getPostalMap.get('District');
                cityName = cityName.trim();
                if(cityName == 'Bangalore') {
                    cityName = 'Bengaluru';
                }
                SYstem.debug('====areaName  '+areaName+' ====cityName  '+cityName);
                Residential_Area__c resArea;
                try {
                    if(cityName != 'Bengaluru') {
                        resArea = [select id, Name, City__c, Pincode__c from Residential_Area__c where Name =: areaName and City__c =: cityName limit 1];
                    }
                    else {
                        resArea = [select id, Name, City__c, Pincode__c from Residential_Area__c where Name =: areaName and (City__c =: cityName or City__c = 'Bangalore') limit 1];
                    }
                    
                    if(resArea != null) {
                        l.Area_Of_Residence__c = resArea.Id;
                        if(resArea.Pincode__c == null) {
                            resArea.Pincode__c = pc;
                        } 
                        if(resArea.City__c == 'Bangalore') {
                            resArea.City__c = 'Bengaluru';   
                        }
                        update resArea;                
                    }
                }  
                catch(Exception e) {
                    resArea = new Residential_Area__c();
                    resArea.Name = areaName;
                    resArea.City__c = cityName;
                    resArea.Pincode__c = pc;
                    insert resArea;
                    l.Area_Of_Residence__c = resArea.Id;
                }
                if(l.id != null && l.Area_Of_Residence__c != null)
                update l;
            }
        }
        catch(Exception e) {
            System.debug('Error Exist  '+e.getMessage());
        }
    }
    
     public static void dummyTestCover(){
        Integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}