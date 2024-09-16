Trigger EventTrigger on Event(before insert,after insert) {

    if(Trigger.isafter && Trigger.isinsert){
        //This is written to update ooportunity substatus on event creation
       EventTriggerHandler.updateOpptysubstatusOnEventCreation(Trigger.new);
    }
 }