public class CallOzoneTelAPIProcessBuilder {

    @InvocableMethod
    public static void callApi(List<id> Leadids)
    {
        List<Lead> ldlst = [Select Id,Owner.Name,WT_Agent__r.Name,City,Phone,WT_Agent__c,OwnerId from Lead Where Id IN : Leadids];
        LeadPushToOzonetelQueueable objLPA = new LeadPushToOzonetelQueueable(ldlst,UserInfo.getSessionId());
        ID jobID = System.enqueueJob(objLPA);
    }
}