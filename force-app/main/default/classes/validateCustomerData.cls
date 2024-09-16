/*
 * $Author: Venkat Arisa
 * $Date: 26/05/2016 
 */

@RestResource(urlMapping='/validateCustomerData/*')
global class validateCustomerData {

 Private List<Contact> customerDetailsList;
  
  @HttpGet
  global static void getAccountdetails(){
    Response response =new Response();
    RestRequest req = RestContext.request; 
    String OpportunityOrderID = req.params.get('OpportunityOrderID'); 
    
   //  system.debug('*** JSON input is ?'+(String)JSON_Input.get('email'));
   
   /* List<OpportunityContactRole> contactlist = [SELECT Id, OpportunityId,Opportunity.Name, Contact.Email, Contact.Phone,Contact.FirstName,Contact.LastName,
                                                Contact.MailingCity,Contact.MailingCountry,Contact.MailingState,Contact.MailingStreet,
                                                Opportunity.Account.name,Opportunity.Quote_Status__c,Opportunity.Account.Customer_ID__c,
                                                Opportunity.AccountId FROM OpportunityContactRole where 
                                                Contact.Email =: req.params.get('email')]; */
                                                
    List<Opportunity> customerDetailsList = [select id,Customer_ID__c,name,Artifact_ID__c,Quote_Status__c, Account.LastName,Account.FirstName,Account.PersonEmail,Account.Phone,
                                             Account.BillingCity,Account.BillingCountry,Account.BillingState,Account.BillingStreet,Account.Customer_ID__c 
                                             from Opportunity where Customer_ID__c =:OpportunityOrderID order by createddate desc ];                                     
    system.debug('*** customerDetailsList is?'+customerDetailsList);

    if(!customerDetailsList.isEmpty()){
       
        //response.success = true;
        response.status = 200;
        response.message = 'Success';
        
        
        List<customerdetails> customerdetailList = new List<customerdetails>();
        for(Opportunity customerrecord : customerDetailsList){
              customerdetails cd = new customerdetails();
                cd.CustomerId = customerrecord.Customer_ID__c;
                cd.firstname = customerrecord.Account.FirstName;
                cd.lastname = customerrecord.Account.LastName;
                cd.email = customerrecord.Account.PersonEmail;
                cd.phone = customerrecord.Account.Phone;
                cd.city = customerrecord.Account.BillingCity;
                cd.state = customerrecord.Account.BillingState;
                cd.street = customerrecord.Account.BillingStreet;
                cd.country = customerrecord.Account.BillingCountry;
                cd.quotestatus = customerrecord.Quote_Status__c;
                cd.Artifactid = customerrecord.Artifact_ID__c;
                
            
            customerdetailList.add(cd);
        }
        
        Response.response = customerdetailList;
        
    }else {
        response.status = 200;
        response.message = 'Success';
        Response.response = null;
     }
    
        string json_data = json.serialize(response);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(json_data);   
    
  }
    
    Private Class Response{
        String message;
        Integer status ;
        customerdetails[] response;
    }
    Private Class customerdetails
    {
      String CustomerId;
      String firstname,lastname,email;
      String phone,quotestatus;
      String city,state,country,street;
      String Artifactid;
    }


}