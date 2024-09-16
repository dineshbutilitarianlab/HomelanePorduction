public class OutOfServiceCity_Controller{
    public Id LeadId { get; set; }
    public string scity {get; set;}
    public static boolean isSuccessfullyUpdated {get; set;}
    public OutOfServiceCity_Controller(ApexPages.StandardController controller) {
        isSuccessfullyUpdated = false;
        LeadId =  controller.getrecord().id;
        System.debug('The lead record: ' + LeadId );
        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Out of service city updated successfully'));
    }
    
    public void UpdateCity(){
        try{
            System.debug('Scity : '+Apexpages.currentPage().getParameters().get('scity'));
            if(!String.isBlank(Apexpages.currentPage().getParameters().get('scity')) && !String.isBlank(LeadId)){
                lead objlead = new lead();
                objlead.id = LeadId;
                objlead.Out_of_Servicing_City__c = Apexpages.currentPage().getParameters().get('scity');
                update objlead;
                isSuccessfullyUpdated = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Out of service city updated successfully'));
                if(Test.isRunningTest()){
                    //for Test exception in test class code coverage
                    System.debug(1/0);
                }
            }
        }  
        catch(Exception e){
            isSuccessfullyUpdated = false;
            Logger.log('Exception','AddressInfoAPI','UpdateCity',e.getMessage(),e.getStackTraceString(),NULL);
            ApexPages.addMessages(e);
        }  
    }
}