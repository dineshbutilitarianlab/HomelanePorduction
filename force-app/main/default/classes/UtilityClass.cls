/**
* @File Name          : UtilityClass.cls
* @Description        : 
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 7/31/2019, 2:37:43 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author      		      Modification
*==============================================================================
* 1.0    3/11/2019, 4:56:56 PM   Baibhav Kumar     Initial Version
**/

public class UtilityClass {
    /**
* @description to get Dynamic Querry
* @author Bharatesh Shetty | 7/31/2019
* @param String  objectName
* @return String
*/
    public static String getQueryString(String objectName)
    {
        Map<String, Schema.SObjectType> objMap = new Map<String, Schema.SObjectType>();
        objMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = objMap.get(objectName).getDescribe().fields.getMap();
        string queryString = 'SELECT ';
        for(Schema.SObjectField field :fieldMap.values())
        {
            queryString = queryString + field.getDescribe().getName() + ', ';
           // System.debug('Field :'+field);
        }
        queryString = queryString.substring(0,queryString.length() - 2);
        return queryString;
    }
  
    public static Boolean getLeadHistory(id LdId)
    {
        system.debug('LdId'+ LdId);
       //List<LeadHistory> myHist;
        Boolean deadInLastMonth =false;
        //system.debug('myDate '+ myHist[0].NewValue);
        Date DeadLeadDate;
        List<LeadHistory> lh;
        if(Test.isRunningTest())
        {  
             lh = new List<LeadHistory>{}; //OldValue, NewValue not writeable
             lh.add(new LeadHistory(LeadId=LdId, Field='Status'));            
        }
        else
        {            
        	lh = [SELECT LeadId, CreatedDate, Field, OldValue, NewValue FROM LeadHistory WHERE leadId =:ldId and Field ='Status'] ;
        }
        try
        {
             
           if (!lh.isEmpty())
           {
                 for(LeadHistory ldHist :lh)
                 {
                    if(ldHist.NewValue =='Dead Lead')
                    {
                        DeadLeadDate = date.newinstance(ldHist.CreatedDate.year(), ldHist.CreatedDate.month(), ldHist.CreatedDate.day());
                    }
        		}
                system.debug('Past 30 days date'+ date.today().addDays(-30));
                
                if(DeadLeadDate >=(date.today().addDays(-30)) && DeadLeadDate <=(date.today()))
                {
                     system.debug('DeadLeadDate '+ DeadLeadDate);
                     deadInLastMonth =true;
        		}
       
        	}
            else
            {
                 deadInLastMonth =false;
            }
            system.debug('deadInLastMonth'+deadInLastMonth); 
         }
        catch(Exception e)
        {
                deadInLastMonth =false;
                system.debug(e.getMessage());
        }       
        
        return deadInLastMonth;        
    }
    
     public static Boolean isCP_AssignedRecently(id LeadId, String HL_Referrer_Phone)
     {
         	boolean CP_assigned_recently = false;
        	system.debug('LeadId'+ LeadId);
         
         	Lead ld =[select id, CP_Assignment_Date__c,LeadSource,HL_Referrer_Phone__c,Status,CreatedDate from Lead where id = :LeadId];
         
            system.debug('Past 6 Months'+ date.today().addDays(-180));
         	system.debug('CP_Assignment_Date__c'+ ld.CP_Assignment_Date__c);
            
         
          // This function returns true if CP is assigned in last 6 months
            if(ld.CreatedDate >=(date.today().addDays(-180)))
             //  (String.isNotBlank(ld.HL_Referrer_Phone__c) && ld.HL_Referrer_Phone__c != HL_Referrer_Phone))
            {
                CP_assigned_recently = true;             	
            }
         
         	system.debug('CP_assigned_recently '+ CP_assigned_recently);
         
         	return CP_assigned_recently;
     }
    
     // This function returns true if lead is created in last 2 months
     public static Boolean isLeadCreatedINLast2Months(id LeadId)
     {
         	boolean lead_created_recently = false;
        	system.debug('LeadId'+ LeadId);
         
         	Lead ld =[select id,LeadSource,Status,CreatedDate from Lead where id = :LeadId];
         
            system.debug('Past 2 Months Date'+ date.today().addDays(-60));
         	system.debug('CreatedDate '+ ld.CreatedDate);                   
         
            if(ld.CreatedDate >=(date.today().addDays(-60)))            
            {
                lead_created_recently = true;             	
            }
         
         	system.debug('lead_created_recently '+ lead_created_recently);
         
         	return lead_created_recently;
     }
    
}