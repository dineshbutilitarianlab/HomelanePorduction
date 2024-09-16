@isTest
public class NextStep_Controller_Test{
    static testMethod void NextStpTest(){
        
        Test.startTest();
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        lead leadRec1=new lead();
        leadRec1.firstName='Vani';
        leadRec1.lastName='Sowmya';
        leadRec1.Email='parinitha@gmail.com';
        leadRec1.Phone='7845111200';
        leadRec1.status='Fresh Lead';
        leadRec1.City = 'Pune';
        leadRec1.LeadSource = 'Website';
        insert leadRec1;
        
        ApexPages.StandardController sc = new ApexPages.standardController(leadRec1);
        NextStep_Controller nxtStp = new NextStep_Controller(sc);
        
        Test.stopTEst();
    }
}