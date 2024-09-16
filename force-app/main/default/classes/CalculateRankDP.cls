public class CalculateRankDP {
    public Id Id { get; set; }
    public Lead lea{ get; set; }

    public CalculateRankDP (ApexPages.StandardController controller) {
    lea =  (lead) controller.getRecord();
    Id = lea.Id;
    System.debug('The lead record: ' + lea);
    }
    public PageReference CalculateRank() {
        System.debug('Lead Id: ' + Id);
        // Stack_DP_Rank__c is a custom setting
        Stack_DP_Rank__c stack = [select Name, X10_40_score__c, Date__c, Rank_for_Conversion_Percent__c, Rank_for_Won_Opp__c, Language_Score__c, New_Active_0_4__c, New_Active_4_8__c, New_Active_8__c, New_Active_Master__c, Project_Score__c from Stack_DP_Rank__c where Name = 'Stack DP'];
        System.debug('###### STACK  '+stack);
        Date d = stack.Date__c;
        
        Lead leadList = [select id, name, Property__c, city, Appointment_Venue_Square__c, Preferred_Language__c,DP_Stack_Rank__c, Regional_Language_Preference__c, Budget_Range__c from Lead where ( id =: id) limit 1];
     
        List<Interior_Designer__c> intDesignList = new List<Interior_Designer__c>();
        intDesignList = [select id, Name, Conversion__c, City__c, Available_at_Showroom__c, Total_Wins__c, OverLoaded__c, Workload_10_40__c, X0_4_Conversion__c, X4_8_Conversion__c, X8_Conversion__c, X0_4_Won_Opportunities__c, X4_8_Won_Opportunities__c, X8_Won_Opportunities__c, New_joineeV2__c, New_Joinee_0_4__c, New_Joinee_4_8__c, New_Joinee_8__c, Email__c, Property_Exp_Data__c, Languages_Known__c from Interior_Designer__c where (Active__c != null and City__c != null and Available_at_Showroom__c != null)];
        
        List<String> languageNames = new List<String>();
        List<String> languageNamesList = new List<String>();
      
        List<Master__c> masterList = new List<Master__c>();
        List<Master__c> masterList1 = new List<Master__c>();
        Set<Id> newSetId = new Set<Id>();
        Set<Id> apptVenSqrId = new Set<Id>();
        
        if(leadList.Property__c != null) {
            newSetId.add(leadList.Property__c);
        }
        
        masterList = [select id, Name from Master__c where id =: newSetId];
        System.debug('****** '+masterList.size());
        String nameOfMaster = '';
        if(masterList.size() > 0) {
            for(Master__c m : masterList ) {
                nameOfMaster = m.Name;
            }
        }
        
        if(leadList.Appointment_Venue_Square__c != null) {
            apptVenSqrId.add(leadList.Appointment_Venue_Square__c);
        }
        
        masterList1 = [select id, Name from Master__c where id =: apptVenSqrId];
        System.debug('****** '+masterList1.size());
        String nameOfMaster1 = '';
        if(masterList1.size() > 0) {
            for(Master__c m : masterList1 ) {
                nameOfMaster1 = m.Name;
            }
        }
       
        List<CalculateRankDPWrapper> CalculateRankDPList = new List<CalculateRankDPWrapper> ();
      
        List<CalculateRankDPWrapper> projectScoreList = new List<CalculateRankDPWrapper> ();
        List<String> propertyNames = new List<String>();
        List<String> propertyNamesList = new List<String>();
        List<String> availAtShowroomList = new List<String>();
        
        List<CalculateRankDPWrapper> languageScoreList = new List<CalculateRankDPWrapper> ();
        
        Map<Id,Interior_Designer__c> intDesignMap = new Map<Id,Interior_Designer__c>();
        if(intDesignList.size() > 0) {
            for(Interior_Designer__c intDes : intDesignList ) {
                intDesignMap.put(intDes.id, intDes);
                String prop = '';               
                if(intDes.Property_Exp_Data__c != null)
                prop = intDes.Property_Exp_Data__c;
                System.debug('!!!!!!!!!!   '+prop);
                propertyNames = prop.split('<@>');
                propertyNamesList.addAll(propertyNames);                
                
                
                String showroom = '';
                if(intDes.Available_at_Showroom__c != null)
                showroom = intDes.Available_at_Showroom__c;
                System.debug('!!!!!!!!!!   '+showroom);
                availAtShowroomList = showroom.split(';');                
                
                CalculateRankDPWrapper CalculateRank = new CalculateRankDPWrapper ();  
                if(leadList.city == intDes.City__c) {
                System.debug('@@@@@@@@@@@  '+intDes);
                if(availAtShowroomList.contains(nameOfMaster1)) {
                System.debug('!!!!!!!!!!!!!  '+intDes);       
                if(leadList.Budget_Range__c == 'Upto 1.5L' || leadList.Budget_Range__c == '1.5L - 4L') {    
                    if((propertyNames.contains(nameOfMaster) || propertyNames.contains(leadList.Property__c)) && intDes.Property_Exp_Data__c != null) {                          
                        if(leadList.Property__c != null)
                        CalculateRank.project = leadList.Property__c;
                        else 
                        CalculateRank.project = nameOfMaster;
                        CalculateRank.projectScore = stack.Project_Score__c;
                        CalculateRank.recordId = intDes.id; 
                    }
                    else {                         
                        CalculateRank.project = '';
                        CalculateRank.projectScore = 0;
                        CalculateRank.recordId = intDes.id; 
                    }
                
                    if(intDes.Languages_Known__c != null && leadList.Regional_Language_Preference__c != null && intDes.Languages_Known__c.contains(leadList.Regional_Language_Preference__c)) {
                        CalculateRank.language = leadList.Regional_Language_Preference__c;
                        CalculateRank.languageScore = stack.Language_Score__c;
                        CalculateRank.recordId = intDes.id;
                    }
                    else {                          
                        CalculateRank.language = '';
                        CalculateRank.languageScore = 0;
                        CalculateRank.recordId = intDes.id;
                    }
                    
                    if(intDes.Email__c != null) {
                        CalculateRank.email = intDes.Email__c;
                    }
                    if(intDes.OverLoaded__c == true) {
                        CalculateRank.ten40score = stack.X10_40_score__c;
                    }
                    else {
                        CalculateRank.ten40score = 0;
                    }
                    CalculateRank.recordId = intDes.id;                                     
                    Decimal convPercent0to4 = intDes.X0_4_Conversion__c;
                    Decimal wonOpp0to4Value = intDes.X0_4_Won_Opportunities__c;
                    if(intDes.X0_4_Conversion__c != null) {
                        if(intDes.New_Joinee_0_4__c == true) {
                            CalculateRank.conversionPercent = stack.New_Active_0_4__c;  
                        }     
                        else {                                         
                            CalculateRank.conversionPercent = convPercent0to4; 
                        }     
                    } 
                    if(intDes.X0_4_Won_Opportunities__c != null) {
                        CalculateRank.wonOpp = wonOpp0to4Value ;
                    }   
                }
                if(leadList.Budget_Range__c == '4L - 6L' || leadList.Budget_Range__c == '6L - 8L') {    
                    if((propertyNames.contains(nameOfMaster) || propertyNames.contains(leadList.Property__c)) && intDes.Property_Exp_Data__c != null) {                          
                        if(leadList.Property__c != null)
                        CalculateRank.project = leadList.Property__c;
                        else 
                        CalculateRank.project = nameOfMaster;
                        CalculateRank.projectScore = stack.Project_Score__c;
                        CalculateRank.recordId = intDes.id; 
                    }
                    else {                         
                        CalculateRank.project = '';
                        CalculateRank.projectScore = 0;
                        CalculateRank.recordId = intDes.id; 
                    }
                
                    if(intDes.Languages_Known__c != null && leadList.Regional_Language_Preference__c != null && intDes.Languages_Known__c.contains(leadList.Regional_Language_Preference__c)) {
                        CalculateRank.language = leadList.Regional_Language_Preference__c;
                        CalculateRank.languageScore = stack.Language_Score__c;
                        CalculateRank.recordId = intDes.id;
                    }
                    else {                          
                        CalculateRank.language = '';
                        CalculateRank.languageScore = 0;
                        CalculateRank.recordId = intDes.id;
                    }
                    
                    if(intDes.Email__c != null) {
                        CalculateRank.email = intDes.Email__c;
                    }
                    if(intDes.OverLoaded__c == true) {
                        CalculateRank.ten40score = stack.X10_40_score__c;
                    }
                    else {
                        CalculateRank.ten40score = 0;
                    }
                    CalculateRank.recordId = intDes.id;                                     
                    Decimal convPercent4to8 = intDes.X4_8_Conversion__c ;
                    Decimal wonOpp4to8Value = intDes.X4_8_Won_Opportunities__c ;
                    if(intDes.X4_8_Conversion__c  != null) {
                        if(intDes.New_Joinee_4_8__c == true) {
                            CalculateRank.conversionPercent = stack.New_Active_4_8__c;  
                        }     
                        else {                                         
                            CalculateRank.conversionPercent = convPercent4to8; 
                        }     
                    } 
                    if(intDes.X4_8_Won_Opportunities__c  != null) {
                        CalculateRank.wonOpp = wonOpp4to8Value;
                    }   
                }
                if(leadList.Budget_Range__c == '8L - 10L' || leadList.Budget_Range__c == '10L+') {    
                    if((propertyNames.contains(nameOfMaster) || propertyNames.contains(leadList.Property__c)) && intDes.Property_Exp_Data__c != null) {                          
                        if(leadList.Property__c != null)
                        CalculateRank.project = leadList.Property__c;
                        else 
                        CalculateRank.project = nameOfMaster;
                        CalculateRank.projectScore = stack.Project_Score__c;
                        CalculateRank.recordId = intDes.id; 
                    }
                    else {                         
                        CalculateRank.project = '';
                        CalculateRank.projectScore = 0;
                        CalculateRank.recordId = intDes.id; 
                    }
                
                    if(intDes.Languages_Known__c != null && leadList.Regional_Language_Preference__c != null && intDes.Languages_Known__c.contains(leadList.Regional_Language_Preference__c)) {
                        CalculateRank.language = leadList.Regional_Language_Preference__c;
                        CalculateRank.languageScore = stack.Language_Score__c;
                        CalculateRank.recordId = intDes.id;
                    }
                    else {                          
                        CalculateRank.language = '';
                        CalculateRank.languageScore = 0;
                        CalculateRank.recordId = intDes.id;
                    }
                    
                    if(intDes.Email__c != null) {
                        CalculateRank.email = intDes.Email__c;
                    }
                    if(intDes.OverLoaded__c == true) {
                        CalculateRank.ten40score = stack.X10_40_score__c;
                    }
                    else {
                        CalculateRank.ten40score = 0;
                    }
                    CalculateRank.recordId = intDes.id;                                     
                    Decimal convPercent8Plus = intDes.X8_Conversion__c;
                    Decimal wonOpp8PlusValue = intDes.X8_Won_Opportunities__c;
                    if(intDes.X8_Conversion__c   != null) {
                        if(intDes.New_Joinee_8__c == true) {
                            CalculateRank.conversionPercent = stack.New_Active_8__c;  
                        }     
                        else {                                         
                            CalculateRank.conversionPercent = convPercent8Plus; 
                        }     
                    } 
                    if(intDes.X8_Won_Opportunities__c  != null) {
                        CalculateRank.wonOpp = wonOpp8PlusValue;
                    }   
                }
                
              if(leadList.Budget_Range__c != '8L - 10L' && leadList.Budget_Range__c != '10L+' && leadList.Budget_Range__c != '4L - 6L' && leadList.Budget_Range__c != '6L - 8L' && leadList.Budget_Range__c != 'Upto 1.5L' && leadList.Budget_Range__c != '1.5L - 4L' && (leadList.Budget_Range__c == 'Cx didn\'t disclose' || leadList.Budget_Range__c == null)) {
                    if((propertyNames.contains(nameOfMaster) || propertyNames.contains(leadList.Property__c)) && intDes.Property_Exp_Data__c != null) {
                        if(leadList.Property__c != null)
                        CalculateRank.project = leadList.Property__c;
                        else 
                        CalculateRank.project = nameOfMaster;
                        CalculateRank.projectScore = stack.Project_Score__c;
                        CalculateRank.recordId = intDes.id; 
                    }
                    else {
                        CalculateRank.project = '';
                        CalculateRank.projectScore = 0;
                        CalculateRank.recordId = intDes.id; 
                    }
                
                    if(intDes.Languages_Known__c != null && leadList.Regional_Language_Preference__c != null && intDes.Languages_Known__c.contains(leadList.Regional_Language_Preference__c)) {
                        CalculateRank.language = leadList.Preferred_Language__c;
                        CalculateRank.languageScore = stack.Language_Score__c;
                        CalculateRank.recordId = intDes.id;
                    }
                    else {
                        CalculateRank.language = '';
                        CalculateRank.languageScore = 0;
                        CalculateRank.recordId = intDes.id;
                    }
                    if(intDes.Email__c != null) {
                        CalculateRank.email = intDes.Email__c;
                    }
                    if(intDes.OverLoaded__c == true) {
                        CalculateRank.ten40score = stack.X10_40_score__c;
                    }
                    else {
                        CalculateRank.ten40score = 0;
                    }
                    CalculateRank.recordId = intDes.id; 
                    if(intDes.Conversion__c != null) {
                        if(intDes.New_joineeV2__c == true) {
                            CalculateRank.conversionPercent = stack.New_Active_Master__c;  
                        }     
                        else {                                         
                            CalculateRank.conversionPercent = intDes.Conversion__c; 
                        }     
                    } 
                    CalculateRank.wonOpp = intDes.Total_Wins__c; 
                                       
                }
               if(CalculateRank.languageScore != null && CalculateRank.projectScore != null && CalculateRank.ten40score != null)
               CalculateRank.finalScore = CalculateRank.languageScore + CalculateRank.projectScore + CalculateRank.ten40score; 
               CalculateRankDPList.add(CalculateRank);          
        } 
        }
        }
        System.debug('-----CalculateRankDPList--- '+CalculateRankDPList);
             
    }
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
                    CalculateRankDPv2.finalRank = finalRankValue ;
                }
            }
            sortByOverallList.add(CalculateRankDPv2);
        }
        
        System.debug('------- sortByOverallList ------  '+sortByOverallList);  
   
       
        // TO DISPLAY VALUES
        
        List<storeInfoWrapper> storeInfoWrap = new List<storeInfoWrapper>();
        List<string> storeInfoList = new List<string> ();
        
        List<Lead> leadToUpdate = new List<Lead>();
          String valueToDisplayV4 = '';
           if(sortByOverallList.size() == 0){
                leadList.DP_Stack_Rank__c = null;
            }
        for(CalculateRankDPWrapper store : sortByOverallList ) {
            storeInfoWrapper storeInfo = new storeInfoWrapper();
            storeInfo.email = store.email;
            storeInfo.rank = store.finalRank; 
            storeInfo.finalScore = store.finalScore;           
            storeInfoWrap.add(storeInfo); 
            String valueToDisplayV1 = string.valueOf(storeInfo);
            System.debug('================= storeInfo: '+storeInfo);           
            String valueToDisplayV3 = valueToDisplayV1.remove('storeInfoWrapper:');        
            System.debug('================= valueToDisplayV3 : '+valueToDisplayV3 ); 
            valueToDisplayV4 = valueToDisplayV4 + ' ; \n'+valueToDisplayV3;
            System.debug('================= valueToDisplayV4 : '+valueToDisplayV4 );                                      
               
            leadList.DP_Stack_Rank__c = valueToDisplayV4 ;
             
        }
         update leadList;
         System.debug('================= storeInfoWrap  : '+storeInfoWrap );  

        
        PageReference pageRef = new PageReference('/'+Id);
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    public class storeInfoWrapper {
        public String email;
        public Decimal rank;
        public Decimal finalScore;
    }
}