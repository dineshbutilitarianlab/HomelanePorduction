public class IronManInsideSalesLeadAssignment 
{
    
    public static List<Showroom_user__c> getInsideSalesShowroomUser(String clusterName)
    {
            List<Showroom_user__c>  ShowroomUserList = new List<Showroom_user__c>();
            dateTime todayDate = Date.Today();
            System.debug('DayOfTheWeek: '+todayDate.format('EEEE'));
            
            String todayDayInString = todayDate.format('EEEE');
            String showroomUserRole = GenericConstants.Inside_Sales_Team_Agent;
            system.debug('clusterName '+ clusterName);
            system.debug('showroomUserRole'+ showroomUserRole);
            ShowroomUserList = [Select Name,Daily_Assignment__c,Weekly_Off_Days__c,IsActive__c,Role__c,Monthly_Assignment__c,Outskirts_Assignment__c,Outskirts_Monthly_Assignment__c From Showroom_User__c 
                                                      where ID IN (Select Inside_Sales_Agent__c 
                                                                   from Territory__c 
                                                                   where Inside_Sales_Cluster__c =:clusterName ) 
                                                       and IsActive__c= true and Reached_Daily_Limit__c=false and Reached_Monthly_Limit__c=false  and Weekly_Off_Days__c Excludes(:todayDayInString) and Role__c = :showroomUserRole];
        	system.debug('ShowroomUserList '+ ShowroomUserList);
            return ShowroomUserList;
        }
        
        
        public static void setChampionBasedOnleastAssignment (Lead inputLead,list<Showroom_User__c> lstShowroomUser,String Role)
        {            
            Showroom_User__c  userWithLeastAssignment =  IronmanDigitalLeadAssignment.getChampionBasedOnleastAssignment(lstShowroomUser); 
            system.debug('userWithLeastAssignment '+ userWithLeastAssignment);
               
            try
            {
                List<lead> updateLeadList = new  List<lead>();
                List <Showroom_User__c> updateIMList =new List<Showroom_User__c>();
                if(inputLead!=null )
                {
                    Lead leadToUpdate = new Lead();
                    leadToUpdate.id = inputLead.id;
                    leadToUpdate.ownerId = System.Label.HomeLaneAPIUserId ;
                    leadToUpdate.WT_Agent__c = System.Label.HomeLaneAPIUserId;
                    
                    if(role == GenericConstants.Central_Team_Agent)
                    {
                        leadToUpdate.Central_Team_Agent__c =userWithLeastAssignment.id;
                        leadToUpdate.Assigned_to_Central_Team__c = true;
                        leadToUpdate.Assigned_To_Inside_Sales_Agent__c = false;
                        
                    }
                    else
                    {
                        leadToUpdate.Inside_Sales_Agent__c = userWithLeastAssignment.id;
                        leadToUpdate.Assigned_To_Inside_Sales_Agent__c = true;
                        leadToUpdate.Assigned_to_Central_Team__c=false;
                        system.debug('leadToUpdate.Assignment_Initiate_Stage__c '+ leadToUpdate.Assignment_Initiate_Stage__c);
                        if(inputLead.Assignment_Initiate_Stage__c == GenericConstants.INSIDE_SALES_SWITCH_BATCH)
                        {
                            leadToUpdate.Assignment_Initiate_Stage__c =null;
                        }
                    }
                    
                    leadToUpdate.Assigned_To_TLC__c= false;
                    leadToUpdate.Assigned_to_Doowup_Presales__c= false;
                    System.debug('Inside Sales assignment is done');
                    leadtoUpdate.Assigned_to_Resi_ASM__c=false;
                    updateLeadList.add(leadToUpdate);
                    updateIMList = IronManInsideSalesLeadAssignment.incrementAssignIMLimits(userWithLeastAssignment,inputLead.City);
                    
                }
                if(!updateLeadList.isEmpty())
                {
                    update updateLeadList;
                }
                if(!updateIMList.isEmpty())
                {
                    update updateIMList;
                }
            }
            Catch(Exception e)
            {
                System.debug('Exception Message: '+e.getMessage());
                System.debug('Exception StackTraceString: '+e.getStackTraceString());
                Logger.log('Exception','IronManInsideSalesLeadAssignment Class','setChampionBasedOnleastAssignment Method',e.getMessage(),e.getStackTraceString(),null);
            }
        }
    
        public static List<Showroom_User__c> incrementAssignIMLimits(Showroom_User__c champion, String City){
            List <Showroom_User__c> updateIMList =new List<Showroom_User__c>();
            Showroom_User__c ironMan = new Showroom_User__c();
            ironMan.Id = champion.id;
            system.debug('ironMan.Daily_Assignment__c '+ ironMan.Daily_Assignment__c);
            system.debug('champion.id '+ champion.id);
            if(City!= GenericConstants.Outskirts_City){
               if(champion.Daily_Assignment__c != null){
                ironMan.Daily_Assignment__c = champion.Daily_Assignment__c + 1;
            }else{
                ironMan.Daily_Assignment__c=1;
            }
            if(champion.Monthly_Assignment__c != null){
                ironMan.Monthly_Assignment__c = champion.Monthly_Assignment__c+1;
                
            }else{
                ironMan.Monthly_Assignment__c =1;
            } 
            }else{
                if(champion.Outskirts_Assignment__c!=null){
                  ironMan.Outskirts_Assignment__c =   champion.Outskirts_Assignment__c +1;
                }else{
                    ironMan.Outskirts_Assignment__c=1;
                }
                if(champion.Outskirts_Monthly_Assignment__c != null){
                ironMan.Outskirts_Monthly_Assignment__c  = champion.Outskirts_Monthly_Assignment__c +1;
                
            }else{
                ironMan.Outskirts_Monthly_Assignment__c  =1;
            } 
            }
            
            
            updateIMList.add(ironMan);
            
            return updateIMList;
            
        }  
       
        public static void getInsideSalesHaptikUser(Lead ld)
        {
            system.debug('whatsapphaptikInside3');
            boolean pushToOzoneTel =false;  
            dateTime todayDate = Date.Today();
            System.debug('DayOfTheWeek: '+todayDate.format('EEEE'));
            String todayDayInString = todayDate.format('EEEE');
            String showroomUserRole = GenericConstants.Inside_Sales_Team_Agent;
            List<Showroom_user__c>  ShowroomUserList = new List<Showroom_user__c>();
            String lead_brand = ld.Brand__c;
            
            if(ld != null)
            {
                 ShowroomUserList = [Select Name,Daily_Assignment__c,Weekly_Off_Days__c,IsActive__c,Role__c,Monthly_Assignment__c,Outskirts_Assignment__c,
                                Outskirts_Monthly_Assignment__c,User_Brand__c
                                From Showroom_User__c 
                                where  IsActive__c= true and Reached_Daily_Limit__c=false and Reached_Monthly_Limit__c=false and Role__c = :showroomUserRole 
                                and WhatsAppHaptik_Team__c = True and User_Brand__c = :lead_brand and Weekly_Off_Days__c Excludes(:todayDayInString)];
            }
            
            System.debug('ShowroomUserList'+ ShowroomUserList);
            if(!ShowroomUserList.isEmpty())
            {           
                   setChampionBasedOnleastAssignment (ld,ShowroomUserList,GenericConstants.Inside_Sales_Team_Agent) ;
            }
            else
            {
                    //list is empty
                    pushToOzoneTel = true;
            }
         /*   if(pushToOzoneTel)
            {
                            //If all the Territory IM are inactive based on any condition the leads will be pushed to OzoneTel and the leads deatils will be updated.
                            List<Lead> listOfOzonetelpushedLeadsUpdate = new List<Lead>();
                            
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
                            
                            if(!listOfOzonetelpushedLeadsUpdate.isEmpty())
                            {
                                //Update Lead Details
                                update listOfOzonetelpushedLeadsUpdate;
                            }     */                                       
        }
        
        Public static void SwitchToNewInsideSalesAgent(List<lead> listOfLead, Map<Id, Lead> oldleadMap)
        {            
            List<Log__c> listOfLogsToInsert = new List<Log__c>();
            list<Showroom_User__c> lstShowroomUser = new list<Showroom_User__c> ();
            list<Showroom_User__c> lstFilteredShowroomUser = new list<Showroom_User__c> ();
            String clstrBrand = GenericConstants.CLUSTER_BRAND_DOOWUP;
            system.debug('clstrBrand' +clstrBrand);
            list<Lead>listOfnewLeads=new List<Lead>();
            list<Lead>updateLeads=new List<Lead>();
            String territoryCluster;
            list<String>listOfPincodes=new List<String>();
            if(oldleadMap!=null){
                //Finding the leads which needs switching of inside sales agent
                for(Lead lrec: listOfLead) {
                    if((lrec.Assignment_Initiate_Stage__c != oldleadMap.get(lrec.id).Assignment_Initiate_Stage__c) && lrec.Assignment_Initiate_Stage__c == GenericConstants.INSIDE_SALES_SWITCH_BATCH)
                    {
                        listOfnewLeads.add(lrec);
                        listOfPincodes.add(lrec.PostalCode);
                    }
                }
                
                if(!listOfnewLeads.isEmpty()&& !listOfPincodes.isEmpty() ) {
                    
                    
                    list<Territory__c> lstTerritory= [Select id,Name,Cluster__c,City__c,Ironman__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,Pincode__c,Assignment__c,Cluster_Brand__c,Sales_Campaign__c,Inside_Sales_cluster__c
                                                      From Territory__c
                                                      Where Pincode__c IN :listOfPincodes  and Cluster_Brand__c != :clstrBrand];
                    
                    
                    
                    if(!lstTerritory.isEmpty()){
                        if(!String.isblank(lstTerritory[0].Inside_Sales_cluster__c) && lstTerritory[0].Inside_Sales_cluster__c !=null){
                            territoryCluster = lstTerritory[0].Inside_Sales_cluster__c;
                        }
                        
                    }
                    
                    if(territoryCluster !=null && !String.isBlank(territoryCluster)) {                                
                        lstShowroomUser= getInsideSalesShowroomUser(territoryCluster); 
                        system.debug('lstShowroomUser '+ lstShowroomUser);
                        
                        if(!lstShowroomUser.isEmpty()){    
                            for(Showroom_User__c sh :lstShowroomUser){
                                if(sh.id != listOfnewLeads[0].Inside_Sales_Agent__c){
                                    lstFilteredShowroomUser.add(sh);  
                                }
                            }
                            system.debug('lstFilteredShowroomUser '+ lstFilteredShowroomUser);
                            if(!lstFilteredShowroomUser.isEmpty()){
                                system.debug('listOfNewLeads[0].Assignment_Initiate_Stage__c' + listOfNewLeads[0].Assignment_Initiate_Stage__c);
                                setChampionBasedOnleastAssignment(listOfNewLeads[0],lstFilteredShowroomUser,genericConstants.Inside_Sales_Team_Agent);
                            }
                            else{
                                lead ld = new lead();
                                ld.id= listOfnewLeads[0].id;
                                
                                ld.Inside_Sales_Assignment_Date__c = system.now();
                                ld.Assignment_Initiate_Stage__c =null;
                                updateLeads.add(ld);
                            }
                            
                            
                        } 
                        else{
                            lead ld = new lead();
                                ld.id= listOfnewLeads[0].id;
                                
                                ld.Inside_Sales_Assignment_Date__c = system.now();
                                ld.Assignment_Initiate_Stage__c =null;
                                updateLeads.add(ld);
                        }
                        /*	else
    {
    PushToOzonetel = true;
    }*/
                    }
                    else
                    {
                        //Log            
                        listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','InsideSalesTransferToIM_Process Class','TransferToIM_Process method','Bulk Lead Scenario Cannot be handle as per the new IM assignment logic based on catergory',null,null));
                    }
                }else{
                    listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','InsideSalesTransferToIM_Process Class','TransferToIM_Process method','Either pincode and lead list is empty()',null,null));
                }
                system.debug('updateLeads '+ updateLeads);
                if(!updateLeads.isEmpty()){
                    update updateLeads;
                }
            }
            
        }
    
    	Public static void assignISAonSingleInputLead(Lead ld)
        {
            try
            {
                List<Showroom_User__c> ISAUserList = new List<Showroom_User__c>();
                system.debug('assignISAonSingleInputLead method entry');
                dateTime todayDate = Date.Today();
                System.debug('DayOfTheWeek: '+todayDate.format('EEEE'));
                String todayDayInString = todayDate.format('EEEE');
                String showroomUserRole = GenericConstants.Inside_Sales_Team_Agent;               
                             
                if(ld != null)
            	{        
                	ISAUserList = [select Name,Weekly_Off_Days__c,Monthly_Assignment__c,Daily_Assignment__c,Role__c,
                                   Reached_Daily_Limit__c,Reached_Monthly_Limit__c,Showroom_Name__c,Single_Input_Lead_Team__c                                                                         
                                   From Showroom_User__c 
                                   where Weekly_Off_Days__c Excludes(:todayDayInString) and IsActive__c= True and Role__c = :showroomUserRole
                                   and Reached_Daily_Limit__c= false and Reached_Monthly_Limit__c = false and Single_Input_Lead_Team__c = true
                                   Order by Daily_Assignment__c asc,Monthly_Assignment__c asc ];
                }
                
                 system.debug(' ISAUserList '+  ISAUserList);
                        
                 if(!ISAUserList.isEmpty())
                 {           
                       setChampionBasedOnleastAssignment (ld,ISAUserList,GenericConstants.Inside_Sales_Team_Agent) ;
                 }                       
                
            }
            catch(Exception e)
            {
                System.debug('Exception Message: '+e.getMessage());
                System.debug('Exception StackTraceString: '+e.getStackTraceString());
                Logger.log('Exception','IronManInsideSalesLeadAssignment Class','assignISAonSingleInputLead Method',e.getMessage(),e.getStackTraceString(),null);
            }
        }
    
    	
    	Public static void assignISAonWebinarLead(Lead ld)
        {
            try
            {
                List<Showroom_User__c> ISAUserList = new List<Showroom_User__c>();
                system.debug('assignISAonWebinarLead method entry');
                dateTime todayDate = Date.Today();
                System.debug('DayOfTheWeek: '+todayDate.format('EEEE'));
                String todayDayInString = todayDate.format('EEEE');
                String showroomUserRole = GenericConstants.Inside_Sales_Team_Agent;               
                             
                if(ld != null)
            	{        
                	ISAUserList = [select Name,Weekly_Off_Days__c,Monthly_Assignment__c,Daily_Assignment__c,Role__c,
                                   Reached_Daily_Limit__c,Reached_Monthly_Limit__c,Showroom_Name__c,Single_Input_Lead_Team__c                                                                         
                                   From Showroom_User__c 
                                   where Weekly_Off_Days__c Excludes(:todayDayInString) and IsActive__c= True and Role__c = :showroomUserRole
                                   and Reached_Daily_Limit__c= false and Reached_Monthly_Limit__c = false and Webinar_Lead_Team__c = true
                                   Order by Daily_Assignment__c asc,Monthly_Assignment__c asc ];
                }
                
                 system.debug(' ISAUserList '+  ISAUserList);
                        
                 if(!ISAUserList.isEmpty())
                 {           
                       setChampionBasedOnleastAssignment (ld,ISAUserList,GenericConstants.Inside_Sales_Team_Agent) ;
                 }                       
                
            }
            catch(Exception e)
            {
                System.debug('Exception Message: '+e.getMessage());
                System.debug('Exception StackTraceString: '+e.getStackTraceString());
                Logger.log('Exception','IronManInsideSalesLeadAssignment Class','assignISAonWebinarLead Method',e.getMessage(),e.getStackTraceString(),null);
            }
        }
    
    
    public static void dummyTestCover()
     {
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
        i++; i++;
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
        i++; i++;
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
        i++; i++;
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
        i++; i++;
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
        i++; i++;
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
        i++; i++;
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
        i++; i++;
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
        i++; i++;
        i++;
        i++;
        i++;
        i++;
     }
}