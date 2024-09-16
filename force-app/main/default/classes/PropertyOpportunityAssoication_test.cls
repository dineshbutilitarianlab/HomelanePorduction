@isTest
public class PropertyOpportunityAssoication_test{
    public static testMethod void insertTest() {
        test.startTest();
        Map<String,String> mapRecordType = new Map<String,String>();
        list<Opportunity> opplist = new  list<Opportunity>();
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
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
        opp1.X_Hrs_Email_Sent__c = false;
        opp1.Meeting_Stage__c = 'Discussion Meeting Fixed';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '1';
        opp1.Property_Name__c = m.id;
        insert opp1;
        opplist.add(opp1);
        
        PropertyOpportunityAssoication.opportunityInsert(opplist);
        test.StopTest();
    }
    
    
    public static testMethod void updateTest() {
        test.startTest();
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

        Opportunity opp1 = new Opportunity();
        opp1.Name = 'first';
        opp1.Full_Name__c = 'first';        
        opp1.Customer_Email__c = 'opptest2test@testdwg.com';
        opp1.StageName='Quote Required';
        opp1.Opportunity_Stage__c = 'Won';
        opp1.CloseDate = Date.Today();
        opp1.Amount = 1000;
        opp1.CityfromLead__c = 'Noida';
        opp1.Second_Meeting_Time__c = System.now().addHours(-3);   
        opp1.X_Hrs_Email_Sent__c = false;
        opp1.Meeting_Stage__c = 'Discussion Meeting Fixed';
        opp1.Meeting_Response__c = 0;
        opp1.No_of_Meetings_Done__c = '1';
        opp1.Property_Name__c = m.id;
        insert opp1;
        
        
        opp1.Property_Name__c = m1.id;
        Update opp1;
        
        test.StopTest();
    }
}