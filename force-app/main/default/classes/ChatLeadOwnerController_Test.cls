@isTest
public class ChatLeadOwnerController_Test {
    static testMethod void ChatLeadOwnerControllertest(){
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        User wta_user=leadUtil_Test.inserUser('tetagent1@gmail.com','TesAT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        lead leadRec2=TestData_Factory.CreateFreshLead(false);
        leadRec2.PostalCode='511284';
        leadRec2.City='Bengaluru';
        try{
                insert leadRec2;
            }
            catch(DmlException e){
               System.assert(e.getMessage().contains('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Lead with same Email and Phone exists: Please update the existing Lead instead of Creating new record , '),e.getMessage());
             
             }
          
        Test.StartTest();
        
         ChatLeadOwnerController.strBody = leadRec2.Id;
         ChatLeadOwnerController.strBodyTest = 'tetagent1@gmail.com';
         ChatLeadOwnerController.getLeadrec();
         Test.StopTest();       
    }
    static testMethod void ChatLeadOwnerControllertest2(){
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        User wta_user=leadUtil_Test.inserUser('tetagent1@gmail.com','TesAT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        lead leadRec2=TestData_Factory.CreateFreshLead(false);
        leadRec2.PostalCode='511284';
        leadRec2.City='Bengaluru';
        try{
                insert leadRec2;
            }
            catch(DmlException e){
               System.assert(e.getMessage().contains('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Lead with same Email and Phone exists: Please update the existing Lead instead of Creating new record , '),e.getMessage());
             
             }
        Test.StartTest();
         ChatLeadOwnerController.strBody = leadRec2.Id;
         ChatLeadOwnerController.strBodyTest = 'tetaget1@gmail.com';
         ChatLeadOwnerController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void ChatLeadOwnerControllerTest3(){
        
        Test.StartTest();
         ChatLeadOwnerController.strBody ='';
         ChatLeadOwnerController.strBodyTest = 'tetaget1@gmail.com';
         ChatLeadOwnerController.getLeadrec();
         Test.StopTest();
        
    }
    
    }