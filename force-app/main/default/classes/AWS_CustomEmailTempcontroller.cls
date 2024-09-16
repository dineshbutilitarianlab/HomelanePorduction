public with sharing class AWS_CustomEmailTempcontroller {
    public String query {get; set;}
    public List<EmailTemplate> lstEmailTemplates {get; set;}
    public String emailFolder {get; set;}
    public list<SelectOption> options {get;set;}
    public static String soql = 'SELECT ApiVersion,Body,BrandTemplateId,CreatedById,CreatedDate,Description,DeveloperName,Encoding,EntityType,FolderId,HtmlValue,Id,IsActive,LastModifiedById,LastModifiedDate,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,SystemModstamp,TemplateStyle,TemplateType,TimesUsed,UiType FROM EmailTemplate Where IsActive = true';
	Public  static URL__c currentURL{get;set;}
    public AWS_CustomEmailTempcontroller(){
    	currentURL = URL__c.getInstance('Env'); 
        map<Id,String> folderNames = new map<Id,String>();
        lstEmailTemplatesWrapper = new list<EmailTemplatesWrapper>();
        
        folder obj = [SELECT AccessType,CreatedById,CreatedDate,DeveloperName,Id,IsReadonly,LastModifiedById,LastModifiedDate,Name,NamespacePrefix,SystemModstamp,Type FROM Folder
        where DeveloperName =: 'File_Attachment'];
        
        lstEmailTemplates = [SELECT ApiVersion,Body,BrandTemplateId,CreatedById,CreatedDate,Description,
                            DeveloperName,Encoding,EntityType,FolderId,HtmlValue,Id,IsActive,LastModifiedById,
                            LastModifiedDate,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,
                            SystemModstamp,TemplateStyle,TemplateType,TimesUsed,UiType,Folder.Name FROM EmailTemplate
                            Where IsActive = true and FolderId =: obj.id];
        
        system.debug(' lstEmailTemplates Yes : '+lstEmailTemplates);
                    
        if(!lstEmailTemplates.isEmpty()){
            for(EmailTemplate each : lstEmailTemplates){
                String fId = string.valueOf(each.FolderId);
                
                if (fId.substring(0,3) == '005') 
                { folderNames.put(each.folderId,'Personal Folder');}
                else if (fId.substring(0,3) == '00D')
                   { folderNames.put(each.folderId,'Public Folder');}
                else
                   { folderNames.put(each.folderId,each.folder.name);}
                system.debug(' each.folder.name : '+each.folder.name);
            }
        }
        
        options = new List<SelectOption>();
        for(Id NameF : folderNames.keyset()){
            options.add(new SelectOption(NameF,folderNames.get(NameF)));
        }
    }
    
    
    public void find()
    {
        lstEmailTemplates = new List<EmailTemplate>();
        lstEmailTemplatesWrapper = new list<EmailTemplatesWrapper>();
        String filter =String.escapeSingleQuotes(emailFolder);
        filter =filter.substring(1, filter.length()-1);
        
        system.debug('  emailFolder : '+emailFolder+ 'filter : '+filter);
        
        try {
            
                soql += ' and folderId = \''+filter+'\'';
                system.debug('  soql : '+soql);
                
                lstEmailTemplates = Database.query(soql);
                
               /* if(!lstEmailTemplates.isEmpty()){
                    for(EmailTemplate each : lstEmailTemplates){
                        EmailTemplatesWrapper obj = new EmailTemplatesWrapper();
                        obj.emailId    = each.Id;
                        obj.emailName    = each.Name;
                        obj.emailHtmlvalue    = each.HtmlValue;
                        lstEmailTemplatesWrapper.add(obj);
                    }
                } */
              } 
          catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! No Match Found'));
          }
    }     
    
    public list<EmailTemplatesWrapper> lstEmailTemplatesWrapper{get;set;}
    public class EmailTemplatesWrapper{
        public String emailId{get;set;}
        public String emailName{get;set;}
        public String emailHtmlvalue{get;set;}
    }   
}