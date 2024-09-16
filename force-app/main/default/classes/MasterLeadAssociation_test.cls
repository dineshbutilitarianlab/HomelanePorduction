@isTest
public class MasterLeadAssociation_test{
    public static testMethod void insertTest() {
      test.startTest();
      list<lead> lstlead = new list<lead>();
      Map<String,String> mapRecordType = new Map<String,String>();
      Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
      for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
        mapRecordType.put(reType.getDeveloperName(),reType.getRecordTypeId());
      }

      Master__c m = new Master__c();
      m.isActive__c = true;
      m.Type__c = 'Property';
      m.Name = 'Brigade Palmsprings';
      m.Full_Name__c = 'Brigade Palmsprings';
      m.Total_Won_Opportunity__c = 6;
      m.Avg_Opportunites_Month__c = 20;
      m.Location__latitude__s = 12.971100;
      m.Location__longitude__s = 77.640920;
      m.RecordTypeId = mapRecordType.get('Property');
      m.PlaceId__c = 'qwyriophdiepo';
      insert m;

      Lead l = new Lead();
      l.FirstName = 'Hamsa';
      l.LastName = 'Raj';
      l.Email = 'HamsaRaj@gmail.com';
      l.Phone = '9000000009';
      l.City = 'Bengaluru';
      l.LeadSource = 'Google Ad';
      l.Status = 'Fresh Lead';
      l.Sub_Status__c = 'New';
      l.property__c = m.id;
      insert l;
      lstlead.add(l);
      MasterLeadAssociation.leadIns(lstlead);

        test.StopTest();
    }
    
    
    public static testMethod void updateTest() {
        test.startTest();
        list<lead> lstlead = new list<lead>();
        Map<id,lead> mapOldMap = new Map<id,lead>();
        Map<String,String> mapRecordType = new Map<String,String>();
        Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
        for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
        mapRecordType.put(reType.getDeveloperName(),reType.getRecordTypeId());
        }
        
        Master__c m = new Master__c();
        m.isActive__c = true;
        m.Type__c = 'Property';
        m.Name = 'Brigade Palmsprings';
        m.Full_Name__c = 'Brigade Palmsprings';
        m.Total_Won_Opportunity__c = 6;
        m.Avg_Opportunites_Month__c = 20;
        m.Location__latitude__s = 12.971100;
        m.Location__longitude__s = 77.640920;
        m.RecordTypeId = mapRecordType.get('Property');
        m.PlaceId__c = 'qwyriophdiepo';
        insert m;
        
        Master__c m1 = new Master__c();
        m1.isActive__c = true;
        m1.Type__c = 'Property';
        m1.Name = 'Brigade Palmsprings';
        m1.Full_Name__c = 'Brigade Palmsprings';
        m1.Total_Won_Opportunity__c = 6;
        m1.Avg_Opportunites_Month__c = 20;
        m1.Location__latitude__s = 12.971100;
        m1.Location__longitude__s = 77.640920;
        m1.RecordTypeId = mapRecordType.get('Property');
        m1.PlaceId__c = 'qwyriophdiepo';
        insert m1;

        Lead l = new Lead();
        l.FirstName = 'Hamsa';
        l.LastName = 'Raj';
        l.Email = 'HamsaRaj@gmail.com';
        l.Phone = '9000000009';
        l.City = 'Bengaluru';
        l.LeadSource = 'Google Ad';
        l.Status = 'Fresh Lead';
        l.Sub_Status__c = 'New';
        l.property__c = m.id;
        insert l;
        
        mapOldMap.put(l.id,l);
         Lead l2 = new Lead();
         l2.id = l.id;
        l2.property__c = m1.id;
        Update l2;
        lstlead.add(l2);
        
        MasterLeadAssociation.leadUpd(lstlead,mapOldMap);
        
        test.StopTest();
    }
}