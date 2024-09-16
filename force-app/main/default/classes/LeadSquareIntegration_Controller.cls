/**
 * @File Name          : LeadSquareIntegration_Controller.cls
 * @Description        : 
 * @Author             : Bharatesh Shetty
 * @Group              : 
 * @Last Modified By   : Bharatesh Shetty
 * @Last Modified On   : 9/19/2019, 2:02:18 PM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/12/2019, 4:29:37 PM   Bharatesh Shetty     Initial Version
**/
public class LeadSquareIntegration_Controller {
    /**
    * @description
    * @author Bharatesh Shetty | 8/12/2019
    * @param Map<Id, SObject> newMap
    * @param Map<Id, SObject> oldMap
    * @param String fieldSetName
    * @param String objectName
    * @return Set<Id>
    */
    Public static Set<Id> checkIfLeadSquareFieldsModified(Map<Id,SObject> newMap,Map<Id,SObject> oldMap,String fieldSetName,String objectName){
        Set<Id> setOfRecordIdsToUpdate = new Set<Id>();
        try{
            System.debug('checkIfLeadSquareFieldsModified Trigger Called');
            if(newMap !=null && !newMap.isEmpty() && oldMap !=null && !oldMap.isEmpty()){
                /*System.debug('New Full Name Value : '+((Lead)newMap.values()[0]).Full_Name__c);
                System.debug('old Full Name Value : '+((Lead)oldMap.values()[0]).Full_Name__c);*/
                Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
                Schema.SObjectType sObjectTypeObj = GlobalDescribeMap.get(ObjectName);
                Map<String, Schema.SobjectField> fieldsMap = SObjectTypeObj.getDescribe().fields.getMap();
                Schema.DescribeSObjectResult describeSObjectResultObj = SObjectTypeObj.getDescribe();

                //system.debug('====>' + DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName));
                
                Map<String, Lead_Square_Opp_Stage_Exclude__c> oppStageExcludeMap = Lead_Square_Opp_Stage_Exclude__c.getAll();

                Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);

                List<Schema.FieldSetMember> fieldSetMemberList =  fieldSetObj.getFields();
                //system.debug('fieldSetMemberList ====>' + fieldSetMemberList); 
                for(SObject eachItem : newMap.values()){
                    if(objectName == 'Lead'){
                        System.debug('objectName: '+objectName);
                        System.debug('Assigned_to_Resi_ASM__c: '+((Lead)eachItem).Assigned_to_Resi_ASM__c); 
                        if((((Lead)eachItem).Assigned_to_Resi_ASM__c == false)||(eachItem.get('Status')=='Appointment Successful' && oldMap.get(eachItem.id).get('Status')=='Appointment Successful')
                            || (eachItem.get('Status')=='Dead Lead' && oldMap.get(eachItem.id).get('Status')=='Dead Lead')
                            || (eachItem.get('Status')=='Not actively pursued' && oldMap.get(eachItem.id).get('Status')=='Not actively pursued')
                            ||(eachItem.get('Lead_square_modified_date__c')!=null) || eachItem.get('Test_Flag__c') == True ){
                            continue;
                        }
                    }
                    else if(objectName == 'Opportunity'){
                        System.debug('objectName: '+objectName);
                        //System.debug('oppStageExcludeMap: '+oppStageExcludeMap);
                        //System.debug('StageName:' +eachItem.get('StageName'));
                        if(eachItem.get('Lead_square_modified_date__c')!=null ||(eachItem.get('StageName')=='10% Payment Received' && oldMap.get(eachItem.id).get('StageName')=='10% Payment Received')
                          	|| oppStageExcludeMap.containsKey(((Opportunity)eachItem).StageName)|| eachItem.get('StageName')=='Install Team Assigned,Material Dispatche'
                            || eachItem.get('Test_Flag__c') == True ){
                            continue;
                        }
                        /*else if(oppStageExcludeMap.containsKey(((Opportunity)eachItem).StageName)){
                            //((Lead)eachItem).Assigned_to_Resi_ASM__c
                            continue;
                        }*/
                    }
                    for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList){
                        System.debug('fieldSetMemberObj.getFieldPath(): '+fieldSetMemberObj.getFieldPath());
                        if(!fieldsMap.isEmpty() && fieldsMap.containsKey(fieldSetMemberObj.getFieldPath())){
                            Schema.SobjectField fieldvalue = fieldsMap.get(fieldSetMemberObj.getFieldPath());
                            //System.debug('fieldvalue: '+ld.get(fieldvalue));
                            System.debug('New Value : '+eachItem.get(fieldvalue));
                            System.debug('old Value : '+oldMap.get(eachItem.id).get(fieldvalue));
                            if(eachItem.get(fieldvalue) != oldMap.get(eachItem.id).get(fieldvalue)){
                                System.debug('Value Changed');
                                setOfRecordIdsToUpdate.add(eachItem.Id);
                                break;
                            }
                        }
                    }
                }
            }
        }
        Catch(Exception e){
           System.debug('Exception: '+e.getStackTraceString());
           Logger.log('Exception','LeadSquareIntegration_Controller','checkIfLeadSquareFieldsModified method',e.getMessage(),e.getStackTraceString(),null);
        }
        return setOfRecordIdsToUpdate;
    }
    /**
    * @description
    * @author Bharatesh Shetty | 8/14/2019
    * @param Map<Id, Lead> mapOfLeads
    * @return List<LeadSquaredWrapper>
    */
    /*public static List<LeadSquaredRequestWrapper> createLeadSquaredRequestWrapperLeadList(Map<Id,Lead> mapOfLeads){
        List<LeadSquaredRequestWrapper> listOfLeadSquaredWrapper = new List<LeadSquaredRequestWrapper>();
        try{
            if(!mapOfLeads.isEmpty()){
                for(Lead eachLead : mapOfLeads.values()){
                    LeadSquaredRequestWrapper ldsqWrap = new LeadSquaredRequestWrapper();
                    ldsqWrap.status = eachLead.Status;
                    listOfLeadSquaredWrapper.add(ldsqWrap);
                }
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
        }
        return listOfLeadSquaredWrapper;
    }*/
    public static List<LeadSquaredResponseWrapper> calloutToLeadSquared(String body,String integrationSettingName){
        List<LeadSquaredResponseWrapper> listOfResponseWrapper = new List<LeadSquaredResponseWrapper>();
        try{
            if(!String.isBlank(body) && !String.isBlank(integrationSettingName)){
                Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                Integration_Setting__c integrationDetail = allEndPoint.get(integrationSettingName);
                    
                //String endPointUrl='https://api-in21.leadsquared.com/v2/LeadManagement.svc/Lead/Bulk/CreateOrUpdate?accessKey=u$r132fe08ce31d4b4fd59511a1f15bf7ff&secretKey=2e388d2e3c98bc9f736942fe48aff155fff76490';
                String endPointUrl = integrationDetail.End_Point__c;
                endPointUrl +='accessKey='+integrationDetail.Authorization__c+'&secretKey='+integrationDetail.Secret_Key__c;
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                Httpresponse response = new Httpresponse();

                request.setMethod('POST');
                request.setBody(body);
                request.setHeader('Content-Type', integrationDetail.ContentType__c);
                //request.setHeader('Content-Type', 'application/json');
                request.setEndPoint(endPointUrl);
                request.setTimeout(120000);
                System.debug('request: '+request);

                response = http.send(request);

                System.debug('response: '+response);
                if(response.getStatusCode()==200){
                    String resJson = response.getBody();
                    listOfResponseWrapper = (List<LeadSquaredResponseWrapper>)JSON.deserialize(resJson,List<LeadSquaredResponseWrapper>.class);
                }
                else{
                    System.debug('response.getStatusCode(): '+response.getStatusCode());
                    Logger.log('Error','LeadSquareIntegration_Controller','calloutToLeadSquared','Status Error',String.ValueOf(response.getStatusCode()),null);
                } 
            }
            else{
                System.debug('blank body or integration setting Name');
                System.debug('body: '+body);
                System.debug('integrationSettingName: '+integrationSettingName);
                Logger.log('Error','LeadSquareIntegration_Controller','calloutToLeadSquared','body or Integration Setting error',integrationSettingName,null);
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            Logger.log('Exception','LeadSquareIntegration_Controller','calloutToLeadSquared',e.getMessage(),e.getStackTraceString(),null);
        }
        return listOfResponseWrapper;
    }

    /**
    * @description
    * @author Bharatesh Shetty | 8/14/2019
    * @param Map<Id, Lead> mapOfLeads
    * @return List<LeadSquaredResponseWrapper>
    */
    /*public static List<LeadSquaredResponseWrapper> createLeadSquaredWrapperLeadList(Map<Id,Lead> mapOfLeads){
        List<LeadSquaredResponseWrapper> listOfLeadSquaredResponseWrapper = new List<LeadSquaredResponseWrapper>();
        try{
            if(!mapOfLeads.isEmpty()){
                for(Lead eachLead : mapOfLeads.values()){
                    LeadSquaredResponseWrapper ldsqWrap = new LeadSquaredResponseWrapper();
                    ldsqWrap.status = eachLead.Status;
                    listOfLeadSquaredResponseWrapper.add(ldsqWrap);
                }
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
        }
        return listOfLeadSquaredResponseWrapper;
    }
    */
    /*public class LeadSquaredRequestWrapper{
        Public String Status;
    }*/
    
    public static ResponseWrapper getLeadSquaredRequestWrapper(List<Sobject> lstSobject,String sObjectName){
        system.debug('SobjectName'+SobjectName);
        Map<Integer,Sobject> mapRecordPosition = new Map<Integer,Sobject>();

        list<InnerWrapper> lstInnerWrapper;
        list<List<InnerWrapper>> lstlstWrapper = new List<List<InnerWrapper>>();
        Integer i = 1;

        Map<String,Lead_Square_Mapping__c> lstMap = Lead_Square_Mapping__c.getAll();
            for(Sobject obj:lstSobject){
                
                lstInnerWrapper = new list<InnerWrapper>();
                for(Lead_Square_Mapping__c maping:lstMap.Values()){
                    InnerWrapper objinner;
                    objinner = new InnerWrapper(maping,Obj,SobjectName);
                    lstInnerWrapper.add(objinner);
                }
                lstInnerWrapper.add(new InnerWrapper('ProspectStage',SobjectName));
                // Add search by attribute later
                lstInnerWrapper.add(new InnerWrapper('SearchBy','mx_salesforce_ID'));
                if(SobjectName == 'Lead'){
                    lstInnerWrapper.add(new InnerWrapper('mx_salesforce_ID',obj.Id));
                }
                else if(SobjectName == 'Opportunity'){
                    if(((Opportunity)obj).Assigned_to_Resi_ASM__c){
                        lstInnerWrapper.add(new InnerWrapper('mx_salesforce_ID',((Opportunity)obj).LeadId__c));
                    }
                    else{
                        lstInnerWrapper.add(new InnerWrapper('mx_salesforce_ID',obj.Id));
                    }
                }
                mapRecordPosition.Put(i,Obj);
                i++;
                lstlstWrapper.add(lstInnerWrapper);
            }
            system.debug('lstInnerWrapper'+lstInnerWrapper);
            system.debug('lstInnerWrapper'+Json.serialize(lstlstWrapper));
            system.debug('mapRecordPosition'+mapRecordPosition.size());
        
            ResponseWrapper res = new ResponseWrapper();
            res.sbody = Json.serialize(lstlstWrapper);
            res.mapPosition = mapRecordPosition;

            system.debug('+++ResponseWrapper++'+res);

            return res;
    }

    public class InnerWrapper{
        String Attribute;
        String Value;

        public InnerWrapper(Lead_Square_Mapping__c objMap,Sobject objLead,String sobjectName){
            this.Attribute = objMap.Lead_Square_Field__c;
            if(SobjectName.equalsIgnoreCase('Lead')){
                //this.value = objMap.IsDateField__C? (String.IsNotBlank(String.ValueOf(getResult(ObjLead,objMap.SF_Lead_Field__c)))?String.ValueOf(getResult(ObjLead,objMap.SF_Lead_Field__c)):String.ValueOf(getResult(ObjLead,objMap.SF_Lead_Field__c))):String.ValueOf(getResult(ObjLead,objMap.SF_Lead_Field__c));
                this.value = String.ValueOf(getResult(ObjLead,objMap.SF_Lead_Field__c));
            }else{
                system.debug('field'+objMap.SF_Opportunity_Field__c);
                //this.value = objMap.IsDateField__C? (String.IsNotBlank(String.ValueOf(getResult(ObjLead,objMap.SF_Opportunity_Field__c)))?String.ValueOf(getResult(ObjLead,objMap.SF_Opportunity_Field__c)):String.ValueOf(getResult(ObjLead,objMap.SF_Opportunity_Field__c))):String.ValueOf(getResult(ObjLead,objMap.SF_Opportunity_Field__c));
                this.value = String.ValueOf(getResult(ObjLead,objMap.SF_Opportunity_Field__c));
            }
            
        }
        public InnerWrapper(String Attribute, String Value){
            this.Attribute = Attribute;
            this.Value = Value;
        }   
    }

    public static Object getResult(SObject record, String field)
    {
        
        if (record == null || String.isBlank(field) ) {
            return null;
        }
        if (!field.contains('.')) {
            return record.get(field);
        }
        return getResult(
            record.getSObject(field.substringBefore('.')),
            field.substringAfter('.')
        );
    }

    /**
    * @description
    * @author Bharatesh Shetty | 8/12/2019
    * @param Map<Id, SObject> newMap
    * @param Map<Id, SObject> oldMap
    * @param List<Lead> newList
    * @return void
    */
    public static void updateLeadSquareModifeidDate (Map<Id,SObject> newMap,Map<Id,SObject> oldMap,List<Opportunity> newList){
        System.debug('updateLeadSquareModifeidDate method called');
        try{
            Set<Id> setOfIds = new Set<Id>();
            if(oldMap == null && newMap == null && !newList.isEmpty()){
                System.debug('updateLeadSquareModifeidDate called from before insert');
                for(Opportunity eachNewOpp : newList ){
                    eachNewOpp.Lead_square_modified_date__c = System.Now();
                }
            }
            else{
                System.debug('updateLeadSquareModifeidDate called from before Update');
                //setOfIds = LeadSquareIntegration_Controller.checkIfLeadSquareFieldsModified(newMap,oldMap,'Lead_Square_Integration_Opportunity','Opportunity');
                setOfIds = checkIfLeadSquareFieldsModified(newMap,oldMap,'Lead_Square_Integration_Opportunity','Opportunity');
                if(!setOfIds.isEmpty()){
                    System.debug('set Of Ids not empty');
                    for(Id eachId : setOfIds){
                       if(newMap.containsKey(eachId)){
                           ((Opportunity)newMap.get(eachId)).Lead_square_modified_date__c = System.Now();
                       } 
                    }
                }
            }
            /*if(!setOfIds.isEmpty()){
                System.debug('set Of Ids not empty');
                //List<Opportunity> listOfOppToUpdateLeadSquareModifiedDate = new List<Opportunity>();
                for(Id eachId : setOfIds){

                    Opportunity opportunityToUpdate = new Opportunity();
                    OpportunityToUpdate.id = eachId;
                    OpportunityToUpdate.Lead_square_modified_date__c = System.Now();
                    listOfOppToUpdateLeadSquareModifiedDate.add(OpportunityToUpdate); 
                }
                if(!listOfOppToUpdateLeadSquareModifiedDate.isEmpty()){
                    System.debug('listOfOppToUpdateLeadSquareModifiedDate not empty');
                    update listOfOppToUpdateLeadSquareModifiedDate;
                }
            }*/
        }
        catch(Exception e){
            System.debug('Exception : '+e.getStackTraceString());
        }
    }
    
    Public static void updateCustomerEmail(map < id, Opportunity > opplist, map < id, Opportunity > opplistold) {
        System.debug('updateCustomerEmail method called');
        map < id, Account > accountmap = new map < id, Account > ();
        map < id, Opportunity > oppmap = new map < id, Opportunity > ();
        Set < Id > actid = new Set < Id > ();
        List < Opportunity > updateopp = new List < Opportunity > ();
        List <String> newcustomeremail = new List<String>();
        List <String> oldcustomeremail = new List<String>();
        
        System.debug('%%%%%%%oppmap%%%%%%%%'+opplist);
        System.debug('%%%%%%%oppmap%%%%%%%%'+opplistold);
        
        for (Opportunity opp: opplist.values()) {
            if (opplistold == NULL) {
                if (opp.AccountId != NULL) {
                    oppmap.put(opp.AccountId, opp);
                    
                }
            } else if (opp.AccountId != opplistold.get(opp.Id).AccountId) {
                
                oppmap.put(opp.AccountId, opp);
                
            }
            else if (opplistold != NULL){
                if(opp.Customer_Email__c != opplistold.get(opp.Id).Customer_Email__c){
                    newcustomeremail.add(opp.Customer_Email__c);
                    oldcustomeremail.add(opplistold.get(opp.Id).Customer_Email__c);
                }
            }
        }
        System.debug('%%%%%%%oppmap%%%%%%%%'+oppmap);
        if(!oppmap.isEmpty()){
            for (Account actobj: [SELECT id, PersonEmail,Phone from Account Where id In: oppmap.keyset()]) {
                accountmap.put(actobj.id, actobj);
            }
        }   
        
        for (Opportunity opp: oppmap.values()) {
            if (accountmap.containskey(opp.AccountId)) {
                Opportunity oppr = new Opportunity(id = opp.id);
                oppr.Customer_Email__c = accountmap.get(opp.AccountId).PersonEmail;
                oppr.Customer_Phone_Lead_Square__c = accountmap.get(opp.AccountId).Phone;
                updateopp.add(oppr);
            }
        }
        
        System.debug('%%%%%%%drsererew%%%%%%%%'+updateopp);
        if (RecursiveTriggerHandlerOpp.isFirstTime) {
            RecursiveTriggerHandlerOpp.isFirstTime = false;
            if (updateopp.size() > 0) {
                update updateopp;
                
                
            }
        }
        if(!test.isrunningtest() && newcustomeremail.size() > 0){
            // Changecustomeremail.customeremailChange(oldcustomeremail, newcustomeremail);
            Changecustomeremail.customeremailChange(newcustomeremail,oldcustomeremail);
        }
    }
    
    public class ResponseWrapper{
        Public String sbody;
        Public Map<Integer,Sobject> mapPosition;
    }
    public class LeadSquaredResponseWrapper{
		public Boolean LeadCreated;
		public Boolean LeadUpdated;
		public String LeadId;
		public Integer AffectedRows;
		public Integer RowNumber;
        public String ExceptionType;
        public String ErrorMessage;
    }
}