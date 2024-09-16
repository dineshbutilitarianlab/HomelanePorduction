trigger OpportunityChangeTrigger on OpportunityChangeEvent (after insert) {
    if(Trigger.isAfter){
        system.debug('Opportunity  Trigger Called');
        ChangeTrigger_Handler.OpportunitychangeEvent(Trigger.New);
    }
}