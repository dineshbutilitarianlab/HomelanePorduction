public class CallOutToSolrQueue{
    
    @InvocableMethod
   public static void CallSolrAPI(List<Id> LeadIds )
   {
       List<lead> leadList = new List<Lead>();
           try 
           {                
                leadList = [select id,Lead_Property_Name__c ,City,Property__c,Lead_Score_for_Assignment__c,LeadSource,Status,Sign_Up_Source__c,
                                  Property__r.Name, Is_Blitz_property_lead__c,Is_Premium_property_lead__c,Bulk_Upload__c,Pre_Appointment_Date__c,                                  
                                  postalCode,OTP_Verified__c,Meeting_Source__c,Budget_Range__c,Property_Status__c,Green_Lead_Class__c,Relanded_Source__c
                                  from lead where id IN :LeadIds];
               
                system.debug('Leads in try block  '+leadList );
                SolarAPICalloutQueueable objLPA = new SolarAPICalloutQueueable(leadList,UserInfo.getSessionId());
                ID jobID = System.enqueueJob(objLPA);
           }
               
           catch(QueryException e ) 
           {
                   System.debug('Lead row is not found ');
           }
           
   }  
}