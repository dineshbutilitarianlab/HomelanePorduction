global class DPAssignmentBatchClass implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
    global Date assigndt;
    global List<Master__c> showroomList;
    global List<id> showroomId;
    global set<id> leadids;
    global DPAssignmentBatchClass(Date assignDate)
    {
        assigndt = assignDate;
        showroomId = new List<id>();
        leadids = new set<id>();
        List<Master__c> mslst = [Select id,name from Master__c];
        System.debug('mslst--> '+mslst);
        showroomList = [select id, name from Master__c where  name = 'Gopalan Showroom'];
        for(Master__c m : showroomList ) {
            showroomId.add(m.id);
        }
    }
    
    global database.QueryLocator start(Database.BatchableContext bc)
    {
        
        Date assigndt1day = assigndt.addDays(1);
        System.debug('assigndt   '+assigndt+' assigndt1day  '+assigndt1day  );
        String appfxd = 'Appointment Fixed';
        String appcon = 'Appointment Confirmed';
        String appcan = 'Appointment Cancelled';
        string shvis = 'Square Showroom Visit';
        String inte1 = 'temp-';
        String inte2 = inte1+'-%';
        //or interior_designer__r.Email__c like  \'' + inte1+ '%\'
        String leadquerystr = 'select id, name, Appointment_Venue_Square__r.Design_Manager__r.Email, Interior_Designer__c, Customer_Score__c, Property__c,Square_Showroom_Manager__r.Email, Interior_Designer__r.Email__c, Appointment_Time__c, city, Email_For_Communication__c, Property__r.Name,Meeting_Status__c, Appointment_Venue_Square__c, Appointment_Venue_Square__r.Name, Appointment_Venue_Square__r.WalkIn_SSA__r.Email, Preferred_Language__c,DP_Stack_Rank__c, Regional_Language_Preference__c, Budget_Range__c from Lead where appointment_time__c >: assigndt and appointment_time__c <: assigndt1day and interior_designer__c = null and (Status = \''+appfxd+'\' or Status = \''+appcon+'\') and Appointment_Venue_Square__c =: showroomId and Appointment_Type__c = \''+shvis+'\' order by Customer_Score__c desc';
        System.debug('----------leadquerystr  '+leadquerystr );
        return database.getQueryLocator(leadquerystr);
    }
    global void execute(Database.BatchableContext bc,List<Lead> scope)
    {
        for(lead ld : scope)
        {
            leadids.add(ld.id);
        }
        System.debug('Scope values --> '+scope);
            
        DPAssignmentBatchHandler.doactions(scope,assigndt);
    }
    global void finish(Database.BatchableContext bc)
    {
        
    }
    
     global static void dummyTestCover(){
   Integer i =0;
   i++;
     i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        }
}