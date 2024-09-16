@IsTest (SeeAllData = true)
private class WalkinLeadController_Test{
    @isTest static void leadTest() {
          Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Noida';
        insert objRA;
        Lead leadRec = new Lead(
           FirstName='Vani',
            LastName='Sowmya',
            Email='testWL@hamelane.com',
            Phone='6534567890',
            City='Noida',
            Area_Of_Residence__c = objRA.id,Floorplan_Received__c = 'No'
        );         
         leadRec.PostalCode='561284';
         leadRec.Status='Fresh Lead';
        // insert leadRec;
          system.debug('leadRec1 ------------->'+leadRec);
          Test.startTest();
          WalkinLeadController.saveLead(leadRec); 
          WalkinLeadController.checkExistingLead(leadRec); 
          WalkinLeadController.updateExistigLead(leadRec);
          WalkinLeadController.SendEmailToManager('Test Class mail');
          WalkinLeadController.ChangeErrorMessage('testt_EXCEPTION.this is error');
          
          Test.stopTest(); 
   }
 @isTest static void leadTes2t() {   
         Residential_Area__c objRA = new Residential_Area__c();
        objRA.Name = 'Test';
        objRA.City__c = 'Bangalore';
        insert objRA;
        Lead leadRec=new lead(
            firstName='Vani',
            lastName='Sowmya',
            email='testWL@hamelane.com',
            Phone='8989449949',
            city='Bangalore',
            Area_Of_Residence__c = objRA.id,Floorplan_Received__c = 'No'
        );         
         leadRec.PostalCode='561284';
         leadRec.status='Fresh Lead';
         leadRec.Lead_Assingment__c=true;
        // leadRec1.OwnerId = wta_user.Id;
        // insert leadRec1;
          system.debug('leadRec1 ------------->'+leadRec);
          Test.startTest();
          WalkinLeadController.saveLead(leadRec); 
          WalkinLeadController.checkExistingLead(leadRec); 
          WalkinLeadController.updateExistigLead(leadRec);
          WalkinLeadController.ChangeErrorMessage('this is error');
         
          Test.stopTest(); 
   }   
   
   @isTest static void leadTes3t() {  
        Master__c mas = new Master__c();
        mas.Name = 'Test Propertysgsfgsg';
        mas.Property_City__c = 'Bengaluru';
        mas.Type__c = 'Showroom';
        insert mas;
        System.debug('######mas  '+mas);       
                 
        lead newLead = new lead();
        newLead.Email = 'test1@test.com';
        newLead.lastName = 'Test1';
        newLead.Phone = '2314567890';
        newLead.LeadSource = 'Unqualified Walk-in';
        newLead.Status = 'Not actively pursued';
        newLead.sub_status__c = 'Possession beyond 6 months';
        newLead.Push_lead_to_Ameyo_Time__c = System.now();
        newLead.Follow_up_time__c = Date.today();
        newLead.Possession_Date__c = system.today().addMonths(4);
        newLead.City = mas.Property_City__c;   
        newLead.Property__c = mas.Id;
        newLead.Appointment_Venue_Square__c = mas.Id;
        newLead.Why_we_didn_t_offer_design_discussion__c = 'Possession > 4 months';            
      //  insert newLead;       
          Test.startTest();
          WalkinLeadController.checkExistingLeadUnqualified(newLead);
       //   WalkinLeadController.updateLeadUnqualified(newLead); 
          Test.stopTest(); 
     
   }   
   
    @isTest static void leadTest4() {        
       Master__c mas = new Master__c();
        mas.Name = 'Test Propertysfgsg';
        mas.Property_City__c = 'Bengaluru';
        mas.Type__c = 'Showroom';
        insert mas;
        System.debug('######mas  '+mas);  
         
         lead newLead1 = new Lead();
        newLead1.Email = 'test2@test.com';
        newLead1.lastName = 'Test2';
        newLead1.Phone = '5434567893';
        newLead1.LeadSource = 'Unqualified Walk-in';
        newLead1.Status = 'Not actively pursued';
        newLead1.sub_status__c = 'Possession beyond 6 months';
        newLead1.Push_lead_to_Ameyo_Time__c = System.now();
        newLead1.Follow_up_time__c = Date.today();
        newLead1.City = mas.Property_City__c;   
        newLead1.Property__c = mas.Id;
        newLead1.Appointment_Venue_Square__c = mas.Id;
        newLead1.Why_we_didn_t_offer_design_discussion__c = 'Move-in > 6 months';        
       // insert newLead1; 
        Test.startTest();
          WalkinLeadController.checkExistingLeadUnqualified(newLead1);
        //  WalkinLeadController.updateLeadUnqualified(newLead1); 
          Test.stopTest();
        
    }
    
