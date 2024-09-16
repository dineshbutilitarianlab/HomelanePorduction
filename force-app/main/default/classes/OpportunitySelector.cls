public class OpportunitySelector {

    public Map<Id,Opportunity> querryOppFromAccIdSet(Set<id> accIdSet){
        String query=UtilityClass.getQueryString('Opportunity');
        query+=' from Opportunity where AccountId=:accIdSet';
        return new Map<Id, Opportunity>((List<Opportunity>)Database.query(query));
    }
    Public Static Opportunity getOpportunityByOpportunityOrderID(String opportunityOrderID){
        List<Opportunity> listOfOpportunitiesQureied = new List<Opportunity>();
        Opportunity returnOpportunityRecord;
        String queryString = UtilityClass.getQueryString('Opportunity');
        queryString += ' From Opportunity where Customer_Id__C =:opportunityOrderID';
        listOfOpportunitiesQureied = Database.query(queryString);
        if(!listOfOpportunitiesQureied.isEmpty()){
            returnOpportunityRecord = listOfOpportunitiesQureied[0];
        }
        return returnOpportunityRecord;
    }
}