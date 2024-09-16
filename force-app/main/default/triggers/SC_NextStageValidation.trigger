/*        crated By : Sanjeev Shukla
 * Last Modified by : Naveen Kumar B H
 *      Description : If Opportunity Type is Printer the while changing form one stage to another this trigger will validate for current
                      whether required user response is given by user for Current stage.
 *             Note : Currently this trigger will run only for printer Opportunity Type.        
*/

trigger SC_NextStageValidation on Opportunity (before update,after update) 
 {    
  /* 
     //To get Record Type name from Database.
    Map<id,Opportunity> mapOldOpportunity = Trigger.oldMap;
 
    //To get all Opportunity stages from schema.
    List<String> lstOppStages = SC_MISalesProcess.getOpportunityStages();
    system.debug('-------lstOppStages-------'+lstOppStages);
    
    map<string,list<sc_section_item__c>> mapSubStatusSectionItem=new map<string,list<sc_section_item__c>>();
        
    for(SC_Section_Item__c sc : [SELECT id,Item__c,Section__r.Opportunity_Sub_Status__c,Section__r.Parent_Section__r.Opportunity_Sub_Status__c 
                                                  FROM SC_Section_Item__c 
                                                  WHERE Section__r.Opportunity_Sub_Status__c In: lstOppStages 
                                                  OR Section__r.Parent_Section__r.Opportunity_Sub_Status__c In: lstOppStages]){
                 
          if(sc.Section__r.Opportunity_Sub_Status__c != null){
              if(!mapSubStatusSectionItem.isEmpty() && mapSubStatusSectionItem.containsKey(sc.Section__r.Opportunity_Sub_Status__c) && mapSubStatusSectionItem.get(sc.Section__r.Opportunity_Sub_Status__c)!= null){
                  mapSubStatusSectionItem.get(sc.Section__r.Opportunity_Sub_Status__c).add(sc);
              }else{
                   mapSubStatusSectionItem.put(sc.Section__r.Opportunity_Sub_Status__c,new List<sc_section_item__c>{sc});                       
              }
          }else{
              if(!mapSubStatusSectionItem.isEmpty() && mapSubStatusSectionItem.containsKey(sc.Section__r.Parent_Section__r.Opportunity_Sub_Status__c) && mapSubStatusSectionItem.get(sc.Section__r.Parent_Section__r.Opportunity_Sub_Status__c)!= null){
                  mapSubStatusSectionItem.get(sc.Section__r.Parent_Section__r.Opportunity_Sub_Status__c).add(sc);
              }else{
                   mapSubStatusSectionItem.put(sc.Section__r.Parent_Section__r.Opportunity_Sub_Status__c,new List<sc_section_item__c>{sc});                       
              }
          }                                              
    }
    System.debug('stages in map---->'+mapSubStatusSectionItem.size());
    System.debug('stages in map---->'+mapSubStatusSectionItem.keySet());
    
    Map<Id,List<String>> mapOppIdStage = new Map<Id,List<String>>();
    SC_OpportunityCustDate__c startDate =  SC_OpportunityCustDate__c.getInstance('StartDate');
    for(Opportunity opp : trigger.new){
     // String link = '<a href="https://hlqa-homelane-qadev.cs6.force.com/Homelaneqadev/apex/SC_MISalesProcess?scontrolCaching=1&id="+ opp.id '"+'</a>';

        System.debug('Created Date------------>'+opp.CreatedDate);
        //Hard coded Opportunity Stage(Closed Lost),Opportunity Record Type(Printer) bcz this functionality is only for printer opportunity.
        //opp.RecordTypeId == Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Printer').getRecordTypeId()   && 
        if( startDate.SC_StartDate__c < (opp.CreatedDate).DATE()  && SC_isTriggerExecute__c.getInstance('Sales Coach Trigger on Opportunity').isTriggerExecute__c && opp.sub_status__c!=null){
         //system.debug('opportunity recordType Id='+opp.recordTypeId);
         //System.debug('Old opp stage--------->'+mapOldOpportunity.get(opp.Id).sub_status__c);
         System.debug('New opp stage--------->'+opp.sub_status__c);
            
            if(mapOldOpportunity.get(opp.Id).sub_status__c != opp.sub_status__c){ 
                Boolean validateNextStages = false;  
                Boolean newStageValueExists = false;
                //Loop to iterate all Opportunity Stages.
                for(String stage : lstOppStages ){
                   
                    if(opp.Sub_Status__c== stage){
                        newStageValueExists = true;
                        System.debug('opp new stage exists------>'+stage);
                    }                 
                    if(newStageValueExists && validateNextStages){
                            break;
                    }               
                     System.debug('Boolean Values '+newStageValueExists+validateNextStages+stage);                     
                    if( mapOldOpportunity.get(opp.Id).Sub_Status__c == stage){
                        System.debug('Boolean Values again '+newStageValueExists+validateNextStages);
                        validateNextStages = true;  
                        if(newStageValueExists && validateNextStages){
                        
                            if(!mapOppIdStage.isEmpty() && mapOppIdStage.containsKey(opp.Id) && mapOppIdStage.get(opp.Id)!= null){
                                mapOppIdStage.get(opp.id).add(Stage);
                            } 
                            else{
                                mapOppIdStage.put(opp.id, new List<String>{Stage});
                            }                        
                            break;
                        }          
                        //If user does not give Required User Response for Previously stored Stage then below error will be displayed.
                        if(mapSubStatusSectionItem.containsKey(stage)){                        
                            if(!newStageValueExists && !SC_OpportunityStageValidation.SC_OpportunityStageValidate(opp.id,mapOldOpportunity.get(opp.Id).Sub_Status__c,mapSubStatusSectionItem.get(stage))){
                                //If we change the error message here we need to chang some code in SC_MISalesProcess. because we are comparing string over there.
                              //  opp.addError('Please, fill out the CheckList in this record https://hlqa-homelane-qadev.cs6.force.com/Homelaneqadev/apex/SC_MISalesProcess?scontrolCaching=1&id='+opp.id);     
                            
                            // opp.addError('Please, fill out the CheckList and Change the Sub-Status to: '+opp.sub_status__c );
                        
                         /*   opp.addError(
            
            '<a href="www.google.com" target="_blank">Help & Training</a>',
            false
        );*/
                    /*          System.debug('breaking in old stage == stage');
                              // return;                     
                               break;
                            }
                        }   
                    }
                    if(opp.Sub_Status__c != stage && newStageValueExists &&  !validateNextStages){
                        if(!mapOppIdStage.isEmpty() && mapOppIdStage.containsKey(opp.Id) && mapOppIdStage.get(opp.Id)!= null){
                            mapOppIdStage.get(opp.id).add(Stage);
                        } 
                        else{
                            mapOppIdStage.put(opp.id, new List<String>{Stage});
                        }
                        System.debug('List of stage to be deleted------>'+Stage);
                        Continue;
                    }  
                    
                    
                    //if User skips stages and if skipped stages doesnot have required User Response then below error will be displayed.
                    if(mapSubStatusSectionItem.containsKey(stage)){
                        if(opp.Sub_Status__c != Stage && !SC_OpportunityStageValidation.SC_OpportunityStageValidate(opp.id,stage,mapSubStatusSectionItem.get(stage))){
                          // opp.addError(' Please, fill out the CheckList in this record '+'https://hlqa-homelane-qadev.cs6.force.com/Homelaneqadev/apex/SC_MISalesProcess?scontrolCaching=1&id='+opp.id);      
                         //   opp.addError(' Please, fill out the CheckList in this record '+link);
                        //opp.addError(' Please, fill out the CheckList and Change the Sub-Status to: '+opp.sub_status__c );
                           System.debug('Breaking in other stages');                    
                            break;
                        }
                    }
                   
                
                }
            }
        }        
    }
    if(!mapOppIdStage.isEmpty()){
        System.debug('Map od stages to be deleted----------->'+mapOppIdStage);
        List<SC_User_Response__c> lstUsrResponse = [SELECT Id,Item__c,Name,Opportunity__c,Stage__c,SystemModstamp,User_Response__c FROM SC_User_Response__c WHERE Opportunity__c In : mapOppIdStage.keySet()  ];
        System.debug('ggggggggggg------->'+lstUsrResponse);
        
        List<SC_User_Response__c> lsiUsrRsp = new List<SC_User_Response__c >();
        for(SC_User_Response__c ur : lstUsrResponse ){
            if(!mapOppIdStage.isEmpty() && mapOppIdStage.containsKey(ur.Opportunity__c) && mapOppIdStage.get(ur.Opportunity__c)!= null){
                for(String s :mapOppIdStage.get(ur.Opportunity__c)){
                    if(ur.Stage__c == s){
                        lsiUsrRsp.add(ur);
                        break;
                    }
                }
            }
        }
        if(trigger.isAfter && trigger.isUpdate){
            Integer i=0;
            try{
                if(!lsiUsrRsp.isEmpty()){
                    System.debug('Records to be de;lete--------'+lsiUsrRsp);
                    Delete lsiUsrRsp;
                }
            }Catch(Exception e){
                System.debug('Opportunity Trigger Exception ### ---->'+e);
            }
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
        }
    }
    */
}