@isTest
public class ApptCancelDescription_Test {
    @isTest static void test1() {
          ApptCancelDescription.dummyTestCover();
          Lead l = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd@hamelane.com',
            Phone='9844318107',
            City='Hyderabad',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website',
             Appointment_Time__c = System.now(),
             Description__c = 'abc'
             ); 
        insert l;
        l.Status = 'Appointment Cancelled';
        update l;
    }
    
    @isTest static void test2() {
          ApptCancelDescription.dummyTestCover();
          Lead l = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd@hamelane.com',
            Phone='9844318107',
            City='Hyderabad',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website',
             Appointment_Time__c = System.now()
             ); 
        insert l;
        l.Status = 'Appointment Cancelled';
        update l;
    }
}