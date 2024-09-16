@isTest
Public class Rest_UpdateMeeting_Test{

   public testMethod static void setup1() { 
        Master__c m = new Master__c();
        m.Type__c = 'Showroom';
        m.Avg_Conversion__c = 10;
        m.Total_Opportunities__c = 10;
        m.Total_Won_Opportunity__c = 6;
        m.Avg_Opportunites_Month__c = 20;
        insert m;
        
        Showroom_Target__c st = new Showroom_Target__c();
        st.Name = 'Testdhfj';
        st.Showroom__c = m.Id;
        st.Target_Achieved__c = 0;
        st.Target_Month__c = Date.Today();        
        insert st;
        
        List<Opportunity> oppList = new List<Opportunity>();
        
        Opportunity opp1 = new Opportunity();
        opp1.name = 'first';
        opp1.StageName='Won';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.Opportunity_Status__c = '6.Won';
       // opp1.AccountId = a.id;
        opp1.CloseDate = Date.Today();
       // opp1.Interior_Design_Partner__c = inte.id;
        opp1.Order_Book_Date__c = Date.Today();
        opp1.Amount = 1000;
        opp1.Appointment_Venue_Square__c = m.Id;
        opp1.Order_Closed__c = true;
        opp1.Appointment_Type__c = 'Square Showroom Visit';
        opp1.Time_of_Actual_Appointment_Start__c = Date.Today().addmonths(-1);
        opp1.Order_Book_Date__c = Date.Today().addmonths(-1);
        oppList.add(opp1);
        insert oppList;
        
        try{
        String JSONMsg='[ { "opportunity_id": "'+opp1.id+'","Second_Meeting_Status":"scheduled","Second_Meeting_Time":"2019-07-12T03:00:00+05:30", "Second_Meeting_Start_Time":"2019-07-12T02:00:00+05:30","Second_Meeting_Link":"https://www.google.com/calendar/event?eid=cXRuMnMzMm02OGJqaDVqZ3MzdW9xbnJnbGcgaG9tZWxhbmUuY29tXzM5YWY5OG03ZGtiMmw0MWhsMXVjb2JiNHA0QGc" }]';
        
        RestRequest req = new RestRequest(); // Build the REST Request for testing
        req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
        req.requestURI = '/services/apexrest/UpdateMeeting';
        req.httpMethod = 'POST';        // Perform a POST
        req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
        RestContext.request = req;
        Rest_UpdateMeeting.Rest_UpdateMeeting();
        }
        catch(Exception e){
        }
         
        }    
}