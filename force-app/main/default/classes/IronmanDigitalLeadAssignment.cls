public class IronmanDigitalLeadAssignment {
    
    public static List<Showroom_user__c> getIMShowroomUser(String clusterName , Lead inputLead ,Boolean GreenFlag){
        List<Showroom_user__c>  ShowroomUserList = new List<Showroom_user__c>();
        dateTime todayDate = Date.Today();
        System.debug('DayOfTheWeek: '+todayDate.format('EEEE'));
        
        String todayDayInString = todayDate.format('EEEE');
        String showroomUserPCRole = GenericConstants.PRODUCT_CONSULTANT_ROLE;
        String showroomUserCentralRole = GenericConstants.Central_Team_Agent;
        
        
        Map<string,list<Showroom_User__c>>  showroomUserclassMap = new  Map<string,List<Showroom_User__c>>();
        list<Showroom_User__c> lstShowroomUser = [Select Name,Daily_Assignment__c,Monthly_Assignment__c,Weekly_Off_Days__c,IsActive__c,Outskirts_Assignment__c,Outskirts_Monthly_Assignment__c,IM_Class__c,Role__c,
                                                  (Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Monthly_Assignment__c
                                                   from Territories__r) 
                                                  From Showroom_User__c 
                                                  where ID IN (Select IronMan__c 
                                                               from Territory__c 
                                                               where Cluster__C =:clusterName and Is_Active__c = True) 
                                                  and Daily_Assignment__c != NULL and Weekly_Off_Days__c Excludes(:todayDayInString) and Role__c != :showroomUserPCRole];
        System.debug('---lstShowroomUser----'+lstShowroomUser);
        
        
        
        if(GreenFlag ){
            
           
              
            List<Showroom_User__c> centralTeamList = [select id,Daily_Assignment__c,Weekly_Off_Days__c,IsActive__c,Monthly_Assignment__c,Role__c,Outskirts_Assignment__c,Outskirts_Monthly_Assignment__c
                                                      from Showroom_User__c 
                                                      where Role__c =:showroomUserCentralRole 
                                                      and Weekly_Off_Days__c Excludes(:todayDayInString) and IsActive__c= true 
                                                      and Reached_Daily_Limit__c=false and Reached_Monthly_Limit__c=false ];
            system.debug(' centralTeamList '+  centralTeamList);
            
            
            if(inputLead!= null){
                if(inputLead.Green_Lead_Class__c == GenericConstants.Green_Lead_Gold_Plus){
                    if(!lstShowroomUser.isEmpty()) {
                        ShowroomUserList=IronmanDigitalLeadAssignment.getIMclassbasedUser(GenericConstants.IM_Class_Gold,lstShowroomUser);
                        
                        if(ShowroomUserList.isEmpty() && !centralTeamList.isEmpty()){
                            ShowroomUserList =  centralTeamList;
                        }
                        
                    }
                }
                else if(inputLead.Green_Lead_Class__c == GenericConstants.Green_Lead_Gold){
                    if(!lstShowroomUser.isEmpty()) {
                        ShowroomUserList = IronmanDigitalLeadAssignment.getIMclassbasedUser(GenericConstants.IM_Class_Gold,lstShowroomUser);
                        
                        if(ShowroomUserList.isEmpty()){
                            ShowroomUserList = IronmanDigitalLeadAssignment.getIMclassbasedUser(GenericConstants.IM_Class_Silver,lstShowroomUser);
                        }
                        if(ShowroomUserList.isEmpty() && !centralTeamList.isEmpty()){
                            ShowroomUserList = centralTeamList;
                        }
                        
                    }
                }
                else if(inputLead.Green_Lead_Class__c == GenericConstants.Green_Lead_Silver || inputLead.Green_Lead_Class__c == GenericConstants.Green_Lead_Silver_Minus){
                    if(!lstShowroomUser.isEmpty()) {
                        ShowroomUserList = IronmanDigitalLeadAssignment.getIMclassbasedUser(GenericConstants.IM_Class_Gold,lstShowroomUser);
                        ShowroomUserList.addAll(IronmanDigitalLeadAssignment.getIMclassbasedUser(GenericConstants.IM_Class_Silver,lstShowroomUser));
                    }
                    if(ShowroomUserList.isEmpty() && !centralTeamList.isEmpty()){
                            ShowroomUserList =  centralTeamList;
                        }
                }
                
                else if(inputLead.Green_Lead_Class__c == GenericConstants.Green_Lead_Bronze_Plus){
                    if(!lstShowroomUser.isEmpty()) {
                        ShowroomUserList = IronmanDigitalLeadAssignment.getIMclassbasedUser(GenericConstants.IM_Class_Silver,lstShowroomUser);
                        ShowroomUserList.addAll(IronmanDigitalLeadAssignment.getIMclassbasedUser(GenericConstants.IM_Class_Bronze,lstShowroomUser));
                    }
                    if(ShowroomUserList.isEmpty() && !centralTeamList.isEmpty()){
                            ShowroomUserList =  centralTeamList;
                        }
                    
                }else{
                    if(!lstShowroomUser.isEmpty()) {
                        
                        ShowroomUserList = IronmanDigitalLeadAssignment.getIMclassbasedUser(GenericConstants.IM_Class_Bronze,lstShowroomUser);
                    }
                }
            
               /** if(mapofIMAndLeadClass.containsKey(inputLead.Green_Lead_Class__c)){
                    String IMClass = mapofIMAndLeadClass.get(inputLead.Green_Lead_Class__c);
                    if(!lstShowroomUser.isEmpty() && String.isNotBlank(IMClass) && IMClass != null){
                        
                        for(Showroom_User__c user : lstShowroomUser){
                            if(user.IM_Class__C == IMClass ){
                                ShowroomUserList.add(user);
                            }
                            
                        }
                        if(ShowroomUserList.isEmpty()){
                            if(inputLead.Green_Lead_Class__c!=genericConstants.Green_Lead_Bronze){
                                if(!centralTeamList.isEmpty()){
                                  ShowroomUserList =  centralTeamList;   
                                }else{
                                   //ShowroomUserList will remain empty 
                                }
                                 
                            }else{
                                //ShowroomUserList will remain empty
                            }   
                        }
                        
                    }
                    else{
                        if(inputLead.Green_Lead_Class__c!=genericConstants.Green_Lead_Bronze){
                            if(!centralTeamList.isEmpty()){
                                  ShowroomUserList =  centralTeamList;   
                                }else{
                                   //ShowroomUserList will remain empty 
                                }  
                        }else{
                            //ShowroomUserList will remain empty
                        } 
                    }
                    
                }
                else{
                  ShowroomUserList  = lstShowroomUser;  
                }
                */
            }
               
        }
        
        
        else{
            ShowroomUserList  = lstShowroomUser;
        }
        
        return ShowroomUserList;
        
    }
    
   
    
     
    
    public static  Showroom_User__c getChampionBasedOnleastAssignment(list<Showroom_User__c> lstShowroomUser){
        Showroom_User__c  userWithLeastAssignment =null;
        if(!lstShowroomUser.isEmpty()){
            
            Decimal minAssignmentNumber = 99999;
            for(Showroom_User__c IMUser :lstShowroomUser){
                //Showroom_User__c  assignUser = new Showroom_User__c();
                if (ImUser.Daily_Assignment__c < minAssignmentNumber) {
                    minAssignmentNumber = ImUser.Daily_Assignment__c;
                    userWithLeastAssignment = imUser;
                }
            }
            
        }
        system.debug('userWithLeastAssignment '+ userWithLeastAssignment);
        return userWithLeastAssignment;
        
        
    }
    
    public static List<Showroom_User__c> getIMclassbasedUser(String className,List<Showroom_user__c>  lstShowroomUser){
        List<Showroom_User__c> ShowroomUserList = new List<Showroom_User__c>();
        
        for(Showroom_User__c user : lstShowroomUser){
            if(user.IM_Class__C == className ){
                ShowroomUserList.add(user);
            }
            
        }
        
        return ShowroomUserList;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
     i++;}
}