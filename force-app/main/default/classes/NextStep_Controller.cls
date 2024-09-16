public class NextStep_Controller {
    private lead a;
    private ApexPages.StandardController controller {get; set;}
    public list<Lead__c> nextsteprec {get;set;}
    public list<lead> leadstatus {get;set;}
    public NextStep_Controller(ApexPages.StandardController controller){
        this.controller = controller;
        this.a = (Lead)controller.getRecord();
        system.debug('lead id = '+a.Id);
        nextsteprec = new list<Lead__c>();
        leadstatus = new list<lead>([Select Status from lead where id =: a.Id ]);
        system.debug('leadstatus = '+leadstatus);
        nextsteprec = [Select Next_Step__c from Lead__c where name =:leadstatus[0].Status];
        system.debug('Next Step = '+nextsteprec);
    }

}