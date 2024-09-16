@isTest(SeeAllData = true)
private class LeadPushToAmeyoQueueable_Test{
     /*static testMethod void checkCallout(){
           Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
         User wta_user = new User(alias = 'amey', email='ameyousertest45@homelane.com',
                emailencodingkey='UTF-8', lastname='Ameyo User', languagelocalekey='en_US',localesidkey='en_US', profileid = profileData.get('WTA Profile'), country='India',IsActive =true,timezonesidkey='America/Los_Angeles', username='ameyousertest45@homelane.com');
        insert wta_user;
        Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Noida';
       insert objRA;
        lead leadRec1=leadUtil_Test.insertLead('parini1@gmail.com','1342563562');
         leadRec1.PostalCode='561284';
         leadRec1.Status='Fresh Lead';
         leadRec1.Sub_Status__c ='New';
         leadRec1.Lead_Assingment__c=true;
         leadRec1.City='Bengaluru';
         leadRec1.OwnerId = wta_user.Id;
         leadRec1.WT_Agent__c = wta_user.Id;
         leadRec1.Ameyo_Call_Attempts__c = 8;
         List<Lead> lstLead = new List<Lead>();
         try{
          insert leadRec1;
           lstLead.add(leadRec1);
         }catch(Exception exp){
            Lead objLD = [Select id, name,LeadSource, Phone,Status, email, city, Company,
            Duplicate_Record__c,Customer_ID__c from Lead where
            Phone = '1234567890' LIMIT 1];
            lstLead.add(objLD);
         }
          
        
        Test.startTest();
       // Set mock callout class  
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorAmeyo());
        
         // Call the method that invokes a callout
         
         LeadPushToAmeyoQueueable obj = new LeadPushToAmeyoQueueable(lstLead,'dskjhskjcbdbcbb');
         System.enqueueJob(obj);
           
         Test.stopTest();
    }
    
    static testMethod void checkCallout1(){
        Test.startTest();
       // Set mock callout class  System.enqueueJob(updater);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorAmeyo());
        
         // Call the method that invokes a callout
            LeadPushToAmeyoQueueable.pushToAmeyo('updateContactSessionId-Invalid','test','Test','Bengaluru','dskjhskjcbdbcbb');
         Test.stopTest();
    }
    static testMethod void checkCallout2(){
        Test.startTest();
       // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorAmeyo());
        
         // Call the method that invokes a callout
            LeadPushToAmeyoQueueable.checkSessionId('valid Session');
         Test.stopTest();
    }
    static testMethod void checkCallout3(){
        Test.startTest();
       // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorAmeyo());
        
         // Call the method that invokes a callout 
            LeadPushToAmeyoQueueable.getAmeyoSessionId('CustomerManager1','passwoed');
         Test.stopTest();
    }
    static testMethod void checkCallout4(){
        Test.startTest();
       // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorAmeyo());
        
         // Call the method that invokes a callout 1234567865
            LeadPushToAmeyoQueueable.PushLeadToAmeyo('updateContactlead-Invalid','test','Bengaluru','dskjhskjcbdbcbb');
         Test.stopTest();
    }
    static testMethod void checkCallout5(){
        Test.startTest();
       // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorAmeyo());
        
         // Call the method that invokes a callout
            LeadPushToAmeyoQueueable.PushLeadToAmeyo('1234567865','test','Bengaluru','dskjhskjcbdbcbb');
         Test.stopTest();
    }
    static testMethod void checkCallout6(){
        Test.startTest();
       // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorAmeyo());
        
         // Call the method that invokes a callout
            LeadPushToAmeyoQueueable.pushToAmeyo('d224-5ad8bd34-ses-CustomerManager-vc2JkjaF-14','Test','test','Bengaluru','dskjhskjcbdbcbb');
         Test.stopTest();
    }*/
}