public class LeadTriggerHandlerHelper {
    
    public static void fbleadCaptureData(list <lead> fbleadList)
    {
        SYstem.debug('fbleadCaptureData');
        Boolean LeadWithSameBrandExists = false;
        set<string> pincodeSet = new Set<string>();
        set<string> phoneSet = new Set<string>();
        set<string> emailSet = new Set<string>();
        List<Territory__c> terriList = new List<Territory__c>();
        Account acFb = new Account();
        List<Account> accountList = new List<Account>();
        List<Lead> listOfLeads = new  List<Lead>();
        Integer monthsToAdd;
        ID AccountID;
        try
        {       
            
            for(Lead ld:fbleadList)
            {
                pincodeSet.add(ld.postalcode);
                phoneset.add(ld.Phone);
                emailset.add(ld.Email);
                SYstem.debug('Lead :'+ ld);
            }
            
            if(!pincodeSet.isEmpty())
            {
              	terriList = [select id, City__c from Territory__c where Pincode__c In: pincodeSet] ;                	
            }
            system.debug('terriList '+terriList);
            system.debug('phoneSet '+phoneSet);
            
            // Fetch the existing Account with same Phone number or Email
            if(!phoneSet.isEmpty())
            {
              	accountList = [select id, Phone,FirstName,LastName,PersonEmail from Account where (Phone IN: phoneSet OR PersonEmail IN: emailset)] ;                  
            }
            system.debug('accountList '+accountList);
            
            //Fetch the Leads on Existing Account with same Brand
            if(!accountList.isEmpty())
            {
                listOfLeads = [select id, Phone from Lead where Account__r.id = :accountList[0].id  AND Brand__c = :fbleadList[0].Brand__c ] ;  
                if(!listOfLeads.isEmpty())
                {
                    	LeadWithSameBrandExists = true;
                }
            }
            
            for(lead ld:fbleadList)
            {
                if(!terriList.isEmpty())
                {    
                    System.debug('terriList[0].City__c in for Loop :'+ terriList[0].City__c);
                    acFb.BillingCity =terriList[0].City__c;
                    SYstem.debug('acFb.BillingCity :'+ acFb.BillingCity);
                    ld.City = '';
                    SYstem.debug('Lead City Null :'+ ld.City);
                    ld.City = ld.City.replace(ld.City,terriList[0].City__c);
                    SYstem.debug('Lead City :'+ ld.City);
                } 
                else
                {
                    ld.City = ld.City.replace(ld.City,'Others');
                    ld.Lead_Assingment__c = true;
                    SYstem.debug('Lead City Others:'+ ld.City);
                }
                
                
                String input = ld.Phone;
                Pattern pattern = Pattern.compile('^\\+(\\d{1,3})\\s*(\\d{10})$');
                Matcher matcher = pattern.matcher(input);
                
                //If Account exists with same phone number but Lead with Same Brand does not exist we will tag the Lead to the existing Account
                if(!accountList.isEmpty() && !LeadWithSameBrandExists)
                {                    	
                    	SYstem.debug('Account exists');
                    
                    	// Copy FirstName,LastName, Email and Phone values from Account to Lead
                    	ld.FirstName = String.isNotBlank(accountList[0].FirstName) ? accountList[0].FirstName :'';
                    	ld.LastName = String.isNotBlank(accountList[0].LastName) ? accountList[0].LastName :'';
                    	ld.Email = String.isNotBlank(accountList[0].PersonEmail) ? accountList[0].PersonEmail :'';
                    	ld.Phone = String.isNotBlank(accountList[0].Phone) ? accountList[0].Phone :'';
                    
                    	if (matcher.matches()) 
                        {
                            ld.Area_Code__c = matcher.group(1);
                            ld.Phone = matcher.group(2);
                        }   
                        
                    	AccountID = accountList[0].Id;
                    	system.Debug(AccountID);	
                }
                // 1.If Account exists with same phone number and Lead with Same Brand also exists, we will try to create new account which will restrict the duplicate account creation
                // 2.If Account does not exist with same phone number then we will create the new Account
                else if((!accountList.isEmpty() && LeadWithSameBrandExists) || accountList.isEmpty())
                {
                      	SYstem.debug('Account does not exist/ Account exists but lead with Same brand exists');
                        if (matcher.matches()) 
                        {
                            ld.Area_Code__c = matcher.group(1);
                            acFb.Area_Code__c=matcher.group(1);
                            acFb.Phone=matcher.group(2);
                            ld.Phone = matcher.group(2);
                        }              
                        
                        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                        acFb.RecordTypeId = recTypeId;
                        acFb.PersonEmail =ld.Email;
                        acFb.Phone = ld.Phone;
                        acFb.LastName=ld.LastName;
                        insert acFb;          
                        
                        Account acctRecord = AccountSelector.getAccountById(acFb.Id);
                        system.Debug(acctRecord);
                    	AccountID = acctRecord.id;
                }
                
                if(AccountID != null)
                {
                    System.debug('Tag Lead to the account');
                    ld.Account__c =AccountID;
                }
                
                system.debug('ld.Description__c'+ ld.Description__c);
                if(!String.isBlank(ld.Description__c))
                {
                    monthsToAdd=  LeadTriggerHandlerHelper.checkMatcher(ld.Description__c);
                    Date givenDate = Date.today(); 
                    Date possessionDate = givenDate.addMonths(monthsToAdd);
                    ld.Possession_Date__c =  possessionDate ; 
                }  
            }
           
        }
        Catch(exception e)
        {
            system.debug('error'+ e.getMessage());
            system.debug('err'+e.getLineNumber()+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerHandlerHelper Class','fbleadCaptureData method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    public Static Integer checkMatcher(String str)
    {
        Integer monthsToadd;
        Pattern pattern1 = Pattern.compile('more_than');
        Matcher matcher1 = pattern1.matcher(str);
        Pattern pattern2 = Pattern.compile('between');
        Matcher matcher2 = pattern2.matcher(str);
        Pattern pattern3 = Pattern.compile('within');
        Matcher matcher3 = pattern3.matcher(str);
        
        if (matcher1.find()) 
        {
            monthsToadd =9;
        } 
        else if(matcher2.find())
        {
            monthsToadd =6;
        }
        else if(matcher3.find())
        {
            monthsToadd =3;
            system.debug('within');
        }
       
        system.debug('monthsToadd'+ monthsToadd);        
        return monthsToadd;
    }
    
    public static String CreateFbLeadJson (String fbId,String status)
    {
        String jsonBody;
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('data');
        gen.writeStartArray();
        gen.writeStartObject(); 
        gen.WriteStringField(GenericConstants.Event_Name ,status+' CAPI');
        gen.writeNumberField(GenericConstants.Event_Time ,DateTime.now().getTime() / 1000);
        gen.writeStringField(GenericConstants.Action_Source,GenericConstants.System_Generated );
        gen.writeFieldName(GenericConstants.USER_DATA);
        gen.writeStartObject();
        gen.writeFieldName('lead_id');
        gen.writeString(fbId);
        
        gen.writeEndObject();
        gen.writeFieldName(GenericConstants.CUSTOM_DATA);
        gen.writeStartObject();
        gen.writeFieldName(GenericConstants.Event_Source);
        gen.writeString('crm');
        gen.writeFieldName(GenericConstants.Lead_Event_Source);
        gen.writeString('salesforce');
        
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndArray();
     //   gen.WriteStringField(genericConstants.TEST_EVENT_CODE,Label.FB_Test_event_CAPI);
        gen.writeEndObject();           
        jsonBody = gen.getAsString();
        system.debug('json'+jsonBody);
        return  jsonBody;
    }
}