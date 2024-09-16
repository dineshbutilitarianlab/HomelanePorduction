@isTest
Public class Lead_Assignment_Handler_Test{
    public static testMethod void freshLeadNew(){

        WTA_Flow__c objFlow = new WTA_Flow__c();
        objFlow.Name = 'Flow2';
        objFlow.isActive__C  = true;
        insert ObjFlow;
        
        lead objLead = new Lead();
        objlead = TestData_Factory.CreateFreshLead(false);
        Insert objlead;
       
        objlead.Closest_Showroom__c = 'HSR showroom 1.1Km';
        Update objlead;
    }

     
    public static testMethod void freshLeadRelanded(){ 

        WTA_Flow__c objFlow = new WTA_Flow__c();
        objFlow.Name = 'Flow2';
        objFlow.isActive__C  = true; 
        insert ObjFlow;
        
        lead objLead = new Lead();
        objlead = TestData_Factory.CreateFreshLead(false);
        objlead.Closest_Showroom__c = 'HSR showroom 1.1Km';
        Insert objlead;
        objlead.Sub_Status__c = 'Re-Landed';
        Update objlead;
    }


    public static testMethod void AppointmentFixed(){

        WTA_Flow__c objFlow = new WTA_Flow__c();
        objFlow.Name = 'Flow2';
        objFlow.isActive__C  = true;
        insert ObjFlow;
        
        master__c NewShowRoom = TestData_Factory.CreateShowRoom(false);
        insert NewShowRoom;

        lead objLead = new Lead();
        objlead = TestData_Factory.CreateFreshLead(false);
        objlead.Appointment_Venue_Square__c  = NewShowRoom.id;
        objlead.Closest_Showroom__c = 'HSR showroom 1.1Km';
        Insert objlead;

        objlead = TestData_Factory.MarkAsAppointmentFixed(objlead);
        Update objlead;
    }

   /* public static testMethod void ChangeOwnerTOCloudAgent(){
        try{
            Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
            WTA_Flow__c objFlow = new WTA_Flow__c();
            objFlow.Name = 'Flow2';
            objFlow.isActive__C  = true;
            insert ObjFlow;
    
            lead objLead = new Lead();
            objlead = TestData_Factory.CreateFreshLead(false);
            objlead.Closest_Showroom__c = 'HSR showroom 1.1Km';
            Insert objlead;
    
            User objUser = TestData_Factory.inserWTAUser('Test@mailnator.com','TM',False);
            objUser.lastname = 'Cloud Agent';
            Insert objUser;
    
            test.starttest();
            objlead.Ownerid = objUser.id;
            objlead.WT_Agent__c = objUser.id;
            Update objlead;
            test.stoptest();
         }
         catch(exception e){
         }

    }*/

    


}