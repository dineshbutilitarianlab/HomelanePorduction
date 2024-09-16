public class AutoLeadCreationController {

    public id id{get;set;}
    public Lead lea{get;set;}
    public Boolean status{get;set;}
    public List<SelectOption> optionList{get;set;}
    public String selectedOption {get;set;}
    public String lastName{get;set;}
    public String email {get;set;}
    public String phone{get;set;}
    public String intDesign{get;set;}
    
    public List<SelectOption> cityListOption{get;set;}
    public string cityOption1{get;set;}
    public List<SelectOption> showroomListOption{get;set;}
    public string showroomOption1{get;set;}
   
    public AutoLeadCreationController() {
        status = false;
        Lead l = new Lead();
        l = lea;
        System.debug('---lea  '+lea+'  ---id  '+id);        
        optionList = new List<SelectOption>();
        cityListOption = new List<SelectOption>();
        showroomListOption = new List<SelectOption>();
        
        // Is this a test lead - options.
        SelectOption option = new SelectOption('---None---','---None---');
        optionList.add(option);
        option = new SelectOption('Yes','Yes');
        optionList.add(option);
        option = new SelectOption('No','No');
        optionList.add(option);
        
        // city options
        SelectOption cityOption = new SelectOption('---None---','---None---');
        cityListOption.add(cityOption);
        cityOption = new SelectOption('Bengaluru','Bengaluru');
        cityListOption.add(cityOption);
        cityOption = new SelectOption('Mumbai','Mumbai');
        cityListOption.add(cityOption);
        cityOption = new SelectOption('Chennai','Chennai');
        cityListOption.add(cityOption);
        cityOption = new SelectOption('Hyderabad','Hyderabad');
        cityListOption.add(cityOption);
        cityOption = new SelectOption('New Delhi','New Delhi');
        cityListOption.add(cityOption);
        cityOption = new SelectOption('Noida','Noida');
        cityListOption.add(cityOption);
        cityOption = new SelectOption('Gurgaon','Gurgaon');
        cityListOption.add(cityOption);
        cityOption = new SelectOption('Ghaziabad','Ghaziabad');
        cityListOption.add(cityOption);
        cityOption = new SelectOption('Thane','Thane');
        cityListOption.add(cityOption);
        cityOption = new SelectOption('Kolkata','Kolkata');
        cityListOption.add(cityOption);
        cityOption = new SelectOption('Other','Other');
        cityListOption.add(cityOption);
        
        // showroom options
        SelectOption showroomOption = new SelectOption('---None---','---None---');
        showroomListOption.add(showroomOption);
        showroomOption = new SelectOption('Kanakapura Showroom','Kanakapura Showroom');
        showroomListOption.add(showroomOption);
        showroomOption = new SelectOption('Hebbal Showroom','Hebbal Showroom');
        showroomListOption.add(showroomOption);
        showroomOption = new SelectOption('Gopalan Showroom','Gopalan Showroom');
        showroomListOption.add(showroomOption);
        showroomOption = new SelectOption('Whitefield Showroom','Whitefield Showroom');
        showroomListOption.add(showroomOption);
        showroomOption = new SelectOption('Bellandur Mini Showroom','Bellandur Mini Showroom');
        showroomListOption.add(showroomOption);        
        showroomOption = new SelectOption('CoWrks OMR','CoWrks OMR');
        showroomListOption.add(showroomOption);        
        showroomOption = new SelectOption('Goregaon Coworks','Goregaon Coworks');
        showroomListOption.add(showroomOption);
        showroomOption = new SelectOption('Noida CoWorks','Noida CoWorks');
        showroomListOption.add(showroomOption);
        showroomOption = new SelectOption('Gurgaon Showroom','Gurgaon Showroom');
        showroomListOption.add(showroomOption);
        showroomOption = new SelectOption('Kodambakkam Showroom','Kodambakkam Showroom');
        showroomListOption.add(showroomOption);
        showroomOption = new SelectOption('Gachibowli Showroom','Gachibowli Showroom');
        showroomListOption.add(showroomOption);
        showroomOption = new SelectOption('HSR Showroom','HSR Showroom');
        showroomListOption.add(showroomOption);
        showroomOption = new SelectOption('Thane Showroom','Thane Showroom');
        showroomListOption.add(showroomOption);
        showroomOption = new SelectOption('Test Showroom','Test Showroom');
        showroomListOption.add(showroomOption);
       
    }
    
    public pageReference autoLead() {
        Id personAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account> listOfAccountWithEmail = new List<Account>();
        List<Account> listOfAccountWithPhone = new List<Account>();
       /* selectedOption = ApexPages.currentPage().getParameters().get('selectedOption');
        cityOption1 = ApexPages.currentPage().getParameters().get('cityOption1');
        showroomOption1 = ApexPages.currentPage().getParameters().get('showroomOption1');
        intDesign  = ApexPages.currentPage().getParameters().get('intDesign');
        phone = ApexPages.currentPage().getParameters().get('phone');
        email = ApexPages.currentPage().getParameters().get('email');
        lastName = ApexPages.currentPage().getParameters().get('lastName');  */  
        
        System.debug('------lastName  '+lastName );
        System.debug('------selectedOption '+selectedOption );
        System.debug('------cityOption1  '+cityOption1);
        System.debug('------showroomOption1  '+showroomOption1 );
        System.debug('------intDesign  '+intDesign );
        System.debug('------phone  '+phone );
        System.debug('------email  '+email);
        listOfAccountWithEmail = [Select Id from Account where PersonEmail = :email];
        listOfAccountWithPhone = [Select Id from Account where Phone = : phone];
        // mapping test showroom and default property
        Map<String,Id> mapMaster = new Map<String,Id>();
        List<Master__c> maList = [select id,name from Master__c where name = 'Test Showroom' or name = 'Default Property' limit 2];
        for(Master__c m : maList) {
            mapMaster.put(m.Name,m.Id);
        }
        
        // check if selectedOption is none
        if(selectedOption == '---None---') {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Select Is it a test lead?'));   
        }
        
        // check if lastName is null
        else if(lastName == null || lastName == '') {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please fill lead name field'));
        }
        
        // check if city is null
        else if(cityOption1 == '---None---') {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Select City'));   
        }
        
        // check if showroom is null
        /*else if(showroomOption1 == '---None---') {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Select Showroom'));   
        }*/
        else if(String.isBlank(intDesign)) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Interior Designer Email cannot be blank.')); 
        }
       // check if interior designer email has @homelane.com
       else if(intDesign != null && !intDesign.containsIgnoreCase('@homelane.com')) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Interior Designer Email must contain @homelane.com')); 
        }
        
        // check if phone has 10 digit pattern        
        else if(phone !=null && !Pattern.matches('\\D*?(\\d\\D*?){10}', phone)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Phone is either not 10 digits OR there is an alphabet while entering phone'));   
        }
        
        // check if lastName contains test
        else if(lastName.containsIgnoreCase('Test')) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Name cannot contain TEST')); 
        }
        
        // check if email contains test
        else if(email.containsIgnoreCase('Test')) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Email cannot contain TEST'));
        }
        
        // check if email is null
        else if(email == null || email == '') {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please fill lead email field'));
        }
        
        // check if email contains @ symbol
        else if(!email.containsIgnoreCase('@')) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Email must contain @ symbol'));
        }
        else if(!listOfAccountWithEmail.isEmpty() && !listOfAccountWithPhone.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'An account exists with same email and Phone'));
        }
        else if(!listOfAccountWithEmail.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'An account exists with same email'));
        }
        else if(!listOfAccountWithPhone.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'An account exists with same Phone'));
        }
      // else if all conditions fail   
     else {
     try {
        
        Lead l = new Lead();      
        l.lastName = lastName;       
        l.email = email;        
        l.city = cityOption1;
        l.phone = phone;
        
        // marking showroom and source as test showroom and test source resp if option is yes
        //if(selectedOption == 'Yes') {
            l.leadSource = 'Test Source';
            if(mapMaster.containsKey('Test Showroom'))
            l.Appointment_Venue_Square__c = mapMaster.get('Test Showroom');
        //}
        // mark source as PDDE Lead Form if option is no
        //else if(selectedOption == 'No') {
          //  l.leadSource = 'PDDE Lead Form';
        //}
        Id idInte;
        Id idmas;
             try {       
           Interior_Designer__c inte = [select id, name, email__c from Interior_Designer__c where  email__c =: intDesign limit 1];
           idInte =  inte.Id;
           System.debug('INSIDE TRY DP');
            }
           catch(Exception e) { 
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Interior Designer does not exist with the mentioned email address')); 
           System.debug('INSIDE CATCH DP');
            }
            
         if(l.Appointment_Venue_Square__c == null) {   
         try {           
            Master__c mas = [select id, name from Master__c where name like : '%'+showroomOption1+'%' and type__c = 'Showroom' and isActive__c = true limit 1];
            l.Appointment_Venue_Square__c = mas.Id;
            System.debug('INSIDE TRY MASTER');
          }
           catch(Exception e) {    
            System.debug('INSIDE CATCH MASTER');
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There is no active showroom record with this name.'));  
            }
            }
          
          // assign all mandatory fields  
        l.Interior_Designer__c = idInte;
        l.Status = 'DP Assigned';
        l.Sub_Status__c = 'DP Assigned';
        l.Property_Type__c = 'Apartment';
        l.Property_Config__c = '1 BHK';
        l.Property_Status__c = 'New';
        l.Interior_Start_Date__c = date.today();
        l.Possession_Date__c = Date.today();
        l.Kitchen__c = 'Yes';
        l.Wardrobes__c = '0';
        l.Entertainment_Unit__c = 'Yes';
        l.Foyer_Shoe_Rack__c  = 'Yes';
        l.Crockery_Unit__c = 'Yes';
        l.Study_Table_Book_Shelf__c = 'Yes';
        l.Pooja__c = 'Yes';
        l.Appointment_Time__c = system.now();
        l.Appointment_Type__c = 'Square Showroom Visit';
        if(mapMaster.containsKey('Default Property'))
        l.Property__c = mapMaster.get('Default Property');
        Account acc = new Account();
        acc.Phone = phone;
        acc.PersonEmail = Email;
        acc.Test_Lead__c = true;
        acc.LastName = lastName;
        acc.RecordTypeId = personAccountRT;
        if(idInte != null && (l.email != null || l.email == '')) {
        insert acc;
        l.Account__c = acc.Id;
        insert l;
        
          status = true;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Record Successfully created')); 
        }
        return null;        
        }
        
        catch(Exception ex) {
            ApexPages.addMessages(ex);
            return null;
        }
        }
        return null; 
        
    } 
 
}