global class N2toN10CalcBatch implements Database.Batchable<sObject>, Database.stateful {
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
        Map<Id,List<Opportunity>> mapSSVOpportunity = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> mapDPOpportunity = new Map<Id,List<Opportunity>>();
        List<Interior_Designer__c> allIntDesigner = (List<sObject>)(scope);
        Map<Id,Interior_Designer__c> allIntDesignerMap = new Map<Id,Interior_Designer__c>();
        for(Interior_Designer__c dp : allIntDesigner) {
            allIntDesignerMap.put(dp.Id,dp);
        }
        
        // set to collect number of interior designers
        Set<Id> setIDP = new Set<Id>();
        for(sObject obj : scope){
            setIDP.add(obj.Id);
        }
        // map for n-2 to n-8 opps for Master
        Map<Id,List<Opportunity>> n2Ton8MapMaster = new Map<Id,List<Opportunity>>();       
        // map for n-2 to n-8 WON opps for Master
        Map<Id,List<Opportunity>> n2Ton8MapMasterWon = new Map<Id,List<Opportunity>>();        
        // map for n-2 to n-8 opps for DP
        Map<Id,List<Opportunity>> n2Ton8MapDP = new Map<Id,List<Opportunity>>();       
        // map for n-2 to n-8 WON opps for DP
        Map<Id,List<Opportunity>> n2Ton8MapDPWon = new Map<Id,List<Opportunity>>();
        
       // map for n-3 to n-9 opps for Master
        Map<Id,List<Opportunity>> n3Ton9MapMaster = new Map<Id,List<Opportunity>>();       
        // map for n-3 to n-9 WON opps for Master
        Map<Id,List<Opportunity>> n3Ton9MapMasterWon = new Map<Id,List<Opportunity>>();        
        // map for n-3 to n-9 opps for DP
        Map<Id,List<Opportunity>> n3Ton9MapDP = new Map<Id,List<Opportunity>>();       
        // map for n-3 to n-9 WON opps for DP
        Map<Id,List<Opportunity>> n3Ton9MapDPWon = new Map<Id,List<Opportunity>>();
        
        // map for n-4 to n-10 opps for Master
        Map<Id,List<Opportunity>> n4Ton10MapMaster = new Map<Id,List<Opportunity>>();       
        // map for n-4 to n-10 WON opps for Master
        Map<Id,List<Opportunity>> n4Ton10MapMasterWon = new Map<Id,List<Opportunity>>();        
        // map for n-4 to n-10 opps for DP
        Map<Id,List<Opportunity>> n4Ton10MapDP = new Map<Id,List<Opportunity>>();       
        // map for n-4 to n-10 WON opps for DP
        Map<Id,List<Opportunity>> n4Ton10MapDPWon = new Map<Id,List<Opportunity>>();
        
          // N2 TO N8 DP TYPE
        Map<Id,Boolean> n2Ton8compareDPShowroom = new Map<Id,Boolean>();       
        
        // N3 TO N9 DP TYPE
        Map<Id,Boolean> n3Ton9compareDPShowroom = new Map<Id,Boolean>(); 
        
        // N4 TO N10 DP TYPE
        Map<Id,Boolean> n4Ton10compareDPShowroom = new Map<Id,Boolean>(); 
        
        Map<Id,Datetime > firstOppMetMap = new Map<Id,Datetime >();
         // to update DP's
        List<Interior_Designer__c> DPToUpdate = new List<Interior_Designer__c>();
        // to update Master
        List<Master__c> MasterToUpdate = new List<Master__c>();
        
        // map for Rookie
        Map<Id,List<Opportunity>> RookieMap = new Map<Id,List<Opportunity>>();
         
        DateTime dtTime = System.now();
        Date dt = date.newinstance(dtTime.year(), dtTime.month(), dtTime.day());
        Date n2 = dt.addMonths(-1).toStartOfMonth()-1;
        Date n8 = dt.addMonths(-7).toStartOfMonth();
        Date n3 = dt.addMonths(-2).toStartOfMonth()-1;
        Date n9 = dt.addMonths(-8).toStartOfMonth();
        Date n4 = dt.addMonths(-3).toStartOfMonth()-1;
        Date n10 = dt.addMonths(-9).toStartOfMonth();
        
        // Stack_DP_Rank__c is a custom setting
        Stack_DP_Rank__c stack = Stack_DP_Rank__c.getValues('Stack DP');
        Date d = stack.Date__c;
      //  System.debug('*******lstOpportunity  '+lstOpportunity.size());
        for(Opportunity obj : [Select Id,New_Opportunity_Stage__c,New_Opportunity_Status__c,Property_Name__c,Interior_Design_Partner__r.DP_Conversion__c, Interior_Design_Partner__r.N_1_DP_Conversion__c, Interior_Design_Partner__r.N_2_DP_Conversion__c, Appointment_Venue_Square__r.Showroom_Conversion__c, Appointment_Venue_Square__r.N_1_Showroom_Conversion__c, Appointment_Venue_Square__r.N_2_Showroom_Conversion__c, X50_100__c,X10_40_On_Hold__c,Order_Closed__c,Order_Book_Date__c,Amount,Opportunity_Status__c,Interior_Design_Partner__r.Email__c,StageName,Property_Name__r.Name,Name,CreatedDate,Time_of_Actual_Appointment_Start__c,Interior_Design_Partner__c,Opportunity_Stage__c,Appointment_Venue_Square__c,Appointment_Venue_Square__r.Name, Interior_Design_Partner__r.Active_in_Showroom__c, Interior_Design_Partner__r.X0_4_Opportunities__c, Interior_Design_Partner__r.OverLoaded__c,Interior_Design_Partner__r.X4_8_Opportunities__c, Interior_Design_Partner__r.X8_Opportunities__c,Interior_Design_Partner__r.X0_4_Won_Opportunities__c,Interior_Design_Partner__r.X4_8_Won_Opportunities__c,Interior_Design_Partner__r.X8_Won_Opportunities__c From Opportunity Where (Interior_Design_Partner__c IN : setIDP and CreatedDate >=: d and Test_Flag__c = false) ORDER BY Time_of_Actual_Appointment_Start__c DESC]) {
            if(obj.Time_of_Actual_Appointment_Start__c != null) {
             // FROM RANGE N2 TO N8
             if(obj.Time_of_Actual_Appointment_Start__c.date() <= n2 && obj.Time_of_Actual_Appointment_Start__c.date() >= n8) {
                   if(n2Ton8MapDP.get(obj.Interior_Design_Partner__c) !=null) {
                        List<Opportunity> n2Ton8OppList = n2Ton8MapDP.get(obj.Interior_Design_Partner__c);
                        n2Ton8OppList.add(obj);
                        n2Ton8MapDP.put(obj.Interior_Design_Partner__c,n2Ton8OppList);
                    }
                    else {
                        List<Opportunity> n2Ton8OppList = new List<Opportunity>();
                        n2Ton8OppList.add(obj);
                        n2Ton8MapDP.put(obj.Interior_Design_Partner__c,n2Ton8OppList);
                    } 
                    
                    if(n2Ton8MapMaster.get(obj.Appointment_Venue_Square__c) !=null) {
                        List<Opportunity> n2Ton8OppList = n2Ton8MapMaster.get(obj.Appointment_Venue_Square__c);
                        n2Ton8OppList.add(obj);
                        n2Ton8MapMaster.put(obj.Appointment_Venue_Square__c,n2Ton8OppList);
                    }
                    else {
                        List<Opportunity> n2Ton8OppList = new List<Opportunity>();
                        n2Ton8OppList.add(obj);
                        n2Ton8MapMaster.put(obj.Appointment_Venue_Square__c,n2Ton8OppList);
                    } 
                 
             
                 if(obj.New_Opportunity_Stage__c == 'Won' || obj.New_Opportunity_Status__c == '6.Won' || obj.Order_Closed__c == true) {
                      if(n2Ton8MapDPWon.get(obj.Interior_Design_Partner__c) !=null) {
                            List<Opportunity> n2Ton8OppList = n2Ton8MapDPWon.get(obj.Interior_Design_Partner__c);
                            n2Ton8OppList.add(obj);
                            n2Ton8MapDPWon.put(obj.Interior_Design_Partner__c,n2Ton8OppList);
                        }
                        else {
                            List<Opportunity> n2Ton8OppList = new List<Opportunity>();
                            n2Ton8OppList.add(obj);
                            n2Ton8MapDPWon.put(obj.Interior_Design_Partner__c,n2Ton8OppList);
                        } 
                        if(n2Ton8MapMasterWon.get(obj.Appointment_Venue_Square__c) !=null) {
                            List<Opportunity> n2Ton8OppList = n2Ton8MapMasterWon.get(obj.Appointment_Venue_Square__c);
                            n2Ton8OppList.add(obj);
                            n2Ton8MapMasterWon.put(obj.Appointment_Venue_Square__c,n2Ton8OppList);
                        }
                        else {
                            List<Opportunity> n2Ton8OppList = new List<Opportunity>();
                            n2Ton8OppList.add(obj);
                            n2Ton8MapMasterWon.put(obj.Appointment_Venue_Square__c,n2Ton8OppList);
                        } 
                 }
                 
                 if(obj.Interior_Design_Partner__c != null && obj.Appointment_Venue_Square__c != null) {
                     if(obj.Interior_Design_Partner__r.DP_Conversion__c > obj.Appointment_Venue_Square__r.Showroom_Conversion__c) {
                         n2Ton8compareDPShowroom.put(obj.Interior_Design_Partner__c, true);
                     }
                     if(obj.Interior_Design_Partner__r.DP_Conversion__c < obj.Appointment_Venue_Square__r.Showroom_Conversion__c) {
                         n2Ton8compareDPShowroom.put(obj.Interior_Design_Partner__c, false);
                     }
                 }    
             }
             
             // FROM RANGE N3 TO N9
             if(obj.Time_of_Actual_Appointment_Start__c.date() <= n3 && obj.Time_of_Actual_Appointment_Start__c.date() >= n9) {
                   if(n3Ton9MapDP.get(obj.Interior_Design_Partner__c) !=null) {
                        List<Opportunity> n3Ton9OppList = n3Ton9MapDP.get(obj.Interior_Design_Partner__c);
                        n3Ton9OppList.add(obj);
                        n3Ton9MapDP.put(obj.Interior_Design_Partner__c,n3Ton9OppList);
                    }
                    else {
                        List<Opportunity> n3Ton9OppList = new List<Opportunity>();
                        n3Ton9OppList.add(obj);
                        n3Ton9MapDP.put(obj.Interior_Design_Partner__c,n3Ton9OppList);
                    } 
                    
                    if(n3Ton9MapMaster.get(obj.Appointment_Venue_Square__c) !=null) {
                        List<Opportunity> n3Ton9OppList = n3Ton9MapMaster.get(obj.Appointment_Venue_Square__c);
                        n3Ton9OppList.add(obj);
                        n3Ton9MapMaster.put(obj.Appointment_Venue_Square__c,n3Ton9OppList);
                    }
                    else {
                        List<Opportunity> n3Ton9OppList = new List<Opportunity>();
                        n3Ton9OppList.add(obj);
                        n3Ton9MapMaster.put(obj.Appointment_Venue_Square__c,n3Ton9OppList);
                    } 
                 
             
                 if(obj.New_Opportunity_Stage__c == 'Won' || obj.New_Opportunity_Status__c == '6.Won' || obj.Order_Closed__c == true) {
                      if(n3Ton9MapDPWon.get(obj.Interior_Design_Partner__c) !=null) {
                            List<Opportunity> n3Ton9OppList = n3Ton9MapDPWon.get(obj.Interior_Design_Partner__c);
                            n3Ton9OppList.add(obj);
                            n3Ton9MapDPWon.put(obj.Interior_Design_Partner__c,n3Ton9OppList);
                        }
                        else {
                            List<Opportunity> n3Ton9OppList = new List<Opportunity>();
                            n3Ton9OppList.add(obj);
                            n3Ton9MapDPWon.put(obj.Interior_Design_Partner__c,n3Ton9OppList);
                        } 
                        if(n3Ton9MapMasterWon.get(obj.Appointment_Venue_Square__c) !=null) {
                            List<Opportunity> n3Ton9OppList = n3Ton9MapMasterWon.get(obj.Appointment_Venue_Square__c);
                            n3Ton9OppList.add(obj);
                            n3Ton9MapMasterWon.put(obj.Appointment_Venue_Square__c,n3Ton9OppList);
                        }
                        else {
                            List<Opportunity> n3Ton9OppList = new List<Opportunity>();
                            n3Ton9OppList.add(obj);
                            n3Ton9MapMasterWon.put(obj.Appointment_Venue_Square__c,n3Ton9OppList);
                        } 
                 }
                 
                 if(obj.Interior_Design_Partner__c != null && obj.Appointment_Venue_Square__c != null) {
                     if(obj.Interior_Design_Partner__r.N_1_DP_Conversion__c > obj.Appointment_Venue_Square__r.N_1_Showroom_Conversion__c) {
                         n3Ton9compareDPShowroom.put(obj.Interior_Design_Partner__c, true);
                     }
                     if(obj.Interior_Design_Partner__r.N_1_DP_Conversion__c < obj.Appointment_Venue_Square__r.N_1_Showroom_Conversion__c) {
                         n3Ton9compareDPShowroom.put(obj.Interior_Design_Partner__c, false);
                     }
                 }    
             }
             
             // FROM RANGE N4 TO N10
             if(obj.Time_of_Actual_Appointment_Start__c.date() <= n4 && obj.Time_of_Actual_Appointment_Start__c.date() >= n10) {
                   if(n4Ton10MapDP.get(obj.Interior_Design_Partner__c) !=null) {
                        List<Opportunity> n4Ton10OppList = n4Ton10MapDP.get(obj.Interior_Design_Partner__c);
                        n4Ton10OppList.add(obj);
                        n4Ton10MapDP.put(obj.Interior_Design_Partner__c,n4Ton10OppList);
                    }
                    else {
                        List<Opportunity> n4Ton10OppList = new List<Opportunity>();
                        n4Ton10OppList.add(obj);
                        n4Ton10MapDP.put(obj.Interior_Design_Partner__c,n4Ton10OppList);
                    } 
                    
                    if(n4Ton10MapMaster.get(obj.Appointment_Venue_Square__c) !=null) {
                        List<Opportunity> n4Ton10OppList = n4Ton10MapMaster.get(obj.Appointment_Venue_Square__c);
                        n4Ton10OppList.add(obj);
                        n4Ton10MapMaster.put(obj.Appointment_Venue_Square__c,n4Ton10OppList);
                    }
                    else {
                        List<Opportunity> n4Ton10OppList = new List<Opportunity>();
                        n4Ton10OppList.add(obj);
                        n4Ton10MapMaster.put(obj.Appointment_Venue_Square__c,n4Ton10OppList);
                    } 
                 
             
                 if(obj.New_Opportunity_Stage__c == 'Won' || obj.New_Opportunity_Status__c == '6.Won' || obj.Order_Closed__c == true) {
                      if(n4Ton10MapDPWon.get(obj.Interior_Design_Partner__c) !=null) {
                            List<Opportunity> n4Ton10OppList = n4Ton10MapDPWon.get(obj.Interior_Design_Partner__c);
                            n4Ton10OppList.add(obj);
                            n4Ton10MapDPWon.put(obj.Interior_Design_Partner__c,n4Ton10OppList);
                        }
                        else {
                            List<Opportunity> n4Ton10OppList = new List<Opportunity>();
                            n4Ton10OppList.add(obj);
                            n4Ton10MapDPWon.put(obj.Interior_Design_Partner__c,n4Ton10OppList);
                        } 
                        if(n4Ton10MapMasterWon.get(obj.Appointment_Venue_Square__c) !=null) {
                            List<Opportunity> n4Ton10OppList = n4Ton10MapMasterWon.get(obj.Appointment_Venue_Square__c);
                            n4Ton10OppList.add(obj);
                            n4Ton10MapMasterWon.put(obj.Appointment_Venue_Square__c,n4Ton10OppList);
                        }
                        else {
                            List<Opportunity> n4Ton10OppList = new List<Opportunity>();
                            n4Ton10OppList.add(obj);
                            n4Ton10MapMasterWon.put(obj.Appointment_Venue_Square__c,n4Ton10OppList);
                        } 
                 }
                 
                 if(obj.Interior_Design_Partner__c != null && obj.Appointment_Venue_Square__c != null) {
                     if(obj.Interior_Design_Partner__r.N_2_DP_Conversion__c > obj.Appointment_Venue_Square__r.N_2_Showroom_Conversion__c) {
                         n4Ton10compareDPShowroom.put(obj.Interior_Design_Partner__c, true);
                     }
                     if(obj.Interior_Design_Partner__r.N_2_DP_Conversion__c < obj.Appointment_Venue_Square__r.N_2_Showroom_Conversion__c) {
                         n4Ton10compareDPShowroom.put(obj.Interior_Design_Partner__c, false);
                     }
                 }    
             }
             
             if(obj.Time_of_Actual_Appointment_Start__c.date() <= n2) {
                 if(RookieMap.get(obj.Interior_Design_Partner__c) !=null) {
                        List<Opportunity> n4Ton10OppList1 = RookieMap.get(obj.Interior_Design_Partner__c);
                        n4Ton10OppList1.add(obj);
                        RookieMap.put(obj.Interior_Design_Partner__c,n4Ton10OppList1);
                    }
                    else {
                        List<Opportunity> n4Ton10OppList1 = new List<Opportunity>();
                        n4Ton10OppList1.add(obj);
                        RookieMap.put(obj.Interior_Design_Partner__c,n4Ton10OppList1);
                    } 
             }
             
         }
         
         // For Master Fields
         if(mapSSVOpportunity.get(obj.Appointment_Venue_Square__c) !=null){
                List<Opportunity> lstDpOpp = mapSSVOpportunity.get(obj.Appointment_Venue_Square__c);
                  lstDpOpp.add(obj);
                    mapSSVOpportunity.put(obj.Appointment_Venue_Square__c,lstDpOpp);
                    
            }else{
                List<Opportunity> lstDpOpp = new List<Opportunity>();
                lstDpOpp.add(obj);
                    mapSSVOpportunity.put(obj.Appointment_Venue_Square__c,lstDpOpp);
            } 
            
         // For DP 
         if(mapDPOpportunity.get(obj.Interior_Design_Partner__c) !=null){
                List<Opportunity> lstDpOpp = mapDPOpportunity.get(obj.Interior_Design_Partner__c);
                lstDpOpp.add(obj);
                    mapDPOpportunity.put(obj.Interior_Design_Partner__c,lstDpOpp);
            }else{
                List<Opportunity> lstDpOpp = new List<Opportunity>();
                lstDpOpp.add(obj);
                    mapDPOpportunity.put(obj.Interior_Design_Partner__c,lstDpOpp);
            }  
        }
        
        for(List<Opportunity> oppList2 : mapDPOpportunity.values()) {             
              Datetime dat = oppList2[oppList2.size() - 1].Time_of_Actual_Appointment_Start__c; 
              firstOppMetMap.put(oppList2[oppList2.size() - 1].Interior_Design_Partner__c,dat); 
         }        
         
        Decimal days30 = 30;
        for(Interior_Designer__c objIdp : allIntDesigner) {
            // N2 TO N8 TOTAL MONTHS 
            if(firstOppMetMap.get(objIdp.Id) <= n2 && firstOppMetMap.get(objIdp.Id) >= n8) {                
                 objIdp.Total_Months__c = Date.valueOf(firstOppMetMap.get(objIdp.Id)).daysBetween(n2) / days30.setScale(2);                             
              }  
              else if(firstOppMetMap.get(objIdp.Id) < n8) {
                 objIdp.Total_Months__c = n8.daysBetween(n2) / days30.setScale(2);
              }  
              else {
                  objIdp.Total_Months__c = 0;
              }                
             
             // FROM N2 TO N8 RANGE 
                if(n2Ton8MapDP.get(objIdp.Id) != null){
                    objIdp.N_8_to_N_2_Total_Opportunities__c = n2Ton8MapDP.get(objIdp.Id).size();
                }
                else {
                    objIdp.N_8_to_N_2_Total_Opportunities__c = 0;
                }
                if(n2Ton8MapDPWon.get(objIdp.Id) != null){
                    objIdp.N_8_to_N_2_Total_Won_Opportunities__c = n2Ton8MapDPWon.get(objIdp.Id).size();
                }
                else {
                    objIdp.N_8_to_N_2_Total_Won_Opportunities__c = 0;
                }                
              
              // N2 TO N8 DP TYPE    
              if(n2Ton8MapDP.get(objIdp.Id) != null) {                    
                    if(n2Ton8MapDP.get(objIdp.Id).size() >= 10 && n2Ton8compareDPShowroom.get(objIdp.Id) == true && objIdp.Average_Meetings__c >= 9) {                        
                        objIdp.DP_Type__c = 'Platinum';
                    }
                    else if(n2Ton8MapDP.get(objIdp.Id).size() >= 10 && n2Ton8compareDPShowroom.get(objIdp.Id) == true && objIdp.Average_Meetings__c < 9) {                        
                       objIdp.DP_Type__c = 'Gold';
                    }
                    else if(n2Ton8MapDP.get(objIdp.Id).size() >= 10  && n2Ton8compareDPShowroom.get(objIdp.Id) == false && objIdp.Average_Meetings__c < 9) {                        
                      objIdp.DP_Type__c = 'Silver';
                    }
                    else if(n2Ton8MapDP.get(objIdp.Id).size() >= 10  && n2Ton8compareDPShowroom.get(objIdp.Id) == false && objIdp.Average_Meetings__c >= 9) {                        
                       objIdp.DP_Type__c = 'Bronze';
                    }                    
                }  
                else if(firstOppMetMap.get(objIdp.Id) != null && firstOppMetMap.get(objIdp.Id) > n2) {
                    objIdp.DP_Type__c = 'New';
                }
                else if(RookieMap.get(objIdp.Id) != null && RookieMap.get(objIdp.Id).size() < 10 && RookieMap.get(objIdp.Id).size() > 0) {                        
                    objIdp.DP_Type__c = 'Rookie';
                }
             
            // n3 TO N9 TOTAL MONTHS  
            if(firstOppMetMap.get(objIdp.Id) <= n3 && firstOppMetMap.get(objIdp.Id) >= n9) {                
                objIdp.N_1_Total_Months__c = Date.valueOf(firstOppMetMap.get(objIdp.Id)).daysBetween(n3) / days30.setScale(2);                               
              }  
              else if(firstOppMetMap.get(objIdp.Id) < n9) {
                 objIdp.N_1_Total_Months__c = n9.daysBetween(n3) / days30.setScale(2);
              }  
              else {
                  objIdp.N_1_Total_Months__c = 0;
              }
              
              // FROM N3 TO N9 RANGE 
                if(n3Ton9MapDP.get(objIdp.Id) != null){
                    objIdp.N_9_to_N_3_Total_Opportunities__c = n3Ton9MapDP.get(objIdp.Id).size();
                }
                else {
                    objIdp.N_9_to_N_3_Total_Opportunities__c = 0;
                }
                if(n3Ton9MapDPWon.get(objIdp.Id) != null){
                    objIdp.N_9_to_N_3_Total_Won_Opportunities__c = n3Ton9MapDPWon.get(objIdp.Id).size();
                }
                else {
                    objIdp.N_9_to_N_3_Total_Won_Opportunities__c = 0;
                }  
             
                 // n3 TO N9 TOTAL MONTHS   
                if(n3Ton9MapDP.get(objIdp.Id) != null) {
                    if(n3Ton9MapDP.get(objIdp.Id).size() >= 10 && n3Ton9compareDPShowroom.get(objIdp.Id) == true && objIdp.N_1_Average_Meetings__c >= 9) {                        
                        objIdp.N_1_DP_Type__c = 'Platinum';
                    }
                    else if(n3Ton9MapDP.get(objIdp.Id).size() >= 10 && n3Ton9compareDPShowroom.get(objIdp.Id) == true && objIdp.N_1_Average_Meetings__c < 9) {                        
                        objIdp.N_1_DP_Type__c = 'Gold';
                    }
                    else if(n3Ton9MapDP.get(objIdp.Id).size() >= 10  && n3Ton9compareDPShowroom.get(objIdp.Id) == false && objIdp.N_1_Average_Meetings__c < 9) {                        
                        objIdp.N_1_DP_Type__c = 'Silver';
                    }
                    else if(n3Ton9MapDP.get(objIdp.Id).size() >= 10  && n3Ton9compareDPShowroom.get(objIdp.Id) == false && objIdp.N_1_Average_Meetings__c >= 9) {                        
                        objIdp.N_1_DP_Type__c = 'Bronze';
                    }                    
                }
                else if(firstOppMetMap.get(objIdp.Id) != null && firstOppMetMap.get(objIdp.Id) > n3) {
                    objIdp.N_1_DP_Type__c = 'New';
                }  
                else if(RookieMap.get(objIdp.Id) != null && RookieMap.get(objIdp.Id).size() < 10 & RookieMap.get(objIdp.Id).size() > 0) {                        
                    objIdp.N_1_DP_Type__c = 'Rookie';
                }
                         
                // n4 TO N10 TOTAL MONTHS 
            if(firstOppMetMap.get(objIdp.Id) <= n4 && firstOppMetMap.get(objIdp.Id) >= n10) {                
                 objIdp.N_2_Total_Months__c = Date.valueOf(firstOppMetMap.get(objIdp.Id)).daysBetween(n4) / days30.setScale(2);                        
              }  
              else if(firstOppMetMap.get(objIdp.Id) < n10) {
                 objIdp.N_2_Total_Months__c = n10.daysBetween(n4) / days30.setScale(2);
              }  
              else {
                  objIdp.N_2_Total_Months__c = 0;
              }
              
               // FROM N4 TO N10 RANGE 
                if(n4Ton10MapDP.get(objIdp.Id) != null){
                    objIdp.N_10_to_N_4_Total_Opportunities__c = n4Ton10MapDP.get(objIdp.Id).size();
                }
                else {
                    objIdp.N_10_to_N_4_Total_Opportunities__c = 0;
                }
                if(n4Ton10MapDPWon.get(objIdp.Id) != null){
                    objIdp.N_10_to_N_4_Total_Won_Opportunities__c = n4Ton10MapDPWon.get(objIdp.Id).size();
                }
                else {
                    objIdp.N_10_to_N_4_Total_Won_Opportunities__c = 0;
                }                  
            
            // n4 TO N10 DP TYPE   
            if(n4Ton10MapDP.get(objIdp.Id) != null) {
                if(n4Ton10MapDP.get(objIdp.Id).size() >= 10 && n4Ton10compareDPShowroom.get(objIdp.Id) == true && objIdp.N_2_Average_Meetings__c >= 9) {                        
                    objIdp.N_2_DP_Type__c = 'Platinum';
                }
                else if(n4Ton10MapDP.get(objIdp.Id).size() >= 10 && n4Ton10compareDPShowroom.get(objIdp.Id) == true && objIdp.N_2_Average_Meetings__c < 9) {                        
                    objIdp.N_2_DP_Type__c = 'Gold';
                }
                else if(n4Ton10MapDP.get(objIdp.Id).size() >= 10  && n4Ton10compareDPShowroom.get(objIdp.Id) == false && objIdp.N_2_Average_Meetings__c < 9) {                        
                    objIdp.N_2_DP_Type__c = 'Silver';
                }
                else if(n4Ton10MapDP.get(objIdp.Id).size() >= 10  && n4Ton10compareDPShowroom.get(objIdp.Id) == false && objIdp.N_2_Average_Meetings__c >= 9) {                        
                    objIdp.N_2_DP_Type__c = 'Bronze';
                }
            }             
            else if(firstOppMetMap.get(objIdp.Id) != null && firstOppMetMap.get(objIdp.Id) > n4) {
                objIdp.N_2_DP_Type__c = 'New';
            }
            else if(RookieMap.get(objIdp.Id) != null && RookieMap.get(objIdp.Id).size() < 10 & RookieMap.get(objIdp.Id).size() > 0) {                        
                objIdp.N_2_DP_Type__c = 'Rookie';
            }
                
            DPToUpdate.add(objIdp);                 
        }        
        
        if(!mapSSVOpportunity.isEmpty()){
            for(Id objId :mapSSVOpportunity.keyset()){
                if(objId != null) {
                    Master__c objSSV = new Master__c();
                    objSSV.Id = objId;                
                    
                    // FROM N2 TO N8 RANGE 
                    if(n2Ton8MapMaster.get(objId) != null){
                        objSSV.N_8_to_N_2_Total_Opportunities__c = n2Ton8MapMaster.get(objId).size();
                    }
                    
                    if(n2Ton8MapMasterWon.get(objId) != null){
                        objSSV.N_8_to_N_2_Total_Won_Opportunities__c = n2Ton8MapMasterWon.get(objId).size();
                    }
                    
                    // FROM N3 TO N9 RANGE 
                    if(n3Ton9MapMaster.get(objId) != null){
                        objSSV.N_9_to_N_3_Total_Opportunities__c = n3Ton9MapMaster.get(objId).size();
                    }
                    
                    if(n3Ton9MapMasterWon.get(objId) != null){
                        objSSV.N_9_to_N_3_Total_Won_Opportunities__c = n3Ton9MapMasterWon.get(objId).size();
                    }
                    
                    // FROM N4 TO N10 RANGE 
                    if(n4Ton10MapMaster.get(objId) != null){
                        objSSV.N_10_to_N_4_Total_Opportunities__c = n4Ton10MapMaster.get(objId).size();
                    }
                    
                    if(n4Ton10MapMasterWon.get(objId) != null){
                        objSSV.N_10_to_N_4_Total_Won_Opportunities__c = n4Ton10MapMasterWon.get(objId).size();
                    }   
                    MasterToUpdate.add(objSSV);  
                }         
            }
        }
    
    if(DPToUpdate != null) {
      if(!Test.isRunningTest())
        Update DPToUpdate;
    }
    if(!MasterToUpdate.isEmpty()) {
     if(!Test.isRunningTest())
        Update MasterToUpdate;   
    }
        
    }
    
    global void finish(Database.BatchableContext BC){
       
    }
}