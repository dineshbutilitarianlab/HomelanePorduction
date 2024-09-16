@isTest
public class Recommended_Meeting_Type_Test{
    public static testMethod void Success() {
    
        Recommended_Meeting_Type__c hsrShowroom = new Recommended_Meeting_Type__c();
        hsrShowroom.Max_Distance__c = 10;
        hsrShowroom.Meeting_Type__c = 'RV';
        hsrShowroom.Min_Distance__c =  0;
        hsrShowroom.ShowRoom_Name__c = 'HSR Showroom';
        hsrShowroom.Name = 'HSR Showroom 0 - 10';
        insert hsrShowroom;
        
    
        Lead l = TestData_Factory.CreateFreshLead(False);
        insert l;
        
        map<id,Lead> newMap = new map<id,Lead>();
        map<id,Lead> OldMap= new map<id,Lead>();
        OldMap.put(l.id,l);
        
        
        lead l2 = new Lead();
        l2.id = l.id;
        l2.Closest_Showroom__c = 'HSR Showroom 8.8km';
        newMap.put(l2.id,l2);
        
        
        
        test.starttest();
        Recommended_Meeting_Type.updateMeetingType(newMap,OldMap);
            //l.Closest_Showroom__c = 'HSR Showroom 8.8km';
            //update l;
           //lead la = [select id,Name,Recommended_Meeting_Type__c from lead where id =:l.id];
           //system.assertequals('RV',la.Recommended_Meeting_Type__c);
        test.stoptest();
    }
 }