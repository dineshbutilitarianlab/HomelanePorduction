Public class AssignLeadToIronMan implements Queueable,Database.AllowsCallouts{

    Lead ObjLead = new Lead(); 
    boolean bInBusinessHours;

    public AssignLeadToIronMan(Lead leadObj){
        ObjLead = leadObj;

    }
    Public void execute(QueueableContext QC){
        system.debug('lead Owner Name'+ObjLead.Owner.Name);
        system.debug('lead Owner Id'+ObjLead.OwnerId);
        Lead_Round_Robin_Assignment__c assignedUser;
        List<Lead> leadToUpdate = new List<Lead>();
        List<Lead> lstAssignToGroups = new List<Lead>();
        list<Lead_Round_Robin_Assignment__c> lstRleadAssignment = new list<Lead_Round_Robin_Assignment__c>();
        list<Lead_Round_Robin_Assignment__c> lstMatchedAssignment = new list<Lead_Round_Robin_Assignment__c>();
        list<Lead_Round_Robin_Assignment__c> lstAssignmentToUpdate = new list<Lead_Round_Robin_Assignment__c>();
        Map<String,List<Lead_Round_Robin_Assignment__c>> mapShowroomRAssgnments = new Map<String,List<Lead_Round_Robin_Assignment__c>>();

        // Lead id not NULL
        if( ObjLead != NULL ){
            try{
                if(ObjLead.Round_Robin_Lead_Source_Condition__c == true){
                    system.debug('++++ObjLead++++'+ObjLead.id);

                    lstRleadAssignment = [Select Assignment__c,Assignment_Days__c,Daily_Assignment__c,Daily_Limit__c,
                                                Distance_from_ShowRoom__c,Monthly_Assignments__c,Monthly_Limit__c,
                                                Showroom_Name__c,User__c,IronMan_Reference__c
                                                from Lead_Round_Robin_Assignment__c];
                    system.debug('+++++lstRleadAssignment+++'+lstRleadAssignment);
                    // IF records are Present put it in a map
                    if(!lstRleadAssignment.isEmpty() && lstRleadAssignment != NULL){
                        for(Lead_Round_Robin_Assignment__c objLeadRA : lstRleadAssignment){
                            if(mapShowroomRAssgnments.containsKey(objLeadRA.Showroom_Name__c)){
                                mapShowroomRAssgnments.get(objLeadRA.Showroom_Name__c).add(objLeadRA);
                            }
                            else{
                                mapShowroomRAssgnments.put(objLeadRA.Showroom_Name__c,new list<Lead_Round_Robin_Assignment__c>{objLeadRA});
                            }
                        }

                        
                        // If Status = Fresh Lead and Sub Status = New and Not Pushed Ozonetel and Not Assigned to Asm
                        if((objLead.Status =='Fresh Lead' && objLead.sub_status__c == 'New' && objLead.Pushed_To_Ozone_1st_Time__c == false && 
                            objLead.Assigned_to_Resi_ASM__c == false && String.isNotBlank(objLead.Closest_Showroom__c)) || 
                            (objLead.status == 'Appointment Fixed' && objLead.Pushed_To_Ozone_1st_Time__c == false  &&
                            objLead.Assigned_to_Resi_ASM__c == false && objLead.Assigned_to_WTA__c == false)){
                            
                            lstMatchedAssignment = NULL;
                            for(String sShowroom:mapShowroomRAssgnments.keyset()){
                                // If the Match Showroom matches
                                if(objLead.Closest_Showroom__c.containsIgnoreCase(sShowroom)){
                                    lstMatchedAssignment = mapShowroomRAssgnments.get(sShowroom);   
                                    break;  
                                }
                            } 

                            if(lstMatchedAssignment != NULL && !lstMatchedAssignment.isEmpty()){
                                Decimal d =100.0;
                                Datetime dt = DateTime.newInstance(objLead.createdDate.date(), Time.newInstance(0, 0, 0, 0));
                                String dayOfWeek=dt.format('EEEE');
                                for(Lead_Round_Robin_Assignment__c objAssignment:lstMatchedAssignment){
                                    if((objAssignment.Daily_Limit__c>0 && objAssignment.Daily_Assignment__c<objAssignment.Daily_Limit__c) 
                                        && (objAssignment.Monthly_Limit__c>0 && objAssignment.Monthly_Assignments__c<objAssignment.Monthly_Limit__c
                                        && objAssignment.Assignment_Days__c.containsIgnoreCase(dayOfWeek))){
                                        Decimal distance; 
                                        distance = String.isNotBlank(objLead.Closest_Showroom__c.trim().substringAfterLast(' ').removeEndIgnoreCase('km'))?Decimal.ValueOf(objLead.Closest_Showroom__c.trim().substringAfterLast(' ').removeEndIgnoreCase('km')):2000;
                                        System.debug('d--->'+d+'objAssignment.Assignment__c'+objAssignment.Assignment__c+'distance'+distance);
                                        if(distance <= objAssignment.Distance_from_ShowRoom__c)
                                            {
                                            if(objAssignment.Assignment__c<=d){
                                                d = objAssignment.Assignment__c;
                                                assignedUser = objAssignment;
                                            }    
                                        }
                                    }    
                                }

                                if(assignedUser != NULL){
                                    //Since After Trigger Creating the New Instance to Update
                                    system.debug('+++++assignedUser+++'+assignedUser+'+++objLead+++'+objLead);
                                    lead objLeadToUpdate = new lead();
                                    objLeadToUpdate.id = ObjLead.id;
                                    objLeadToUpdate.OwnerId = assignedUser.User__c;
                                    objLeadToUpdate.Wt_Agent__c = assignedUser.User__c;
    
                                    // Update Iron Man As SSA in 
                                    //objLeadToUpdate.Square_Showroom_Agent__c = assignedUser.User__c;
                                    objLeadToUpdate.Sales_Manager__c =  assignedUser.IronMan_Reference__c;
                                    objLeadToUpdate.Assigned_to_Resi_ASM__c = true;
                                    leadToUpdate.add(objLeadToUpdate);

                                    assignedUser.Daily_Assignment__c++;
                                    assignedUser.Monthly_Assignments__c++;
                                    System.debug('Updated sadsa'+assignedUser);
                                    lstAssignmentToUpdate.add(assignedUser); 
                                }else{
                                    // No Iron Man Meets the Critiria
                                    lstAssignToGroups.add(objLead);
                                } 

                            }else{
                                // No Macth Found i.e No IronMan for the showroom then assign it to WTA
                                lstAssignToGroups.add(objLead);
                            }

                        // Fresh Lead - Relanded Condition       
                        }else if(objLead.Status =='Fresh Lead' && objLead.sub_status__c == 'Re-Landed'){
                                lstAssignToGroups.add(objLead);
                        }
                        else{
                                // Do Nothing     
                        }
                        
                    }
                    else{
                        // Group A and Group B
                        // If there is no Iron man Records
                        lstAssignToGroups.add(objLead);
                    }

                    if(lstAssignToGroups != NULL && !lstAssignToGroups.isEmpty()){
                        // If created in business Hours
                        system.debug('lstAssignToGroups'+lstAssignToGroups);
                        if(objLead.Created_during_business_hours__c){ 
                            lead ObjLeadNew = new lead();
                            ObjLeadNew.id = objLead.id;
                            ObjLeadNew.Pushed_To_Ozonetel__c = true;
                            leadToUpdate.add(ObjLeadNew);
                            system.debug('LeadPushToOzonetelQueueable');
                            LeadPushToOzonetelQueueable objLPA = new LeadPushToOzonetelQueueable(lstAssignToGroups,UserInfo.getSessionId());
                            ID jobID = System.enqueueJob(objLPA);
                        }else{
                            AssignOffBusinessHrLead(objLead);
                        }
                    }
                    
                    // Update the Lead   
                    if(leadToUpdate != NULL && !leadToUpdate.isEmpty()){
                        update leadToUpdate;
                    }

                    // Update Assignement List 
                    if(lstAssignmentToUpdate != NULL && !lstAssignmentToUpdate.isEmpty()){
                        update lstAssignmentToUpdate;
                    }
                }
                else{
                    //Round_Robin_Lead_Source_Condition__c false don't change the Owner 
                }
            }
            catch(Exception e){
                system.debug('Exception  --- >'+e.getStackTraceString());
                 Logger.log('Exception','AssignLeadToIronMan','execute',e.getMessage(),e.getStackTraceString(),NULL);
            }    
        }else{
            // IF Lead Object is NULL
        }
    }

    public static void AssignOffBusinessHrLead(Lead ObjectLead){

     /* When Lead is created it's assigned to respective Group and We are comapring the Group Name
     In Round Robin*/
    system.debug('lead Owner Name'+ObjectLead.Owner.Name);
    system.debug('lead Owner Id'+ObjectLead.OwnerId);
    Map < String, Id > rrNameMap = new Map < String, Id > ();
    Lead_Assignment__c curLAss = new Lead_Assignment__c();
    list<lead> lstupdatelead = new list<lead>();
    list<Lead_Assignment__c> lstleadAssignment = new list<Lead_Assignment__c>();
    Map < Id, Round_Robin__c > roundRobinMap = new Map < Id, Round_Robin__c > ([select Queue_Name__c, Total_Leads__c,IsActive__c,
                                                                                (select Name,Number_of_Leads__c, USer__r.name, User__r.LastLoginDate, Assign_Percent__c, Actual_Percentage__c, Round_Robin__c, User__c from Lead_Assignment__r 
                                                                                    where Assign_Percent__c >0)
                                                                                FROM Round_Robin__c
                                                                                WHERE Queue_Name__c =: ObjectLead.Owner.Name
                                                                                ]);
        system.debug('lead Owner Name'+ObjectLead.Owner.Name); 
        system.debug('roundRobinMap'+roundRobinMap);                                                                        
        if(!roundRobinMap.isEmpty()){
            for(Round_Robin__c rr:roundRobinMap.values()){
                rrNameMap.put(rr.Queue_Name__c,rr.id);
            }    

            system.debug('rrNameMap'+rrNameMap); 
            if(!rrNameMap.isEmpty()){
                Round_Robin__c roundRobin = roundRobinMap.get(rrNameMap.get(ObjectLead.Owner.Name));
                if (roundRobin.Lead_Assignment__r != NULL) {
                    decimal i = 0;
                    for(Lead_Assignment__c leadAssign:roundRobin.Lead_Assignment__r){
                        system.debug('i-->'+(leadAssign.Assign_Percent__c - leadAssign.Actual_Percentage__c)+'leadAssign.User__c'+leadAssign.Name );
                        if( i < leadAssign.Assign_Percent__c - leadAssign.Actual_Percentage__c ){
                            
                            i = leadAssign.Assign_Percent__c - leadAssign.Actual_Percentage__c;
                            curLAss = leadAssign;
                        }
                    }
                }
                if(curLAss != NULL){
                    lead ObjLeadNew = new lead();
                    ObjLeadNew.id = ObjectLead.id;
                    ObjLeadNew.Ownerid = curLAss.User__c;
                    ObjLeadNew.WT_Agent__c = curLAss.User__c;
                    ObjLeadNew.Assigned_to_WTA__c = true;
                    lstupdatelead.add(ObjLeadNew);
                    curLAss.Number_of_Leads__c += 1;
                    lstleadAssignment.add(curLAss);
                }
                else{
                    // No lead Assignment record for lead
                }
            }    
        }
        else{
            // Round Robin record doesn't exists
        }

        system.debug('lstupdatelead--->'+lstupdatelead);
        system.debug('lstleadAssignment--->'+lstleadAssignment);


        if(!lstupdatelead.isEmpty()){
            update lstupdatelead;
        }
        if(!lstleadAssignment.isEmpty()){
            update lstleadAssignment;
        }

    }



    

    public void  AssignToWTA(Lead ObjectLead){

        lead objlead;
        list<Lead> lstLeadUpdate = new list<Lead>();
        list<WTA_Assignment__c> lstWTAssignment = new list<WTA_Assignment__c>();
        list<WTA_Assignment__c> lstGroupA_Assignment = new list<WTA_Assignment__c>();
        list<WTA_Assignment__c> lstGroupB_Assignment = new list<WTA_Assignment__c>();

        if(String.isNotBlank(ObjectLead.city)){
            objLead = ObjectLead;
            try{
                lstGroupA_Assignment = [Select id,Name,Assignment__c,City__c,Daily_Assignment__c,Daily_Limit__c,Group__c,
                                            IsActive__c,Monthly_Assignments__c,Monthly_Limit__c,User__c,Weekly_Assignment__c,Weekly_Limit__c,
                                            Agent_Campaign_Name__c,City_Campaign_Name__c,Agent_Email__c 
                                            from WTA_Assignment__c 
                                            where City__c includes (:objLead.city) and Group__c = 'Group A' and 
                                            Assignment__c <100 and IsActive__c = true
                                            Order by Assignment__c desc];

                                            
                
                if(lstGroupA_Assignment != NULL && !lstGroupA_Assignment.isEmpty()){
                    system.debug('Sample Assignment Group A OutOfWorking Hr'+lstGroupA_Assignment);
                    lead ObjLeadNew = new lead();
                    ObjLeadNew.id = objLead.id;
                    ObjLeadNew.OwnerID = lstGroupA_Assignment[0].User__c;
                    ObjLeadNew.WT_Agent__c = lstGroupA_Assignment[0].User__c;
                    ObjLeadNew.Assigned_to_WTA__c = true;
                    lstLeadUpdate.add(ObjLeadNew);

                    lstGroupA_Assignment[0].Daily_Assignment__c = lstGroupA_Assignment[0].Daily_Assignment__c +1;
                    lstGroupA_Assignment[0].Monthly_Assignments__c = lstGroupA_Assignment[0].Monthly_Assignments__c +1;
                    lstGroupA_Assignment[0].Weekly_Assignment__c = lstGroupA_Assignment[0].Weekly_Assignment__c +1;
                    lstWTAssignment.add(lstGroupA_Assignment[0]); 
                }
                else{

                    lstGroupB_Assignment = [Select id,Name,Assignment__c,City__c,Daily_Assignment__c,Daily_Limit__c,Group__c,
                                IsActive__c,Monthly_Assignments__c,Monthly_Limit__c,User__c,Weekly_Assignment__c,Weekly_Limit__c,
                                Agent_Campaign_Name__c,City_Campaign_Name__c,Agent_Email__c
                                from WTA_Assignment__c 
                                where City__c includes (:objLead.city) and Group__c = 'Group B'  
                                and IsActive__c = true
                                Order by Assignment__c desc];

                    if(lstGroupB_Assignment != NULL && !lstGroupB_Assignment.isEmpty()){
                        system.debug('Sample Assignment Group B OutOfWorking Hr'+lstGroupB_Assignment);
                        lead ObjLeadNew = new lead();
                        ObjLeadNew.id = objLead.id;
                        ObjLeadNew.OwnerID = lstGroupB_Assignment[0].User__c;
                        ObjLeadNew.WT_Agent__c = lstGroupB_Assignment[0].User__c;
                        ObjLeadNew.Assigned_to_WTA__c = true;
                        lstLeadUpdate.add(ObjLeadNew);

                        lstGroupB_Assignment[0].Daily_Assignment__c = lstGroupB_Assignment[0].Daily_Assignment__c +1;
                        lstGroupB_Assignment[0].Monthly_Assignments__c = lstGroupB_Assignment[0].Monthly_Assignments__c +1;
                        lstGroupB_Assignment[0].Weekly_Assignment__c = lstGroupB_Assignment[0].Weekly_Assignment__c +1;
                        lstWTAssignment.add(lstGroupB_Assignment[0]); 
                    }            
                }
                
                if(lstLeadUpdate != NULL && !lstLeadUpdate.isEmpty()){
                    System.debug('lstLeadUpdate'+lstLeadUpdate);
                    update lstLeadUpdate;
                }

                if(lstWTAssignment != NULL && !lstWTAssignment.isEmpty()){
                    update lstWTAssignment;
                }
            }
            catch(Exception e){
                 Logger.log('Exception','AssignLeadToIronMan','AssignToWTA',e.getMessage(),e.getStackTraceString(),NULL);
            }
        }
        
        else{
            // If city is not null 
        }

    }
}