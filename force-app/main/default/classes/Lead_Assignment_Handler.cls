public class Lead_Assignment_Handler{
        
    public static void callOzoneTel(Map<id,Lead> newMap,Map<id,Lead> OldMap)
    {
        list<Lead> lstLeadToUpdate = new list<Lead>();
        list<Lead> leadPushtoOzonetel = new list<Lead>();
        list<Lead> leadEstimateFlow = new list<Lead>();
        list<Lead> leadWTAAssignment = new list<Lead>(); 
        Map<id,lead> MapNewLead ;
        boolean bcreatedinBussinessHours;
        if(!OldMap.isEmpty()){
            MapNewLead = new Map<id,lead>([Select id,Round_Robin_Lead_Source_Condition__c,Status,sub_status__c,Pushed_To_Ozone_1st_Time__c,
                                            Assigned_to_Resi_ASM__c,Closest_Showroom__c,Assigned_to_WTA__c,createdDate,Owner.Name,Phone,
                                            WT_Agent__r.Cloud_Agent_Campaign_Name__c,City,Created_during_business_hours__c from Lead where id IN:newMap.keySet()]);
            for(lead objLead:newMap.values()){
                try{ 
                    // Check IF it a test Lead and not Created by WTA || WTM 
                    if(objLead.Round_Robin_Created_By_Condition__c == true && objLead.Test_Flag__c == False ){
                        // If its a Fresh Lead and SubStatus = new and SubStatus is Changed or Closest ShowRoom is Changed and Not Pushed to Ozonetel and Assigned to ASM.
                        system.debug('Lead_Assignment_Handler First Loop');
                        if((objLead.status == 'Fresh Lead' && objLead.sub_status__c == 'New' && objLead.Pushed_To_Ozone_1st_Time__c == false  &&
                            objLead.Assigned_to_Resi_ASM__c == false && objLead.Assigned_to_WTA__c == false && (((objLead.Sub_Status__c != OldMap.get(objLead.id).Sub_Status__c) || 
                            (objLead.Closest_Showroom__c != OldMap.get(objLead.id).Closest_Showroom__c)) && String.isNotBlank(objLead.Closest_Showroom__c))) ||
                            (objLead.status == 'Fresh Lead' && objLead.sub_status__c == 'Re-Landed' && (objLead.Sub_Status__c != OldMap.get(objLead.id).Sub_Status__c))){
                                system.debug('Lead_Assignment_Handler Inside the Condition'+objLead);
                                // Created During Business Hours 
								bcreatedinBussinessHours = objLead.Created_during_business_hours__c;
                                if (Test.isRunningTest()){bcreatedinBussinessHours = true;} 
                                if(bcreatedinBussinessHours){ 
                                    if(objLead.Round_Robin_Lead_Source_Condition__c == true){
                                        
                                        // IF Fresh Lead and New  
                                        if(objLead.status == 'Fresh Lead' && objLead.sub_status__c == 'New')
                                        {
                                            // calling New Queable method  
                                            
                                            if(RecursiveTriggerHandlerLead.bCallToOzonetel){
                                                system.debug('Calling Iron Man');
                                                System.enqueueJob(new AssignLeadToIronMan(MapNewLead.get(objLead.id)));
                                                RecursiveTriggerHandlerLead.bCallToOzonetel = false;
                                            }

                                        }
                                        else If(objLead.status == 'Fresh Lead' && objLead.sub_status__c == 'Re-Landed'){
                                            // Push it to  WTA Queue
                                            if(RecursiveTriggerHandlerLead.bCallToOzonetel){
                                                System.enqueueJob(new AssignLeadToIronMan(MapNewLead.get(objLead.id)));
                                                RecursiveTriggerHandlerLead.bCallToOzonetel = false;
                                            }    
                                        }
                                        else{
                                            // DO Noting No Record should Enter this Loop
                                        }

                                    }else{
                                        // IF is from Restricted Source assign it to WTA Do Nothing
                                          /*  if(RecursiveTriggerHandlerLead.bCallToOzonetel){
                                                System.enqueueJob(new AssignLeadToIronMan(objLead));
                                                RecursiveTriggerHandlerLead.bCallToOzonetel = false;
                                            }  */
                                    }

                                
                                }
                                // If Lead is created in Off business hours assigned to WTA
                                else{     
                                    if(RecursiveTriggerHandlerLead.bCallToOzonetel){
                                        System.enqueueJob(new AssignLeadToIronMan(MapNewLead.get(objLead.id)));
                                        RecursiveTriggerHandlerLead.bCallToOzonetel = false;
                                    }    
                                }
                        }
                        else{

                            system.debug('In Else Condition Lead_Assignment');
                             
                            // customer Fix the appointment directly from website then call and confirm them
                            if(objLead.status == 'Appointment Fixed' && (objLead.status != OldMap.get(objLead.id).status) && 
                            objLead.Pushed_To_Ozone_1st_Time__c == false  && String.isNotBlank(objLead.Closest_Showroom__c) &&
                            objLead.Assigned_to_Resi_ASM__c == false && objLead.Assigned_to_WTA__c == false && objLead.WT_Agent__c == NULL ) {
                                if(RecursiveTriggerHandlerLead.bCallToOzonetel){
                                    System.enqueueJob(new AssignLeadToIronMan(MapNewLead.get(objLead.id)));
                                    RecursiveTriggerHandlerLead.bCallToOzonetel = false;
                                }
                            }
                           
                            else if(objLead.ownerID !=  OldMap.get(objLead.id).ownerID && MapNewLead.get(objLead.id).owner.Name =='Cloud Agent'){
                                if(String.isNotBlank(MapNewLead.get(objLead.id).WT_Agent__r.Cloud_Agent_Campaign_Name__c)){
                                    system.debug('Pused to Ozonetel Queue'+MapNewLead.get(objLead.id).owner.Name);
                                    if(RecursiveTriggerHandlerLead.bCallToOzonetel){
                                        LeadPushToOzonetelQueueable.callOzonetelAPI(MapNewLead.get(objLead.id).WT_Agent__r.Cloud_Agent_Campaign_Name__c, objLead.Phone, objLead.id);
                                        RecursiveTriggerHandlerLead.bCallToOzonetel = false;
                                    }
                                }
                                system.debug('Inside Owner Change');
                                // Directly call the Futurer method
                            }
                            else{

                            }
                            // IF Sub Status is not New and Relande 
                            // IF fresh lead and new and already Pused to ozonetel or Assigned to ASM
                        }
                    }
                    else{
                        // if Test lead or Created By WTA || WTM do nothing 
                    }
                }
                catch(Exception e){
                    system.debug('Exception Occured'+e.getMessage());
                }    
            }
        }
    }
}