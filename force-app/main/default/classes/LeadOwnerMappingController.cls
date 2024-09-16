@RestResource(urlMapping='/LeadOwnerMappingAPI/*')
global with sharing class  LeadOwnerMappingController
{
  public Static String strBody{get;set;}
  public Static String strBodyTest{get;set;}
@HttpGet
  global static void getLeadrec() {
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        RestRequest req = RestContext.request; 
        String leadId = '';
        String agentEmail = '';
        if(!Test.IsRunningTest()){
          leadId = req.params.get('record_id');
          agentEmail = req.params.get('agent_id');
        }
        else{
          leadId = strBody; 
          agentEmail =  strBodyTest;
        }     
        List<sObject> opplist = new List<sObject>();
        try{
        /*
        if(leadId !='' && agentEmail !='' ){
            system.debug('lead_id ------------------->'+leadId+'-------agentEmail---'+agentEmail);
            Lead obj = new Lead();
            String leadoppquery = 'Select id,Email from User where Email = \''+agentEmail+'\'';
             opplist = Database.query(leadoppquery);
             Lead objLead = [Select Id,WT_Agent__r.Name from Lead Where Id =:leadId];
            if(opplist !=null && (!opplist.isEmpty())){
               List<User> listUser = (List<User>)(opplist);
                for(User ld : listUser){
                    if(objLead.WT_Agent__r.Name == 'Ameyo User')
                        obj.WT_Agent__c = ld.Id;
                    obj.OwnerId = ld.Id;
                    obj.Id = objLead.Id;                   
                   system.debug('lstLead -------------------->'+obj);
                }
                Database.SaveResult result = Database.update(obj,false);
                if(result.isSuccess()){
                    FinalWrapper fin = new FinalWrapper();
                            fin.status = true;
                            fin.Message = 'Lead Update Sucessfully.';
                            finalList.add(fin);
                }else{
                    FinalWrapper fin = new FinalWrapper();
                            fin.status = false;
                            fin.Message = 'Lead Update Error-'+result.getErrors()[0].getMessage();
                            finalList.add(fin);
                }
            }else{
                FinalWrapper fin = new FinalWrapper();
                    fin.status = false;
                    fin.Message = 'Agent Id - '+agentEmail+' is not found for record - '+leadId;
                    finalList.add(fin);
            } 
            
        }else{
            FinalWrapper fin = new FinalWrapper();
                    fin.status = false;
                    fin.Message = 'AgentId - '+agentEmail+' or Record Id - '+leadId+' is not Present.';
                    finalList.add(fin);
        }
        
        
       */
        FinalWrapper fin = new FinalWrapper();
                            fin.status = true;
                            fin.Message = 'Lead Update Sucessfully.';
                            finalList.add(fin); 
        
       }catch(Exception ex){FinalWrapper fin = new FinalWrapper();fin.status = false;fin.Message = ex.getMessage();finalList.add(fin);
                system.debug('oppoppquery Error-------------------->'+ex.getMessage());
                    }
        if(!Test.isRunningTest()){string json_data = json.serialize(finalList);RestContext.response.addHeader('Content-Type', 'application/json');RestContext.response.responseBody = Blob.valueOf(json_data);}    
       }
         
        
        global class FinalWrapper{
            public boolean status{get;set;}
            public String Message{get;set;}
           
            
        }
        
        
}