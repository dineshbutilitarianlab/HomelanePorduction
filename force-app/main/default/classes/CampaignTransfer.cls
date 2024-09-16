public class CampaignTransfer
{    
    @InvocableMethod (Label = 'Transfer Leads to Campaign based on City and Offline Priority value')
   public static void CampaignTransferMethod(List<Id> cc_record_ids)
   {
		   Set<Id> setOfIds = new Set<Id>();
       	   List<lead> leadList = new List<Lead>();
       	   List<Custom_Campaign__c> ccList = new  List<Custom_Campaign__c>();      
       	   List<String> cityList = new List<String>();
       	   List<String> priorityValues = new List<String>();
       	   String CampaignName;
       	   Id CampaignId;
       	   Decimal totalLeads;
       	   String Description;
       	   Custom_Campaign__c ccRecord;
       
           try 
           {       
                ccList = [SELECT id,City__c, Offline_Priority_Values__c,Name,Batch_Process_Description__c,Total_Leads_Processed__c 
                          from Custom_Campaign__c 
                          where id IN :cc_record_ids LIMIT 1];
               
               if(!ccList.isEmpty())
               {
                   if(String.isNotBlank(ccList[0].City__c) && String.isNotBlank(ccList[0].Offline_Priority_Values__c))
                	{
                        CampaignId = ccList[0].Id ;
                        CampaignName = ccList[0].Name ;
                    	cityList =  ccList[0].City__c.split(';'); 
                        priorityValues = ccList[0].Offline_Priority_Values__c.split(';'); 
                        totalLeads = ccList[0].Total_Leads_Processed__c;
                        Description = ccList[0].Batch_Process_Description__c;
                        ccRecord = ccList[0];
                	}                                     
               }
               
               leadList = 	[select id,Lead_Property_Name__c ,City,Property__c,Property__r.Name, Is_Blitz_property_lead__c,Offline_Priority_Lead__c,
                            Lead_Score_for_Assignment__c,LeadSource,Status,Sign_Up_Source__c,Bulk_Upload__c,Pre_Appointment_Date__c,Nimbus_Campaign__c,
                            postalCode,OTP_Verified__c,Meeting_Source__c,Budget_Range__c,Property_Status__c,Green_Lead_Class__c,Relanded_Source__c,Nimbus_Status__c
                            from lead 
                            where Bulk_upload__c=true AND LeadSource = 'Broker/Channel Partner' AND Status = 'Fresh Lead' AND Sub_Status__c = 'New' AND City IN :cityList  
                           	AND  Offline_Priority_Lead__c IN :priorityValues  AND Brand__c != 'Doowup'  AND  Nimbus_Status__c != :GenericConstants.PROCESSED_BY_NIMBUS
                            AND Nimbus_Status__c != :GenericConstants.SENT_TO_NIMBUS LIMIT 500];
               
               system.debug('Leads in try block  '+leadList );
               
               if(!leadList.isEMpty())
               {
                   for(Lead records : leadList)                       
                   {
                       setOfIds.add(records.id);
                   }
                   
                   system.debug('Calling Batch class');
                   CampaignTransferBatch callCampaignBatch = new CampaignTransferBatch(setofIds,CampaignName,CampaignId,totalLeads,Description,ccRecord);
                   Database.executeBatch(callCampaignBatch, 1);
               }   
               else
               {
                   DateTime newDateTime = DateTime.now().addHours(5);
                   newDateTime = newDateTime.addMinutes(30);
                   System.debug('New DateTime: ' + newDateTime);
                            
                   ccRecord.Batch_Process_Description__c = ccRecord.Batch_Process_Description__c + '\n'+'There are no leads to process. Batch is finished at ' + newDateTime ;                            
                                            
                   System.debug('ccRecord :'+ccRecord);
                   System.debug('ccRecord.Batch_Process_Description__c :'+ccRecord.Batch_Process_Description__c);                                                    
                                        
                   update ccRecord;
               }                          
               
           }
               
           catch(QueryException e ) 
           {
                   System.debug('Lead row is not found ');
           }
           
   }  
}