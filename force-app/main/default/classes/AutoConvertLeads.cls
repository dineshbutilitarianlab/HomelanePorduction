Public class AutoConvertLeads {     
@InvocableMethod
     public static void LeadAssign(List<Id> LeadIds)     {
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
        List<Lead> listOfLeads = [Select Id,Account__c from Lead where Id in:LeadIds];
        for(Lead currentlead: listOfLeads){
            Database.LeadConvert Leadconvert = new Database.LeadConvert();
            Leadconvert.setLeadId(currentlead.Id);
            Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel); 
            //Leadconvert.setDoNotCreateOpportunity(TRUE); 
            Leadconvert.setAccountId(currentlead.Account__c);
            MassLeadconvert.add(Leadconvert);
        }                 
        if (!MassLeadconvert.isEmpty()) {
        List<Database.LeadConvertResult> lcr = Database.convertLead(MassLeadconvert); 
        system.debug('->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        
        }   
        
}
 
     /*public PageReference redirecttoaccount() {
        PageReference send = new PageReference('http://www.google.com');
        send.setRedirect(true);
        return send;
    }*/
                                          
}