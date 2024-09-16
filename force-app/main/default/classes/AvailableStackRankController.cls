public class AvailableStackRankController {
    public Id Id { get; set; }
    public Lead lea{ get; set; }

    public AvailableStackRankController (ApexPages.StandardController controller) {
    lea =  (lead) controller.getRecord();
    Id = lea.Id;
    System.debug('The lead record: ' + lea);
    }
    
    
    
    public PageReference CalculateRank() {
        DPAssignment__c availability = DPAssignment__c.getValues('Availability');
        String availability1 = availability.API__c;
         List<Object> listJson = new List<Object>();
        Set<String> emailList = new Set<String>();
        Map<String,List<Lead>> emailMap = new Map<String,List<Lead>>();
        List<Object> infoList = new List<Object>();
        List<Object> finalScoreSort = new List<Object>();
        Map<Id,Lead> leadMap = new Map<Id,Lead>();
        List<Lead> listUpd = new List<Lead>();
        
        
        System.debug('Lead Id: ' + Id);
        try {
        Lead l = [select id, name, Appointment_Venue_Square__r.Design_Manager__r.Email, Interior_Designer__c, Customer_Score__c, Property__c,Square_Showroom_Manager__r.Email, Interior_Designer__r.Email__c, Appointment_Time__c, city, Email_For_Communication__c, Property__r.Name,Meeting_Status__c, Appointment_Venue_Square__c, Appointment_Venue_Square__r.Name, Appointment_Venue_Square__r.WalkIn_SSA__r.Email, Preferred_Language__c,DP_Stack_Rank__c, Regional_Language_Preference__c, Budget_Range__c from Lead where  ( id =: id) and Appointment_Time__c != null and Appointment_Venue_Square__c != null limit 1];
        System.debug('lead --> '+l);
        List<Interior_Designer__c> intDesignList = new List<Interior_Designer__c>();
        
        if(l != null) {           
            DateTime gst;
            Map<String, Object> json_req_input;
         
                System.debug('lead val --> '+l);
                gst = l.Appointment_Time__c.addHours(5).addMinutes(30);
                String con = 'showroom_name='+l.Appointment_Venue_Square__r.Name+'&start_time='+gst;
                System.debug('-----con   '+con );  
                Http http = new http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(availability1);
                request.setMethod('POST');
                request.setBody(con);
                System.debug('-----request  '+request); 
                HttpResponse response = http.send(request);  
                System.debug('-----response  '+response ); 
                System.debug('-----response body '+response.getBody()); 
                json_req_input = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());           
                system.debug('******json_req_input *******'+json_req_input );
                      
                if(json_req_input.get('response') != 'DPs are not available!!') {
                    listJson = (List<Object>)json_req_input.get('response');
                    System.debug('LIST OBJECT '+listJson); 
                    
                    for(Object em : listJson) {
                        Map<String, Object>  json_req_input1 = (Map<String, Object>)em;
                        String strJson = (String)json_req_input1.get('dp_email');
                        emailList.add(strJson);
                        System.debug('Entering before emailMap key '+strJson+' and lead '+l);
                        //emailMap.put(strJson,l);   
                        leadMap.put(l.Id,l);     
                        System.debug('INSIDE  '+strJson );
                    }       
                         
                }
               
                System.debug('---------EMAIL LIST  '+emailList);
                infoList = Calculate(emailList, l);
                System.debug('InfoList --> '+infoList);
                
        }
        PageReference pageRef = new PageReference('/'+Id);
        pageRef.setRedirect(true);
        return pageRef;
        }
        catch(Exception e) {
        
        }
        PageReference pageRef = new PageReference('/'+Id);
        pageRef.setRedirect(true);
        return pageRef;
       }
       
       
       public static List<storeInfoWrapper>  Calculate(Set<String> emailList, Lead myLead)  {
           List<String> availAtShowroomList = new List<String>();
        List<String> propertyNames = new List<String>();
        List<CalculateRankDPWrapper> CalculateRankDPList = new List<CalculateRankDPWrapper> ();
        
        Stack_DP_Rank__c stack = [select Name, X10_40_score__c, Rank_for_Conversion_Percent__c, Rank_for_Won_Opp__c, Language_Score__c, New_Active_0_4__c, New_Active_4_8__c, New_Active_8__c, New_Active_Master__c, Project_Score__c from Stack_DP_Rank__c where Name = 'Stack DP'];
        
        List<Interior_Designer__c> intDesList = new List<Interior_Designer__c>();
        intDesList = [select id, Name, Conversion__c, City__c, Available_at_Showroom__c, Total_Wins__c, OverLoaded__c, Workload_10_40__c, X0_4_Opportunities__c, X4_8_Opportunities__c, X8_Opportunities__c, X0_4_Conversion__c, X4_8_Conversion__c, X8_Conversion__c, X0_4_Won_Opportunities__c, X4_8_Won_Opportunities__c, X8_Won_Opportunities__c, New_joineeV2__c, New_Joinee_0_4__c, New_Joinee_4_8__c, New_Joinee_8__c, Email__c, Property_Exp_Data__c, Languages_Known__c from Interior_Designer__c where Email__c =:emailList];
        
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
              //  if(availAtShowroomList.contains(myLead.Appointment_Venue_Square__r.Name)) {
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
           
        } 
        
        System.debug('-----CalculateRankDPList--- '+CalculateRankDPList);
      
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
        if(sortByOverallList.size() == 0){
            myLead.Available_DP_Stack_Rank__c  = null;
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
               
            myLead.Available_DP_Stack_Rank__c = valueToDisplayV4 ;
        }
            UpdateAvailability__c mc = UpdateAvailability__c.getOrgDefaults();
            mc.Flag__c = false;
            update mc;
            update myLead;             
            mc.Flag__c = true; 
            update mc;       
          
        System.debug('================= storeInfoList  : '+storeInfoList);  
        System.debug('================= storeInfoWrap  : '+storeInfoWrap); 
        return storeInfoWrap;
       }
 
    public class storeInfoWrapper {
        public String email;
        public Decimal rank;
        public Decimal finalScore;
    }
}