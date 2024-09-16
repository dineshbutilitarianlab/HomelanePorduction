public class MilestoneTriggerHandler{

    /****************************************************************************************************/
    // To count number of sub-milestone type records based on insert and update which is used for project planner
    
    
    public static void increaseCountInParentMileStone(list<Milestone__c> listMileStone){
        Map<Id,Integer> countSubMileStone=new Map<Id,Integer>();
        for(Milestone__c mStone:listMileStone){
            if(mStone.Milestone__c != null) {
                if(!countSubMileStone.containsKey(mStone.Milestone__c)) {
                        countSubMileStone.put(mStone.Milestone__c , 1);
                 }else {
                        countSubMileStone.put(mStone.Milestone__c , countSubMileStone.get(mStone.Milestone__c)+1);
                }
             }
        }
        system.debug('countSubMileStone='+countSubMileStone);
        List<Milestone__c> mileStonelist = new List<Milestone__c>();
        
        for(Milestone__c milStones: [SELECT Id, Number_Of_Sub_MileStone_Records__c FROM Milestone__c WHERE Id IN : countSubMileStone.keySet()] ) {
           if(milStones.Number_Of_Sub_MileStone_Records__c>=1){
                milStones.Number_Of_Sub_MileStone_Records__c += countSubMileStone.get(milStones.Id);
           }else{
                milStones.Number_Of_Sub_MileStone_Records__c = countSubMileStone.get(milStones.Id);
           }
            mileStonelist.add(milStones);
        }
        if(!mileStonelist.isEmpty())
        update mileStonelist;
    }
    
    /*********************************************************************************************************************/
    
    /**********************************************************************************************************************/
    // To count or to decrease the number of sub-task type records based on after delete event which is used for project planner
     
    public static void decreaseCountInParentMileStone(list<Milestone__c> listMileStone){
        Map<Id,Integer> countSubMileStone=new Map<Id,Integer>();
        for(Milestone__c mStone:listMileStone){
            if(mStone.Milestone__c != null) {
                if(!countSubMileStone.containsKey(mStone.Milestone__c)) {
                        countSubMileStone.put(mStone.Milestone__c , 1);
                 }else {
                        countSubMileStone.put(mStone.Milestone__c , countSubMileStone.get(mStone.Milestone__c)-1);
                }
             }
        }
        system.debug('countSubMileStone='+countSubMileStone);
        List<Milestone__c> mileStonelist = new List<Milestone__c>();
        
        for(Milestone__c milStones: [SELECT Id, Number_Of_Sub_MileStone_Records__c FROM Milestone__c WHERE Id IN : countSubMileStone.keySet()] ) {
           if(milStones.Number_Of_Sub_MileStone_Records__c>=1){
                milStones.Number_Of_Sub_MileStone_Records__c -= countSubMileStone.get(milStones.Id);
           }/*else{
                milStones.Number_Of_Sub_MileStone_Records__c -= countSubMileStone.get(milStones.Id);
           }*/
            mileStonelist.add(milStones);
        }
        if(!mileStonelist.isEmpty())
        update mileStonelist;
    }
    
    /*******************************************************************************************************************/
}