trigger CaluclateLeadCountOnLeadAssignment on Lead_Assignment__c (after insert,after update,before update,after delete) 
{

  // Trigger to do rollup summary at Round_Robin__c object  Total_Leads__c filed
    
    set<id> parentId=new set<id>();
    
    if(Trigger.isInsert||(Trigger.isUpdate && Trigger.isafter))
    {
        for(Lead_Assignment__c LeadAssign:Trigger.new)
        {
            parentId.add(LeadAssign.Round_Robin__c);
        }
    }
    
    
    if(Trigger.isDelete)
    {
        for(Lead_Assignment__c LeadAssign:Trigger.old)
        {
            parentId.add(LeadAssign.Round_Robin__c);
        }
        
    }
    
    
    List<Round_Robin__c> acc=new List<Round_Robin__c>();
    for(AggregateResult sr:[select Round_Robin__c t,sum(Number_of_Leads__c) e,sum(Assign_Percent__c) f from Lead_Assignment__c where Round_Robin__c=:parentId group by Round_Robin__c])
    {
        Round_Robin__c a=new Round_Robin__c();
        a.id=(id)sr.get('t');
        a.Total_Leads__c=(decimal)sr.get('e');
        acc.add(a);
    }
    if(acc.size()>0)
    {   
        try
        {
            update acc;
        }
        catch(DmlException e)
        {
            System.debug('Error Caught '+e);
        }
    }
    
  
    
}