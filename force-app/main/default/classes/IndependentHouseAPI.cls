@RestResource(urlMapping='/IndependentHouseAPI/*') 
global class IndependentHouseAPI {
    @HttpPost
    global static void IndependentHouse() {
         //creating instance to get request data
         RestRequest req = RestContext.Request;
         String inputData = req.requestBody.toString();
         Map<String,Object> JSON_Input = (Map<String,Object>)JSON.deserializeUntyped(inputData);
         System.debug('***JSON_Input '+JSON_Input);
         Map<String,String> mapRecordType = new Map<String,String>();
         List<FinalWrapper> finalList = new List<FinalWrapper>();
         try {
               Lead objLead = new Lead();
               List<Lead> leadList = [select id, name from Lead where id =:(String) JSON_Input.get('LeadId')];
               if(leadList.size() > 0) {
                   System.debug('Its a Lead');
                   objLead.Id = (String) JSON_Input.get('LeadId');
               }
               
               Opportunity objOpp = new Opportunity ();
               List<Opportunity> oppList = [select id, name from Opportunity where id =:(String) JSON_Input.get('LeadId')];
               if(oppList.size() > 0) {
                   System.debug('Its an Opportunity');
                   objOpp.Id = (String) JSON_Input.get('LeadId');
               }    
                        
             objLead.Property__c = label.Wt_Independent_Property;
             objLead.Independent_House_Address__c = (String) JSON_Input.get('Independent_House_Address__c');
             objLead.Property_Type__c = (String) JSON_Input.get('Property_Type__c');
             System.debug('****objLead  '+objLead); 
             
             objOpp.Property_Name__c = label.Wt_Independent_Property;
             objOpp.Independent_House_Address__c = (String) JSON_Input.get('Independent_House_Address__c');
             objOpp.Property_Type__c = (String) JSON_Input.get('Property_Type__c');
             System.debug('****objOpp  '+objOpp); 
           
              FinalWrapper fin = new FinalWrapper();
                fin.status = true;
                fin.errorMsg = '';
                finalList.add(fin);  
                if(objLead.Id != null)      
                update objLead;
                if(objOpp.Id != null)      
                update objOpp;
         }
         catch(Exception exp) {
            FinalWrapper fin = new FinalWrapper();
            fin.status = false;
            fin.errorMsg = exp.getMessage();
            System.debug('*****fin.errorMsg  '+fin.errorMsg);
            finalList.add(fin);
         }
    }
     global class FinalWrapper{
            public boolean status{get;set;}
            public String errorMsg{get;set;}
         
        }               
}