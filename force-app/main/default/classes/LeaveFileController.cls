public class LeaveFileController 
{
    public transient string nameFile{get;set;}
    public transient Blob contentFile{get;set;}
    transient String[] filelines = new String[]{};
    Map<String,String> mapCity= new Map<String,String>();
    Map<String,String> maproundRobin= new Map<String,String>();
    Map<String,String> mapUserName= new Map<String,String>();
    public boolean isError{get;set;}
    //List<displayData> accstoupload;
    
    public LeaveFileController(){
        
        for(Round_Robin__c objRR : [Select Id,Name from Round_Robin__c]){
            maproundRobin.put(objRR.Name,objRR.Id);
        }
        
        for(User objUser : [Select Name,Id from User Where Profile.Name IN ('WTA Profile','WTM Profile')]){
            system.debug('----objUser---'+objUser);
            mapUserName.put(objUser.Name,objUser.Id);
        }
        system.debug('----mapUserName---'+mapUserName);
        Queue_Custom_Setting__c QCS = Queue_Custom_Setting__c.getValues('Lead Queue');
        for(String strQueue : QCS.Queue_Setting__c.split(',')){
            String[] queueData = strQueue.split(':');
            mapCity.put(queueData[0],queueData[1]);
            
        }
      system.debug('-------maproundRobin------'+maproundRobin+'-----------mapUserName--------------'+mapUserName+'--------mapCity-------'+mapCity); 
    }
    
    public Pagereference ReadFile()
    {
       if(Test.isRunningTest()){
          String strDate = 'City,Names,2017-12-19<@>BLR,TesWT1,9:00 AM<@>BLR,TesWT2,9:00 AM<@>BLR,TesWT3,10:00 AM';
          filelines = strDate.split('<@>');
       }          
       else{           
         nameFile=contentFile.toString();
         filelines = nameFile.split('\n');
       }
       system.debug('-------contentFile------'+contentFile);
         system.debug('-------nameFile------'+nameFile);
        List<Agent_Roster__c> listLeaveUser = new List<Agent_Roster__c>();
        String[] dateArray = filelines[0].split(',');
        system.debug('-------dateArray------'+dateArray);
       
        for (Integer i=1;i<filelines.size();i++)
        {
            String[] inputvalues = new String[]{};
            inputvalues = filelines[i].split(',');
            for(Integer j=2;j<inputvalues.size();j++){
                Agent_Roster__c objLH = new Agent_Roster__c();
                objLH.Apply_Date__c = Date.valueof(dateArray[j]);
                objLH.Login_Active_Status__c = false;
                objLH.Round_Robin__c = maproundRobin.get(mapCity.get(inputvalues[0]));
                objLH.Reporting_Time__c = inputvalues[j];
                system.debug('----inputvalues[1]---'+inputvalues[1]);
                objLH.User__c = mapUserName.get(inputvalues[1]);
                listLeaveUser.add(objLH);
            }
               
        }
            
            system.debug('---listLeaveUser----'+listLeaveUser);

        try
        {
         insert listLeaveUser;
        }
        catch (Exception e)
        {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the Problem Type colum template or try again later');
            ApexPages.addMessage(errormsg);
            isError = true;
        }
        
               
        return null;
    }
     
    public pageReference ReloadPage()
    {
       pageReference pageObj = new pageReference('/apex/RosterUploadVF');
       pageObj.setRedirect(true);
       return pageObj;
    
    }
     
    
}