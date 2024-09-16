/*
    * Class Name : SC_MISalesProcess
    * Author: Sanjeev Shukla - KVP
    * Date:   13/Feb/2016
    * Description: * Contains Methods to get all Sections, items user responses.
                   * Method to Save Opportunity data and Slescoch data.
                   * Method to get Opportunity Stage pickList vlues from Schema.
                   * Method to get Opportunity Reason Won pickList vlues from Schem.
                   * Method to check whether stage is ready to move to next stage or not.
                   * And wrapper classes to display Sections,Items, and respones for current stage as well s previous stage.
*/
global class SC_MISalesProcess {
    public static List<Sections> listWrapSec;
    public static List<Responses> listWrapRes;
    
     // If we want to generate any exception then we can use this exception claSS
        global class applicationException extends Exception {}
    

    
    //To save both Opportunity data and Sales Coach data on click of "save" button.
    @AuraEnabled        
    public static List<ErrorMsgWrapper> saveData(String data, Id oppId, String stageName){
        system.debug('*********opp salescoach data*******'+data);
        List<ErrorMsgWrapper> lstErrMsgWrapper = new List<ErrorMsgWrapper>();
        //String errormsg='';
        Savepoint sp = Database.setSavepoint();
        try{
        // Converting Sales Coach data from JSon type to "Sections" Wrapper class type.
        system.debug('*********after user resp Data*******'+data);
       // system.debug('*********after Opportunity Data*******'+objforUpdate);
        JSONParser parser = JSON.createParser(data);
        List<Sections> listSec = new List<Sections>();
        while (parser.nextToken() != NULL) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != NULL) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        Sections sec = (Sections)parser.readValueAs(Sections.class);
                        listSec.add(sec);
                        parser.skipChildren();
                    }
                } 
            }
        }
        system.debug('list of section -----> '+listSec);
        List<SC_User_Response__c> listUsrRes = new List<SC_User_Response__c>();
        Set<Id> setUserRes = new Set<Id>();
        Boolean updtSalesBfrOpp = false;
        
        // To add the UserResponse in "listUsrRes" list.
        for(Sections sec : listSec){
            if(!sec.section.isEmpty()){
                for(Sections subSec : sec.section){
                    if(!subSec.item.isEmpty()){
                        for(Items itm : subSec.item){
                            if((itm.value.trim() != '' && 
                                itm.value.trim() != 'NONE') ||
                               (itm.responseType == 'Check Box' && 
                                (itm.checkValue) ) ){
                                SC_User_Response__c usrRes = new SC_User_Response__c();
                                if(itm.userResId != NULL && itm.userResId != ''){
                                    usrRes.id = itm.userResId;
                                }
                                usrRes.Opportunity__c  = oppId;
                                usrRes.Stage__c       = stageName;
                                if(itm.responseType == 'Check Box'){
                                    usrRes.User_Response__c = String.valueOf(itm.checkValue);
                                }else{
                                    usrRes.User_Response__c = itm.value;
                                }
                                usrRes.Item__c = itm.itemId;
                                if(itm.responseType == 'PickList' && itm.value.trim() != 'NONE'){
                                    for(Responses res : itm.response){
                                        if(itm.value == res.responseName){
                                            usrRes.Response_Score__c = res.score;
                                            break;
                                        }
                                    }
                                }else{
                                    system.debug('************response score *****************'+itm.response);
                                    usrRes.Response_Score__c = itm.response[0].score;
                                }
                                listUsrRes.add(usrRes); 
                            }else if(itm.userResId != NULL){
                                setUserRes.add(itm.userResId);
                            }
                        }
                    }
                }
            }else if(!sec.item.isEmpty()){
                for(Items itm : sec.item){
                    if((itm.value.trim() != '' && itm.value.trim() != 'NONE') || 
                        (itm.responseType == 'Check Box' && (itm.checkValue) ) ){
                        SC_User_Response__c usrRes = new SC_User_Response__c();
                        if(itm.userResId != NULL && itm.userResId != '' ){
                            usrRes.id = itm.userResId;
                        }
                        usrRes.Opportunity__c  = oppId;
                        usrRes.Stage__c    = stageName;
                        if(itm.responseType == 'Check Box'){
                            usrRes.User_Response__c = String.valueOf(itm.checkValue);
                        }else{
                            usrRes.User_Response__c = itm.value;
                        }
                        usrRes.Item__c = itm.itemId;
                        if(itm.responseType == 'PickList' && itm.value.trim() != 'NONE'){
                            for(Responses res : itm.response){
                                if(itm.value == res.responseName){
                                    usrRes.Response_Score__c = res.score;
                                    break;
                                }
                            }
                        }else{
                            system.debug('************response score *****************'+itm.response[0].score);
                            usrRes.Response_Score__c = itm.response[0].score;
                        }
                        listUsrRes.add(usrRes);
                    }else if(itm.userResId != NULL){
                        setUserRes.add(itm.userResId);
                    }                    
                }
            }
            System.debug('list of user response ----> '+listUsrRes.size());            
            }
            //Inserting or Updating UserResponse
            
           
            if(!listUsrRes.isEmpty()){
                System.debug('list of user response before ----> '+listUsrRes);
                upsert listUsrRes;
                System.debug('list of user response after----> '+listUsrRes);
            }            
           
   
            if(!setUserRes.isEmpty()){
                List<SC_User_Response__c> listURes = new List<SC_User_Response__c>();
               
                for(Id usrResId : setUserRes){
                    SC_User_Response__c usrRes = new SC_User_Response__c();                    
                    usrRes.id = usrResId;
                    listURes.add(usrRes);
                }
                System.debug('before deleted list---->'+listURes);
                if(!listURes.isEmpty()){
                     delete listURes;
                }             
                System.debug('after deleted list---->'+listURes);
            }
            lstErrMsgWrapper.add(new ErrorMsgWrapper('SUCCESS',''));        
            return lstErrMsgWrapper;
        }catch(Exception e) {
            System.debug('other exception ------------------>'+e);
            
                lstErrMsgWrapper.add(new ErrorMsgWrapper(e.getMessage(),''));
            return lstErrMsgWrapper;
        }
       
    }
    @AuraEnabled
    public Static String dltCommitmentUsrRsp(Id oppId){
        List<SC_User_Response__c> lstUsrRsp = new List<SC_User_Response__c>();
      /*  if(oppId != null){
            lstUsrRsp = [SELECT Name FROM SC_User_Response__c WHERE Opportunity__c  =: oppId AND Stage__c = 'Commitment'];
        }*/
        if(lstUsrRsp.size() > 0 ){
            try{
                DELETE lstUsrRsp;
            }Catch(Exception e){
                System.debug('Delete Exception---->'+e);
            }
        }
        return 'Success';
    }
    /* 
    * Author: Sanjeev Shukla - KVP
    * Date:   13/Feb/2016
    * Description: We get all Sales Coach data by this method based on opportunity details.
    * 
    */
    @AuraEnabled        
    public static List<Sections> getResponse(Id oppId, String stageName, String RecordTypeName,Decimal NoOfKitchen,decimal NoOfBedrooms,decimal NoOfFoyers,Decimal NoOfLivingRooms,Decimal NoOfDiningRooms,Decimal NoOfBathrooms,Decimal NoOfPujaUnits,Decimal NoOfUtilities){  
        System.debug('record type id  --> '+RecordTypeName);
        System.debug('Stage Name-----  --> '+stageName);
        System.debug('oppId-----  --> '+oppId);
        System.debug('----------NoOfKitchen-------> '+NoOfKitchen);
        //System.debug('----------NoOfBedrooms---Decimal NoOfBedrooms------> '+NoOfBedrooms);
        if(stageName!=null && stageName!=''){
            // get all parent section id for outer joining in soql
            List<SC_Section_Item__c> listSectn = [SELECT Section__c 
                                                  FROM SC_Section_Item__c 
                                                  WHERE Section__r.Opportunity_Sub_Status__c =: stageName 
                                                  OR Section__r.Parent_Section__r.Opportunity_Sub_Status__c =: stageName];
            Set<Id> setSectn = new Set<Id>();
            
            System.debug('listSectn---------------> now'+listSectn);
            
            for(SC_Section_Item__c secItm : listSectn){
                setSectn.add(secItm.Section__c);
            }
            
            // Querying all information of Section and Item of Respected Opportunity Stage.
            List<SC_Section_Item__c> listSecItm = new  List<SC_Section_Item__c>();
            if(!setSectn.isEmpty()){
                listSecItm = [SELECT Item__c, Item__r.Response_Type__c, Item__r.Item__c, Order__c, Section__c, Section__r.Section__c, Section__r.Parent_Section__r.Section__c, Section__r.Parent_Section__c,Section__r.Additional_Number_Of_Kitchens__c,Section__r.Parent_Section__r.Additional_Number_Of_Kitchens__c,Section__r.Additional_Number_Of_Bedrooms__c,Section__r.Parent_Section__r.Additional_Number_Of_Bedrooms__c 
                                                   FROM SC_Section_Item__c WHERE Section__c IN : setSectn 
                                                   AND Item__r.Is_Active__c =: TRUE 
                                                   AND (Section__r.Opportunity_Sub_Status__c =: stageName 
                                                        OR Section__r.Parent_Section__r.Opportunity_Sub_Status__c=: stageName)
                                                   AND Section__r.Additional_Number_Of_Kitchens__c<=:NoOfKitchen
                                                   AND Section__r.Additional_Number_Of_Bedrooms__c<=:NoOfBedrooms
                                                   AND Section__r.Additional_Number_Of_Foyers__c <=:NoOfFoyers
                                                   AND Section__r.Additional_Number_Of_Living_Rooms__c <=:NoOfLivingRooms
                                                   AND Section__r.Additional_Number_Of_Bathrooms__c <=:NoOfBathrooms
                                                   AND Item__r.Record_Type__c INCLUDES (:RecordTypeName) 
                                                   ORDER BY Section__r.Order__c, Order__c];
                }
            System.debug('*********listSecItm************ '+listSecItm);
            Set<Id> setItmId = new Set<Id>();
            for(SC_Section_Item__c secItm : listSecItm){
                setItmId.add(secItm.Item__c); 
            }
            //Getting all information of section based on Opportunity Stage.
            Map<id,SC_Section__c> mapAllSec = new Map<Id,SC_Section__c>([SELECT Section__c,Parent_Section__c,Order__c, Parent_Section__r.Section__c, Parent_Section__r.Opportunity_Sub_Status__c ,Parent_Section__r.Order__c
                                                                         FROM SC_Section__c 
                                                                         WHERE ID IN : setSectn 
                                                                         AND (Opportunity_Sub_Status__c =: stageName OR Parent_Section__r.Opportunity_Sub_Status__c =: stageName) ORDER BY Order__c]);
            System.debug('list of all sections --> '+mapAllSec.values());
            //Getting Item Information based on "setItmId".
            Map<id,SC_Item__c> mapItem = new Map<id,SC_Item__c>([SELECT id,
                                                                 (SELECT id, Answer__c, Score__c,Required_for_Next_Stage__c 
                                                                  FROM SC_Responses__r 
                                                                  WHERE Is_Active__c =: TRUE ORDER BY Order__c) 
                                                                 FROM SC_Item__c 
                                                                 WHERE Id IN : setItmId 
                                                                 AND Is_Active__c =: TRUE 
                                                                 AND Record_Type__c INCLUDES (:RecordTypeName)]);
            System.debug('*********mapItem************  --> '+mapItem);
            //Getting UserResponses based on Opportunity Id and Opportunity Stage. 
            List<SC_User_Response__c> listUserRes = new List<SC_User_Response__c>();
            listUserRes = [select id, User_Response__c,Item__c,Response_Score__c 
                           FROM SC_User_Response__c 
                           WHERE Opportunity__c  =: oppId 
                           AND Stage__c =: stageName];
            system.debug('list of user res ----> '+listUserRes  );
            
            Map<id, SC_User_Response__c> mapUserRes = new Map<id, SC_User_Response__c>();
            for(SC_User_Response__c usRes : listUserRes ){
                mapUserRes.put(usRes.Item__c, usRes);
            }
            Map<Id,List<Items>> mapSec = new Map<Id,List<Items>>();
            Boolean requiredQues = false;
            for(SC_Section_Item__c secItm : listSecItm){
                if(!mapSec.containsKey(secItm.Section__c)){
                    mapSec.put(secItm.Section__c, new List<Items>());                      
                }
                //Adding Responses to listWrapRes.
                listWrapRes = new List<Responses>();
                if(!mapItem.get(secItm.Item__c).SC_Responses__r.isEmpty()){
                    for(SC_Response__c res :  mapItem.get(secItm.Item__c).SC_Responses__r){
                        if(requiredQues == false && res.Required_for_Next_Stage__c){
                            requiredQues = true;
                        }
                        if(res.Score__c != NULL && res.Score__c >= 0){
                            listWrapRes.add(new Responses(res.Answer__c, Integer.valueOf(res.Score__c)));
                        }else{
                            listWrapRes.add(new Responses(res.Answer__c, 0));
                        }
                    }
                }else{
                    listWrapRes.add(new Responses('', 0));
                }
                System.debug('list of response ---> '+listWrapRes);
                //To add Items with Responses to mapSec. 
                Items it = new Items(listWrapRes,secItm.Item__r.Item__c, secItm.Item__c,secItm.Item__r.Response_Type__c,requiredQues);
                requiredQues = false;
                if(!mapUserRes.isEmpty() && 
                   mapUserRes.containsKey(secItm.Item__c)){
                    if(secItm.Item__r.Response_Type__c == 'Check Box'){
                        it.checkValue = Boolean.valueOf(mapUserRes.get(secItm.Item__c).User_Response__c);
                    }else{
                        it.value = mapUserRes.get(secItm.Item__c).User_Response__c;
                    }
                    it.userResId = mapUserRes.get(secItm.Item__c).id;
                }
                mapSec.get(secItm.Section__c).add(it);
            }
            System.debug('List of All Data-----> '+mapSec);
            Map<Id,Sections> mapWrapSec = new Map<Id,Sections>();
            //To add Section With Items and Responses in mapWrapSec map.
            for(Id sectionId : mapSec.keyset()){
                Sections sectn = new Sections(mapAllSec.get(sectionId).Section__c,Integer.valueOf(mapAllSec.get(sectionId).Order__c));
                //sectn.sectionName = sectn.sectionName +' - '+mapAllSec.get(sectionId).Opportunity_Stage__c.toUpperCase();
                sectn.item.addAll(mapSec.get(sectionId));
                if(mapAllSec.get(sectionId).Parent_Section__c == NULL){
                    mapWrapSec.put(sectionId, sectn);
                }else{
                    if(!mapWrapSec.containsKey(mapAllSec.get(sectionId).Parent_Section__c)){
                        Sections sec = new Sections(mapAllSec.get(sectionId).Parent_Section__r.Section__c,Integer.valueOf(mapAllSec.get(sectionId).Order__c));
                        //sec.sectionName = sec.sectionName +' - '+mapAllSec.get(sectionId).Opportunity_Stage__c.toUpperCase();
                        mapWrapSec.put(mapAllSec.get(sectionId).Parent_Section__c, sec);
                    }
                    mapWrapSec.get(mapAllSec.get(sectionId).Parent_Section__c).section.add(sectn);
                }         
            }
            
            System.debug('list of all map data --> '+mapWrapSec.values());
            return mapWrapSec.values();
     }
     else{
         return null;
     }
    }
    //To get all Opportunity Stages from Schema.
    @AuraEnabled
    public Static List<String> getOpportunityStages(){
        List<String> listStage = new List<String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Sub_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pl : ple){
            listStage.add(pl.getLabel());
        }
        System.debug('list of stages ----> '+listStage);
        return listStage;
    }
    //To get defaultProbability of particular stage.
   /* @AuraEnabled
    public static Integer getDefaultProbability( String StageName){
        OpportunityStage oppStage = [SELECT ApiName,DefaultProbability FROM OpportunityStage WHERE ApiName =: StageName];
        return Integer.valueOf(oppStage.DefaultProbability);
    }*/
    
    //To get all previous Stage Sales Coach information.
    @AuraEnabled        
    public static List<PreviousStageSections> getAllPreviousStage(String stageName){
        if(stageName!=null && stageName!=''){
            Map<String,Integer> mapStage = new Map<String,Integer>(); 
            Schema.DescribeFieldResult fieldResult = Opportunity.Sub_Status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            Integer i = 0;
            for(Schema.PicklistEntry pl : ple){
                if(stageName == pl.getLabel()){
                    break; 
                }
                mapStage.put(pl.getLabel(),i);
                i++;
            }
            List<SC_Section__c> listSec = new List<SC_Section__c>();
            listSec = [SELECT id, Section__c,Opportunity_Sub_Status__c 
                       FROM SC_Section__c 
                       WHERE  Opportunity_Sub_Status__c IN: mapStage.keySet()  ORDER BY Order__c];
            List<PreviousStageSections> listPreStage = new List<PreviousStageSections>();
            Integer c = 0;
            for(SC_Section__c sec : listSec){
                PreviousStageSections preStage = new PreviousStageSections(sec.Section__c, sec.Opportunity_Sub_Status__c, mapStage.get(sec.Opportunity_Sub_Status__c),c);
                listPreStage.add(preStage);
                c++;
            }
            listPreStage.sort();
            return listPreStage;
        }
        else{
            return null;
        }
    }
    //To check whether Opportunity is ready to move from current stage to next stage.
    @AuraEnabled
    public Static Boolean isReadyToNextStage(Id oppId, String stageName){
        List<String> lstOppStages = SC_MISalesProcess.getOpportunityStages();
    
    
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
     System.debug('**********isReady**********');
        try{
            Boolean isReady = SC_OpportunityStageValidation.SC_OpportunityStageValidate(oppId,stageName,mapSubStatusSectionItem.get(stageName));
            System.debug('**********isReady**********'+isReady);
            return  isReady;
        }catch(Exception ex){
            System.debug('**********isReady exception **********'+ex);
            return false;
        }
    }    
    
    
 @AuraEnabled
    public static String validateStage(Id oppId,String newStageName){  
    
    List<String> lstOppStages = SC_MISalesProcess.getOpportunityStages();
    
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
  
        Opportunity opp = new Opportunity();
        String returnString='true'; 
        if(oppId != null){
           opp = [SELECT Id,createdDate,StageName,sub_status__c,RecordType.Name,Name FROM Opportunity WHERE ID =:oppId];
        }
        System.debug('new stage ---->'+newStageName);
        System.debug('old stage='+opp.StageName);
        if(opp != null){   
        //SC_OpportunityCustDate__c startDate =  SC_OpportunityCustDate__c.getInstance('StartDate');        
      //  List<String> lstOppStages = SC_MISalesProcess.getOpportunityStages();
            if(newStageName != 'Closed Lost'){
                returnString = 'true';
            }
        if(//opp.recordType.Name== 'Printer' 
       // && startDate.SC_StartDate__c < (opp.createdDate).DATE() 
       // && 
        newStageName != 'Closed Lost'){
               
            if(opp.sub_status__c != newStageName){ 
                Boolean validateNextStages = false;                
                //Loop to iterate all Opportunity Stages.
                for(String stage : lstOppStages ){                
                    //loop will execute until stage to be updated is equals to stage of Loop currently running. 
                    if(newStageName == stage ){
                        returnString = 'true';
                        break;
                    }                            
                    if( opp.Sub_Status__c == stage){
                        validateNextStages = true;           
                         System.debug('inside add skiiped stager error ------>'+validateNextStages);             
                        //If user does not give Required User Response for Previously stored Stage then below error will be displayed.
                        if( !SC_OpportunityStageValidation.SC_OpportunityStageValidate(opp.Id,opp.Sub_Status__c,mapSubStatusSectionItem.get(opp.Sub_Status__c))){
                            //If we change the error message here we need to chang some code in SC_MISalesProcess. because we are comparing string over there.
                            returnString = 'Please, fill out the CheckList and Change the Status to : '+newStageName+' sub status';
                            newStageName = opp.Sub_Status__c;
                            Break;
                        }
                    }
                    //if User skips stages and if skipped stages doesnot have required User Response then below error will be displayed.
                    if(newStageName != stage  && !SC_OpportunityStageValidation.SC_OpportunityStageValidate(oppId,stage,mapSubStatusSectionItem.get(stage ))){
                        System.debug('inside add skiiped stager error ------>');
                        returnString = 'Please, fill out the CheckList and Change the Status to : '+newStageName+' sub status';
                        newStageName = opp.Sub_Status__c;                          
                        Break;
                    }                
                }
            }else if(opp.Sub_Status__c == newStageName){
                    returnString = 'true';
                }
            
        }  
            }
        return returnString;
    }
    

    /*
* This wrapper class contain Item information. 
*/
    public class Items{
        
        @AuraEnabled
        public Boolean required{get;set;} //to diplay required sign in UI
        @AuraEnabled
        public String itemId {get;set;}
        @AuraEnabled
        public String userResId {get;set;}
        @AuraEnabled
        public List<Responses> response {get;set;}
        @AuraEnabled
        public String itemName {get;set;}
        @AuraEnabled
        public String responseType {get;set;}
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public Boolean checkValue {get;set;}
        
        
        public Items(List<Responses> response,String itemName, String itemId, string responseType,Boolean required){
            this.itemName = itemName;
            this.itemId = itemId;
            this.response = response;
            this.responseType = responseType;
            if(responseType == 'PickList'){
                this.value = '--Select--';
            }else{
                this.value = '';
            }
            this.checkValue = false;
            this.required = required;
            
        }
    }
    /*
* This wrapper class contain Response information. 
*/   
    public class Responses{
        @AuraEnabled
        public String responseName {get;set;}
        @AuraEnabled
        public Integer score {get;set;}
        public Responses(String responseName, Integer score){
            this.responseName = responseName;
            this.score = score;
        }
    }
    

    
    /*
     * Wrapper for error messages with API name
    */
    global class ErrorMsgWrapper{
        @AuraEnabled
        public String errorMsg{get;set;}
        @AuraEnabled
        public String fieldApi {get;set;}
        public ErrorMsgWrapper( String errorMsg,String fieldApi){
            this.errorMsg    = errorMsg;
            this.fieldApi   = fieldApi;
        }
    }
}