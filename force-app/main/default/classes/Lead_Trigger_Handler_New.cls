public class Lead_Trigger_Handler_New 
{
    
    //This method is updating the Description if External user is sending data through API.
	public static void updateDescriptionForExternalUser(List<Lead> listOfLeads, Map<Id,Lead> OldMap)
    {
        
        //Returns the context user's login name.
        String UserName = UserInfo.getUserName();
        System.Debug('UserName-' + UserName);
        String OldDesc;
        String NewDesc;
        List<lead> LeadList = new List<lead>();
    	try
        {
            for(Lead ld:listOfLeads)
            {
                if(!String.isBlank(OldMap.get(ld.id).Description) && UserName == System.Label.External_User_Name)
                {
                        OldDesc = (OldMap.get(ld.id).Description).deleteWhitespace();
                        NewDesc = (ld.Description).deleteWhitespace();
                     
                        if(OldMap.get(ld.id).Description != ld.Description && !String.isBlank(ld.Description) && !(OldDesc.equals(NewDesc)))
                        {
                            ld.Description = OldMap.get(ld.id).Description + '\n' + ld.Description;
                        }
                }
            }     
             
        }
        Catch(Exception e)
        {
            Logger.log('Exception','Lead_Trigger_Handler_New Class','updateDescriptionForExternalUser method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
}