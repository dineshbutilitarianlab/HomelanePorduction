@RestResource(urlMapping='/InboundIVR/*')
global with sharing class  InboundIVRController
{
  public Static String strBody{get;set;}
@HttpGet
  global static void getLeadrec() {
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        RestRequest req = RestContext.request; 
        String LeadOrderID = '';
        if(!Test.IsRunningTest())
          LeadOrderID = req.params.get('LeadOrderID');
        else
          LeadOrderID = strBody;  
        List<sObject> opplist = new List<sObject>();
        //List<sObject> leadlist = new List<sObject>(); 
        try{
        if(LeadOrderID!=''){
            system.debug('LeadOrderID ------------------->'+LeadOrderID);
            String leadoppquery = 'Select id,WT_Agent__r.Email from Lead where Customer_ID__C = \''+LeadOrderID+'\' AND IsConverted = false';
            if(Database.query(leadoppquery)!=null && (!Database.query(leadoppquery).isEmpty())){
                opplist = Database.query(leadoppquery);
                List<Lead> listopp = (List<Lead>)(opplist);
                for(Lead ld : listopp){
                    FinalWrapper fin = new FinalWrapper();
                    fin.status = true;
                    fin.agent_id = ld.WT_Agent__r.Email;
                    finalList.add(fin);
                    system.debug('leadoppquery -------------------->'+finalList);
                }
            }else{
                FinalWrapper fin = new FinalWrapper();
                    fin.status = false;
                    fin.agent_id = '';
                    finalList.add(fin);
            } 
            
        }
       }catch(Exception ex){FinalWrapper fin = new FinalWrapper();fin.status = false;fin.agent_id = '';finalList.add(fin);
                system.debug('oppoppquery Error-------------------->'+ex.getMessage());
                    }
         if(!Test.isRunningTest()){string json_data = json.serialize(finalList);RestContext.response.addHeader('Content-Type', 'application/json');RestContext.response.responseBody = Blob.valueOf(json_data);
                    }    
       }
         
        
        global class FinalWrapper{
            public boolean status{get;set;}
            public String agent_id{get;set;}
           
            
        }
        
        
}