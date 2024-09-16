Public class AssignLeadToWTAGroup{ 
    
    Public static void  AssignLeadToWTAGroupA_GroupB(lead objectLead){  
        
        Lead ObjLead = new Lead();
        list<WTA_Assignment__c> lstAssignmentGroupA = new list<WTA_Assignment__c>();
        
        if(objectLead != NULL){  
            system.debug('++++objectLead++++'+objectLead.id);
            ObjLead = objectLead;
            if((objLead.Status =='Fresh Lead' && objLead.sub_status__c == 'New' &&
               objLead.Pushed_To_Ozone_1st_Time__c == false && objLead.Assigned_to_Resi_ASM__c == false && 
               objLead.Assigned_to_WTA__c == false) ||(objLead.Status =='Fresh Lead' && objLead.sub_status__c == 'Re-Landed')||
               (objLead.Status =='Appointment Fixed'  && objLead.Pushed_To_Ozone_1st_Time__c == false && 
               objLead.Assigned_to_Resi_ASM__c == false )){
            
                // Group A Details 
                lstAssignmentGroupA = getGroupADetails(ObjLead);

                if(lstAssignmentGroupA != NULL && !lstAssignmentGroupA.isEmpty()){
                    system.debug('List Of Group A Records'+lstAssignmentGroupA);
                    Map<String,WTA_Assignment__c> MapGroupA_Assignmnet  = new Map<String,WTA_Assignment__c>();
                    for(WTA_Assignment__c obj:lstAssignmentGroupA){
                        MapGroupA_Assignmnet.put(obj.Agent_Email__c,obj);
                    }
                    Lead_Assignment_Helper.checkWTAStatus(objLead,MapGroupA_Assignmnet,lstAssignmentGroupA[0].City_Campaign_Name__c);
                }
                //
                else{
                    list<WTA_Assignment__c> lstGroupB_Assignment = getGroupBDetails(objLead);
                    if(lstGroupB_Assignment != NULL && !lstGroupB_Assignment.isEmpty()){
                        system.debug('List Of Group B Records'+lstGroupB_Assignment);
                        Map<String,WTA_Assignment__c> MapGroupB_Assignmnet  = new Map<String,WTA_Assignment__c>();
                        for(WTA_Assignment__c obj:lstGroupB_Assignment){
                            MapGroupB_Assignmnet.put(obj.Agent_Email__c,obj);
                        }
                       Lead_Assignment_Helper.checkWTAStatus(objLead,MapGroupB_Assignmnet,lstGroupB_Assignment[0].City_Campaign_Name__c);
                    }   
                }
            }    
            else{
                    // If Status is not Matching 
            }     
            
           
        }
        else{
            // If lead is  null 
        }

    }

        /*
    Used to Query the lead Assignment of Group A
    */

    Public static List<WTA_Assignment__c> getGroupADetails(lead objlead){
        list<WTA_Assignment__c> lstAssignment = [Select id,Name,Assignment__c,City__c,Daily_Assignment__c,Daily_Limit__c,Group__c,
                                        IsActive__c,Monthly_Assignments__c,Monthly_Limit__c,User__c,Weekly_Assignment__c,Weekly_Limit__c,
                                        Agent_Campaign_Name__c,City_Campaign_Name__c,Agent_Email__c
                                        from WTA_Assignment__c 
                                        where City__c =: objLead.city and Group__c = 'Group A' and 
                                        Assignment__c <100 and IsActive__c = true
                                        Order by Assignment__c desc];
        system.debug('------Group A Assignment lstAssignment-------'+lstAssignment);                                
        return lstAssignment;
        
    }

    /*
    Used to Query the lead Assignment of Group B
    */
    Public static List<WTA_Assignment__c> getGroupBDetails(lead objlead){
       list<WTA_Assignment__c> lstAssignment = [Select id,Name,Assignment__c,City__c,Daily_Assignment__c,Daily_Limit__c,Group__c,
                                                        IsActive__c,Monthly_Assignments__c,Monthly_Limit__c,User__c,Weekly_Assignment__c,Weekly_Limit__c,
                                                        Agent_Campaign_Name__c,City_Campaign_Name__c,Agent_Email__c
                                                        from WTA_Assignment__c 
                                                        where City__c includes (:objLead.city)  and Group__c = 'Group B' and 
                                                        IsActive__c = true
                                                        Order by Assignment__c desc]; 
        system.debug('------Group B Assignment lstAssignment-------'+lstAssignment);   
        return lstAssignment;
        
    }

    Public static void asssigntoGroupB(lead objlead){
        map<String,WTA_Assignment__c> mapAssignment = new map<String,WTA_Assignment__c>();
        list<WTA_Assignment__c> lstAssignment = [Select id,Name,Assignment__c,City__c,Daily_Assignment__c,Daily_Limit__c,Group__c,
                                                        IsActive__c,Monthly_Assignments__c,Monthly_Limit__c,User__c,Weekly_Assignment__c,Weekly_Limit__c,
                                                        Agent_Campaign_Name__c,City_Campaign_Name__c,Agent_Email__c
                                                        from WTA_Assignment__c 
                                                        where City__c includes (:objLead.city)  and Group__c = 'Group B' and 
                                                        IsActive__c = true
                                                        Order by Assignment__c desc]; 
        system.debug('------Group B Assignment lstAssignment-------'+lstAssignment);   
        if(!lstAssignment.isEmpty()){
            for(WTA_Assignment__c objassign:lstAssignment){
                mapAssignment.put(objassign.Agent_Email__c,objassign);
            }
            Lead_Assignment_Helper.checkWTAStatus(objLead,mapAssignment,lstAssignment[0].City_Campaign_Name__c);
        }
    }
}