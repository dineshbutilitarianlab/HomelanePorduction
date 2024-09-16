/**
 * @File Name          : SendEmailBatchToSM_BU.cls
 * @Description        : 
 * @Author             : Bharatesh Shetty
 * @Group              : 
 * @Last Modified By   : Bharatesh Shetty
 * @Last Modified On   : 9/23/2019, 5:28:32 PM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                Modification
 *==============================================================================
 * 1.0    9/20/2019, 12:56:20 PM   Bharatesh Shetty     Initial Version
**/
global class SendEmailBatchToSM_BU implements Database.Batchable<sObject>,Database.AllowsCallouts,Schedulable{

    global database.QueryLocator start(Database.BatchableContext bc)
    {
        Datetime dNow = datetime.now();
        String sQuery = 'Select Id,Name,Customer_ID__c,Appointment_Type__c,Appointment_Time__c,Appointment_Venue_Square__r.Pilot_ShowRoom__c,Interior_Designer__c,'+
                        'VirtualMeeting_Reminder_Email_Sent__c,Appointment_Venue_Square__r.Showroom_Manager__r.Name,' +
                        'Possession_Date__c,Area_Of_Residence__r.Name,Property__r.Name,Appointment_Venue_Square__r.BU_Head__r.Email__c,'+
                        'Appointment_Venue_Square__r.Showroom_Manager__r.Email__c,Appointment_Venue_Square__r.BU_Head__r.Name,'+
                        'WT_Agent__r.Email,WT_Agent__r.Name,Schedule_a_meeting_on_Acuity_v2__c,Phone,Email,Floorplan_URL__c,'+ 
                        'Appointment_Venue_Square__r.Sales_Manager_Virtual_Meeting__r.Name,'+  
                        'Appointment_Venue_Square__r.Sales_Manager_Virtual_Meeting__r.Email__c from Lead '+ 
                        'Where Appointment_Type__c = \'Virtual Meeting\' and Appointment_Venue_Square__r.Pilot_ShowRoom__c = true and '+
                        'Interior_Designer__c = NULL and Appointment_Time__c !=NULL and Status= \'Appointment Fixed\' and '+
                        'Appointment_Time__c >=: dNow and Test_Flag__c = false' ;
                        system.debug('sQuery'+sQuery);
        return database.getQueryLocator(sQuery);
    }
    
    global void execute(Database.BatchableContext bc,List<Lead> scope)
    {
        try{
            list<Lead> lstLead = new List<Lead>();
            Lead retLead = new Lead();
            list<OrgWideEmailAddress> lstowa = new list<OrgWideEmailAddress>();
            OrgWideEmailAddress fromAddress = new OrgWideEmailAddress();
            List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();

            List<EmailTemplate> emaList = [select id, name, subject, DeveloperName,HtmlValue from EmailTemplate 
                                            where DeveloperName = 'Virtual_Meeting_Reminder_Mail_SM' OR 
                                            DeveloperName = 'Virtual_Meeting_Reminder_Mail_SM_BU' OR 
                                            DeveloperName = 'Virtual_Meeting_Reminder_Mail_WTA'];
            System.debug('*****emaList  '+emaList.Size());
            Map<String,EmailTemplate> emaMap = new Map<String,EmailTemplate>();
            for(EmailTemplate e : emaList) {
            emaMap.put(e.DeveloperName,e);
            }

            lstowa = [select id, Address, DisplayName from OrgWideEmailAddress where address = 'assign-dp@homelane.com' limit 1];
            String sPortalId = [Select id from Network where Name = 'Homelane-c' ].id;

            if(lstowa != NULL && !lstowa.isEmpty()){
                fromAddress = lstowa[0];
            }

            for(Lead ObjLead : scope){
               /* 
                retLead = SendEmailBatchToSM_BU_Handler.makeCallOut(ObjLead);
                if(retLead != NULL){
                     lstLead.add(retLead);
                }
                */
             
                /*system.debug('VirtualMeeting'+ObjLead.VirtualMeeting_Reminder_Email_Sent__c.addHours(Integer.ValueOf(Label.SendEmailBatch_ProcessNextEmail_Hours))+' Time Now'+System.now());
                system.debug('VirtualMeeting'+ObjLead.VirtualMeeting_Reminder_Email_Sent__c.addHours(Integer.ValueOf(Label.SendEmailBatch_ProcessNextEmail_Hours)).addMinutes(Integer.ValueOf(Label.SendEmailBatch_ProcessNextEmail_Minute)) +' Time Now'+System.now());
        */
                String loginLink = Label.Rosters_login_Url+ObjLead.email;
                if(ObjLead.VirtualMeeting_Reminder_Email_Sent__c == NULL || 
                (ObjLead.VirtualMeeting_Reminder_Email_Sent__c.addHours(Integer.ValueOf(Label.SendEmailBatch_ProcessNextEmail_Hours))) <=System.now().addMinutes(Integer.ValueOf(Label.SendEmailBatch_ProcessNextEmail_Minute)) ||
                ObjLead.Appointment_Time__c <= System.now().addHours(Integer.ValueOf(Label.SendEmailBatch_WTA))){
                    system.debug('Inside the Message condition');
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                     system.debug('VirtualMeeting'+ObjLead.Appointment_Time__c.addHours(Integer.ValueOf(Label.SendEmailBatch_WTA))+' Time Now'+System.now());
                    if(ObjLead.Appointment_Time__c <= System.now().addHours(Integer.ValueOf(Label.SendEmailBatch_WTA))){
                        message.toAddresses = new String[] {ObjLead.Appointment_Venue_Square__r.Showroom_Manager__r.Email__c,ObjLead.Appointment_Venue_Square__r.BU_Head__r.Email__c,objLead.Appointment_Venue_Square__r.Sales_Manager_Virtual_Meeting__r.Email__c} ; 
                        //message.ccAddresses = new String[] {str.SSMEmail, str.SSAEmail};
                        message.setOrgWideEmailAddressId(fromAddress.id);
                        message.optOutPolicy = 'FILTER';       
                        message.setHtmlBody(emaMap.get('Virtual_Meeting_Reminder_Mail_WTA').HtmlValue
                                            .replace('{!Lead.Name}', String.ValueOF('<a href="'+loginLink+'">'+ObjLead.Name+'</a>' ))
                                            .replace('{!Lead.Customer_ID__c}',ObjLead.Customer_ID__c).replace('{!Date}',String.ValueOf(objLead.Appointment_Time__c.dateGMT()))
                                            .replace('{!Day}',objLead.Appointment_Time__c.format('EEEE')).replace('{!Time}',String.ValueOf(objLead.Appointment_Time__c.format('h:mm a')))                
                                            .replace('{!Lead.SM_Name}',String.Valueof(objLead.Appointment_Venue_Square__r.Showroom_Manager__r.Name))
                                            .replace('{!Lead.Sales_Manager_Name}',String.Valueof(objLead.Appointment_Venue_Square__r.Sales_Manager_Virtual_Meeting__r.Name))
                                            .replace('{!Lead.Acuity}',String.Valueof('<a href="'+objLead.Schedule_a_meeting_on_Acuity_v2__c+'">'+'this link'+'</a>' ))); 
                        message.setTemplateId(emaMap.get('Virtual_Meeting_Reminder_Mail_WTA').Id);   
                        message.subject = emaMap.get('Virtual_Meeting_Reminder_Mail_WTA').subject.replace('{!Lead.Customer_ID__c}',objLead.Customer_ID__c);     
                        lstMails.add(message);   
                        System.debug('message'+message);
                        ObjLead.VirtualMeeting_Reminder_Email_Sent__c = System.now();
                        lstLead.add(ObjLead);                                                 
                    }
                    else if(ObjLead.Appointment_Time__c <= System.now().addHours(Integer.ValueOf(Label.SendEmailBatch_BU_Email))){
                        system.debug('objLeadobjLead'+objLead.Appointment_Venue_Square__r.BU_Head__r.Name);
                        message.toAddresses = new String[] {ObjLead.Appointment_Venue_Square__r.Showroom_Manager__r.Email__c,ObjLead.Appointment_Venue_Square__r.BU_Head__r.Email__c,objLead.Appointment_Venue_Square__r.Sales_Manager_Virtual_Meeting__r.Email__c} ; 
                        //message.ccAddresses = new String[] {str.SSMEmail, str.SSAEmail};
                        message.setOrgWideEmailAddressId(fromAddress.id);
                        message.optOutPolicy = 'FILTER';       
                        message.setHtmlBody(emaMap.get('Virtual_Meeting_Reminder_Mail_SM_BU').HtmlValue
                                            .replace('{!Lead.Name}', String.ValueOF('<a href="'+loginLink+'">'+ObjLead.Name+'</a>' ))
                                            .replace('{!Lead.Customer_ID__c}',ObjLead.Customer_ID__c).replace('{!Date}',String.ValueOf(objLead.Appointment_Time__c.dateGMT()))
                                            .replace('{!Day}',objLead.Appointment_Time__c.format('EEEE')).replace('{!Time}',String.ValueOf(objLead.Appointment_Time__c.format('h:mm a')))
                                            .replace('{!Lead.ProjectName}',String.isNotBlank(objLead.Property__r.Name)?objLead.Property__r.Name:'')
                                            .replace('{!Lead.Location}',String.isNotBlank(objLead.Area_Of_Residence__r.Name)?objLead.Area_Of_Residence__r.Name:'')
                                            .replace('{!Lead.PossessionDate}',String.isNotBlank(String.Valueof(objLead.Possession_Date__c))?String.Valueof(objLead.Possession_Date__c):'')
                                            .replace('{!Lead.BU_Name}',String.Valueof(objLead.Appointment_Venue_Square__r.BU_Head__r.Name))
                                            .replace('{!Lead.Sales_Manager_Name}',String.Valueof(objLead.Appointment_Venue_Square__r.Sales_Manager_Virtual_Meeting__r.Name))
                                            .replace('{!Lead.Phone}',objLead.Phone)
                                            .replace('{!Lead.Email}',objLead.Email)
                                            .replace('{!Lead.FloorPlan}',String.isNotBlank(objLead.Floorplan_URL__c)?objLead.Floorplan_URL__c:'')
                                            ); 
                        message.setTemplateId(emaMap.get('Virtual_Meeting_Reminder_Mail_SM_BU').Id);   
                        message.subject = emaMap.get('Virtual_Meeting_Reminder_Mail_SM_BU').subject.replace('{!Lead.Customer_ID__c}',objLead.Customer_ID__c);     
                        lstMails.add(message);   
                        System.debug('message'+message);
                        ObjLead.VirtualMeeting_Reminder_Email_Sent__c = System.now();
                        lstLead.add(ObjLead);
                    }
                    else{
                       
                        message.toAddresses = new String[] {ObjLead.Appointment_Venue_Square__r.Showroom_Manager__r.Email__c,objLead.Appointment_Venue_Square__r.Sales_Manager_Virtual_Meeting__r.Email__c} ; 
                        //message.ccAddresses = new String[] {str.SSMEmail, str.SSAEmail};
                        message.setOrgWideEmailAddressId(fromAddress.id);
                        message.optOutPolicy = 'FILTER';       
                        message.setHtmlBody(emaMap.get('Virtual_Meeting_Reminder_Mail_SM').HtmlValue
                                            .replace('{!Lead.Name}', String.ValueOF('<a href="'+loginLink+'">'+ObjLead.Name+'</a>' ))
                                            .replace('{!Lead.Customer_ID__c}',ObjLead.Customer_ID__c).replace('{!Date}',String.ValueOf(objLead.Appointment_Time__c.dateGMT()))
                                            .replace('{!Day}',objLead.Appointment_Time__c.format('EEEE')).replace('{!Time}',String.ValueOf(objLead.Appointment_Time__c.format('h:mm a')))
                                            .replace('{!Lead.ProjectName}',String.isNotBlank(objLead.Property__r.Name)?objLead.Property__r.Name:'')
                                            .replace('{!Lead.Location}',String.isNotBlank(objLead.Area_Of_Residence__r.Name)?objLead.Area_Of_Residence__r.Name:'')
                                            .replace('{!Lead.PossessionDate}',String.isNotBlank(String.Valueof(objLead.Possession_Date__c))?String.Valueof(objLead.Possession_Date__c):'')
                                            .replace('{!Lead.SM_Name}',objLead.Appointment_Venue_Square__r.Showroom_Manager__r.Name)
                                            .replace('{!Lead.Sales_Manager_Name}',objLead.Appointment_Venue_Square__r.Sales_Manager_Virtual_Meeting__r.Name) 
                                            .replace('{!Lead.Phone}',objLead.Phone)
                                            .replace('{!Lead.Email}',objLead.Email)
                                            .replace('{!Lead.FloorPlan}',String.isNotBlank(objLead.Floorplan_URL__c)?objLead.Floorplan_URL__c:'')   
                                            ); 
                        message.setTemplateId(emaMap.get('Virtual_Meeting_Reminder_Mail_SM').Id); 
                        message.subject = emaMap.get('Virtual_Meeting_Reminder_Mail_SM').subject.replace('{!Lead.Customer_ID__c}',objLead.Customer_ID__c);     
                        lstMails.add(message);   
                        System.debug('message'+message); 
                        ObjLead.VirtualMeeting_Reminder_Email_Sent__c = System.now();
                        lstLead.add(ObjLead); 
                    }
                }
                
            }
            
            System.debug('lstMails'+lstMails);
            if(lstMails != NULL && !lstMails.isEmpty()){
                Messaging.SendEmailResult[] sendEmails = Messaging.sendEmail(lstMails);     
            }

            if(lstLead!= NULL && !lstLead.isEmpty()){
                List<Database.SaveResult> updateResults = Database.update(lstLead, false);
                for(Integer i=0;i<updateResults.size();i++){
                    if (updateResults.get(i).isSuccess()){
                    }
                    else if (!updateResults.get(i).isSuccess()){
                    // DML operation failed
                    Database.Error error = updateResults.get(i).getErrors().get(0);
                    //String failedDML = error.getMessage();
                    //lstLead.get(i);//failed record from the list
                    Logger.log('Update Failed','SendEmailBatchToSM_BU','Execute',error.getMessage(),NULL,lstLead.get(i).id);
                    }
                }
            }
        }
        catch(Exception e){
             System.debug('Exception e'+e.getMessage()+''+e.getStackTraceString());
             Logger.log('Exception','SendEmailBatchToSM_BU','execute',e.getMessage(),e.getStackTraceString(),NULL);
        }    
    }
    
    global void finish(Database.BatchableContext bc)
    {
    }

       global void execute(SchedulableContext sc) {
           Database.executeBatch(new SendEmailBatchToSM_BU(),2);
   }
}