@isTest
Public class AssignLeadToWTAGroup_Test{
     public static testMethod void AssignToWTAGroupA(){

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
        objlead.Closest_Showroom__c = 'HSR showroom 1.1Km';
        Insert objlead;
          
         test.startTest(); 
        AssignLeadToWTAGroup.AssignLeadToWTAGroupA_GroupB(objlead);
        test.stopTest(); 
        
    }

    public static testMethod void AssignToWTAGroupB(){

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
        objlead.Closest_Showroom__c = 'HSR showroom 1.1Km';
        Insert objlead;
        
        test.startTest(); 
        AssignLeadToWTAGroup.AssignLeadToWTAGroupA_GroupB(objlead);
        AssignLeadToWTAGroup.asssigntoGroupB(objlead);
        AssignLeadToWTAGroup.getGroupBDetails(objlead);
        AssignLeadToWTAGroup.getGroupADetails(objlead);
        test.stoptest(); 
        
    }
}