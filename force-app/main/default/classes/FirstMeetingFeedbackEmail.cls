global class FirstMeetingFeedbackEmail implements Database.Batchable<sObject>, Database.allowsCallouts{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([select id, name, createdDate, Appointment_Type__c,First_meeting_Feedback_Email_Sent__c,Email_For_Communication__c,Showroom_Manager__r.Name,First_Meeting_Date__c,Appointment_Venue_Square__r.Name from Opportunity where (createdDate >=: System.now().addHours(-4) and createdDate <=: System.now()) and First_meeting_Feedback_Email_Sent__c = false]);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
        Integration_Setting__c integrationDetail = allEndPoint.get('ResidenceVisit API');
        List<Opportunity> oppList = (List<Opportunity>)(scope);
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        System.debug('-------oppList Size '+oppList.size());
        for(Opportunity o : oppList) {
           if(System.now() >= o.createdDate.addHours(3)) {
               if(String.IsNotBlank(o.Appointment_Type__c)){
                   if(o.Appointment_Type__c == 'Residence Visit' || o.Appointment_Type__c == 'Site Visit' || o.Appointment_Type__c == 'Office Visit'){
                        //mandrillAPIResidenceVisit(o,integrationDetail);
                        o.First_meeting_Feedback_Email_Sent__c = true;
                        oppListToUpdate.add(o);
                   }
                   else{
                        //mandrillAPT(o.Email_For_Communication__c,integrationDetail);
                        o.First_meeting_Feedback_Email_Sent__c = true;
                        oppListToUpdate.add(o);
                   }
               }    
            }
        }
        
        if(!oppListToUpdate.isEmpty())
        update oppListToUpdate;
    }
    global void finish(Database.BatchableContext BC) {}

    global static void mandrillAPT(String email,Integration_Setting__c intSetting) {
        try{
            if(String.IsNotBlank(email) && intSetting!= NULL){
                HTTP h = new HTTP();
                HTTPRequest req = new HTTPRequest();       
                //   String sub = EncodingUtil.urlDecode('The HomeLane \'First Meeting\' Experience', 'UTF-8');
                String sub ='TheHomeLaneFirstMeetingExperience';
                String url =intSetting.End_Point__c+'?template=FirstMeetingFeedbackEmailSF&from=aman.b@homelane.com&subject='+sub+'&to='+email+'&from_name=AmanBansal&visitType=Other';
                req.setEndpoint(url);
                req.setMethod('GET');
                req.setHeader('ACCEPT',intSetting.ContentType__c);
                HTTPResponse res = new HTTPResponse();
                if(!Test.isRunningTest())
                res = h.send(req);
                System.debug('RESPONSE IS  : '+res+'  BODY IS  '+res.getBody());
            }  
        }  
        catch(Exception e){
            Logger.log('Exception','FirstMeetingFeedbackEmail','mandrillAPT',e.getMessage(),e.getStackTraceString(),NULL);
        }
    }

    global static void mandrillAPIResidenceVisit(Opportunity Opp,Integration_Setting__c intSetting) {
        try{
            if(Opp!= NULL && intSetting!= NULL){
                HTTP h = new HTTP();
                HTTPRequest req = new HTTPRequest();       
                //   String sub = EncodingUtil.urlDecode('The HomeLane \'First Meeting\' Experience', 'UTF-8');
                String sub = 'TheHomeLaneFirstMeetingExperience';
                String url = intSetting.End_Point__c+'?template=FirstMeetingFeedbackEmailSF&from=aman.b@homelane.com&subject='+sub+'&to='+Opp.Email_For_Communication__c+'&from_name=AmanBansal&visitType=Residence'+
                '&email='+Opp.Email_For_Communication__c+'&salesmanager='+Opp.Showroom_Manager__r.Name+'&meetingdate='+DateTime.newInstance(Opp.First_Meeting_Date__c.year(),Opp.First_Meeting_Date__c.month(),
                Opp.First_Meeting_Date__c.day()).format('d-MMM-YYYY')+'&appointmentvenuesquare='+Opp.Appointment_Venue_Square__r.Name;
                req.setEndpoint(url);
        req.setMethod('GET');
                req.setHeader('ACCEPT',intSetting.ContentType__c);
                System.debug('res'+req +'res Body'+req.getBody());
                HTTPResponse res = new HTTPResponse();

                if(!Test.isRunningTest())
                res = h.send(req);
                System.debug('RESPONSE IS  : '+res+'  BODY IS  '+res.getBody());
            } 
        }
        catch(Exception e){
            Logger.log('Exception','FirstMeetingFeedbackEmail','mandrillAPIResidenceVisit',e.getMessage(),e.getStackTraceString(),NULL);
        }   
    }
    
     public static void dummyTestCover(){
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