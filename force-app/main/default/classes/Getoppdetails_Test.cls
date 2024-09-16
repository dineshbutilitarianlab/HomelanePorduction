@IsTest(SeeAllData=true)
global class Getoppdetails_Test{
    global static testMethod void getopprec() {
              RestRequest request = new RestRequest();
              request.addParameter('email','aksingh@gmail.com');// Che-TC-2000001610

              request.requestUri='/setup/build/getopprec/Che-TC-2000001610';
              request.httpMethod='GET';
              RestContext.request = request;
              
              Account acc= new Account();
              acc.LastName='Singh';
              acc.PersonEmail = 'aksingh@gmail.com';
              acc.Phone='9994716455';
              insert acc;
              
              SC_OpportunityCustDate__c sc = new SC_OpportunityCustDate__c();
              sc.Name = 'SomeDate';
              sc.SC_StartDate__c = System.today().addDays(-5);
              insert sc;
        
              Opportunity opp = new Opportunity();
              opp.Name='Opptest1rr';
              opp.AccountId=acc.Id;
              opp.StageName='Quote Required';
              opp.CloseDate =system.today();
              opp.Probability=.5;
              opp.Sub_Status__c = '40% Payment Received';
              opp.Artifact_ID__c=acc.id;
              opp.Amount=2020;
              opp.Quote_Status__c='Initial Quote Rejected';
              opp.CityfromLead__c='varanasi';
              opp.CreatedDate=system.today().addDays(-5);
              
             
             
                try{
                     insert opp; 
                    
                }catch(exception exp){} 
              Getoppdetails.FinalWrapper wrapper= new Getoppdetails.FinalWrapper();
              wrapper.Id=opp.id;
              wrapper.QuoteStatus=opp.Quote_Status__c;
              wrapper.ArtifactID =opp.Artifact_ID__c;
              wrapper.name = opp.Name;
              wrapper.SSAname=opp.Square_Showroom_Agent__r.name;
              wrapper.SSAemail=opp.Square_Showroom_Agent__r.email;
              wrapper.DPphone=opp.Design_Partner__r.phone;
              wrapper.SSAphone=opp.Square_Showroom_Agent__r.phone;
              wrapper.SSMname=opp.Square_Showroom_Manager__r.name;
              wrapper.SSMemail=opp.Square_Showroom_Manager__r.email;
              wrapper.DPname=opp.Design_Partner__r.name;
              wrapper.DPemail=opp.Design_Partner__r.email;
              wrapper.email=opp.Customer_Email__c;
              wrapper.amnt=opp.Amount;
            //  wrapper.customeraddress=opp.
              wrapper.city=opp.CityfromLead__c;
              wrapper.CID=opp.account.Customer_ID__c;
              wrapper.recordcreateddate=opp.CreatedDate;
              wrapper.phoneno=opp.Customer_Phone_Number__c;
              Getoppdetails.getopprec();

              } 



}