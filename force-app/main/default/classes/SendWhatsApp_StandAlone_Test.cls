@isTest
Public Class SendWhatsApp_StandAlone_Test{
    public static testMethod void testSuccess(){
        //Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        Integration_Setting__c intSetting = new Integration_Setting__c();
        intSetting.Name = 'Verloop API';
        intSetting.End_Point__c = 'https://homelane.verloop.io/api/v1/Campaign/SendMessage/Test';
        intSetting.ContentType__c = 'application/json';
        insert intSetting;
        
        list<Lead> lstLead = new list<Lead>();
        Lead l = new Lead();
        l.FirstName = 'Hamsa';
        l.LastName = 'Raj';
        l.Email = 'HamsaRaj@gmail.com';
        l.Phone = '9000000009';
        l.City = 'Bengaluru';
        l.LeadSource = 'Google Ad';
        l.Status = 'Fresh Lead';
        l.Sub_Status__c = 'New';
        l.Whatsapp_Opt_in__c= true;
        insert l;
        
        lstLead.add(l);
        
        test.starttest();
        
        SendWhatsApp_StandAlone.sendMessage(lstLead);
        test.stoptest();
        
    }
}