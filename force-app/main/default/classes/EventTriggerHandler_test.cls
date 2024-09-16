@isTest
public class EventTriggerHandler_test {
    static testMethod void updateEvent(){
        test.startTest();
         SC_MI_TestHandler.insertIsTriggerExecute();
        SC_MI_TestHandler.insertCustomDate();
        RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account businessAcc=new Account(Name='Anand',recordTypeId=recType1.Id);
        insert businessAcc;
        
        Contact con=new Contact(LastName='Suraj',AccountId=businessAcc.Id,Email='priya@gmail.com');
        insert con;
        
        Opportunity Opp=new Opportunity(Name='Gagan',AccountId=businessAcc.Id,stageName='Initial Quote Sent',
                                                closeDate=system.today(),SME1__c=con.Name);
        insert Opp;
        
      /*  try{
        opp.stageName='D1 Initiated';
        opp.Sub_Status__c='Site Measurement Proposed';
        update opp;
        }catch(DMLException e){
            
        }*/
        
        Event e=new Event();
        e.WhatId=opp.Id;
        e.DurationInMinutes=15;
        e.ActivityDateTime=system.today();
        e.EventType__c='D1: Site Measurement Proposed';
        insert e;
        
        Event e1=new Event();
        e1.WhatId=opp.Id;
        e1.DurationInMinutes=15;
        e1.ActivityDateTime=system.today();
        e1.EventType__c='D2: Design Presentation Proposed';
        insert e1;
        
        Event e2=new Event();
        e2.WhatId=opp.Id;
        e2.DurationInMinutes=15;
        e2.ActivityDateTime=system.today();
        e2.EventType__c='D3: Project Kick-off Proposed';
        insert e2;
        
        Event e3=new Event();
        e3.WhatId=opp.Id;
        e3.DurationInMinutes=15;
        e3.ActivityDateTime=system.today();
        e3.EventType__c='D4: Installation Meeting Proposed';
        insert e3;
        
        /*opp.Sub_Status__c='Project Kick-off Proposed';
        update opp;*/
        
        test.stopTest();
    }
}