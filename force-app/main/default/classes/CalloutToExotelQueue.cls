public class CalloutToExotelQueue {
   
    @InvocableMethod
   public static void CallExotelAPI(List<Id> LeadIds )
   {
       List<lead> leadList = new List<Lead>();
           try 
           {                
                leadList = [select id,Lead_Property_Name__c ,City,Property__c,Assigned_to_Resi_ASM__c,Sales_Manager__c,Description,Description__c,
                                  Sales_Manager__r.Phone__c, Phone, Property__r.Name, Is_Blitz_property_lead__c,Auto_Dialled__c,Sales_Manager__r.Exotel_Phone_Number__c,
                                  Lead_Score_for_Assignment__c,LeadSource,Status,Sign_Up_Source__c,Bulk_Upload__c,Pre_Appointment_Date__c,
                                  postalCode,OTP_Verified__c,Meeting_Source__c,Budget_Range__c,Property_Status__c,Green_Lead_Class__c
                                  from lead where  id IN :LeadIds];
               
                system.debug('Leads in try block  '+leadList );
                ExotelAPICalloutQueueable objLPA = new ExotelAPICalloutQueueable(leadList,UserInfo.getSessionId());
                ID jobID = System.enqueueJob(objLPA);
           }
               
           catch(QueryException e ) 
           {
                   System.debug('Lead row is not found ');
           }
           
   }  
}