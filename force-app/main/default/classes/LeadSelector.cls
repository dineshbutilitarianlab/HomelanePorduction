public class LeadSelector {
    Public Static Lead getLeadById(String leadId){
        List<Lead> listOfLeadsQureied = new List<Lead>();
        Lead returnLeadRecord;
        String queryString = UtilityClass.getQueryString('Lead');
        queryString += ' From Lead where id=:leadId';
        returnLeadRecord = Database.query(queryString);
        if(!listOfLeadsQureied.isEmpty()){
            returnLeadRecord = listOfLeadsQureied[0];
        }
        return returnLeadRecord;
    }
    public Map<Id,Lead> querryleadFromAccIdSet(Set<id> accIdSet){
        String query=UtilityClass.getQueryString('Lead');
        query+=' from lead where Account__c=:accIdSet';
        return new Map<Id, lead>((List<lead>)Database.query(query));
    }
    public Map<Id,Lead> querryleadFromAccIdSet(List<Id> listOfLeadIds){
        String query=UtilityClass.getQueryString('Lead');
        query+=' from lead where Id=:listOfLeadIds';
        return new Map<Id, lead>((List<lead>)Database.query(query));
    }
}