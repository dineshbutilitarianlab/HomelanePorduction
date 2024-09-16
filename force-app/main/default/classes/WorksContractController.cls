public without Sharing class WorksContractController{
    
    Public String Id {get;set;}
    Public Opportunity oppty{get;set;}
    Public string customerInput {get;set;}
    Public string customerpicklistInput {get;set;}
    Public String strErrorMsg{get;set;}
    // Public String customercom1 {get;set;}
    Public Boolean customerAggrement{get;set;}
    Public Boolean redirect = FALSE;
    Public Boolean redirectError{get;set;}
    public String strCustomerEmail{get;set;}
    public Opportunity oppObj{get;set;}
    
    //Variables for NPS warranty document
    public String hmlinteriorValue {get;set;}
    public String hmlrecommandValue {get;set;}
    
    public String hmlNPSquesValue {get;set;}
    public boolean isFeedbackGiven{get;set;}
    
    public String hmldesignValue {get;set;}
    public String hmlInstallationValue {get;set;}
    public String hmlsuggestionValue {get;set;}
    Public String customername {get;set;}
    Public String installationaddress {get;set;}
    Public Boolean contractSigned {get;set;}
    Public Boolean npsSent {get;set;}
    Public Boolean hideButtonsActions {get;set;}
    Public Boolean isWhatsappOptedIn {get;set;}
    public String hmlWhatsappOptInValue {get;set;}
    
    Public Boolean allowWCAndNPS {get;set;}
    
    public Static String CMEmailAddress {get;set;}
    public Static String CMName {get;set;}
    
    public WorksContractController(){
        Id = ApexPages.currentPage().getParameters().get('id');
        if(String.isBlank(Id)){
            hideButtonsActions = true;
        }
        else{
            allowWCAndNPS = true;
            isWhatsappOptedIn = false;
            hideButtonsActions = false;
            oppty = getOpportunityRecord(Id);
            npsSent = false;
            customername = oppty.Name;
            strCustomerEmail = oppty.Customer_ID__c;
            strErrorMsg = '';
            installationaddress = oppty.Address_Of_Instalation__c;
            system.debug('----oppty-----'+oppty);
            if(oppty != NULL){
                if(oppty.Works_Contract_Sign_Off_Done__c == True && oppty.Customer_Satisfaction__c !=NULL){
                    npsSent = true;
                    system.debug('----Works_Contract_Sign_Off_Done__c -----'+oppty.Works_Contract_Sign_Off_Done__c );
                    system.debug('----Customer_Satisfaction__c-----'+oppty.Customer_Satisfaction__c);
                }
                else if (oppty.Works_Contract_Sign_Off_Done__c == True ){
                    system.debug('----Works_Contract_Sign_Off_Done__c -----'+contractSigned );
                    contractSigned = false;
                }
                //Added By Bharatesh Shetty
                if(oppty.Scope_Of_Work__c != null && oppty.Scope_Of_Work__c !='' && oppty.Address_Of_Instalation__c != null && oppty.Address_Of_Instalation__c != '' && oppty.Date_Of_Completion__c != null){
                    isFeedbackGiven = false;
                    System.debug('isFeedbackGiven: '+isFeedbackGiven);
                }
                else{
                    isFeedbackGiven = true;
                    System.debug('isFeedbackGiven: '+isFeedbackGiven);
                }
                if(oppty.Whatsapp_Opt_in__c){
                    isWhatsappOptedIn = True;
                }
                System.debug('Constructor isWhatsappOptedIn: '+isWhatsappOptedIn);
            }
        }
    }
    
    /* Public void readinputdata(){
system.debug(' customerComments '+ customerComments+' customerInput '+customerInput);
oppty.Works_Contract_Comments__c = customerComments;
oppty.Customer_Satisfaction__c = customerInput;
} */
    public pageReference UpdatefeedbackOnOpportunity(){
        
        System.debug('oppty.Name ---------------------------------->'+oppty.Name);
        
        PageReference pageRef = checkCurrentStatusAndRedirect();
        
        if(pageRef == NULL){
            System.debug('Success Condition in NPS submit and Update');
            hmlinteriorValue = ApexPages.currentPage().getParameters().get('interiorValue');
            hmlrecommandValue = ApexPages.currentPage().getParameters().get('recommandValue');
            hmldesignValue = ApexPages.currentPage().getParameters().get('designhmlValue');
            hmlNPSquesValue = ApexPages.currentPage().getParameters().get('NPSqueshmlValue');
            hmlsuggestionValue = ApexPages.currentPage().getParameters().get('suggestionboxValue');
            hmlWhatsappOptInValue = ApexPages.currentPage().getParameters().get('WhatsappOptInhmlValue');
            // oppty.Customer_s_Design_Rating__c = hmlinteriorValue; 
            oppty.Customer_Satisfaction__c= Decimal.valueOf(hmlrecommandValue);
            oppty.Design_Feedback_Question__c = hmlNPSquesValue;
            oppty.Design_Feedback_Answer__c = hmldesignValue;
            oppty.Works_Contract_Comments__c = hmlsuggestionValue;
            oppty.Date_of_40_NPS_Sign_Off__c = system.Now();
            System.debug('hmlWhatsappOptInValue: '+hmlWhatsappOptInValue);
            System.debug('UpdatefeedbackOnOpportunity method isWhatsappOptedIn: '+isWhatsappOptedIn);
            /*if(!String.isBlank(hmlWhatsappOptInValue)){
if(hmlWhatsappOptInValue.equalsIgnoreCase('TRUE')){
oppty.Whatsapp_Opt_in__c = True;
}
else if(hmlWhatsappOptInValue.equalsIgnoreCase('FALSE')){
oppty.Whatsapp_Opt_in__c = False;
}
System.debug('oppty.Whatsapp_Opt_in__c: '+oppty.Whatsapp_Opt_in__c);
}*/
            System.debug('oppty.Whatsapp_Opt_in__c 1: '+oppty.Whatsapp_Opt_in__c);
            oppty.Whatsapp_Opt_in__c = isWhatsappOptedIn;
            System.debug('oppty.Whatsapp_Opt_in__c 2: '+oppty.Whatsapp_Opt_in__c);
            system.debug('hmlinteriorValue ----------------------'+hmlinteriorValue+'----hmlrecommandValue---'+hmlrecommandValue+'----hmldesignValue---'+hmldesignValue+'----hmlNPSquesValue---'+hmlNPSquesValue+'----hmlsuggestionValue---'+hmlsuggestionValue);
            
            String sMessage;
            
            try{
                system.debug('test inside1 try ---------------------->'+oppty);
                update oppty;
                System.debug('oppty.Whatsapp_Opt_in__c 3: '+oppty.Whatsapp_Opt_in__c);
                system.debug('test inside2 try ----------------------');
            }catch(VisualforceException ex){
                exceptionEmail(ex);
                
            }
            // return Workscontractpage();
            return null;
        }
        else{
            //redirect to new Error Page
            System.debug('Error Condition in NPS submit');
            /*PageReference pageRefErrorPage = new PageReference('/apex/WCAndNPSNotApprovedErrorPage?id='+oppty.Id);
            pageRef.getParameters().put('CMName',CMName);
            pageRef.getParameters().put('CMEmailAddress',CMEmailAddress);
            System.debug('pageRefErrorPage: '+pageRefErrorPage);
            pageRefErrorPage.setRedirect(true);
            return pageRefErrorPage;*/
            System.debug('pageRef: '+pageRef);
            return pageRef;
        }
        
    }
    
    public pageReference AcceptedEdited(){
        PageReference pageRef = checkCurrentStatusAndRedirect();
        
        if(pageRef == NULL){
            oppty.Works_Contract_Sign_Off_Done__c= true;
            oppty.Works_Contract_Sign_Off_Date__c= system.now();
            try{
                update oppty;
                if(!Test.isRunningTest()){
                    SendFeedBackToRoasterAPI.SendToRoaster(strCustomerEmail);
                }
            }catch(DMLException DMLex){
                system.debug('*** Oppty update failed due to '+DMLex);
            }
            return feadbackPage(oppty.Id);
        }
        else{
            return pageRef;
        }
    }
    
    public pageReference reDirectToNPS(){
        system.debug('feadbackPage called');
        return feadbackPage(oppty.Id);
    }
    
    public pageReference checkNps(){
        system.debug('Check NPS called'+npsSent);
        if(!hideButtonsActions){
            if(npsSent){
                PageReference pageRef = new PageReference('/apex/ThankyouPage?id='+oppty.Id);
                pageRef.setRedirect(true);
                return pageRef;
            }
            else{
                return checkCurrentStatusAndRedirect();
            }
        }
        return NULL;
        //return feadbackPage(oppty.Id);
    }
    
    public pageReference Submitfeedback(){
        
        System.debug('oppty.Name ---------------------------------->'+oppty.Name);
        
        hmlinteriorValue = ApexPages.currentPage().getParameters().get('interiorValue');
        hmlrecommandValue = ApexPages.currentPage().getParameters().get('recommandValue');
        hmldesignValue = ApexPages.currentPage().getParameters().get('designhmlValue');
        hmlNPSquesValue = ApexPages.currentPage().getParameters().get('NPSqueshmlValue');
        hmlsuggestionValue = ApexPages.currentPage().getParameters().get('suggestionboxValue');
        //oppty.Address_Of_Instalation__c = hmlinstallationaddValue;
        
        
        
        oppty.Customer_s_Interior_Rating__c = hmlinteriorValue; 
        //oppty.Experience_On_Installation__c = hmlInstallationValue;
        oppty.Customer_Overall_Review__c= hmldesignValue;
        oppty.Customer_Feedback_Suggestion__c = hmlsuggestionValue;
        oppty.Customer_s_Recommendation_Of_Homelane__c = hmlrecommandValue;
        oppty.NPS_Feedback_Question__c = hmlNPSquesValue;
        oppty.Date_Of_NPS_Form_Sign_Off__c = system.today();
        
        
        system.debug('test outside try ----------------------');
        
        String sMessage;
        
        try{
            system.debug('test inside1 try ---------------------->'+oppty);
            update oppty;
            system.debug('updated opp ---------------------->'+oppty);
            
            
            //system.debug('---body ------------------------------>'+body);
            //body = pdf.getContent();
            redirect =TRUE;
            system.debug('test inside2 try ----------------------');
        }catch(VisualforceException ex){
            exceptionEmail(ex);
            /*sMessage += 'ERROR: ' + 'An exception has occurred. Please contact your System Administrator quoting the following message -- '+ ex.getTypeName() + ':'+ex.getMessage() + ':' + ex.getLineNumber() + ':' + ex.getStackTraceString();
Apexpages.Message errorMessage1 = new Apexpages.Message(ApexPages.Severity.ERROR,sMessage );
Apexpages.addMessage(errorMessage1);
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;
String[] toAddresses = new String[] {'sachin.k@kvpcorp.com', 'cameron.j@homelane.com'};
mail.setToAddresses(toAddresses) ;
mail.setSubject('Exception occered');

String bod = '<html lang="ja"><body>'+
'<br><br>'+
'This email alert is to bring to your notice that exception occured  '+
'<br><br>'+
'<b>'+
'Here is detail of Exception '+
'</b>'+
'<br><br>'+ sMessage+
'</body></html>';
mail.setHtmlBody(bod);
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

// Blob body = Blob.valueOf('Some Text');
system.debug('*** Oppty update failed due to '+ex);*/
        }
        
        
        return Workscontractpage();
        
    }
    
    // Return type changed from Void to PageReference by Bharatesh Shetty
    public PageReference sendWarrantyDocument(){
        if(oppty.Scope_Of_Work__c != null && oppty.Scope_Of_Work__c !='' && oppty.Address_Of_Instalation__c != null && oppty.Address_Of_Instalation__c != '' && oppty.Date_Of_Completion__c != null)
        {
            PageReference pdf = Page.NPSwarrantyPDF;
            pdf.getParameters().put('id',Id);
            Blob body;
            if(!test.isRunningTest()){
                body = pdf.getContent();
            }
            else{
                body = blob.valueof('TEST');
            }
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('Certificate_of_Warranty.pdf');
            attach.setInline(false);
            attach.Body = body;
            system.debug('test try ----------------------');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSenderDisplayName('Homelane Support');
            mail.setReplyTo('care@homelane.com');
            mail.setUseSignature(false);
            mail.setToAddresses(new String[] { oppty.Customer_Email__c });
            mail.setSubject('Here\'s your Certificate of Warranty!');
            mail.setHtmlBody('<!DOCTYPE html><html><head><title>Warranty Mailer</title><meta name="viewport" content="width=device-width, initial-scale=1"></head><body><div id="wrapper" style="max-width: 800px; margin: auto; padding-bottom: 10px; font-family:\'Helvetica\',\'Lucida Grande\',Arial,sans-serif"><div id="Logo" style="padding: 20px;"><img src="https://s3-ap-southeast-1.amazonaws.com/hlmicrosite/careLogo.jpg" alt="bannerImage" style="max-width: 100%;" /></div><div id="bannerImage"><img src="https://s3-ap-southeast-1.amazonaws.com/hlmicrosite/careBanner.jpg" alt="bannerImage" style="max-width: 100%" /></div><div id="textContent" style="text-align: center; width: 80%; margin: auto;"><h2 style="text-align: center;display: block;color: #202020;font-family: Helvetica;font-size: 26px;font-style: normal;font-weight: bold;line-height: 125%;letter-spacing: normal;">Thank you for the opportunity to help build your dream home! </h2><p style="font-size: 16px;"> We want you to know that HomeLane\'s promise of after-sales service holds good for five years. <br/> Please ensure you read the warranty details carefully and get your first service done within 6 months of installation. <br/> We hope to continue serving you.  </p></div><div id="textContent1" style="text-align: center;margin: auto;background-color: #404040;padding:10px;"><h2 style="text-align: center;display: block;color: #202020;font-family: Helvetica;font-size: 26px;font-style: normal;font-weight: bold;line-height: 100%;letter-spacing: normal;color: #D2D7DD;">Happy to Help </h2><p style="font-size: 16px;color: #D2D7DD;font-family: Helvetica;">Your Customer ID is <span style="font-size: 16px;color: #EF4626;font-family: Helvetica;"> '+oppty.Customer_ID__c+'  </span><br/><p style="font-size: 16px;color: #FFFFFF;font-family: Helvetica;">Please use this for any services you may require in future.<br/>For all care and maintenance-related queries and requests, please visit<br/><br/><a style="color: #218391;font-family: Helvetica;" href="www.homelane.com/care"> www.homelane.com/care </a></div><div id="textContent2" style="text-align: center; width: 85%; margin: auto;padding:10px;"><p style="font-size: 16px;font-family: Helvetica;">Thank you for the opportunity to learn, grow and serve you.<br/>Hope you enjoy your home.</p><p style="font-size: 16px;font-family: Helvetica;">Best wishes,<br/>Team HomeLane</div> <div style="text-align:center"><div>    <div style="margin:15px 0px 20px 0px"><div style="display:inline-block;margin:0px 15px">    <a href="https://www.facebook.com/homelaneinteriors" target="_blank"><img src="https://ci5.googleusercontent.com/proxy/pS-xPwkFqnflV7rc4dnAlcsKqer1SA-EyY1YKnmCus118BOixN6hD5sRUCqoKMZBD78ATe0j-zF2SEBCop4dd3IM3pxnSPoc9-fO4R1zWRUa_ZokVGh8ZWqkBAU41prZ_UAex2DRoVPt3A=s0-d-e1-ft#https://cdn-images.mailchimp.com/icons/social-block-v2/outline-color-facebook-48.png" style="display:block;border:0;height:auto;outline:none;text-decoration:none;margin:auto" height="24" width="24"></a></div><div style="display:inline-block;margin:0px 15px"> <a href="https://www.linkedin.com/company/homelane" target="_blank"><img src="https://ci4.googleusercontent.com/proxy/qt0bcUPJDoDitbKgOAFA2l5NBXDJO8aoXqmyus5yzCtGQemA8CzvEKTjqa5ZHnMgSbvHPR10n76ryrXmMuOjgQ6y9-Jh_EB9_-R-ODN__Rh_Qa3uP2mOYqhQoMGh2l2pEk780fgL-92VvA=s0-d-e1-ft#https://cdn-images.mailchimp.com/icons/social-block-v2/outline-color-linkedin-48.png" style="display:block;border:0;height:auto;outline:none;text-decoration:none;margin:auto" height="24" width="24"></a></div><div style="display:inline-block;margin:0px 15px">  <a href="https://www.instagram.com/homelane_india/" target="_blank"><img src="https://ci5.googleusercontent.com/proxy/8INiLUw6716N8IzDDrNVR1r5ns6itr-NalqNitNUhJ0x4S_-iDxDJ_8700uJq8ZbPkV4XyhznNELgW5h2tIAeHlLfBz63mBu1EEETVgqwQDD2o_QrnIy86oxk3wWt6GyNAeNXRnUnKz1g4Y=s0-d-e1-ft#https://cdn-images.mailchimp.com/icons/social-block-v2/outline-color-instagram-48.png" style="display:block;border:0;height:auto;outline:none;text-decoration:none;margin:auto" height="24" width="24"></a></div><div style="display:inline-block;margin:0px 15px">    <a href="http://www.homelane.com/hl/homeinteriors1" target="_blank"><img src="https://ci4.googleusercontent.com/proxy/WGiDIp1Ys80qhunuIwUhEq5iEn7PDecfoA3NWG1DPa-jz6pWgZSQHGBFJSpYXseoQuDEO2FDWxgpS582Q9GGH70KHf9lAr_Bq5MvSV7OxsFEtmP_WLr5ZLUkGC8K-xv07Mh5I2iA=s0-d-e1-ft#https://cdn-images.mailchimp.com/icons/social-block-v2/outline-color-link-48.png" style="display:block;border:0;height:auto;outline:none;text-decoration:none;margin:auto" height="24" width="24"></a></div>  </div></div><div>  <p><em>Copyright © 2017  Homevista Decor and Furnishings Pvt Ltd., All rights reserved.</em></p></div></div></div></body></html>');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
            if(!Test.isRunningTest()){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                system.debug('-----Messaging----'+results);
            }
            oppty.Warranty_Document_Sent_Date_and_Time__c = System.Now();
            update oppty;
            isFeedbackGiven = false;
            //Commented and added by Bharatesh Shetty
            PageReference pageRef = new PageReference('/apex/WarrantyThankYou?id='+Id);
            return pageRef;
        }
        else{
            //Commented and added by Bharatesh Shetty
            isFeedbackGiven = true;
            return null;
        }
        
    }
    public pageReference getWarrantydata(){
        try{
            System.debug('Address_Of_Instalation__c : '+oppty.Address_Of_Instalation__c);
            System.debug('Date_Of_Completion__c : '+oppty.Date_Of_Completion__c);
            update oppty;
            
            Opportunity o = [select id, name,Date_Of_Completion__c,Address_Of_Instalation__c,Scope_Of_Work__c,Warranty_Document_Comments__c from Opportunity where id =:Id limit 1];
            System.debug('Address_Of_Instalation__c After DML : '+o.Address_Of_Instalation__c);
            System.debug('Date_Of_Completion__c After DML : '+o.Date_Of_Completion__c);
            //Commented and added by Bharatesh Shetty
            PageReference pageRef = new PageReference('/apex/SendWarranty?id='+Id);
            return pageRef;
            /*sendWarrantyDocument();
            return Recordpage(); */
        }catch(VisualforceException exp){
            exceptionEmail(exp);
        }
        return null;
    }
    
    Public void exceptionEmail(VisualforceException ex){
        String sMessage = 'ERROR: ' + 'An exception has occurred. Please contact your System Administrator quoting the following message -- '+ ex.getTypeName() + ':'+ex.getMessage() + ':' + ex.getLineNumber() + ':' + ex.getStackTraceString();
        Apexpages.Message errorMessage1 = new Apexpages.Message(ApexPages.Severity.ERROR,sMessage );
        Apexpages.addMessage(errorMessage1);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;
        String[] toAddresses = new String[] {'balasubramanian.r@kvpcorp.com', 'cameron.j@homelane.com'};
            mail.setToAddresses(toAddresses) ;
        mail.setSubject('Exception occered');
        
        String bod = '<html lang="ja"><body>'+
            '<br><br>'+
            'This email alert is to bring to your notice that exception occured  '+
            '<br><br>'+
            '<b>'+
            'Here is detail of Exception '+
            '</b>'+
            '<br><br>'+ sMessage+
            '</body></html>';
        mail.setHtmlBody(bod);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        
        
        
    }
    
    /* public PageReference Rejected(){
if((oppty.StageName == 'D3 Initiated' || oppty.StageName == 'Quote Required' || oppty.StageName == 'Initial Quote Sent' || oppty.StageName == 'Initial Quote Approved' || oppty.StageName == 'Initial Quote Rejected' || oppty.StageName == 'IQ Follow Up' || 
oppty.StageName == '10% Payment Received' || oppty.StageName == '10% Payment Collected' || oppty.StageName == 'D1 Initiated' || oppty.StageName == 'D2 Initiated' || 
oppty.StageName == 'Project Plan & Estimates Publish' || oppty.StageName == 'Production Initiated & Order Placed' || oppty.StageName == 'Production & Procurement Complete' || 
oppty.StageName == '50% Payment Received' || oppty.StageName == '50% Payment Collected' ||  oppty.StageName == 'Full and Final Settlement Collected' || oppty.StageName == 'Opportunity Lost' || oppty.StageName == 'Install Team Assigned,Material Dispatche' || oppty.StageName == 'Material Received'
|| oppty.StageName == 'Installation Started' || oppty.StageName == 'D4 Initiated' || oppty.StageName == 'Installation Completed' 
|| oppty.StageName == 'Snaglist Rectification Completed' || oppty.StageName == 'Full and Final Settlement Received' || oppty.StageName == 'Project Signed Off' ) && customerAggrement == TRUE && customerInput != NULL){



oppty.Works_Contract_Comments__c = customerpicklistInput;
oppty.Customer_Satisfaction__c = decimal.valueof(customerInput);
oppty.Works_Contract_Sign_Off_Rejected__c= true;
oppty.Works_Contract_Sign_Off_Date__c= system.now();


/*if(oppty.StageName == 'D3 Initiated'){
oppty.Sub_Status__c = 'Final Drawings, Quote & Works Contract Rejected';
oppty.Works_Contract_Comments__c = customerpicklistInput;
oppty.Customer_Satisfaction__c = decimal.valueof(customerInput);
}--Close here--
if(oppty.StageName == 'Full and Final Settlement Collected'){
oppty.Final_Customer_Rating__c = decimal.valueof(customerInput);
oppty.Final_Works_Contract_Comments__c = customerpicklistInput + ' - Rejected';
}    
try{
update oppty;
redirect =TRUE;
}catch(DMLException DMLex){
system.debug('*** Oppty update failed due to '+DMLex);
}
}else if((oppty.StageName == 'D3 Initiated' || oppty.StageName == 'Quote Required' || oppty.StageName == 'Initial Quote Sent' || oppty.StageName == 'Initial Quote Approved' || oppty.StageName == 'Initial Quote Rejected' || oppty.StageName == 'IQ Follow Up' || 
oppty.StageName == '10% Payment Received' || oppty.StageName == '10% Payment Collected' || oppty.StageName == 'D1 Initiated' || oppty.StageName == 'D2 Initiated' || 
oppty.StageName == 'Project Plan & Estimates Publish' || oppty.StageName == 'Production Initiated & Order Placed' || oppty.StageName == 'Production & Procurement Complete' || 
oppty.StageName == '50% Payment Received' || oppty.StageName == '50% Payment Collected' ||  oppty.StageName == 'Full and Final Settlement Collected' || oppty.StageName == 'Opportunity Lost' || oppty.StageName == 'Install Team Assigned,Material Dispatche' || oppty.StageName == 'Material Received'
|| oppty.StageName == 'Installation Started' || oppty.StageName == 'D4 Initiated' || oppty.StageName == 'Installation Completed' 
|| oppty.StageName == 'Snaglist Rectification Completed' || oppty.StageName == 'Full and Final Settlement Received' || oppty.StageName == 'Project Signed Off' ) && ( customerAggrement == FALSE || customerInput == NULL)){
redirect = FALSE;
redirectError = true;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please accept the Terms and Conditions, Rating and Submit the form again'));
}

if(redirect ==TRUE){
if(!test.isrunningtest())
SendFeedBackToRoasterAPI.SendToRoaster(strCustomerEmail);
return Homelanehomepage();
}
else 
return null;
}*/
    
    
    public static Opportunity getOpportunityRecord(Id opptyId) {
        Opportunity opportunityrec = new Opportunity();
        opportunityrec = [select id, name,Customer_ID__c,Works_Contract_Sign_Off_Done__c,Customer_Email__c,Date_Of_NPS_Form_Sign_Off__c,Address_Of_Instalation__c,Customer_s_Interior_Rating__c,Date_Of_Completion__c,Experience_On_Installation__c,Experience_On_Home_Design__c,Customer_Feedback_Suggestion__c,Customer_s_Recommendation_Of_Homelane__c,Sub_Status__c,Works_Contract_Comments__c,Final_Works_Contract_Comments__c,Scope_Of_Work__c,Final_Customer_Rating__c,Customer_Satisfaction__c,StageName,Whatsapp_Opt_In__c from Opportunity where id =: opptyId];
        
        return opportunityrec;
    }
    public PageReference Homelanehomepage(){
        system.debug('sasasasasas');
        PageReference pageRef = new PageReference('http://www.homelane.com/');
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference feadbackPage(String oppId){
        system.debug('sasasasasasfeadbackPage');
        String currentCustomerStatus;
        allowWCAndNPS = True;
        currentCustomerStatus = calloutToRosterToGetCurrentStatus(oppty.Id,oppty.Customer_ID__c);
        System.debug('currentCustomerStatus: '+currentCustomerStatus);
        System.debug('CMEmailAddress: '+CMEmailAddress);
        System.debug('CMName: '+CMName);
        if(String.isNotBlank(currentCustomerStatus)){
            if(currentCustomerStatus.equalsIgnoreCase('sow_approved') || currentCustomerStatus.equalsIgnoreCase('wc_signed_off')){
                allowWCAndNPS = True;
            }
            else{
                allowWCAndNPS = False;
            }
        }
        /*if(allowWCAndNPS){
            PageReference pageRef = new PageReference('/apex/DesignNPS?id='+oppId);
            pageRef.setRedirect(true);
            return pageRef;
        }*/
        if(allowWCAndNPS){
            PageReference pageRef = new PageReference('/apex/ThankyouPage?id='+oppId);
            pageRef.setRedirect(true);
            return pageRef;
            }       

        else{
            PageReference pageRef = new PageReference('/apex/WCAndNPSNotApprovedErrorPage?id='+oppId);
            pageRef.setRedirect(true);
            return pageRef;
        }
    }
    public PageReference Recordpage(){
        system.debug('sasasasasas');
        PageReference pageRef = new PageReference('/'+oppty.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference Workscontractpage(){
        PageReference pageRef = new PageReference('http://www.homelane.com/thankyouwarranty');
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference checkCurrentStatusAndRedirect(){
        String currentCustomerStatus;
        allowWCAndNPS = True;
        currentCustomerStatus = calloutToRosterToGetCurrentStatus(oppty.Id,oppty.Customer_ID__c);
        System.debug('currentCustomerStatus: '+currentCustomerStatus);
        System.debug('CMEmailAddress: '+CMEmailAddress);
        System.debug('CMName: '+CMName);
        if(String.isNotBlank(currentCustomerStatus)){
            if(currentCustomerStatus.equalsIgnoreCase('sow_approved') || currentCustomerStatus.equalsIgnoreCase('wc_signed_off')){
                allowWCAndNPS = True;
            }
            else{
                allowWCAndNPS = False;
            }
            //allowWCAndNPS = True;
        }
        System.debug('allowWCAndNPS: '+allowWCAndNPS);
        if(allowWCAndNPS){
            return null;
        }
        else{
            PageReference pageRef = new PageReference('/apex/WCAndNPSNotApprovedErrorPage?id='+Id);
            pageRef.getParameters().put('CMName',CMName);
            pageRef.getParameters().put('CMEmailAddress',CMEmailAddress);
            pageRef.setRedirect(true);
            System.debug('pageRef: '+pageRef);
            return pageRef;
        }
    }
    public PageReference RedirectToMain(){
             PageReference pageRef;
              
            if(oppty!=null){
                   if(oppty.Works_Contract_Sign_Off_Done__c == True){
                   
                        pageRef = new PageReference('/apex/ThankyouPage?id='+oppty.Id);
                   }
                else{
                   
                    pageRef = new PageReference('/apex/WorksContractVFPage1?id='+Id);
               }
            }
              pageRef.setRedirect(true);
                    return pageRef; 

    }
    
    
    
    public List<SelectOption> getcustomernumber() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','0'));
        options.add(new SelectOption('1','1'));
        options.add(new SelectOption('2','2'));
        options.add(new SelectOption('3','3'));
        options.add(new SelectOption('4','4'));
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('6','6'));
        options.add(new SelectOption('7','7'));
        options.add(new SelectOption('8','8'));
        options.add(new SelectOption('9','9'));
        options.add(new SelectOption('10','10'));
        
        return options;
        
    }
    
    public List<SelectOption> getcustomerpicklistresponse() {
        
        List<SelectOption> picklistoptions = new List<SelectOption>();
        picklistoptions.add(new SelectOption(' Please select a value ',' Please select a value '));
        picklistoptions.add(new SelectOption('Design - Unhappy with the design / designer','Design - Unhappy with the design / designer'));
        picklistoptions.add(new SelectOption('Coordination & Communication didnot meet expectation','Coordination & Communication didnot meet expectation'));
        picklistoptions.add(new SelectOption('Product and Installation - Quality / choices / production / delivery poor','Product and Installation - Quality / choices / production / delivery poor'));
        picklistoptions.add(new SelectOption('Personnel - Lack of / poor responsiveness, understanding, professionalism','Personnel - Lack of / poor responsiveness, understanding, professionalism'));
        picklistoptions.add(new SelectOption('Pricing - Not value for money','Pricing - Not value for money'));
        
        return picklistoptions ;
        
    }
    
    
    public pageReference sendRating() {
        System.debug('isWhatsappOptedIn: '+isWhatsappOptedIn);
        String custEmail = '';
        custEmail = ApexPages.currentPage().getParameters().get('strCustomerEmail');
        System.debug('----INSIDE METHOD  '+custEmail);
        System.debug('isWhatsappOptedIn: '+isWhatsappOptedIn);
        return null;
    }
    public pageReference CheckAndUncheckWhatsappOptIn() {
        System.debug('isWhatsappOptedIn: '+isWhatsappOptedIn);
        isWhatsappOptedIn = isWhatsappOptedIn ? False : True;
        System.debug('isWhatsappOptedIn: '+isWhatsappOptedIn);
        return null;
    } 
    Public Static String calloutToRosterToGetCurrentStatus(String oppId,String OpportunityOrderId){
        String currentStatus;
        try{
            if( String.isNotBlank(oppId) && String.isNotBlank(OpportunityOrderId)){
                Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                Integration_Setting__c integrationDetail = allEndPoint.get('Roster_SOW_Approved_Check_API');
                String endPointUrl = integrationDetail.End_Point__c+OpportunityOrderId;
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                Httpresponse response = new Httpresponse();
                
                request.setMethod('GET');
                //request.setHeader('Content-Type', integrationDetail.ContentType__c);
                
                request.setEndPoint(endPointUrl);
                request.setHeader('Accept', integrationDetail.ContentType__c);
                request.setTimeout(10000);
                
                System.debug('request: '+request);
                response = http.send(request);
                System.debug('response: '+response);
                
                String resJson;
                if(response.getStatusCode()==200){
                    resJson = response.getBody();
                    System.debug('resJson: '+resJson);
                    finalResponse respWrapMap = new finalResponse();
                    respWrapMap = (finalResponse)JSON.deserialize(resJson,finalResponse.class);
                    System.debug('respWrapMap: '+respWrapMap);
                    if(respWrapMap != Null){
                        if(respWrapMap.status == True){
                            if(respWrapMap.data !=Null){
                                currentStatus = respWrapMap.data.currentOrderStage;
                                CMEmailAddress = respWrapMap.data.cmEmail;
                                CMName = respWrapMap.data.cmName;
                            }
                            else{
                                System.debug('respWrapMap data is null');
                                Logger.log('Error','WorksContractController class','calloutToRosterToGetCurrentStatus method','respWrapMap data is null',resJson,OpportunityOrderId);
                            }
                        }
                        else{
                            System.debug('respWrapMap Status is false');
                            Logger.log('Error','WorksContractController class','calloutToRosterToGetCurrentStatus method','respWrapMap Status is false',resJson,OpportunityOrderId);
                        }
                    }
                    else{
                        System.debug('respWrapMap is null');
                        Logger.log('Error','WorksContractController class','calloutToRosterToGetCurrentStatus method','respWrapMap is null',resJson,OpportunityOrderId);
                    }
                }
                else{
                    System.debug('response.getStatusCode(): '+response.getStatusCode());
                    Logger.log('Error','WorksContractController class','calloutToRosterToGetCurrentStatus method','Status code error',String.ValueOf(response.getStatusCode()),OpportunityOrderId);
                }
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception','WorksContractController class','calloutToRosterToGetCurrentStatus method',e.getMessage(),e.getStackTraceString(),OpportunityOrderId);
        }
        System.debug('currentStatus: '+currentStatus);
        return currentStatus;
    }
    public class finalResponse{
        public Boolean status;
        Public String msg;
        public responseWrapper data;
    }
    public class responseWrapper{
        public String dpEmail;
        public String dpUserId;
        public String cmEmail;
        public String cmName;
        public String currentOrderStage;
    }
}