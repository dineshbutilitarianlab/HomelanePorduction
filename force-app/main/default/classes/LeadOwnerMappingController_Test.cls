@isTest
public class LeadOwnerMappingController_Test {
    static testMethod void LeadOwnerMappingControllertest(){
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        User wta_user=leadUtil_Test.inserUser('tetagent1@gmail.com','TesAT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        lead leadRec2=leadUtil_Test.insertLead('prin1irha@gyail.com','7235111200');
        leadRec2.PostalCode='511284';
        leadRec2.City='Bengaluru';
        leadRec2.LeadSource = 'Website';
        try{
                insert leadRec2;
            }
            catch(DmlException e){
               //System.assert(e.getMessage().contains('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Lead with same Email and Phone exists: Please update the existing Lead instead of Creating new record , '),e.getMessage());
             
             }
          
        Test.StartTest();
        
         LeadOwnerMappingController.strBody = leadRec2.Id;
         LeadOwnerMappingController.strBodyTest = 'tetagent1@gmail.com';
         LeadOwnerMappingController.getLeadrec();
         Test.StopTest();       
    }
    static testMethod void LeadOwnerMappingControllertest2(){
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        User wta_user=leadUtil_Test.inserUser('tetagent1@gmail.com','TesAT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        lead leadRec2=leadUtil_Test.insertLead('prin1irha@gyail.com','7235111200');
        leadRec2.PostalCode='511284';
        leadRec2.City='Bengaluru';
        leadRec2.LeadSource = 'Website';
        try{
                insert leadRec2;
            }
            catch(DmlException e){
              // System.assert(e.getMessage().contains('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Lead with same Email and Phone exists: Please update the existing Lead instead of Creating new record , '),e.getMessage());
             
             }
        Test.StartTest();
         LeadOwnerMappingController.strBody = leadRec2.Id;
         LeadOwnerMappingController.strBodyTest = 'tetaget1@gmail.com';
         LeadOwnerMappingController.getLeadrec();
         Test.StopTest();
        
    }
    static testMethod void LeadOwnerMappingControllerTest3(){
        
        Test.StartTest();
         LeadOwnerMappingController.strBody ='';
         LeadOwnerMappingController.strBodyTest = 'tetaget1@gmail.com';
         LeadOwnerMappingController.getLeadrec();
         Test.StopTest();
        
    }
    
    }