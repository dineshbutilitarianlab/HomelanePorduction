@isTest
Public class Rest_Update_SCVM_To_Roster_Test{
    public static testMethod void Success(){
        
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test()); 
        Integration_Setting__c intSet= new Integration_Setting__c();
        intSet.Name = 'OzoneTel Active Agent';
        intSet.End_Point__c = 'https://sandbox-roster.homelane.com/apis/general/scvm_rain_flow/Test';
        insert intSet;
        
        lead objLead = new Lead();
        objlead = TestData_Factory.CreateFreshLead(False);
        Insert objlead;
        
        Test.StartTest();
            Rest_Update_SCVM_To_Roster.updateMeeting(objlead.id);
        Test.StopTest();
    }
}