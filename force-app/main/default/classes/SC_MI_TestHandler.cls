public class SC_MI_TestHandler {
   public static SC_Section__c insertSection(String sectionName,String Stage,Integer Order,Id parentSection){
        return new SC_Section__c(Section__c           = sectionName,
                                 Opportunity_Sub_Status__c = Stage,
                                 Order__c             = Order,
                                  Parent_Section__c    = parentSection);
    }    
    public static SC_Item__c insertItem(String itemName,Boolean isActive,String responseType,String recordType){
        return new SC_Item__c( Item__c           = itemName,
                               Is_Active__c      = isActive,
                               Record_Type__c    = recordType, 
                               Response_Type__c  = responseType);    
    }
    public static SC_Response__c insertResponse(String answer,Id item,Integer score,Boolean isActive,Boolean requiredForNextStage){
        return new SC_Response__c( Answer__c                 = answer,
                                   Item__c                   = item,
                                  Score__c                  = score,
                                   Is_Active__c              = isActive,
                                  Required_for_Next_Stage__c= requiredForNextStage);
    }
    public static SC_User_Response__c insertUsrResponse(Id item,String response,String stage,Id oppId,Integer responseScore){
        return new SC_User_Response__c( Item__c           = item,
                                       User_Response__c  = response,
                                       Stage__c          = stage,
                                       Opportunity__c    = oppId,
                                       Response_Score__c  = responseScore);
    }  
    public static SC_Section_Item__c insertSectionItem(Id Item,Id Section,Integer Order){
        return new SC_Section_Item__c( Item__c      = item,
                                       Section__c  = Section,
                                       Order__c    = Order);
    }
    public static Opportunity insertOpportunity(String Name,Date closedDate,String StageName,Integer Amount,Date ForecastDate){
    

    
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> OpportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id printerId = OpportunityRecordTypeInfo.get('Record Type D1').getRecordTypeId();
     //   System.debug('opp'+printerId);
      RecordType recType1=[SELECT Id FROM RecordType WHERE Name='Business Account'];
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.recordTypeId=recType1.Id;
      //  acc.PersonEmail='John@gmail.com';
        insert acc;
        Contact con = new Contact();
        con.LastName = 'Test contact';
        con.AccountId = acc.Id;
        insert con;
        return new Opportunity(Name       = Name,
                               CloseDate  = closedDate,
                               
                               Amount     = Amount,
                               stageName='D1 Initiated',
                               recordTypeId =printerId  ,
                               NextStep = 'test step',
                               AccountId = acc.Id
                              
                              );
    }
    public static void insertIsTriggerExecute(){
        SC_isTriggerExecute__c isTriggerEx = new SC_isTriggerExecute__c();
        isTriggerEx.name = 'Sales Coach Trigger on Opportunity';
        isTriggerEx.isTriggerExecute__c = TRUE;
        insert isTriggerEx;
    }
    public Static void insertCustomDate(){
        SC_OpportunityCustDate__c setting = new SC_OpportunityCustDate__c();
        setting.SC_StartDate__c= System.Today()-1;
        setting.Name = 'StartDate';
        insert setting;
        
        

    }
}