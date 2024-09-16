/**
* @File Name          : UpdateOpportunityDetails_Controller.cls
* @Description        : 
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 08-06-2021
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0    8/12/2019, 10:48:23 AM   Bharatesh Shetty     Initial Version
**/
public Without Sharing class UpdateOpportunityDetails_Controller{
    public  Id OpportunityID{ get; set; }
    public  Opportunity objOpportunity {get; set;}
    
    Public String Name{get;set;}
    public String Email{get;set;}
    public String City{get;set;}
    Public String Mobile{get;set;}
    Public String SalesDescription{get;set;}
    Public String propertyNameManual {get;set;}
    Public String lostOpp{get;set;}
    Public String existingPropertyName{get;set;}
    Public Boolean alreadyHasProperty {get;set;}
    Public Boolean isPropertyUpdate {get;set;}
    Public Boolean shouldDisableGoogleProperty {get;set;}
    Public String googlePropertyDetails {get;set;}
    Public String propertyNameFromGoogle {get;set;}
    public String selectedBlockerValue {get;set;}
    public String selectedPropertyStatus {get;set;}
    Public Boolean propertyNotFoundInGoogle {get;set;}
    Public String noneValue = '--NONE--';
    Public String selectedLostReason{get;set;}
    Public String selectedLostToPlayer{get;set;}
    public String selectedStatus {get;set;}
    public String selectedSubStatus {get;set;}
    
    Public Decimal probabilityOfClosure{get;set;}
    
    Public Date newClosedate{get;set;}
    //Public Date followUpTime{get;set;}
    
    public DateTime followUpTime {get;set;}
    
    public Date possessionDate {get;set;}
    public Date propertyMoveInDate {get;set;}
    
    Public List<SelectOption> listOfLostOpp {get;set;}
    public  List<SelectOption> listOfBlockersValues {get;set;}
    public  List<SelectOption> listOfPropertyStatus {get;set;}
    public  List<SelectOption> listOfLostReason {get;set;}
    public  List<SelectOption> listOfLostToPlayer {get;set;}
    public  List<SelectOption> listOfStatus {get;set;}
    public  List<SelectOption> listOfSubStatus {get;set;}
    
    Public Boolean shouldDisplayLossReason {get;set;}
    
    Public Set<String> setOfAvailableStatus = new Set<String>();
    Public Map<String,List<String>> mapOfStatusListOfSubStatus = new Map<String,List<String>>();
    
    //Public DateTime followUpTime{get;set;}
    
    public UpdateOpportunityDetails_Controller(ApexPages.StandardController controller) {
        //Sobject Lead = new Sobject();
        OpportunityID =  controller.getrecord().id;
        listOfLostOpp = new List<SelectOption>();
        listOfBlockersValues = new List<SelectOption>();
        listOfPropertyStatus = new List<SelectOption>();
        alreadyHasProperty = false;
        isPropertyUpdate = false;
        mapOfStatusListOfSubStatus = new Map<String,List<String>>();
        if(String.isNotBlank(OpportunityID)){
            
            objOpportunity =[Select id,Name,Customer_Email__c,Customer_Phone_Number__c,CityfromLead__c,Sales_Description__c,Lost_Opp__c,
                             Probability_of_Closure_1__c,Property_Name__c,Property_Name__r.Name,New_Close_Date__c,Follow_Up_Time__c,Full_Name__c,Blockers__c,
                             Property_Status__c,LeadId__c,Loss_Reason__c,Lost_to_Player__c,Property_Move_In_Date__c,When_is_the_actual_possession_date__c,
                             New_Opportunity_Status__c,Opportunity_Funnel_Status__c,Opportunity_Funnel_Sub_Status__c
                             from Opportunity 
                             where id = :OpportunityID];
            alreadyHasProperty = objOpportunity.Property_Name__c != null ? True : False;        
            if(objOpportunity.Property_Name__c != null){
                alreadyHasProperty = true;
                existingPropertyName = objOpportunity.Property_Name__r.Name;
                System.debug('existingPropertyName: '+existingPropertyName);
            }
            if(objOpportunity !=null){
                shouldDisplayLossReason = false;
                Name = objOpportunity.Full_Name__c;
                Email = objOpportunity.Customer_Email__c;
                City = objOpportunity.CityfromLead__c;
                possessionDate = objOpportunity.When_is_the_actual_possession_date__c;
                propertyMoveInDate = objOpportunity.Property_Move_In_Date__c;
                selectedPropertyStatus = objOpportunity.Property_Status__c != null ? objOpportunity.Property_Status__c : noneValue;
                //selectedBlockerValue =  String.isNotBlank(objOpportunity.Blockers__c) ? objOpportunity.Blockers__c : noneValue;
                System.debug('objOpportunity.Blockers__c: '+objOpportunity.Blockers__c);
                //Commented with OFM Changes
                /*if(String.isNotBlank(objOpportunity.Blockers__c)){
                    if(objOpportunity.Blockers__c.contains(';')){
                        selectedBlockerValue = objOpportunity.Blockers__c.split(';')[0];
                    }
                    else{
                        selectedBlockerValue = objOpportunity.Blockers__c;
                    }
                }
                else{
                    selectedBlockerValue = noneValue;
                }*/
                Mobile = String.isNotBlank(objOpportunity.Customer_Phone_Number__c) ? objOpportunity.Customer_Phone_Number__c.replaceAll('\\D','') : null;
                SalesDescription = objOpportunity.Sales_Description__c;
                
                //Commented with OFM Changes
                /*if(String.isNotBlank(objOpportunity.Lost_Opp__c))
                {
                    if(objOpportunity.Lost_Opp__c.equalsIgnoreCase('Lost')){
                        lostOpp = 'Lost';
                        shouldDisplayLossReason = true;
                    }else{
                        lostOpp = '--NONE--';
                    }
                }else{
                    lostOpp = '--NONE--';
                }*/
                
                selectedStatus = objOpportunity.Opportunity_Funnel_Status__c != null ? objOpportunity.Opportunity_Funnel_Status__c : noneValue;
                selectedSubStatus = objOpportunity.Opportunity_Funnel_Sub_Status__c != null ? objOpportunity.Opportunity_Funnel_Sub_Status__c : noneValue;
                selectedLostToPlayer = objOpportunity.Lost_to_Player__c != null ? objOpportunity.Lost_to_Player__c : noneValue;
                selectedLostReason = objOpportunity.Loss_Reason__c != null ? objOpportunity.Loss_Reason__c : noneValue;
                System.debug('Loss_Reason__c: '+objOpportunity.Loss_Reason__c);
                System.debug('selectedLostReason: '+selectedLostReason);
                System.debug('selectedLostToPlayer: '+selectedLostToPlayer);
                probabilityOfClosure = objOpportunity.Probability_of_Closure_1__c;
                System.debug('objOpportunity.Probability_of_Closure_1__c: '+objOpportunity.Probability_of_Closure_1__c);
                newClosedate = objOpportunity.New_Close_Date__c;
                
                followUpTime = objOpportunity.Follow_Up_Time__c;
                //followUpTime = Date.ValueOf(objOpportunity.Follow_Up_Time__c);
                
                //Commented with OFM changes
                /*listOfLostOpp.add(new SelectOption('Lost','Lost'));
                listOfLostOpp.add(new SelectOption('--NONE--','--NONE--'));
                listOfBlockersValues = getPickValues(objOpportunity, 'Blockers__c', selectedBlockerValue);*/
                
                listOfPropertyStatus = getPickValues(objOpportunity, 'Property_Status__c',noneValue);
                listOfLostReason = getPickValues(objOpportunity, 'Loss_Reason__c',noneValue);
                listOfLostToPlayer = getPickValues(objOpportunity, 'Lost_to_Player__c',noneValue);
                
                setOfAvailableStatus = getAvailableStatusListForCurrentStatus(objOpportunity.Opportunity_Funnel_Status__c);
                setOfAvailableStatus.add(selectedStatus);
                listOfStatus = new List<SelectOption>();
                if(!setOfAvailableStatus.isEmpty()){
                    System.debug('setOfAvailableStatus:'+setOfAvailableStatus);
                    for(String status: setOfAvailableStatus){
                        listOfStatus.add(new SelectOption(status,status));
                    }
                    listOfStatus.sort();
                }
                mapOfStatusListOfSubStatus = GetDependentPicklistValuesDetails.getDependentPicklistValues(Opportunity.Opportunity_Funnel_Sub_Status__c);
                System.debug('mapOfStatusListOfSubStatus:'+mapOfStatusListOfSubStatus);
                //For setting Sub Status List
                handleStatusFieldDependency();
            }   
        }
    } 
    public PageReference googlePropertySearchDisableToggle(){
        shouldDisableGoogleProperty = propertyNotFoundInGoogle?true:false;
        return null;
    }
    Public PageReference saveRecord(){
        System.debug('Apex method called');
        String result;
        try{
            if(OpportunityID !=null){
                System.debug('OpportunityID: '+OpportunityID);
                Opportunity opportunityToUpdate = new Opportunity();
                Lead leadPropertyToUpdate = new Lead();
                Boolean errorCase = false;
                Id leadrecordUpdateId;
                
                if(possessionDate != objOpportunity.When_is_the_actual_possession_date__c && (possessionDate < System.today() || possessionDate == NULL)){
                    errorCase = true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Possession Date cannot be blank or a past date. Please select a future date.'));
                }
                else if(possessionDate != objOpportunity.When_is_the_actual_possession_date__c && possessionDate >= System.today()){
                    opportunityToUpdate.When_is_the_actual_possession_date__c = possessionDate;
                    leadPropertyToUpdate.Id = objOpportunity.LeadId__c;
                    leadPropertyToUpdate.Possession_Date__c = possessionDate;
                }
                if(propertyMoveInDate != objOpportunity.Property_Move_In_Date__c && (propertyMoveInDate < System.today() || propertyMoveInDate == NULL)){
                    errorCase = true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Property Move In Date cannot be blank or a past date. Please select a future date.'));
                }
                else if(propertyMoveInDate != objOpportunity.Property_Move_In_Date__c && propertyMoveInDate >= System.today()){
                    opportunityToUpdate.Property_Move_In_Date__c = propertyMoveInDate;
                    leadPropertyToUpdate.Id = objOpportunity.LeadId__c;
                    leadPropertyToUpdate.Property_Move_In_Date__c = propertyMoveInDate;
                }
                if(! errorCase){
                    //Commented with OFM changes
                    /*if(selectedBlockerValue == noneValue){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Blocker value is mandatory. Please select any suitable value to proceed.'));
                    }
                    else if(lostOpp.equalsIgnoreCase('Lost') && (selectedLostReason == noneValue || selectedLostToPlayer == noneValue)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Lost Reason and Lost to Player is mandatory when the Lost opportunity is selected. Please select any suitable value to proceed.'));
                    }
                    else if(selectedBlockerValue =='Possession' && (possessionDate < System.today() || (possessionDate != objOpportunity.When_is_the_actual_possession_date__c && possessionDate < System.today().addDays(30)))){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Blocker value is Possession. Please select any valid Possession Date after one month from today.'));
                    }*/
                    /*else if((followUpTime == NULL || followUpTime < System.today()) && (!objOpportunity.New_Opportunity_Status__c.contains('Won') && !objOpportunity.New_Opportunity_Status__c.contains('Lost') && ! objOpportunity.New_Opportunity_Status__c.contains('Cancelled'))){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Follow-up Date is mandatory since the New Opportunity Status is not among Won,Lost or Cancelled. Please select a valid future date value.'));
                    }*/
                    //If codition Added with OFM Changes
                    if(selectedStatus.equalsIgnoreCase('Lost')){
                       
                        opportunityToUpdate.Loss_Reason__c = selectedsubstatus;
                        
                    }
                    if(selectedStatus.equalsIgnoreCase('Lost') && (selectedLostToPlayer == noneValue)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Lost to Player is mandatory when the Lost opportunity is selected. Please select any suitable value to proceed.'));
                    }
                    else{
                        googlePropertyDetails = Apexpages.currentPage().getParameters().get('googlePropertyDetails');
                        System.debug('googlePropertyDetails: '+googlePropertyDetails);
                        System.debug('alreadyHasProperty'+alreadyHasProperty+isPropertyUpdate );
                        if(!alreadyHasProperty || isPropertyUpdate){
                            System.debug('1');
                            List<Master__c> propertyInsertList = new List<Master__c>();
                            Id propertyRecordTypeId = Schema.getGlobalDescribe().get('Master__c').getDescribe().getRecordTypeInfosByName().get('Property').getRecordTypeId();
                            Master__c newProperty = new Master__c();
                            newProperty.RecordTypeId = propertyRecordTypeId;
                            System.debug('propertyNotFoundInGoogle..'+propertyNotFoundInGoogle);
                            System.debug('googlePropertyDetails'+googlePropertyDetails);
                            // If property not found in google and property is manually entered then create a new property and link it to the lead.
                            if(propertyNotFoundInGoogle && String.isNotBlank(propertyNameManual)){
                                System.debug('propertyNotFoundInGoogle: '+propertyNotFoundInGoogle);
                                newProperty.Name = propertyNameManual;
                                newProperty.DataBase_Type__c = MasterConstants.DATABASE_TYPE_UNVERIFIED;
                                newProperty.Verification_Status__c = MasterConstants.VERIFICATION_STATUS_GOOGLE_NOT_VERIFIED; 
                                propertyInsertList.add(newProperty);
                                if(!propertyInsertList.isEmpty()){
                                    insert propertyInsertList;
                                    opportunityToUpdate.Property_Name__c = propertyInsertList[0].Id;
                                    leadPropertyToUpdate.Id = objOpportunity.LeadId__c;
                                    leadPropertyToUpdate.Property__c = propertyInsertList[0].Id;
                                }
                                System.debug('propertyNotFoundInGoogle..'+propertyNotFoundInGoogle);
                                System.debug('googlePropertyDetails'+googlePropertyDetails);
                            }
                            // If Property found in google and the google property json is filled 
                            else if(!propertyNotFoundInGoogle && !String.isBlank(googlePropertyDetails) && googlePropertyDetails !='""'){
                                System.debug('2');
                                System.debug('propertyNotFoundInGoogle: '+propertyNotFoundInGoogle);
                                // Make an internal callout to AddressInfo API 
                                //result = CallOutToAddressInfoAPI.callAddressInfoAPI(googlePropertyDetails);
                                System.debug('result: '+result);
                                // If the result is success do nothing as everything is already taken care in the AddressInfo API class.
                                //If the result is not Success
                                if(result!='Success'){
                                    Map<String, Object> JSON_Input = new Map<String, Object>();
                                    JSON_Input = (Map<String, Object>)JSON.deserializeUntyped(googlePropertyDetails);
                                    // Call the CreateMaster method from AddressInfoApi class to create a new Property passing the json from google search and link the newly created property to the lead.
                                    newProperty = AddressInfoApi.createMaster(JSON_Input, propertyRecordTypeId, MasterConstants.VERIFICATION_STATUS_GOOGLE_VERIFIED, googlePropertyDetails);
                                    if(newProperty !=null && newProperty.id!=null){
                                        opportunityToUpdate.Property_Name__c = newProperty.Id;
                                        leadPropertyToUpdate.Id = objOpportunity.LeadId__c;
                                        leadPropertyToUpdate.Property__c = newProperty.Id;
                                    }
                                    else {
                                        return null;
                                    }
                                }
                            }
                            
                        }
                        
                        opportunityToUpdate.Id = OpportunityID;
                        opportunityToUpdate.Sales_Description__c = SalesDescription;
                        
                        //Commented and Changed with OFM changes
                        opportunityToUpdate.Probability_of_Closure_1__c = probabilityOfClosure ;
                        /*opportunityToUpdate.Lost_Opp__c = lostOpp.equalsIgnoreCase('--none--')?'':lostOpp;*/
                        opportunityToUpdate.Lost_Opp__c = selectedStatus.equalsIgnoreCase('Lost')?selectedStatus:'';
                        
                        opportunityToUpdate.New_Close_Date__c = newClosedate;
                        opportunityToUpdate.Follow_Up_Time__c = followUpTime;
                        
                        //opportunityToUpdate.Blockers__c = selectedBlockerValue;
                        opportunityToUpdate.Property_Status__c = selectedPropertyStatus != noneValue ? selectedPropertyStatus : NULL ;
                        //opportunityToUpdate.Loss_Reason__c = selectedLostReason != noneValue ? selectedLostReason : NULL ;
                        opportunityToUpdate.Lost_to_Player__c = selectedLostToPlayer != noneValue ? selectedLostToPlayer : NULL ;
                        opportunityToUpdate.Opportunity_Funnel_Status__c = selectedStatus;
                        opportunityToUpdate.Opportunity_Funnel_Sub_Status__c = selectedSubStatus;
                        //System.debug(1/0);
                        //
                        
                        System.debug('Possession Date: '+opportunityToUpdate.When_is_the_actual_possession_date__c);
                        System.debug('Possession Date Selected: '+possessionDate);
                        update opportunityToUpdate;
                        if(leadPropertyToUpdate.id != Null){
                            update leadPropertyToUpdate;
                        }
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Your changes saved successfully.'));
                        return NULL;
                    }
                }
            }
        }
        Catch(Exception e){
            ApexPages.addMessages(e);
            System.debug('Exception : '+e.getStackTraceString());
            System.debug('Exception Message: '+e.getMessage());
            return null;
        }
        return NULL;
    } 
    public List<selectOption> getPickValues(Sobject object_name, String field_name, String first_val) {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        if (first_val != null) { //if there is a first value being provided
            options.add(new selectOption(first_val, first_val)); //add the first option
        }
        Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            if(first_val != a.getValue()){
                options.add(new selectOption(a.getValue(), a.getLabel())); //add the value and label to our final list
            }
        }
        options.sort();
        return options; //return the List
    }
    Public PageReference checkDisplayLossReason(){
        shouldDisplayLossReason = selectedStatus.equalsIgnoreCase('Lost') ? True : False;
        System.debug('shouldDisplayLossReason: '+shouldDisplayLossReason);
        return null;
    }
    public Set<String> getAvailableStatusListForCurrentStatus(String CurrentStatus){
        setOfAvailableStatus = new Set<String>();
        for(Opportunity_Status_Mapping__mdt objMeta:[Select id,New_Status__c,Old_Status__c from Opportunity_Status_Mapping__mdt where Old_Status__c=:CurrentStatus]){
            setOfAvailableStatus.add(objMeta.New_Status__c);
        }
        System.debug('setOfAvailableStatus:'+setOfAvailableStatus);
        return setOfAvailableStatus;
    }
    public void handleStatusFieldDependency() {
        listOfSubStatus = new List<SelectOption>();
        System.debug('mapOfStatusListOfSubStatus: '+mapOfStatusListOfSubStatus);
        if(mapOfStatusListOfSubStatus != Null && !mapOfStatusListOfSubStatus.isEmpty()){
            if(mapOfStatusListOfSubStatus.containsKey(selectedStatus)){
                for(String SubStatus : mapOfStatusListOfSubStatus.get(selectedStatus)){
                    System.debug('Print SubStatus: '+SubStatus);
                    listOfSubStatus.add(new selectOption(SubStatus,SubStatus));
                }
            }
        }
        //Added with OFM Changes
        checkDisplayLossReason();
    }
}