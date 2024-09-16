/*
* Created By    : Aditya Saini
* Created Date  : 25/May/2016
* Modified Date : 13/Oct/2017
* Description   : Lead Trigger  
*/
trigger LeadTrigger on Lead(before insert, after update, before update, after insert) 
{
    
    if(UserInfo.getName() != System.Label.DataLoad_User)
    {
        // We are stopping the trigger for Bulk Updates from Globiva team/Cube Dialler Team (Unable to connect Substatus)
        if(Trigger.new.size() > 1 && (UserInfo.getName() == System.Label.ExternalUserName || UserInfo.getName() == System.Label.External_User_Name))
        {
                System.debug('More than 1 records');
        }
        else
        {
            
            		if (Trigger.isBefore && Trigger.isInsert) 
                    {            
                        LeadTriggerHandler.websiteReferralLeadsIMAssignment(trigger.new);
                        //LeadTriggerHandler.checkDoowupLead(trigger.new); 
                        
                        UpdateReferral_Information.UpdateReferral(trigger.new,NULL);
                        LeadTriggerHandler.InsertEmailForCommunication(trigger.new);
                        LeadTriggerHandler.beforeFBLeadInsert(trigger.new);
                        LeadTriggerHandler.insertDealerInformation(trigger.new);
                        //Commented for Order heirarchy changes
                        //LeadTriggerHandler.validateLeadinsertion(Trigger.new);
                        //Commenting it since it is not used much 
                        //ReferralProgramToLead.referralInsert(Trigger.new);
                        LeadTriggerHandler.insertTerritoryCheck(trigger.new,null);
                        LeadTriggerHandler.updatePossessionDelay(Trigger.newmap,null);
                         LeadTriggerHandler.calculateLeadScore(trigger.new,Null);
                        //LeadTriggerHandler.websiteReferralLeadsIMAssignment(trigger.new);
                        
                        // Moved this trigger to before insert as it was giving error in After insert context            
                        LeadTriggerHandler.createDoowupLeadFromHomeLaneLead(Trigger.New,null);
                        LeadTriggerCubicoAndDoowupHandler.assignDFNShowroom(Trigger.New,null);
                    }
                
                    if (Trigger.isBefore && Trigger.isUpdate &&  RecursiveTriggerHandlerLead.beforeCount <5) 
                    {
            
                        RecursiveTriggerHandlerLead.beforeCount++;
                        // New field added to track Pre-appointment date (7 Feb 2024)
                        LeadTriggerHandler.updatePreAppointmentDate(trigger.new,trigger.OldMap);
                        // Call this method to uncheck the Requested Call Back check box
                        LeadTriggerHandler.insertTerritoryCheck(trigger.new,trigger.OldMap);
                        leadTriggerHandler.uncheckRequestedCallBack(trigger.New,trigger.OldMap);
                        
                        //To check whether to update the lead score after verified for assignment
                        //leadTriggerHandler.LeadScoreUpdateCheck(trigger.New,trigger.OldMap);
                        
                        //Will be moved to after update
                        //LeadTriggerHandler.updateCustomerRegisteredLeads(trigger.New,trigger.OldMap);
                        //Call this method to assign the WTA leads to IM at Pre-Appointment stage.  
                        
                        //leadTriggerHandler.updateFollowUpTimeLSQLeads(trigger.New,trigger.OldMap);
                        
                        UpdateReferral_Information.UpdateReferral(trigger.new, trigger.OldMap);
                        LeadTriggerHandler.UpdateEmailForCommunication(trigger.new);
                        //Commented for order heirarchy changes
                        //LeadTriggerHandler.validateLeadUpdate(trigger.new, trigger.OldMap);
                        LeadTriggerHandler.updatePossessionDelay(trigger.newmap,trigger.OldMap);
                        //LeadTriggerHandler.validateDuplicateLeadUpdate(trigger.new, trigger.OldMap);
                        
                        // Not Needed since it is referring the old field which is not in use
                        LeadSharingHandler.manualShareRead(Trigger.newmap, Trigger.oldmap);
                        Recommended_Meeting_Type.updateMeetingType(Trigger.newmap, Trigger.oldmap);
            
                        LeadTriggerHandler.UpdateActivityCount(Trigger.newmap);
                       // LeadTriggerHandler.checkReLandedLeadStatus(Trigger.new,Trigger.oldmap);
                        
                        
                        LeadTriggerHandler.updateCustomerCityName(Trigger.newMap); 
                        //  SendSMSController.makeSortUrl(Trigger.new);
                        // DPAssignmentField.updEvent(Trigger.new, Trigger.oldMap);
                       
                        //Commenting it since it is not used
                        //ReferralProgramToLead.referralUpdate(Trigger.newMap, Trigger.oldMap);
                        PinCodeController.pinCode(Trigger.new,Trigger.oldMap);
                        ApptCancelDescription.apptCancel(Trigger.new,Trigger.oldMap);
                        // CalculateUCLCallAttempts.UCLAttempts(Trigger.new,Trigger.oldMap);
                        
                        
                        
                        LeadTriggerHandler.calculateLeadScore(trigger.new,trigger.OldMap);
                        //    LeadTriggerHandler.BlitzPropertyScoreUpdate(Trigger.new,Trigger.OldMap);
                        LeadTriggerHandler.WTAtoIMLeadAssignmentCheckPincode(trigger.New,trigger.OldMap);
                        // Newly added in before update to avoid exceptions of after update(commented in after update trigger)
                        LeadTriggerHandler.NimbusProcessedLeadsAssignment(Trigger.new,Trigger.OldMap);
                        // Added on 25th April 2024 to add new Description added 
                        //   Lead_Trigger_Handler_New.updateDescriptionForExternalUser(Trigger.new,Trigger.OldMap);  
                        //   Added on 25th June to delete dealer info if Dealer showroom is removed from Doowup Lead.s
                        LeadTriggerCubicoAndDoowupHandler.removeDealerInfo(Trigger.new,Trigger.OldMap);
                    }
                
                
                    if (Trigger.isafter && Trigger.isinsert) 
                    {
                                 
                        // Assign Leads to Iron Man
                        // Commented and changed based on SQUADIQ and LEAD CURATION logic mix
             
                        //LeadTriggerHandler.checkPincode(Trigger.New);
                        LeadTriggerHandler.callToFBCAPI(Trigger.New,Null);
                  
                        LeadTriggerHandler.checkForPincodeAssignmentTrigger(Trigger.New,NULL); 
                        
                        LeadTriggerHandler.checkForluxeLeadAssignment(Trigger.New,Null);
                        // Call the updateLeadSquareModifeidDate method from LeadTriggerHandler class. Added By Bharatesh Shetty. (Not needed after Insert)
                        // LeadTriggerHandler.updateLeadSquareModifeidDate(Trigger.newMap,null);
                        
                        // Call SendLeadRelatedSMS method from the class LeadTriggerHandler after lead is inserted. Added by Bharatesh Shetty 
                        LeadTriggerHandler.SendLeadRelatedSMS(Trigger.new,null);
                        
                        //LeadTriggerHandler.checkIfPropertyNameUpdated(Trigger.new,null);
                        
                        LeadSharingHandler.manualShareRead(Trigger.newmap, null);
                        
                        PinCodeController.pinCodeOnInsert(Trigger.new);
                        // LeadTriggerHandler.CallPushLeadtoAmeyo(Trigger.new);    
                        //LeadTriggerHandler.sendLeadDuplicationEmail(Trigger.new);
                        
                        //This method will create the DFN lead from Homelane Lead and assign DFN showroom if Homelane Territory is not available
                        LeadTriggerCubicoAndDoowupHandler.createDFNLeadForNOHomeLaneTerritories(Trigger.new);
                        
                        MasterLeadAssociation.leadIns(Trigger.new);                 
                        
                        //This method is written to call Assingment Rule when Lead is created through  Web API 
                        {
                            list < Lead > ls = new list < Lead > ();
                            
                            for (Lead l: Trigger.new) {
                                {
                                    ls.add(new Lead(id = l.id));
                                    // ls.add(l.id);
                                    
                                }
                            }
                            
                            Database.DMLOptions dmo = new Database.DMLOptions();
                            dmo.assignmentRuleHeader.useDefaultRule = true;
                            System.debug('Bangalorelslsls' + ls);
                            Database.update(ls, dmo);
                        }
                        
                        
                      }
                
                    if (Trigger.isafter && Trigger.isupdate && RecursiveTriggerHandlerLead.afterCount < 5) 
                    {
                        System.debug('After Trigger Called');
            
                        // Call the updateLeadSquareModifeidDate method from LeadTriggerHandler class. Added By Bharatesh Shetty. 
                        // Commented the code as it was no longer needed because this is being taken care from the middleware.
                        //LeadTriggerHandler.updateLeadSquareModifeidDate(Trigger.newMap,Trigger.OldMap);
                        System.debug('System.isBatch(): '+System.isBatch());
                        System.debug('System.isFuture(): '+System.isFuture());
                        
            
                        LeadTriggerHandler.callToFBCAPI(Trigger.New,Trigger.OldMap);
                        // Added based on SQUADIQ and LEAD CURATION logic mix
                        LeadTriggerHandler.checkForPincodeAssignmentTrigger(Trigger.New,Trigger.OldMap);
                    
                        LeadTriggerHandler.relandedLeadAssignmentTrigger(Trigger.New,Trigger.OldMap);
                        LeadTriggerHandler.callPushLeadToNimbus(Trigger.New,Trigger.OldMap);
                        
                        //LeadTriggerHandler.squadIQProcessedLeadsAssignment(Trigger.new,Trigger.OldMap);
                      
                        // Commented because this trigger moved to before update
                        //  LeadTriggerHandler.NimbusProcessedLeadsAssignment(Trigger.new,Trigger.OldMap);
            
                        LeadTriggerHandler.rosterReferralLeadsIMAssignment(Trigger.new,Trigger.OldMap);
                       
                       // Commented this trigger as we are no longer using it. Half of the code is commented to stop the functionality.
                       // LeadTriggerHandler.checkIfPropertyNameUpdated(Trigger.new,Trigger.OldMap);
                        
                        LeadTriggerHandler.handleLeadRosterEmails(Trigger.new,Trigger.OldMap);
                        
                        //Will be called internally in the updateCustomerRegisteredLeads method
                        //LeadTriggerHandler.processCustomerRegisteredLeads(Trigger.new,Trigger.OldMap);
                        LeadTriggerHandler.updateCustomerRegisteredLeads(trigger.New,trigger.OldMap);
                        
                        //  Commented the following trigger on the request of DEEPAK M as they dont want re-assignment
                        //LeadTriggerHandler.reassignToInsideSalesAgent(trigger.New,trigger.OldMap);
                        
                        //This should be commented as the communication will happen through the Order specific unique id and 
                        //not the customer email id going forward as per the Order Hierarchy implementation.
                        //Call IsEmailUpdated method to check if the email has been updated and then to update MIQ if yes.
                        //LeadTriggerHandler.isEmailUpdated(Trigger.newMap,Trigger.OldMap);
                        if(RecursiveTriggerHandlerLead.cubicoCount<1)
                        {
                            LeadTriggerCubicoAndDoowupHandler.AssignDeadLeadsToCubicoShowrooms(trigger.New,trigger.OldMap);                
                        }
                        if(RecursiveTriggerHandlerLead.wrapzapCount<1)
                        {
                            LeadTriggerCubicoAndDoowupHandler.AssignDeadLeadsToWrapzapShowrooms(trigger.New,trigger.OldMap);                
                        }
               
                        //Call IsEmailUpdated method to check if the DP has been updated and then to update MIQ if yes.
                        LeadTriggerHandler.isDPUpdated(Trigger.new,Trigger.OldMap);
                        
                        //WhatsappTrigger.UnableToContact(trigger.new,Trigger.oldmap);
                        System.debug('fired lead assignement and entered');
                        
                        WTA_Flow__c objFlow = WTA_Flow__c.getValues('Flow2');
                        if(objFlow != NULL){
                            if(objFlow.isActive__C != true){
                                system.debug('---objFlow--handleRoundRobin-'+objFlow);
                                LeadTriggerHandler.handleRoundRobin(Trigger.new, Trigger.oldmap);
                            }
                        }
                        LeadTriggerHandler.UpdateMeetingTask(Trigger.new,Trigger.oldmap);
                        LeadTriggerHandler.SendLeadRelatedSMS(Trigger.new,Trigger.oldmap);
                        system.debug('---objFlow---'+objFlow);
                        if(objFlow != NULL){
                            if(objFlow.isActive__C != true){  
                                system.debug('---objFlow--CallPushLeadtoOzoneTel-'+objFlow);
                                LeadTriggerHandler.CallPushLeadtoOzoneTel(Trigger.new,Trigger.oldmap);
                            }
                        }
                        //Commented By Bharatesh as suggested by Pavan
                        //SendEmailToSSA.SendEmailUpd(Trigger.new, Trigger.oldMap);
                        System.debug('Commented SendEmailToSSA.SendEmailUpd method: ');
                        MasterLeadAssociation.leadUpd(Trigger.new,Trigger.oldMap);
                        
                        RecursiveTriggerHandlerLead.afterCount++;
                        
                        
                        UpdateAvailability__c mc = UpdateAvailability__c.getOrgDefaults();
                        if(mc.Flag__c) {
                            //added for making DP available when meeting is cancelled
                            RosterDpAvailability.RosterDpCancel(Trigger.oldMap,Trigger.NewMap);
                            //added for rescheduling of DP
                            //  RosterDpAvailability.RescheduleRoster(Trigger.oldMap,Trigger.NewMap);
                            
                            //Commented By Bharatesh as suggested by Pavan
                            //SendEmailToSSA.SendEmailToDp(Trigger.new, Trigger.oldMap);
                            System.debug('Commented SendEmailToSSA.SendEmailToDp method: ');
                        }
                        
                        // Assigning new inside sales agent after 24 hours of Inside sales assignment(if there is no change in Status or substatus)
                       IronManInsideSalesLeadAssignment.SwitchToNewInsideSalesAgent(Trigger.new, Trigger.oldmap);
                        
                       //Create new Doowup DFN Lead/Normal Doowup Lead from Homelane Dead Lead 
                       if(RecursiveTriggerHandlerLead.doowupCount<1)
                       {
                            LeadTriggerCubicoAndDoowupHandler.doowupDFNLeadCreation(Trigger.new, Trigger.oldmap);
                            
                       }            
                        
                    }
                
                    if (Trigger.isafter && Trigger.isupdate) 
                    {
                        WTA_Flow__c objFlow = WTA_Flow__c.getValues('Flow2');
                        
                        if(objFlow != NULL){
                            if(objFlow.isActive__C == true){
                                system.debug('---objFlow--Lead_Assignment_Handler-'+objFlow);
                                Lead_Assignment_Handler.callOzoneTel(Trigger.newMap,Trigger.oldMap);
                            }   
                        }
                    }
                    //Added by Rohan Dsouza
                    /*if(Trigger.isBefore && Trigger.isInsert){
                        LeadTriggerHandler.beforeInsert(Trigger.new,null);
                    }*/
            
        }                     
        
    }
}