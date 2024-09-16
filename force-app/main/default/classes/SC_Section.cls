/*
    * Description : Used as an Extension to .SC_Section_VF_Page controller. 
                    To get all Opportunity Stage PickList values and passing to visual force page.
*/
public class SC_Section{

    public List<SelectOption> listStage{get;set;}
    
    public SC_Section(ApexPages.StandardController stdController) {   
        listStage = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Opportunity.Sub_Status__c.getDescribe();        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        listStage.add(new selectOption('','--None--'));
        
        for(Schema.PicklistEntry pl : ple){        
            listStage.add(new selectOption(String.valueOf(pl.getLabel()),String.valueOf(pl.getLabel())));
        }
    }
}