@RestResource(urlMapping='/WebHookAPITesting/*')
global with sharing class  WebHookController
{

  @HttpPost
  global static void getRec() {
       RestRequest req = RestContext.request; 
       System.debug(' REQUEST IS : '+req);
       String webhookinput = req.requestBody.toString();  
       webhookinput = webhookinput .replace('"date":', '"customDate":');
       System.debug('******webhookinput *******'+webhookinput );   
       InteriorDesignerWebhookResponse intDesResponse = (InteriorDesignerWebhookResponse) System.JSON.deserialize(webhookinput , InteriorDesignerWebhookResponse.class);  
       system.debug('******intDesResponse *******'+ intDesResponse);     
       system.debug('******label*******'+ intDesResponse.form_response.answers[0].choice.label);        
       system.debug('******RECORD ID *******'+ intDesResponse.form_response.hidden.interiordesignerid);      
       
       try {
       Interior_Designer__c objInt = [select id, name, DP_Status__c, Leave_Start_Date__c, Leave_End_Date__c from Interior_Designer__c where id=:intDesResponse.form_response.hidden.interiordesignerid limit 1];
      
       if(intDesResponse.form_response.answers[0].choice.label == 'I am available to take meetings.') {
           objInt.DP_Status__c = 'Inactive - Available to take meetings';          
       }
       else if(intDesResponse.form_response.answers[0].choice.label == 'On Short Leave.') {
           objInt.DP_Status__c = 'Inactive - On short leave';
           if(intDesResponse.form_response.answers[1].customDate != null) {
               String startDate2 = (String)intDesResponse.form_response.answers[1].customDate;
               List<String> startDateList2 = startDate2.split('-');
               System.debug(startDateList2);
               Date startfinalDate2 = date.newInstance(Integer.valueOf(startDateList2[0]), Integer.valueOf(startDateList2[1]), Integer.valueOf(startDateList2[2]));        
               System.debug('startfinalDate : '+startfinalDate2 );
               objInt.Leave_Start_Date__c = startfinalDate2;
           }
           if(intDesResponse.form_response.answers[2].customDate != null) {
               String endDate2 = (String)intDesResponse.form_response.answers[2].customDate;
               List<String> endDateList2 = endDate2.split('-');
               System.debug(endDateList2);
               Date endfinalDate2 = date.newInstance(Integer.valueOf(endDateList2[0]), Integer.valueOf(endDateList2[1]), Integer.valueOf(endDateList2[2]));        
               System.debug('endfinalDate : '+endfinalDate2 );
               objInt.Leave_End_Date__c = endfinalDate2;
           }
       }
       else if(intDesResponse.form_response.answers[0].choice.label == 'On Long Leave.') {
           objInt.DP_Status__c = 'Inactive - On long leave';
           if(intDesResponse.form_response.answers[1].customDate != null) {
               String startDate3 = (String)intDesResponse.form_response.answers[1].customDate;
               List<String> startDateList3 = startDate3.split('-');
               System.debug(startDateList3);
               Date startfinalDate3 = date.newInstance(Integer.valueOf(startDateList3[0]), Integer.valueOf(startDateList3[1]), Integer.valueOf(startDateList3[2]));        
               System.debug('startfinalDate : '+startfinalDate3 );
               objInt.Leave_Start_Date__c = startfinalDate3;
           }
           if(intDesResponse.form_response.answers[2].customDate != null) {
               String endDate3 = (String)intDesResponse.form_response.answers[2].customDate;
               List<String> endDateList3 = endDate3.split('-');
               System.debug(endDateList3);
               Date endfinalDate3 = date.newInstance(Integer.valueOf(endDateList3[0]), Integer.valueOf(endDateList3[1]), Integer.valueOf(endDateList3[2]));        
               System.debug('endfinalDate : '+endfinalDate3 );
               objInt.Leave_End_Date__c = endfinalDate3;
           }
       }
       else if(intDesResponse.form_response.answers[0].choice.label == 'I have quit HomeLane.') {
           objInt.DP_Status__c = 'Inactive - Quit HL';         
       }
       else if(intDesResponse.form_response.answers[0].choice.label == 'Yes' && intDesResponse.form_response.definition.fields[0].title == 'Will you be available to take meetings.') {
           objInt.DP_Status__c = 'Active - Overloaded available to meetings';         
       }
       else if(intDesResponse.form_response.answers[0].choice.label == 'Busy with 10-40.') {
           objInt.DP_Status__c = 'Inactive- Busy with 10-40';         
       }
       update objInt;
       }
       catch(Exception e) {
           System.debug('The error is : '+e.getMessage());
       }
  }  
}