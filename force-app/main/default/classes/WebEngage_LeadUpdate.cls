public class WebEngage_LeadUpdate implements Queueable{

    private List<Lead> lstLead; 
    public WebEngage_LeadUpdate (List<Lead> leadList) {
        this.lstLead = leadList;
    }
    public void execute(QueueableContext context){
        if(!lstLead.isEmpty()){
            try{
                if(!lstLead.isEmpty()){
                    integer leadCounter = 0;
                    List<Database.SaveResult> results = Database.update(lstLead, false);
                    for (Database.SaveResult result : results) {

                    if (!result.isSuccess()){
                        for (Database.Error err : result.getErrors()){
                             Logger.log('Update Failed','WebEngage_LeadUpdate class','execute method','Lead ID--->' +lstLead[leadCounter].id+'Last Seen Date--->'+lstLead[leadCounter].WebEngage_Last_Seen__c,NULL,NULL);
                        }
                    }else{
                            //Do Nothning 
                        }
                    leadCounter++;
                    }
                }
            }
            catch(Exception e){
                System.debug('Exception occures  '+e.getMessage()+'Stack Trace  '+e.getStackTraceString());
                Logger.log('Exception','Rest_UpdateNameAPI class','UpdateNameAPI method',e.getMessage(),e.getStackTraceString(),NULL);
            }        
        }
    }
}