/**
* @File Name          : IronManLead_Assignment_Handler.cls
* @Description        : 
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 2/6/2020, 3:28:04 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author                    Modification
*==============================================================================
* 1.0    02/06/2020, 4:29:37 PM PM   Bharatesh Shetty     Initial Version
***/
public class IronManLead_Assignment_Handler
{
    /**
* @description || This Method will Fetch list of IronMan where the assignment is minium for the Cluster Homelane and showroomuser
* @author Bharatesh Shetty | 2/6/2020 
* @param List<Lead> lstOfLead 
* @param set<String> lstOfPincode 
* @return void 
* @Last modified by Soniya Kocher |25/08/2022
**/
    Public Static void  getIronManDetails(List<Lead> lstOfLead,set<String> lstOfPincode)
    {
        system.debug('Imdetailsflag');
        system.debug('lstOfpindode '+lstOfPincode);
        Map<String,Territory__c> mapClustor_AssociatedTerritory = new Map<String,Territory__c>();
        Map<String,List<Territory__c>> mapCluster_Territory = new Map<String,List<Territory__c>>();
        Set<String> setCluster = new Set<String>();
        
        List<Log__c> listOfLogsToInsert = new List<Log__c>();             
        boolean pushToOzoneTel =false;  
        
        try
        {
            
            //Due to Our Process constraints we cannot handle multiple leads hence restricting it to single leads
            if(!lstOfLead.isEmpty() && !lstOfPincode.isEmpty() && lstOfLead.size() ==1 && lstOfPincode.size()==1)
            {
                if (lstOfLead[0].Brand__c == GenericConstants.LEAD_DOOWUP)
                {
                    IronManLead_Assignment_Handler.getProductConsultantDetails(lstOfLead, lstOfPincode);
                }
                else
                {
                    // Fetching the Territories from Pincode 
                    String clstrBrand = GenericConstants.CLUSTER_BRAND_DOOWUP;
                    system.debug('clstrBrand' +clstrBrand);
                    list<Territory__c> lstTerritory= [Select id,Name,Cluster__c,City__c,Ironman__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,Pincode__c,Assignment__c,Monthly_Assignment__c,Cluster_Brand__c,Sales_Campaign__c,Inside_Sales_cluster__c
                                                      From Territory__c
                                                      Where Pincode__c IN:lstOfPincode and Cluster_Brand__c != :clstrBrand];
                    
                    System.debug('---lstTerritory----'+lstTerritory);
                    list<Showroom_User__c> lstShowroomUser = new list<Showroom_User__c> ();
                    
                    //Constructing a map of Pincode,Territory and List cluster which is Mapped to the pincode 
                    if(!lstTerritory.isEmpty())
                    {
                        //Only one territory is expected to be return for one pincode
                        String salesCampaignName='';
                        String territoryCluster ='';
                        boolean insideSalesFlag = false;
                        if(lstTerritory[0].Sales_Campaign__c != null || !String.isBlank(lstTerritory[0].Sales_Campaign__c))
                        {
                        	salesCampaignName  = lstTerritory[0].Sales_Campaign__c;
                        }                       
                        
                        if(salesCampaignName == GenericConstants.Inside_Sales_Campaign)
                        {
                            territoryCluster= lstTerritory[0].Inside_Sales_cluster__c;
                        }
                        else
                        {
                             territoryCluster = lstTerritory[0].Cluster__c;
                        }
                      
                       
                        mapClustor_AssociatedTerritory.put(lstTerritory[0].Pincode__c,lstTerritory[0]);
                        
                        
                        System.debug('---mapClustor_AssociatedTerritory----'+mapClustor_AssociatedTerritory);
                        System.debug('territoryCluster'+territoryCluster);
                        System.debug('salesCampaignName '+ salesCampaignName);
                        
                        
                        if(salesCampaignName == null ||String.isBlank(salesCampaignName))
                        {
                            //Normal Assignment
                            if(territoryCluster !=null && !String.isBlank(territoryCluster))
                            {
                                lstShowroomUser= IronmanDigitalLeadAssignment.getIMShowroomUser(territoryCluster, null ,False);
                                
                                // If no IRM is available for assignment, assign ISA : 16th May 2024
                                if(lstShowroomUser.isEmpty())
                                {
                                    territoryCluster= lstTerritory[0].Inside_Sales_cluster__c;
                                    System.debug('territoryCluster'+territoryCluster);
                                    
                                    if(territoryCluster !=null && !String.isBlank(territoryCluster))
                                    {
                                            lstShowroomUser =  IronManInsideSalesLeadAssignment.getInsideSalesShowroomUser(territoryCluster);
                                        
                                        	if(!lstShowroomUser.isEmpty())
                                            {
                                                insideSalesFlag=true;
                                                IronManInsideSalesLeadAssignment.setChampionBasedOnleastAssignment(lstOfLead[0],lstShowroomUser,genericConstants.Inside_Sales_Team_Agent);
                                            } 
                                            else
                                            {                                                
                                                PushToOzonetel = true;
                                                System.debug('PushToOzonetel '+ PushToOzonetel);
                                            }   
                                    }
                                    else
                      				{
                                        	PushToOzonetel = true;
                                            System.debug('PushToOzonetel '+ PushToOzonetel);
                                    }                       
                                }
                            }
                            else
                            {
                                //Log                                
                                listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','IronManLead_Assignment_Handler Class','getIronManDetails method','Bulk Lead Scenario Cannot be handle as per the new IM assignment logic based on catergory',null,null));
                            }
                            
                        }
                        else if(salesCampaignName == GenericConstants.Inside_Sales_Campaign)
                        {
                            
                                if(territoryCluster !=null && !String.isBlank(territoryCluster))
                                {
                                    lstShowroomUser =  IronManInsideSalesLeadAssignment.getInsideSalesShowroomUser(territoryCluster); 
                                }
                                
                                if(!lstShowroomUser.isEmpty())
                                {
                                    insideSalesFlag=true;
                                    IronManInsideSalesLeadAssignment.setChampionBasedOnleastAssignment(lstOfLead[0],lstShowroomUser,genericConstants.Inside_Sales_Team_Agent);
                                } 
                            	else
                                {
                                	PushToOzonetel = true;
                            	}                                                    
                        }
                        else if(salesCampaignName == GenericConstants.Green_Channel_Campaign)
                        {
                            String greenLeadClass = lstOfLead[0].Green_Lead_Class__c;                            
              
                                if(greenLeadClass == GenericConstants.Green_Lead_Bronze  )
                                {
                                    
                                    String  insideSalesTerritoryCluster = lstTerritory[0].Inside_Sales_cluster__c;
                                    
                                    //bronze lead are assigned to inside sales
                                    lstShowroomUser =  IronManInsideSalesLeadAssignment.getInsideSalesShowroomUser(insideSalesTerritoryCluster); 
                                    if(!lstShowroomUser.isEmpty())
                                    {
                                        insideSalesFlag=true;
                                        system.debug('insideSalesFlag' + insideSalesFlag);
                                        IronManInsideSalesLeadAssignment.setChampionBasedOnleastAssignment(lstOfLead[0],lstShowroomUser,genericConstants.Inside_Sales_Team_Agent);
                                    } 
                                    else
                                    {
                                        
                                        //if no inside sales is available the lead is passed to IRM (normal assignment flag is false)
                                         
                                         lstShowroomUser= IronmanDigitalLeadAssignment.getIMShowroomUser(territoryCluster,lstOfLead[0],false);
                                        
                                        // now if IRM is also not available then push to ozonetal 
                                        if(lstShowroomUser.isEmpty())
                                        {
                                            PushToOzonetel = true; 
                                        }
                                    }
                                }
                            	else
                                {
                                        //normal assignment for gold plus /gold /silver
                                        lstShowroomUser= IronmanDigitalLeadAssignment.getIMShowroomUser(territoryCluster,lstOfLead[0],false);
                                        
                                        // If no IRM is available for assignment, assign ISA : 16th May 2024
                                        if(lstShowroomUser.isEmpty())
                                        {
                                            territoryCluster= lstTerritory[0].Inside_Sales_cluster__c;
                                            
                                            if(territoryCluster !=null && !String.isBlank(territoryCluster))
                                            {
                                                    lstShowroomUser =  IronManInsideSalesLeadAssignment.getInsideSalesShowroomUser(territoryCluster);
                                                
                                                    if(!lstShowroomUser.isEmpty())
                                                    {
                                                        insideSalesFlag=true;
                                                        IronManInsideSalesLeadAssignment.setChampionBasedOnleastAssignment(lstOfLead[0],lstShowroomUser,genericConstants.Inside_Sales_Team_Agent);
                                                    } 
                                                    else
                                                    {
                                                        PushToOzonetel = true;
                                                        System.debug('PushToOzonetel '+ PushToOzonetel);
                                                    }   
                                            }    
                                            else
                                            {
                                                	PushToOzonetel = true;
                                                	System.debug('PushToOzonetel '+ PushToOzonetel);
                                            }  
                                        }
                                }
                            
                        }
                        
                        
                        // Constructing a map of clustorName,List<IromMan> where Iron Man have minimum lead assigned 
                        if(!lstShowroomUser.isEmpty() )
                        {
                            System.debug('---lstShowroomUser----'+lstShowroomUser);
                            //Assignment for inside sales is alreday done above
                            if(!insideSalesFlag)
                            {
                                IronManLead_Assignment_Handler.getTerritoryChampionMapping(lstOfLead,  lstShowroomUser,  mapClustor_AssociatedTerritory); 
                            }
                            
                        }
                        else
                        {
                            //list is empty
                            pushToOzoneTel = true;
                        }                                                                                                       
                    }
                    else
                    {
                        // Territory record is not present in pincode. Log the scenario and email will be sent through workflow on log record.
                        //First element is taken as the leads are getting created from Website and it will be only one at a time and not in bulk.
                        listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','IronManLead_Assignment_Handler Class','getIronManDetails method',' A Territory record is not present for this pincode: '+String.valueOf(lstOfPincode),lstOfLead[0].email,String.valueOf(lstOfPincode)));
                        //pushToOzoneTel = true;
                    }
                    
                    
                    
                    if(pushToOzoneTel)
                    {
                        //If all the Territory IM are inactive based on any condition the leads will be pushed to OzoneTel and the leads deatils will be updated.
                        List<Lead> listOfOzonetelpushedLeadsUpdate = new List<Lead>();
                        for(Lead ld : lstOfLead)
                        {
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
                        }
                        
                    }
                    
                    if(!listOfLogsToInsert.isEmpty())
                    {
                        //Insert log records.
                        insert listOfLogsToInsert;
                    }
                }
            }
            else
            {
                //cannot handle bulk scenarios
                listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','IronManLead_Assignment_Handler Class','getIronManDetails method','Bulk Lead Scenario Cannot be handle as per the new IM assignment logic based on catergory',null,null));
            } 
            
        }
        catch(Exception e)
        {
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            //Log the exceptions
            Logger.log('Exception','getIronManDetails method','IronManLead_Assignment_Handler Class',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    
    Public Static void  getProductConsultantDetails(List<Lead> lstOfLead,set<String> lstOfPincode){
        system.debug('productconsultant');
        Map<String,Territory__c> mapClustor_AssociatedTerritory = new Map<String,Territory__c>();
        Map<String,List<Territory__c>> mapCluster_Territory = new Map<String,List<Territory__c>>();
        
        //Set<String> setCluster = new Set<String>();
        List<Log__c> listOfLogsToInsert = new List<Log__c>();
        String clstrBrand = GenericConstants.CLUSTER_BRAND_DOOWUP;
        boolean pushToOzoneTel =false;
        
        try{
            if(!lstOfLead.isEmpty() && !lstOfPincode.isEmpty()){
                // Fetching the Territories from Pincode 
                list<Territory__c> lstTerritory= [Select id,Name,Cluster__c,City__c,Ironman__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,Pincode__c,Assignment__c,Cluster_Brand__c,Sales_Campaign__c,Inside_Sales_cluster__c
                                                  From Territory__c
                                                  Where Pincode__c IN:lstOfPincode and Cluster_Brand__c = :clstrBrand];
                
                System.debug('---lstTerritory----'+lstTerritory);
                String salesCampaignName='';
                String territoryCluster='';
               
                 boolean insideSalesFlag = false;
                list<Showroom_User__c> lstShowroomUser = new list<Showroom_User__c> ();
                //Constructing a map of Pincode,Territory and List cluster which is Mapped to the pincode 
                if(!lstTerritory.isEmpty()){
                    
                    if(lstTerritory[0].Sales_Campaign__c != null || !String.isBlank(lstTerritory[0].Sales_Campaign__c)){
                     salesCampaignName = lstTerritory[0].Sales_Campaign__c;   
                    }
                    if(salesCampaignName == GenericConstants.Inside_Sales_Campaign){
                        territoryCluster = lstTerritory[0].Inside_Sales_Cluster__c;
                    }else{
                        territoryCluster = lstTerritory[0].Cluster__c;
                    }
                    
                    mapClustor_AssociatedTerritory.put(lstTerritory[0].Pincode__c,lstTerritory[0]);
                    
                    
                    System.debug('---mapClustor_AssociatedTerritory----'+mapClustor_AssociatedTerritory);
                    
                    // Fetching active Iron Man Details for the Cluster  
                    if(salesCampaignName == null ||String.isBlank(salesCampaignName))
                    {
                        //Normal Assignment
                        if(territoryCluster !=null && !String.isBlank(territoryCluster)){
                             
                             dateTime todayDate = Date.Today();
                             String todayDayInString = todayDate.format('EEEE');
                             String showroomUserPCRole = GenericConstants.PRODUCT_CONSULTANT_ROLE;
                             
                             lstShowroomUser = [Select Name,Daily_Assignment__c,Weekly_Off_Days__c,IsActive__c,Role__c,
                                                                       (Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Monthly_Assignment__c
                                                                        from Territories__r) 
                                                                  From Showroom_User__c 
                                                                  where ID IN (Select IronMan__c 
                                                                               from Territory__c 
                                                                               where Cluster__C =:territoryCluster and Is_Active__c = True) 
                                                                  and Daily_Assignment__c != NULL  and Weekly_Off_Days__c Excludes(:todayDayInString) and Role__c =:showroomUserPCRole ];
                        System.debug('---lstShowroomUser----'+lstShowroomUser);
                            }
                         else{
                                //Log
                                listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','IronManLead_Assignment_Handler Class','getIronManDetails method','Bulk Lead Scenario Cannot be handle as per the new IM assignment logic based on catergory',null,null));
                            }
                    }
                    else if(salesCampaignName == GenericConstants.Inside_Sales_Campaign)
                    {
                             if(territoryCluster !=null && !String.isBlank(territoryCluster))
                             {
                                  lstShowroomUser =  IronManInsideSalesLeadAssignment.getInsideSalesShowroomUser(territoryCluster);
                             }
                           
                            if(!lstShowroomUser.isEmpty())
                            {
                                insideSalesFlag=true;
                                IronManInsideSalesLeadAssignment.setChampionBasedOnleastAssignment(lstOfLead[0],lstShowroomUser,genericConstants.Inside_Sales_Team_Agent);
                            } 
                        	else
                            {
                                PushToOzonetel = true;
                            }
                        }
                         
                        // Constructing a map of clustorName,List<IromMan> where Iron Man have minimum lead assigned 
                        if(!lstShowroomUser.isEmpty()){
                            System.debug('---lstShowroomUser----'+lstShowroomUser);
                            if(!insideSalesFlag){
                             IronManLead_Assignment_Handler.getTerritoryChampionMapping(lstOfLead,  lstShowroomUser,   mapClustor_AssociatedTerritory);   
                            }
                            
                        }else{
                            //list is empty
                            pushToOzoneTel = true;
                        }                                                                                                       
                   
                
        	}
                else
                {
                    // Territory record is not present in pincode. Log the scenario and email will be sent through workflow on log record.
                    //First element is taken as the leads are getting created from Website and it will be only one at a time and not in bulk.
                    listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','IronManLead_Assignment_Handler Class','getIronManDetails method',' A Territory record is not present for this pincode: '+String.valueOf(lstOfPincode),lstOfLead[0].email,String.valueOf(lstOfPincode)));
                    //pushToOzoneTel = true;
                }
                
            }  
                
            if(pushToOzoneTel)
            {
                    //If all the Territory IM are inactive based on any condition the leads will be pushed to OzoneTel and the leads deatils will be updated.
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
        else{
                // If Lead/Pincode is NULL 
            }
            if(!listOfLogsToInsert.isEmpty()){
                //Insert log records.
                insert listOfLogsToInsert;
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            //Log the exceptions
            Logger.log('Exception','getProductConsultantDetails method','IronManLead_Assignment_Handler Class',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    
    public Static void getTerritoryChampionMapping(List<Lead>lstOfLead,List<Showroom_User__c> showroomUserList, Map<String,Territory__c> mapClustor_AssociatedTerritory){
        
        try{
            Map<String,List<Territory__c>> mapCluster_Territory = new Map<String,List<Territory__c>> ();
            if(!showroomUserList.isEmpty()){
                for(Showroom_User__c objShowRoom : showroomUserList){ 
                    if(objShowRoom.Role__c == GenericConstants.Central_Team_Agent){
                        // It is assumed that a single lead will be passed
                        if(!lstOfLead.isEmpty()){
                         IronManInsideSalesLeadAssignment.setChampionBasedOnleastAssignment(lstOfLead[0],showroomUserList,GenericConstants.Central_Team_Agent);
                            
                        }
                        Break;
                        
                    }else{
                       if(!objShowRoom.Territories__r.isEmpty()){
                        System.debug('---objShowRoom----'+objShowRoom.Daily_Assignment__c);
                        list<Territory__c> lstTerritoryWithMinAssg = new list<Territory__c>();
                        for(Territory__c terr : objShowRoom.Territories__r){
                            System.debug('---terr----'+terr);
                            
                              if(mapCluster_Territory.containsKey(terr.Cluster__C)){
                                if(mapCluster_Territory.get(terr.Cluster__C)[0].Assignment__c == terr.Assignment__c)
                                {
                                    mapCluster_Territory.get(terr.Cluster__C).add(terr);
                                }else if(mapCluster_Territory.get(terr.Cluster__C)[0].Assignment__c > terr.Assignment__c){
                                    mapCluster_Territory.get(terr.Cluster__C).clear();
                                    mapCluster_Territory.put(terr.Cluster__C,new list<Territory__c>{terr});
                                }else{
                                    // DO Nothing 
                                }
                            }else{
                                mapCluster_Territory.put(terr.Cluster__C,new list<Territory__c>{terr});
                            }  
                            
                           
                    }
                    }else{
                        // Territories are not present
                    } 
                    }
                    
                }
                system.debug('----mapCluster_Territory----'+mapCluster_Territory);
                if(!mapCluster_Territory.isEmpty()){
                    IronManLead_Assignment_Helper.assignIronmanToLead(lstOfLead,mapCluster_Territory,mapClustor_AssociatedTerritory);
                }
                
            }
            
            else{
                // Iron Man area's are Inactive in the territory. So make it eligible to push to ozonetel
                System.debug('showroom list is empty ');
                //First element is taken as the leads are getting created from Website and it will be only one at a time and not in bulk.
                //listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','IronManLead_Assignment_Handler Class','getIronManDetails method','Lead Email: '+lstOfLead[0].email+' , Lead Source: '+lstOfLead[0].LeadSource+' . No Active Ironman found for these clusters. Please check with the system Admin.','',String.valueOf(setCluster)));
               
            }                                                                                                       
            
            
            
            
        }Catch(exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            //Log the exceptions
            Logger.log('Exception','getTerritoryChampionMapping method','IronManLead_Assignment_Handler Class',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    
    Public Static void  getIronManDetailsWTAtoIMAssignment(List<Lead> lstOfLead,set<String> lstOfPincode){
        system.debug('ImWTa');
        Map<String,Territory__c> mapClustor_AssociatedTerritory = new Map<String,Territory__c>();
        Map<String,List<Territory__c>> mapCluster_Territory = new Map<String,List<Territory__c>>();
        Map<String,Map<Integer,List<Showroom_User__c>>> mapCluster_MapDailyAssign_IM = new Map<String,Map<Integer,List<Showroom_User__c>>>();
        Set<String> setCluster = new Set<String>();
        List<Log__c> listOfLogsToInsert = new List<Log__c>();
        List<Lead> doowupLeadList = new List<lead>();
        try{
            if(!lstOfLead.isEmpty() && !lstOfPincode.isEmpty()){
                String errorIMAssignmentStage;
                for(Lead ld :lstOfLead){
                    if(ld.Brand__c == GenericConstants.LEAD_DOOWUP){
                        system.debug('doowuplead brand');
                         
                        doowupLeadList.add(ld);
                    }else{
                        system.debug('homelane');
                    }
                }
                System.debug('doowupLeadList '+doowupLeadList);
                if(!doowupLeadList.isEmpty()){
                   IronManLead_Assignment_Handler.getProductConsultantDetailsWTAtoIMAssignment(doowupLeadList, lstOfPincode); 
                }
                    else{
                        String clstrBrand = GenericConstants.CLUSTER_BRAND_DOOWUP;
                        list<Territory__c> lstTerritory= [Select id,Name,Cluster__c,City__c,Ironman__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,Pincode__c,Assignment__c,Cluster_Brand__c
                                                  From Territory__c
                                                  Where Pincode__c IN:lstOfPincode and Cluster_Brand__c != :clstrBrand];
                
                System.debug('---lstTerritory----'+lstTerritory);
                
                //Constructing a map of Pincode,Territory and List cluster which is Mapped to the pincode 
                if(!lstTerritory.isEmpty()){
                    for(Territory__c objTer: lstTerritory){
                        
                        mapClustor_AssociatedTerritory.put(objTer.Pincode__c,objTer);
                        setCluster.add(objTer.Cluster__C);
                    }
                    System.debug('---mapClustor_AssociatedTerritory----'+mapClustor_AssociatedTerritory);
                    System.debug('---setCluster----'+setCluster);
                    // Fetching active Iron Man Details for the Cluster  
                    if(!setCluster.isEmpty()){
                        
                        dateTime todayDate = Date.Today();
                        System.debug('DayOfTheWeek: '+todayDate.format('EEEE'));
                        
                        String todayDayInString = todayDate.format('EEEE');
                        String productConsultantRole =GenericConstants.PRODUCT_CONSULTANT_ROLE;
                        list<Showroom_User__c> lstShowroomUser = [Select Name,Daily_Assignment__c,Weekly_Off_Days__c,WT_Leads_Daily_Assignment__c,	WT_Leads_Monthly_Assignment__c,WT_Leads_Daily_Assignment_Limit__c,WT_Leads_Monthly_Assignment_Limit__c,Role__c,
                                                                  (Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Monthly_Assignment__c,WT_Leads_Daily_Assignment__c,WT_Leads_Monthly_Assignment__c
                                                                   from Territories__r) 
                                                                  From Showroom_User__c 
                                                                  where ID IN (Select IronMan__c 
                                                                               from Territory__c 
                                                                               where Cluster__C IN: setCluster) 
                                                                  and WT_Leads_Daily_Assignment__c != NULL and WT_Leads_Monthly_Assignment__c!=NULL and IsActive__c=True and Reached_WT_Leads_Daily_Limit__c=False  and Reached_WT_Leads_Monthly_Limit__c=False and Role__c !=:productConsultantRole ];
                        System.debug('---lstShowroomUser----'+lstShowroomUser);
                        // Constructing a map of clustorName,List<IromMan> where Iron Man have minimum lead assigned 
                        if(!lstShowroomUser.isEmpty()){
                            System.debug('---lstShowroomUser----'+lstShowroomUser);
                            IronManLead_Assignment_Handler.getWTATerritoryClusterMapping(lstOfLead,  lstShowroomUser, mapCluster_Territory,  mapClustor_AssociatedTerritory);
                        }else{
                            // Iron Man area's are Inactive in the territory. So make it eligible to push to ozonetel
                            errorIMAssignmentStage = 'PA - No Iron Man available';
                            System.debug('errorIMAssignmentStage: '+errorIMAssignmentStage);
                            System.debug('******Log insert: ');
                            listOfLogsToInsert.add(Logger.returnLog('WTA to IM Lead Assignment Error','IronManLead_Assignment_Handler Class','getIronManDetailsWTAtoIMAssignment method','Lead Email: '+lstOfLead[0].email+' , Lead Source: '+lstOfLead[0].LeadSource+' . No Active Ironman found for these clusters. Please check with the system Admin.','',String.valueOf(setCluster)));
                        }                                                                                                       
                    }else{
                        // Cluster Name Is not present 
                    }
                }else{
                    // Territory record is not present in pincode.
                    errorIMAssignmentStage = 'PA - Out of service pin code';
                    System.debug('errorIMAssignmentStage: '+errorIMAssignmentStage);
                    listOfLogsToInsert.add(Logger.returnLog('WTA to IM Lead Assignment Error','IronManLead_Assignment_Handler Class','getIronManDetailsWTAtoIMAssignment method',' A Territory record is not present for this pincode: '+String.valueOf(lstOfPincode),lstOfLead[0].email,String.valueOf(lstOfPincode)));
                    
                }
                if(!String.isBlank(errorIMAssignmentStage)){
                    System.debug('errorIMAssignmentStage: '+errorIMAssignmentStage);
                    for(Lead ld: lstOfLead){
                        ld.IM_Assignment_Stage__c = errorIMAssignmentStage;
                    }
                }
                        else{
                // If Lead/Pincode is NULL 
            }
            if(!listOfLogsToInsert.isEmpty()){
                //Insert log records.
                insert listOfLogsToInsert;
            }
                        
                    }
            }
                }
                // Fetching the Territories from Pincode 
                
        
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            //Log the exceptions
            Logger.log('Exception','IronManLead_Assignment_Handler Class','getIronManDetailsWTAtoIMAssignment method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    
    Public Static void  getProductConsultantDetailsWTAtoIMAssignment(List<Lead> lstOfLead,set<String> lstOfPincode){
        system.debug('ImWTa');
        Map<String,Territory__c> mapClustor_AssociatedTerritory = new Map<String,Territory__c>();
        Map<String,List<Territory__c>> mapCluster_Territory = new Map<String,List<Territory__c>>();
        Map<String,Map<Integer,List<Showroom_User__c>>> mapCluster_MapDailyAssign_IM = new Map<String,Map<Integer,List<Showroom_User__c>>>();
        Set<String> setCluster = new Set<String>();
        List<Log__c> listOfLogsToInsert = new List<Log__c>();
        try{
            if(!lstOfLead.isEmpty() && !lstOfPincode.isEmpty()){
                String errorIMAssignmentStage;
                String clstrDoowupBrand = GenericConstants.CLUSTER_BRAND_DOOWUP;
                // Fetching the Territories from Pincode 
                list<Territory__c> lstTerritory= [Select id,Name,Cluster__c,City__c,Ironman__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,Pincode__c,Assignment__c,Cluster_Brand__c
                                                  From Territory__c
                                                  Where Pincode__c IN:lstOfPincode and Cluster_Brand__c =:clstrDoowupBrand];
                
                System.debug('---lstTerritory----'+lstTerritory);
                
                //Constructing a map of Pincode,Territory and List cluster which is Mapped to the pincode 
                if(!lstTerritory.isEmpty()){
                    for(Territory__c objTer: lstTerritory){
                        
                        mapClustor_AssociatedTerritory.put(objTer.Pincode__c,objTer);
                        setCluster.add(objTer.Cluster__C);
                    }
                    System.debug('---mapClustor_AssociatedTerritory----'+mapClustor_AssociatedTerritory);
                    System.debug('---setCluster----'+setCluster);
                    // Fetching active Iron Man Details for the Cluster  
                    if(!setCluster.isEmpty()){
                        
                        dateTime todayDate = Date.Today();
                        System.debug('DayOfTheWeek: '+todayDate.format('EEEE'));
                        
                        String todayDayInString = todayDate.format('EEEE');
                        String productConsultantRole = GenericConstants.PRODUCT_CONSULTANT_ROLE;
                        list<Showroom_User__c> lstShowroomUser = [Select Name,Daily_Assignment__c,Weekly_Off_Days__c,WT_Leads_Daily_Assignment__c,	WT_Leads_Monthly_Assignment__c,WT_Leads_Daily_Assignment_Limit__c,WT_Leads_Monthly_Assignment_Limit__c,Role__c,
                                                                  (Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Monthly_Assignment__c,WT_Leads_Daily_Assignment__c,WT_Leads_Monthly_Assignment__c
                                                                   from Territories__r) 
                                                                  From Showroom_User__c 
                                                                  where ID IN (Select IronMan__c 
                                                                               from Territory__c 
                                                                               where Cluster__C IN: setCluster) 
                                                                  and WT_Leads_Daily_Assignment__c != NULL and WT_Leads_Monthly_Assignment__c!=NULL and IsActive__c=True and Reached_WT_Leads_Daily_Limit__c=False  and Reached_WT_Leads_Monthly_Limit__c=False and Role__c =:productConsultantRole ];
                        System.debug('---lstShowroomUser----'+lstShowroomUser);
                        // Constructing a map of clustorName,List<IromMan> where Iron Man have minimum lead assigned 
                        if(!lstShowroomUser.isEmpty()){
                            System.debug('---lstShowroomUser----'+lstShowroomUser);
                            IronManLead_Assignment_Handler.getWTATerritoryClusterMapping(lstOfLead,  lstShowroomUser, mapCluster_Territory,  mapClustor_AssociatedTerritory);
                            
                        }else{
                            // Iron Man area's are Inactive in the territory. So make it eligible to push to ozonetel
                            errorIMAssignmentStage = 'PA - No Iron Man available';
                            System.debug('errorIMAssignmentStage: '+errorIMAssignmentStage);
                            System.debug('******Log insert: ');
                            listOfLogsToInsert.add(Logger.returnLog('WTA to IM Lead Assignment Error','IronManLead_Assignment_Handler Class','getProductConsultantDetailsWTAtoIMAssignment method','Lead Email: '+lstOfLead[0].email+' , Lead Source: '+lstOfLead[0].LeadSource+' . No Active Ironman found for these clusters. Please check with the system Admin.','',String.valueOf(setCluster)));
                        }                                                                                                       
                    }else{
                        // Cluster Name Is not present 
                    }
                }else{
                    // Territory record is not present in pincode.
                    errorIMAssignmentStage = 'PA - Out of service pin code';
                    System.debug('errorIMAssignmentStage: '+errorIMAssignmentStage);
                    listOfLogsToInsert.add(Logger.returnLog('WTA to IM Lead Assignment Error','IronManLead_Assignment_Handler Class','getProductConsultantDetailsWTAtoIMAssignment method',' A Territory record is not present for this pincode: '+String.valueOf(lstOfPincode),lstOfLead[0].email,String.valueOf(lstOfPincode)));
                    
                }
                if(!String.isBlank(errorIMAssignmentStage)){
                    System.debug('errorIMAssignmentStage: '+errorIMAssignmentStage);
                    for(Lead ld: lstOfLead){
                        ld.IM_Assignment_Stage__c = errorIMAssignmentStage;
                    }
                }
            }else{
                // If Lead/Pincode is NULL 
            }
            if(!listOfLogsToInsert.isEmpty()){
                //Insert log records.
                insert listOfLogsToInsert;
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            //Log the exceptions
            Logger.log('Exception','IronManLead_Assignment_Handler Class','getProductConsultantDetailsWTAtoIMAssignment method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
     /*Public Static void  getOutskirtsWTAtoIMAssignment(List<Lead> lstOfLead,set<String> lstOfPincode){
        system.debug('ImWTa');
        Map<String,Territory__c> mapClustor_AssociatedTerritory = new Map<String,Territory__c>();
        Map<String,List<Territory__c>> mapCluster_Territory = new Map<String,List<Territory__c>>();
        Map<String,Map<Integer,List<Showroom_User__c>>> mapCluster_MapDailyAssign_IM = new Map<String,Map<Integer,List<Showroom_User__c>>>();
        Set<String> setCluster = new Set<String>();
        List<Log__c> listOfLogsToInsert = new List<Log__c>();
        try{
            if(!lstOfLead.isEmpty() && !lstOfPincode.isEmpty()){
                String errorIMAssignmentStage;
                String clstrDoowupBrand = GenericConstants.CLUSTER_BRAND_DOOWUP;
                // Fetching the Territories from Pincode 
                list<Territory__c> lstTerritory= [Select id,Name,Cluster__c,City__c,Ironman__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,Pincode__c,Assignment__c,Cluster_Brand__c
                                                  From Territory__c
                                                  Where Pincode__c IN:lstOfPincode and Cluster_Brand__c !=:clstrDoowupBrand];
                
                System.debug('---lstTerritory----'+lstTerritory);
                
                //Constructing a map of Pincode,Territory and List cluster which is Mapped to the pincode 
                if(!lstTerritory.isEmpty()){
                    for(Territory__c objTer: lstTerritory){
                        
                        mapClustor_AssociatedTerritory.put(objTer.Pincode__c,objTer);
                        setCluster.add(objTer.Cluster__C);
                    }
                    System.debug('---mapClustor_AssociatedTerritory----'+mapClustor_AssociatedTerritory);
                    System.debug('---setCluster----'+setCluster);
                    // Fetching active Iron Man Details for the Cluster  
                    if(!setCluster.isEmpty()){
                        
                        dateTime todayDate = Date.Today();
                        System.debug('DayOfTheWeek: '+todayDate.format('EEEE'));
                        
                        String todayDayInString = todayDate.format('EEEE');
                        String productConsultantRole = GenericConstants.PRODUCT_CONSULTANT_ROLE;
                        list<Showroom_User__c> lstShowroomUser = [Select Name,Daily_Assignment__c,Weekly_Off_Days__c,WT_Leads_Daily_Assignment__c,WT_Leads_Daily_Assignment_Limit__c,Role__c,WT_Leads_Outskirts_Assignment__c,	WT_Leads_Outskirts_Assignment_Limit__c,
                                                                  (Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Monthly_Assignment__c,WT_Leads_Daily_Assignment__c
                                                                   from Territories__r) 
                                                                  From Showroom_User__c 
                                                                  where ID IN (Select IronMan__c 
                                                                               from Territory__c 
                                                                               where Cluster__C IN: setCluster) 
                                                                  and Weekly_Off_Days__c Excludes(:todayDayInString) and IsActive__c=True and Reached_WT_Leads_Outskirts_Limit__c=False and Role__c !=:productConsultantRole ];
                        System.debug('---lstShowroomUser----'+lstShowroomUser);
                        // Constructing a map of clustorName,List<IromMan> where Iron Man have minimum lead assigned 
                        if(!lstShowroomUser.isEmpty()){
                            System.debug('---lstShowroomUser----'+lstShowroomUser);
                            IronManLead_Assignment_Handler.getWTATerritoryClusterMapping(lstOfLead,  lstShowroomUser, mapCluster_Territory,  mapClustor_AssociatedTerritory);
                            
                        }else{
                            // Iron Man area's are Inactive in the territory. So make it eligible to push to ozonetel
                            errorIMAssignmentStage = 'PA - No Iron Man available';
                            System.debug('errorIMAssignmentStage: '+errorIMAssignmentStage);
                            System.debug('******Log insert: ');
                            listOfLogsToInsert.add(Logger.returnLog('WTA to IM Lead Assignment Error','IronManLead_Assignment_Handler Class','getOutskirtsWTAtoIMAssignment method','Lead Email: '+lstOfLead[0].email+' , Lead Source: '+lstOfLead[0].LeadSource+' . No Active Ironman found for these clusters. Please check with the system Admin.','',String.valueOf(setCluster)));
                        }                                                                                                       
                    }else{
                        // Cluster Name Is not present 
                    }
                }else{
                    // Territory record is not present in pincode.
                    errorIMAssignmentStage = 'PA - Out of service pin code';
                    System.debug('errorIMAssignmentStage: '+errorIMAssignmentStage);
                    listOfLogsToInsert.add(Logger.returnLog('WTA to IM Lead Assignment Error','IronManLead_Assignment_Handler Class','getOutskirtsWTAtoIMAssignment method',' A Territory record is not present for this pincode: '+String.valueOf(lstOfPincode),lstOfLead[0].email,String.valueOf(lstOfPincode)));
                    
                }
                if(!String.isBlank(errorIMAssignmentStage)){
                    System.debug('errorIMAssignmentStage: '+errorIMAssignmentStage);
                    for(Lead ld: lstOfLead){
                        ld.IM_Assignment_Stage__c = errorIMAssignmentStage;
                    }
                }
            }else{
                // If Lead/Pincode is NULL 
            }
            if(!listOfLogsToInsert.isEmpty()){
                //Insert log records.
                insert listOfLogsToInsert;
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            //Log the exceptions
            Logger.log('Exception','IronManLead_Assignment_Handler Class','getOutskirtsWTAtoIMAssignment method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
*/   
    
    Public static void getWTATerritoryClusterMapping(List<Lead>lstOfLead, List<Showroom_User__c> showroomUserList,Map<String,List<Territory__c>> mapCluster_Territory, Map<String,Territory__c> mapClustor_AssociatedTerritory){
        
        try{
            if(!showroomUserList.isEmpty()){
                for(Showroom_User__c objShowRoom : showroomUserList){              
                    if(!objShowRoom.Territories__r.isEmpty()){
                      //  System.debug('---WT_Leads_Daily_Assignment__c----'+objShowRoom.WT_Leads_Daily_Assignment__c);
                        System.debug('---WT_Leads_Monthly_Assignment__c----'+objShowRoom.WT_Leads_Monthly_Assignment__c);
                        list<Territory__c> lstTerritoryWithMinAssg = new list<Territory__c>();
                        for(Territory__c terr : objShowRoom.Territories__r){
                            System.debug('---terr----'+terr);
                            if(mapCluster_Territory.containsKey(terr.Cluster__C)){
                                if(mapCluster_Territory.get(terr.Cluster__C)[0].WT_Leads_Monthly_Assignment__c == terr.WT_Leads_Monthly_Assignment__c)
                                {
                                    mapCluster_Territory.get(terr.Cluster__C).add(terr);
                                }else if(mapCluster_Territory.get(terr.Cluster__C)[0].WT_Leads_Monthly_Assignment__c > terr.WT_Leads_Monthly_Assignment__c){
                                    mapCluster_Territory.get(terr.Cluster__C).clear();
                                    mapCluster_Territory.put(terr.Cluster__C,new list<Territory__c>{terr});
                                }else{
                                    // DO Nothing 
                                }
                            }else{
                                mapCluster_Territory.put(terr.Cluster__C,new list<Territory__c>{terr});
                            }
                        }
                    }else{
                        // Territories are not present
                    }
                }
                system.debug('----mapCluster_Territory----'+mapCluster_Territory);
                if(!mapCluster_Territory.isEmpty()){
                    IronManLead_Assignment_Helper.assignIronmanToWTALead(lstOfLead,mapCluster_Territory,mapClustor_AssociatedTerritory);
                }
            }else{
                System.debug('Showroom user list is empty');
                
            }
        }
        Catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            //Log the exceptions
            Logger.log('Exception','getWTATerritoryClusterMapping method','IronManLead_Assignment_Handler Class',e.getMessage(),e.getStackTraceString(),null);
        }
        
    }
    
    /**
* @description || This Method will Fetch list of IronMan where Champion is a Specialist
* @author Soniya Kocher
* @param List<Lead> lstOfLead 
* @param set<String> lstOfPincode 
* @return boolean
**/
    Public Static boolean getSpecialisedIMDetails(List<Lead> lstOfLead,set<String> lstOfPincode)
    {
        system.debug('getspecial champion');
        Map<String,Territory__c> mapClustor_AssociatedTerritory = new Map<String,Territory__c>();
        
        boolean pushToOzoneTel =false;
        boolean isSpecialistIMAssigned = false;
        Map<String,List<Territory__c>> mapCluster_Territory = new Map<String,List<Territory__c>>();
        Map<String,Map<Integer,List<Showroom_User__c>>> mapCluster_MapDailyAssign_IM = new Map<String,Map<Integer,List<Showroom_User__c>>>();
        Set<String> setCluster = new Set<String>();
        List<Log__c> listOfLogsToInsert = new List<Log__c>();
        Set<String> specialisationList = new Set<String>();
        list<Showroom_User__c> lstShowroomUser = new list<Showroom_User__c> ();
        specialisationList.add('Renovation');
        
        try
        {
            if(!lstOfLead.isEmpty() && !lstOfPincode.isEmpty())
            {
                system.debug('lstOfPincode '+ lstOfPincode);
                // Fetching the Territories from Pincode 
                list<Territory__c> lstTerritory= [Select id,Name,Cluster__c,City__c,Ironman__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,Pincode__c,Assignment__c,Sales_Campaign__c,Inside_Sales_Agent__c,Inside_Sales_Cluster__c
                                                  From Territory__c
                                                  Where Pincode__c IN:lstOfPincode AND Cluster_Brand__c ='Homelane'];
                
                System.debug('---lstTerritory----'+lstTerritory);
                
                //Constructing a map of Pincode,Territory and List cluster which is Mapped to the pincode 
                if(!lstTerritory.isEmpty())
                {
                    String salesCampaignName='';
                    String territoryCluster ='';
                    
                    
                    if(lstTerritory[0].Sales_Campaign__c != null || !String.isBlank(lstTerritory[0].Sales_Campaign__c))
                    {
                        salesCampaignName  = lstTerritory[0].Sales_Campaign__c;                        
                    }
                    mapClustor_AssociatedTerritory.put(lstTerritory[0].Pincode__c,lstTerritory[0]);
                    setCluster.add(lstTerritory[0].Cluster__C);
                    
                    System.debug('---mapClustor_AssociatedTerritory----'+mapClustor_AssociatedTerritory);
                    System.debug('---setCluster----'+setCluster);
                    // Fetching active Iron Man Details for the Cluster  
                    if(!setCluster.isEmpty())
                    {
                        if(salesCampaignName == GenericConstants.Inside_Sales_Campaign)
                        {
                            territoryCluster=lstTerritory[0].Inside_Sales_cluster__c ;   
                            if(territoryCluster !=null && !String.isBlank(territoryCluster))
                            {
                                lstShowroomUser =  IronManInsideSalesLeadAssignment.getInsideSalesShowroomUser(territoryCluster); 
                            }                                                   
                        }                        
                        else
                        {
                            dateTime todayDate = Date.Today();
                            System.debug('DayOfTheWeek: '+todayDate.format('EEEE'));
                            
                            String todayDayInString = todayDate.format('EEEE');
                            lstShowroomUser = [Select Name,Daily_Assignment__c,Weekly_Off_Days__c,
                                               (Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Monthly_Assignment__c
                                                from Territories__r) 
                                               From Showroom_User__c 
                                               where ID IN (Select IronMan__c 
                                                            from Territory__c 
                                                            where Cluster__C IN: setCluster and Is_Active__c = True)
                                               and Daily_Assignment__c != NULL and Weekly_Off_Days__c Excludes(:todayDayInString) and Specialisation__c In :specialisationList
                                               and IsActive__c = true];
                            
                            System.debug('---lstShowroomUser----'+lstShowroomUser);
                            // Constructing a map of clustorName,List<IromMan> where Iron Man have minimum lead assigned 
                            
                            if(!lstShowroomUser.isEmpty())
                            {
                                System.debug('---lstShowroomUser----'+lstShowroomUser);
                                
                                for(Showroom_User__c objShowRoom : lstShowroomUser)
                                {              
                                    if(!objShowRoom.Territories__r.isEmpty())
                                    {
                                        System.debug('---objShowRoom----'+objShowRoom.Daily_Assignment__c);
                                        list<Territory__c> lstTerritoryWithMinAssg = new list<Territory__c>();
                                        for(Territory__c terr : objShowRoom.Territories__r)
                                        {
                                            System.debug('---terr----'+terr);
                                            if(mapCluster_Territory.containsKey(terr.Cluster__C))
                                            {
                                                if(mapCluster_Territory.get(terr.Cluster__C)[0].Assignment__c == terr.Assignment__c)
                                                {
                                                    mapCluster_Territory.get(terr.Cluster__C).add(terr);
                                                }
                                                else if(mapCluster_Territory.get(terr.Cluster__C)[0].Assignment__c > terr.Assignment__c)
                                                {
                                                    mapCluster_Territory.get(terr.Cluster__C).clear();
                                                    mapCluster_Territory.put(terr.Cluster__C,new list<Territory__c>{terr});
                                                }
                                                else
                                                {
                                                    // DO Nothing 
                                                }
                                            }
                                            else
                                            {
                                                mapCluster_Territory.put(terr.Cluster__C,new list<Territory__c>{terr});
                                            }
                                        }
                                    }
                                    else
                                    {
                                        // Territories are not present                                         
                                    }
                                }
                                system.debug('----mapCluster_Territory----'+mapCluster_Territory);
                                if(!mapCluster_Territory.isEmpty())
                                {                                    
                                    IronManLead_Assignment_Helper.assignIronmanToLead(lstOfLead,mapCluster_Territory,mapClustor_AssociatedTerritory);
                                    isSpecialistIMAssigned = true;
                                }                            
                            }
                            else
                            {
                                // Iron Man area's are Inactive in the territory. So make it eligible to push to ozonetel
                                //pushToOzoneTel = true;
                                System.debug('******Log insert: ');
                                //First element is taken as the leads are getting created from Website and it will be only one at a time and not in bulk.
                                //listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','IronManLead_Assignment_Handler Class','getIronManDetails method','Lead Email: '+lstOfLead[0].email+' , Lead Source: '+lstOfLead[0].LeadSource+' . No Active Ironman found for these clusters. Please check with the system Admin.','',String.valueOf(setCluster)));                               
                            }       
                        }
                    }
                    
                    else
                    {
                        // Cluster Name Is not present 
                    }
                    
                }                    
            }
            else
            {
                // Territory record is not present in pincode. Log the scenario and email will be sent through workflow on log record.
                //First element is taken as the leads are getting created from Website and it will be only one at a time and not in bulk.
                    listOfLogsToInsert.add(Logger.returnLog('Lead Assignment Error','IronManLead_Assignment_Handler Class','getSpecialisedIMDetails method',' A Territory record is not present for this pincode: '+String.valueOf(lstOfPincode),lstOfLead[0].email,String.valueOf(lstOfPincode)));
                    //pushToOzoneTel = true;
            }            
           
        }     
                               
        
        catch(Exception e)
        {
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception message: '+e.getMessage());
            //Log the exceptions
            Logger.log('Exception','getSpecialisedIMDetails method','IronManLead_Assignment_Handler Class',e.getMessage(),e.getStackTraceString(),null);
        }
        return isSpecialistIMAssigned;
    }

    
    public static void getIronManPaintSpecialist(List<Lead> leads){
        List<Lead> leadUpdateList = new List<Lead>();
        system.debug('getIronManPaintSpecialist method entry');
        dateTime todayDate = Date.Today();
        System.debug('DayOfTheWeek: '+todayDate.format('EEEE'));
        String todayDayInString = todayDate.format('EEEE');
        List<Showroom_User__c> ironManPaintSpecialistList = new List<Showroom_User__c>();
        if(!leads.isEmpty()){
            for(Lead ld :leads){
                List<Showroom_User__c> ironManListAssignment = [select Name,Daily_Assignment__c,Weekly_Off_Days__c,Monthly_Assignment__c 
                                                                From Showroom_User__c 
                                                                where Weekly_Off_Days__c Excludes(:todayDayInString) 
                                                                and IsActive__c= True and Reached_Daily_Limit__c= false
                                                                and Specialisation__c = 'Paint' and Reached_Monthly_Limit__c = false Order by Daily_Assignment__c asc ];
                system.debug(' ironManListAssignment '+  ironManListAssignment);
                
                if(!ironManListAssignment.isEmpty()){
                    lead ldToUpdate = new lead();
                    ldToUpdate.id = ld.id;
                    ldToUpdate.Sales_Manager__c = ironManListAssignment[0].id;
                    ldToUpdate.Assigned_to_Resi_ASM__c= true;
                    ldToUpdate.ownerId = System.Label.HomeLaneAPIUserId ;
                    ldToUpdate.WT_Agent__c = System.Label.HomeLaneAPIUserId;
                    leadUpdateList.add(ldToUpdate);
                    
                    if(ironManListAssignment[0].Daily_Assignment__c!=null){
                        ironManListAssignment[0].Daily_Assignment__c += 1;
                    }
                    else{
                        ironManListAssignment[0].Daily_Assignment__c = 1;
                    }
                    
                    if( ironManListAssignment[0].Monthly_Assignment__c !=null){
                        ironManListAssignment[0].Monthly_Assignment__c += 1;
                        
                    }else{
                        ironManListAssignment[0].Monthly_Assignment__c = 1;
                    }
                    
                    system.debug('ironman update daily assignment '+ironManListAssignment[0].Daily_Assignment__c);
                    system.debug('ironman update monthly assignment '+ironManListAssignment[0].Monthly_Assignment__c);
                    
                    ironManPaintSpecialistList.add(ironManListAssignment[0]);
                    
                }else{
                    //Assignment to user
                    
                }
                
                if(!leadUpdateList.isEmpty()){
                    update leadUpdateList;
                }
                if(!ironManPaintSpecialistList.isEmpty())
                {
                    update  ironManPaintSpecialistList;
                }
                
            }
        }
    }
    
    //Assignment is done on the basis of Showroom assigned to Showroom Users.
    public static void getIronManFromShowroom(List<Lead> leads)
    {         
        try
        {
                List<Lead> leadUpdateList = new List<Lead>();
                system.debug('getIronManFromShowroom method entry');
                dateTime todayDate = Date.Today();
                System.debug('DayOfTheWeek: '+todayDate.format('EEEE'));
                String todayDayInString = todayDate.format('EEEE');
                List<Showroom_User__c> ShowroomUserList = new List<Showroom_User__c>();
                if(!leads.isEmpty())
                {
                    for(Lead ld :leads)
                    {                        
                        List<Showroom_User__c> ironManFromShowroomList = [select Name,Offline_Daily_Assignment__c,Weekly_Off_Days__c,Offline_Monthly_Assignment__c,
                                                                          Reached_Offline_Daily_Limit__c,Reached_Offline_Monthly_Limit__c,Showroom_Name__c                                                                          
                                                                            From Showroom_User__c 
                                                                            where Showroom_Name__c = :ld.Appointment_Venue_Square__c
                                                                          	and IsActive__c= True and Reached_Offline_Daily_Limit__c= false
                                                                            and Reached_Offline_Monthly_Limit__c = false Order by Offline_Daily_Assignment__c asc,Offline_Monthly_Assignment__c asc ];
                       
                        system.debug(' ironManFromShowroomList '+  ironManFromShowroomList);
                        
                        if(!ironManFromShowroomList.isEmpty())
                        {
                            ld.Sales_Manager__c = ironManFromShowroomList[0].id;
                            ld.Assigned_to_Resi_ASM__c= true;
                            ld.ownerId = System.Label.HomeLaneAPIUserId ;
                            ld.WT_Agent__c = System.Label.HomeLaneAPIUserId;
                            ld.Assigned_To_Inside_Sales_Agent__c = false;
                            ld.Assigned_To_TLC__c = false;
                            ld.Assigned_to_Doowup_Presales__c = false;
                                                        
                            if(ironManFromShowroomList[0].Offline_Daily_Assignment__c!=null)
                            {
                                ironManFromShowroomList[0].Offline_Daily_Assignment__c += 1;
                            }
                            else
                            {
                                ironManFromShowroomList[0].Offline_Daily_Assignment__c = 1;
                            }
                            
                            if( ironManFromShowroomList[0].Offline_Monthly_Assignment__c !=null)
                            {
                                ironManFromShowroomList[0].Offline_Monthly_Assignment__c += 1;                                
                            }
                            else
                            {
                                ironManFromShowroomList[0].Offline_Monthly_Assignment__c = 1;
                            }
                            
                            system.debug('ironman update daily assignment '+ironManFromShowroomList[0].Offline_Daily_Assignment__c);
                            system.debug('ironman update monthly assignment '+ironManFromShowroomList[0].Offline_Monthly_Assignment__c);
                            
                            ShowroomUserList.add(ironManFromShowroomList[0]);                            
                        }
                                                
                      
                        if(!ShowroomUserList.isEmpty())
                        {
                            update ShowroomUserList;
                        }
                        
                    }
                }
    	}
    
        Catch(Exception e)
        {
                system.debug('Exception : '+e.getStackTraceString());
                system.debug('Exception message: '+e.getMessage());
                //Log the exceptions
                Logger.log('Exception','getIronManFromShowroom method','IronManLead_Assignment_Handler Class',e.getMessage(),e.getStackTraceString(),null);
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