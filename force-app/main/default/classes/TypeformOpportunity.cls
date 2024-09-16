@RestResource(urlMapping='/TypeformOpportunity/*')
global class TypeformOpportunity {
    @HttpPost
    global static void Typeform() {
        RestRequest req = RestContext.request;
        System.debug(' REQUEST IS : '+req);
        String type = req.requestBody.toString();
        System.debug('******type*******'+type ); 
        TypeformOpportunityJson2Apex typeResponse = (TypeformOpportunityJson2Apex) System.JSON.deserialize(type , TypeformOpportunityJson2Apex.class);  
        system.debug('******typeResponse*******'+ typeResponse); 
        system.debug('******label*******'+ typeResponse.form_response.answers[0].choice.label);   
        try {
            Opportunity opp = [select id, name, Meeting_Stage__c, Meeting_Response__c, No_of_Meetings_Done__c, Second_Meeting_Time__c from Opportunity where id=:typeResponse.form_response.hidden.opportunityid limit 1];
          
            if(opp.Meeting_Stage__c == 'Discussion Meeting Fixed' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '1' && typeResponse.form_response.answers[0].choice.label == 'Yes') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = 1;
                opp.No_of_Meetings_Done__c = '2';
            }
            else if(opp.Meeting_Stage__c == 'Discussion Meeting Fixed' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '1' && typeResponse.form_response.answers[0].choice.label == 'No') {
                opp.Meeting_Stage__c = 'First Meeting Done';
                opp.Meeting_Response__c = -1;
                opp.No_of_Meetings_Done__c = '1';
            }
            // No_of_Meetings_Done__c == '2'
            if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '2' && typeResponse.form_response.answers[0].choice.label == 'Yes') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = 1;
                opp.No_of_Meetings_Done__c = '3';
            }
            else if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '2' && typeResponse.form_response.answers[0].choice.label == 'No') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = -1;
                opp.No_of_Meetings_Done__c = '2';
            }
            // No_of_Meetings_Done__c == '3'
            if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '3' && typeResponse.form_response.answers[0].choice.label == 'Yes') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = 1;
                opp.No_of_Meetings_Done__c = '4';
            }
            else if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '3' && typeResponse.form_response.answers[0].choice.label == 'No') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = -1;
                opp.No_of_Meetings_Done__c = '3';
            }
            // No_of_Meetings_Done__c == '4'
            if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '4' && typeResponse.form_response.answers[0].choice.label == 'Yes') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = 1;
                opp.No_of_Meetings_Done__c = '5';
            }
            else if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '4' && typeResponse.form_response.answers[0].choice.label == 'No') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = -1;
                opp.No_of_Meetings_Done__c = '4';
            }
            // No_of_Meetings_Done__c == '5'
            if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '5' && typeResponse.form_response.answers[0].choice.label == 'Yes') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = 1;
                opp.No_of_Meetings_Done__c = '6';
            }
            else if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '5' && typeResponse.form_response.answers[0].choice.label == 'No') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = -1;
                opp.No_of_Meetings_Done__c = '5';
            }
            // No_of_Meetings_Done__c == '6'
            if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '6' && typeResponse.form_response.answers[0].choice.label == 'Yes') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = 1;
                opp.No_of_Meetings_Done__c = '7';
            }
            else if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '6' && typeResponse.form_response.answers[0].choice.label == 'No') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = -1;
                opp.No_of_Meetings_Done__c = '6';
            }
            // No_of_Meetings_Done__c == '7'
            if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '7' && typeResponse.form_response.answers[0].choice.label == 'Yes') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = 1;
                opp.No_of_Meetings_Done__c = '8';
            }
            else if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '7' && typeResponse.form_response.answers[0].choice.label == 'No') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = -1;
                opp.No_of_Meetings_Done__c = '7';
            }
            // No_of_Meetings_Done__c == '8'
            if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '8' && typeResponse.form_response.answers[0].choice.label == 'Yes') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = 1;
                opp.No_of_Meetings_Done__c = '9';
            }
            else if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '8' && typeResponse.form_response.answers[0].choice.label == 'No') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = -1;
                opp.No_of_Meetings_Done__c = '8';
            }
            // No_of_Meetings_Done__c == '9'
            if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '9' && typeResponse.form_response.answers[0].choice.label == 'Yes') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = 1;
                opp.No_of_Meetings_Done__c = '10';
            }
            else if(opp.Meeting_Stage__c == 'Second Meeting Done' && opp.Meeting_Response__c == 0 && opp.No_of_Meetings_Done__c == '9' && typeResponse.form_response.answers[0].choice.label == 'No') {
                opp.Meeting_Stage__c = 'Second Meeting Done';
                opp.Meeting_Response__c = -1;
                opp.No_of_Meetings_Done__c = '9';
            }
         
            update opp;
        }
        catch(Exception e) {
             System.debug('The error is : '+e.getMessage());
        }           
    }
}