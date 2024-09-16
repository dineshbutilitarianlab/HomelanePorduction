@isTest
public class EmailReplyfromCustomerController_Test {
    static testMethod void testControllerMethods(){
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Person Account'];
        Account personAcc=new Account(LastName='Anand',recordTypeId=recType.Id,PersonEmail='Anand@gmail.com',phone='0801231541');
        insert personAcc;
        
        Opportunity opp=new Opportunity(Name='Vijay',AccountId=personAcc.Id,stageName='Initial Quote Sent',
                                        closeDate=system.today());
        insert opp;
       
        String oppId=opp.Id;
      
        EmailReplyfromCustomerController mailReply1=new EmailReplyfromCustomerController();
        string Id=apexpages.currentpage().getparameters().put('id' , oppId);
        mailReply1.updateoppStatus();
        
        mailReply1.Reply=apexpages.currentpage().getparameters().put('Reply' , 'yes');
        mailReply1.updateoppStatus();
       
        mailReply1.Reply=apexpages.currentpage().getparameters().put('Reply' , 'no');
        mailReply1.updateoppStatus();
        
        mailReply1.D3=apexpages.currentpage().getparameters().put('D3' , 'yes');
        mailReply1.updateoppStatus();
        
        mailReply1.D3=apexpages.currentpage().getparameters().put('D3' , 'no');
        mailReply1.updateoppStatus();
        
        mailReply1.D3_Initial=apexpages.currentpage().getparameters().put('D3_Initial' , 'yes');
        mailReply1.updateoppStatus();
        
        mailReply1.D3_Initial=apexpages.currentpage().getparameters().put('D3_Initial' , 'no');
        mailReply1.updateoppStatus();
    }
     static testMethod void testControllerMethod(){
        
        SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        
        RecordType recType=[SELECT Id FROM RecordType WHERE Name='Person Account'];
        Account personAcc=new Account(LastName='Anand',recordTypeId=recType.Id,PersonEmail='Anand@gmail.com',phone='0801231541');
        insert personAcc;
        
        Opportunity opp=new Opportunity(Name='Vijay',AccountId=personAcc.Id,stageName='Initial Quote Sent',
                                        closeDate=system.today());
        insert opp;
       
        String oppId=opp.Id;
      
        EmailReplyfromCustomerController mailReply1=new EmailReplyfromCustomerController();
        string Id=apexpages.currentpage().getparameters().put('id' , oppId);
        mailReply1.updateoppStatus();
        
        mailReply1.Reply=apexpages.currentpage().getparameters().put('Reply' , 'yes');
        mailReply1.updateoppStatus();
       
        mailReply1.Reply=apexpages.currentpage().getparameters().put('Reply' , 'no');
        mailReply1.updateoppStatus();
        
        mailReply1.D2=apexpages.currentpage().getparameters().put('D2' , 'yes');
        mailReply1.updateoppStatus();
        
        mailReply1.D2=apexpages.currentpage().getparameters().put('D2' , 'no');
        mailReply1.updateoppStatus();
        
        mailReply1.D3_Initial=apexpages.currentpage().getparameters().put('D3_Initial' , 'yes');
        mailReply1.updateoppStatus();
        
        mailReply1.D3_Initial=apexpages.currentpage().getparameters().put('D3_Initial' , 'no');
        mailReply1.updateoppStatus();
    }
}