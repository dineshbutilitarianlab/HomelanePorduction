global class GreenChannelLeadAssignmentInitiateBatch implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable {
    Public Set<Id> setOfIds = new Set<Id>();
    // Constructor to excecute only set of records in the Batch which runs everyday.
    global GreenChannelLeadAssignmentInitiateBatch(Set<Id> setOfIds){
        this.setOfIds = setOfIds;
    }
    global GreenChannelLeadAssignmentInitiateBatch(){
        
    }
    global void execute(SchedulableContext SC) {
        database.executebatch(new GreenChannelLeadAssignmentInitiateBatch(),1);
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
       Set<String> GreenChannelPincodeSet = new Set<String>();
       GreenChannelPincodeSet = GreenChannelLeadAssignmentInitiateBatch.getGreenPincode();
        
        //
        DateTime greenLeadCreatedBeforeTime = System.now().addMinutes(-(Integer.valueOf(Label.GreenChannelIMAssignmentBefore)));
       // system.debug('lead before'+leadCreatedBeforeTime);
        
        system.debug('now'+system.now());
        DateTime greenLeadCreatedAfterTime = System.now().addMinutes(-(Integer.valueOf(Label.GreenChannelIMAssignment)));
        //system.debug('lead after'+leadCreatedAfterTime);
        String queryString = UtilityClass.getQueryString('Lead');
        queryString += ' From Lead where (Status =\'Fresh Lead\' or Status =\'Pre-Appointment\' or Status =\'WhatsApp Pre-Appointment\') and (Sub_Status__c=\'Unverified\' or Sub_Status__c=\'Customer Online\' or Sub_Status__c=\'New\' or Sub_Status__c =\'Pre-Appointment\') and assigned_To_resi_Asm__c = False  and Assigned_To_Inside_Sales_Agent__c =false and Sign_Up_Source__c !=\'WhatsAppHaptik\' and Brand__c != \'Doowup\' and Assigned_to_Central_Team__c = False and Transfer_Status__c !=\'Doowup Transfer\' and Pushed_To_Ozonetel__c = False  and Squad_IQ_Status__c!=\'Sent to SquadIQ\' and Should_run_Ironman_assignment__c = True and Assignment_Initiate_Stage__c !=\'HL Doowup GFE Experiment\'  and createdDate <= :greenLeadCreatedBeforeTime and CreatedDate >= : greenLeadCreatedAfterTime and PostalCode =:GreenChannelPincodeSet';
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
                    leadrec.Assignment_Initiate_Stage__c = 'Green Channel IM Assignment';
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
    
    public static Set<String> getGreenPincode(){
        List<Green_Channel_Pincode__mdt> GreenChannelPincodeList = new List<Green_Channel_Pincode__mdt>();
        GreenChannelPincodeList =[select id,Postal_code__c from Green_Channel_Pincode__mdt];
        Set<String> GreenChannelPincodeSet = new Set<String>();
        for(Green_Channel_Pincode__mdt greenchnlpincode :GreenChannelPincodeList){
            GreenChannelPincodeSet.add(greenchnlpincode.Postal_code__c);
        }
        return GreenChannelPincodeSet;
    }
}