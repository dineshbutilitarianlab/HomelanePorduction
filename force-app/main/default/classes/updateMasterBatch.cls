global class updateMasterBatch implements Database.Batchable<sObject> {
    
    Set<Id> setMasterId = new Set<Id>();
    public updateMasterBatch(Set<Id> setID){
        this.setMasterId = setID; 
    }
    
    global database.QueryLocator start(Database.BatchableContext bc)
    {
        String sQuery = 'Select name,Unique_Name__c from master__C where id IN : setMasterId' ;
                        system.debug('sQuery'+sQuery);
        return database.getQueryLocator(sQuery);
    }
     
    global void execute(Database.BatchableContext bc,List<master__C> scope)
    {
        try{
            String newString;
            String Name;
            list<Master__c> lstmaster = new List<Master__c>();



            list<RedundantPropertyString__mdt>  lstRedundantString = [Select Label,Priority__c,RedundantString__c,IsPreposition__c from RedundantPropertyString__mdt
                                                                        order by Priority__c ASC];
                                                                        
                                                                        
            for(Master__c m:scope){
               
                Name = m.name;
                //Add Space at begining and Ending of the word
                Name = ' '+Name.toLowerCase()+' ';
                System.debug('+++Name lower++'+Name);
                //replace Double space with single space  
                Name = Name.replace('  ',' ');

                //Remove the Number 
                Name = Name.replaceAll('[0-9]', '');

                // Remove Special Character  
                Name = Name.replaceAll('[^a-zA-Z\\s+]', '');

                System.debug('+++PropertyMatchString__c ++'+lstRedundantString);
                for(RedundantPropertyString__mdt strRemove:lstRedundantString){
                   
                        newString =' '+strRemove.RedundantString__c.toLowerCase()+' ';
                        Name = Name.replace(newString,' '); 
                  
                }

                //Replace Double space with single space  
                Name = Name.replace('  ',' ');


                //Remove white Space from begining and End
                Name = Name.trim();

                m.Unique_Name__c = Name.replaceAll( '\\s+', '');
                lstmaster.add(m);

            }
                    if(lstmaster!=NULL && !lstmaster.isempty())
                    {
                        update lstmaster;
                    }
                    
            }
        catch(Exception e){
             Logger.log('Exception','updateMasterBatch ','execute',e.getMessage(),e.getStackTraceString(),NULL);
        }    
    }
    
    global void finish(Database.BatchableContext bc)
    {
    }


}