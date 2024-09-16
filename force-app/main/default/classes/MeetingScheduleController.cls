Public Class MeetingScheduleController{
   public string strLeadId{get;set;}
   public Lead objLead{get;set;}

  public MeetingScheduleController(){
   strLeadId = ApexPages.currentPage().getParameters().get('LeadId');
       if(strLeadId != null && strLeadId !=''){
         for(Lead obj : [Select Id,Full_Name__c,Phone,Email,Property__r.Name,Possession_Date__c,customer_Id__c From Lead Where Id =:strLeadId ]){
            objLead =  obj;
         }
       }
  }





}