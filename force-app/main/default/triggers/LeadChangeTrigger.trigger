trigger LeadChangeTrigger on LeadChangeEvent (after insert) {
    if(Trigger.isAfter){
        system.debug('Trigger Called');
        ChangeTrigger_Handler.leadchangeEvent(Trigger.New);
    }
}