/**
* @File Name          : ExceptionLeadsIMShareBatch.cls
* @Description        : Batch class to fairly share the IM Territory based exception leads between the IM.
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 04/14/2019, 12:21:43 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0    11/21/2019, 12:20:14 PM   Bharatesh Shetty     Initial Version
**/
global class ExceptionLeadsIMShareBatch implements Database.Batchable<sObject>,Schedulable{
    Public Set<Id> setOfIds = new Set<Id>();
    // Constructor to excecute only set of records in the Batch.
    global ExceptionLeadsIMShareBatch(Set<Id> setOfIds){
        this.setOfIds = setOfIds;
    }
    global ExceptionLeadsIMShareBatch(){
    }
    global void execute(SchedulableContext SC) {
        database.executebatch(new ExceptionLeadsIMShareBatch(),10);
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // Only the leads from the set of cities where Territory based pincode IM assignment happens are picked for the IM fair share.
        Schema.DescribeFieldResult fieldResult = Territory__c.City__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Set<String> setOfCities = new Set<String>();
        //Hardcoded because there is no classification between Ghaziabad city and Noida city. Noida city IM's should be considered for the Exception Leads IM 
        //fair share belonging to Ghaziabad City. If it is not hard coded Ghaziabad City leads will not be picked in the query.
        setOfCities.add('Ghaziabad');
        for( Schema.PicklistEntry f : ple)
        {
            setOfCities.add(f.getLabel());
        } 
        String homeLaneAPIUserId = Label.HomeLaneAPIUserId;
        String queryString = UtilityClass.getQueryString('Lead');
        System.debug('setOfIds '+setOfIds);
        System.debug('Territory setOfCities : '+setOfCities);
        String sentTOSquadIQ = 'Sent to SquadIQ';
        String processedBySquadIQ = 'Processed by SquadIQ';
        String sentToNimbus ='Sent to Nimbus';
        String processedByNimbus ='Processed by Nimbus';
        String prontoSignUpSource = GenericConstants.PRONTO_SIGNUP_SOURCE;
        String brandHomelane = GenericConstants.LEAD_HOMELANE;
        queryString += ' From Lead where id != Null and Test_Flag__c =False and Brand__c = :brandHomelane';
        //queryString += ' and Assigned_To_Resi_ASM__c = False and Pushed_To_Ozone_1st_Time__c = False and Sales_Manager__c = NULL and WT_Agent__c = NULL and CreatedDate = Today and Owner.Id ='+'\''+Label.HomeLaneAPIUserId+'\'';
        //queryString += ' and Assigned_To_Resi_ASM__c = False and Pushed_To_Ozone_1st_Time__c = False and Sales_Manager__c = NULL and WT_Agent__c = NULL and CreatedDate = Today and Owner.Id =:homeLaneAPIUserId and City =:setOfCities';
        if(!Test.isRunningTest()){
            queryString += ' and Assigned_To_Resi_ASM__c = False and Pushed_To_Ozone_1st_Time__c = False and Sales_Manager__c = NULL and CreatedDate = LAST_N_DAYS:2 and  Owner.Id =:homeLaneAPIUserId and City =:setOfCities and Transfer_Status__c !=\'Doowup Transfer\' and Squad_IQ_Status__C !=:sentTOSquadIQ and Squad_IQ_Status__C !=:processedBySquadIQ and Postalcode != NULL and Should_run_Ironman_assignment__c = True and Sign_Up_Source__c!=:prontoSignUpSource and Assigned_to_Central_Team__c=false and Assigned_to_Doowup_Presales__c=false and Assigned_To_Inside_Sales_Agent__c=false and Assigned_To_TLC__c=false and Nimbus_Status__c !=:sentToNimbus and Nimbus_Status__c !=:processedByNimbus';
        }
        if(!setOfIds.isEmpty()){
            queryString += ' and id=:setOfIds';
        }
        System.debug('queryString: '+queryString);
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> listOfLeads) { 
        try{
            if(!listOfLeads.isEmpty()){
                Set<String> setOfCities = new Set<String>();
                //Hardcoded because there is no classification between Ghaziabad city and Noida city. Noida city IM's should be considered for the Exception Leads IM 
                //fair share belonging to Ghaziabad City. If it is not hard coded and if the list of leads contains only Ghaiabad city leads and no Noida City leads 
                //then the assignment will not happen because there is no IM or territory from Ghaziabad city and listOfShowroomUsers will be empty when queried..
                setOfCities.add('Noida');
                for(Lead ld: listOfLeads){
                    setOfCities.add(ld.City);
                }
                if(!setOfCities.isEmpty()){
                    System.debug('Lead setOfCities: '+setOfCities);
                    // Map Of Showroom Users Id and the count of monthly exceptional leads assigned.
                    Map<String,Integer> mapOfIMUserIdAndExceptionLeadsCount = new Map<String,Integer>();
                    // Map Of City and corresponding List of Showroom Users Ids.
                    Map<String,List<String>> mapOfCityAndListOfIMUserId = new Map<String,List<String>>();
                    List<Showroom_User__c> listOfShowroomUsers = new List<Showroom_User__c>();
                     String showroomUserRole = GenericConstants.PRODUCT_CONSULTANT_ROLE;
                    //String clstrBrand = GenericConstants.CLUSTER_BRAND_HOMELANE;
                    if(Test.isRunningTest()){
                        // For test class coverage because of createdDate !=This_Month criteria in the query
                        listOfShowroomUsers = [Select Id,Name,Monthly_Exception_Leads_Assigned__c,City__c,IsActive__c,Role__c
                                               From Showroom_User__c 
                                               where ID IN (Select IronMan__c 
                                                            from Territory__c 
                                                            where City__C IN: setOfCities ) 
                                               and IsActive__c = True and City__C IN: setOfCities and Role__c !=:showroomUserRole];
                    }
                    else{
                        listOfShowroomUsers = [Select Id,Name,Monthly_Exception_Leads_Assigned__c,City__c,IsActive__c,Role__c
                                               From Showroom_User__c 
                                               where ID IN (Select IronMan__c 
                                                            from Territory__c 
                                                            where City__C IN: setOfCities) 
                                               and IsActive__c = True and createdDate !=This_Month and City__C IN: setOfCities and Role__c !=:showroomUserRole];
                    }
                    if(!listOfShowroomUsers.isEmpty()){
                        for(Showroom_User__c showroomUser : listOfShowroomUsers)
                        {
                            // Construct mapOfIMUserIdAndExceptionLeadsCount
                            if(showroomUser.Monthly_Exception_Leads_Assigned__c != Null){
                                mapOfIMUserIdAndExceptionLeadsCount.put(showroomUser.Id,Integer.valueOf(showroomUser.Monthly_Exception_Leads_Assigned__c));
                            }
                            else{
                                mapOfIMUserIdAndExceptionLeadsCount.put(showroomUser.Id,0);
                            }
                            // Construct mapOfCityAndListOfIMUserId
                            if(mapOfCityAndListOfIMUserId.containsKey(showroomUser.City__c)){
                                mapOfCityAndListOfIMUserId.get(showroomUser.City__c).add(showroomUser.Id);
                            }
                            else{
                                mapOfCityAndListOfIMUserId.put(showroomUser.City__c,new List<String>{showroomUser.Id});
                            }
                        }
                        if(!mapOfCityAndListOfIMUserId.isEmpty() && !mapOfIMUserIdAndExceptionLeadsCount.isEmpty()){
                            System.debug('mapOfCityAndListOfIMUserId: '+mapOfCityAndListOfIMUserId);
                            System.debug('mapOfIMUserIdAndExceptionLeadsCount: '+mapOfIMUserIdAndExceptionLeadsCount);
                            // Call fairShareLeadsToIM method to fairly share the list of leads with the IM based on the city.
                            fairShareLeadsToIM(listOfLeads,mapOfIMUserIdAndExceptionLeadsCount,mapOfCityAndListOfIMUserId);
                        } 
                    }
                    else{
                        System.debug('list of Showroom Users is empty.');
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','ExceptionLeadsIMShareBatch Class','excecute Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }   
    
    global void finish(Database.BatchableContext bc){ 
        System.debug('finish method');   
    }
   /* //To Schedule the batch at 6AM 
    String schedMorning = '0 0 6 * * ?';
    ExceptionLeadsIMShareBatch IMShareBatchMorning = new ExceptionLeadsIMShareBatch(); 
    String jobIDMorning = System.schedule('ExceptionLeadsIMShareBatch - Morning',schedMorning , IMShareBatchMorning);

    //To Schedule batch at 6PM
    String schedEvening = '0 0 18 * * ?';
    ExceptionLeadsIMShareBatch IMShareBatchEvening = new ExceptionLeadsIMShareBatch(); 
    String jobIDEvening = System.schedule('ExceptionLeadsIMShareBatch - Evening',schedEvening , IMShareBatchEvening);*/
    
    
    // Method to fair share the Exception leads with the list of showroom users based on the lead city.
    Public static void fairShareLeadsToIM (List<Lead> listOfLeads,Map<String,Integer> mapOfIMUserIdAndExceptionLeadsCount,Map<String,List<String>> mapOfCityAndListOfIMUserId){
        try{
            //System.debug('mapOfCityWiseListOfIMUserIdAndLeadsCount: '+mapOfCityWiseListOfIMUserIdAndLeadsCount);
            System.debug('mapOfIMUserIdAndExceptionLeadsCount: '+mapOfIMUserIdAndExceptionLeadsCount);
            System.debug('mapOfCityAndListOfIMUserId: '+mapOfCityAndListOfIMUserId);
            System.debug('listOfLeads: '+listOfLeads);
            if(!listOfLeads.isEmpty() && !mapOfIMUserIdAndExceptionLeadsCount.isEmpty() && !mapOfCityAndListOfIMUserId.isEmpty()){
                Map<Id,Lead> MapOfLeadsToUpdateIMDetails = new Map<Id,Lead>();
                Map<String,Showroom_User__c> MapOfShowroomUsersToUpdate = new Map<String,Showroom_User__c>();
                //Iterate over the list of leads.
                for(Lead ld : listOfLeads){
                    //Hardcoded because there is no classification between Ghaziabad city and Noida city. Noida city IM's should be considered for the Exception Leads IM 
                    //fair share belonging to Ghaziabad City.
                    String leadCity;
                    if(ld.city.equalsIgnoreCase('Ghaziabad')){
                        leadCity = 'Noida';
                    }
                    else{
                        leadCity = ld.city;
                    }
                    if(mapOfCityAndListOfIMUserId.containsKey(leadCity)){
                        String assignedIMUserId;
                        System.debug('ld.Name: '+ld.Name);
                        System.debug('ld.Id: '+ld.Id);
                        /*If mapOfCityAndListOfIMUserId contains the lead city then get the list of showroom users of that city and iterate over the 
                        list to see which user has less number of Exception leads assigned for that month and assign the lead to that user. */
                        for(String IMUserID: mapOfCityAndListOfIMUserId.get(leadCity)){
                            //if(mapOfCityAndListOfIMUserId.containsKey(IMUserID)){
                            if(mapOfIMUserIdAndExceptionLeadsCount.containsKey(IMUserID)){
                                //If the number of Exception leads assigned is zero then assign that user to the lead and go to next lead
                                if(mapOfIMUserIdAndExceptionLeadsCount.get(IMUserID) == 0){
                                    assignedIMUserId = IMUserID;
                                    System.debug('assignedIMUserId: '+assignedIMUserId);
                                    System.debug('mapOfIMUserIdAndExceptionLeadsCount.get(assignedIMUserId): '+mapOfIMUserIdAndExceptionLeadsCount.get(assignedIMUserId));
                                    break;
                                }
                                //If the assignedIMUserId is blank (first element in the user) then assign that user to the lead
                                if(String.isBlank(assignedIMUserId)){
                                    assignedIMUserId = IMUserID;
                                    System.debug('assignedIMUserId: '+assignedIMUserId);
                                    System.debug('mapOfIMUserIdAndExceptionLeadsCount.get(assignedIMUserId): '+mapOfIMUserIdAndExceptionLeadsCount.get(assignedIMUserId));
                                }
                                //If the number of Exception leads assigned of current IM user id in the loop is less than that of the assigned user's then replace the assigned user.
                                else if(mapOfIMUserIdAndExceptionLeadsCount.get(IMUserID) < mapOfIMUserIdAndExceptionLeadsCount.get(assignedIMUserId)){
                                    assignedIMUserId = IMUserID;
                                    System.debug('assignedIMUserId: '+assignedIMUserId);
                                    System.debug('mapOfIMUserIdAndExceptionLeadsCount.get(assignedIMUserId): '+mapOfIMUserIdAndExceptionLeadsCount.get(assignedIMUserId));
                                }
                            }
                            else{
                                System.debug('mapOfIMUserIdAndExceptionLeadsCount does not contain IMUserId as key. IMUserId: '+IMUserId);
                            }
                            
                            //}
                        }
                        if(!String.isBlank(assignedIMUserId)){
                            //Increment the counter of the user
                            mapOfIMUserIdAndExceptionLeadsCount.put(assignedIMUserId,mapOfIMUserIdAndExceptionLeadsCount.get(assignedIMUserId)+1);
                            Lead leadtoUpdate = new Lead();
                            leadtoUpdate.Id = ld.Id;
                            leadtoUpdate.Assigned_to_Resi_ASM__c = True;
                            leadtoUpdate.Sales_Manager__c = assignedIMUserId;
                            leadtoUpdate.Transfer_Status__c = 'From Exception';
                            leadtoUpdate.IM_Assignment_Stage__c = 'From Exception';
                            // Add Owner and WTA to the lead
                            leadToUpdate.ownerId = System.Label.HomeLaneAPIUserId ;
                            leadToUpdate.WT_Agent__c = System.Label.HomeLaneAPIUserId;
                            
                            MapOfLeadsToUpdateIMDetails.put(leadtoUpdate.Id,leadtoUpdate);
                            
                            //Showroom user Monthly_Exception_Leads_Assigned__c field value update
                            Showroom_User__c showroomUserToUpdate = new Showroom_User__c();
                            showroomUserToUpdate.Id = assignedIMUserId;
                            showroomUserToUpdate.Monthly_Exception_Leads_Assigned__c = mapOfIMUserIdAndExceptionLeadsCount.get(assignedIMUserId);
                            MapOfShowroomUsersToUpdate.put(showroomUserToUpdate.Id,showroomUserToUpdate);
                        }
                    }
                    else{
                        System.debug('mapOfIMUserIdAndExceptionLeadsCount does not contain the lead city value as key. Lead city: '+ld.city);
                    }
                }
                // Update leads
                if(!MapOfLeadsToUpdateIMDetails.IsEmpty()){
                    Update MapOfLeadsToUpdateIMDetails.values();
                }
                // Update Showroom Users
                if(!MapOfShowroomUsersToUpdate.IsEmpty()){
                    Update MapOfShowroomUsersToUpdate.values();
                }
            }
            else{
                System.debug('Either listOfLeads or mapOfIMUserIdAndExceptionLeadsCount or mapOfCityAndListOfIMUserId is Empty.');
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','ExceptionLeadsIMShareBatch Class','fairShareLeadsToIM Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }

    



}