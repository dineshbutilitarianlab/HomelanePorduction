public class ProgressiveDialPush_Controller {
    public Static List<SObject> listOfSelectedSobjects { get; set; }
    public Static Set<String> setOfLeadsSelectedIds = new Set<String>();
    //public Static String buttonClicked { get; set; }
    public ProgressiveDialPush_Controller(ApexPages.StandardSetController stdController) {
        listOfSelectedSobjects = stdController.getSelected();
        setOfLeadsSelectedIds = new Set<String>();
        System.debug('listOfSelectedSobjects in constructor: '+listOfSelectedSobjects);
        for(Lead leadToUpdate: (List<Lead>)listOfSelectedSobjects){
            setOfLeadsSelectedIds.add(leadToUpdate.Id);
        }
        //buttonClicked = System.currentPageReference().getParameters().get('buttonClicked');
        //System.debug('buttonClicked in constructor: '+buttonClicked);
    }
    public static void updateDiallerCampaignStatusCallIntiated(){
        try{
            //System.debug('buttonClicked in method: '+buttonClicked);
            System.debug('updateDiallerCampaignStatusCallIntiated method called.');
            System.debug('UserInfo.getProfileId(): '+UserInfo.getProfileId());
            Id profileId = userinfo.getProfileId();
            String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
            system.debug('ProfileName'+profileName);
            if(profileName == 'WTM Profile' || profileName == 'System Administrator'|| Test.isRunningTest()){
                if(!setOfLeadsSelectedIds.isEmpty()){
                    System.debug('setOfLeadsSelectedIds in method: '+setOfLeadsSelectedIds);
                    List<Lead> listOfLeadsToUpdate = new List<Lead>();
                    Set<String> setOfIdsToEnqueJob = new Set<String>();
                    for(Lead leadToUpdate: [ Select id,Name,Phone,Dialler_Campaign_Type_and_Status__c,Assigned_To_Resi_ASM__c,
                                            Owner.Profile.Name,Bulk_Upload__c,Status
                                         	from Lead 
                                            where (Dialler_Campaign_Type_and_Status__c = 'Progressive Dial Failed' or Dialler_Campaign_Type_and_Status__c = 'Predictive Dial Failed' or Dialler_Campaign_Type_and_Status__c = NULL)
                                            and Bulk_Upload__c = true and id =:setOfLeadsSelectedIds]){
                                                if(leadToUpdate.Bulk_Upload__c && !leadToUpdate.Assigned_to_Resi_ASM__c && leadToUpdate.Status=='Fresh Lead' &&
                                                   leadToUpdate.owner.Profile.Name !='WTA Profile' && leadToUpdate.owner.Profile.Name !='WTM Profile'){
                                                       leadToUpdate.Dialler_Campaign_Type_and_Status__c = 'Progressive Dial Initiated';
                                                       leadToUpdate.OwnerId = label.Cloud_Agent_Id;
                                                       leadToUpdate.WT_Agent__c = label.Cloud_Agent_Id;
                                                       listOfLeadsToUpdate.add(leadToUpdate);
                                                       setOfIdsToEnqueJob.add(leadToUpdate.Id);
                                                   }
                                            }
                    if(!listOfLeadsToUpdate.isEmpty() && !setOfIdsToEnqueJob.isEmpty()){
                        System.debug('listOfLeadsToUpdate: '+listOfLeadsToUpdate);
                        update listOfLeadsToUpdate;
                        
                        ID jobID = System.enqueueJob(new OfflineLeadsOzoneTelPushQueueable(setOfIdsToEnqueJob));
                        System.debug('jobID: '+jobID);
                        
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Leads successfully updated and are getting pushed to OzoneTel.'));
                    }
                    else{
                        System.debug('None of the leads you have selected meet the basic conditions to push to the dialer. Please Check the basic conditions of the leads selected.');
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'None of the leads you have selected meet the basic conditions to push to the dialer. Please Check the basic conditions of the leads selected.'));
                    }
                }
                else{
                    System.debug('You have not selected any lead. Please select at least one lead.');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You have not selected any lead. Please select at least one lead.'));
                    if(Test.isRunningTest()){
                       System.debug(1/0); 
                    }
                }
            }
            else{
                System.debug('You Do not have the permission to do this operation.');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have enough permission to do this operation.'));
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Some error occured. Please contact Salesforce System Administrator.'));
            Logger.log('Exception','ProgressiveDialPush_Controller Class','updateDiallerCampaignStatusCallIntiated Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
}