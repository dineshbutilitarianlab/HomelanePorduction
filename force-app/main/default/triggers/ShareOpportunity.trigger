/**
 * @File Name          : ShareOpportunity.trigger
 * @Description        : 
 * @Author             : Bharatesh Shetty
 * @Group              : 
 * @Last Modified By   : Bharatesh Shetty
 * @Last Modified On   : 8/27/2019, 7:48:28 PM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    8/12/2019, 6:00:18 PM   Bharatesh Shetty     Initial Version
**/
trigger ShareOpportunity on Opportunity(before insert, after update, before update, after insert) {
    
    Public static Boolean truevalue=true;
    system.debug('*** Logged in user ' + UserInfo.getName());
    
    if(UserInfo.getName() != System.Label.DataLoad_User){
        System.debug('Inside Trigger ');   
          if (Trigger.isBefore && Trigger.isinsert) 
          {
            
            // Change Stage Based on Status.
             OpportunitySharingHandler.opptyStages(Trigger.New);
             OpportunityTriggerHandler.updateCustomerEmail_Phone(Trigger.new);
             OpportunityTriggerHandler.RemoveNullFromName(Trigger.new);
              
              // Added this trigger on 20 March 2024
			 OpportunityTriggerHandler.updateFollowupTimeOnFreshOpportunity(Trigger.new);
            // Call updateLeadSquareModifeidDate method of OpportunitySharingHandler class. Added by Bharatesh Shetty
            //Commented the code as it was no longer needed because this is being taken care from the middleware.
            //LeadSquareIntegration_Controller.updateLeadSquareModifeidDate(null,null,Trigger.New);
        
          	 // function to update the GST information on all Opportunities.
            OpportunityTriggerHandler.updateGSTinfo(Trigger.new,Trigger.OldMap);
          }

        if (Trigger.isafter && Trigger.isinsert) {
			OpportunityTriggerHandler.afterInsert(Trigger.newmap);
            //Update the CustomerEmail field in Opportunity
            //LeadSquareIntegration_Controller.updateCustomerEmail(Trigger.newmap, NULL);

            //Call SpaceCraft API When ever new Opportunity is created
            System.enqueueJob(new Rest_SendOpportunitytoSpaceCraft(Trigger.new));
        }
    
        if (Trigger.isBefore && Trigger.isUpdate &&  RecursiveTriggerHandlerOpp.beforeCount <3) {
            // Call this method to uncheck the Requested Call Back check box
            OpportunityTriggerHandler.uncheckRequestedCallBack(trigger.New,trigger.OldMap);
            // Call updateLeadSquareModifeidDate method of OpportunitySharingHandler class. Added by Bharatesh Shetty
            //Commented the code as it was no longer needed because this is being taken care from the middleware.
            //LeadSquareIntegration_Controller.updateLeadSquareModifeidDate(Trigger.newMap,Trigger.oldMap,null);
            
            OpportunityTriggerHandler.updateEBPApplicableCheckbox(trigger.New,trigger.OldMap);
            
            OpportunityTriggerHandler.updateProbabilityOfClosure(trigger.New,trigger.OldMap);
            
            //Added by Venkat - update Opportunity Outstanding Balance when bills are approved
            OpportunitySharingHandler.updateOpptyBalance(trigger.New,trigger.OldMap);
            //Change Status based on Stage.
            //Commented by Bharatesh Shetty (because it is handled in the opptyChangeStage method of OpportunityTriggerHandler class)
            //OpportunitySharingHandler.opptyChangeStage(Trigger.New,Trigger.OldMap);
            //Change Status based on Stage.
            OpportunityTriggerHandler.opptyChangeStage(Trigger.New,Trigger.OldMap);
            //OpportunitySharingHandler.UpdateEmailForCommunication(Trigger.New);
            OpportunityTriggerHandler.UpdateEmailForCommunication(Trigger.oldmap,Trigger.newMap);
            //Commented for Order Heirarchy
            //OpportunitySharingHandler.validateOpportunityUpdate(Trigger.New,Trigger.OldMap);
            OpportunitySharingHandler.validateParentOpportunity(Trigger.New,Trigger.OldMap);
            
             // Added this trigger on 20 March 2024
            if(RecursiveTriggerHandlerOpp.beforeCount <1)
            {
            	OpportunityTriggerHandler.updateFollowupTimeOnNewCloseDateChange(Trigger.new,Trigger.OldMap);
            }
            //Stopped because this API was being called twice. One when Works contract Controller and another fom here.
            //OpportunitySharingHandler.WorksContractTrue(Trigger.New,Trigger.oldMap); 
            RecursiveTriggerHandlerOpp.beforeCount++;
        }
    
/***************************************************************************************************************************/
       if (Trigger.isafter && Trigger.isupdate && RecursiveTriggerHandlerOpp.afterCount <2) {
            system.debug('update---------------->');
            
            // Call the updateLeadSquareModifeidDate method from OpportunitySharingHandler class. Added By Bharatesh Shetty.
            /*System.debug('After update Trigger called');
            OpportunitySharingHandler.updateLeadSquareModifeidDate(Trigger.newMap,Trigger.oldMap,null); */

            //SendNpsToRoster
           SendNpsToRoster.CheckNpsUpdation(trigger.new,Trigger.oldMap);

            //Update master record
           PropertyOpportunityAssoication.opportunityUpdate(Trigger.new, Trigger.oldmap);
            
            // function to update the DP information on IQ by hitting the IQ API.
            OpportunityTriggerHandler.updateDP(Trigger.new, Trigger.oldmap);           
            
            //This should be commented as the communication will happen through the Order specific unique id and 
            //not the customer email id going forward as per the Order Hierarchy implementation.
            //Update the CustomerEmail field in Opportunity
            //OpportunityTriggerHandler.IsEmailUpdated(Trigger.newmap, Trigger.oldmap);
            
            // Send SMS
            OpportunityTriggerHandler.sendOpportunityRelatedSMS(Trigger.New,Trigger.oldmap);
           
            OpportunityTriggerHandler.handleOpportunityRosterEmails(Trigger.new,Trigger.OldMap);
            OpportunityTriggerHandler.callOppToFBCAPI(Trigger.new,Trigger.OldMap);
           	
           // function to update the GST information on all Opportunities.
            OpportunityTriggerHandler.updateGSTinfo(Trigger.new,Trigger.OldMap);
           
            // When D3 Substatus Changes from Project Kick-off Proposed to Project Kick-off MEeting Confirmed , Send Event Details
            //Commented by Bharatesh shetty on 29th Oct 2020 after checking with pavan because these emails are not needed.
            //OpportunitySharingHandler.sendProjectDetailsToCustomer(Trigger.new, Trigger.oldMap);
           // Commented and added in the next line to handle the Email API to Mandril via Roster.   
           //opportunitySharingHandler.WorksContractSignOff(Trigger.new, Trigger.oldMap);   
           //OpportunityTriggerHandler.WorksContractSignOff(Trigger.new, Trigger.oldMap);
            //temprorary
            RecursiveTriggerHandlerOpp.afterCount++;
        }
    }
}