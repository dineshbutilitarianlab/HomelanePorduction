Public Class ProjectTriggerHandler{

   
    /*****************************
Description   : This method is to to update Approved Project Field in User so that DP and Buddy approval is Required only for First 3 Project*****
*/
    Public static void updateApprovedProjectOnUser(List<Project_Name__c> newlist){
    
        Set<id> userid =new Set<id>();
        Set<id> oppidid =new Set<id>();
        List<opportunity> lstopp=new List<opportunity >();
        List<user> lstuser=new List<user>();
        
        for(Project_Name__c proj:newlist){
            oppidid.add(proj.Opportunity_Project__c);
        }
        
        lstopp=[SELECT id,Name,Design_Partner__r.Approved_Project__c FROM Opportunity WHERE ID IN :oppidid];
        for(Opportunity oppid:lstopp){
            userid.add(oppid.Design_Partner__c);
        }
        
        lstuser=[Select id,Approved_Project__c from user where id IN:userid];
        for(User Updateuse:lstuser){
            if(Updateuse.Approved_Project__c == null)
                Updateuse.Approved_Project__c = 1;
            else
                Updateuse.Approved_Project__c = Updateuse.Approved_Project__c+1;
            update Updateuse;
        }
     } 
     
     Public static void updateprojectid(List<Project_Name__c> prolist){
         
         list<Opportunity> opplist = new list<Opportunity>();
         if(!prolist.isEmpty()){
             system.debug('prolist--------prolist[0].Id--------->>>>>>>>>>>>>'+prolist[0].Opportunity_Project__c);
             opplist = [Select id,Project_ID__c from Opportunity where id =: prolist[0].Opportunity_Project__c];
             for(opportunity opp :opplist ){
                 opp.Project_ID__c = prolist[0].Id;
             }
             update opplist;
         }
         
         
     }
}