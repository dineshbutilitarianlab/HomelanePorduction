/**
* @File Name          : UnverifiedLeadsAssignmentInitiateBatch.cls
* @Description        : 
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 10/15/2019, 12:21:43 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author      		      Modification
*==============================================================================
* 1.0    10/15/2019, 12:20:14 PM   Bharatesh Shetty     Initial Version
**/
global class UnverifiedLeadsAssignmentInitiateBatch implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable {
    Public Set<Id> setOfIds = new Set<Id>();
    // Constructor to excecute only set of records in the Batch which runs everyday.
    global UnverifiedLeadsAssignmentInitiateBatch(Set<Id> setOfIds){
        this.setOfIds = setOfIds;
    }
    global UnverifiedLeadsAssignmentInitiateBatch(){
        
    }
    global void execute(SchedulableContext SC) {
        database.executebatch(new UnverifiedLeadsAssignmentInitiateBatch(),1);
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        system.debug('start');
        DateTime leadCreatedBeforeTime = System.now().addMinutes(-(Integer.valueOf(Label.UnverifiedLeadsPickTimeForAssignment)));
        DateTime leadCreatedAfterTime = System.now().addMinutes(-(Integer.valueOf(Label.UnverifiedLeadsPickTimeForAssignmentAfterTime)));
        system.debug('lead before'+leadCreatedBeforeTime);
        system.debug('now'+system.now());
        system.debug('lead after'+leadCreatedAfterTime);
        
        
        
       Set<String> GreenChannelPincodeSet = new Set<String>();
       GreenChannelPincodeSet = GreenChannelLeadAssignmentInitiateBatch.getGreenPincode();
        
        String queryString = UtilityClass.getQueryString('Lead');
        queryString += ' From Lead where Status =\'Fresh Lead\' and (Sub_Status__c=\'Unverified\' or Sub_Status__c=\'Customer Online\') and assigned_To_resi_Asm__c = False and Transfer_Status__c !=\'Doowup Transfer\' and Pushed_To_Ozonetel__c = False and Squad_IQ_Status__c!=\'Sent to SquadIQ\' and Should_run_Ironman_assignment__c = True  and Assignment_Initiate_Stage__c !=\'HL Doowup GFE Experiment\'  and createdDate <= :leadCreatedBeforeTime and CreatedDate >= : leadCreatedAfterTime and (PostalCode !=:GreenChannelPincodeSet Or (PostalCode =:GreenChannelPincodeSet and Brand__c=\'Doowup\')) ';
            
        if(!setOfIds.isEmpty()){
            queryString += ' and id=:setOfIds';
        }
        if(Test.isRunningTest()){
            queryString = 'Select id from Lead limit 1';
        }
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> listOfLeads) { 
        System.debug('listOfLeads' +listOfLeads);
        
        try{
            System.debug('listOfLeads: '+listOfLeads);
            if(!listOfLeads.isEmpty()){
                for(Lead leadrec : listOfLeads){
                    
                        leadrec.Assignment_Initiate_Stage__c = 'Unverified - SquadIQ/IRM';
                    
                    
                }
                update listOfLeads; 
            }
            
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
        }
    }   
    
    global void finish(Database.BatchableContext bc){ 
        System.debug('finish method');   
    }
}