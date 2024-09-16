Public class EventTriggerHandler{

    Public Static void updateOpptysubstatusOnEventCreation(List<Event> neweventlist){
    
     Map<Id,String> opptyMap = new Map<Id,String>();
     List<Opportunity> opptyToBeUpdated = new List<Opportunity>();
     List<Opportunity> opptyRelatedToEvent = new List<Opportunity>();

     
      for(Event eventrecord: neweventlist){
        if( (null != eventrecord.WhatId)&& (String.valueOf(eventrecord.WhatId).startsWith('006')) &&
           ((eventrecord.EventType__c == 'D1: Site Measurement Proposed') ||
            (eventrecord.EventType__c == 'D2: Design Presentation Proposed') ||
            (eventrecord.EventType__c == 'D3: Project Kick-off Proposed') ||
            (eventrecord.EventType__c == 'D4: Installation Meeting Proposed'))){
               opptyMap.put(eventrecord.WhatId,eventrecord.EventType__c);
            }
      }
      system.debug('*** opptyMap '+opptyMap);
      opptyRelatedToEvent = [select id,name,Sub_Status__c from Opportunity where id in:opptyMap.KeySet()];
      
      for(Opportunity opptyrecord: opptyRelatedToEvent){
      
          if(opptyMap.get(opptyrecord.id) == 'D1: Site Measurement Proposed'){
              opptyrecord.Sub_Status__c = 'Site Measurement Proposed';
              opptyrecord.Event_Created_D1__c = TRUE;
            }else if(opptyMap.get(opptyrecord.id) == 'D2: Design Presentation Proposed'){
                opptyrecord.Sub_Status__c = 'Design Presentation Proposed';
             }else if(opptyMap.get(opptyrecord.id) == 'D3: Project Kick-off Proposed'){
                   opptyrecord.Sub_Status__c = 'Project Kick-off Proposed';
                }else if(opptyMap.get(opptyrecord.id) == 'D4: Installation Meeting Proposed'){
                   opptyrecord.Sub_Status__c = 'Installation Meeting Proposed';
                }
         opptyToBeUpdated.add(opptyrecord);     
      }
    
    system.debug(' *** opptyToBeUpdated '+opptyToBeUpdated);
    
      if(!opptyToBeUpdated.isEmpty()){
         try{
           update opptyToBeUpdated;
         }catch(DMLException DMLEx){
           system.debug(' Failed to Update Opportunity with the event sub status '+ DMLEx);
         }
      }
    
    
    }

}