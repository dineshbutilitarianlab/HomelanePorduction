/**
* @File Name          : WTACounterUpdateHandler.cls
* @Description        : Handler class for running the logics of WTACounterUpdateBatch class. Test Class: WTACounterUpdateBatch_Test
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 7/31/2019, 2:18:09 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author      		      Modification
*==============================================================================
* 1.0    7/31/2019, 4:51:50 PM   Bharatesh Shetty     Initial Version
**/
public class WTACounterUpdateHandler {
    /**
* @description | Method to refresh daily, Weekly and Monthly Assignment counter based on the condition.
* @author Bharatesh Shetty | 7/31/2019
* @param List<WTA_Assignment__c> listOfWTAAssignment, String  contextToRUNLogic
* @return String
*/
    public static void refreshWTAAssignmentCounter(List<WTA_Assignment__c> listOfWTAAssignment, String contextToRUNLogic){
        try{
            if(!listOfWTAAssignment.isEmpty() && !String.isBlank(contextToRUNLogic)){
                Map<Id,WTA_Assignment__c> mapOfWTAAssignmentToUpdate = new Map<Id,WTA_Assignment__c>();
                for(WTA_Assignment__c eachWTAAssignment : listOfWTAAssignment){
                    WTA_Assignment__c WTAAssignmentToUpdate = new WTA_Assignment__c();
                    WTAAssignmentToUpdate.Id = eachWTAAssignment.Id;
                    if(contextToRUNLogic == 'MONTHLY'){
                        WTAAssignmentToUpdate.Daily_Assignment__c = 0;
                        WTAAssignmentToUpdate.Weekly_Assignment__c = 0;
                        WTAAssignmentToUpdate.Monthly_Assignments__c = 0;
                        
                    }
                    else if(contextToRUNLogic == 'WEEKLY') {
                        WTAAssignmentToUpdate.Daily_Assignment__c = 0;
                        WTAAssignmentToUpdate.Weekly_Assignment__c = 0;
                    }
                    else if(contextToRUNLogic == 'DAILY'){
                        WTAAssignmentToUpdate.Daily_Assignment__c = 0;
                    }
                    mapOfWTAAssignmentToUpdate.put(WTAAssignmentToUpdate.Id, WTAAssignmentToUpdate);
                }
                if(!mapOfWTAAssignmentToUpdate.isEmpty()){
                    update mapOfWTAAssignmentToUpdate.values();
                }
            }  
        }
        catch(Exception e){
            Logger.log('Exception','WTACounterUpdateHandler','refreshWTAAssignmentCounter',e.getMessage(),e.getStackTraceString(),NULL);
        }
    }
}