global class DPTransferBatch implements Database.Batchable<sObject>, Database.Stateful{
    global final String oldDPEmail;
    global String newDPEmail ;
    global Schema.SObjectType  LeadOrOpportunity;
    
    //global boolean isOppUpdated = true;
    
    global DPTransferBatch (String old_Email,String new_Email,Schema.SObjectType leadOpportunity ){
        oldDPEmail = old_Email;
        newDPEmail = new_Email;
        LeadOrOpportunity = leadOpportunity;
        
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        system.debug('start method');
        system.debug('old email '+ oldDPEmail );
        system.debug('LeadOrOpportunity '+ LeadOrOpportunity);
        String  query ='';
       
            
            if(LeadOrOpportunity == Lead.SObjectType ){
                system.debug('lead');
                query ='Select id, Interior_Designer__c, Dp_Email__c from Lead where Dp_Email__c = :oldDPEmail';
            }
            else if(LeadOrOpportunity == Opportunity.sObjectType){
                system.debug('opportunity');
                query ='select id, Interior_Design_Partner__c, Design_Partner_Email__c from Opportunity where Design_Partner_Email__c = :oldDPEmail';
            }
        
        system.debug('query '+ query);
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext BC, List<sObject> scope){
        
        system.debug('scope '+scope);
        
        if(!scope.isEmpty()){
            List <Interior_Designer__c> newEmailInteriorDesigner = [Select id ,Email__c from Interior_Designer__c where Email__c=:newDPEMail];
            List<Lead> leadListToUpdate = new List <Lead>();
            List<Opportunity> oppListToUpdate = new List<Opportunity>();
            
            for(sObject  sobj :scope){
                if(sobj.getSObjectType() == Lead.sObjectType){
                    Lead ldToUpdate = new Lead();
                    ldToUpdate.id = ((Lead) sobj).id; 
                    ldToUpdate.Interior_Designer__c = newEmailInteriorDesigner[0].id;
                    leadListToUpdate.add(ldToUpdate);
                }
                else if(sobj.getSObjectType()==  Opportunity.sObjectType){
                    Opportunity oppToUpdate = new Opportunity();
                    oppToUpdate.id = ((Opportunity) sobj).id; 
                    oppToUpdate.Interior_Design_Partner__c = newEmailInteriorDesigner[0].id;
                    oppListToUpdate.add(oppToUpdate);
                }
                
                
                
            }
            system.debug('oppListToUpdate '+ oppListToUpdate);
            system.debug('leadListToUpdate' + leadListToUpdate);
            try{
                if(!leadListToUpdate.isEmpty()){
                    update leadListToUpdate;
                }
                if(!oppListToUpdate.isEmpty()){
                    update oppListToUpdate;
                }
            }Catch(Exception e){
                
                System.debug('Exception Message: '+e.getMessage());
                System.debug('Exception StackTraceString: '+e.getStackTraceString());
                Logger.log('Exception','DPTransferBatch Class','execute Method',e.getMessage(),e.getStackTraceString(),null);
                
            }
           
        }
        
       // system.debug('isOppupd'+isOppUpdated );
    }
    global void finish(Database.BatchableContext BC){
        
        List<Opportunity> oppList = [select id,Interior_Design_Partner__c,Design_Partner_Email__c from Opportunity where Design_Partner_Email__c=:oldDPEmail];
//        system.debug('isOppUpdated '+ isOppUpdated );
        if(!oppList.isEmpty() && LeadOrOpportunity == Lead.SObjectType  ){
            DPTransferBatch batchable = new DPTransferBatch(oldDPEmail , newDPEmail, Opportunity.sObjectType ); 
            database.executeBatch(batchable,1);
        }
        
    }
}