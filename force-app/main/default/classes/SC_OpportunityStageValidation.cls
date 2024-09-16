/*
 * Description : To validate and display Message to user whether Opportunity is ready to move to next Stage or not.
 * Created Date: 11/02/2016
 * Created By  : Naveen Kumar B H
*/
public class SC_OpportunityStageValidation { 
    @AuraEnabled
    public static Boolean SC_OpportunityStageValidate(Id OpportunityId, String StageName,List<SC_Section_Item__c> listSectn){
        try{
            /* 
             * Query to get SC_Item,SC_User_Response__c(child of SC_Item) and SC_Response__c(child of SC_Item).
             * From SC_Response__c object , we are querying only responses which are required to move to next stage. 
            */
            
            Set<Id> setItemId = new Set<Id>();
            for(SC_Section_Item__c secItm : listSectn){
                setItemId.add(secItm.Item__c);
            }
            for(SC_Item__c item : [SELECT Id,Item__c,Response_Type__c,
                                   (SELECT Item__c,Stage__c,User_Response__c 
                                    FROM SC_User_Responses__r 
                                    WHERE Stage__c =: StageName 
                                    AND Opportunity__c =: OpportunityId),
                                   (SELECT Answer__c,Is_Active__c,Item__c,Required_for_Next_Stage__c,Score__c 
                                    FROM  SC_Responses__r 
                                    WHERE Required_for_Next_Stage__c = TRUE)  
                                   FROM SC_Item__c 
                                   WHERE (Response_Type__c = 'Picklist' OR Response_Type__c = 'Check Box' OR Response_Type__c = 'Date') AND Id IN : setItemId]){
                                       
                                       if(!item.SC_Responses__r.isEmpty()){
                                           if(!item.SC_User_Responses__r.isEmpty()){
                                               //To check all question's response, setting flag value to false for each question.
                                               Boolean flag = false;
                                               if(item.Response_Type__c == 'Picklist'){
                                                   for(SC_Response__c response : item.SC_Responses__r){ 
                                                       if(item.SC_User_Responses__r[0].User_Response__c == response.Answer__c){
                                                           //Settting flag as TRUE if user response is in response list which is required to move to next stage.
                                                           flag = true;
                                                       }
                                                   }
                                               }else if(item.Response_Type__c == 'Check Box'){
                                                   if(item.SC_User_Responses__r[0].User_Response__c == 'true'){
                                                       flag = true;
                                                   }
                                               }
                                               else {
                                                   if(item.SC_User_Responses__r[0].User_Response__c != null && item.SC_User_Responses__r[0].User_Response__c != ''){
                                                       system.debug('***********'+item.SC_User_Responses__r[0].User_Response__c);
                                                       flag = true;
                                                   }

                                               }
                                               if(!flag){
                                                   //If any one of required questioned is not answered or other answer is given then not ready message will be displayed.
                                                   return false;
                                               }
                                           }else{
                                               return false;
                                           }
                                       }            
                                   }
        }
        catch(Exception e){
            System.debug('Exception ----->'+e);
            // if all requred answers are given, then method will return true. And Redy to move message will be displayed.
            return true;
        }
        return true;
    }
}