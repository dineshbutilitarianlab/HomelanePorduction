/*
 * Description : To get all Opportunity Stage from Schema.
 * Created by  : Naveen Kumar B H
*/ 
public class SC_MISalesPath {
    @AuraEnabled
    public Static List<String> getOpportunityStages(){
        List<String> listStage = new List<String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.sub_status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pl : ple){
          //  if(
           if( pl.getLabel() == 'Site Measurement Meeting Confirmed' || pl.getLabel() == 'Design Presentation Confirmed' 
           || pl.getLabel() == 'Project Kick-off Meeting Confirmed'  || pl.getLabel() == 'D1 Initiated' || pl.getLabel() == 'D2 Initiated' 
           || pl.getLabel() == 'D3 Initiated'|| pl.getLabel() == 'D4 Initiated')
                listStage.add(pl.getLabel());
        }
        System.debug('list of stages ----> '+listStage);
        return listStage;
    }    
    @AuraEnabled
    public Static Boolean refresh(){
        return false;
    }
}