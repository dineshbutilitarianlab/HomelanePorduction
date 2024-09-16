@IsTest(SeeAllData=true)
private class DesignPartnerSelectionCntlr_Test{
    @isTest static void DesignPartnerSelectionCntlrTest() {
        Interior_Designer__c objIDP = new Interior_Designer__c();
        objIDP.Name = 'testData';
        objIDP.Email__c = 'Test1DesighP@hfltest.com';
        objIDP.Available_at_Showroom__c  = 'Test Showroom 2; Kodambakkam Showroom; Gachibowli Showroom; Kandivali Showroom; HSR Showroom; Test Showroom';
        objIDP.Total_Wins__c = 5;
        objIDP.Workload_10_40__c = 22;
        objIDP.Avg_Opportunites_Month__c = 20.02;
        objIDP.Total_Opportunities__c = 50;
        objIDP.New_joinee__c = true;
        objIDP.Property_Exp_Data__c = 'a090I00000odaKL,<@>Test ,Property 3<@>2';
        insert objIDP;
        lead leadRec1=leadUtil_Test.insertLead('tesqWL@hamelane.com','8919449949');
         leadRec1.PostalCode='561284';
         leadRec1.status='Fresh Lead';
         leadRec1.City='Bengaluru';
        leadRec1.LeadSource = 'Website';
         insert leadRec1; 
        ApexPages.currentPage().getParameters().put('id','a092800000TGD0w');
        ApexPages.currentPage().getParameters().put('recordId',leadRec1.Id);
        ApexPages.currentPage().getParameters().put('objectName','Lead');
        ApexPages.currentPage().getParameters().put('name','Test Lead');
        ApexPages.currentPage().getParameters().put('property','a090I00000odaKL');
        Test.StartTest();
        DesignPartnerSelectionCntlr obj = new DesignPartnerSelectionCntlr();
        obj.getDesginPartnerData();
        obj.strSearchDP = 'A';
        //obj.GetSearchData();
        obj.strRecordId =leadRec1.Id;
        obj.strDPId = objIDP.Id;
        obj.updateDesignPartner();
        Test.StopTest();
       
            
         
   }

}