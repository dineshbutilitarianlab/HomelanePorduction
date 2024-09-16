public class NextStep_OpportunityController {
    private Opportunity opp;
    private ApexPages.StandardController controller {get; set;}
    public list<Opportunity_NextStep__c> nextsteprec {get;set;}
    public list<Opportunity> oppstatus {get;set;}
    public NextStep_OpportunityController(ApexPages.StandardController controller){
        this.controller = controller;
        this.opp = (Opportunity)controller.getRecord();
        system.debug('Opportunity id = '+opp.Id);
        nextsteprec = new list<Opportunity_NextStep__c>();
        oppstatus = new list<Opportunity>([Select StageName,Sub_Status__c from Opportunity where id =: opp.Id ]);
        system.debug('oppstatus = '+oppstatus );
        nextsteprec = [Select Next_Step__c from Opportunity_NextStep__c where Stage_Name__c=:Oppstatus[0].StageName OR Stage_Name__c=:Oppstatus[0].Sub_Status__c];
        system.debug('Next Step = '+nextsteprec);
    }

}