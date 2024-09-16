@isTest
Public class UpdateStatustoUnSuccessFull_Batch_Test{

    public static testmethod void success(){
    
     Map<String,String> mapRecordType = new Map<String,String>();
        Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
        for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
        mapRecordType.put(reType.getDeveloperName(),reType.getRecordTypeId());
        }
         
        Profile pf1 = [Select Id from Profile where Name = 'Standard User'];
        User u1 = new User();        
        u1 .LastName = 'Manager1';
        u1 .Email = 'test@test123456789.com';
        u1 .CompanyName = 'test.com';
        u1 .Title = 'Test User1';
        u1 .Username = 'testuser12345678@test133456789.com';
        u1 .Alias = 'test';
        u1 .CommunityNickname = 'Test User12';
        u1 .TimeZoneSidKey = 'America/Mexico_City';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'ISO-8859-1';
        u1.ProfileId = pf1.Id;            
        u1.LanguageLocaleKey = 'en_US';
        insert u1;
        
        Master__c m = new Master__c();
        m.isActive__c = true;
        m.Type__c = 'Showroom';
        m.Name = 'OMR Thoraipakkam Showroom';
        m.Full_Name__c = 'OMR Thoraipakkam Showroom';
        m.Total_Won_Opportunity__c = 6;
        m.Avg_Opportunites_Month__c = 20;
        m.Location__latitude__s = 12.971100;
        m.Location__longitude__s = 77.640920;
        m.RecordTypeId = mapRecordType.get('Property');
        m.PlaceId__c = 'qwyriophdiepo';
        m.Pilot_ShowRoom__c = true;
        m.SM__c = u1.id;
        m.BU__c = u1.id;

        insert m;
           
        
        Account ac=new Account(); 
        ac.Name ='Hamsa Raj';
        insert ac;
            
        Lead l = new Lead();
        l.FirstName = 'Hamsa';
        l.LastName = 'Raj';
        l.Email = 'HamsaRaj@gmail.com';
        l.Phone = '9000000009';
        l.City = 'Bengaluru';
        l.LeadSource = 'Google Ad';
        l.Status = 'Appointment Fixed';
        l.Sub_Status__c = 'Appointment Fixed';
        l.Appointment_Time__c=  datetime.now().addhours(-18);
        l.Appointment_Type__c = 'Virtual Meeting';
        l.Appointment_Venue_Square__c = m.id;
        l.Kitchen__c= 'Yes';
        l.Crockery_Unit__c= 'No';
        l.Wardrobes__c= '0';
        l.Entertainment_Unit__c= 'No';
        l.Pooja__c= 'No';
        l.Study_Table_Book_Shelf__c= 'No';
        l.Foyer_Shoe_Rack__c= 'No';
        l.Interior_Start_Date__c = date.today()+14;
        l.Possession_Date__c = date.today()+24;
        l.Property_Status__c = 'New';
        l.Property_Config__c = '1 BHK';
        l.Property__c = m.id;
        l.Property_Type__c = 'Apartment';
        l.WT_Agent__c = u1.id;
        l.Account__c= ac.id;
        insert l;
        
        
        UpdateStatustoUnSuccessFull_Batch  sh1 = new UpdateStatustoUnSuccessFull_Batch ();
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Check', sch, sh1); 
        
        UpdateStatustoUnSuccessFull_Batch  obj = new UpdateStatustoUnSuccessFull_Batch ();
        DataBase.executeBatch(obj);
    }
}