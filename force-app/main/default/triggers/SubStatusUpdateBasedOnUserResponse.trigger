trigger SubStatusUpdateBasedOnUserResponse on SC_User_Response__c (after insert,after update) {

    /************************************************************************************************************************/
    // Checklist: Based on the User Responses generated for particular sub-status, automatically sub-status has to get updated
    
    map<id,SC_User_Response__c> userRespMap=new map<id,sc_user_response__c>();
    Id oppId;
    for(SC_User_Response__c uResp:trigger.new){
        if(!userRespMap.containsKey(uResp.opportunity__c)){
            userRespMap.put(uResp.opportunity__c,uResp);
            oppId=uResp.opportunity__c;
        }
    }
    system.debug(userRespMap);
    system.debug(oppId);
    list<SC_Section_Item__c> secItem=[SELECT id,Item__c,Section__c FROM SC_Section_Item__c WHERE Item__c =:userRespMap.get(oppId).Item__c AND Section__r.Parent_Section__r.Opportunity_Sub_Status__c =:userRespMap.get(oppId).stage__c];
   // Boolean validate=SC_OpportunityStageValidation.SC_OpportunityStageValidate(oppId,userRespMap.get(oppId).stage__c,secItem);
    /*if(validate==true && userRespMap.get(oppId).stage__c=='Site Measurement Meeting Confirmed'){
        
    }*/
    system.debug(secItem);
    list<opportunity> oppList=new list<opportunity>();
    if(userRespMap.keySet()!=null){
        for(Opportunity oppt:[SELECT id,stageName,sub_status__c FROM opportunity WHERE ID=:userRespMap.keySet()]){
            if(oppt.Sub_status__c==userRespMap.get(oppId).stage__c && oppt.Sub_status__c=='Design Presentation Confirmed'){
                oppt.Sub_status__c='Design Presentation Completed';
                oppList.add(oppt);
            }
            else if(oppt.Sub_status__c==userRespMap.get(oppId).stage__c && oppt.Sub_status__c=='Project kick-off Meeting Confirmed'){
                oppt.Sub_status__c='Project kick-off Completed';
                oppList.add(oppt);
            }
            else if(oppt.Sub_status__c==userRespMap.get(oppId).stage__c && oppt.Sub_status__c=='Site Measurement Meeting Confirmed'){
                oppt.Sub_status__c='Site Measurement Completed';
                oppList.add(oppt);
            }
        }
    }
    try{
        if(!oppList.isEmpty())
            update opplist;
            
    }catch(DMLException e){
        system.debug('an exception occured while updating opportunity');
    }
}