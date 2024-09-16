global class OfflineAdsLeadIMShareBatch implements Database.Batchable<sObject>,Schedulable{
    Public Set<Id> setOfIds = new Set<Id>();
    // Constructor to excecute only set of records in the Batch.
    global OfflineAdsLeadIMShareBatch(Set<Id> setOfIds){
        this.setOfIds = setOfIds;
    }
    global OfflineAdsLeadIMShareBatch(){
    }
    global void execute(SchedulableContext SC) {
        database.executebatch(new OfflineAdsLeadIMShareBatch(),10);
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Id recTypeId = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Offline Ads').getRecordTypeId();
        
        Lead_Class_Scoring__c offlineConfig = [Select id, Offline_Ads_Included_Cities__c ,Offline_Assignment_Enable__c from Lead_Class_Scoring__c where RecordTypeId =:recTypeId   limit 1 ];
        system.debug('offlineConfig '+offlineConfig );
        List<String> setOfOfflineCities = new List<String>();
        if(offlineConfig !=null &&  offlineConfig.Offline_Assignment_Enable__c==true){
            setOfOfflineCities = offlineConfig.Offline_Ads_Included_Cities__c.Split(';');
        }else{
            system.debug('no assignment');
        }
        system.debug('setOfOfflineCities '+setOfOfflineCities);
        
        
        String queryString = UtilityClass.getQueryString('Lead');
        queryString += ' From Lead where id != Null and Test_Flag__c =False and LeadSource =\'Offline Ads\' and Assigned_to_Resi_ASM__c =false and Sales_Manager__c =null and Brand__c =\'HomeLane\'and  City  In:setOfOfflineCities'; 
        return Database.getQueryLocator(queryString);
        
        
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> listOfLeads) { 
        try{
            if(!listOfLeads.isEmpty()){
                Set<String> setOfCities = new Set<String>();
                
                
                for(Lead ld: listOfLeads){
                    setOfCities.add(ld.City);
                }
                if(!setOfCities.isEmpty()){
                    System.debug('Lead setOfCities: '+setOfCities);
                    // Map Of Showroom Users Id and the count of monthly Daily leads assigned.
                    Map<String,Integer> mapOfIMUserIdAndDailyLeadsCount = new Map<String,Integer>();
                     Map<String,Integer> mapOfIMUserIdAndMonthlyLeadsCount = new Map<String,Integer>();
                    // Map Of City and corresponding List of Showroom Users Ids.
                    Map<String,List<String>> mapOfCityAndListOfIMUserId = new Map<String,List<String>>();
                    List<Showroom_User__c> listOfShowroomUsers = new List<Showroom_User__c>();
                    dateTime todayDate = Date.Today();
                        System.debug('DayOfTheWeek: '+todayDate.format('EEEE'));
                        
                        String todayDayInString = todayDate.format('EEEE');
                        String showroomUserRole = GenericConstants.PRODUCT_CONSULTANT_ROLE;
                     
                        listOfShowroomUsers = [Select Id,Name,Monthly_Exception_Leads_Assigned__c,City__c,IsActive__c,Role__c,Daily_Assignment__c,Monthly_Assignment__c
                                               From Showroom_User__c 
                                               where ID IN (Select IronMan__c 
                                                            from Territory__c 
                                                            where City__C IN: setOfCities and Cluster_Brand__c='Homelane'and Is_Active__c = true  ) 
                                               and IsActive__c = True  and Role__c !=: showroomUserRole and  Weekly_Off_Days__c Excludes(:todayDayInString)];
                    
                    
                    if(!listOfShowroomUsers.isEmpty()){
                        for(Showroom_User__c showroomUser : listOfShowroomUsers)
                        {
                            // Construct mapOfIMUserIdAndDailyLeadsCount
                            if(showroomUser.Daily_Assignment__c != Null){
                                mapOfIMUserIdAndDailyLeadsCount.put(showroomUser.Id,Integer.valueOf(showroomUser.Daily_Assignment__c));
                            }
                            else{
                                mapOfIMUserIdAndDailyLeadsCount.put(showroomUser.Id,0);
                            }
                            // Construct mapOfCityAndListOfIMUserId
                            if(mapOfCityAndListOfIMUserId.containsKey(showroomUser.City__c)){
                                mapOfCityAndListOfIMUserId.get(showroomUser.City__c).add(showroomUser.Id);
                            }
                            else{
                                mapOfCityAndListOfIMUserId.put(showroomUser.City__c,new List<String>{showroomUser.Id});
                            }
                            
                            if(showroomUser.Monthly_Assignment__c != null){
                                mapOfIMUserIdAndMonthlyLeadsCount.put(showroomUser.Id,Integer.valueOf(showroomUser.Monthly_Assignment__c));
                            }
                            else{
                                mapOfIMUserIdAndMonthlyLeadsCount.put(showroomUser.Id,0);
                            }
                            
                        }
                        if(!mapOfCityAndListOfIMUserId.isEmpty() && !mapOfIMUserIdAndDailyLeadsCount.isEmpty() && !mapOfIMUserIdAndMonthlyLeadsCount.isEmpty()){
                            System.debug('mapOfCityAndListOfIMUserId: '+mapOfCityAndListOfIMUserId);
                            System.debug('mapOfIMUserIdAndDailyLeadsCount: '+mapOfIMUserIdAndDailyLeadsCount);
                            // Call fairShareLeadsToIM method to fairly share the list of leads with the IM based on the city.
                            fairShareLeadsToIM(listOfLeads,mapOfIMUserIdAndDailyLeadsCount,mapOfCityAndListOfIMUserId,mapOfIMUserIdAndMonthlyLeadsCount);
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
            Logger.log('Exception','OfflineAdsLeadIMShareBatch  Class','excecute Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }   
    
    global void finish(Database.BatchableContext bc){ 
        System.debug('finish method');   
    }
   
    
    
    // Method to fair share the Offline leads with the list of showroom users based on the lead city.
    Public static void fairShareLeadsToIM (List<Lead> listOfLeads,Map<String,Integer> mapOfIMUserIdAndDailyLeadsCount,Map<String,List<String>> mapOfCityAndListOfIMUserId,Map<String,Integer>mapOfIMUserIdAndMonthlyLeadsCount){
        try{
            //System.debug('mapOfCityWiseListOfIMUserIdAndLeadsCount: '+mapOfCityWiseListOfIMUserIdAndLeadsCount);
            System.debug('mapOfIMUserIdAndDailyLeadsCount: '+mapOfIMUserIdAndDailyLeadsCount);
            System.debug('mapOfCityAndListOfIMUserId: '+mapOfCityAndListOfIMUserId);
            System.debug('listOfLeads: '+listOfLeads);
            if(!listOfLeads.isEmpty() && !mapOfIMUserIdAndDailyLeadsCount.isEmpty() && !mapOfCityAndListOfIMUserId.isEmpty()){
                Map<Id,Lead> MapOfLeadsToUpdateIMDetails = new Map<Id,Lead>();
                Map<String,Showroom_User__c> MapOfShowroomUsersToUpdate = new Map<String,Showroom_User__c>();
                //Iterate over the list of leads.
                for(Lead ld : listOfLeads){
                   
                    
                    if(mapOfCityAndListOfIMUserId.containsKey(ld.city)){
                        String assignedIMUserId;
                        System.debug('ld.Name: '+ld.Name);
                        System.debug('ld.Id: '+ld.Id);
                        /*If mapOfCityAndListOfIMUserId contains the lead city then get the list of showroom users of that city and iterate over the 
                        list to see which user has less number of offline leads assigned  and assign the lead to that user. */
                        for(String IMUserID: mapOfCityAndListOfIMUserId.get(ld.city)){
                            //if(mapOfCityAndListOfIMUserId.containsKey(IMUserID)){
                            if(mapOfIMUserIdAndDailyLeadsCount.containsKey(IMUserID)){
                                //If the number of Offline leads assigned is zero then assign that user to the lead and go to next lead
                                if(mapOfIMUserIdAndDailyLeadsCount.get(IMUserID) == 0){
                                    assignedIMUserId = IMUserID;
                                    System.debug('assignedIMUserId: '+assignedIMUserId);
                                    System.debug('mapOfIMUserIdAndDailyLeadsCount.get(assignedIMUserId): '+mapOfIMUserIdAndDailyLeadsCount.get(assignedIMUserId));
                                    break;
                                }
                                //If the assignedIMUserId is blank (first element in the user) then assign that user to the lead
                                if(String.isBlank(assignedIMUserId)){
                                    assignedIMUserId = IMUserID;
                                    System.debug('assignedIMUserId: '+assignedIMUserId);
                                    System.debug('mapOfIMUserIdAndDailyLeadsCount.get(assignedIMUserId): '+mapOfIMUserIdAndDailyLeadsCount.get(assignedIMUserId));
                                }
                                //If the number of Daily leads assigned of current IM user id in the loop is less than that of the assigned user's then replace the assigned user.
                                else if(mapOfIMUserIdAndDailyLeadsCount.get(IMUserID) < mapOfIMUserIdAndDailyLeadsCount.get(assignedIMUserId)){
                                    assignedIMUserId = IMUserID;
                                    System.debug('assignedIMUserId: '+assignedIMUserId);
                                    System.debug('mapOfIMUserIdAndDailyLeadsCount.get(assignedIMUserId): '+mapOfIMUserIdAndDailyLeadsCount.get(assignedIMUserId));
                                }
                            }
                            else{
                                System.debug('mapOfIMUserIdAndDailyLeadsCount does not contain IMUserId as key. IMUserId: '+IMUserId);
                            }
                            
                            //}
                        }
                        if(!String.isBlank(assignedIMUserId)){
                            //Increment the counter of the user
                            mapOfIMUserIdAndDailyLeadsCount.put(assignedIMUserId,mapOfIMUserIdAndDailyLeadsCount.get(assignedIMUserId)+1);
                            mapOfIMUserIdAndMonthlyLeadsCount.put(assignedIMUserId,mapOfIMUserIdAndMonthlyLeadsCount.get(assignedIMUserId)+1);
                            Lead leadtoUpdate = new Lead();
                            leadtoUpdate.Id = ld.Id;
                            leadtoUpdate.Assigned_to_Resi_ASM__c = True;
                            leadtoUpdate.Sales_Manager__c = assignedIMUserId;
                           
                            // Add Owner and WTA to the lead
                            leadToUpdate.ownerId = System.Label.HomeLaneAPIUserId ;
                            leadToUpdate.WT_Agent__c = System.Label.HomeLaneAPIUserId;
                            
                            MapOfLeadsToUpdateIMDetails.put(leadtoUpdate.Id,leadtoUpdate);
                            
                            //Showroom user Monthly_Exception_Leads_Assigned__c field value update
                            Showroom_User__c showroomUserToUpdate = new Showroom_User__c();
                            showroomUserToUpdate.Id = assignedIMUserId;
                            showroomUserToUpdate.Daily_Assignment__c = mapOfIMUserIdAndDailyLeadsCount.get(assignedIMUserId);
                            showroomUserToUpdate.Monthly_Assignment__c=mapOfIMUserIdAndMonthlyLeadsCount.get(assignedIMUserId);
                            
                            
                            MapOfShowroomUsersToUpdate.put(showroomUserToUpdate.Id,showroomUserToUpdate);
                        }
                    }
                    else{
                        System.debug('mapOfIMUserIdAndDailyLeadsCount does not contain the lead city value as key. Lead city: '+ld.city);
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
                System.debug('Either listOfLeads or mapOfIMUserIdAndDailyLeadsCount or mapOfCityAndListOfIMUserId is Empty.');
            }
        }
        catch(Exception e){
            System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','ExceptionLeadsIMShareBatch Class','fairShareLeadsToIM Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }

    



}