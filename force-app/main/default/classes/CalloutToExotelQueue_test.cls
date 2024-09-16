@istest
global class CalloutToExotelQueue_test  {
    
     public static  Integration_Setting__c  intSetting ;
    Public static Lead ld;
    public static master__c prop;
    @TestSetup static void data() { 
        intSetting = new Integration_Setting__c();
        intSetting.Name = 'Exotel API';
        intSetting.End_Point__c ='https://88f2905a42807de7499a2e23bae7c99e5745d496f3e76427:72f89a2e7c8d2e1302769ceafb1fb035eed1e6b6ba006592@api.exotel.com/v1/Accounts/homelane4/Calls/connect?' ;   
        insert intsetting ;

        Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.Email__c ='showroomuser@gmail.com';
        objShowroom1.Phone__c = '9911882266';
        objShowroom1.Threashold__c = 10;
        objShowroom1.Backlogs__c = 2;
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Bronze';
        insert ObjShowroom1;
              
        account acc= new account();
        acc.name='Tetsacc';
        insert acc;
         //Create User record
        
       
        ld = TestData_Factory.CreateFreshLead(false);
        ld.Account__c =acc.id;
        ld.city='Bengaluru';
        ld.Phone='9988772244';
        insert ld;
        
    }
    
    
    
    public testMethod static void testscenario1(){
        
        
        
        test.startTest();
        try
        {
            intsetting = [select id from Integration_Setting__c limit 1 ];
            
            ld=[select id,phone from lead limit 1];                        
            
            List<Id> LeadIds = new List<Id>();
            LeadIds.add(ld.id);
            
            CalloutToExotelQueue.CallExotelAPI(LeadIds);
        }
        catch(exception e)
        {
            system.debug('exception');
        }
        
        test.stoptest();
        
    }
    
}