/**
* @File Name          : UpdateLeadDetails_Controller.cls
* @Description        : 
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 9/23/2019, 1:52:54 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0    8/12/2019, 10:48:23 AM   Bharatesh Shetty     Initial Version
**/
public Without Sharing class UpdateLeadDetails_Controller{
    public  Id LeadId { get; set; }
    public  lead objLead {get; set;}
    public  string scity {get; set;}
    
    public  List<SelectOption> listOfAppointmentVenue {get;set;}
    public  List<SelectOption> listOfCities {get;set;}
    Public List<Master__c> listOfActiveShowRooms;
    Public List<Master__c> listOfBlitzBuilderName;
    
    Public String referrerPhoneNumber {get;set;}
    Public String noneValue = '--NONE--';
    public String selectedShowRoom{get;set;}
    public String selectedCity{get;set;}
    public String leadLastName{get;set;}
    public String email{get;set;}
    public String phone{get;set;}
    public String selectedBuilderName {get;set;}
    public String selectedPropertyType {get;set;}
    public String selectedPropertyStatus {get;set;}
    public String selectedPropertyConfig {get;set;}
    public String selectedPurposeOfInteriors {get;set;}
    public String selectedBudgetRange {get;set;}
    public String selectedFloorPlanRecieved {get;set;}
    public String selectedFirstHome {get;set;}
    public String selectedAppointmentType {get;set;}
    public String selectedHowDidYouHearAboutUs {get;set;}
    Public String meetingBookingUrl {get;set;}
    public String appointmentAddressMannualEnter {get;set;}
    public String appointmentDoorNumber {get;set;}
    Public String appointmentLandmark {get;set;}
    Public String propertyNameManual {get;set;}
    
    Public String propertyNameFromGoogle {get;set;}
    Public String addressFromGoogle {get;set;}
    //Public String calledFromButton {get;set;}
    Public String otherSource {get;set;}
    Public String googlePropertyDetails {get;set;}
    Public String endPointUrl {get;set;}
    public string callfunc{get;set;}
    Public String appointmentTimeString{get;set;}
    Public String description{get;set;}
    public String selectedStatus {get;set;}
    public String selectedSubStatus {get;set;}
    public String selectedReasonForDeadLead {get;set;}
    public String outOfServicingAreaCity {get;set;}
    Public String uploadFloorPlanURl {get;set;}
    public String altPhoneNumber{get;set;}
    public String existingPropertyName{get;set;}
    public String pincode{get;set;}
    public String selectedPrimaryLanguage{get;set;}
    public String selectedSecondaryLanguage{get;set;}
    public String selectedSubStatusDead{get;set;}
    Public Boolean propertyNotFoundInGoogle {get;set;}
    Public Boolean addressNotFoundInGoogle {get;set;}
    Public Boolean kitchenCheckbox {get;set;}
    Public Boolean wardrobesCheckbox {get;set;}
    Public Boolean modularStorgeCheckbox {get;set;}
    Public Boolean looseFurnitureCheckbox {get;set;}
    Public Boolean hdsCheckbox {get;set;}
    Public Boolean isResidenceOrSiteVisitType {get;set;}
    Public Boolean alreadyHasProperty {get;set;}
    Public Boolean displayReasonForDeadLead {get;set;}
    Public Boolean dispalyButtons {get;set;}
    Public Boolean isNonServiceableCity {get;set;}
    Public Boolean shouldRenderAltAppointmentTime {get;set;}
    Public Boolean isPropertyUpdate {get;set;}
    Public Boolean shouldDisableGoogleProperty {get;set;}
    Public Boolean isBulkOfflineLead {get;set;}
    Public Boolean isPincodeBlank {get;set;}
    Public Boolean isFromOthersCity {get;set;}
    Public Boolean meetingFixedByWarroomAgent {get;set;}
    
    public  List<SelectOption> listOfBuilderName {get;set;}
    public  List<SelectOption> listOfPropertyType {get;set;}
    public  List<SelectOption> listOfPropertyStatus {get;set;}
    public  List<SelectOption> listOfPropertyConfig {get;set;}
    public  List<SelectOption> listOfPurposeOfInteriors {get;set;}
    public  List<SelectOption> listOfBudgetRange {get;set;}
    public  List<SelectOption> listOfFloorPlanRecieved {get;set;}
    public  List<SelectOption> listOfFirstHome {get;set;}
    public  List<SelectOption> listOfAppointmentType {get;set;}
    public  List<SelectOption> listOfHowDidYouHearAboutUs {get;set;}
    public  List<SelectOption> listOfStatus {get;set;}
    public  List<SelectOption> listOfSubStatus {get;set;}
    public  List<SelectOption> listOfReasonForDeadLead {get;set;}
    public  List<SelectOption> listOfPrimaryLanguage {get;set;}
    public  List<SelectOption> listOfSecondaryLanguage {get;set;}
    public  List<SelectOption> listOfSubStatusDead{get;set;}
    
    public Date possessionDate {get;set;}
    public Date propertyMoveInDate {get;set;}
    public DateTime preferredAppointmentSlot {get;set;}
    //publicaccounts = new list<Dead_Status__c>();
    
    public DateTime appointmentTime {get;set;}
    public DateTime followUpTime {get;set;}
    public DateTime alternativeAppointmentTime {get;set;}
    //public String PropertyConfig{get;set;}
    List<Master__c> updateProperty = new   List<Master__c> ();
    //Newly Added for Renovation Service
    Public Set<String> originalValues = new Set<String>();
    Public Set<String> previoslySelectedValues = new Set<String>();
    Public List<string> leftselected{get;set;}
    Public List<string> rightselected{get;set;}
    Set<string> leftvalues = new Set<string>();
    Set<string> rightvalues = new Set<string>();
    
    Public Map<String,List<String>> mapOfStatusListOfSubStatus = new Map<String,List<String>>();
    Public Map<String,List<String>> mapOfStatusListOfDeadLeadReason = new Map<String,List<String>>();
    Public Set<String> setOfAvailableStatus = new Set<String>();
    @TestVisible
    private boolean hasBeenClickedAlready = false;
    public PageReference captureButtonClick() {
       hasBeenClickedAlready = true;
       return null;
    }
    public Boolean disableSaveButton {
       get {
          return hasBeenClickedAlready;
       }
    }
    
    public UpdateLeadDetails_Controller(ApexPages.StandardController controller) {
        //Sobject Lead = new Sobject();
        listOfCities = new List<SelectOption>();
        listOfAppointmentVenue = new List<SelectOption>();
        listOfBuilderName = new List<SelectOption>();
        listOfPropertyType = new List<SelectOption>();
        listOfPropertyStatus = new List<SelectOption>();
        listOfPropertyConfig = new List<SelectOption>();
        listOfPurposeOfInteriors = new List<SelectOption>();
        listOfBudgetRange = new List<SelectOption>();
        listOfFloorPlanRecieved = new List<SelectOption>();
        listOfFirstHome = new List<SelectOption>();
        listOfAppointmentType = new List<SelectOption>();
        listOfHowDidYouHearAboutUs = new List<SelectOption>();
        listOfActiveShowRooms = new List<Master__c>(); 
        List<City__c> allCitiesQueryList = new List<City__c>();
        
        //LeadId =  controller.getrecord().id;
        system.debug('++++LeadId++++'+controller.getrecord().id);
        LeadId = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('++++LeadId++++'+LeadId);
        propertyNotFoundInGoogle = false;
        addressNotFoundInGoogle = false;
        kitchenCheckbox = false;
        wardrobesCheckbox = false;
        modularStorgeCheckbox = false;
        looseFurnitureCheckbox = false;
        hdsCheckbox = false;
        alreadyHasProperty = false;
        endPointUrl ='';
        dispalyButtons = false;
        isNonServiceableCity = false;
        shouldRenderAltAppointmentTime = false;
        isPropertyUpdate = false;
        shouldDisableGoogleProperty = false;
        isBulkOfflineLead = false;
        isPincodeBlank = false;
        isFromOthersCity = false;
        meetingFixedByWarroomAgent=false;
        
        //try{
        if(String.isNotBlank(LeadId)){
            system.debug('++++LeadId++++'+LeadId);
            List<Lead> listOfLeadsQueried = new List<Lead>();
            listOfLeadsQueried =[Select id,LastName,Brand__c,Property_Type__c,Property_Status__c,Possession_Date__c,Property_Config__c,Email,Phone,Schedule_a_meeting_on_Acuity__c,
                                 city,How_did_you_hear_about_us__c,Appointment_Type__c,Appointment_Venue_Square__c,Purpose_of_Interiors__c,Schedule_a_meeting_on_Acuity_v2__c,
                                 Appointment_Venue_Square__r.Name,Property__c,Property__r.name,Property__r.Type__C,Budget_Range__c,Property_Move_In_Date__c,Floorplan_Received__c,
                                 First_home__c,HL_Referrer_Phone__c,Appointment_Venue_Site_Residence_Add1__c,Appointment_Venue_Site_Resi_Locality__c,Builder_Name__c,Builder_Name__r.Name,
                                 Appointment_Venue_Site_Resi_Landmark__c,Street, Appointment_Time__c,Other_Source__c,Status,Sub_Status__c,Interior_Start_Date__c,
                                 Kitchen__c,Wardrobes__c,Entertainment_Unit__c,Crockery_Unit__c,Study_Table_Book_Shelf__c,Pooja__c,Vanity_Unit__c,Utility_Unit__c,
                                 Foyer_Shoe_Rack__c,Urban_Ladder__c,False_Ceiling__c,Wallpaper__c,Painting__c,Renovation_Services__c,Description__c,Sales_Manager__c,
                                 Sales_Manager__r.Name,Reason_For_Dead_Lead__c,Follow_up_time__c,Out_of_Servicing_City__c,Alternative_Appointment_Time__c,Upload_Floor_Plan__c,
                                 Alt_Phone_Number__c,Primary_Language__c,Secondary_Language__c,Bulk_Upload__c,Account__c,PostalCode,Assigned_to_Resi_ASM__c,Assigned_To_TLC__c,
                                 Preferred_Appointment_Slot__c,Assigned_to_Doowup_Presales__c,Assigned_To_Inside_Sales_Agent__c,Assigned_to_Central_Team__c,Central_Team_Agent__c,
                                 Inside_Sales_Agent__c,Meeting_Fixed_by_Warroom_Agent__c

                                 from Lead where id = :LeadId ];
            if(!listOfLeadsQueried.isEmpty())
            {
                objLead = listOfLeadsQueried[0]; 
                if(objLead !=null)
                {
                    /*meetingBookingUrl = Label.MeetingBookingFromUpdateLeadDetailsURL;
                    if(String.isNotBlank(meetingBookingUrl)){
                        meetingBookingUrl +=LeadId;
                    }*/
                    System.debug('objLead.Schedule_a_meeting_on_Acuity_v2__c: '+objLead.Schedule_a_meeting_on_Acuity_v2__c);
                    System.debug('objLead.Schedule_a_meeting_on_Acuity__c: '+objLead.Schedule_a_meeting_on_Acuity__c);
                    //meetingBookingUrl = objLead.Schedule_a_meeting_on_Acuity_v2__c;
                        if(objLead.Brand__c == 'Doowup')
                        {
                            if(objLead.Schedule_a_meeting_on_Acuity_v2__c.containsIgnoreCase(Label.Current_Org_Domain)){
                            meetingBookingUrl = Label.Site_User_Domain +'/MeetingScheduleDoowupPage?LeadId='+LeadId;
                            System.debug('meetingBookingUrl: '+meetingBookingUrl);
                        }
                        else
                        {
                           meetingBookingUrl = objLead.Schedule_a_meeting_on_Acuity_v2__c; 
                            System.debug('meetingBookingUrl: '+meetingBookingUrl);
                        }
                    }
                    else
                    {
                        if(objLead.Schedule_a_meeting_on_Acuity_v2__c.containsIgnoreCase(Label.Current_Org_Domain)){
                        meetingBookingUrl = Label.Site_User_Domain +'/MeetingSchedulePage?LeadId='+LeadId;
                        System.debug('meetingBookingUrl: '+meetingBookingUrl);
                    }
                    else
                    {
                       meetingBookingUrl = objLead.Schedule_a_meeting_on_Acuity_v2__c; 
                        System.debug('meetingBookingUrl: '+meetingBookingUrl);
                    }
                    }
                    
                    uploadFloorPlanURl = objLead.Upload_Floor_Plan__c;
                    kitchenCheckbox = objLead.Kitchen__c == LeadConstants.VALUE_YES ? True : False;                    
                    wardrobesCheckbox = (String.isNotBlank(objLead.Wardrobes__c) && objLead.Wardrobes__c !='0' )? True : False;
                    meetingFixedByWarroomAgent= objLead.Meeting_Fixed_by_Warroom_Agent__c;
                    
                    if(objLead.Entertainment_Unit__c == LeadConstants.VALUE_YES || objLead.Crockery_Unit__c == LeadConstants.VALUE_YES ||objLead.Study_Table_Book_Shelf__c == LeadConstants.VALUE_YES ||
                       objLead.Pooja__c == LeadConstants.VALUE_YES || objLead.Vanity_Unit__c == LeadConstants.VALUE_YES || objLead.Utility_Unit__c == LeadConstants.VALUE_YES){
                           modularStorgeCheckbox = True;
                       }
                    if(objLead.Foyer_Shoe_Rack__c == LeadConstants.VALUE_YES || String.isNotBlank(objLead.Urban_Ladder__c)){
                        looseFurnitureCheckbox = True;
                    }
                    if(objLead.False_Ceiling__c || objLead.Wallpaper__c || objLead.Painting__c){
                        hdsCheckbox = true;
                    }
                    
                    selectedCity = objLead.city;
                    leadLastName = objLead.LastName;
                    email = objLead.Email;
                    phone = objLead.Phone;
                    altPhoneNumber = objLead.Alt_Phone_Number__c;
                    pincode = objLead.PostalCode;
                    if(objLead.Appointment_Time__c != null){
                        System.debug('objLead.Appointment_Time__c: '+objLead.Appointment_Time__c);
                        appointmentTimeString = objLead.Appointment_Time__c.format();
                        System.debug('appointmentTimeString: '+appointmentTimeString);
                    }
                    isBulkOfflineLead = objLead.Bulk_Upload__c;
                    System.debug('isBulkOfflineLead: '+isBulkOfflineLead);
                    isPincodeBlank = String.isBlank(objLead.PostalCode)? True : False;
                    if(objLead.City.equalsIgnoreCase('other') || objLead.City.equalsIgnoreCase('others')){
                        isFromOthersCity = True;
                    }
                    else{
                        isFromOthersCity = False;
                    }                    
                   
                    appointmentAddressMannualEnter = objLead.Appointment_Venue_Site_Residence_Add1__c != null ? objLead.Appointment_Venue_Site_Residence_Add1__c : '';//28th June 2024
                    addressNotFoundInGoogle = String.isBlank(objLead.Appointment_Venue_Site_Residence_Add1__c)? false : true;
                    appointmentDoorNumber = objLead.Appointment_Venue_Site_Resi_Locality__c!=null ? objLead.Appointment_Venue_Site_Resi_Locality__c : '';//28th June 2024
                    appointmentLandmark = objLead.Appointment_Venue_Site_Resi_Landmark__c!=null ? objLead.Appointment_Venue_Site_Resi_Landmark__c : '';//28th June 2024
                    referrerPhoneNumber = objLead.HL_Referrer_Phone__c!=null ? objLead.HL_Referrer_Phone__c : '';//28th June 2024
               //     selectedBuilderName = objLead.Builder_Name__c != null ? objLead.Builder_Name__c : noneValue;
                    selectedPropertyType = objLead.Property_Type__c != null ? objLead.Property_Type__c : noneValue;
                    selectedPropertyStatus = objLead.Property_Status__c != null ? objLead.Property_Status__c : noneValue;
                    selectedPropertyConfig = objLead.Property_Config__c != null ? objLead.Property_Config__c : noneValue;
                    possessionDate = objLead.Possession_Date__c!=null ? objLead.Possession_Date__c : null; //28th June 2024
                    preferredAppointmentSlot =objLead.Preferred_Appointment_Slot__c!=null ? objLead.Preferred_Appointment_Slot__c : null; //28th June 2024
                    selectedPurposeOfInteriors = objLead.Purpose_of_Interiors__c != null ? objLead.Purpose_of_Interiors__c : noneValue;
                    selectedBudgetRange = objLead.Budget_Range__c != null ? objLead.Budget_Range__c : noneValue;
                    propertyMoveInDate = objLead.Property_Move_In_Date__c!=null ? objLead.Property_Move_In_Date__c : null; //28th June 2024
                    //interiorStartDate =objLead.Interior_Start_Date__c;
                    selectedFloorPlanRecieved = objLead.Floorplan_Received__c != null ? objLead.Floorplan_Received__c : noneValue;
                    selectedFirstHome = objLead.First_home__c != null ? objLead.First_home__c : noneValue;
                    selectedAppointmentType = objLead.Appointment_Type__c != null ? objLead.Appointment_Type__c : noneValue;
                    alreadyHasProperty = objLead.Property__c != null ? True : False;
                    if(alreadyHasProperty && objLead.Property__c != null){
                        existingPropertyName = objLead.Property__r.Name;
                        System.debug('existingPropertyName: '+existingPropertyName);
                    }
                    selectedPrimaryLanguage =  String.isNotBlank(objLead.Primary_Language__c) ? objLead.Primary_Language__c : noneValue;
                    selectedSecondaryLanguage = String.isNotBlank(objLead.Secondary_Language__c) ? objLead.Secondary_Language__c : noneValue;
                    /*System.debug('Property Name: '+objLead.Property__r.name);
System.debug('Property Type: '+objLead.Property__r.Type__C); 
System.debug('Sales_Manager__r.Name: '+objLead.Sales_Manager__r.Name);*/ 
                    otherSource = objLead.Other_Source__c !=null ? objLead.Other_Source__c : '';
                    // Calling checkAppointMentType method to set the isResidenceOrSiteVisitType boolean value based on the Appointment Type Value
                    checkAppointMentType();
                    
                    selectedHowDidYouHearAboutUs = objLead.How_did_you_hear_about_us__c != null ? objLead.How_did_you_hear_about_us__c : noneValue;
                    if(objLead.Appointment_Venue_Square__c !=null)
                    {
                        selectedShowRoom = objLead.Appointment_Venue_Square__r.Name;
                    }
                    else
                    {
                        selectedShowRoom = '--SELECT AN APPOINTMENT VENUE--';
                    }
                    if(objLead.Builder_Name__c !=null)
                    {
                        selectedBuilderName = objLead.Builder_Name__r.Name;
                    }
                    else
                    {
                        selectedBuilderName = '--SELECT BUILDER NAME--';
                    }
                    //Newly Added for Renovation Service
                    leftselected = new List<String>();
                    rightselected = new List<String>();
                    Schema.sObjectType sobject_type = objLead.getSObjectType(); //grab the sobject that was passed
                    Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
                    Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
                    List<Schema.PicklistEntry> pick_list_values = field_map.get('Renovation_Services__c').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
                    for (Schema.PicklistEntry a : pick_list_values) 
                    { //for all values in the picklist list
                        //add the value and label to our final list
                        originalValues.add(a.getValue());
                    }
                    System.debug('objLead.Renovation_Services__c: '+objLead.Renovation_Services__c);
                    if(objLead.Renovation_Services__c !=null && !String.isBlank(objLead.Renovation_Services__c))
                    {
                        System.debug('objLead.Renovation_Services__c: '+objLead.Renovation_Services__c);
                        List<String> listOfVal = objLead.Renovation_Services__c.split(';');
                        System.debug('listOfVal: '+listOfVal);
                        if(!listOfVal.isEmpty())
                        {
                            System.debug('listOfVal: '+listOfVal);
                            for(String val : listOfVal)
                            {
                                System.debug('val: '+val);
                                previoslySelectedValues.add(val);
                                originalValues.remove(val);
                            }
                        }
                    }
                    if(!originalValues.isEmpty())
                    {
                        leftvalues.addAll(originalValues);
                    }
                    if(!previoslySelectedValues.isEmpty())
                    {
                        rightvalues.addAll(previoslySelectedValues);
                    }
                }
                System.debug('selectedShowRoom: '+selectedShowRoom);
                allCitiesQueryList = City__c.getall().values();
                  
           /*     listOfActiveShowRooms = [Select Id,Name from Master__c where (Type__c=:MasterConstants.TYPE_SHOWROOM OR 
                                        (Type__c=:MasterConstants.DEALER_SHOWROOM AND (Property_City__c=:GenericConstants.LD_City_Hyderabad OR 
                                         Property_City__c=:GenericConstants.LD_City_Mysore OR Property_City__c=:GenericConstants.LD_City_Kolkata))) and 
                                         IsActive__c = true and (Not Name like '%test showroom%')];*/
            	
            	// Brand wise showroom list added on 15th July 2024
            	
                if(!String.isBlank(objLead.Brand__c))
                {
                    	listOfActiveShowRooms = [Select Id,Name,Brand__c,IsActive__c from Master__c 
                                                 where Brand__c = :objLead.Brand__c and	IsActive__c = true and 
                                                 (Type__c=:MasterConstants.TYPE_SHOWROOM OR Type__c=:MasterConstants.DEALER_SHOWROOM) and (Not Name like '%test%')];
                }   
                else
                {
                    	listOfActiveShowRooms = [Select Id,Name,Brand__c,IsActive__c from Master__c 
                                                 where Brand__c = :GenericConstants.LEAD_HOMELANE and IsActive__c = true and 
                                                 (Type__c=:MasterConstants.TYPE_SHOWROOM OR Type__c=:MasterConstants.DEALER_SHOWROOM) and (Not Name like '%test%')];
                }
                
                if(!allCitiesQueryList.isEmpty())
                {
                    for(City__c city:allCitiesQueryList)
                    {
                        listOfCities.add(new SelectOption (city.Name,city.Name));  
                    }  
                }
                listOfAppointmentVenue.add(new SelectOption ('--SELECT AN APPOINTMENT VENUE--','--SELECT AN APPOINTMENT VENUE--'));
                if(!listOfActiveShowRooms.isEmpty())
                {
                    for(Master__c masterShowRoom:listOfActiveShowRooms)
                    {
                        if(!String.isBlank(masterShowRoom.Name))
                        {
                            listOfAppointmentVenue.add(new SelectOption (masterShowRoom.Name,masterShowRoom.Name));
                        }   
                    }
                }
                
                // Newly added builder list to select builder at Appointment Fixed Stage
                listOfBlitzBuilderName = [select id,Name,Type__c from Master__c where  Type__c = :MasterConstants.TYPE_BUILDER and (Blitz_Property__c =true OR Name = 'Other') order by Name];
                
                listOfBuilderName.add(new SelectOption ('--SELECT BUILDER NAME--','--SELECT BUILDER NAME--'));
                if(!listOfBlitzBuilderName.isEmpty())
                {
                    for(Master__c masterBuilder:listOfBlitzBuilderName)
                    {
                        if(!String.isBlank(masterBuilder.Name))
                        {
                            listOfBuilderName.add(new SelectOption (masterBuilder.Name,masterBuilder.Name));
                        }   
                    }
                }
                
                listOfPropertyType = getPickValues(objLead, 'Property_Type__c', noneValue,null);
                listOfPropertyStatus = getPickValues(objLead, 'Property_Status__c',noneValue,null);
                listOfPropertyConfig = getPickValues(objLead, 'Property_Config__c', noneValue,null);
                listOfPurposeOfInteriors = getPickValues(objLead, 'Purpose_of_Interiors__c', noneValue,null);
                listOfBudgetRange = getPickValues(objLead, 'Budget_Range__c',noneValue,objLead.Brand__c);
                listOfFloorPlanRecieved = getPickValues(objLead, 'Floorplan_Received__c', noneValue,null);
                listOfFirstHome = getPickValues(objLead, 'First_Home__c', noneValue,null);
                listOfAppointmentType = getPickValues(objLead, 'Appointment_Type__c', noneValue,null);
                listOfHowDidYouHearAboutUs = getPickValues(objLead, 'How_did_you_hear_about_us__c', noneValue,null);
                listOfPrimaryLanguage = getPickValues(objLead, 'Primary_Language__C', noneValue,null);
                listOfSecondaryLanguage = getPickValues(objLead, 'Secondary_Language__C', noneValue,null);
                
                //Added for Non Servicing Area city capture.
                isNonServiceableCity = objLead.Sub_Status__c =='Non serviceable city' ? True : False;
                outOfServicingAreaCity = isNonServiceableCity ? objLead.Out_of_Servicing_City__c : '';//28th June 2024
                //outOfServicingAreaCity = objLead.Out_of_Servicing_City__c;
                System.debug('isNonServiceableCity: '+isNonServiceableCity);
                System.debug('outOfServicingAreaCity: '+outOfServicingAreaCity);
                
                //Added after new Status substatus n other requirements.            
                selectedStatus = objLead.Status != null ? objLead.Status : 'noneValue';
                selectedSubStatus = objLead.Sub_Status__c != null ? objLead.Sub_Status__c : 'noneValue';
                selectedReasonForDeadLead = objLead.Reason_For_Dead_Lead__c != null ? objLead.Reason_For_Dead_Lead__c : 'noneValue';
                description = objLead.Description__c != null ? objLead.Description__c : '';  //28th June 2024
                followUpTime =objLead.Follow_up_time__c != null ? objLead.Follow_up_time__c : null; //28th June 2024
                alternativeAppointmentTime = objLead.Alternative_Appointment_Time__c!= null ? objLead.Alternative_Appointment_Time__c : null; //28th June 2024
                displayReasonForDeadLead = objLead.Status == GenericConstants.LEAD_DEAD_STATUS ? True : False;
                dispalyButtons = objLead.Status == GenericConstants.LEAD_APPOINTMENT_SUCCESSFUL ? false : True;
                
                setOfAvailableStatus =getAvailableStatusListForCurrentStatus(objLead.Status);
                setOfAvailableStatus.add(selectedStatus);
                listOfStatus = new List<SelectOption>();
                if(!setOfAvailableStatus.isEmpty())
                {
                    for(String status: setOfAvailableStatus)
                    {
                        listOfStatus.add(new SelectOption(status,status));
                    }
                    listOfStatus.sort();
                }
                else
                {
                }
                
                
                //setOfAvailableStatus.add(selectedStatus);
                //For setting Status List
                //getAndSetAvailableListOfStatus();
                
                //listOfStatus = getPickValues(objLead, 'Status', null); 
                //listOfSubStatus = getPickValues(objLead, 'Sub_Status__c', noneValue);
                
                //For setting listOfReasonForDeadLead
                //listOfReasonForDeadLead = getPickValues(objLead, 'Reason_For_Dead_Lead__c', null); 
                 //mapOfSubStatusAndReasonForDeadLead = GetDependentPicklistValuesDetails.getDependentPicklistValues(Lead.Reason_For_Dead_Lead__c);
                mapOfStatusListOfSubStatus = GetDependentPicklistValuesDetails.getDependentPicklistValues(Lead.Sub_Status__C);
                handleStatusFieldDependency();
                mapOfStatusListOfDeadLeadReason = GetDependentPicklistValuesDetails.getDependentPicklistValues(Lead.Reason_For_Dead_Lead__C);
                system.debug('mapOfStatusListOfDeadLeadReason '+ mapOfStatusListOfDeadLeadReason);
                system.debug('mapOfStatusListOfSubStatus '+ mapOfStatusListOfSubStatus);
                //For setting Sub Status List
               
                
                System.debug('displayReasonForDeadLead: '+displayReasonForDeadLead);
                
                System.debug('selectedStatus: '+selectedStatus);
                System.debug('------------listOfStatus------->: '+listOfStatus);
                System.debug('------------listOfStatus------->: '+listOfStatus);
                System.debug('selectedReasonForDeadLead: '+selectedReasonForDeadLead); 
                System.debug('objLead.Status: '+objLead.Status);
                System.debug('objLead.Sub_Status__c: '+objLead.Sub_Status__c);
                System.debug('objLead.Reason_For_Dead_Lead__c: '+objLead.Reason_For_Dead_Lead__c); 
            }
        }
        /*}
catch(exception e){
System.debug('Exception Message: '+e.getMessage());
System.debug('Exception StackTraceString: '+e.getStackTraceString());
}*/
    }
    Public PageReference SubmitLeadRecord()
    {
        
        try
        {
            Lead leadRecordToUpdate = new Lead();
            if(LeadId !=null)
            {
                System.debug('followUpTime :'+followUpTime);
                System.debug('System.now() :'+System.now());
                System.debug('selectedStatus :'+selectedStatus);
                System.debug('selectedSubStatus :'+selectedSubStatus);
                System.debug('objLead.Status :'+objLead.Status);
                System.debug('objLead.Sub_Status__c :'+objLead.Sub_Status__c);
                
                if((selectedStatus == GenericConstants.LEAD_FRESH_STATUS || selectedStatus== GenericConstants.LEAD_APPOINTMENT_UNSUCCESSFUL || selectedStatus == GenericConstants.LEAD_APPOINTMENT_CANCELLED) && (selectedSubStatus == GenericConstants.LEAD_SUBSTATS_FOLLOWUP_LATER_CX  || selectedSubStatus == GenericConstants.LEAD_SUBSTATS_FOLLOWUP_LATER_NOT_MENTION) && (followUpTime == NULL || followUpTime <= System.now()))
                {
                    //Add Error message 
                    System.debug('Follow Up Time Error.');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Follow-Up time is mandatory. Please fill a valid future Follow-Up time.'));
                }
               //Commented this code on 22nd July 2024 
              /*  else if(selectedStatus == GenericConstants.LEAD_PRE_APPOINTMENT_STATUS && ObjLead.Assigned_to_Resi_ASM__c)
                {                    
                        System.debug('Unvalid user');
                    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot change status to Pre Appointment as you are not valid user '));
                }*/
                else if(selectedStatus == GenericConstants.LEAD_PRE_APPOINTMENT_STATUS && possessionDate == Null)
                {
                    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Possession/Interior start date is mandatory please enter a valid future value'));
                }
                
                
                else if(ObjLead.Assigned_To_TLC__c && (selectedStatus == GenericConstants.LEAD_APPOINTMENT_FIXED_STATUS  || selectedStatus == GenericConstants.LEAD_APPOINTMENT_CANCELLED))
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot change status as you are not valid user'));
                }
                 else if(ObjLead.Assigned_to_Doowup_Presales__c && (selectedStatus == GenericConstants.LEAD_APPOINTMENT_FIXED_STATUS  || selectedStatus == GenericConstants.LEAD_APPOINTMENT_CANCELLED))
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot change status as you are not valid user'));
                }
                 /* else if(ObjLead.Assigned_To_Inside_Sales_Agent__c && ( selectedStatus == GenericConstants.LEAD_APPOINTMENT_CANCELLED)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot change status as you are not valid user'));
                } */ 
                
                /*else if(selectedStatus=='Pre-Appointment' && selectedPropertyConfig == null && !modularStorgeCheckbox  && !looseFurnitureCheckbox && !hdsCheckbox){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Property config is required'));
                    }*/
                else
                {
                    String result;
                    String successMessage = 'Your changes saved successfully.';
                    //calledFromButton = Apexpages.currentPage().getParameters().get('calledFromButton');
                    googlePropertyDetails = Apexpages.currentPage().getParameters().get('googlePropertyDetails');
                    System.debug('googlePropertyDetails: '+googlePropertyDetails);
                    System.debug('addressFromGoogle: '+addressFromGoogle);
                    //System.debug('calledFromButton: '+calledFromButton);
                    list<Master__c> SelectedShowRoomQueryList = new list<Master__c>();
                  /*  SelectedShowRoomQueryList = [Select Id,Name from Master__c where (Type__c=:MasterConstants.TYPE_SHOWROOM OR 
                                                (Type__c=:MasterConstants.DEALER_SHOWROOM AND (Property_City__c=:GenericConstants.LD_City_Hyderabad OR 
                                                Property_City__c=:GenericConstants.LD_City_Mysore OR Property_City__c=:GenericConstants.LD_City_Kolkata))) and 
                                                IsActive__c = true and Name =:selectedShowRoom limit 1];*/
                    
                    SelectedShowRoomQueryList =[Select Id,Name,Brand__c,IsActive__c from Master__c 
                                                where IsActive__c = true and (Type__c=:MasterConstants.TYPE_SHOWROOM OR Type__c=:MasterConstants.DEALER_SHOWROOM) 
                                                and Name =:selectedShowRoom limit 1];
                    
                    if(!SelectedShowRoomQueryList.isEmpty())
                    {
                        leadRecordToUpdate.Appointment_Venue_Square__c = SelectedShowRoomQueryList[0].Id;
                    }
                    
                    list<Master__c> SelectedBuilderQueryList = new list<Master__c>();
                    SelectedBuilderQueryList = [Select Id,Name from Master__c where Type__c=:MasterConstants.TYPE_BUILDER and (Blitz_Property__c =true OR Name = 'Other') and Name =:selectedBuilderName limit 1];
                    if(!SelectedBuilderQueryList.isEmpty())
                    {
                        leadRecordToUpdate.Builder_Name__c = SelectedBuilderQueryList[0].Id;
                    }
                    leadRecordToUpdate.Id = LeadId;
                    /*leadRecordToUpdate.LastName = leadLastName;
                    leadRecordToUpdate.Email = email;
                    leadRecordToUpdate.Phone = phone;
                    leadRecordToUpdate.city = selectedCity;*/
                    /*if(String.isBlank(objLead.PostalCode) && String.isNotBlank(pincode)){
                        leadRecordToUpdate.PostalCode = pincode;
                    }*/
                    if(objLead.PostalCode != pincode && String.isNotBlank(pincode))
                    {
                        leadRecordToUpdate.PostalCode = pincode;
                    }
                    System.debug('');
                    if(objLead.city != selectedCity && String.isNotBlank(selectedCity) && !(selectedCity.equalsIgnoreCase('other') || selectedCity.equalsIgnoreCase('others')))
                    {
                        leadRecordToUpdate.city = selectedCity;
                    }
                    leadRecordToUpdate.Alt_Phone_Number__c = altPhoneNumber != null ? altPhoneNumber : NULL ; //28th June 2024
                    leadRecordToUpdate.Property_Type__c = selectedPropertyType != noneValue ? selectedPropertyType : NULL ;
                    leadRecordToUpdate.Property_Status__c = selectedPropertyStatus != noneValue ? selectedPropertyStatus : NULL ;
                    leadRecordToUpdate.Property_Config__c = selectedPropertyConfig != noneValue ? selectedPropertyConfig : NULL ;
                    leadRecordToUpdate.Possession_Date__c = possessionDate != null ? possessionDate : NULL ; //28th June 2024
                    //leadRecordToUpdate.Interior_Start_Date__c = interiorStartDate;
                    
                    leadRecordToUpdate.Purpose_Of_Interiors__c = selectedPurposeOfInteriors != noneValue ? selectedPurposeOfInteriors : NULL ;
                    leadRecordToUpdate.Budget_Range__c = selectedBudgetRange != noneValue ? selectedBudgetRange : NULL ;
                    leadRecordToUpdate.Property_Move_In_Date__c = propertyMoveInDate != null ? propertyMoveInDate : NULL ; //28th June 2024
                    leadRecordToUpdate.FloorPlan_Received__c = selectedFloorPlanRecieved != noneValue ? selectedFloorPlanRecieved : NULL ;
                    leadRecordToUpdate.First_Home__c = selectedFirstHome != noneValue ? selectedFirstHome : NULL ;
                    leadRecordToUpdate.Appointment_Type__c = selectedAppointmentType != noneValue ? selectedAppointmentType : NULL ;
                    leadRecordToUpdate.How_did_you_hear_about_us__c = selectedHowDidYouHearAboutUs != noneValue ? selectedHowDidYouHearAboutUs : NULL ;
                    leadRecordToUpdate.Primary_Language__c = selectedPrimaryLanguage != noneValue ? selectedPrimaryLanguage : NULL ;
                    leadRecordToUpdate.Secondary_Language__c = selectedSecondaryLanguage != noneValue ? selectedSecondaryLanguage : NULL ;
                    //leadRecordToUpdate.Appointment_Time__c = appointmentTime;
                    if(addressNotFoundInGoogle)
                    {
                        leadRecordToUpdate.Appointment_Venue_Site_Residence_Add1__c = appointmentAddressMannualEnter ;
                        leadRecordToUpdate.Street = appointmentAddressMannualEnter;
                        System.debug('appointmentAddressMannualEnter: '+appointmentAddressMannualEnter);
                    }
                    else
                    {
                        leadRecordToUpdate.Appointment_Venue_Site_Residence_Add1__c = addressFromGoogle != null ? addressFromGoogle : NULL ; //28th June 2024 ;
                        leadRecordToUpdate.Street = addressFromGoogle != null ? addressFromGoogle : NULL ; //28th June 2024 ;
                      //  System.debug('addressFromGoogle: '+addressFromGoogle);
                    }
                    if(kitchenCheckbox)
                    {
                        leadRecordToUpdate.Kitchen__c = 'Yes';
                    }
                    else
                    {
                        leadRecordToUpdate.Kitchen__c = 'No';
                    }
                    if(wardrobesCheckbox)
                    {
                        leadRecordToUpdate.Wardrobes__c = '1';
                    }
                    else
                    {
                        leadRecordToUpdate.Wardrobes__c = '0';
                    }
                    if(meetingFixedByWarroomAgent)
                    {
                        leadRecordToUpdate.Meeting_Fixed_by_Warroom_Agent__c = true;
                    }
                    else
                    {
                        leadRecordToUpdate.Meeting_Fixed_by_Warroom_Agent__c = false;
                    }
                    if(modularStorgeCheckbox)
                    {
                        leadRecordToUpdate.Entertainment_Unit__c = 'Yes';
                        leadRecordToUpdate.Crockery_Unit__c = 'Yes';
                        leadRecordToUpdate.Study_Table_Book_Shelf__c = 'Yes';
                        leadRecordToUpdate.Pooja__c = 'Yes';
                        leadRecordToUpdate.Vanity_Unit__c = 'Yes';
                        leadRecordToUpdate.Utility_Unit__c = 'Yes';
                    }
                    else
                    {
                        leadRecordToUpdate.Entertainment_Unit__c = 'No';
                        leadRecordToUpdate.Crockery_Unit__c = 'No';
                        leadRecordToUpdate.Study_Table_Book_Shelf__c = 'No';
                        leadRecordToUpdate.Pooja__c = 'No';
                        leadRecordToUpdate.Vanity_Unit__c = 'No';
                        leadRecordToUpdate.Utility_Unit__c = 'No';
                    }
                    if(looseFurnitureCheckbox)
                    {
                        leadRecordToUpdate.Urban_Ladder__c = 'Category A';
                        leadRecordToUpdate.Foyer_Shoe_Rack__c = 'Yes';
                    }
                    else
                    {
                        //leadRecordToUpdate.Urban_Ladder__c = 'Category A';
                        leadRecordToUpdate.Foyer_Shoe_Rack__c = 'No';
                    }
                    if(hdsCheckbox)
                    {
                        leadRecordToUpdate.False_Ceiling__c = True;
                        leadRecordToUpdate.Wallpaper__c = True;
                        leadRecordToUpdate.Painting__c = True;
                    }
                    else
                    {
                        leadRecordToUpdate.False_Ceiling__c = False;
                        leadRecordToUpdate.Wallpaper__c = False;
                        leadRecordToUpdate.Painting__c = False;
                    }
                    /*if(addressNotFoundInGoogle){
leadRecordToUpdate.Appointment_Venue_Site_Residence_Add1__c = appointmentAddressMannualEnter ;
leadRecordToUpdate.Street = appointmentAddressMannualEnter;
} */
                    
                    if(selectedHowDidYouHearAboutUs == 'Refered by a friend who has used HL' || selectedHowDidYouHearAboutUs == 'Refered by a friend who knows about HL')
                    {
                        leadRecordToUpdate.HL_Referrer_Phone__c = referrerPhoneNumber !=null ? referrerPhoneNumber : null; //28th June 2024
                    }
                    else if(selectedHowDidYouHearAboutUs == 'Others')
                    {
                        leadRecordToUpdate.Other_Source__c = otherSource;
                    }
                    leadRecordToUpdate.Appointment_Venue_Site_Resi_Locality__c = appointmentDoorNumber ;
                    leadRecordToUpdate.Appointment_Venue_Site_Resi_Landmark__c = appointmentLandmark ;
                    
                    leadRecordToUpdate.Out_of_Servicing_City__c = outOfServicingAreaCity != null ? outOfServicingAreaCity : ''; //28th June 2024
                    
                    //Chek if the Lead doesn't has property already and the property is not found in google as well then create a new Property with  
                    //the Property Name manually entered and link it to the lead.
                    //Incase if it does not have a property or if they have chosen for property update
                    if(!alreadyHasProperty || isPropertyUpdate)
                    {
                        List<Master__c> propertyInsertList = new List<Master__c>();
                        Id propertyRecordTypeId = Schema.getGlobalDescribe().get('Master__c').getDescribe().getRecordTypeInfosByName().get('Property').getRecordTypeId();
                        Master__c newProperty = new Master__c();
                        newProperty.RecordTypeId = propertyRecordTypeId;
                        // If property not found in google and property is manually entered then create a new property and link it to the lead.
                        if(propertyNotFoundInGoogle && String.isNotBlank(propertyNameManual))
                        {
                            System.debug('propertyNotFoundInGoogle: '+propertyNotFoundInGoogle);
                            newProperty.Name = propertyNameManual;
                            newProperty.DataBase_Type__c = MasterConstants.DATABASE_TYPE_UNVERIFIED;
                            newProperty.Verification_Status__c = MasterConstants.VERIFICATION_STATUS_GOOGLE_NOT_VERIFIED; 
                            propertyInsertList.add(newProperty);
                            if(!propertyInsertList.isEmpty())
                            {
                                insert propertyInsertList;
                                leadRecordToUpdate.Property__c = propertyInsertList[0].Id;
                            }
                        }
                        // If Property found in google and the google property json is filled 
                        else if(!propertyNotFoundInGoogle && !String.isBlank(googlePropertyDetails) && googlePropertyDetails !='""')
                        {
                            System.debug('propertyNotFoundInGoogle: '+propertyNotFoundInGoogle);
                            // Make an internal callout to AddressInfo API 
                            result = CallOutToAddressInfoAPI.callAddressInfoAPI(googlePropertyDetails);
                            System.debug('result: '+result);
                            // If the result is success do nothing as everything is already taken care in the AddressInfo API class.
                            //If the result is not Success
                            if(result!='Success')
                            {
                                Map<String, Object> JSON_Input = new Map<String, Object>();
                                JSON_Input = (Map<String, Object>)JSON.deserializeUntyped(googlePropertyDetails);
                                // Call the CreateMaster method from AddressInfoApi class to create a new Property passing the json from google search and link the newly created property to the lead.
                                newProperty = AddressInfoApi.createMaster(JSON_Input, propertyRecordTypeId, MasterConstants.VERIFICATION_STATUS_GOOGLE_VERIFIED, googlePropertyDetails);
                                
                                if(newProperty !=null && newProperty.id!=null)
                                {
                                    leadRecordToUpdate.Property__c = newProperty.Id;
                                    newProperty.Description__c = newProperty.Description__c+'UpdateLead address';
                                	updateProperty.add(newProperty);
                                }
                                else 
                                {
                                    
                                }
                            }
                        }
                        
                    }
                    //newly added for renovation service
                    if(!rightvalues.isEmpty())
                    {
                        System.debug('rightvalues not empty');
                        String renovationServices ='';
                        for(String val: rightvalues)
                        {
                            renovationServices +=val+';';
                        }
                        System.debug('renovationServices: '+renovationServices);
                        leadRecordToUpdate.Renovation_Services__c = renovationServices;
                    }
                    else
                    {
                        System.debug('rightvalues empty');
                        leadRecordToUpdate.Renovation_Services__c = null;
                    }
                    // Added after new Status substatus n other requirements. 
                    
                    
                        leadRecordToUpdate.status = selectedStatus;
                        leadRecordToUpdate.Sub_Status__c = selectedSubStatus;
                        system.debug('leadRecordToUpdate.Sub_Status__c '+ leadRecordToUpdate.Sub_Status__c);
                    
                    
                    leadRecordToUpdate.Description__c = description!=null ? description : null;
                    leadRecordToUpdate.Follow_up_time__c = followUpTime!=null ? followUpTime : null; //28th June 2024
                    leadRecordToUpdate.Alternative_Appointment_Time__c = alternativeAppointmentTime !=null ? alternativeAppointmentTime : null; //28th June 2024
                    System.debug('followUpTime: '+followUpTime);
                    System.debug('status: '+leadRecordToUpdate.status);
                    System.debug('Sub_Status__c: '+leadRecordToUpdate.Sub_Status__c);
                    System.debug('leadRecordToUpdate.Follow_up_time__c: '+leadRecordToUpdate.Follow_up_time__c);
                    if(selectedStatus == 'Dead Lead')
                    {
                        leadRecordToUpdate.Reason_For_Dead_Lead__c = selectedReasonForDeadLead;
                    }
                    /*if(calledFromButton == 'APPOINTMENT'){
successMessage += ' And the Appointment is Fixed.';
leadRecordToUpdate.Status = LeadConstants.LEAD_STATUS_APPOINTMENT_FIXED;
leadRecordToUpdate.Sub_Status__c = LeadConstants.LEAD_SUB_STATUS_APPOINTMENT_FIXED;
leadRecordToUpdate.Interior_Start_Date__c = objLead.Interior_Start_Date__c == null? possessionDate: objLead.Interior_Start_Date__c;
}*/
                    leadRecordToUpdate.Interior_Start_Date__c = objLead.Interior_Start_Date__c == null? possessionDate: objLead.Interior_Start_Date__c;
                    leadRecordToUpdate.Preferred_Appointment_Slot__c =preferredAppointmentSlot != null ? preferredAppointmentSlot : null;//28th June 2024
                    if(selectedSubStatus != objLead.Sub_Status__c && selectedSubStatus =='Unable To Contact' 
                       && (selectedStatus == GenericConstants.LEAD_FRESH_STATUS || selectedStatus =='Appointment Unsuccessful' || selectedStatus =='Appointment Cancelled') 
                       && (followUpTime ==Null || followUpTime <= System.now()))
                    {
                           DateTime returnFollowUpTimeValue = updateFollowUpTime();
                           if(returnFollowUpTimeValue != null)
                           {
                               leadRecordToUpdate.Follow_up_time__c = returnFollowUpTimeValue;
                           }
                       }
                    
                    System.debug('Final Record to be updated :'+leadRecordToUpdate);
                    // Update the Lead record
                    update leadRecordToUpdate;
                    
                    if(String.isNotBlank(email) && objLead.Email != email && isBulkOfflineLead & objLead.Account__c !=Null)
                    {
                        // If the email is changed in the bulk offline lead then update the email in the account(will automatically get updated in the lead).
                        System.debug('email: '+email);
                        System.debug('objLead.email: '+objLead.email);
                        Account accToUpdate = new Account();
                        accToUpdate.Id = objLead.Account__c;
                        accToUpdate.PersonEmail = email;
                        update accToUpdate;
                    }
                    if(selectedStatus == LeadConstants.LEAD_STATUS_APPOINTMENT_FIXED)
                    {
                        successMessage += ' And the Appointment is Fixed.';
                    }
                    //Add success page message 
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,successMessage));
                    
                    // google sheet callout call after saving the lead details.
                    
                 //	  Commented because we are getting AUthorization error on 8th July 2024
                 //   callOutToGoogleSheets(leadRecordToUpdate.id);
                    
                    // Callout to R function to check the Property details if property not found in google and Address info API failed for some reaon in case of property found in google.
                    if((propertyNotFoundInGoogle && String.isNotBlank(propertyNameManual))|| result !='Success')
                    {
                        System.debug('propertyNotFoundInGoogle in callout to R if Block: '+propertyNotFoundInGoogle);
                        //CallOutToR_Function.callFunction(leadRecordToUpdate.id);
                    }
                    if(!updateProperty.isEmpty())
                    {
                        update updateProperty;
                    }
                }
            }
        }
        catch(Exception e)
        {
            ApexPages.addMessages(e);
            system.debug('Exception occurred: '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            
            //return null;
        }
        /*PageReference tempPage = new pagereference('https://hlprod-workscontracthomelane.cs72.force.com/Downloadfile/UpdateLeadDetails?id=00Q5D000002Zyip');
//PageReference tempPage = new pagereference('https://homelane--hlprod--c.cs72.visual.force.com/apex/UpdateLeadDetails?id=00Q5D000002Zyip');

ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Success'));
tempPage.setRedirect(true);
return tempPage; */
        
        return null;
    }
    public List<selectOption> getPickValues(Sobject object_name, String field_name, String first_val,String Brand) 
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        if (first_val != null) 
        { //if there is a first value being provided
            options.add(new selectOption(first_val, first_val)); //add the first option
        }
        
        Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        Set<String> includedHLValues =new Set<String>{'Upto 1.5L','1.5L - 4L','4L - 8L','6L - 8L','8L - 12L','12L - 20L','20L+','Cx didn\'t disclose','Cx did not disclose'};
            Set<String> includedDoowupValues =new Set<String>{'50K - 1.5L','1.5L - 3L','3L - 5L','5L - 8L','8L+','Cx didn\'t disclose','Cx did not disclose'};
            List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) 
        { //for all values in the picklist list
            if(field_name =='Budget_Range__c')
            {
                system.debug('String.valueOf(a)'+ String.valueOf(a));
                
                if(Brand == 'Doowup')
                {
                    if(includedDoowupValues.contains(String.valueOf(a.getValue())))
                    {
                        options.add(new selectOption(a.getValue(), a.getLabel())); 
                    }
                    
                }
                else
                {
                    if(includedHLValues.contains(String.valueOf(a.getValue())))
                    {
                        system.debug('valueOf(a)');
                        options.add(new selectOption(a.getValue(), a.getLabel()));
                    }
                }
            }
            
            else{
              options.add(new selectOption(a.getValue(), a.getLabel()));  
            } //add the value and label to our final list
        }
        //options.sort();
        
        return options; //return the List
    }
    
    // method to set the isResidenceOrSiteVisitType boolean value based on the Appointment Type Value
    public void checkAppointMentType() 
    {
        if(selectedAppointmentType == LeadConstants.RESIDENCE_VISIT_APPOINTMENT_TYPE || selectedAppointmentType == LeadConstants.SITE_VISIT_APPOINTMENT_TYPE || selectedAppointmentType == LeadConstants.OFFICE_VISIT_APPOINTMENT_TYPE)
        {
            isResidenceOrSiteVisitType = true;
        }
        else
        {
            isResidenceOrSiteVisitType = false;
        }
        chekcAltAppointmentTimeRendering();
        system.debug('selectedAppointmentType: '+selectedAppointmentType);
        system.debug('isResidenceOrSiteVisitType: '+isResidenceOrSiteVisitType);
    }
    
    
    Public void callOutToGoogleSheets(Id leadId)
    {
        try
        {
            if(leadId !=null)
            {
                Lead leadRecord;
                List<Lead> listOfLeadsQueryied = new List<Lead>();
                String queryString = UtilityClass.getQueryString('Lead');
                queryString += ',Property__r.Name,Appointment_Venue_Square__r.Name,Owner.Name,Sales_Manager__r.Name From Lead where id=:leadId';
                listOfLeadsQueryied = Database.query(queryString);
                if(!listOfLeadsQueryied.isEmpty())
                {
                    leadRecord = listOfLeadsQueryied[0];
                    String HDS,Loose_Furniture,Modular_Storage,Wardrobes;
                    
                    Wardrobes = (String.isNotBlank(leadRecord.Wardrobes__c) && leadRecord.Wardrobes__c !='0' ) ? 'Yes' : 'NO';
                    
                    if(leadRecord.Entertainment_Unit__c == LeadConstants.VALUE_YES || leadRecord.Crockery_Unit__c == LeadConstants.VALUE_YES ||leadRecord.Study_Table_Book_Shelf__c == LeadConstants.VALUE_YES ||
                       leadRecord.Pooja__c == LeadConstants.VALUE_YES || leadRecord.Vanity_Unit__c == LeadConstants.VALUE_YES || leadRecord.Utility_Unit__c == LeadConstants.VALUE_YES)
                    {
                           Modular_Storage = 'Yes';
                    }
                    else
                    {
                        Modular_Storage = 'No';
                    }
                    if(leadRecord.Foyer_Shoe_Rack__c == LeadConstants.VALUE_YES || String.isNotBlank(leadRecord.Urban_Ladder__c))
                    {
                        Loose_Furniture = 'Yes';
                    }
                    else
                    {
                        Loose_Furniture = 'No';
                    }
                    if(leadRecord.False_Ceiling__c || leadRecord.Wallpaper__c || leadRecord.Painting__c)
                    {
                        HDS = 'Yes';
                    }
                    else
                    {
                        HDS = 'No';
                    }
                    
                    Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                    Integration_Setting__c integrationDetail = allEndPoint.get('GOOGLE SHEET API');
                    
                    //String endPointUrl='https://script.google.com/macros/s/AKfycbxdS-e8f-p_uUveNuhLsqMwP33dAX33TVP4VuV_nr_SdukCtOY8/exec';
                    endPointUrl = integrationDetail.End_Point__c;
                    endPointUrl += '?timestamp='+System.now()+'&LookUp=&Lead_ID='+leadRecord.Id+'&Name='+leadRecord.Name+'&Email='+leadRecord.Email+'&Mobile='+leadRecord.Phone;
                    endPointUrl += '&City='+leadRecord.City+'&Property_Type='+leadRecord.Property_Type__c+'&Property_Status='+leadRecord.Property_Status__c;
                    endPointUrl += '&Property_Name='+'\''+leadRecord.Property__r.Name+'\''+'&Property_Config='+leadRecord.Property_Config__c+'&Possession_Month='+formatDate(leadRecord.Possession_Date__c);
                    endPointUrl += '&Kitchen='+leadRecord.Kitchen__c+'&Wardrobes='+Wardrobes+'&Modular_Storage='+Modular_Storage+'&Loose_Furniture='+Loose_Furniture;
                    endPointUrl += '&HDS='+HDS+'&Purpose_of_Interiors='+leadRecord.Purpose_of_Interiors__c+'&Budget_Range='+leadRecord.Budget_Range__c;
                    endPointUrl += '&Move-In_Date='+formatDate(leadRecord.Property_Move_In_Date__c)+'&Floor_Plan_Received='+leadRecord.Floorplan_Received__c;
                    endPointUrl += '&First_Home='+leadRecord.First_home__c+'&Appointment_type='+leadRecord.Appointment_Type__c+'&Appointment_Venue=';
                    endPointUrl += leadRecord.Appointment_Venue_Square__r.Name+'&Address='+'\''+ leadRecord.Street + '\'';
                    endPointUrl += '&Door_Flat_No='+'\''+leadRecord.Appointment_Venue_Site_Resi_Locality__c+'\''+'&Landmark='+'\''+ leadRecord.Appointment_Venue_Site_Resi_Landmark__c + '\'';
                    endPointUrl += '&How_did_you_hear_about_us='+leadRecord.How_did_you_hear_about_us__c+'&Referrer_Phone='+leadRecord.HL_Referrer_Phone__c;
                    endPointUrl += '&Lead_Status='+leadRecord.Status+'&Lead_Owner='+leadRecord.Sales_Manager__r.Name;
                    
                    System.debug('endPointUrl: '+endPointUrl); 
                }
                else
                {
                    System.debug('Lead with Lead Id : '+leadId+'Not found in salesforce');
                    Logger.log('Error','UpdateLeadDetails_Controller','callOutToGoogleSheets','Lead with Lead Id : '+leadId+'Not found in salesforce','',leadId);
                } 
            }
            else
            {
                System.debug('LeadId variable is null');
                Logger.log('Error','UpdateLeadDetails_Controller','callOutToGoogleSheets','LeadId variable is null','',leadId);
            } 
        }
        Catch(Exception e)
        {
            System.debug('Exception'+e.getMessage()+ ' Stack '+ e.getStackTraceString());
            Logger.log('Exception','UpdateLeadDetails_Controller','callOutToGoogleSheets',e.getMessage(),e.getStackTraceString(),leadId);
        }
        
       
    }
    public static String formatDate(Date d) 
    {
        if(d!=null)
        {
            return d.year() + '-' + d.month() + '-' + d.day();
        }
        return '';
    }
    
    public void handleStatusFieldDependency() 
    {
        listOfSubStatus = new List<SelectOption>();
        listOfReasonForDeadLead = new List<SelectOption>();
        String stringValue = 'DND Opt';
		
        if(!mapOfStatusListOfSubStatus.isEmpty())
        {
            if(mapOfStatusListOfSubStatus.containsKey(selectedStatus))
            {
                if(selectedStatus =='Dead Lead')
                {
                    listOfSubStatus.add(new selectOption('','--None--'));
                }
                
                for(String SubStatus : mapOfStatusListOfSubStatus.get(selectedStatus))
                {      
                    if(SubStatus != stringValue)
                    {
                        System.debug('Print SubStatus: '+SubStatus);                    
                    	listOfSubStatus.add(new selectOption(SubStatus,SubStatus));
                    }
                }
            }            
        }
        else
        {          
        }
         if(!mapOfStatusListOfDeadLeadReason.isEmpty())
         {
                    system.debug('selectedsubstatus'+ selectedSubStatus);
                    if(mapOfStatusListOfDeadLeadReason.containsKey(selectedSubStatus))
                    {
                        listOfReasonForDeadLead.add(new selectOption('','--None--'));
                        for(String reasonForDeadLead : mapOfStatusListOfDeadLeadReason.get(selectedSubStatus))
                        {                            
                            listOfReasonForDeadLead.add(new selectOption(reasonForDeadLead,reasonForDeadLead));
                        }
                    }
                }
                else
                {                    
                } 
        system.debug('listOfReasonForDeadLead'+ listOfReasonForDeadLead);
        displayReasonForDeadLead = selectedStatus =='Dead Lead' ? True : False;
        isNonServiceableCity = selectedStatus =='Dead Lead' && selectedSubStatus =='Non serviceable city' ? True : False;
        listOfSubStatus.sort();
        //listOfReasonForDeadLead.sort();
        System.debug('displayReasonForDeadLead: '+displayReasonForDeadLead);
        //System.debug('listOfSubStatus: '+listOfSubStatus);
        System.debug('selectedStatus: '+selectedStatus);
        System.debug('selectedSubStatus: '+selectedSubStatus);
        
        chekcAltAppointmentTimeRendering();
        listOfReasonForDeadLead.sort();
    }
    
    /*public void getAndSetAvailableListOfStatus(){
listOfStatus = new List<SelectOption>();
Map<String,AvailableLeadStatusForIronManPage__c> allStatusMap = AvailableLeadStatusForIronManPage__c.getAll();
for(String name : allStatusMap.keySet()){
if(!String.isBlank(allStatusMap.get(name).Status__c)){
setOfAvailableStatus.add(allStatusMap.get(name).Status__c);
}
}
System.debug('setOfAvailableStatus: '+setOfAvailableStatus);
if(!setOfAvailableStatus.isEmpty()){
for(String status : setOfAvailableStatus){
listOfStatus.add(new selectOption(status,status));
}
}
if(!listOfStatus.isEmpty()){
listOfStatus.sort();
}
}*/
    
    
    public Set<String> getAvailableStatusListForCurrentStatus(String CurrentStatus)
    {
        setOfAvailableStatus = new Set<String>();
        for(Status_Mapping__mdt objMeta:[Select id,New_Status__c,Old_Status__c from Status_Mapping__mdt where Old_Status__c=:CurrentStatus])
        {
            setOfAvailableStatus.add(objMeta.New_Status__c);
        }
        return setOfAvailableStatus;
    }
    public PageReference checkIsNonServicableAreaCity()
    {
        //Added for Non Servicing Area city capture request.
        isNonServiceableCity = selectedSubStatus =='Non serviceable city' ? True : False;
        System.debug('inside checkIsNonServicableAreaCity method isNonServiceableCity: '+isNonServiceableCity);
        System.debug('inside checkIsNonServicableAreaCity method selectedSubStatus: '+selectedSubStatus);
        return null;
    }
    public void chekcAltAppointmentTimeRendering()
    {
        shouldRenderAltAppointmentTime = False;
        System.debug('selectedStatus chekcAltAppointmentTimeRendering method: '+selectedSubStatus);
        System.debug('selectedAppointmentType chekcAltAppointmentTimeRendering method: '+selectedAppointmentType);
        if(!String.isBlank(selectedStatus) && !String.isBlank(selectedAppointmentType))
        {
            if(selectedStatus == 'Appointment Fixed' && selectedAppointmentType == 'Virtual Meeting')
            {
                shouldRenderAltAppointmentTime = True;
                System.debug('shouldRenderAltAppointmentTime: '+shouldRenderAltAppointmentTime);
            }
        }
    }
    //Newly added for Renovation Service
    public PageReference selectclick()
    {
        rightselected.clear();
        for(String s : leftselected)
        {
            leftvalues.remove(s);
            rightvalues.add(s);
        }
        return null;
    }
    //Newly added for Renovation Service
    public PageReference unselectclick()
    {
        leftselected.clear();
        for(String s : rightselected)
        {
            rightvalues.remove(s);
            leftvalues.add(s);
        }
        return null;
    }
    //Newly added for Renovation Service
    public List<SelectOption> getunSelectedValues()
    {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string s : tempList)
        {
            options.add(new SelectOption(s,s));
        }            
        return options;
    }
    //Newly added for Renovation Service
    public List<SelectOption> getSelectedValues()
    {
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    Public Static DateTime updateFollowUpTime()
    {
        DateTime returnFollowUpTimeValue = Null;
        try{
            System.debug('System.now():'+ System.now());
            
            Datetime workhourStart = Datetime.newInstance(Date.today().Year(),Date.today().Month(),Date.today().Day(),9, 00, 00);
            Datetime workhourEnd = Datetime.newInstance(Date.today().Year(),Date.today().Month(),Date.today().Day(),19, 00, 00);
            
            if(System.now() <= workhourStart)
            {
                returnFollowUpTimeValue = workhourStart.addHours(8);
                System.debug('returnFollowUpTimeValue: '+returnFollowUpTimeValue);
            }
            else if(System.now() >= workhourEnd)
            {
                returnFollowUpTimeValue = workhourStart.addDays(1).addHours(8);
                System.debug('returnFollowUpTimeValue: '+returnFollowUpTimeValue);
            }
            else
            {
                Long dt1Long = System.now().getTime();
                Long dt2Long = workhourEnd.getTime();
                Decimal RemainingWorkHoursToAddToday = 0;
                if(dt1Long != dt2Long)
                {
                    RemainingWorkHoursToAddToday = (Decimal.valueOf(dt2Long - dt1Long)/(1000*60*60));
                }
                /*Decimal milliseconds = Decimal.valueOf(dt2Long - dt1Long);
                Decimal seconds = milliseconds / 1000;
                Decimal minutes = seconds / 60;
                RemainingWorkHoursToAddToday = minutes / 60;
                System.debug('milliseconds: '+milliseconds);
                System.debug('seconds: '+seconds);
                System.debug('minutes: '+minutes);*/
                
                System.debug('RemainingWorkHoursToAddToday: '+RemainingWorkHoursToAddToday);
                if(RemainingWorkHoursToAddToday >=8)
                {
                    returnFollowUpTimeValue = System.now().addhours(8);
                    System.debug('returnFollowUpTimeValue: '+returnFollowUpTimeValue);
                }
                else
                {
                    Decimal RemainingWorkHoursToAddTomorrow = 8-RemainingWorkHoursToAddToday;
                    System.debug('RemainingWorkHoursToAddTomorrow: '+RemainingWorkHoursToAddTomorrow);
                    Integer hourTom = Integer.valueOf(RemainingWorkHoursToAddTomorrow);
                    System.debug('hourTom: '+hourTom);
                    //Integer minutesTom = getNumberAfterDecimal(RemainingWorkHoursToAddTomorrow);
                    String StringRemainingWorkHoursToAddTomorrow = String.valueOf(RemainingWorkHoursToAddTomorrow);
                    String StringDecimalValue = '.'+StringRemainingWorkHoursToAddTomorrow.substringAfter('.');
                    StringDecimalValue = StringDecimalValue.substring(0,7);
                    System.debug('StringDecimalValue: '+StringDecimalValue);
                    Integer minutesTom = Integer.ValueOf(Decimal.valueOf(StringDecimalValue)*60);
                    //Integer SecondsTom = getNumberAfterDecimal(minutesTom);
                    System.debug('minutesTom: '+minutesTom);
                    returnFollowUpTimeValue = workhourStart.addDays(1).addHours(hourTom).addMinutes(minutesTom);
                    System.debug('returnFollowUpTimeValue: '+returnFollowUpTimeValue);
                }
            }
        }
        catch(Exception e)
        {
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','UpdateLeadDetails_Controller Class','updateFollowUpTime Method',e.getMessage(),e.getStackTraceString(),null);
        }
        System.debug('returnFollowUpTimeValue: '+returnFollowUpTimeValue);
        return returnFollowUpTimeValue;
    }
    public PageReference googlePropertySearchDisableToggle()
    {
        shouldDisableGoogleProperty = propertyNotFoundInGoogle?true:false;
        return null;
    }
    Public class propertyWrapper
    {
        Public Decimal latitude;
        Public Decimal longitude;
        Public String city;
        Public String country;
        Public String searched_address;
        Public String property_name;
        Public String map_url;
        Public String lead_id;
        Public String pincode;
        Public String state;
        Public String locality;
    }
}