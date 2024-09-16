Public Class ThankyouPageController{


    Public String Id {get;set;}
    Public Opportunity oppty{get;set;}
    Public String workContactSingOffDate{get;set;}
    Public String CMName {get;set;}
    Public String CMEmailAddress{get;set;}
 
        public ThankyouPageController()
        {
           try{
                Id = ApexPages.currentPage().getParameters().get('id');
                CMName = ApexPages.currentPage().getParameters().get('CMName');
                CMEmailAddress = ApexPages.currentPage().getParameters().get('CMEmailAddress');
                oppty = getOpportunityRecord(Id);
                if(oppty.Works_Contract_Sign_Off_Date__c!=NULL){
                    workContactSingOffDate = String.Valueof(oppty.Works_Contract_Sign_Off_Date__c.date());
                    System.debug('CMName: '+CMName);
                    System.debug('CMEmailAddress: '+CMEmailAddress);
                    System.debug('oppty.Interior_Design_Partner__r.Name: '+oppty.Interior_Design_Partner__r.Name);
                    if(String.isBlank(CMName)|| String.isBlank(CMEmailAddress)){
                        CMName = oppty.Interior_Design_Partner__r.Name;
                        CMEmailAddress = oppty.Design_Partner_Email__c;
                    }
                    System.debug('oppty.Works_Contract_Sign_Off_Done__c'+String.Valueof(oppty.Works_Contract_Sign_Off_Date__c.date()));
                }
            }    
            catch(Exception e){ System.debug('++++e++++'+e);}
        }
              
        public static Opportunity getOpportunityRecord(Id opptyId) {
            try{
                Opportunity opportunityrec = new Opportunity();
                opportunityrec = [select id, name,Customer_ID__c,Works_Contract_Sign_Off_Done__c,Works_Contract_Sign_Off_Date__c,Customer_Email__c,
                                    Date_Of_NPS_Form_Sign_Off__c,Address_Of_Instalation__c,Customer_s_Interior_Rating__c,Date_Of_Completion__c,
                                    Experience_On_Installation__c,Experience_On_Home_Design__c,Customer_Feedback_Suggestion__c,
                                    Customer_s_Recommendation_Of_Homelane__c,Sub_Status__c,Works_Contract_Comments__c,
                                    Final_Works_Contract_Comments__c,Scope_Of_Work__c,Final_Customer_Rating__c,
                                    Customer_Satisfaction__c,StageName,Interior_Design_Partner__r.Name, Design_Partner_Email__c from Opportunity where id =: opptyId];
                return opportunityrec;
            }  
            catch(Exception e){ System.debug('++++e++++'+e);return NULL;}           
        }
}