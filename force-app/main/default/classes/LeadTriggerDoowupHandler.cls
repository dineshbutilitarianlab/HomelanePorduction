public class LeadTriggerDoowupHandler {
    public static void doowupLeadCreation (List<Lead> newList,Set<String>  setOfPincodes){
        system.debug('method entry');
        try{
          list<Territory__c>  lstTerritory = new list<Territory__c>();
          Lead_Class_Scoring__c HLRec;
          List<Lead> insertLeadList = new List<lead>();
          Set<string> emailSet = new Set<string>();
          Set<String> phoneSet = new Set<String>();
         
          List<lead> ldList = new List<Lead>();          
          List<Lead_Class_Scoring__c> hlrecList = new List<Lead_Class_Scoring__c>();
          Boolean BudgetFlag = false;
          boolean purposeFlag = false;
          boolean propType = false;
          Id LeadId;
          Id recTypeId = Schema.SObjectType.Lead_Class_Scoring__c.getRecordTypeInfosByName().get('Routing HL Leads').getRecordTypeId();
          system.debug('recTypeId');
        system.debug('setOfPincodes '+setOfPincodes);
                      if(!setOfPincodes.isEmpty()){
                          lstTerritory= [Select id,Name,Cluster__c,City__c,Ironman__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,Pincode__c,Assignment__c,Cluster_Brand__c
                                         From Territory__c
                                         Where Pincode__c IN:setOfPincodes and Cluster_Brand__c = 'Doow up'];
                      }
                      system.debug('lstTerritory'+lstTerritory);
                      
                      if(!lstTerritory.isEmpty()){
                          
                          
                          system.debug('terri entry');
                          HLRec = [Select id,Budget_Counter__c,Budget_Counter_Limit__c,Purpose_Counter__c,Purpose_Counter_Limit__c,Property_Counter__c,Property_Counter_Limit__c,Counter_Limit__c,	Total_Limit__c
                                   from Lead_Class_Scoring__c 
                                   where RecordTypeId =:recTypeId 
                                   limit 1];
                          system.debug('Hlrec'+ HLRec);
                          if(HLRec != null&& Hlrec.Counter_Limit__c < Hlrec.Total_Limit__c){
                              for(lead ld :newList){
                                  
                                  
                                  if(HLRec.Budget_Counter__c <  HLRec.Budget_Counter_Limit__c && ld.Budget_Range__c =='Upto 1.5L' ){
                                      
                                      BudgetFlag = true;
                                      Lead newlead = LeadTriggerDoowupHandler.createDoowupLead(ld);
                                      system.debug('budget flag '+BudgetFlag + newlead);
                                      LeadId = ld.id;
                                      insertLeadList.add(newLead);
                                      
                                  }
                              
                              else if(Hlrec.Property_Counter__c < Hlrec.Property_Counter_Limit__c && ld.Property_Config__c =='1 BHK'){
                                  propType = true;
                                  Lead newlead = LeadTriggerDoowupHandler.createDoowupLead(ld);
                                  system.debug('propTypeflag '+propType + newlead);
                                  //ldList.add(ld);
                                  LeadId = ld.id;
                                  insertLeadList.add(newLead);
                              }
                              else if(HLrec.Purpose_Counter__c < HlRec.Purpose_Counter_Limit__c && ld.Property_Status__c=='Rent Out'){
                                  purposeflag = true;
                                  Lead newlead = LeadTriggerDoowupHandler.createDoowupLead(ld);
                                  system.debug('purpose flag '+purposeFlag + newlead);
                                  //ldList.add(ld);
                                  LeadId = ld.id;
                                  insertLeadList.add(newLead);
                              }
                              }
                          }
                      }
                      system.debug(' insertLeadList ' +  insertLeadList);
                      if(!insertLeadList.isEmpty()){
                          Database.SaveResult[] saveResultList = Database.insert(insertLeadList, false);
                          for (Database.SaveResult sr : saveResultList) {
                              if (sr.isSuccess()) {
                                  Showroom_User__c doowupUser = [select id,Email__c from Showroom_User__c where Email__c ='doowuptransfer@homelane.com' limit 1];
                                  system.debug('doowup user'+ doowupUser);
                                  // Operation was successful, so get the ID of the record that was processed
                                  Lead ld= new Lead();
                                  ld.id= leadId;
                                  ld.Assigned_to_Resi_ASM__c= true;
                                  ld.Sales_Manager__c=doowupUser.id;
                                  ld.Transfer_Status__c ='Doowup Transfer';
                                  ldList.add(ld);
                                  
                                  System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                                  HLRec = [Select id,Budget_Counter__c,Budget_Counter_Limit__c,Purpose_Counter__c,Purpose_Counter_Limit__c,Property_Counter__c,Property_Counter_Limit__c,Counter_Limit__c,	Total_Limit__c
                                           from Lead_Class_Scoring__c 
                                           where RecordTypeId =:recTypeId
                                           limit 1];
                                  if(HlRec!=null && Hlrec.Counter_Limit__c < Hlrec.Total_Limit__c){
                                      if( BudgetFlag  == true){
                                          if(HLRec.Budget_Counter__c == Null ||HLRec.Budget_Counter__c==0 ){
                                              HLRec.Budget_Counter__c =1;
                                              
                                          }else{
                                              HLRec.Budget_Counter__c +=1;
                                              
                                          }  
                                      }
                                      if(propType == true){
                                          
                                          if (HLRec.Property_Counter__c == Null ||HLRec.Property_Counter_Limit__c==0 ){
                                              HLRec.Property_Counter__c =1;
                                              
                                          }else{
                                              HLRec.Property_Counter__c +=1;
                                              
                                          }  
                                      }
                                      if(purposeflag == true){
                                          if (HLRec.Purpose_Counter__c == Null ||HLRec.Purpose_Counter__c==0 ){
                                              HLRec.Purpose_Counter__c =1;
                                              
                                          }else{
                                              HLRec.Purpose_Counter__c +=1;
                                              
                                          }  
                                      }
                                      if(BudgetFlag  == true ||propType == true ||purposeflag == true){
                                          if(Hlrec.Counter_Limit__c == Null || hlrec.Counter_Limit__c ==0){
                                              hlrec.Counter_Limit__c =1;
                                              
                                          }else{
                                              hlrec.Counter_Limit__c +=1;
                                          }
                                      }
                                      
                                      hlrecList.add(HLRec);
                                  }
                              } else{
                                  system.debug(sr.getErrors());
                              }
                          }
                          
                      }
                      if(!hlrecList.isEmpty()){
                          update hlrecList;
                      }
                      if(!ldList.isEmpty()){
                          update ldList;
                      }
            }catch(Exception e){
             System.debug('Exception Message: '+e.getMessage());
            System.debug('Exception StackTraceString: '+e.getStackTraceString());
            Logger.log('Exception','LeadTriggerDoowupHandler Class','doowupLeadCreation Method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    public static lead createDoowupLead(lead ld){
        Lead newLead = new Lead();
        if(ld!=null){
            
            newLead.LastName = ld.LastName;
            newLead.Email= ld.Email;
            newLead.PostalCode = ld.PostalCode;
            newlead.Phone=ld.Phone;
            newlead.Area_Code__c = ld.Area_Code__c;
            newlead.Brand__c='Doowup';
            newlead.LeadSource ='HomeLane';
            newlead.Status='Fresh Lead';
            newLead.Sub_Status__c='New';
            newLead.City=ld.City;
            newLead.Account__c = ld.Account__c;
            newLead.Sign_Up_Source__c=ld.Sign_Up_Source__c;
            newLead.Property_Status__c=ld.Property_Status__c;
            newLead.Property_Config__c=ld.Property_Config__c;
            newLead.Kitchen__c =ld.Kitchen__c;
            newLead.Wardrobes__c = ld.Wardrobes__c;
            newLead.Entertainment_Unit__c= ld.Entertainment_Unit__c;
            newLead.Study_Table_Book_Shelf__c = ld.Study_Table_Book_Shelf__c;
            newLead.Crockery_Unit__c = ld.Crockery_Unit__c;
            newLead.Budget_Range__c=ld.Budget_Range__c;
            newLead.Property_Type__c=ld.Property_Type__c;
            newLead.Property__c =ld.Property__c;
            newLead.Purpose_of_Interiors__c=ld.Purpose_of_Interiors__c;
           
            newLead.Possession_Date__c=ld.Possession_Date__c;
        }
        return newLead;
    }
    
}