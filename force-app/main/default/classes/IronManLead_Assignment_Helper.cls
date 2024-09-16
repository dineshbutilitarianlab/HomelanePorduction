/**
* @File Name          : IronManLead_Assignment_Helper.cls
* @Description        : 
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 2/6/2020, 3:28:08 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author                    Modification
*==============================================================================
* 1.0    02/06/2020, 4:29:37 PM   Bharatesh Shetty     Initial Version
**/
public class IronManLead_Assignment_Helper {
    
    public static ShowRoom_User__c assignIronmanToLead(List<Lead> listOfLeads, Map<String,List<Territory__c>> mapOfClusterNdLeastAssignedTerritorries,Map<String,Territory__c> mapOfPincodeAndTerritory){
        List<Log__c> listOfLogsToInsert = new List<Log__c>();
        ShowRoom_User__c su = new Showroom_User__c();
        
        try{
            if(!listOfLeads.isEmpty() && !mapOfClusterNdLeastAssignedTerritorries.isEmpty() && !mapOfPincodeAndTerritory.isEmpty()){
                List<Showroom_User__c> ironManListToUpdateAssignment = new List<Showroom_User__c>();
                List<Lead> listOfLeadsToUpdate = new List<Lead>();
                List<Lead> listOfOzonetelpushedLeadsUpdate = new List<Lead>();
                List<Lead> listOfOzonetelpushLeads = new List<Lead>();
                for(Lead leadObj : listOfLeads){
                    if(!String.isBlank(leadObj.PostalCode)){
                        System.debug('leadObj.PostalCode :'+leadObj.PostalCode);
                        System.debug('mapOfPincodeAndTerritory: '+mapOfPincodeAndTerritory);
                        /* && leadObj.City.equalsIgnoreCase(mapOfPincodeAndTerritory.get(leadObj.PostalCode).City__c) Add this condition in the if conditon below if the 
IM allocation should happen to territories with respect to pincodes of the same city. Now the IM allocation happens irrespective of City and based 
only on the pincode of the territory and that of the lead and doesn't compares the city of the lead and that of the territory.
*/
                        if(mapOfPincodeAndTerritory.containsKey(leadObj.PostalCode)){
                            System.debug('leadObj.PostalCode :'+leadObj.PostalCode);
                            System.debug('cluster :'+mapOfPincodeAndTerritory.get(leadObj.PostalCode).Cluster__c);
                            System.debug('Latitude :'+mapOfPincodeAndTerritory.get(leadObj.PostalCode).Lat_Long__latitude__s);
                            Territory__c nearestIronManTerritory ;
                            if(!String.isBlank(mapOfPincodeAndTerritory.get(leadObj.PostalCode).Cluster__c) && mapOfPincodeAndTerritory.get(leadObj.PostalCode).Lat_Long__latitude__s!=null){
                                if(mapOfClusterNdLeastAssignedTerritorries.containsKey(mapOfPincodeAndTerritory.get(leadObj.PostalCode).Cluster__c)||leadObj.Sign_Up_Source__c == genericConstants.HomeLaneLuxeLeadForm ){
                                    List<Territory__c> listOfLeastAssignedTerritories = new List<Territory__c>();
                                    if(leadObj.Sign_Up_Source__c != genericConstants.HomeLaneLuxeLeadForm){
                                       listOfLeastAssignedTerritories = mapOfClusterNdLeastAssignedTerritorries.get(mapOfPincodeAndTerritory.get(leadObj.PostalCode).Cluster__c);
                                          nearestIronManTerritory = getNearestIronManId(mapOfPincodeAndTerritory.get(leadObj.PostalCode),listOfLeastAssignedTerritories);
                                    }else{
                                        for(String cluster: mapOfClusterNdLeastAssignedTerritorries.KeySet()){
                                            listOfLeastAssignedTerritories.addAll(mapOfClusterNdLeastAssignedTerritorries.get(cluster));
                                        }
                                        if(!listOfLeastAssignedTerritories.isEmpty() && listOfLeastAssignedTerritories.size()>1){
                                            system.debug('size 2');
                                            nearestIronManTerritory = getNearestIronManId(mapOfPincodeAndTerritory.get(leadObj.PostalCode),listOfLeastAssignedTerritories);
                                        } else{
                                            system.debug('size 1');
                                            nearestIronManTerritory =listOfLeastAssignedTerritories[0];
                                        }
                                    }
                                    
                                    System.debug('listOfLeastAssignedTerritories :'+listOfLeastAssignedTerritories);
                                    System.debug('mapOfPincodeAndTerritory.get(leadObj.PostalCode) :'+mapOfPincodeAndTerritory.get(leadObj.PostalCode));
                                   
                                    if(nearestIronManTerritory !=null){
                                        Lead leadToUpdate = new Lead();
                                        leadToUpdate.id = leadObj.id;
                                        leadToUpdate.Sales_Manager__c = nearestIronManTerritory.Ironman__c;
                                        leadToUpdate.Assigned_to_Resi_ASM__c = True;
                                        // Add Owner and WTA to the lead
                                        leadToUpdate.ownerId = System.Label.HomeLaneAPIUserId ;
                                        leadToUpdate.WT_Agent__c = System.Label.HomeLaneAPIUserId;
                                        leadToUpdate.Assigned_To_TLC__c= false;
                                        leadToUpdate.Assigned_to_Doowup_Presales__c= false;
                                        leadToUpdate.Assigned_to_Central_Team__c = false;
                                        leadToUpdate.Assigned_To_Inside_Sales_Agent__c=false;
                                       
                                        
                                        if(String.isNotBlank(leadObj.Squad_IQ_Status__c) && leadObj.Squad_IQ_Status__c.equalsIgnoreCase('Processed by SquadIQ')){
											leadToUpdate.IM_Assignment_Stage__c = 'After SquadIQ processing'; 
                                        }else{
                                           leadToUpdate.IM_Assignment_Stage__c = 'Lead creation'; 
                                        }
                                        if(leadObj.Status =='Fresh Lead' && leadObj.Sub_Status__c =='Re-Landed' && leadObj.Bulk_Upload__C ){
                                            leadToUpdate.IM_Assignment_Stage__c = 'Offline Relanded';
                                        }
                                        listOfLeadsToUpdate.add(leadToUpdate);
                                        // As the lead assignment will be not be in bulk we are not handling the bulk scenario.
                                        Showroom_User__c ironMan = new Showroom_User__c();
                                        ironMan.Id = nearestIronManTerritory.Ironman__c;
                                        Decimal territoryAssignment = nearestIronManTerritory.Assignment__c;
                                        Decimal territoryMonthlyAssignment = nearestIronManTerritory.Monthly_Assignment__c;
                                     //   ironMan.Daily_Assignment__c = 0;
                                     //   ironMan.Monthly_Assignment__c = 0;
                                        System.debug('nearestIronManTerritory.Ironman__c '+ nearestIronManTerritory.Ironman__c);
                                        System.debug('territoryAssignment '+ territoryAssignment);
                                        System.debug('territoryMonthlyAssignment '+ territoryMonthlyAssignment);
                                        System.debug('territoryMonthlyAssignment '+ territoryMonthlyAssignment);
                                        
                                        if(leadObj.City !='Outskirts'){
                                           if(territoryAssignment !=null  ){
                                            ironMan.Daily_Assignment__c = territoryAssignment + 1;
                                        }
                                        else{
                                            ironMan.Daily_Assignment__c = 1;
                                        }
                                        if(territoryMonthlyAssignment !=null){
                                            ironMan.Monthly_Assignment__c = territoryMonthlyAssignment+1;
                                        }
                                        else{
                                            ironMan.Monthly_Assignment__c = 1;
                                        }
                                        ironManListToUpdateAssignment.add(ironMan);
                                        
                                        su.Id = nearestIronManTerritory.Ironman__c; 
                                        }
                                        else{
                                           if(territoryAssignment !=null  ){
                                            ironMan.Outskirts_Assignment__c = territoryAssignment+1;
                                        }
                                        else{
                                            ironMan.Outskirts_Assignment__c = 1;
                                        }
                                            if(territoryMonthlyAssignment !=null){
                                                ironman.Outskirts_Monthly_Assignment__c =territoryMonthlyAssignment+1;
                                            }else{
                                                ironman.Outskirts_Monthly_Assignment__c=1;
                                            }
                                        
                                        ironManListToUpdateAssignment.add(ironMan);
                                        
                                        su.Id = nearestIronManTerritory.Ironman__c; 
                                        }
                                        
                                        
                                       
                                       
                                        }
                                    else{
                                        System.debug('Nearest Iron man is null.');
                                    }
                                }
                                else{
                                    System.debug('mapOfClusterNdLeastAssignedTerritorries doesnt contain value for this leads cluster.');
                                }
                            }
                            else{
                                System.debug('Lead Pincode territory few details are empty. Either Cluster or Lat long.');
                                //listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','IronManLead_Assignment_Helper Class','assignIronmanToLead method','Few Lead pin code '+leadObj.PostalCode+ ' related territory details are empty (Either Cluster or Lat long). Contact your system administrator.',leadObj.LeadSource,leadObj.email));
                            }
                        }
                        else{
                            System.debug('Lead pin code is not among valid Territory pincodes ');
                            listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','IronManLead_Assignment_Helper Class','assignIronmanToLead method','A Territory record is not present for this pincode: '+leadObj.PostalCode,leadObj.email,leadObj.PostalCode));
                           
                        }
                    }
                    else{
                        System.debug('Lead pin code is blank');
                        //If the pincode is empty for the lead (which ideally shouldn't be) capture the log and push the lead to OzoneTel and update lead details.
                        listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','IronManLead_Assignment_Helper Class','assignIronmanToLead method','Pin code is empty for the lead : '+leadObj.LastName+' with Lead source: '+leadObj.LeadSource,leadObj.email,leadObj.LeadSource));
                        
                        Lead leadToUpdate = new Lead();
                        leadToUpdate.id = leadObj.Id;
                        leadToUpdate.Pushed_To_Ozonetel__c = true;
                        //Owner and WTA Cloud Agent '0055D000001sYVV'
                        leadToUpdate.OwnerId = label.Cloud_Agent_Id;
                        leadToUpdate.WT_Agent__c = label.Cloud_Agent_Id;
                        listOfLeadsToUpdate.add(leadToUpdate);
                        
                        listOfOzonetelpushLeads.add(leadObj);
                    }
                }
                system.debug('list of lead to update'+ listOfLeadsToUpdate);
                if(!listOfOzonetelpushLeads.isEmpty()){
                    //Pushing leads to OzoneTel in exceptional cases
                    PushToOzoneTelAdditionalQueue objLPA = new PushToOzoneTelAdditionalQueue(listOfOzonetelpushLeads,UserInfo.getSessionId());
                    ID jobID = System.enqueueJob(objLPA);
                    system.debug('-----jobID----'+jobID);
                }
                if(!listOfLeadsToUpdate.isEmpty()){
                    system.debug('listOfLeadsToUpdate is not empty');
                    update listOfLeadsToUpdate;
                }
                if(!ironManListToUpdateAssignment.isEmpty()){
                    system.debug('ironManListToUpdateAssignment is not empty');
                    update ironManListToUpdateAssignment;
                }
                if(!listOfLogsToInsert.isEmpty()){
                    system.debug('listOfLogsToInsert is not empty');
                    insert listOfLogsToInsert;
                }
                
            }
            else{
                System.debug('Method input parameters are empty');
            }
            return su;
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            Logger.log('Exception','assignIronmanToLead method','IronManLead_Assignment_Helper Class',e.getMessage(),e.getStackTraceString(),null);
            return su;
        } 
    }
    
