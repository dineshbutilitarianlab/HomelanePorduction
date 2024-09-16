public class WarrantyThankYouController {
    Public String Id{get;set;}
    
    public WarrantyThankYouController(){
        Id = ApexPages.currentPage().getParameters().get('id');
    }
    public PageReference Recordpage(){
        PageReference pageRef = new PageReference('/'+Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
}