/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Author: Aditya Saini
* Created Date : 27th Jan 2017
* Description : This class will generate json file that will contain all the date wrt all the fileds in the Sobject passed
*               through API - https://homelane--hmldevop.cs6.my.salesforce.com/services/apexrest/Getleadapi?SobjectApiName=Lead.
* ─────────────────────────────────────────────────────────────────────────────────────────────────
**/
@RestResource(urlMapping='/Getleadapi/*')
global with sharing class Getleadapi
{
@HttpGet
  global static list<FinalWrapper>  getLeaddata() {
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        String SobjectApiName = RestContext.request.params.get('SobjectApiName');
        system.debug('testrun');
        system.debug('SobjectApiName'+SobjectApiName);
        List<sObject> leadlist = new List<sObject>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset()){       if(commaSepratedFields == null || commaSepratedFields == ''){       commaSepratedFields = fieldName;   }else{       commaSepratedFields = commaSepratedFields + ', ' + fieldName;   }
        }
        System.debug('List of Lead variables'+commaSepratedFields);
        String query = 'select ' + commaSepratedFields + ' ,Showroom_Manager__r.Name ,Builder_Name__r.name ,Appointment_Venue_Square__r.name from ' + SobjectApiName;
        leadlist = Database.query(query);
        system.debug('leadlist---------------------->'+leadlist);
        system.debug('leadlist.size()---------------------->'+leadlist.size());
        List<Lead> listLead = (List<Lead>)(leadlist);
        for(Lead ld : listLead ){   FinalWrapper fin = new FinalWrapper();fin.CID = ld.Customer_ID__c;fin.Name =ld.Name;fin.Phone = ld.Phone;fin.Status = ld.Status;fin.Id = ld.Id;fin.SubStatus = ld.Sub_Status__c;fin.Altemail = ld.Alt_Email_ID__c;fin.Altphn = ld.Alt_Phone_Number__c;fin.Buildername = ld.Builder_Name__r.name;fin.Appttime= ld.Appointment_Time__c;     fin.Appttype= ld.Appointment_Type__c;     fin.Apptvenuesquare= ld.Appointment_Venue_Square__r.name;     fin.Crocunit= ld.Crockery_Unit__c;     fin.Des= ld.Description__c;     fin.DP= ld.Interior_Designer__c;     fin.Entertainmentunit= ld.Entertainment_Unit__c;     fin.FPRecieve= ld.Floorplan_Received__c;     fin.FPURL= ld.Floorplan_URL__c;     fin.Followuptime= ld.Follow_up_time__c;     fin.Foyer= ld.Foyer_Shoe_Rack__c;     fin.Interiorbudget= ld.Interior_Budget__c;     fin.Interiordate= ld.Interior_Start_Date__c;     fin.kitchen= ld.Kitchen__c;     fin.Pooja= ld.Pooja__c;     fin.SSM= ld.Showroom_Manager__r.Name;     fin.CustomerReasonforCancelling = ld.Customer_s_Reason_for_Cancelling__c;     fin.Customerreasonfornoshow = ld.Customer_s_reason_for_no_show__c;      fin.CustomerReasonforReScheduling= ld.Customer_s_Reason_for_Re_Scheduling__c;     fin.CustomerShowUpTime= ld.Customer_Show_Up_Time__c;     fin.DPReasonForNoShow= ld.DP_Reason_For_No_Show__c;     fin.DPreasontomarkleadasDEADLEAD= ld.DP_s_reason_to_mark_lead_as_DEAD_LEAD__c;     fin.DPReasonForDelayInSendingQuote= ld.DP_s_Reason_For_Delay_In_Sending_Quote__c;     fin.DPpresentforAppointment= ld.DP_present_for_Appointment__c;     fin.DPShowUpTime= ld.DP_Show_Up_Time__c;     fin.CreatedDate = ld.CreatedDate ;     fin.Timeofactualapp = ld.Time_of_Actual_Appointment_Start__c;     fin.Experimentrunning = ld.Experiment_Running__c;     fin.WTAagent = ld.WT_Agent__c;     fin.leadsource = ld.LeadSource;       finalList.add(fin);
        }
      
        return finalList;
     }
     global class FinalWrapper{public String Phone{get;set;}public String Status{get;set;}public String Id{get;set;}public String Name{get;set;}public String SubStatus{get;set;}public String CID{get;set;}public String Altemail{get;set;}public String Altphn{get;set;}public String Buildername {get;set;}public Datetime Appttime{get;set;}public String Appttype{get;set;}public String Apptvenuesquare{get;set;}public String Crocunit{get;set;}public String Des{get;set;}public String DP{get;set;}public String Entertainmentunit{get;set;}public String FPRecieve{get;set;}public String FPURL{get;set;}public Datetime Followuptime{get;set;}public String Foyer{get;set;}public Decimal Interiorbudget{get;set;}public Date Interiordate{get;set;}public String kitchen{get;set;}public String Pooja{get;set;}public String SSM{get;set;}public String CustomerReasonforCancelling {get;set;}public String Customerreasonfornoshow{get;set;}public String CustomerReasonforReScheduling {get;set;}public Datetime CustomerShowUpTime{get;set;}public String DPReasonForNoShow{get;set;}public String DPreasontomarkleadasDEADLEAD{get;set;}public String DPReasonForDelayInSendingQuote{get;set;}public String DPpresentforAppointment{get;set;}public Datetime DPShowUpTime{get;set;}public Datetime CreatedDate{get;set;}public Datetime Timeofactualapp{get;set;}public String Experimentrunning{get;set;}public String WTAagent{get;set;}public String leadsource{get;set;}        
     }
}