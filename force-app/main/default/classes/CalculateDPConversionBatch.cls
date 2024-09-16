global class CalculateDPConversionBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([select Id,Name,Batch_Job_Execute_Time__c,Email__c, Active_in_Showroom__c,
X0_4_Opportunities__c,
OverLoaded__c,
X4_8_Opportunities__c, 
X8_Opportunities__c,
X0_4_Won_Opportunities__c,
X4_8_Won_Opportunities__c, DP_Conversion__c,Average_Meetings__c,N_1_Average_Meetings__c,N_2_Average_Meetings__c,
X8_Won_Opportunities__c, Workload_10_40__c, X10_40_Workload_Amount__c, X50_100_Projects__c, Available_at_Showroom__c From Interior_Designer__c]);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        // set to collect number of interior designers
        Set<Id> setIDP = new Set<Id>();
        // DP and SSV Opportunity
        Map<Id,List<Opportunity>> mapDPOpportunity = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> mapSSVOpportunity = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> mapDPWonOpportunity = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> mapSSVWonOpportunity = new Map<Id,List<Opportunity>>();
        // 10 to 40 Opportunity
        Map<Id,List<Opportunity>> map10to40Opportunity = new Map<Id,List<Opportunity>>();
        // 0-4, 4-8 and 8+ map variables
        Map<Id,List<Opportunity>> map0to4Opportunity = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> map4to8Opportunity = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> map8PlusOpportunity = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> mapOpportunity = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> map0to4WonOpportunity = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> map4to8WonOpportunity = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> map8PlusWonOpportunity = new Map<Id,List<Opportunity>>();
        
        Map<Id,List<Opportunity>> intOppMap = new Map<Id,List<Opportunity>>();
        List<Opportunity> OppList = new List<Opportunity>();   
     
        Map<Id,Map<Id,List<Opportunity>>> mapDPPropertyOpp = new Map<Id,Map<Id,List<Opportunity>>>();
        // to map showroom
        Map<Id,Set<Id>> mapShowroomDP = new Map<Id,Set<Id>>();
        Map<Id,String> mapPropertyIdName = new Map<Id,String>();
        // to update DP's
        List<Interior_Designer__c> listDPUpdateDate = new List<Interior_Designer__c>();
        // to update SSV's
        List<Master__c> listSSVUpdate = new List<Master__c>();
        // DP Showroom
        Map<Id,Set<String>> mapDPShowroom = new Map<Id,Set<String>>();
        List<Interior_Designer__c> interiorDesignerListtoUpdate = new List<Interior_Designer__c>();
        // 0 to 10 workload to update
        Map<Id,Interior_Designer__c> workload0to10toUpdate = new Map<Id,Interior_Designer__c>();
        Map<Id,Decimal> mapAmountUpdate = new Map<Id,Decimal>();
        // 50-100 projects
        Map<Id,List<Opportunity>> map50100Opportunity = new Map<Id,List<Opportunity>>();
        // 0 to 10 workload
        Map<Id,List<Opportunity>> workload0to10 = new Map<Id,List<Opportunity>>();  
        
        List<Boolean> flagList = new List<Boolean>();
        Set<Id> intId = new Set<Id>();
        // for DP's more than 10 opps
        List<Interior_Designer__c> moreThan10Opps = new List<Interior_Designer__c>();
        // marks active showroom as true
        Map<Id,Interior_Designer__c> inteMapTrue = new Map<Id,Interior_Designer__c>();
        // marks active showroom as false
        Map<Id,Interior_Designer__c> inteMapFalse = new Map<Id,Interior_Designer__c>();
        Map<Id,Datetime > lastOppMetMap = new Map<Id,Datetime >();
        Map<Id,Datetime > firstOppMetMap = new Map<Id,Datetime >();
        Boolean flag = false;
        
        Map<Id,Decimal> n3MonthsTatAverage = new Map<Id,Decimal>();
        
        Map<id,Decimal> decimalAmount = new Map<Id,Decimal>();
       
        for(sObject obj : scope){
            setIDP.add(obj.Id);
        }
        List<Interior_Designer__c> allIntDesigner = (List<sObject>)(scope);
        Map<Id,Interior_Designer__c> allIntDesignerMap = new Map<Id,Interior_Designer__c>();
        for(Interior_Designer__c dp : allIntDesigner) {
            allIntDesignerMap.put(dp.Id,dp);
        }
        
        DateTime nextFire;
        try {
            CronTrigger cron = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType, TimesTriggered, NextFireTime, PreviousFireTime, StartTime, EndTime  FROM CronTrigger where CronJobDetail.name = 'Hourly DP Batch Run'];
            nextFire = cron.PreviousFireTime;
        }
        catch(Exception e) {}
     
         // Stack_DP_Rank__c is a custom setting
        Stack_DP_Rank__c stack = Stack_DP_Rank__c.getValues('Stack DP');
        Date d = stack.Date__c;
     
        for(AggregateResult ar : [select Interior_Design_Partner__c, AVG(Quote_Sent_TAT__c) from Opportunity where (Time_of_Actual_Appointment_Start__c >=: Date.Today().addMonths(-3) and Time_of_Actual_Appointment_Start__c <=: Date.Today()) and test_flag__c = false group by Interior_Design_Partner__c]) {
            n3MonthsTatAverage.put((Id)ar.get('Interior_Design_Partner__c'),(Decimal) ar.get('expr0'));
        }
        System.debug('*******n3MonthsTatAverage  '+n3MonthsTatAverage);
        
        Decimal amount = 0;
        for(Opportunity obj : [Select Id,Property_Name__c,Interior_Design_Partner__r.DP_Conversion__c, Interior_Design_Partner__r.N_1_DP_Conversion__c, Interior_Design_Partner__r.N_2_DP_Conversion__c, Appointment_Venue_Square__r.Showroom_Conversion__c, Appointment_Venue_Square__r.N_1_Showroom_Conversion__c, Appointment_Venue_Square__r.N_2_Showroom_Conversion__c, X50_100__c,X10_40_On_Hold__c,Order_Closed__c,Order_Book_Date__c,Amount,New_Opportunity_Status__c,Interior_Design_Partner__r.Email__c,StageName,Property_Name__r.Name,Name,CreatedDate,Time_of_Actual_Appointment_Start__c,Interior_Design_Partner__c,New_Opportunity_Stage__c,Appointment_Venue_Square__c,Appointment_Venue_Square__r.Name, Interior_Design_Partner__r.Active_in_Showroom__c, Interior_Design_Partner__r.X0_4_Opportunities__c, Interior_Design_Partner__r.OverLoaded__c,Interior_Design_Partner__r.X4_8_Opportunities__c, Interior_Design_Partner__r.X8_Opportunities__c,Interior_Design_Partner__r.X0_4_Won_Opportunities__c,Interior_Design_Partner__r.X4_8_Won_Opportunities__c,Interior_Design_Partner__r.X8_Won_Opportunities__c From Opportunity Where (Interior_Design_Partner__c IN : setIDP and CreatedDate >=: d and Test_Flag__c = false) ORDER BY Time_of_Actual_Appointment_Start__c DESC]){
            if(intOppMap.get(obj.Interior_Design_Partner__c) !=null) {
                List<Opportunity> intOppList = intOppMap.get(obj.Interior_Design_Partner__c);
                intOppList.add(obj);
                intOppMap.put(obj.Interior_Design_Partner__c,intOppList);
            }
            else {
                List<Opportunity> intOppList = new List<Opportunity>();
                intOppList.add(obj);
                intOppMap.put(obj.Interior_Design_Partner__c,intOppList);
            } 
            
            if(obj.Interior_Design_Partner__c != null) {
                OppList.add(obj);
            }
            
            
            if(obj.X50_100__c == true) {
             if(map50100Opportunity.get(obj.Interior_Design_Partner__c) !=null ){
                List<Opportunity> lst = map50100Opportunity.get(obj.Interior_Design_Partner__c);
                lst.add(obj);
                map50100Opportunity.put(obj.Interior_Design_Partner__c,lst);               
            }else{
                List<Opportunity> lst = new List<Opportunity>();
                lst.add(obj);
                map50100Opportunity.put(obj.Interior_Design_Partner__c,lst);
                
            }
            }
            
            mapPropertyIdName.put(obj.Property_Name__c,obj.Property_Name__r.Name);
            if((obj.StageName == 'Payment Stage A Reached' || obj.StageName == '10% Payment Collected' || obj.StageName == 'D1 Initiated' || obj.StageName == 'D2 Initiated' || obj.StageName == 'D3 Initiated' ) && obj.X10_40_On_Hold__c == false){
                
                 if(map10to40Opportunity.get(obj.Interior_Design_Partner__c) !=null){
                List<Opportunity> lstDpOpp = map10to40Opportunity.get(obj.Interior_Design_Partner__c);
                lstDpOpp.add(obj);
                    map10to40Opportunity.put(obj.Interior_Design_Partner__c,lstDpOpp);
                }else{
                    List<Opportunity> lstDpOpp = new List<Opportunity>();
                    lstDpOpp.add(obj);
                        map10to40Opportunity.put(obj.Interior_Design_Partner__c,lstDpOpp);
                }
            }
            
            if(mapDPOpportunity.get(obj.Interior_Design_Partner__c) !=null){
                List<Opportunity> lstDpOpp = mapDPOpportunity.get(obj.Interior_Design_Partner__c);
                lstDpOpp.add(obj);
                    mapDPOpportunity.put(obj.Interior_Design_Partner__c,lstDpOpp);
            }else{
                List<Opportunity> lstDpOpp = new List<Opportunity>();
                lstDpOpp.add(obj);
                    mapDPOpportunity.put(obj.Interior_Design_Partner__c,lstDpOpp);
            }
            
             if(mapSSVOpportunity.get(obj.Appointment_Venue_Square__c) !=null){
                List<Opportunity> lstDpOpp = mapSSVOpportunity.get(obj.Appointment_Venue_Square__c);
                  lstDpOpp.add(obj);
                    mapSSVOpportunity.put(obj.Appointment_Venue_Square__c,lstDpOpp);
                    
            }else{
                List<Opportunity> lstDpOpp = new List<Opportunity>();
                lstDpOpp.add(obj);
                    mapSSVOpportunity.put(obj.Appointment_Venue_Square__c,lstDpOpp);
            }            
            
            
            if(mapShowroomDP.get(obj.Appointment_Venue_Square__c) !=null){
                Set<Id> setDpOpp = mapShowroomDP.get(obj.Appointment_Venue_Square__c);
                setDpOpp.add(obj.Interior_Design_Partner__c);
                    mapShowroomDP.put(obj.Appointment_Venue_Square__c,setDpOpp);
            }else{
                Set<Id> setDpOpp = new Set<Id>();
                setDpOpp.add(obj.Interior_Design_Partner__c);
                    mapShowroomDP.put(obj.Appointment_Venue_Square__c,setDpOpp);
            }
         if(obj.New_Opportunity_Stage__c == 'Won'){
            if(mapDPPropertyOpp.get(obj.Interior_Design_Partner__c) !=null){
                Map<Id,List<Opportunity>> mapProperyOpp = mapDPPropertyOpp.get(obj.Interior_Design_Partner__c);
                if(mapProperyOpp.get(obj.Property_Name__c) != null){
                    List<Opportunity> lstOpp = mapProperyOpp.get(obj.Property_Name__c);
                    lstOpp.add(obj);
                    mapProperyOpp.put(obj.Property_Name__c,lstOpp);
                }
                else{
                    List<Opportunity> lstOpp = new List<Opportunity>();
                    lstOpp.add(obj);
                    mapProperyOpp.put(obj.Property_Name__c,lstOpp);
                }
                mapDPPropertyOpp.put(obj.Interior_Design_Partner__c,mapProperyOpp);
            }else{
                Map<Id,List<Opportunity>> mapProperyOpp = new Map<Id,List<Opportunity>>();
                List<Opportunity> lstOpp = new List<Opportunity>();
                    lstOpp.add(obj);
                    mapProperyOpp.put(obj.Property_Name__c,lstOpp);
                mapDPPropertyOpp.put(obj.Interior_Design_Partner__c,mapProperyOpp);
            }
             if(mapDPWonOpportunity.get(obj.Interior_Design_Partner__c) !=null){
                List<Opportunity> lstDpOpp = mapDPWonOpportunity.get(obj.Interior_Design_Partner__c);
                lstDpOpp.add(obj);
                    mapDPWonOpportunity.put(obj.Interior_Design_Partner__c,lstDpOpp);
            }else{
                List<Opportunity> lstDpOpp = new List<Opportunity>();
                lstDpOpp.add(obj);
                    mapDPWonOpportunity.put(obj.Interior_Design_Partner__c,lstDpOpp);
            }   
         }
         
       
            
            if(mapDPShowroom.get(obj.Interior_Design_Partner__c) !=null){
                    Set<String> setDpOpp = mapDPShowroom.get(obj.Interior_Design_Partner__c);
                    setDpOpp.add(obj.Appointment_Venue_Square__r.Name);
                        mapDPShowroom.put(obj.Interior_Design_Partner__c,setDpOpp);
                }else{
                    Set<String> setDpOpp = new Set<String>();
                    setDpOpp.add(obj.Appointment_Venue_Square__r.Name);
                        mapDPShowroom.put(obj.Interior_Design_Partner__c,setDpOpp);
                }          
            
        
        if(obj.New_Opportunity_Stage__c == 'Won'){
             if(mapSSVWonOpportunity.get(obj.Appointment_Venue_Square__c) !=null){
                List<Opportunity> lstDpOpp = mapSSVWonOpportunity.get(obj.Appointment_Venue_Square__c);
                lstDpOpp.add(obj);
                    mapSSVWonOpportunity.put(obj.Appointment_Venue_Square__c,lstDpOpp);
            }else{
                List<Opportunity> lstDpOpp = new List<Opportunity>();
                lstDpOpp.add(obj);
                    mapSSVWonOpportunity.put(obj.Appointment_Venue_Square__c,lstDpOpp);
            }   
         }
         
         /***************************************************************************************/
         if(obj.Amount >0 && obj.Amount <=400000) {
             if(mapOpportunity.get(obj.Interior_Design_Partner__c) !=null && map0to4Opportunity.get(obj.Interior_Design_Partner__c) != null){
                List<Opportunity> lst0to4 = mapOpportunity.get(obj.Interior_Design_Partner__c);
                lst0to4.add(obj);
                mapOpportunity.put(obj.Interior_Design_Partner__c,lst0to4 );
                
                List<Opportunity> lst0to41 = map0to4Opportunity.get(obj.Interior_Design_Partner__c);
                lst0to41.add(obj);
                map0to4Opportunity.put(obj.Interior_Design_Partner__c,lst0to41 );
            }else{
                List<Opportunity> lst0to4 = new List<Opportunity>();
                lst0to4 .add(obj);
                mapOpportunity.put(obj.Interior_Design_Partner__c,lst0to4 );
                
                List<Opportunity> lst0to41 = new List<Opportunity>();
                lst0to41.add(obj);
                map0to4Opportunity.put(obj.Interior_Design_Partner__c,lst0to41);
            }
          
            if(obj.New_Opportunity_Stage__c == 'Won') {
                if(mapOpportunity.get(obj.Interior_Design_Partner__c) !=null && map0to4WonOpportunity.get(obj.Interior_Design_Partner__c) != null){
                List<Opportunity> lst0to4Won = mapOpportunity.get(obj.Interior_Design_Partner__c);
                lst0to4Won.add(obj);
                mapOpportunity.put(obj.Interior_Design_Partner__c,lst0to4Won);
                    
                List<Opportunity> lst0to4Won1 = map0to4WonOpportunity.get(obj.Interior_Design_Partner__c);
                lst0to4Won1.add(obj);
                map0to4WonOpportunity.put(obj.Interior_Design_Partner__c,lst0to4Won1);
                }else{
                List<Opportunity> lst0to4Won = new List<Opportunity>();
                lst0to4Won.add(obj);
                mapOpportunity.put(obj.Interior_Design_Partner__c,lst0to4Won);
                
                List<Opportunity> lst0to4Won1 = new List<Opportunity>();
                lst0to4Won1.add(obj);
                map0to4WonOpportunity.put(obj.Interior_Design_Partner__c,lst0to4Won1);
                }
            }
         }
        
         
         if(obj.Amount >400000 && obj.Amount <=800000 ) {
             if(mapOpportunity.get(obj.Interior_Design_Partner__c) != null && map4to8Opportunity.get(obj.Interior_Design_Partner__c) != null){
                List<Opportunity> lst4to8 = mapOpportunity.get(obj.Interior_Design_Partner__c);
                lst4to8.add(obj);
                mapOpportunity.put(obj.Interior_Design_Partner__c,lst4to8);
                
                List<Opportunity> lst4to81 = map4to8Opportunity.get(obj.Interior_Design_Partner__c);
                lst4to81.add(obj);
                map4to8Opportunity.put(obj.Interior_Design_Partner__c,lst4to81);
            }else{
                List<Opportunity> lst4to8 = new List<Opportunity>();
                lst4to8.add(obj);
                mapOpportunity.put(obj.Interior_Design_Partner__c,lst4to8);
                
                List<Opportunity> lst4to81 = new List<Opportunity>();
                lst4to81.add(obj);
                map4to8Opportunity.put(obj.Interior_Design_Partner__c,lst4to81);
            }
            
            if(obj.New_Opportunity_Stage__c == 'Won') {
              if(mapOpportunity.get(obj.Interior_Design_Partner__c) !=null && map4to8WonOpportunity.get(obj.Interior_Design_Partner__c) != null){
                List<Opportunity> lst4to8Won = mapOpportunity.get(obj.Interior_Design_Partner__c);
                lst4to8Won.add(obj);
                mapOpportunity.put(obj.Interior_Design_Partner__c,lst4to8Won);
                
                List<Opportunity> lst4to8Won1 = map4to8WonOpportunity.get(obj.Interior_Design_Partner__c);
                lst4to8Won1.add(obj);
                map4to8WonOpportunity.put(obj.Interior_Design_Partner__c,lst4to8Won1);
            }else{
                List<Opportunity> lst4to8Won = new List<Opportunity>();
                lst4to8Won.add(obj);
                mapOpportunity.put(obj.Interior_Design_Partner__c,lst4to8Won);
                
                List<Opportunity> lst4to8Won1 = new List<Opportunity>();
                lst4to8Won1.add(obj);
                map4to8WonOpportunity.put(obj.Interior_Design_Partner__c,lst4to8Won1);
            }
            }
         }
         
          
         if(obj.Amount >800000) {
             if(mapOpportunity.get(obj.Interior_Design_Partner__c) !=null && map8PlusOpportunity.get(obj.Interior_Design_Partner__c) != null){
                List<Opportunity> lst8Plus = mapOpportunity.get(obj.Interior_Design_Partner__c);
                lst8Plus.add(obj);
                mapOpportunity.put(obj.Interior_Design_Partner__c,lst8Plus);
                
                List<Opportunity> lst8Plus1 = map8PlusOpportunity.get(obj.Interior_Design_Partner__c);
                lst8Plus1.add(obj);
                map8PlusOpportunity.put(obj.Interior_Design_Partner__c,lst8Plus1);
            }else{
                List<Opportunity> lst8Plus = new List<Opportunity>();
                lst8Plus.add(obj);
                mapOpportunity.put(obj.Interior_Design_Partner__c,lst8Plus);
                
                List<Opportunity> lst8Plus1 = new List<Opportunity>();
                lst8Plus1.add(obj);
                map8PlusOpportunity.put(obj.Interior_Design_Partner__c,lst8Plus1);    
            }
            if(obj.New_Opportunity_Stage__c == 'Won') {
              if(mapOpportunity.get(obj.Interior_Design_Partner__c) !=null && map8PlusWonOpportunity.get(obj.Interior_Design_Partner__c) != null){
                List<Opportunity> lst8PlusWon = mapOpportunity.get(obj.Interior_Design_Partner__c);
                lst8PlusWon.add(obj);
                mapOpportunity.put(obj.Interior_Design_Partner__c,lst8PlusWon);
                
                List<Opportunity> lst8PlusWon1 = map8PlusWonOpportunity.get(obj.Interior_Design_Partner__c);
                lst8PlusWon1.add(obj);
                map8PlusWonOpportunity.put(obj.Interior_Design_Partner__c,lst8PlusWon1);
                }else{
                List<Opportunity> lst8PlusWon = new List<Opportunity>();
                lst8PlusWon.add(obj);
                mapOpportunity.put(obj.Interior_Design_Partner__c,lst8PlusWon);
                
                List<Opportunity> lst8PlusWon1 = new List<Opportunity>();
                lst8PlusWon1.add(obj);
                map8PlusWonOpportunity.put(obj.Interior_Design_Partner__c,lst8PlusWon1);
                }
            }
         }
         
                     
        } 

       /**************************** FOR LOOP END ****************************/
       
        if(!intOppMap.isEmpty()) {
            if(intOppMap.keyset() != null) {
                for(Id objId : intOppMap.keyset()) {                   
                    if(intOppMap.get(objId).size() > 10) {
                        flag = true;
                        flagList.add(flag);
                        intId.add(objId);
                    }
                }
           
            if(!OppList.isEmpty()) {
                for(Opportunity opp : OppList) {
                    Interior_Designer__c inte = new Interior_Designer__c();
                    inte.Id = opp.Interior_Design_Partner__c;
                  
                    if(opp.Time_of_Actual_Appointment_Start__c != null && (opp.Time_of_Actual_Appointment_Start__c >= Date.Today() - 14 && opp.Time_of_Actual_Appointment_Start__c <= Date.Today())) {                    
                        inte.Active_in_Showroom__c = true;
                      inteMapTrue.put(opp.Interior_Design_Partner__c,inte);
                      
                    }
                  
                    else if(opp.Interior_Design_Partner__r.OverLoaded__c == true) {
                        inte.Active_in_Showroom__c = true;
                      inteMapTrue.put(opp.Interior_Design_Partner__c,inte);
                      
                    }  
                  
                    else {
                        inte.Active_in_Showroom__c = false;
                       inteMapFalse.put(opp.Interior_Design_Partner__c,inte);
                       
                    }
                    if(opp.New_Opportunity_Status__c == '1.Active' || opp.New_Opportunity_Status__c == '3.Followup' || opp.New_Opportunity_Status__c == '4.Overdue' || opp.New_Opportunity_Status__c == '5.Pipeline') {
                       if(workload0to10.get(opp.Interior_Design_Partner__c) !=null ){
                            List<Opportunity> workload0to10List = workload0to10.get(opp.Interior_Design_Partner__c);
                            workload0to10List .add(opp);
                            workload0to10.put(opp.Interior_Design_Partner__c,workload0to10List );                            
                            
                        }
                        else{
                            List<Opportunity> workload0to10List = new List<Opportunity>();
                            workload0to10List .add(opp);
                            workload0to10.put(opp.Interior_Design_Partner__c,workload0to10List );                               
                        }                       
                    }                                       
                }                 
            }            
            }
            
        }         
        
        for(List<Opportunity> oppList2 : map10to40Opportunity.values()) {
            Decimal d5 = 0;
            for(Opportunity opp : oppList2) {
                d5 = d5 + opp.AMount;
                decimalAmount.put(opp.Interior_Design_Partner__c, d5);
            }
        }
         
         // Calculation of last opportunity met on
         for(List<Opportunity> oppList2 : mapDPOpportunity.values()) {             
              Datetime dat = oppList2[0].Time_of_Actual_Appointment_Start__c; 
              lastOppMetMap.put(oppList2[0].Interior_Design_Partner__c,dat); 
         }
        
         // Calculation of first opportunity met on
         for(List<Opportunity> oppList2 : mapDPOpportunity.values()) {             
              Datetime dat = oppList2[oppList2.size() - 1].Time_of_Actual_Appointment_Start__c; 
              firstOppMetMap.put(oppList2[oppList2.size() - 1].Interior_Design_Partner__c,dat); 
         }
      
        
       /***************************************************************************************/ 
        
            for(Interior_Designer__c objIdp : allIntDesigner) {
                objIdp.Batch_Job_Execute_Time__c = nextFire; 
                if(mapDPWonOpportunity.get(objIdp.Id) != null){
                    objIdp.Total_Wins__c = mapDPWonOpportunity.get(objIdp.Id).size();
                }
                else {
                    objIdp.Total_Wins__c = 0;
                }
                if(map10to40Opportunity.get(objIdp.Id) != null){
                    objIdp.Workload_10_40__c = map10to40Opportunity.get(objIdp.Id).size();
                }
                else {
                    objIdp.Workload_10_40__c = 0;
                }
                if(map50100Opportunity.get(objIdp.Id) != null) {                   
                    objIdp.X50_100_Projects__c = map50100Opportunity.get(objIdp.Id).size();                       
                }
                else {
                    objIdp.X50_100_Projects__c = 0;
                }
              
                System.debug('---mapDPPropertyOpp------'+mapDPPropertyOpp);
                if(mapDPPropertyOpp.get(objIdp.Id) != null){
                    Map<Id,List<Opportunity>> mapProperyOpp = mapDPPropertyOpp.get(objIdp.Id);
                    String strPropertyData = '';
                    for(Id objPropId : mapProperyOpp.keySet()){
                        List<Opportunity> lstOpp = mapProperyOpp.get(objPropId);
                        if(strPropertyData =='')
                            strPropertyData = objPropId+'<@>'+mapPropertyIdName.get(objPropId)+'<@>'+lstOpp.size();
                        else
                            strPropertyData = strPropertyData+','+objPropId+'<@>'+mapPropertyIdName.get(objPropId)+'<@>'+lstOpp.size();
                    }
                    objIdp.Property_Exp_Data__c = strPropertyData;
                }
                if(mapDPOpportunity.get(objIdp.Id) != null){
                    objIdp.Total_Opportunities__c = mapDPOpportunity.get(objIdp.Id).size();
                    System.debug('---Last Date------'+mapDPOpportunity.get(objIdp.Id)[mapDPOpportunity.get(objIdp.Id).size()-1].CreatedDate+'----First Crested Date-----'+mapDPOpportunity.get(objIdp.Id)[0].CreatedDate);                    
                    Decimal noDays = (Date.valueOf(mapDPOpportunity.get(objIdp.Id)[0].CreatedDate)).daysBetween(Date.valueOf(mapDPOpportunity.get(objIdp.Id)[mapDPOpportunity.get(objIdp.Id).size()-1].CreatedDate));
                    try{
                        Decimal differsDays = mapDPOpportunity.get(objIdp.Id).size()*30;
                        Decimal avgOpp = differsDays/noDays;
                        System.debug('-----differsDays----'+differsDays+'-----Total Opp Size----'+mapDPOpportunity.get(objIdp.Id).size()+'-----Total Opp Size----'+mapDPOpportunity.get(objIdp.Id).size()/noDays+'-----noDays----'+noDays+'----avgOpp-----ss'+avgOpp+'----objId-----'+objIdp.Id);
                        objIdp.Avg_Opportunites_Month__c = avgOpp;
                    }catch(exception exp){
                        system.debug('----Exception In-----'+exp.getMessage());
                        
                    }
                    
                }
                if(mapDPOpportunity.get(objIdp.Id) == null) {
                    objIdp.Total_Opportunities__c = 0;
                }
                if(mapDPShowroom.get(objIdp.Id) !=null){
                  String showroomName = '';
                    for(String objStr : mapDPShowroom.get(objIdp.Id)){
                    if(objStr != null) {
                      if(showroomName == '') {
                       System.debug('#####showroomName LOOP 1  '+showroomName);
                          showroomName = objStr;
                          }
                      else {
                      System.debug('#####showroomName LOOP 2  '+showroomName);
                     
                        showroomName = showroomName+';'+objStr;
                        
                        }  
                        }
                    }
                    objIdp.Available_at_Showroom__c = showroomName; 
                }  
                
               // updation of 0-4, 4-8,8+ opp
               if(map0to4Opportunity.get(objIdp.Id) != null){
                    objIdp.X0_4_Opportunities__c = map0to4Opportunity.get(objIdp.Id).size();
                }
                if(map0to4WonOpportunity.get(objIdp.Id) != null) {                   
                    objIdp.X0_4_Won_Opportunities__c = map0to4WonOpportunity.get(objIdp.Id).size();                       
                }
                if(map4to8Opportunity.get(objIdp.Id) != null){
                    objIdp.X4_8_Opportunities__c = map4to8Opportunity.get(objIdp.Id).size();
                }
                if(map4to8WonOpportunity.get(objIdp.Id) != null) {                   
                    objIdp.X4_8_Won_Opportunities__c = map4to8WonOpportunity.get(objIdp.Id).size();                       
                }
                if(map8PlusOpportunity.get(objIdp.Id) != null){
                    objIdp.X8_Opportunities__c = map8PlusOpportunity.get(objIdp.Id).size();
                }
                if(map8PlusWonOpportunity.get(objIdp.Id) != null) {                   
                    objIdp.X8_Won_Opportunities__c = map8PlusWonOpportunity.get(objIdp.Id).size();                       
                }
          
                if(map0to4Opportunity.get(objIdp.Id) == null) {
                    objIdp.X0_4_Opportunities__c = 0;
                }
                
                if(map0to4WonOpportunity.get(objIdp.Id) == null) {
                    objIdp.X0_4_Won_Opportunities__c = 0;
                } 
                
                if(map4to8Opportunity.get(objIdp.Id) == null) {
                    objIdp.X4_8_Opportunities__c = 0;
                }
                
                if(map4to8WonOpportunity.get(objIdp.Id) == null) {
                    objIdp.X4_8_Won_Opportunities__c = 0;
                }
                
                if(map8PlusOpportunity.get(objIdp.Id) == null) {
                    objIdp.X8_Opportunities__c = 0;
                }
                
                if(map8PlusWonOpportunity.get(objIdp.Id) == null) {
                    objIdp.X8_Won_Opportunities__c = 0;
                }
                         
                // updation of workload 0-10
                if(workload0to10.get(objIdp.Id) != null){
                     objIdp.X0_10_Workload__c = workload0to10.get(objIdp.Id).size();
                 }
                 else {
                     objIdp.X0_10_Workload__c = 0;
                 }
                 // active in showroom true
                 if(intemapTrue.get(objIdp.Id) != null){
                     objIdp.Active_in_Showroom__c = true;
                 } 
                 else {
                     objIdp.Active_in_Showroom__c = false;
                 }
                // add total amount values
                if(decimalAmount.get(objIdp.Id) != null){
                     objIdp.X10_40_Workload_Amount__c = decimalAmount.get(objIdp.Id);
                 }
                 else {
                     objIdp.X10_40_Workload_Amount__c = 0;
                 }
                 // last opportunity met on
                 if(lastOppMetMap.get(objIdp.Id) != null) {
                     objIdp.Last_Opportunity_Met_On__c = lastOppMetMap.get(objIdp.Id);
                 } 
                 else {
                     objIdp.Last_Opportunity_Met_On__c = null;
                 }
                 // first opportunity met on
                 if(firstOppMetMap.get(objIdp.Id) != null) {
                     objIdp.First_Opp_Meeting_Date__c = firstOppMetMap.get(objIdp.Id);
                 } 
                 else {
                     objIdp.First_Opp_Meeting_Date__c = null;
                 }
                // 3 months TAT calculation
                if(n3MonthsTatAverage.get(objIdp.Id) != null) {
                    objIdp.DP_Quote_TAT__c = n3MonthsTatAverage.get(objIdp.Id);
                }
                else {
                    objIdp.DP_Quote_TAT__c = 0;
                } 
              
            listDPUpdateDate.add(objIdp);                   
           } 
     
        if(!mapSSVOpportunity.isEmpty()){
            for(Id objId :mapSSVOpportunity.keyset()){
                if(objId != null) {
                     Master__c objSSV = new Master__c();
                     objSSV.Id = objId;
                        Decimal noDays = (Date.valueOf(mapSSVOpportunity.get(objId)[0].CreatedDate)).daysBetween(Date.valueOf(mapSSVOpportunity.get(objId)[mapSSVOpportunity.get(objId).size()-1].CreatedDate));
                        try{
                            Decimal avgOpp = mapSSVOpportunity.get(objId).size()*30;
                            System.debug('------noDays*mapShowroomDP.get(objId).Size()---  '+(noDays*mapShowroomDP.get(objId).Size()));
                            if(noDays*mapShowroomDP.get(objId).Size() != 0) {
                            avgOpp = avgOpp/(noDays*mapShowroomDP.get(objId).Size());
                            }
                            objSSV.Avg_Opportunites_Month__c = avgOpp;
                        }catch(exception exp){
                            system.debug('----Exception In---2---'+exp.getMessage());
                        }
                    if(mapSSVWonOpportunity.get(objId) != null && mapSSVOpportunity.get(objId) != null){
                        try{
                         objSSV.Avg_Conversion__c = (mapSSVWonOpportunity.get(objId).size()*100)/mapSSVOpportunity.get(objId).size();
                         objSSV.Total_Opportunities__c = mapSSVOpportunity.get(objId).size();
                         objSSV.Total_Won_Opportunity__c = mapSSVWonOpportunity.get(objId).size();
                        }catch(Exception exp){
                            system.debug('----Exception In---3---'+exp.getMessage());
                        }
                    }
                    if(mapShowroomDP.get(objId) != null){
                        objSSV.Total_DP_With_Opportunity__c = mapShowroomDP.get(objId).Size();
                    }
                    
                    listSSVUpdate.add(objSSV);
                }
            }
        }
        
      
        
    if(listDPUpdateDate != null) {
      if(!Test.isRunningTest())
        Update listDPUpdateDate;
    }
    if(!listSSVUpdate.isEmpty()) {
     if(!Test.isRunningTest())
        Update listSSVUpdate;   
    }
   
   }
    
     
    global void finish(Database.BatchableContext BC){
       
    }

}