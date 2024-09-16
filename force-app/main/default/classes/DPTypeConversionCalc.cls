public class DPTypeConversionCalc {
    public static void DPTypeConversion() {
        // query master
        List<Master__c> masterList = [select id, name, type__c,
         Showroom_Conversion__c, N_8_to_N_2_Total_Opportunities__c, N_8_to_N_2_Total_Won_Opportunities__c,
         N_1_Showroom_Conversion__c, N_9_to_N_3_Total_Opportunities__c, N_9_to_N_3_Total_Won_Opportunities__c,
         N_2_Showroom_Conversion__c, N_10_to_N_4_Total_Opportunities__c, N_10_to_N_4_Total_Won_Opportunities__c 
         from Master__c where Type__c = 'Showroom'];
        // set to collect number of Masters
        Set<Id> setIDP = new Set<Id>();
        // DP and SSV Opportunity
        Map<Id,List<Opportunity>> mapDPOpportunity = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> mapSSVOpportunity = new Map<Id,List<Opportunity>>();
               
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
     
        // to update DP's
        List<Interior_Designer__c> listDPUpdateDate = new List<Interior_Designer__c>();
         List<Interior_Designer__c> listForLoop = new List<Interior_Designer__c>();
        // to update SSV's
        List<Master__c> listSSVUpdate = new List<Master__c>();
      
        Map<Id,Datetime > firstOppMetMap = new Map<Id,Datetime >();       
        
        // N2 TO N8 DP TYPE
        Map<Id,String> n2Ton8rookieMap = new Map<Id,String>();
        Map<Id,String> n2Ton8platinumMap = new Map<Id,String>();
        Map<Id,String> n2Ton8goldMap = new Map<Id,String>();
        Map<Id,String> n2Ton8silverMap = new Map<Id,String>();
        Map<Id,String> n2Ton8bronzeMap = new Map<Id,String>();        
        Map<Id,Boolean> n2Ton8compareDPShowroom = new Map<Id,Boolean>();       
        Map<Id,Decimal> n2Ton8monthsInRange = new Map<Id,Decimal>();
        Map<Id,Decimal> n2Ton8monthsOutOfRange = new Map<Id,Decimal>();        
        
        // N3 TO N9 DP TYPE
        Map<Id,String> n3Ton9rookieMap = new Map<Id,String>();
        Map<Id,String> n3Ton9platinumMap = new Map<Id,String>();
        Map<Id,String> n3Ton9goldMap = new Map<Id,String>();
        Map<Id,String> n3Ton9silverMap = new Map<Id,String>();
        Map<Id,String> n3Ton9bronzeMap = new Map<Id,String>();        
        Map<Id,Boolean> n3Ton9compareDPShowroom = new Map<Id,Boolean>(); 
        Map<Id,Decimal> n3Ton9monthsInRange = new Map<Id,Decimal>();
        Map<Id,Decimal> n3Ton9monthsOutOfRange = new Map<Id,Decimal>();
        
        // N4 TO N10 DP TYPE
        Map<Id,String> n4Ton10rookieMap = new Map<Id,String>();
        Map<Id,String> n4Ton10platinumMap = new Map<Id,String>();
        Map<Id,String> n4Ton10goldMap = new Map<Id,String>();
        Map<Id,String> n4Ton10silverMap = new Map<Id,String>();
        Map<Id,String> n4Ton10bronzeMap = new Map<Id,String>();        
        Map<Id,Boolean> n4Ton10compareDPShowroom = new Map<Id,Boolean>(); 
        Map<Id,Decimal> n4Ton10monthsInRange = new Map<Id,Decimal>();
        Map<Id,Decimal> n4Ton10monthsOutOfRange = new Map<Id,Decimal>();
                
        DateTime dtTime = System.now();
        Date dt = date.newinstance(dtTime.year(), dtTime.month(), dtTime.day());
        Date n2 = dt.addMonths(-1).toStartOfMonth()-1;
        Date n8 = dt.addMonths(-7).toStartOfMonth();
        Date n3 = dt.addMonths(-2).toStartOfMonth()-1;
        Date n9 = dt.addMonths(-8).toStartOfMonth();
        Date n4 = dt.addMonths(-3).toStartOfMonth()-1;
        Date n10 = dt.addMonths(-9).toStartOfMonth();
        
        for(sObject obj : masterList){
            setIDP.add(obj.Id);
        }
        
        List<Opportunity> lstOpportunity = [Select Id,Property_Name__c,Interior_Design_Partner__r.DP_Conversion__c, Interior_Design_Partner__r.N_1_DP_Conversion__c, Interior_Design_Partner__r.N_2_DP_Conversion__c, Appointment_Venue_Square__r.Showroom_Conversion__c, Appointment_Venue_Square__r.N_1_Showroom_Conversion__c, Appointment_Venue_Square__r.N_2_Showroom_Conversion__c, Order_Closed__c,Order_Book_Date__c,Amount,Opportunity_Status__c,Name,CreatedDate,Time_of_Actual_Appointment_Start__c,Interior_Design_Partner__c,Opportunity_Stage__c,Appointment_Venue_Square__c,Appointment_Venue_Square__r.Name From Opportunity Where (Interior_Design_Partner__c != null and Test_Flag__c = false) ORDER BY Time_of_Actual_Appointment_Start__c DESC];
        System.debug('*******lstOpportunity  '+lstOpportunity.size());
        for(Opportunity obj : lstOpportunity){
            
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
                 
             
                 if(obj.Opportunity_Stage__c == 'Won' || obj.Opportunity_Status__c == '6.Won' || obj.Order_Closed__c == true) {
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
                 
             
                 if(obj.Opportunity_Stage__c == 'Won' || obj.Opportunity_Status__c == '6.Won' || obj.Order_Closed__c == true) {
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
                 
             
                 if(obj.Opportunity_Stage__c == 'Won' || obj.Opportunity_Status__c == '6.Won' || obj.Order_Closed__c == true) {
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
             
         }                  
                       
        } 

       /**************************** FOR LOOP END ****************************/
       
        for(List<Opportunity> oppList2 : mapDPOpportunity.values()) {             
             for(Opportunity opp : oppList2) {             
                  Datetime dat = oppList2[oppList2.size() - 1].Time_of_Actual_Appointment_Start__c; 
                  firstOppMetMap.put(opp.Interior_Design_Partner__c,dat); 
             }
         }
        
        Decimal days30 = 30;
        for(Id objId : mapDPOpportunity.keyset()) {
            Interior_Designer__c objIdp = new Interior_Designer__c();
            objIdp.Id = objId;
            // N2 TO N8 RANGE
            if(firstOppMetMap.get(objIdp.Id) <= n2 && firstOppMetMap.get(objIdp.Id) >= n8) {                
                 n2Ton8monthsInRange.put(objIdp.Id, Date.valueOf(firstOppMetMap.get(objIdp.Id)).daysBetween(n2) / days30.setScale(2));                                
              }  
              else if(firstOppMetMap.get(objIdp.Id) < n8) {
                 n2Ton8monthsOutOfRange.put(objIdp.Id, n8.daysBetween(n2) / days30.setScale(2));
              }                
                 
              if(n2Ton8MapDP.get(objIdp.Id) != null) {
                    if(n2Ton8MapDP.get(objIdp.Id).size() < 10) {                        
                        n2Ton8rookieMap.put(objIdp.Id, 'Rookie');
                    }
                }  
                
              if(n2Ton8MapDP.get(objIdp.Id) != null) {
                    if(n2Ton8MapDP.get(objIdp.Id).size() >= 10 && n2Ton8compareDPShowroom.get(objIdp.Id) == true && objIdp.Average_Meetings__c >= 9) {                        
                        n2Ton8platinumMap.put(objIdp.Id, 'Platinum');
                    }
                }    
                
            if(n2Ton8MapDP.get(objIdp.Id) != null) {
                if(n2Ton8MapDP.get(objIdp.Id).size() >= 10 && n2Ton8compareDPShowroom.get(objIdp.Id) == true && objIdp.Average_Meetings__c < 9) {                        
                    n2Ton8goldMap.put(objIdp.Id, 'Gold');
                }
            }  
                
            if(n2Ton8MapDP.get(objIdp.Id) != null) {
                if(n2Ton8MapDP.get(objIdp.Id).size() >= 10  && n2Ton8compareDPShowroom.get(objIdp.Id) == false && objIdp.Average_Meetings__c < 9) {                        
                    n2Ton8silverMap.put(objIdp.Id, 'Silver');
                }
            }  
                
            if(n2Ton8MapDP.get(objIdp.Id) != null) {
                if(n2Ton8MapDP.get(objIdp.Id).size() >= 10  && n2Ton8compareDPShowroom.get(objIdp.Id) == false && objIdp.Average_Meetings__c >= 9) {                        
                    n2Ton8bronzeMap.put(objIdp.Id, 'Bronze');
                }
            }
            
            // N3 TO N9 RANGE  
            if(firstOppMetMap.get(objIdp.Id) <= n3 && firstOppMetMap.get(objIdp.Id) >= n9) {                
                 n3Ton9monthsInRange.put(objIdp.Id, Date.valueOf(firstOppMetMap.get(objIdp.Id)).daysBetween(n3) / days30.setScale(2));                                
              }  
              else if(firstOppMetMap.get(objIdp.Id) < n9) {
                 n3Ton9monthsOutOfRange.put(objIdp.Id, n9.daysBetween(n3) / days30.setScale(2));
              }  
               
            if(n3Ton9MapDP.get(objIdp.Id) != null) {
                    if(n3Ton9MapDP.get(objIdp.Id).size() < 10) {                        
                        n3Ton9rookieMap.put(objIdp.Id, 'Rookie');
                    }
                }  
                
              if(n3Ton9MapDP.get(objIdp.Id) != null) {
                    if(n3Ton9MapDP.get(objIdp.Id).size() >= 10 && n3Ton9compareDPShowroom.get(objIdp.Id) == true && objIdp.N_1_Average_Meetings__c >= 9) {                        
                        n3Ton9platinumMap.put(objIdp.Id, 'Platinum');
                    }
                }    
                
            if(n3Ton9MapDP.get(objIdp.Id) != null) {
                if(n3Ton9MapDP.get(objIdp.Id).size() >= 10 && n3Ton9compareDPShowroom.get(objIdp.Id) == true && objIdp.N_1_Average_Meetings__c < 9) {                        
                    n3Ton9goldMap.put(objIdp.Id, 'Gold');
                }
            }  
                
            if(n3Ton9MapDP.get(objIdp.Id) != null) {
                if(n3Ton9MapDP.get(objIdp.Id).size() >= 10  && n3Ton9compareDPShowroom.get(objIdp.Id) == false && objIdp.N_1_Average_Meetings__c < 9) {                        
                    n3Ton9silverMap.put(objIdp.Id, 'Silver');
                }
            }  
                
            if(n3Ton9MapDP.get(objIdp.Id) != null) {
                if(n3Ton9MapDP.get(objIdp.Id).size() >= 10  && n3Ton9compareDPShowroom.get(objIdp.Id) == false && objIdp.N_1_Average_Meetings__c >= 9) {                        
                    n3Ton9bronzeMap.put(objIdp.Id, 'Bronze');
                }
            } 
            
            // N4 TO N10 RANGE 
            if(firstOppMetMap.get(objIdp.Id) <= n4 && firstOppMetMap.get(objIdp.Id) >= n10) {                
                 n4Ton10monthsInRange.put(objIdp.Id, Date.valueOf(firstOppMetMap.get(objIdp.Id)).daysBetween(n4) / days30.setScale(2));                                
              }  
              else if(firstOppMetMap.get(objIdp.Id) < n10) {
                 n4Ton10monthsOutOfRange.put(objIdp.Id, n10.daysBetween(n4) / days30.setScale(2));
              }  
              
            if(n4Ton10MapDP.get(objIdp.Id) != null) {
                    if(n4Ton10MapDP.get(objIdp.Id).size() < 10) {                        
                        n4Ton10rookieMap.put(objIdp.Id, 'Rookie');
                    }
                }  
                
              if(n4Ton10MapDP.get(objIdp.Id) != null) {
                    if(n4Ton10MapDP.get(objIdp.Id).size() >= 10 && n4Ton10compareDPShowroom.get(objIdp.Id) == true && objIdp.N_2_Average_Meetings__c >= 9) {                        
                        n4Ton10platinumMap.put(objIdp.Id, 'Platinum');
                    }
                }    
                
            if(n4Ton10MapDP.get(objIdp.Id) != null) {
                if(n4Ton10MapDP.get(objIdp.Id).size() >= 10 && n4Ton10compareDPShowroom.get(objIdp.Id) == true && objIdp.N_2_Average_Meetings__c < 9) {                        
                    n4Ton10goldMap.put(objIdp.Id, 'Gold');
                }
            }  
                
            if(n4Ton10MapDP.get(objIdp.Id) != null) {
                if(n4Ton10MapDP.get(objIdp.Id).size() >= 10  && n4Ton10compareDPShowroom.get(objIdp.Id) == false && objIdp.N_2_Average_Meetings__c < 9) {                        
                    n4Ton10silverMap.put(objIdp.Id, 'Silver');
                }
            }  
                
            if(n4Ton10MapDP.get(objIdp.Id) != null) {
                if(n4Ton10MapDP.get(objIdp.Id).size() >= 10  && n4Ton10compareDPShowroom.get(objIdp.Id) == false && objIdp.N_2_Average_Meetings__c >= 9) {                        
                    n4Ton10bronzeMap.put(objIdp.Id, 'Bronze');
                }
            }  
            
            listForLoop.add(objIdp);       
        }
       
        
        if(!mapDPOpportunity.isEmpty()){           
            for(Interior_Designer__c  objId : listForLoop){
                Interior_Designer__c objIdp = new Interior_Designer__c();
                objIdp.Id = objId.Id;
            
                 // first opportunity met on
                 if(firstOppMetMap.get(objIdp.Id) != null) {
                     objIdp.First_Opp_Meeting_Date__c = firstOppMetMap.get(objIdp.Id);
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
                
                // N2 TO N8 TOTAL MONTHS 
                if(n2Ton8monthsInRange.get(objIdp.Id) != null) {
                    objIdp.Total_Months__c = n2Ton8monthsInRange.get(objIdp.Id);
                } 
                else if(n2Ton8monthsOutOfRange.get(objIdp.Id) != null) {
                    objIdp.Total_Months__c = n2Ton8monthsOutOfRange.get(objIdp.Id);
                }      
                else if(n2Ton8monthsOutOfRange.get(objIdp.Id) == null && n2Ton8monthsInRange.get(objIdp.Id) == null) {
                    objIdp.Total_Months__c = 0;
                } 
                
                // N2 TO N8 DP TYPE 
                if(firstOppMetMap.get(objIdp.Id) > n2) {
                    objIdp.DP_Type__c = 'New';
                }
                else if(n2Ton8rookieMap.get(objIdp.Id) != null) {   
                    objIdp.DP_Type__c = n2Ton8rookieMap.get(objIdp.Id);                   
                }
                else if(n2Ton8platinumMap.get(objIdp.Id) != null) {     
                    objIdp.DP_Type__c = n2Ton8platinumMap.get(objIdp.Id);                   
                }
                else if(n2Ton8goldMap.get(objIdp.Id) != null) {     
                    objIdp.DP_Type__c = n2Ton8goldMap.get(objIdp.Id);                   
                }
                else if(n2Ton8silverMap.get(objIdp.Id) != null) {     
                    objIdp.DP_Type__c = n2Ton8silverMap.get(objIdp.Id);                   
                }
                else if(n2Ton8bronzeMap.get(objIdp.Id) != null) {     
                    objIdp.DP_Type__c = n2Ton8bronzeMap.get(objIdp.Id);                   
                }
                else {
                    objIdp.DP_Type__c = null;
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
                if(n3Ton9monthsInRange.get(objIdp.Id) != null) {
                    objIdp.N_1_Total_Months__c = n3Ton9monthsInRange.get(objIdp.Id);
                } 
                else if(n3Ton9monthsOutOfRange.get(objIdp.Id) != null) {
                    objIdp.N_1_Total_Months__c = n3Ton9monthsOutOfRange.get(objIdp.Id);
                }      
                else if(n3Ton9monthsOutOfRange.get(objIdp.Id) == null && n3Ton9monthsInRange.get(objIdp.Id) == null) {
                    objIdp.N_1_Total_Months__c = 0;
                } 
                
                // n3 TO N9 DP TYPE 
                if(firstOppMetMap.get(objIdp.Id) > n3) {
                    objIdp.N_1_DP_Type__c = 'New';
                }
                else if(n3Ton9rookieMap.get(objIdp.Id) != null) {   
                    objIdp.N_1_DP_Type__c = n3Ton9rookieMap.get(objIdp.Id);                   
                }
                else if(n3Ton9platinumMap.get(objIdp.Id) != null) {     
                    objIdp.N_1_DP_Type__c = n3Ton9platinumMap.get(objIdp.Id);                   
                }
                else if(n3Ton9goldMap.get(objIdp.Id) != null) {     
                    objIdp.N_1_DP_Type__c = n3Ton9goldMap.get(objIdp.Id);                   
                }
                else if(n3Ton9silverMap.get(objIdp.Id) != null) {     
                    objIdp.N_1_DP_Type__c = n3Ton9silverMap.get(objIdp.Id);                   
                }
                else if(n3Ton9bronzeMap.get(objIdp.Id) != null) {     
                    objIdp.N_1_DP_Type__c = n3Ton9bronzeMap.get(objIdp.Id);                   
                }
                else {
                    objIdp.N_1_DP_Type__c = null;
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
                
                // n4 TO N10 TOTAL MONTHS 
                if(n4Ton10monthsInRange.get(objIdp.Id) != null) {
                    objIdp.N_2_Total_Months__c = n4Ton10monthsInRange.get(objIdp.Id);
                } 
                else if(n4Ton10monthsOutOfRange.get(objIdp.Id) != null) {
                    objIdp.N_2_Total_Months__c = n4Ton10monthsOutOfRange.get(objIdp.Id);
                }      
                else if(n4Ton10monthsOutOfRange.get(objIdp.Id) == null && n4Ton10monthsInRange.get(objIdp.Id) == null) {
                    objIdp.N_2_Total_Months__c = 0;
                } 
                
                // n4 TO N10 DP TYPE 
                if(firstOppMetMap.get(objIdp.Id) > n3) {
                    objIdp.N_2_DP_Type__c = 'New';
                }
                else if(n4Ton10rookieMap.get(objIdp.Id) != null) {   
                    objIdp.N_2_DP_Type__c = n4Ton10rookieMap.get(objIdp.Id);                   
                }
                else if(n4Ton10platinumMap.get(objIdp.Id) != null) {     
                    objIdp.N_2_DP_Type__c = n4Ton10platinumMap.get(objIdp.Id);                   
                }
                else if(n4Ton10goldMap.get(objIdp.Id) != null) {     
                    objIdp.N_2_DP_Type__c = n4Ton10goldMap.get(objIdp.Id);                   
                }
                else if(n4Ton10silverMap.get(objIdp.Id) != null) {     
                    objIdp.N_2_DP_Type__c = n4Ton10silverMap.get(objIdp.Id);                   
                }
                else if(n4Ton10bronzeMap.get(objIdp.Id) != null) {     
                    objIdp.N_2_DP_Type__c = n4Ton10bronzeMap.get(objIdp.Id);                   
                }
                else {
                    objIdp.N_2_DP_Type__c = null;
                } 
              
            listDPUpdateDate.add(objIdp);   
            }             
           }       
   
        if(!masterList.isEmpty()){
            for(Master__c objSSV : masterList){
                
                // FROM N2 TO N8 RANGE 
                if(n2Ton8MapMaster.get(objSSV.Id) != null){
                    objSSV.N_8_to_N_2_Total_Opportunities__c = n2Ton8MapMaster.get(objSSV.Id).size();
                }
                
                if(n2Ton8MapMasterWon.get(objSSV.Id) != null){
                    objSSV.N_8_to_N_2_Total_Won_Opportunities__c = n2Ton8MapMasterWon.get(objSSV.Id).size();
                }
                
                // FROM N3 TO N9 RANGE 
                if(n3Ton9MapMaster.get(objSSV.Id) != null){
                    objSSV.N_9_to_N_3_Total_Opportunities__c = n3Ton9MapMaster.get(objSSV.Id).size();
                }
                
                if(n3Ton9MapMasterWon.get(objSSV.Id) != null){
                    objSSV.N_9_to_N_3_Total_Won_Opportunities__c = n3Ton9MapMasterWon.get(objSSV.Id).size();
                }
                
                // FROM N4 TO N10 RANGE 
                if(n4Ton10MapMaster.get(objSSV.Id) != null){
                    objSSV.N_10_to_N_4_Total_Opportunities__c = n4Ton10MapMaster.get(objSSV.Id).size();
                }
                
                if(n4Ton10MapMasterWon.get(objSSV.Id) != null){
                    objSSV.N_10_to_N_4_Total_Won_Opportunities__c = n4Ton10MapMasterWon.get(objSSV.Id).size();
                }
              
                listSSVUpdate.add(objSSV);
                         
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
}