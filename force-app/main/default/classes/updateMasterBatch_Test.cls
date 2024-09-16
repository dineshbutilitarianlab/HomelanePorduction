@isTest
public class updateMasterBatch_Test{
    public static testMethod void insertTest() {
        Set<id> setmasterid = new Set<id>();
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
        setmasterid.add(m.id);
        
        test.startTest();
        updateMasterBatch obj = new updateMasterBatch(setmasterid);
        database.executeBatch(obj);
        test.stoptest();
      }
 }