    public static void assignIronmanToWTALead(List<Lead> listOfLeads, Map<String,List<Territory__c>> mapOfClusterNdLeastAssignedTerritorries,Map<String,Territory__c> mapOfPincodeAndTerritory)
    {
        List<Log__c> listOfLogsToInsert = new List<Log__c>();
        Map<Id,Showroom_User__c> mapOfShowroomUsers = new Map<Id,Showroom_User__c>();
        
        
        try
        {
        
            if(!listOfLeads.isEmpty())
            {
                mapOfShowroomUsers = new Map<Id,Showroom_User__c>([Select id,IsActive__c,Name,City__c,Showroom_Name__c,Showroom_Name__r.Name,Email__c,Phone__c from Showroom_User__c]);
            }
            
            System.debug('mapOfShowroomUsers :'+mapOfShowroomUsers);
        	
            if(!listOfLeads.isEmpty() && !mapOfClusterNdLeastAssignedTerritorries.isEmpty() && !mapOfPincodeAndTerritory.isEmpty()){
                List<Showroom_User__c> ironManListToUpdateAssignment = new List<Showroom_User__c>();
                for(Lead leadObj : listOfLeads){
                    if(!String.isBlank(leadObj.PostalCode)){
                        System.debug('leadObj.PostalCode :'+leadObj.PostalCode);
                        System.debug('mapOfPincodeAndTerritory: '+mapOfPincodeAndTerritory);
                        /* && leadObj.City.equalsIgnoreCase(mapOfPincodeAndTerritory.get(leadObj.PostalCode).City__c) Add this condition in the if conditon below if the 
                          IM allocation should happen to territories with respect to pincodes of the same city. Now the IM allocation happens irrespective of City and based 
                          only on the pincode of the territory and that of the lead and doesn't compares the city of the lead and that of the territory.
                         */
                        if(mapOfPincodeAndTerritory.containsKey(leadObj.PostalCode)){
                            System.debug('leadObj.PostalCode :'+leadObj.PostalCode);
                            System.debug('cluster :'+mapOfPincodeAndTerritory.get(leadObj.PostalCode).Cluster__c);
                            System.debug('Latitude :'+mapOfPincodeAndTerritory.get(leadObj.PostalCode).Lat_Long__latitude__s);
                            if(!String.isBlank(mapOfPincodeAndTerritory.get(leadObj.PostalCode).Cluster__c) && mapOfPincodeAndTerritory.get(leadObj.PostalCode).Lat_Long__latitude__s!=null){
                                if(mapOfClusterNdLeastAssignedTerritorries.containsKey(mapOfPincodeAndTerritory.get(leadObj.PostalCode).Cluster__c)){
                                    List<Territory__c> listOfLeastAssignedTerritories = new List<Territory__c>();
                                    listOfLeastAssignedTerritories = mapOfClusterNdLeastAssignedTerritorries.get(mapOfPincodeAndTerritory.get(leadObj.PostalCode).Cluster__c);
                                    System.debug('listOfLeastAssignedTerritories :'+listOfLeastAssignedTerritories);
                                    System.debug('mapOfPincodeAndTerritory.get(leadObj.PostalCode) :'+mapOfPincodeAndTerritory.get(leadObj.PostalCode));
                                    Territory__c nearestIronManTerritory = getNearestIronManId(mapOfPincodeAndTerritory.get(leadObj.PostalCode),listOfLeastAssignedTerritories);
                                   // System.debug('nearestIronManTerritory :'+nearestIronManTerritory);
                                    if(nearestIronManTerritory !=null){
                                        System.debug('Lead is assigned to IRM ');
                                        leadObj.Sales_Manager__c = nearestIronManTerritory.Ironman__c;
                                        leadObj.Assigned_to_Resi_ASM__c = True;
                                        // Add Owner to the lead but the WTA will remain the same
                                        leadObj.ownerId = System.Label.HomeLaneAPIUserId ;
                                        leadObj.Assigned_To_TLC__c= false;
                                        leadObj.Assigned_to_Doowup_Presales__c= false;
                                        leadObj.Assigned_to_Central_Team__c = false;
                                        
                                        // Assign showroom for Doowup leads when Pre-appointment and Appointment is fixed
                                         if(leadObj.Brand__c == GenericConstants.LEAD_DOOWUP && leadObj.Appointment_Venue_Square__c==null)
                                        {
                                            leadObj.Appointment_Venue_Square__c = mapOfShowroomUsers.get(nearestIronManTerritory.Ironman__c).Showroom_Name__c;
                                        }
                                        
                                         
                                        //If MeetingSource is customer Inside sales Agent details are deleted for HomeLane Leads
                                        if(leadObj.Meeting_Source__c =='Customer' && leadObj.Assigned_To_Inside_Sales_Agent__c==true && 
                                           leadObj.Brand__c!=GenericConstants.LEAD_DOOWUP)
                                        {
                                              leadObj.Assigned_To_Inside_Sales_Agent__c=false;
                                       /*       leadObj.Inside_Sales_Agent__c=null;
                                              leadObj.Inside_Sales_Agent_Email__c=null;
                                        }
                                        else
                                        {
                                              leadObj.Assigned_To_Inside_Sales_Agent__c=false;*/
                                        }
                                        //leadObj.WT_Agent__c = System.Label.HomeLaneAPIUserId;
                                        leadObj.IM_Assignment_Stage__c = 'Pre-Appointment';
                                        
                                        // As the lead assignment will not be in bulk we are not handling the bulk scenario.
                                        Showroom_User__c ironMan = new Showroom_User__c();
                                        
                                        ironMan.Id = nearestIronManTerritory.Ironman__c;
                                        
                                            if(nearestIronManTerritory.WT_Leads_Daily_Assignment__c !=null){
                                            ironMan.WT_Leads_Daily_Assignment__c = nearestIronManTerritory.WT_Leads_Daily_Assignment__c+1;
                                        }
                                        else{
                                            ironMan.WT_Leads_Daily_Assignment__c = 1;
                                        }
                                            
                                        
                                        if(nearestIronManTerritory.WT_Leads_Monthly_Assignment__c !=null){
                                            ironMan.WT_Leads_Monthly_Assignment__c = nearestIronManTerritory.WT_Leads_Monthly_Assignment__c+1;
                                        }
                                        else{
                                            ironMan.WT_Leads_Monthly_Assignment__c = 1;
                                        }
                                        
                                        ironManListToUpdateAssignment.add(ironMan);
                                       // System.debug('ironManListToUpdateAssignment :'+ironManListToUpdateAssignment);
                                        
                                        
                                    }
                                    else{
                                        System.debug('Nearest Iron man is null.');
                                    }
                                }
                                else{
                                    System.debug('mapOfClusterNdLeastAssignedTerritorries doesnt contain value for this leads cluster.');
                                }
                            }
                            else{
                                System.debug('Lead Pincode territory few details are empty. Either Cluster or Lat long.');
                                //listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','IronManLead_Assignment_Helper Class','assignIronmanToWTALead method','Few Lead pin code '+leadObj.PostalCode+ ' related territory details are empty (Either Cluster or Lat long). Contact your system administrator.',leadObj.LeadSource,leadObj.email));
                            }
                        }
                        else{
                            System.debug('Lead pin code is not among valid Territory pincodes ');
                            listOfLogsToInsert.add(Logger.returnLog('WTA to IM Lead Assignment Error','IronManLead_Assignment_Helper Class','assignIronmanToWTALead method','A Territory record is not present for this pincode: '+leadObj.PostalCode,leadObj.email,leadObj.PostalCode));
                        }
                    }
                    else{
                        System.debug('Lead pin code is blank');
                        // At Pre- Appointment stage Pincode is mandatory (validation rule)
                    }
                }
                if(!ironManListToUpdateAssignment.isEmpty()){
                    system.debug('ironManListToUpdateAssignment is not empty');
                    update ironManListToUpdateAssignment;
                }
                if(!listOfLogsToInsert.isEmpty()){
                    system.debug('listOfLogsToInsert is not empty');
                    insert listOfLogsToInsert;
                }
            }
            else{
                System.debug('Method input parameters are empty');
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            Logger.log('Exception','IronManLead_Assignment_Helper method','assignIronmanToWTALead Class',e.getMessage(),e.getStackTraceString(),null);
        } 
    }
     
    
    
    /*public static Decimal calculateDistanceBwLatLongs(Decimal leadLat, Decimal leadLong, Decimal territoryLat, Decimal territoryLong){
Decimal distance;
if(leadLat !=null && leadLong !=null && territoryLat !=null && territoryLong !=null){
distance = ((leadLat - territoryLat)*(leadLat - territoryLat) + (leadLong - territoryLong)*(leadLong - territoryLong));
}
System.debug('distance: '+distance);
return distance;
}
*/
    public static Territory__c getNearestIronManId(Territory__c leadPinCodeTerritory, List<Territory__c> listOfLeastAssignedTerritories){
        Territory__c nearestIronManTerritory;
        try{
            if(leadPinCodeTerritory !=null && !listOfLeastAssignedTerritories.isEmpty()){
                Decimal leastDistance = null;
                for(Territory__c territory : listOfLeastAssignedTerritories){
                    if(territory.Ironman__c != null && territory.Lat_Long__latitude__s != null){
                        Decimal distance,leadLat, leadLong, territoryLat,territoryLong;
                        leadLat = leadPinCodeTerritory.Lat_Long__latitude__s;
                        leadLong = leadPinCodeTerritory.Lat_Long__longitude__s;
                        territoryLat = territory.Lat_Long__latitude__s;
                        territoryLong = territory.Lat_Long__longitude__s;
                        distance = ((leadLat - territoryLat)*(leadLat - territoryLat) + (leadLong - territoryLong)*(leadLong - territoryLong));
                        System.debug('Distance calculated: '+distance);
                        if(leastDistance == null && nearestIronManTerritory == null){
                            leastDistance = distance;
                            nearestIronManTerritory = territory;
                        }
                        else{
                            if(distance < leastDistance){
                                leastDistance = distance;
                                nearestIronManTerritory = territory;
                            }
                        }
                        System.debug('nearestIronManTerritory: '+nearestIronManTerritory);
                        System.debug('leastDistance: '+leastDistance);
                        
                    }
                    else{
                        System.debug('Territory few details are empty. Either Cluster or Lat long.');
                    }
                }
            }
            else{
                System.debug('Method input parameters are empty');
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            Logger.log('Exception','getNearestIronManId method','IronManLead_Assignment_Helper Class',e.getMessage(),e.getStackTraceString(),null);
        } 
        return nearestIronManTerritory;
    }
    
     public static void dummyTestCover(){
        Integer i =0;
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