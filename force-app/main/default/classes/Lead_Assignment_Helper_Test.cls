@isTest
Public class Lead_Assignment_Helper_Test{
    public static testMethod void checkWTAStatus1(){
        try{
        WTA_Flow__c objFlow = new WTA_Flow__c();
        objFlow.Name = 'Flow2';
        objFlow.isActive__C  = true;
        insert ObjFlow;

        
        Integration_Setting__c intSet= new Integration_Setting__c();
        intSet.Name = 'OzoneTel Active Agent';
        intSet.End_Point__c = 'http://api1.cloudagent.in:4567/CAServices/v2/Test2?';
        intSet.Authorization__c = 'abcd';
        insert intSet;

        map<String,WTA_Assignment__c> mapWTAAssignment = new map<String,WTA_Assignment__c>();

        User objUser = TestData_Factory.inserWTAUser('Test@mailnator.com','TM',False);
        Insert objUser;

        User objUser1 = TestData_Factory.inserWTAUser('Test1@mailnator.com','TM',False);
        Insert objUser1;

        WTA_Assignment__c WTAAssignment = TestData_Factory.inserWTAAssignment(objUser,'Group A', false);
        insert WTAAssignment;
        mapWTAAssignment.put(objUser.Email,WTAAssignment);

        WTA_Assignment__c WTAAssignment1 = TestData_Factory.inserWTAAssignment(objUser1,'Group A', false);
        insert WTAAssignment1;
        mapWTAAssignment.put(objUser.Email,WTAAssignment1);
        system.debug('-----mapWTAAssignment---'+mapWTAAssignment);
       
        lead objLead = new Lead();
        objlead = TestData_Factory.CreateFreshLead(true);
        //Insert objlead;
        objlead.Description__C = 'HSR showroom 1.1Km';
         Update  objlead;
         test.startTest();
         Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());

        Lead_Assignment_Helper.checkWTAStatus(objlead,mapWTAAssignment,'TEST_AUTOLEAD');
        test.stopTest();
        }
        catch(Exception e){
        }

    }

    public static testMethod void checkWTAStatus2(){
        try{
        WTA_Flow__c objFlow = new WTA_Flow__c();
        objFlow.Name = 'Flow2';
        objFlow.isActive__C  = true;
        insert ObjFlow;
        
        Integration_Setting__c intSet= new Integration_Setting__c();
        intSet.Name = 'OzoneTel Active Agent';
        intSet.End_Point__c = 'http://api1.cloudagent.in:4567/CAServices/v2/Test?';
        intSet.Authorization__c = 'abcd';
        insert intSet;

        map<String,WTA_Assignment__c> mapWTAAssignment = new map<String,WTA_Assignment__c>();

        User objUser = TestData_Factory.inserWTAUser('Test@mailnator.com','TM',False);
        Insert objUser;

        User objUser1 = TestData_Factory.inserWTAUser('Test1@mailnator.com','TM',False);
        Insert objUser1;

        WTA_Assignment__c WTAAssignment = TestData_Factory.inserWTAAssignment(objUser,'Group A', false);
        insert WTAAssignment;
        mapWTAAssignment.put(objUser.Email,WTAAssignment);

        WTA_Assignment__c WTAAssignment1 = TestData_Factory.inserWTAAssignment(objUser1,'Group A', false);
        insert WTAAssignment1;
        mapWTAAssignment.put(objUser.Email,WTAAssignment1);
        system.debug('-----mapWTAAssignment---'+mapWTAAssignment);
       
        lead objLead = new Lead();
        objlead = TestData_Factory.CreateFreshLead(true);
        //Insert objlead;
        objlead.Description__C = 'HSR showroom 1.1Km';
         Update  objlead;
         test.startTest();
         Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());

        Lead_Assignment_Helper.checkWTAStatus(objlead,mapWTAAssignment,'TEST_AUTOLEAD');
        test.stopTest();
        }
        catch(Exception e){
        }
    }
    public static testMethod void checkWTAStatus3(){
        try{
        WTA_Flow__c objFlow = new WTA_Flow__c();
        objFlow.Name = 'Flow2';
        objFlow.isActive__C  = true;
        insert ObjFlow;
        
        Integration_Setting__c intSet= new Integration_Setting__c();
        intSet.Name = 'OzoneTel Active Agent';
        intSet.End_Point__c = 'http://api1.cloudagent.in:4567/CAServices/v2/Test1?';
        intSet.Authorization__c = 'abcd';
        insert intSet;

        map<String,WTA_Assignment__c> mapWTAAssignment = new map<String,WTA_Assignment__c>();

        User objUser = TestData_Factory.inserWTAUser('Test@mailnator.com','TM',False);
        Insert objUser;

        User objUser1 = TestData_Factory.inserWTAUser('Test1@mailnator.com','TM',False);
        Insert objUser1;

        WTA_Assignment__c WTAAssignment = TestData_Factory.inserWTAAssignment(objUser,'Group A', false);
        insert WTAAssignment;
        mapWTAAssignment.put(objUser.Email,WTAAssignment);

        WTA_Assignment__c WTAAssignment1 = TestData_Factory.inserWTAAssignment(objUser1,'Group A', false);
        insert WTAAssignment1;
        mapWTAAssignment.put(objUser.Email,WTAAssignment1);
        system.debug('-----mapWTAAssignment---'+mapWTAAssignment);
       
        lead objLead = new Lead();
        objlead = TestData_Factory.CreateFreshLead(true);
        //Insert objlead;
        objlead.Description__C = 'HSR showroom 1.1Km';
         Update  objlead;
         test.startTest();
         Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());

        Lead_Assignment_Helper.checkWTAStatus(objlead,mapWTAAssignment,'TEST_AUTOLEAD');
        test.stopTest();
        }
        catch(Exception e){
        }
    }
    public static testMethod void checkWTAStatus4(){
        try{

        WTA_Flow__c objFlow = new WTA_Flow__c();
        objFlow.Name = 'Flow2';
        objFlow.isActive__C  = true;
        insert ObjFlow;
        
        Integration_Setting__c intSet= new Integration_Setting__c();
        intSet.Name = 'OzoneTel Active Agent';
        intSet.End_Point__c = 'http://api1.cloudagent.in:4567/CAServices/v2/Test4?';
        intSet.Authorization__c = 'abcd';
        insert intSet;

        map<String,WTA_Assignment__c> mapWTAAssignment = new map<String,WTA_Assignment__c>();

        User objUser = TestData_Factory.inserWTAUser('Test@mailnator.com','TM',False);
        Insert objUser;

        User objUser1 = TestData_Factory.inserWTAUser('Test1@mailnator.com','TM',False);
        Insert objUser1;

        WTA_Assignment__c WTAAssignment = TestData_Factory.inserWTAAssignment(objUser,'Group A', false);
        insert WTAAssignment;
        mapWTAAssignment.put(objUser.Email,WTAAssignment);

        WTA_Assignment__c WTAAssignment1 = TestData_Factory.inserWTAAssignment(objUser1,'Group A', false);
        insert WTAAssignment1;
        mapWTAAssignment.put(objUser.Email,WTAAssignment1);
        system.debug('-----mapWTAAssignment---'+mapWTAAssignment);
       
        lead objLead = new Lead();
        objlead = TestData_Factory.CreateFreshLead(true);
        //Insert objlead;
        objlead.Description__C = 'HSR showroom 1.1Km';
         Update  objlead;
         test.startTest();
         Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());

        Lead_Assignment_Helper.checkWTAStatus(objlead,mapWTAAssignment,'TEST_AUTOLEAD');
        test.stopTest();
        }
                catch(Exception e){
        }
    }    
}