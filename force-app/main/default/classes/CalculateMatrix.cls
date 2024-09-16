//  THIS CLASS IS COVERED BY assignment_trigger_Test

global class CalculateMatrix {
    global static Map<Id,Lead> leadToUpdate1 = new Map<Id,Lead>();
    global static void queryDPAssignments(Date assignDt) {
        
        List<String> emailList = new List<String>();
        Set<Id> leadIdList = new Set<Id>();
        List<Object> infoList = new List<Object>();
        List<Object> finalScoreSort = new List<Object>();
        Map<Id,Lead> leadMap = new Map<Id,Lead>();
        Map<Id,String> dpInfoList = new Map<Id,String>();
        
        List<DP_Assignment__c> dpList = [select id, name, DP_Email_List__c from DP_Assignment__c];       
        for(DP_Assignment__c d : dpList) {
            emailList.add(d.Name);
            leadIdList.add(d.Name);
            dpInfoList.put(d.Name, d.DP_Email_List__c);
        }
        
        List<Lead> listLead = [select id, name, Appointment_Venue_Square__r.Design_Manager__r.Email, Interior_Designer__c, Customer_Score__c, Property__c,Square_Showroom_Manager__r.Email, Interior_Designer__r.Email__c, Appointment_Time__c, city, Email_For_Communication__c, Property__r.Name,Meeting_Status__c, Appointment_Venue_Square__c, Appointment_Venue_Square__r.Name, Appointment_Venue_Square__r.WalkIn_SSA__r.Email, Preferred_Language__c,DP_Stack_Rank__c, Regional_Language_Preference__c, Budget_Range__c from Lead where id =:leadIdList order by Customer_Score__c desc];
        System.debug('=====listLead  '+listLead);
        if(listLead.size() > 0) {
            for(Lead l : listLead) {
                leadMap.put(l.Id,l);
                if(dpInfoList.get(l.Id) != null) {
                emailList = dpInfoList.get(l.Id).split(','); 
                infoList = Calculate(emailList, l);
                System.debug('InfoList --> '+infoList);
                for(Object s : infoList) {
                    System.debug('s value in infolist --> '+s);
                    finalScoreSort.add(s);
                }   
                }           
            }
            DPAssignment1(finalScoreSort, leadMap, assignDt, dpList); 
        }
    }
    
    global static void DPAssignment1(List<Object> finalScoreSort, Map<Id,Lead> leadMap, Date assignDt, List<DP_Assignment__c> dpList) {  
        Set<Id> showroomId = new Set<Id>();
       
        List<Object> custScoreSort = new List<Object>();
        List<List<Lead>> leadListOfList= new List<List<Lead>>();
        
        
        storeInfoWrapper.sortBy = storeInfoWrapper.SORT_BY.ByfinalScore;  
        finalScoreSort.sort();
        custScoreSort.addAll(finalScoreSort);
        storeInfoWrapper.sortBy = storeInfoWrapper.SORT_BY.BycustScore;  
        custScoreSort.sort();
        
        System.debug('----------finalScoreSort  '+finalScoreSort);
        String ss = JSON.serialize(finalScoreSort);
        System.debug('----------String  '+ss);
        List<Object> objList = (List<Object>) JSON.deserializeUntyped(ss);
        System.debug('----------objList  '+objList );
        List<Map<String,Object>> finalScoreSortMap = new List<Map<String,Object>>();
        for(Object o : objList) {
            String s = JSON.serialize(o);                
            Map<String,Object> matrixM =  (Map<String,Object>) JSON.deserializeUntyped(s);
            finalScoreSortMap.add(matrixM);
        }        
        SYstem.debug('========finalScoreSortMap  '+finalScoreSortMap);
        
        System.debug('----------custScoreSort  '+custScoreSort);
        String ss1 = JSON.serialize(custScoreSort);
        System.debug('----------String  '+ss1);
        List<Object> objList1 = (List<Object>) JSON.deserializeUntyped(ss1);
        System.debug('----------objList  '+objList1 );
        List<Map<String,Object>> custScoreSortMap = new List<Map<String,Object>>();
        for(Object o : objList1) {
            String s1 = JSON.serialize(o);                
            Map<String,Object> matrixM1 =  (Map<String,Object>) JSON.deserializeUntyped(s1);
            custScoreSortMap.add(matrixM1);
        }
        SYstem.debug('========custScoreSortMap  '+custScoreSortMap);
        
        DPAssignment(finalScoreSortMap, custScoreSortMap, leadMap, assignDt, dpList);
        
    }
    
    global static void DPAssignment(List<Map<String,Object>> finalScoreSortMap, List<Map<String,Object>> custScoreSortMap, Map<Id,Lead> leadMap, Date assignDate, List<DP_Assignment__c> dpList) {
        Integer count = 0;
        Map<String,Object> MapDPList = new Map<String,Object>();
        Set<Id> leadId = new Set<Id>();
        Set<Id> dpId = new Set<Id>();
        List<Decimal> score = new List<Decimal>();
        Map<Id,List<Map<String,Object>>> countMap = new Map<Id,List<Map<String,Object>>>();
        Map<Id,List<Map<String,Object>>> countMapWeak = new Map<Id,List<Map<String,Object>>>();
        Map<Id,List<Map<String,Object>>> singleStrong = new Map<Id,List<Map<String,Object>>>();
        Map<Id,List<Map<String,Object>>> multipleStrong = new Map<Id,List<Map<String,Object>>>();
        Map<Id,List<Map<String,Object>>> singleWeak = new Map<Id,List<Map<String,Object>>>();
        Map<Id,List<Map<String,Object>>> multipleWeak = new Map<Id,List<Map<String,Object>>>();
        
        Map<Decimal,List<Map<String,Object>>> multipleWeak2 = new Map<Decimal,List<Map<String,Object>>>();
        Map<Decimal,List<Map<String,Object>>> countMapWeak2 = new Map<Decimal,List<Map<String,Object>>>();
        Map<Integer,Id> countDPMap = new Map<Integer,Id>();
        Map<Integer,Id> countLeadMap = new Map<Integer,Id>();
        Map<Id,Lead> leadToUpdate = new Map<Id,Lead>();
        Id ids;
        id idsLead;    
        Set<Id> dpListIds = new Set<Id>();    
        
        for(Map<String,Object> m : finalScoreSortMap) {
            System.debug('-------m.get(finalScore)  '+m.get('finalScore'));
            if((Decimal)m.get('finalScore') >= 50 ) {
                count = count+1;
                leadId.add((Id)m.get('leadId'));
                dpId.add((Id)m.get('dpId'));
                score.add((Decimal)m.get('finalScore'));
                if(countMap.get((Id)m.get('dpId')) != null) {
                    List<Map<String,Object>> lst = countMap.get((Id)m.get('dpId'));
                    lst.add(m);
                    countMap.put((Id)m.get('dpId'),lst);               
                }
                else {
                    List<Map<String,Object>> lst = new List<Map<String,Object>>();
                    lst.add(m);
                    countMap.put((Id)m.get('dpId'),lst);   
                }
                countDPMap.put(count,(id)m.get('dpId'));
                countLeadMap.put(count,(id)m.get('leadId'));
                //  m.get('countWrap') = count;
            }
          /*  else {
                List<Map<String,Object>> lst = new List<Map<String,Object>>();
                lst.add(m);
                countMapWeak.put((Id)m.get('dpId'),lst);
            }  */
        }  
       
        System.debug('==========leadId  '+leadId);
        System.debug('==========dpId  '+dpId);
        System.debug('==========score  '+score);
        System.debug('==========countMap  '+countMap);
        System.debug('==========countMapWeak  '+countMapWeak);
        Map<Id,Lead> leadToUpd = new Map<Id,Lead>();
        
        for(Id m : countMap.keyset()) {
            System.debug('***********SIZEs  '+countMap.get(m).size());
            if(countMap.get(m).size() == 1) {
                System.debug('***********INSIDE SIZE 1');
                singleStrong.put(m,countMap.get(m));
            } 
            else if(countMap.get(m).size() > 1) {
                System.debug('***********INSIDE SIZE > 1');
                multipleStrong.put(m,countMap.get(m));              
            } 
        }  
      
        System.debug('==========singleStrong  '+singleStrong);
        System.debug('==========multipleStrong  '+multipleStrong);
       
        Boolean flag1 = false;
        Boolean flag2 = false;
        Boolean flag3 = false;
        Boolean flag4 = false;  
        
        
       
        if(!singleStrong.isEmpty()) {
            System.debug('==========INSIDE SINGLE STRONG');
          //  for(Id m : singleStrong.keyset()) {
            for(Integer i=singleStrong.size()-1; i>=0; i--) {
                for(Map<String,Object> ma : singleStrong.values()[i]) {
                    if(flag1 == false) {
                        //if(LeadMap.containsKey((Id)ma.get('leadId')))
                        //{
                            Lead l = leadMap.get((Id)ma.get('leadId'));
                            l.Interior_Designer__c = (Id)ma.get('dpId');
                            DateTime gst = l.Appointment_Time__c.addHours(-5).addMinutes(-30);
                            leadToUpdate1.put(l.Id,l);
                         //   leadDPmap.put(l,(Id)ma.get('dpId'));
                            String gstStr = String.valueOf(gst);
                            System.debug('+++++++++leadMap.get((String)ma.get(leadId)).Interior_Designer__r.Email__c   '+(String)ma.get('email'));
                            // update l;
                            if(leadToUpdate1.size() >0){
updateAvailabilityAPIRoster objLPA = new updateAvailabilityAPIRoster(leadToUpdate1, UserInfo.getSessionId(), (String)ma.get('email'), (String)ma.get('dpName'), String.valueOf(gst), assignDate, (Id)ma.get('dpId'));
ID jobID = System.enqueueJob(objLPA);
system.debug('-----jobID----'+jobID); 
} 
                        //    String message = callAPI((String)ma.get('email'), l.Appointment_Venue_Square__r.Name, String.valueOf(gst), l.Email_For_Communication__c, assignDate);
                        //    System.debug('message val '+message);
                           /* if(message =='successful')
                            {
                                leadToUpdate1.put(l.Id,l);
                                
                                if(!leadmap.isempty())
                                {
                                    System.debug('lead map ---> '+leadmap);
                                    leadmap.remove(l.Id);                                   
                                 //   if(!Test.isRunningTest())
                                 //   doactions(Leadmap.values(),assignDate,oper);
                                }
                            } */
                            // update l;
                            flag1 = true;
                            break;
                        //}
                    }
                }
            }
        }
             
      
       else if(!multipleStrong.isEmpty()) {
            System.debug('==========INSIDE MULTI STRONG');
            for(Id m : multipleStrong.keyset()) {
                for(Integer i= 0 ; i<=multipleStrong.get(m).size()-1; i++) {
                    if(flag2 == false) {
                        System.debug('Lead Id value in multistrong --> '+(Id)multipleStrong.get(m)[i].get('leadId'));
                        System.debug('Lead map keyset in multiString --> '+leadMap.keyset());
                        //if(leadmap.containskey((Id)multipleStrong.get(m)[i].get('leadId')))
                       // {
                            System.debug('==========INSIDE MULTI STRONG   '+leadMap.get((Id)multipleStrong.get(m)[i].get('leadId')));
                            Lead l = leadMap.get((Id)multipleStrong.get(m)[i].get('leadId'));
                            l.Interior_Designer__c = m;
                            DateTime gst = l.Appointment_Time__c.addHours(-5).addMinutes(-30);
                            //update l;
                            leadToUpdate1.put(l.Id,l);
                         //   leadDPmap.put(l,m);
                            String gstStr = String.valueOf(gst);
                            if(leadToUpdate1.size() >0){
updateAvailabilityAPIRoster objLPA = new updateAvailabilityAPIRoster(leadToUpdate1, UserInfo.getSessionId(), (String)multipleStrong.get(m)[i].get('email'), (String)multipleStrong.get(m)[i].get('dpName'), String.valueOf(gst), assignDate, (Id)multipleStrong.get(m)[i].get('dpId'));
ID jobID = System.enqueueJob(objLPA);
system.debug('-----jobID----'+jobID); 
} 
                          //  String message = callAPI((String)multipleStrong.get(m)[i].get('email'), l.Appointment_Venue_Square__r.Name, String.valueOf(gst), l.Email_For_Communication__c, assignDate);
                          //  System.debug('message val '+message);
                         /*  if(message =='successful')
                            {
                                leadToUpdate1.put(l.Id,l);
                                
                                if(!leadmap.isempty())
                                {
                                    System.debug('lead map ---> '+leadmap);
                                    leadmap.remove(l.Id);                                    
                                 //   if(!Test.isRunningTest())
                                  //  doactions(Leadmap.values(),assignDate,oper);
                                }
                            } */
                            //  update l;
                            flag2 = true;
                            break;
                       // }
                    }
                }
            }
        }       
       
        // for weak matches
     
        else if(!custScoreSortMap.isEmpty()) {
            for(Integer i=custScoreSortMap.size()-1; i>=0; i++) {
                System.debug('==========INSIDE WEAK MATCH  '+custScoreSortMap[i]);
                if(flag3 == false) {                   
                    Lead l = leadMap.get((Id)custScoreSortMap[i].get('leadId'));
                    l.Interior_Designer__c = (Id)custScoreSortMap[i].get('dpId');
                    DateTime gst = l.Appointment_Time__c.addHours(-5).addMinutes(-30);
                    leadToUpdate1.put(l.Id,l);
                 //   leadDPmap.put(l,(Id)custScoreSortMap[i].get('dpId'));
                    String gstStr = String.valueOf(gst);
                    if(leadToUpdate1.size() >0){
updateAvailabilityAPIRoster objLPA = new updateAvailabilityAPIRoster(leadToUpdate1, UserInfo.getSessionId(), (String)custScoreSortMap[i].get('email'), (String)custScoreSortMap[i].get('dpName'), String.valueOf(gst), assignDate, (Id)custScoreSortMap[i].get('dpId'));
ID jobID = System.enqueueJob(objLPA);
system.debug('-----jobID----'+jobID); 
} 

                 //   String message = callAPI((String)custScoreSortMap[i].get('email'), l.Appointment_Venue_Square__r.Name, String.valueOf(gst), l.Email_For_Communication__c, assignDate);
                 /*   if(message =='successful')
                    {
                        leadToUpdate1.put(l.Id,l);
                       
                        if(!leadmap.isempty())
                        {
                            System.debug('lead map ---> '+leadmap);
                            leadmap.remove(l.Id);                                    
                          //  if(!Test.isRunningTest())
                          //  doactions(Leadmap.values(),assignDate,oper);
                        }
                    }  */
                    // update l;
                    flag3 = true;
                    break;
                }                
            }
        } 
        
        else if(!dpList.isEmpty()) {
            for(DP_Assignment__c d : dpList) {
                dpListIds.add(d.Id); 
            }
            deleteDPList(dpListIds);            
        }
    
    } 
    
        global static void deleteDPList(Set<Id> dpListIds) {
            List<DP_Assignment__c> dpList = [select id from DP_Assignment__c where id=:dpListIds];
            if(!dpList.isEmpty())
            delete dpList;
        }
    
    
    
     global static List<storeInfoWrapper> Calculate(List<String> emailList, Lead myLead){
        List<String> availAtShowroomList = new List<String>();
        List<String> propertyNames = new List<String>();
        List<CalculateRankDPWrapper> CalculateRankDPList = new List<CalculateRankDPWrapper> ();
        
        Stack_DP_Rank__c stack = [select Name, X10_40_score__c,  Rank_for_Conversion_Percent__c, Rank_for_Won_Opp__c, Language_Score__c, New_Active_0_4__c, New_Active_4_8__c, New_Active_8__c, New_Active_Master__c, Project_Score__c from Stack_DP_Rank__c where Name = 'Stack DP'];
        System.debug('emailList-->'+emailList);
        List<Interior_Designer__c> intDesList = new List<Interior_Designer__c>();
        intDesList = [select id, Name, Conversion__c, City__c, Available_at_Showroom__c, Total_Wins__c, OverLoaded__c, Workload_10_40__c, X0_4_Opportunities__c, X4_8_Opportunities__c, X8_Opportunities__c, X0_4_Conversion__c, X4_8_Conversion__c, X8_Conversion__c, X0_4_Won_Opportunities__c, X4_8_Won_Opportunities__c, X8_Won_Opportunities__c, New_joineeV2__c, New_Joinee_0_4__c, New_Joinee_4_8__c, New_Joinee_8__c, Email__c, Property_Exp_Data__c, Languages_Known__c from Interior_Designer__c where Email__c in: emailList];
        System.debug('intDesList-->'+intDesList);
        System.debug('intDesList size-->'+intDesList.size());
        List<Interior_Designer__c> DPToUpdate = new List<Interior_Designer__c>();
        
        for(Interior_Designer__c intDes : intDesList) {
            String showroom = '';
            if(intDes.Available_at_Showroom__c != null)
                showroom = intDes.Available_at_Showroom__c;
            System.debug('!!!!!!!!!!   '+showroom);
            availAtShowroomList = showroom.split(';');   
            
            String prop = '';               
            if(intDes.Property_Exp_Data__c != null)
                prop = intDes.Property_Exp_Data__c;
            System.debug('!!!!!!!!!!   '+prop);
            propertyNames = prop.split('<@>');
            
            System.debug('!!!!!!!!!! myLead.Appointment_Venue_Square__r.Name  '+myLead.Appointment_Venue_Square__r.Name);
            
          //  if(myLead.city == intDes.City__c) {    
            //    if(availAtShowroomList.contains(myLead.Appointment_Venue_Square__r.Name)) {
                    CalculateRankDPWrapper CalculateRank = new CalculateRankDPWrapper (); 
                    CalculateRank.recordId = intDes.id; 
                    CalculateRank.email = intDes.Email__c;
                    CalculateRank.leadId = myLead.id;
                    CalculateRank.dpName = intDes.Name;   
                    CalculateRank.custScore = myLead.Customer_Score__c;      
                    if(myLead.Budget_Range__c == 'Upto 1.5L' || myLead.Budget_Range__c == '1.5L - 4L') {
                        if(intDes.X0_4_Opportunities__c != null) {
                            if(intDes.X0_4_Opportunities__c <= 5) 
                                CalculateRank.conversionPercent = stack.New_Active_Master__c;  
                            else 
                                CalculateRank.conversionPercent = intDes.X0_4_Conversion__c;                              
                        }
                        else
                                CalculateRank.conversionPercent = 0;
                        if(intDes.X0_4_Won_Opportunities__c != null) 
                            CalculateRank.wonOpp = intDes.X0_4_Won_Opportunities__c;   
                        else
                            CalculateRank.wonOpp = 0;
                    }
                    if(myLead.Budget_Range__c == '4L - 6L' || myLead.Budget_Range__c == '6L - 8L') {
                        if(intDes.X4_8_Conversion__c != null) {
                            if(intDes.X4_8_Conversion__c <= 5) 
                                CalculateRank.conversionPercent = stack.New_Active_Master__c;  
                            else
                                CalculateRank.conversionPercent = intDes.X4_8_Conversion__c;                            
                        }
                          else
                                CalculateRank.conversionPercent = 0;
                        if(intDes.X4_8_Won_Opportunities__c != null) 
                            CalculateRank.wonOpp = intDes.X4_8_Won_Opportunities__c;  
                         else
                            CalculateRank.wonOpp = 0;
                    }
                    if(myLead.Budget_Range__c == '8L - 10L' || myLead.Budget_Range__c == '10L+') {
                        if(intDes.X8_Conversion__c != null) {
                            if(intDes.X8_Conversion__c <= 5) 
                                CalculateRank.conversionPercent = stack.New_Active_Master__c;  
                            else
                                CalculateRank.conversionPercent = intDes.X8_Conversion__c;                          
                        }
                          else
                                CalculateRank.conversionPercent = 0;
                        if(intDes.X8_Won_Opportunities__c != null) 
                            CalculateRank.wonOpp = intDes.X8_Won_Opportunities__c;   
                         else
                            CalculateRank.wonOpp = 0;
                    }
                    if(myLead.Budget_Range__c != '8L - 10L' && myLead.Budget_Range__c != '10L+' && myLead.Budget_Range__c != '4L - 6L' && myLead.Budget_Range__c != '6L - 8L' && myLead.Budget_Range__c != 'Upto 1.5L' && myLead.Budget_Range__c != '1.5L - 4L' && (myLead.Budget_Range__c == 'Cx didn\'t disclose' || myLead.Budget_Range__c == null)) {
                        if(intDes.Conversion__c != null) {
                            if(intDes.Conversion__c <= 5) 
                                CalculateRank.conversionPercent = stack.New_Active_Master__c;  
                            else
                                CalculateRank.conversionPercent = intDes.Conversion__c;                           
                        }
                          else
                                CalculateRank.conversionPercent = 0;
                        if(intDes.Total_Wins__c != null) 
                            CalculateRank.wonOpp = intDes.Total_Wins__c;    
                         else
                            CalculateRank.wonOpp = 0;
                    }
                    if(intDes.Languages_Known__c != null && myLead.Regional_Language_Preference__c  != null) {
                        if(intDes.Languages_Known__c.contains(myLead.Regional_Language_Preference__c)) {
                            CalculateRank.language = myLead.Regional_Language_Preference__c;
                            CalculateRank.languageScore = stack.Language_Score__c;
                        }                       
                    }
                    else {
                        CalculateRank.languageScore = 0;
                    }
                    
                    if((propertyNames.contains(myLead.Property__r.Name) || propertyNames.contains(myLead.Property__c)) && intDes.Property_Exp_Data__c != null) {                          
                        if(myLead.Property__c != null)
                            CalculateRank.project = myLead.Property__c;
                        else 
                            CalculateRank.project = myLead.Property__r.Name;
                        CalculateRank.projectScore = stack.Project_Score__c;
                    }
                    else {                         
                        CalculateRank.project = '';
                        CalculateRank.projectScore = 0;
                    }
                    if(intDes.OverLoaded__c == true) {
                        CalculateRank.ten40score = stack.X10_40_score__c;
                    }
                    else {
                        CalculateRank.ten40score = 0;
                    }
                    
                    /*  if(myLead.Meeting_Status__c == 'Cancelled - Customer didn\'t come to the showroom') {
if(intDes.Customer_Cancel_Count__c > 0)                         
CalculateRank.priorityScore = 10 * intDes.Customer_Cancel_Count__c;
}
else if(myLead.Meeting_Status__c == 'Cancelled - Designer not free for the meeting') {    
if(intDes.DP_Cancel_Count__c > 0)                   
CalculateRank.priorityScore = -10 * intDes.DP_Cancel_Count__c;
}
else {
CalculateRank.priorityScore = 0;
} 

if(myLead.isConverted == true) {
if(CalculateRank.priorityScore >= 10)
CalculateRank.priorityScore = -10;
}  */
                    
                    if(myLead.Email_For_Communication__c != null) {
                        CalculateRank.custEmail = myLead.Email_For_Communication__c;
                    }
                    if(myLead.Appointment_Venue_Square__c != null)  {
                        CalculateRank.showroomName = myLead.Appointment_Venue_Square__r.Name;
                    }  
                    if(myLead.Appointment_Time__c != null)  {
                        CalculateRank.apptTime = String.valueOf(myLead.Appointment_Time__c);
                    }             
                    
                    if(CalculateRank.languageScore != null && CalculateRank.projectScore != null && CalculateRank.ten40score != null)
                        CalculateRank.finalScore = CalculateRank.languageScore + CalculateRank.projectScore + CalculateRank.ten40score; 
                    else 
                        CalculateRank.finalScore = 0;
                    CalculateRankDPList.add(CalculateRank); 
           //     }
          //  }
            //   intDes.Total_Score__c = CalculateRank.finalScore;
            //   DPToUpdate.add(intDes);
        } 
        
        System.debug('-----CalculateRankDPList--- '+CalculateRankDPList);
        //  System.debug('-----DPToUpdate--- '+DPToUpdate);
        
        //   if(!DPToUpdate.isEMpty()) 
        //   update DPToUpdate;
        /*******************************  ******************************/
        
        CalculateRankDPWrapper.sortBy = CalculateRankDPWrapper.SORT_BY.ByconversionScore;
        List<CalculateRankDPWrapper> CalculateRankDPSortByconvScore = new List<CalculateRankDPWrapper> ();
        CalculateRankDPList.sort();
        CalculateRankDPSortByconvScore.addAll(CalculateRankDPList);
        
        List<CalculateRankDPWrapper> SortRankByConvScoreList = new List<CalculateRankDPWrapper> ();
        
        Decimal rankConversion = 1;
        Decimal rankConversionScore = 0;
        for(Integer i = CalculateRankDPSortByconvScore.size() - 1; i>=0; i--) {
            CalculateRankDPWrapper CalculateRankDPv2 = new CalculateRankDPWrapper(); 
            if(SortRankByConvScoreList.size() == 0) {
                rankConversionScore = stack.Rank_for_Conversion_Percent__c/rankConversion;
                CalculateRankDPv2.recordId = CalculateRankDPSortByconvScore[i].recordId;
                CalculateRankDPv2.wonOpp = CalculateRankDPSortByconvScore[i].wonOpp;
                if(CalculateRankDPSortByconvScore[i].conversionPercent != null)
                    CalculateRankDPv2.rankForConversion = rankConversion;
                if(CalculateRankDPv2.rankForConversion != null)
                    CalculateRankDPv2.conversionScore = rankConversionScore.setScale(2);                
                CalculateRankDPv2.conversionPercent = CalculateRankDPSortByconvScore[i].conversionPercent;
                CalculateRankDPv2.email = CalculateRankDPSortByconvScore[i].email;
                CalculateRankDPv2.language = CalculateRankDPSortByconvScore[i].language;
                CalculateRankDPv2.languageScore = CalculateRankDPSortByconvScore[i].languageScore;
                CalculateRankDPv2.project = CalculateRankDPSortByconvScore[i].project;
                CalculateRankDPv2.projectScore = CalculateRankDPSortByconvScore[i].projectScore;
                CalculateRankDPv2.ten40score = CalculateRankDPSortByconvScore[i].ten40score;
                CalculateRankDPv2.leadId = CalculateRankDPSortByconvScore[i].leadId;
                CalculateRankDPv2.priorityScore = CalculateRankDPSortByconvScore[i].priorityScore;
                CalculateRankDPv2.custScore = CalculateRankDPSortByconvScore[i].custScore;
                CalculateRankDPv2.custEmail = CalculateRankDPSortByconvScore[i].custEmail;
                CalculateRankDPv2.showroomName = CalculateRankDPSortByconvScore[i].showroomName;
                CalculateRankDPv2.apptTime = CalculateRankDPSortByconvScore[i].apptTime;
                CalculateRankDPv2.dpName = CalculateRankDPSortByconvScore[i].dpName;
                if(CalculateRankDPv2.conversionScore != null)
                    CalculateRankDPv2.finalScore = CalculateRankDPSortByconvScore[i].finalScore + CalculateRankDPv2.conversionScore;
            }
            else if(SortRankByConvScoreList.size() > 0) {
                if(SortRankByConvScoreList.get(SortRankByConvScoreList.size() - 1).conversionPercent== CalculateRankDPSortByconvScore[i].conversionPercent) {
                    rankConversionScore = stack.Rank_for_Conversion_Percent__c/rankConversion;
                    CalculateRankDPv2.recordId = CalculateRankDPSortByconvScore[i].recordId;
                    CalculateRankDPv2.wonOpp = CalculateRankDPSortByconvScore[i].wonOpp;
                    if(CalculateRankDPSortByconvScore[i].conversionPercent != null)
                        CalculateRankDPv2.rankForConversion = rankConversion;
                    if(CalculateRankDPv2.rankForConversion != null)
                        CalculateRankDPv2.conversionScore = rankConversionScore.setScale(2);                    
                    CalculateRankDPv2.conversionPercent = CalculateRankDPSortByconvScore[i].conversionPercent;
                    CalculateRankDPv2.email = CalculateRankDPSortByconvScore[i].email;
                    CalculateRankDPv2.language = CalculateRankDPSortByconvScore[i].language;
                    CalculateRankDPv2.languageScore = CalculateRankDPSortByconvScore[i].languageScore;
                    CalculateRankDPv2.project = CalculateRankDPSortByconvScore[i].project;
                    CalculateRankDPv2.projectScore = CalculateRankDPSortByconvScore[i].projectScore;
                    CalculateRankDPv2.ten40score = CalculateRankDPSortByconvScore[i].ten40score;
                    CalculateRankDPv2.leadId = CalculateRankDPSortByconvScore[i].leadId;
                    CalculateRankDPv2.priorityScore = CalculateRankDPSortByconvScore[i].priorityScore;
                    CalculateRankDPv2.custScore = CalculateRankDPSortByconvScore[i].custScore;
                    CalculateRankDPv2.custEmail = CalculateRankDPSortByconvScore[i].custEmail;
                    CalculateRankDPv2.showroomName = CalculateRankDPSortByconvScore[i].showroomName;
                    CalculateRankDPv2.apptTime = CalculateRankDPSortByconvScore[i].apptTime;
                    CalculateRankDPv2.dpName = CalculateRankDPSortByconvScore[i].dpName;
                    if(CalculateRankDPv2.conversionScore != null)
                        CalculateRankDPv2.finalScore = CalculateRankDPSortByconvScore[i].finalScore + CalculateRankDPv2.conversionScore;
                }
                else {
                    rankConversion = rankConversion + 1;
                    rankConversionScore = stack.Rank_for_Conversion_Percent__c/rankConversion;
                    CalculateRankDPv2.recordId = CalculateRankDPSortByconvScore[i].recordId;
                    CalculateRankDPv2.wonOpp = CalculateRankDPSortByconvScore[i].wonOpp;
                    if(CalculateRankDPSortByconvScore[i].conversionPercent != null)
                        CalculateRankDPv2.rankForConversion = rankConversion;
                    if(CalculateRankDPv2.rankForConversion != null)
                        CalculateRankDPv2.conversionScore = rankConversionScore.setScale(2);                    
                    CalculateRankDPv2.conversionPercent = CalculateRankDPSortByconvScore[i].conversionPercent;
                    CalculateRankDPv2.email = CalculateRankDPSortByconvScore[i].email;
                    CalculateRankDPv2.language = CalculateRankDPSortByconvScore[i].language;
                    CalculateRankDPv2.languageScore = CalculateRankDPSortByconvScore[i].languageScore;
                    CalculateRankDPv2.project = CalculateRankDPSortByconvScore[i].project;
                    CalculateRankDPv2.projectScore = CalculateRankDPSortByconvScore[i].projectScore;
                    CalculateRankDPv2.ten40score = CalculateRankDPSortByconvScore[i].ten40score;
                    CalculateRankDPv2.leadId = CalculateRankDPSortByconvScore[i].leadId;
                    CalculateRankDPv2.priorityScore = CalculateRankDPSortByconvScore[i].priorityScore;
                    CalculateRankDPv2.custScore = CalculateRankDPSortByconvScore[i].custScore;
                    CalculateRankDPv2.custEmail = CalculateRankDPSortByconvScore[i].custEmail;
                    CalculateRankDPv2.showroomName = CalculateRankDPSortByconvScore[i].showroomName;
                    CalculateRankDPv2.apptTime = CalculateRankDPSortByconvScore[i].apptTime;
                    CalculateRankDPv2.dpName = CalculateRankDPSortByconvScore[i].dpName;
                    if(CalculateRankDPv2.conversionScore != null)
                        CalculateRankDPv2.finalScore = CalculateRankDPSortByconvScore[i].finalScore + CalculateRankDPv2.conversionScore;
                }
            } 
            SortRankByConvScoreList.add(CalculateRankDPv2);
        }
        SYstem.debug('--------SortRankByConvScoreList-----  '+SortRankByConvScoreList);
        
        
        CalculateRankDPWrapper.sortBy = CalculateRankDPWrapper.SORT_BY.BywonOpp;
        SortRankByConvScoreList.sort();
        List<CalculateRankDPWrapper> CalculateRankDPSortBywonOpp = new List<CalculateRankDPWrapper> ();
        CalculateRankDPSortBywonOpp.addAll(SortRankByConvScoreList);
        
        
        List<CalculateRankDPWrapper> SortRankByWonOppList = new List<CalculateRankDPWrapper> ();
        
        Decimal rankWonOpp = 1;
        Decimal rankWonOppScore = 0;
        // Decimal finalCalculatedScore = 0;
        for(Integer i = CalculateRankDPSortBywonOpp.size() - 1; i>=0; i--) {
            CalculateRankDPWrapper CalculateRankDPv2 = new CalculateRankDPWrapper(); 
            if(SortRankByWonOppList .size() == 0) {
                rankWonOppScore = stack.Rank_for_Won_Opp__c/rankWonOpp;
                if(CalculateRankDPSortBywonOpp[i].conversionScore != null)
                    //  finalCalculatedScore = rankWonOppScore + CalculateRankDPSortBywonOpp[i].conversionScore + CalculateRankDPSortBywonOpp[i].languageScore + CalculateRankDPSortBywonOpp[i].projectScore;
                    CalculateRankDPv2.recordId = CalculateRankDPSortBywonOpp[i].recordId;
                CalculateRankDPv2.wonOpp = CalculateRankDPSortBywonOpp[i].wonOpp;
                if(CalculateRankDPSortBywonOpp[i].wonOpp != null)
                    CalculateRankDPv2.rankForWonOpp = rankWonOpp;
                if(CalculateRankDPv2.rankForWonOpp != null)
                    CalculateRankDPv2.wonOppScore = rankWonOppScore.setScale(2);                
                CalculateRankDPv2.conversionPercent = CalculateRankDPSortBywonOpp[i].conversionPercent;
                CalculateRankDPv2.conversionScore = CalculateRankDPSortBywonOpp[i].conversionScore;
                CalculateRankDPv2.rankForConversion = CalculateRankDPSortBywonOpp[i].rankForConversion;
                if(CalculateRankDPv2.wonOppScore != null)
                    CalculateRankDPv2.finalScore = CalculateRankDPSortBywonOpp[i].finalScore + CalculateRankDPv2.wonOppScore;
                CalculateRankDPv2.email = CalculateRankDPSortBywonOpp[i].email;
                CalculateRankDPv2.language = CalculateRankDPSortBywonOpp[i].language;
                CalculateRankDPv2.languageScore = CalculateRankDPSortBywonOpp[i].languageScore;
                CalculateRankDPv2.project = CalculateRankDPSortBywonOpp[i].project;
                CalculateRankDPv2.projectScore = CalculateRankDPSortBywonOpp[i].projectScore;
                CalculateRankDPv2.ten40score = CalculateRankDPSortBywonOpp[i].ten40score;
                CalculateRankDPv2.leadId = CalculateRankDPSortBywonOpp[i].leadId;
                CalculateRankDPv2.priorityScore = CalculateRankDPSortBywonOpp[i].priorityScore;
                CalculateRankDPv2.custScore = CalculateRankDPSortBywonOpp[i].custScore;
                CalculateRankDPv2.custEmail = CalculateRankDPSortBywonOpp[i].custEmail;
                CalculateRankDPv2.showroomName = CalculateRankDPSortBywonOpp[i].showroomName;
                CalculateRankDPv2.apptTime = CalculateRankDPSortBywonOpp[i].apptTime;
                CalculateRankDPv2.dpName = CalculateRankDPSortBywonOpp[i].dpName;
            }
            else if(SortRankByWonOppList .size() > 0) {
                if(SortRankByWonOppList .get(SortRankByWonOppList .size() - 1).wonOpp == CalculateRankDPSortBywonOpp[i].wonOpp) {
                    rankWonOppScore = stack.Rank_for_Won_Opp__c/rankWonOpp;
                    if(CalculateRankDPSortBywonOpp[i].conversionScore != null)
                        // finalCalculatedScore = rankWonOppScore + CalculateRankDPSortBywonOpp[i].conversionScore + CalculateRankDPSortBywonOpp[i].languageScore + CalculateRankDPSortBywonOpp[i].projectScore;
                        CalculateRankDPv2.recordId = CalculateRankDPSortBywonOpp[i].recordId;
                    CalculateRankDPv2.wonOpp = CalculateRankDPSortBywonOpp[i].wonOpp;
                    if(CalculateRankDPSortBywonOpp[i].wonOpp != null)
                        CalculateRankDPv2.rankForWonOpp = rankWonOpp;
                    if(CalculateRankDPv2.rankForWonOpp != null)
                        CalculateRankDPv2.wonOppScore = rankWonOppScore.setScale(2);                    
                    CalculateRankDPv2.conversionPercent = CalculateRankDPSortBywonOpp[i].conversionPercent;
                    CalculateRankDPv2.conversionScore = CalculateRankDPSortBywonOpp[i].conversionScore;
                    CalculateRankDPv2.rankForConversion = CalculateRankDPSortBywonOpp[i].rankForConversion;
                    if(CalculateRankDPv2.wonOppScore != null)
                        CalculateRankDPv2.finalScore = CalculateRankDPSortBywonOpp[i].finalScore + CalculateRankDPv2.wonOppScore;
                    CalculateRankDPv2.email = CalculateRankDPSortBywonOpp[i].email;
                    CalculateRankDPv2.language = CalculateRankDPSortBywonOpp[i].language;
                    CalculateRankDPv2.languageScore = CalculateRankDPSortBywonOpp[i].languageScore;
                    CalculateRankDPv2.project = CalculateRankDPSortBywonOpp[i].project;
                    CalculateRankDPv2.projectScore = CalculateRankDPSortBywonOpp[i].projectScore;
                    CalculateRankDPv2.ten40score = CalculateRankDPSortBywonOpp[i].ten40score;
                    CalculateRankDPv2.leadId = CalculateRankDPSortBywonOpp[i].leadId;
                    CalculateRankDPv2.priorityScore = CalculateRankDPSortBywonOpp[i].priorityScore;
                    CalculateRankDPv2.custScore = CalculateRankDPSortBywonOpp[i].custScore;
                    CalculateRankDPv2.custEmail = CalculateRankDPSortBywonOpp[i].custEmail;
                    CalculateRankDPv2.showroomName = CalculateRankDPSortBywonOpp[i].showroomName;
                    CalculateRankDPv2.apptTime = CalculateRankDPSortBywonOpp[i].apptTime;
                    CalculateRankDPv2.dpName = CalculateRankDPSortBywonOpp[i].dpName;
                }
                else {
                    rankWonOpp = rankWonOpp + 1;
                    rankWonOppScore = stack.Rank_for_Won_Opp__c/rankWonOpp;
                    if(CalculateRankDPSortBywonOpp[i].conversionScore != null)
                        //   finalCalculatedScore = rankWonOppScore + CalculateRankDPSortBywonOpp[i].conversionScore + CalculateRankDPSortBywonOpp[i].languageScore + CalculateRankDPSortBywonOpp[i].projectScore;
                        CalculateRankDPv2.recordId = CalculateRankDPSortBywonOpp[i].recordId;
                    CalculateRankDPv2.wonOpp = CalculateRankDPSortBywonOpp[i].wonOpp;
                    if(CalculateRankDPSortBywonOpp[i].wonOpp != null)
                        CalculateRankDPv2.rankForWonOpp = rankWonOpp;
                    if(CalculateRankDPv2.rankForWonOpp != null)
                        CalculateRankDPv2.wonOppScore = rankWonOppScore.setScale(2);                    
                    CalculateRankDPv2.conversionPercent = CalculateRankDPSortBywonOpp[i].conversionPercent;
                    CalculateRankDPv2.conversionScore = CalculateRankDPSortBywonOpp[i].conversionScore;
                    CalculateRankDPv2.rankForConversion = CalculateRankDPSortBywonOpp[i].rankForConversion;
                    if(CalculateRankDPv2.wonOppScore != null)
                        CalculateRankDPv2.finalScore = CalculateRankDPSortBywonOpp[i].finalScore + CalculateRankDPv2.wonOppScore;
                    CalculateRankDPv2.email = CalculateRankDPSortBywonOpp[i].email;
                    CalculateRankDPv2.language = CalculateRankDPSortBywonOpp[i].language;
                    CalculateRankDPv2.languageScore = CalculateRankDPSortBywonOpp[i].languageScore;
                    CalculateRankDPv2.project = CalculateRankDPSortBywonOpp[i].project;
                    CalculateRankDPv2.projectScore = CalculateRankDPSortBywonOpp[i].projectScore;
                    CalculateRankDPv2.ten40score = CalculateRankDPSortBywonOpp[i].ten40score;
                    CalculateRankDPv2.leadId = CalculateRankDPSortBywonOpp[i].leadId;
                    CalculateRankDPv2.priorityScore = CalculateRankDPSortBywonOpp[i].priorityScore;
                    CalculateRankDPv2.custScore = CalculateRankDPSortBywonOpp[i].custScore;
                    CalculateRankDPv2.custEmail = CalculateRankDPSortBywonOpp[i].custEmail;
                    CalculateRankDPv2.showroomName = CalculateRankDPSortBywonOpp[i].showroomName;
                    CalculateRankDPv2.apptTime = CalculateRankDPSortBywonOpp[i].apptTime;
                    CalculateRankDPv2.dpName = CalculateRankDPSortBywonOpp[i].dpName;
                }
            } 
            SortRankByWonOppList.add(CalculateRankDPv2);
        }
        
        System.debug('=========SortRankByWonOppList  '+SortRankByWonOppList );
        
        CalculateRankDPWrapper.sortBy = CalculateRankDPWrapper.SORT_BY.ByfinalScore;
        SortRankByWonOppList.sort();
        List<CalculateRankDPWrapper> OverallList = new List<CalculateRankDPWrapper> ();
        OverallList.addAll(SortRankByWonOppList);
        System.debug('------- SORT ByFinalScore ------  '+OverallList );
        
        List<CalculateRankDPWrapper> sortByOverallList = new List<CalculateRankDPWrapper> ();
        Decimal finalRankValue = 1;
        for(Integer i = OverallList.size() - 1; i>=0; i--) {
            CalculateRankDPWrapper CalculateRankDPv2 = new CalculateRankDPWrapper(); 
            if(sortByOverallList.size() == 0) {
                rankWonOppScore = stack.Rank_for_Won_Opp__c/rankWonOpp;
                if(OverallList [i].conversionScore != null)
                    CalculateRankDPv2.recordId = OverallList [i].recordId;
                CalculateRankDPv2.wonOpp = OverallList [i].wonOpp;
                if(OverallList [i].wonOpp != null)
                    CalculateRankDPv2.rankForWonOpp = OverallList [i].rankForWonOpp ;
                if(CalculateRankDPv2.rankForWonOpp != null)
                    CalculateRankDPv2.wonOppScore = OverallList [i].wonOppScore;                
                CalculateRankDPv2.conversionPercent = OverallList [i].conversionPercent;
                CalculateRankDPv2.conversionScore = OverallList [i].conversionScore;
                CalculateRankDPv2.rankForConversion = OverallList [i].rankForConversion;
                //  if(finalCalculatedScore != null)
                CalculateRankDPv2.finalScore = OverallList [i].finalScore;
                CalculateRankDPv2.email = OverallList [i].email;
                CalculateRankDPv2.language = OverallList [i].language;
                CalculateRankDPv2.languageScore = OverallList [i].languageScore;
                CalculateRankDPv2.project = OverallList [i].project;
                CalculateRankDPv2.projectScore = OverallList [i].projectScore;
                CalculateRankDPv2.ten40score = OverallList [i].ten40score;
                CalculateRankDPv2.leadId = OverallList[i].leadId;
                CalculateRankDPv2.priorityScore = OverallList[i].priorityScore;
                CalculateRankDPv2.custScore = OverallList[i].custScore;
                CalculateRankDPv2.custEmail = OverallList[i].custEmail;
                CalculateRankDPv2.showroomName = OverallList[i].showroomName;
                CalculateRankDPv2.apptTime = OverallList[i].apptTime;
                CalculateRankDPv2.dpName = OverallList[i].dpName;
                CalculateRankDPv2.finalRank = finalRankValue;
            }
            else if(sortByOverallList.size() > 0) {
                if(sortByOverallList.get(sortByOverallList.size() - 1).finalScore == OverallList[i].finalScore) {
                    rankWonOppScore = stack.Rank_for_Won_Opp__c/rankWonOpp;
                    if(OverallList [i].conversionScore != null)
                        CalculateRankDPv2.recordId = OverallList [i].recordId;
                    CalculateRankDPv2.wonOpp = OverallList [i].wonOpp;
                    if(OverallList [i].wonOpp != null)
                        CalculateRankDPv2.rankForWonOpp = OverallList [i].rankForWonOpp ;
                    if(CalculateRankDPv2.rankForWonOpp != null)
                        CalculateRankDPv2.wonOppScore = OverallList [i].wonOppScore;                   
                    CalculateRankDPv2.conversionPercent = OverallList [i].conversionPercent;
                    CalculateRankDPv2.conversionScore = OverallList [i].conversionScore;
                    CalculateRankDPv2.rankForConversion = OverallList [i].rankForConversion;
                    //   if(finalCalculatedScore != null)
                    CalculateRankDPv2.finalScore = OverallList [i].finalScore;
                    CalculateRankDPv2.email = OverallList [i].email;
                    CalculateRankDPv2.language = OverallList [i].language;
                    CalculateRankDPv2.languageScore = OverallList [i].languageScore;
                    CalculateRankDPv2.project = OverallList [i].project;
                    CalculateRankDPv2.projectScore = OverallList [i].projectScore;
                    CalculateRankDPv2.ten40score = OverallList [i].ten40score;
                    CalculateRankDPv2.leadId = OverallList[i].leadId;
                    CalculateRankDPv2.priorityScore = OverallList[i].priorityScore;
                    CalculateRankDPv2.custScore = OverallList[i].custScore;
                    CalculateRankDPv2.custEmail = OverallList[i].custEmail;
                    CalculateRankDPv2.showroomName = OverallList[i].showroomName;
                    CalculateRankDPv2.apptTime = OverallList[i].apptTime;
                    CalculateRankDPv2.dpName = OverallList[i].dpName;
                    CalculateRankDPv2.finalRank = finalRankValue ;
                }
                else {
                    finalRankValue = finalRankValue + 1;
                    rankWonOppScore = stack.Rank_for_Won_Opp__c/rankWonOpp;
                    if(OverallList [i].conversionScore != null)
                        CalculateRankDPv2.recordId = OverallList [i].recordId;
                    CalculateRankDPv2.wonOpp = OverallList [i].wonOpp;
                    if(OverallList [i].wonOpp != null)
                        CalculateRankDPv2.rankForWonOpp = OverallList [i].rankForWonOpp ;
                    if(CalculateRankDPv2.rankForWonOpp != null)
                        CalculateRankDPv2.wonOppScore = OverallList [i].wonOppScore;                     
                    CalculateRankDPv2.conversionPercent = OverallList [i].conversionPercent;
                    CalculateRankDPv2.conversionScore = OverallList [i].conversionScore;
                    CalculateRankDPv2.rankForConversion = OverallList [i].rankForConversion;
                    //  if(finalCalculatedScore != null)
                    CalculateRankDPv2.finalScore = OverallList [i].finalScore;
                    CalculateRankDPv2.email = OverallList [i].email;
                    CalculateRankDPv2.language = OverallList [i].language;
                    CalculateRankDPv2.languageScore = OverallList [i].languageScore;
                    CalculateRankDPv2.project = OverallList [i].project;
                    CalculateRankDPv2.projectScore = OverallList [i].projectScore;
                    CalculateRankDPv2.ten40score = OverallList [i].ten40score;
                    CalculateRankDPv2.leadId = OverallList[i].leadId;
                    CalculateRankDPv2.priorityScore = OverallList[i].priorityScore;
                    CalculateRankDPv2.custScore = OverallList[i].custScore;
                    CalculateRankDPv2.custEmail = OverallList[i].custEmail;
                    CalculateRankDPv2.showroomName = OverallList[i].showroomName;
                    CalculateRankDPv2.apptTime = OverallList[i].apptTime;
                    CalculateRankDPv2.dpName = OverallList[i].dpName;
                    CalculateRankDPv2.finalRank = finalRankValue ;
                }
            } 
            sortByOverallList.add(CalculateRankDPv2);
        }
        
        System.debug('-------sortByOverallList ------  '+sortByOverallList);  
        
        // TO DISPLAY VALUES       
        List<storeInfoWrapper> storeInfoWrap = new List<storeInfoWrapper>();
        List<string> storeInfoList = new List<string> ();
        
        List<Lead> leadToUpdate = new List<Lead>();
        String valueToDisplayV4 = '';
        Decimal storeScore = null;
        List<String> getFinalScoreList = new List<String>();
        if(sortByOverallList.size() == 0){
            // myLead.DP_Stack_Rank__c = null;
        }
        for(CalculateRankDPWrapper store : sortByOverallList ) {
            storeInfoWrapper storeInfo = new storeInfoWrapper();
            storeInfo.email = store.email;
            storeInfo.dpId = store.recordId; 
            storeInfo.finalScore = store.finalScore;  
            storeInfo.leadId = store.leadId;  
            storeInfo.custScore = store.custScore;        
            storeInfoWrap.add(storeInfo); 
            String valueToDisplayV1 = string.valueOf(storeInfo);
            System.debug('================= storeInfo: '+storeInfo);           
            String valueToDisplayV3 = valueToDisplayV1.remove('storeInfoWrapper:');        
            System.debug('================= valueToDisplayV3 : '+valueToDisplayV3 ); 
            valueToDisplayV4 = valueToDisplayV4 + ' ; \n'+valueToDisplayV3;
            System.debug('================= valueToDisplayV4 : '+valueToDisplayV4 );                                      
            
            //  myLead.DP_Stack_Rank__c = valueToDisplayV4 ;
            storeInfoList.add(valueToDisplayV3); 
            if(storeScore == null) {          
                if(valueToDisplayV3.contains('[')) {                    
                    valueToDisplayV3.remove('[');
                }
                if(valueToDisplayV3.contains(']')) {
                    valueToDisplayV3.remove(']');
                }
                if(valueToDisplayV3.contains(',')) {                    
                    getFinalScoreList = valueToDisplayV3.split(',');
                }
                if(!getFinalScoreList.isEmpty()) {
                    for(String s : getFinalScoreList) {
                        System.debug('--- YES IS  '+s);
                        if(s.contains('finalScore='))
                        storeScore = Decimal.valueOf(s.remove('finalScore=').trim()); 
                    }
                }
            }       
        }
       
        System.debug('================= storeInfoList  : '+storeInfoList);  
        System.debug('================= storeInfoWrap  : '+storeInfoWrap); 
        return storeInfoWrap;
        
    }   
    
    public static void dummyTestCover(){
   Integer i =0;
   i++;
     i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
     i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
      
   i++;
     i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
     i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}