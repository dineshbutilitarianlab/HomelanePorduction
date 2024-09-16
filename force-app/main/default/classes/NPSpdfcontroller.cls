public class NPSpdfcontroller {
    Public String Id {get;set;}Public String CustomerName {get;set;}Public String CustomerComments {get;set;}Public String Addofinstall {get;set;}Public String ScopeOfwork {get;set;}Public Date Dateofcompletion {get;set;}
    
    public NPSpdfcontroller(){
    Id = ApexPages.currentPage().getParameters().get('id');
    System.debug('Id ------------------------------------------->'+Id);
    
    Opportunity opportunityrec = new Opportunity();
    if(!Test.isRunningTest()){
        opportunityrec = [select id, name,Date_Of_Completion__c,Address_Of_Instalation__c,Scope_Of_Work__c,Warranty_Document_Comments__c from Opportunity where id =:Id ];CustomerName = opportunityrec.name;CustomerComments = opportunityrec.Warranty_Document_Comments__c ;Addofinstall = opportunityrec.Address_Of_Instalation__c;ScopeOfwork = opportunityrec.Scope_Of_Work__c;Dateofcompletion = opportunityrec.Date_Of_Completion__c;
    }
 
   
    
    }
}