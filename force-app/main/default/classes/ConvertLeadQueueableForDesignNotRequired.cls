public class ConvertLeadQueueableForDesignNotRequired implements queueable{
    
    public List<Lead> listOfLeadsToUpdate = new List<Lead>();
    public ConvertLeadQueueableForDesignNotRequired(List<Lead> listOfLeads){
        
        listOfLeadsToUpdate = listOfLeads;
    }
    
    public void execute(System.QueueableContext qc) {
        try{
        Map<Id,Id> mapOfParentLeadIds = new Map<Id,Id>();
        for(Lead l : listOfLeadsToUpdate){
            if(l.Main_Order__c != null)
                mapOfParentLeadIds.put(l.Id, l.Main_Order__c);
        }
        System.debug('mapOfParentLeadIds'+mapOfParentLeadIds);
        LeadSelector ls= new LeadSelector();
        System.debug('Lead'+listOfLeadsToUpdate);
        Map<Id,Lead> mapOfParentLeadDetails = ls.querryleadFromAccIdSet(mapOfParentLeadIds.values());
        for(Lead ld : listOfLeadsToUpdate){
            
            if(mapOfParentLeadDetails.containsKey(mapOfParentLeadIds.get(ld.Id))){
                Id parentLeadId = mapOfParentLeadIds.get(ld.Id);
                ld.status = 'Appointment Successful';
                ld.Sub_Status__c = 'Appointment Successful';
                //Commented out because these are copied already in the Sub Order create API
                /*
                ld.Phone = mapOfParentLeadDetails.get(parentLeadId).phone;
                ld.City = mapOfParentLeadDetails.get(parentLeadId).city;ld.Property_Status__c = mapOfParentLeadDetails.get(parentLeadId).Property_Status__c;
                ld.Property_Type__c = mapOfParentLeadDetails.get(parentLeadId).Property_Type__c;
                ld.Property_Config__c = mapOfParentLeadDetails.get(parentLeadId).Property_Config__c;
                ld.Interior_Start_Date__c = mapOfParentLeadDetails.get(parentLeadId).Interior_Start_Date__c;
                ld.Possession_Date__c = mapOfParentLeadDetails.get(parentLeadId).Possession_Date__c;
                ld.Kitchen__c = mapOfParentLeadDetails.get(parentLeadId).Kitchen__c;
                ld.Crockery_Unit__c = mapOfParentLeadDetails.get(parentLeadId).Crockery_Unit__c;
                ld.Entertainment_Unit__c = mapOfParentLeadDetails.get(parentLeadId).Entertainment_Unit__c;
                ld.Pooja__c = mapOfParentLeadDetails.get(parentLeadId).Pooja__c;
                ld.Study_Table_Book_Shelf__c = mapOfParentLeadDetails.get(parentLeadId).Study_Table_Book_Shelf__c;
                ld.Foyer_Shoe_Rack__c = mapOfParentLeadDetails.get(parentLeadId).Foyer_Shoe_Rack__c;
				ld.Appointment_Venue_Square__c = mapOfParentLeadDetails.get(parentLeadId).Appointment_Venue_Square__c;\
				ld.Appointment_Type__c = mapOfParentLeadDetails.get(parentLeadId).Appointment_Type__c;
*/
                ld.Appointment_Time__c = mapOfParentLeadDetails.get(parentLeadId).Appointment_Time__c;
                ld.Time_of_Actual_Appointment_Start__c = mapOfParentLeadDetails.get(parentLeadId).Time_of_Actual_Appointment_Start__c;
              
            }
        }
        if(!listOfLeadsToUpdate.isEmpty()){
            update listOfLeadsToUpdate;
        }
    
    }catch(Exception e){
        System.debug('Exception ');
        Logger.log('Exception','ConvertLeadQueueableForDesignNotRequired','Convert Lead Queueable' + listOfLeadsToUpdate[0].Id+'',e.getMessage(),e.getStackTraceString(),null);
    }
    }
}