trigger emailMessageTrigger on EmailMessage (after insert) {

  if(Trigger.isafter && Trigger.isinsert){
        //This is written to update ooportunity substatus on message sent -Initial Quote
       EmailMessageTriggerHandler.updateOpptysubstatusOnEmailCreation(Trigger.new);
    }

}