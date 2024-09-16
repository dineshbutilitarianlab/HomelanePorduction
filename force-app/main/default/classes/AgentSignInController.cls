public Class AgentSignInController{

public string strPageMessage{get;set;}
public boolean isLoggedIn{get;set;}
public AgentSignInController(){
    
    
}

    public void UpdateUserRoster(){
        try{
            RR_Deactivate_Time__c RRDT = RR_Deactivate_Time__c.getvalues('Daily Time');
        Agent_Roster__c objLeave = [Select Id,User__c,Reporting_Time__c,Login_Active_Status__c From Agent_Roster__c Where Apply_Date__c =: System.Today() AND User__c =: Userinfo.getuserid() Limit 1];
        if(objLeave.Login_Active_Status__c == true){
            strPageMessage = 'You are already logged In.';
        }else{
            Integer ReportTime = Integer.valueof(RRDT.Reporting_Time__c);
            if(objLeave.Reporting_Time__c =='OFF' || objLeave.Reporting_Time__c =='Leave')
                objLeave.Reporting_Time__c = ReportTime+':00 AM';
            objLeave.Login_Active_Status__c = true;
            update objLeave; 
            strPageMessage = 'You have Sucessfully logged In.';         
        }
        isLoggedIn = true;
        }catch(Exception exp){
            strPageMessage ='Your Roster is not updated. Please coordinate with your reporting manager.';
        }
    }
    public void LogOutUser(){
        try{
            RR_Deactivate_Time__c RRDT = RR_Deactivate_Time__c.getvalues('Daily Time');
        Agent_Roster__c objLeave = [Select Id,User__c,Reporting_Time__c,Login_Active_Status__c From Agent_Roster__c Where Apply_Date__c =: System.Today() AND User__c =: Userinfo.getuserid() Limit 1];
        if(objLeave.Login_Active_Status__c == true){
            objLeave.Login_Active_Status__c = false;
            update objLeave; 
            strPageMessage = 'You have Sucessfully logged Out.';         
        }
        isLoggedIn = false;
        }catch(Exception exp){
            strPageMessage ='Your Roster is not updated. Please coordinate with your reporting manager.';
        }
    }

}