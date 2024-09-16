@isTest
Public class AssignLeadToIronMan_Test{
    public static testMethod void freshLeadNew(){
        
        try{
            WTA_Flow__c objFlow = new WTA_Flow__c();
            objFlow.Name = 'Flow2';
            objFlow.isActive__C  = true;
            insert ObjFlow;
            
            User objUser = TestData_Factory.inserWTAUser('Test@mailnator.com','TM',False);
            objUser.lastname = 'Cloud Agent';
            Insert objUser;
            
            Lead_Round_Robin_Assignment__c objIronManAssignment =  TestData_Factory.createIronMan(objUser,False);
            insert objIronManAssignment;
            
            lead objLead = new Lead();
            objlead = TestData_Factory.CreateFreshLead(false);
            Insert objlead;
            
            objlead.Closest_Showroom__c = 'HSR showroom 1.1Km';
            Update objlead; 
            
        }
        catch(Exception e){
        }    
        
    }
    
    
    public static testMethod void AssignToWTAGroupA(){
        try{
            WTA_Flow__c objFlow = new WTA_Flow__c();
            objFlow.Name = 'Flow2';
            objFlow.isActive__C  = true;
            insert ObjFlow;
            
            User objUser = TestData_Factory.inserWTAUser('Test@mailnator.com','TM',False);
            Insert objUser;
            
            WTA_Assignment__c WTAAssignment = TestData_Factory.inserWTAAssignment(objUser,'Group A', false);
            insert WTAAssignment;
            
            lead objLead = new Lead();
            objlead = TestData_Factory.CreateFreshLead(false);
            Insert objlead;
            objlead.Closest_Showroom__c = 'HSR showroom 1.1Km';
            Update objlead; 
            AssignLeadToIronMan objclass = new AssignLeadToIronMan(objlead);
            objclass.AssignToWTA(objlead);
        }
        catch(Exception e){
        }   
        
    }
    
    public static testMethod void AssignToWTAGroupB(){
        try{
            WTA_Flow__c objFlow = new WTA_Flow__c();
            objFlow.Name = 'Flow2';
            objFlow.isActive__C  = true;
            insert ObjFlow;
            
            User objUser = TestData_Factory.inserWTAUser('Test@mailnator.com','TM',False);
            Insert objUser;
            
            WTA_Assignment__c WTAAssignment = TestData_Factory.inserWTAAssignment(objUser,'Group B', false);
            insert WTAAssignment;
            
            lead objLead = new Lead();
            objlead = TestData_Factory.CreateFreshLead(false);
            Insert objlead;
            objlead.Closest_Showroom__c = 'HSR showroom 1.1Km';
            Update objlead; 
            
            AssignLeadToIronMan objclass = new AssignLeadToIronMan(objlead);
            objclass.AssignToWTA(objlead);        
        }
        catch(Exception e){
        }   
    }
    
    
    public static testMethod void ironManNotFoundForShowroom(){
        try{
            WTA_Flow__c objFlow = new WTA_Flow__c();
            objFlow.Name = 'Flow2';
            objFlow.isActive__C  = true;
            insert ObjFlow;
            
            User objUser = TestData_Factory.inserWTAUser('Test@mailnator.com','TM',False);
            objUser.lastname = 'Cloud Agent';
            Insert objUser;
            
            Lead_Round_Robin_Assignment__c objIronManAssignment =  TestData_Factory.createIronMan(objUser,False);
            objIronManAssignment.Showroom_Name__c = 'Test';
            insert objIronManAssignment;
            
            lead objLead = new Lead();
            objlead = TestData_Factory.CreateFreshLead(false);
            Insert objlead;
            
            objlead.Closest_Showroom__c = 'HSR showroom 1.1Km';
            Update objlead; 
        }
        catch(Exception e){
        }
    }
    
    
    public static testMethod void noIronManRecord(){
        try{
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
        catch(Exception e){
        }
    }
    
    public static testMethod void freshLeadRelanded(){
        try{
            WTA_Flow__c objFlow = new WTA_Flow__c();
            objFlow.Name = 'Flow2';
            objFlow.isActive__C  = true; 
            insert ObjFlow;
            
            User objUser1 = TestData_Factory.inserWTAUser('Test@mailnator.com','TM',False);
            objUser1.lastname = 'Cloud Agent';
            Insert objUser1;
            
            Lead_Round_Robin_Assignment__c objIronManAssignment =  TestData_Factory.createIronMan(objUser1,False);
            insert objIronManAssignment;
            
            lead objLead = new Lead();
            objlead = TestData_Factory.CreateFreshLead(false);
            objlead.Closest_Showroom__c = 'HSR showroom 1.1Km';
            Insert objlead;
            objlead.Sub_Status__c = 'Re-Landed';
            Update objlead;
        }
        catch(Exception e){
        }
    }
    
    
    public static testMethod void AppointmentFixed(){
        try{
            WTA_Flow__c objFlow = new WTA_Flow__c();
            objFlow.Name = 'Flow2';
            objFlow.isActive__C  = true;
            insert ObjFlow;
            
            User objUser = TestData_Factory.inserWTAUser('Test@mailnator.com','TM',False);
            objUser.lastname = 'Cloud Agent';
            Insert objUser;
            
            Lead_Round_Robin_Assignment__c objIronManAssignment =  TestData_Factory.createIronMan(objUser,False);
            insert objIronManAssignment;
            
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
        catch(Exception e){
        }
    }
    public static testMethod void AssignOffBusinessHrLeadTest1(){
        try{
            WTA_Flow__c objFlow = new WTA_Flow__c();
            objFlow.Name = 'Flow2';
            objFlow.isActive__C  = true; 
            insert ObjFlow;
            
            User objUser1 = TestData_Factory.inserWTAUser('Test@mailnator.com','TM',False);
            objUser1.FirstName = 'Test Round';
            objUser1.lastname = 'Robin';
            //objUser1.Name = 'Test Round Robin';
           	
            Insert objUser1;
            User u = [Select id,Name from user where id=:objUser1.id];
            System.debug('u: '+u);
            
            Lead_Round_Robin_Assignment__c objIronManAssignment =  TestData_Factory.createIronMan(objUser1,False);
            insert objIronManAssignment;
            
            Round_Robin__c roundRobin = TestData_Factory.createRoundRobin('Test Round Robin',true);
            
            Lead_Assignment__c leadAssignment = TestData_Factory.createLeadAssignment(roundRobin.Name,roundRobin.Id,objUser1.Id,true);
            
            lead objLead = new Lead();
            objlead = TestData_Factory.CreateFreshLead(false);
            objlead.Closest_Showroom__c = 'HSR showroom 1.1Km';
            objlead.OwnerId = u.id;
            Insert objlead;
            
            Lead ld = [Select id,OwnerId,Owner.Name from Lead where id=:objlead.id limit 1];
            System.debug('ld: '+ld);
            System.debug('ld: objUser1 id:'+u.id);
            System.debug('ld: objUser1 Name:'+u.Name);
            AssignLeadToIronMan.AssignOffBusinessHrLead(ld);
        }
        Catch(Exception e){
            
        }
    }
}