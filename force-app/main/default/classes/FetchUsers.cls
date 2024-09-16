global class FetchUsers  {
    Public FetchUsers(){}
    Public FetchUsers(Object o){}
    
    public String loginUserImg {
        get{
            return GeneralInformation.generalInfo.loginUserImg;   
        } 
    }
    
    @RemoteAction
    global static List<Object> searchUserNgrps(String filter){
        List<List<Object>> usernGrps = new List<List<Object>>();
        usernGrps.add(AWS_Utility.findUserInDB(filter, 10, new set<Id>()));
        usernGrps.add(AWS_Utility.findGroupInDB(filter, 10)); 
        return usernGrps;
    }  

    @RemoteAction
    global static List<List<AWS_Utility.UserWrap>> searchUsers(String filter){
        List<List<AWS_Utility.UserWrap>> usernGrps = new List<List<AWS_Utility.UserWrap>>(); 
        usernGrps.add(AWS_Utility.findUserInDB(filter, 10, new set<Id>()));
        system.debug('--------------usernGrps----------------'+usernGrps);
        return usernGrps;
        
    }

}