/**
* @File Name          : IronmenBacklogsUpdateBatchHandler.cls
* @Description        : Batch class.
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 11/21/2019, 12:21:43 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author      		      Modification
*==============================================================================
* 1.0    11/21/2019, 12:20:14 PM   Bharatesh Shetty     Initial Version
**/
public class IronmenBacklogsUpdateBatchHandler {
    public static void updateBackLogsCount(Set<Id> setOfIronmenId,Map<Id,AggregateResult> mapOfIronmanWithAggregateResult){
        try{
            if(!setOfIronmenId.isEmpty() && !mapOfIronmanWithAggregateResult.isEmpty()){
                Map<Id,Showroom_User__c> mapOfIronMenToUpdateBacklogs = new Map<Id,Showroom_User__c>();
                for(Id ironmanId :setOfIronmenId){
                    Showroom_User__c ironman = new Showroom_User__c();
                    ironman.Id = ironmanId;
                    if(mapOfIronmanWithAggregateResult.containskey(ironmanId)){
                        ironman.Backlogs__c = (Decimal)mapOfIronmanWithAggregateResult.get(ironmanId).get('expr0');
                    }
                    else{
                        ironman.Backlogs__c = 0;
                    }
                    mapOfIronMenToUpdateBacklogs.put(ironmanId,ironman);
                    System.debug('ironman record Update: '+ironman);
                }
                if(!mapOfIronMenToUpdateBacklogs.isEmpty()){
                    update mapOfIronMenToUpdateBacklogs.values();
                }
            }
            
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            Logger.log('Exception','IronmenBacklogsUpdateBatchHandler class','updateBackLogsCount method',e.getMessage(),e.getStackTraceString(),null);
        } 
    }
    
}