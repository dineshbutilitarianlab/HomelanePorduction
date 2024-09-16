public class LuxeLeadAssignmentHandler {
    Public Static void  getLuxeShowroomUserDetails(List<Lead> lstOfLead,set<String> lstOfPincode){
        try{
             List<Log__c> listOfLogsToInsert = new List<Log__c>();
            if(!lstOfPincode.isEmpty()&& !lstOfLead.isEmpty()){
                String clstrBrand = GenericConstants.CLUSTER_BRAND_DOOWUP;
                Set<String> clusterSet = new Set<String>();
                Map<String,Territory__c> mapClustor_AssociatedTerritory = new Map<String,Territory__c>();
                list<Showroom_User__c> lstShowroomUser = new list<Showroom_User__c> ();
               
                list<Territory__c> lstTerritory= [Select id,Name,Cluster__c,City__c,Ironman__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,Pincode__c,Assignment__c,Cluster_Brand__c,Sales_Campaign__c,Inside_Sales_cluster__c
                                                  From Territory__c
                                                  Where Pincode__c IN:lstOfPincode and Cluster_Brand__c != :clstrBrand];
                if(!lstTerritory.isEmpty()){
                    for(Territory__c terri: lstTerritory){
                        clusterSet.add(terri.Cluster__c);
                        mapClustor_AssociatedTerritory.put(terri.Pincode__c,terri);
                    }
                    if(!clusterSet.isEmpty()){
                        dateTime todayDate = Date.Today();
                        System.debug('DayOfTheWeek: '+todayDate.format('EEEE'));
                        String showroomUserPCRole = GenericConstants.PRODUCT_CONSULTANT_ROLE;
                        String bronzeIMClass= GenericConstants.IM_Class_Bronze;
                        String todayDayInString = todayDate.format('EEEE');
                        lstShowroomUser = [Select Name,Daily_Assignment__c,Weekly_Off_Days__c,IsActive__c,Outskirts_Assignment__c,Outskirts_Monthly_Assignment__c,IM_Class__c,Role__c,Luxe_service_Showroom__c,
                                           (Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Monthly_Assignment__c
                                            from Territories__r) 
                                           From Showroom_User__c 
                                           where ID IN (Select IronMan__c 
                                                        from Territory__c 
                                                        where Cluster__C IN:clusterSet and Is_Active__c = True) 
                                           and Daily_Assignment__c != NULL and Weekly_Off_Days__c Excludes(:todayDayInString) and Role__c != :showroomUserPCRole and Luxe_service_Showroom__c = True and IM_Class__c !=:bronzeIMClass ];
                        system.debug('lstShowroomUser '+ lstShowroomUser);
                        
                        if(!lstShowroomUser.isEmpty()){
                            IronManLead_Assignment_Handler.getTerritoryChampionMapping(lstOfLead,  lstShowroomUser,   mapClustor_AssociatedTerritory); 
                            
                        }
                        else{
                            Boolean  pushToOzonetel = false;
                            set<String> citySet = new Set<String>();
                            for(lead ld: lstOfLead){
                                citySet.add(ld.city); 
                            }
                            system.debug('citySet' + citySet);
                            List<master__c> showroomListBasedOnCity = new List<master__c>();
                            Map<String,List<Showroom_user__c>> mapOfCityAndShowroomUser = new Map<String,List<Showroom_user__c>>();
                           // List<Showroom_User__c> lstShowroomUser = new List<Showroom_User__c>();
                            showroomListBasedOnCity =[select id,(select id,Role__c  from showroom_user__r where IM_Class__c != :bronzeIMClass and Role__c != :showroomUserPCRole and Weekly_Off_Days__c Excludes(:todayDayInString) 
                                                                 and Reached_Daily_Limit__c = false 
                                                                 and Reached_Monthly_Limit__c = false and IsActive__c = true ),
                                                                  Property_City__c from Master__c where Type__c = :GenericConstants.Showroom_Type and Property_City__c In: citySet and Luxe_service__c=true];
                            system.debug(' showroomListBasedOnCity ' +  showroomListBasedOnCity);
                            if(!showroomListBasedOnCity.isEmpty()){
                                for(master__c showroom : showroomListBasedOnCity){
                                    system.debug('showroom.showroom_user__r'+ showroom.showroom_user__r);
                                    lstShowroomUser.addAll(showroom.showroom_user__r);
                                }
                            }
                           
                            system.debug('lstShowroomUser '+ lstShowroomUser);
                            system.debug('mapClustor_AssociatedTerritory '+ mapClustor_AssociatedTerritory);
                            List<Showroom_user__c>    shTerriList = new List<Showroom_user__c>();
                            if(!lstShowroomUser.isEmpty()){
                                 shTerriList= [Select Name,Daily_Assignment__c,Weekly_Off_Days__c,IsActive__c,Role__c,
                                                                    (Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Monthly_Assignment__c
                                                                     from Territories__r where  Is_Active__c =true) 
                                                                    From Showroom_User__c where id IN:lstShowroomUser];
                            }else{
                                pushToOzoneTel = true;   
                             }
                            system.debug('shTerriList '+ shTerriList);
                            if(!shTerriList.isEmpty()){
                                IronManLead_Assignment_Handler.getTerritoryChampionMapping(lstOfLead,  shTerriList,  mapClustor_AssociatedTerritory);
                            }else{
                                pushToOzoneTel = true;
                            }
                            
                           
                            
                            if(pushToOzonetel){
                                List<Lead> listOfOzonetelpushedLeadsUpdate = new List<Lead>();
                                for(Lead ld : lstOfLead){
                                    Lead leadToUpdate = new Lead();
                                    leadToUpdate.id = ld.Id;
                                    leadToUpdate.Pushed_To_Ozonetel__c = true;
                                    leadToUpdate.Transfer_Status__c = 'IM-Inactive-Cluster';
                                    leadToUpdate.IM_Assignment_Stage__c = 'LC - No Iron Man available';
                                    //Owner and WTA Cloud Agent
                                    leadToUpdate.OwnerId = label.Cloud_Agent_Id;
                                    leadToUpdate.WT_Agent__c = label.Cloud_Agent_Id;
                                    listOfOzonetelpushedLeadsUpdate.add(leadToUpdate);
                                }
                                //Pushing to OzoneTel Queue
                                PushToOzoneTelAdditionalQueue objLPA = new PushToOzoneTelAdditionalQueue(lstOfLead,UserInfo.getSessionId());
                                ID jobID = System.enqueueJob(objLPA);
                                system.debug('-----jobID----'+jobID);
                                
                                if(!listOfOzonetelpushedLeadsUpdate.isEmpty()){
                                    //Update Lead Details
                                    update listOfOzonetelpushedLeadsUpdate;
                                }
                            }
                            if(!listOfLogsToInsert.isEmpty()){
                                //Insert log records.
                                insert listOfLogsToInsert;
                            }
                            
                        }
                    }  
                }
               else{
                        // Territory record is not present in pincode. Log the scenario and email will be sent through workflow on log record.
                        //First element is taken as the leads are getting created from Website and it will be only one at a time and not in bulk.
                        listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','IronManLead_Assignment_Handler Class','getIronManDetails method',' A Territory record is not present for this pincode: '+String.valueOf(lstOfPincode),lstOfLead[0].email,String.valueOf(lstOfPincode)));
                        //pushToOzoneTel = true;
                    }
                
            }else{
             
                //cannot handle bulk scenarios
                listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','IronManLead_Assignment_Handler Class','getIronManDetails method','Bulk Lead Scenario Cannot be handle as per the new IM assignment logic based on catergory',null,null));
             
            }
        }
        
        catch(exception e){
             system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            //Log the exceptions
            Logger.log('Exception','getShowroomUserDetails method','IronManLead_Assignment_Handler Class',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
}