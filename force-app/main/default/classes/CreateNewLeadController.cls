public class CreateNewLeadController {
    public CreateNewLeadController(ApexPages.StandardController controller) {
        
    }
    public PageReference redirectToWebsiteLeadCretionForm() {

          //string  websiteLeadCretionFormURL = 'http://www.google.ca/';
          string  websiteLeadCretionFormURL = Label.websiteLeadCretionFormURL;
		  websiteLeadCretionFormURL += UserInfo.getUserEmail();
          PageReference page = new PageReference(websiteLeadCretionFormURL);
          page.setRedirect(true);
          return page;
    }
}