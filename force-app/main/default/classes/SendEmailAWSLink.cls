public class SendEmailAWSLink {
    public String addlRecipients {get; set;}
    public EmailMessage emailMsg {get; private set;}
    private OrgWideEmailAddress sender = null;
    private static final String SUPPORT_EMAIL_ADDRESS = 'support@somewhere.com';
    private static final String SUPPORT_NAME = 'Support Email';
    list<String> Urlslst {get; set;}
    set<id> setEleIds {get; set;}
    String userEmail;
    public  string relatedId ;
    Public  URL__c currentURL{get;set;}
    public list<Element__c> lsteles;
    public URL__c classiccurrentURL;
    public URL__c SiteDownload;
    public String pname;        

    public SendEmailAWSLink() {
        currentURL = URL__c.getInstance('Env'); 
        classiccurrentURL = URL__c.getInstance('Classic'); 
        SiteDownload = URL__c.getInstance('SiteDownload');
        
        Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
        pname = p.name;
        // create our EmailMessage 
        emailMsg = new EmailMessage();
        relatedId = ApexPages.currentPage().getParameters().get('relatedId');
        // get our org-wide email address to set from/sender field
        
        String userid = UserInfo.getUserId();
        User activeUser = [Select Email From User where id = : userid limit 1];
        userEmail = activeUser.Email;
        
        //sender = userEmail;
    }
    public Attachment attachment {
        get {
            if (attachment==null) {
                System.debug('==========> creating new empty Attachment.');
                attachment = new Attachment();
            }
            return attachment;
        }
        set;
    }
    // send email message per the attributes specified by user.
    public PageReference send() {
        try {
            // now create our SingleEmailMessage to send out.
            Messaging.SingleEmailMessage singleEmailMsg = new Messaging.SingleEmailMessage();

            // concatenate all Bcc Addresses
            if (emailMsg.BccAddress != null && emailMsg.BccAddress != '') {
                singleEmailMsg.setBccAddresses(emailMsg.BccAddress.split(';'));
            }

            // concatenate all CC Addresses
            if (emailMsg.CcAddress != null && emailMsg.CcAddress != '') {
                singleEmailMsg.setCcAddresses(emailMsg.CcAddress.split(';'));
            }
            //singleEmailMsg.setOrgWideEmailAddressId(sender.Id); 

            singleEmailMsg.setSubject(emailMsg.Subject);
            singleEmailMsg.setPlainTextBody(emailMsg.TextBody);

            // now add additional recipients
            String[] addlToAddresses = null;
            if (addlRecipients != null && addlRecipients != '') {
                addlToAddresses = addlRecipients.split(';');
            }
            // now lets add any additional recipients to our list of recipients.
            List<String> lstToAddresses = null;
            if (addlToAddresses != null) {
                // now append these to our main recipient.
                lstToAddresses = new List<String>(addlToAddresses);
            } else {
                lstToAddresses = new List<String>();
            }
            lstToAddresses.add(emailMsg.ToAddress);
            singleEmailMsg.setToAddresses(lstToAddresses); 
            singleEmailMsg.setHtmlBody(emailMsg.HtmlBody);
            // now we need to reset the ToAddress for our EmailMessage.
            emailMsg.ToAddress += (addlRecipients != null ? ';' + addlRecipients : '');

            // now attach file to email if there is one. Have to check the Body as Attachment
            // itself will never be null as it is always created first time it is accessed.
            if (attachment.Body != null) {
                Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
                emailAttachment.setBody(attachment.Body);
                emailAttachment.setFileName(attachment.Name);
                singleEmailMsg.setFileAttachments(new List<Messaging.EmailFileAttachment> {emailAttachment});
            }
            List<Messaging.SendEmailResult> results =  Messaging.sendEmail(
                new List<Messaging.SingleEmailMessage> {singleEmailMsg});

            // now parse  our results
            // on success, return to calling page - Case view.
            if (results[0].success) {
                // now insert EmailMessage into database so it is associated with Case.
                System.debug('emailMsg : &&&&&&&&&&&&&&&&&&&&&&'+emailMsg);
                insert emailMsg;
                // and insert attachment into database as well, associating it with our emailMessage
                if (attachment.Body != null) {
                    attachment.parentId=emailMsg.Id;
                    insert attachment;
                }
                
                PageReference pgRef;
                if(pname == 'Design Partner Profile'){
                    pgRef = new PageReference('https://'+currentURL.URL__c+'/apex/AWSTreeStructurelightning?id='+relatedId);
                }else{
                    pgRef = new PageReference('https://'+classiccurrentURL.URL__c+'/apex/AWSTreeStructure?id='+relatedId);
                }
                
                pgRef.setRedirect(true);
                return pgRef;
            } else {
                // on failure, display error message on existing page so return null to return there.
                String errorMsg = 'Error sending Email Message. Details = ' + results.get(0).getErrors()[0].getMessage();
                System.debug('==========> ' + errorMsg);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
                return null;
            }
        }
        catch (Exception e) {
            // on failure, display error message on existing page so return null to return there.
            String errorMsg = 'Exception thrown trying to send Email Message. Details = ' + e;
            System.debug('==========> ' + errorMsg);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
            return null;
        }

        return null;
    }
    // cancel creation of emailMessage. 
    public PageReference cancel() {
        // no need to do anything - just return to calling page.
        PageReference pgRef = new PageReference('https://hldevbox-homelane-dev.cs6.force.com/Homelanedevops/apex/AWSTreeStructurelightning?id='+relatedId);
        pgRef.setRedirect(true);
        return pgRef;
    }
    public PageReference populateTemplate() {
        // we need to perform the merge for this email template before displaying to end-user.
        
        String emailTempId = apexpages.currentpage().getparameters().get('template_id');
        String Urls = apexpages.currentpage().getparameters().get('emailIds');
        Urlslst = new list<String>();
        setEleIds = new set<Id>();
        for(String eachUrls: Urls.replace('\'', '').split(','))
        {
            Urlslst.add(eachUrls); 
            setEleIds.add(eachUrls);
        }

        if(!setEleIds.isEmpty()){
            lsteles = new list<Element__c>();
            lsteles = [SELECT Bucket__c,Description__c,Extension__c,File_Size__c,File_URL__c,Id,Name,OwnerId,
                    Parent_Element__c,Related_Object_ID__c,SystemModstamp,Type__c FROM Element__c
                    Where id in: setEleIds];
        }
        
        System.debug('Urlslst 123: '+Urlslst);

        EmailTemplate emailTemplate = [select Body, HtmlValue, Subject, DeveloperName, BrandTemplateId 
            from EmailTemplate where id=: emailTempId limit 1];

        // construct dummy email to have Salesforce merge BrandTemplate (HTML letterhead) with our email
        Messaging.SingleEmailMessage dummyEmailMsg = new Messaging.SingleEmailMessage();
        dummyEmailMsg.setTemplateId(emailTemplate.Id);
        // This ensures that sending this email is not saved as an activity for the targetObjectId. 
        dummyEmailMsg.setSaveAsActivity(false);

        // send dummy email to populate HTML letterhead in our EmailMessage object's html body.
        String[] toAddresses = new String[]{'test@test.com','test@test.com'};
        dummyEmailMsg.setToAddresses(toAddresses);
        dummyEmailMsg.setReplyTo(userEmail); 
        
        // now send email and then roll it back but invocation of sendEmail() 
        // means merge of letterhead & body is done

        // TargetObject is User. This tells the emailMsg to use the email message
        // associated with our dummy User. This is necessary so we can populate our
        // email message body & subject with merge fields from template
        Savepoint sp = Database.setSavepoint();
        
        Recordtype recObj = [SELECT BusinessProcessId,CreatedById,CreatedDate,Description,DeveloperName,Id,IsActive,IsPersonType,LastModifiedById,LastModifiedDate,Name,NamespacePrefix,SobjectType,SystemModstamp FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Business_Account'];
        
        Account dummyAcct = new Account(Name='dummy account',RecordTypeId=recObj.id);
        insert dummyAcct;
        
        Contact dummyContact        = new Contact(AccountId=dummyAcct.Id); 
        dummyContact.FirstName      = 'First';
        dummyContact.LastName       = 'Last';
        dummyContact.Email          = 'nobody@nowhere.com';
        insert dummyContact;

        dummyEmailMsg.setTargetObjectId(dummyContact.Id);
        
        //dummyEmailMsg.setWhatId(ourCase.Id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {dummyEmailMsg});
        // now rollback our changes.
        Database.rollback(sp);

        // now populate our fields with values from SingleEmailMessage.
        emailMsg.BccAddress  = UserInfo.getUserEmail();
        emailMsg.Subject     = dummyEmailMsg.getSubject();
        emailMsg.TextBody    = 'dummy';
        System.debug('************************** emailMsg.TextBody : '+emailMsg.TextBody);
        emailMsg.ToAddress   = dummyEmailMsg.getToAddresses().get(0);
        emailMsg.FromAddress = userEmail; 
        emailMsg.CcAddress   = '';
        
        System.debug('emailTemplate.HtmlValue********************************'+emailTemplate.HtmlValue);
        
        String htmlValue = emailTemplate.HtmlValue;
        String toAdd = '<br/><b>Attachments : </b><br/>';
        for(Element__c each : lsteles){
            if(pname == 'Design Partner Profile'){
                toAdd = toAdd+'<a href="'+SiteDownload.URL__c+'/apex/CallApiDownload?elementId='+each.id+'">'+each.name+'</a><br/>';
            }else{
                toAdd = toAdd+'<a href="'+SiteDownload.URL__c+'/apex/CallApiDownload?elementId='+each.id+'">'+each.name+'</a><br/>';
            }
        }
        toAdd = toAdd + '<br/>Regards';
        emailTemplate.HtmlValue = (emailTemplate.HtmlValue).replace('Regards', toAdd);
        emailMsg.HtmlBody = emailTemplate.HtmlValue; 
        System.debug('emailMsg.HtmlBody********************************'+emailMsg.HtmlBody);
        //emailMsg.ParentId    = ourCase.Id;
        return null;
    }
    
}