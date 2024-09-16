@isTest
public class InboundIVR_Test {
    static testMethod void InboundIVRtest(){
        lead leadRec2=leadUtil_Test.insertLead('prin1itha@gmail.com','7835111200');
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
         InboundIVRController.strBody = '7835111200';
         InboundIVRController.getLeadrec();
         Test.StopTest();       
    }
    static testMethod void InboundIVRtest2(){
        Test.StartTest();
         InboundIVRController.strBody = '7835111200';
         InboundIVRController.getLeadrec();
         Test.StopTest();
        
    }
    
    }