    @isTest static void leadTest5() {   
     Master__c mas = new Master__c();
        mas.Name = 'Test Propertewysfgsg';
        mas.Property_City__c = 'Bengaluru';
        mas.Type__c = 'Showroom';
        insert mas;
        System.debug('######mas  '+mas);  
         lead newLead2 = new Lead();
        newLead2.Email = 'tes3t@test.com';
        newLead2.lastName = 'Test3';
        newLead2.Phone = '5554567894';
        newLead2.LeadSource = 'Unqualified Walk-in';
        newLead2.Status = 'Dead Lead';
        newLead2.sub_status__c = 'Qualification Constraints(Budget/Requirements)';
        newLead2.Push_lead_to_Ameyo_Time__c = System.now();
        newLead2.Follow_up_time__c = Date.today();
        newLead2.City = mas.Property_City__c;   
        newLead2.Property__c = mas.Id;
        newLead2.Appointment_Venue_Square__c = mas.Id;
        newLead2.Why_we_didn_t_offer_design_discussion__c = 'Requirements not in HL Scope';   
        Test.startTest(); 
          WalkinLeadController.checkExistingLeadUnqualified(newLead2);
        //  WalkinLeadController.updateLeadUnqualified(newLead2); 
          Test.stopTest();
    }
    
    @isTest static void leadTest6() {  
    Master__c mas = new Master__c();
        mas.Name = 'Test pertewysfgsg';
        mas.Property_City__c = 'Bengaluru';
        mas.Type__c = 'Showroom';
        insert mas;
        System.debug('######mas  '+mas); 
        lead newLead3 = new Lead();
        newLead3.Email = 'test4@test.com';
        newLead3.lastName = 'Test4';
        newLead3.Phone = '6754567896';
        newLead3.LeadSource = 'Unqualified Walk-in';
        newLead3.Status = 'Dead Lead';
        newLead3.sub_status__c = 'Non serviceable city';
        newLead3.Push_lead_to_Ameyo_Time__c = System.now();
        newLead3.Follow_up_time__c = Date.today();
        newLead3.Property__c = mas.Id;
        newLead3.Appointment_Venue_Square__c = mas.Id;
        newLead3.Why_we_didn_t_offer_design_discussion__c = 'Not within city limits'; 
         Test.startTest();
          WalkinLeadController.checkExistingLeadUnqualified(newLead3);
          //WalkinLeadController.updateLeadUnqualified(newLead3); 
          Test.stopTest(); 
    }
    
    @isTest static void leadTest7() {   
    Master__c mas = new Master__c();
        mas.Name = 'Test Propewysfgsg';
        mas.Property_City__c = 'Bengaluru';
        mas.Type__c = 'Showroom';
        insert mas;
        System.debug('######mas  '+mas);
        lead newLead4 = new Lead();
        newLead4.Email = 'test5@test.com';
        newLead4.lastName = 'Test5';
        newLead4.Phone = '5464567895';
        newLead4.LeadSource = 'Unqualified Walk-in';
        newLead4.Status = 'Fresh Lead';
        newLead4.sub_status__c = 'Visited Showroom';
        newLead4.Push_lead_to_Ameyo_Time__c = System.now().addHours(3);
        newLead4.Follow_up_time__c = Date.today();
        newLead4.Property__c = mas.Id;
        newLead4.Appointment_Venue_Square__c = mas.Id;
        newLead4.Why_we_didn_t_offer_design_discussion__c = 'Customer didn\'t have enough time'; 
         Test.startTest();
          WalkinLeadController.checkExistingLeadUnqualified(newLead4);
          //WalkinLeadController.updateLeadUnqualified(newLead4);         
          Test.stopTest(); 
    }
    
     @isTest static void leadTest8() {   
    Master__c mas = new Master__c();
        mas.Name = 'Test Pewysfgsg';
        mas.Property_City__c = 'Bengaluru';
        mas.Type__c = 'Showroom';
        insert mas;
        System.debug('######mas  '+mas);
        lead newLead4 = new Lead();
        newLead4.Email = 'test5@test.com';
        newLead4.lastName = 'Test5';
        newLead4.Phone = '5464567895';
        newLead4.LeadSource = 'Unqualified Walk-in';
        newLead4.Status = 'Fresh Lead';
        newLead4.sub_status__c = 'Visited Showroom';
        newLead4.Push_lead_to_Ameyo_Time__c = System.now().addHours(3);
        newLead4.Follow_up_time__c = Date.today();
        newLead4.Property__c = mas.Id;
        newLead4.Appointment_Venue_Square__c = mas.Id;
        newLead4.Why_we_didn_t_offer_design_discussion__c = 'Designer not available'; 
         Test.startTest();
          WalkinLeadController.checkExistingLeadUnqualified(newLead4);
         // WalkinLeadController.updateLeadUnqualified(newLead4);         
          Test.stopTest(); 
    }
   
}