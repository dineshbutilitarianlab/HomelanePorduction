global class AmountOpportunityonST implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([select id,Name,Showroom__c,Showroom_Target_Month__c,Target_Achieved__c,Target_Amount__c,M_1_Showroom_Target_Month__c,M_2_Showroom_Target_Month__c,M_3_Showroom_Target_Month__c, 
                                        M1_M1M2M3_Residence_Order_Amt__c, M1_M1M2M3_Site_Order_Amt__c, M1_M1M2M3_Virtual_Order_Amt__c, M2_M1M2M3_Residence_Order_Amt__c, M2_M1M2M3_Site_Order_Amt__c, M2_M1M2M3_Virtual_Order_Amt__c,
                                        M3_M1M2M3_Residence_Order_Amt__c, M3_M1M2M3_Site_Order_Amt__c, M3_M1M2M3_Virtual_Order_Amt__c, M_4_Showroom_Target_Month__c, M_4_Target_Month__c,
                                        Showroom_Order1_Time1__c, Showroom_Order1_Time2__c, Showroom_Order1_Time3__c, Showroom_Order2_Time2__c, Showroom_Order2_Time3__c, Showroom_Order2_Time4__c, Showroom_Order3_Time3__c, Showroom_Order3_Time4__c,
                                        Virtual_Order1_Time1__c, Virtual_Order1_Time2__c, Virtual_Order1_Time3__c, Virtual_Order2_Time2__c, Virtual_Order2_Time3__c, Virtual_Order2_Time4__c, Virtual_Order3_Time3__c, Virtual_Order3_Time4__c,
                                        Residence_Order1_Time1__c, Residence_Order1_Time2__c, Residence_Order1_Time3__c, Residence_Order2_Time2__c, Residence_Order2_Time3__c, Residence_Order2_Time4__c, Residence_Order3_Time3__c, Residence_Order3_Time4__c,
                                        Site_Order1_Time1__c, Site_Order1_Time2__c, Site_Order1_Time3__c, Site_Order2_Time2__c, Site_Order2_Time3__c, Site_Order2_Time4__c, Site_Order3_Time3__c, Site_Order3_Time4__c,
                                        Target_Month__c, M_1_M_1_M_2_M_3_Showroom_Order_Amt__c, M_2_M_1_M_2_M_3_Showroom_Order_Amt__c, M_3_M_1_M_2_M_3_Showroom_Order_Amt__c from Showroom_Target__c]);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
    /******************************** VARIABLES START***************************************/
        List<Showroom_Target__c> stList = (List<sObject>)(scope);
        System.debug('*******stList  '+stList );
        Map<Id,Showroom_Target__c > stMap = new Map<Id,Showroom_Target__c >();
        Map<Id,String> stMap1 = new Map<Id,String>();
        Map<String,Id> stMap2 = new Map<String,Id>();
        Map<Id,Decimal> amountMap = new Map<Id,Decimal>();
        Set<String> monthStr = new Set<String>();
        Set<Id> setId = new Set<Id>();
        Set<Id> newSet = new Set<id>();
        Set<String> months1back = new Set<String>();
        Set<String> months2back = new Set<String>();
        Set<String> months3back = new Set<String>();
        List<Date> dateList = new List<Date>();
        List<Showroom_Target__c> stToUpdate = new List<Showroom_Target__c >();
        Map<Id,Showroom_Target__c > showroomMap = new Map<Id,Showroom_Target__c >();
        Map<Id,String> showroomMap1 = new Map<Id,String>();
        Map<String,Id> showroomMap2 = new Map<String,Id>();
        Map<Id,Showroom_Target__c> showroomList = new Map<Id,Showroom_Target__c>();
        Map<String,List<Opportunity>> targetAmt = new Map<String,List<Opportunity>>();
        
        // Showroom meeting Variables
        Map<Id,List<Opportunity>> mainMap = new Map<Id,List<Opportunity>>();
        Map<String,List<Opportunity>> mTotalShowroom = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m1TotalShowroom = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m2TotalShowroom = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m3TotalShowroom = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mTotalShowroomWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m1TotalShowroomWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m2TotalShowroomWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m3TotalShowroomWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> TotalShowroom = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mMonthlyShowroom = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m1MonthlyShowroom = new Map<String,List<Opportunity>>();
        Map<Id,List<Opportunity>> mTotalShowroomConv = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> m1TotalShowroomConv = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> m2TotalShowroomConv = new Map<Id,List<Opportunity>>();
        Map<String,List<Opportunity>> mShowroomOrder = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m1ShowroomOrder = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m2ShowroomOrder = new Map<String,List<Opportunity>>();        
        Map<String,List<Opportunity>> mShowroomTime = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m1ShowroomTime = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m2ShowroomTime = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m3ShowroomTime = new Map<String,List<Opportunity>>();      
        Map<String,List<Opportunity>> mShowroomOrder1Time1 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mShowroomOrder2Time2 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mShowroomOrder3Time3 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mShowroomOrder1Time2 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mShowroomOrder2Time3 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mShowroomOrder3Time4 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mShowroomOrder1Time3 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mShowroomOrder2Time4 = new Map<String,List<Opportunity>>();
        
        // Virtual meeting Variables
        Map<String,List<Opportunity>> mVirtualMeet = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m1VirtualMeet = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m2VirtualMeet = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m3VirtualMeet = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mVirtualMeetWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m1VirtualMeetWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m2VirtualMeetWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m3VirtualMeetWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> VirtualMeet = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mMonthlyVirtual = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m1MonthlyVirtual = new Map<String,List<Opportunity>>();
        Map<Id,List<Opportunity>> mVirtualMeetConv = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> m1VirtualMeetConv = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> m2VirtualMeetConv = new Map<Id,List<Opportunity>>();
        Map<String,List<Opportunity>> mVirtualOrder1Time1 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mVirtualOrder2Time2 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mVirtualOrder3Time3 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mVirtualOrder1Time2 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mVirtualOrder2Time3 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mVirtualOrder3Time4 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mVirtualOrder1Time3 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mVirtualOrder2Time4 = new Map<String,List<Opportunity>>();
        
        // Residence Visit Variables
        Map<String,List<Opportunity>> mResidenceVisit = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m1ResidenceVisit = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m2ResidenceVisit = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m3ResidenceVisit = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mResidenceVisitWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m1ResidenceVisitWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m2ResidenceVisitWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m3ResidenceVisitWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> ResidenceVisit = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mMonthlyResidence = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m1MonthlyResidence = new Map<String,List<Opportunity>>();
        Map<Id,List<Opportunity>> mResidenceVisitConv = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> m1ResidenceVisitConv = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> m2ResidenceVisitConv = new Map<Id,List<Opportunity>>();
        Map<String,List<Opportunity>> mResidenceOrder1Time1 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mResidenceOrder2Time2 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mResidenceOrder3Time3 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mResidenceOrder1Time2 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mResidenceOrder2Time3 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mResidenceOrder3Time4 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mResidenceOrder1Time3 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mResidenceOrder2Time4 = new Map<String,List<Opportunity>>();
        
        // Site Visit Variables
        Map<String,List<Opportunity>> mSiteVisit = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m1SiteVisit = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m2SiteVisit = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m3SiteVisit = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mSiteVisitWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m1SiteVisitWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m2SiteVisitWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m3SiteVisitWins = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> SiteVisit = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mMonthlySite = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> m1MonthlySite = new Map<String,List<Opportunity>>();
        Map<Id,List<Opportunity>> mSiteVisitConv = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> m1SiteVisitConv = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> m2SiteVisitConv = new Map<Id,List<Opportunity>>();
        Map<String,List<Opportunity>> mSiteOrder1Time1 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mSiteOrder2Time2 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mSiteOrder3Time3 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mSiteOrder1Time2 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mSiteOrder2Time3 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mSiteOrder3Time4 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mSiteOrder1Time3 = new Map<String,List<Opportunity>>();
        Map<String,List<Opportunity>> mSiteOrder2Time4 = new Map<String,List<Opportunity>>();
        
        
        // Amount Calculation Variables
        Map<String,Decimal> showroomAmtMap = new Map<String,Decimal>();
        Map<String,Decimal> virtualAmtMap = new Map<String,Decimal>();
        Map<String,Decimal> residenceAmtMap = new Map<String,Decimal>();
        Map<String,Decimal> siteAmtMap = new Map<String,Decimal>();
        Map<String,Decimal> targetAmtMap = new Map<String,Decimal>();
        
        Map<Id,Id> showroomId = new Map<Id,Id>();
        Map<Id,String> targetMonthMap = new Map<Id,String>();
      /*************************************** VARIABLES END********************************************/  
        
        for(Showroom_Target__c st : stList) {
            if(st.Showroom__c != null) {
                setId.add(st.Showroom__c);
            }
            if(st.Showroom_Target_Month__c != null) {
                monthStr.add(st.Showroom_Target_Month__c);
            }
            if(st.Target_Month__c != null) {
                dateList.add(st.Target_Month__c);
                months1back.add(st.Target_Month__c.addMonths(-1).month()+'/'+st.Showroom__c);
                months2back.add(st.Target_Month__c.addMonths(-2).month()+'/'+st.Showroom__c);
                months3back.add(st.Target_Month__c.addMonths(-3).month()+'/'+st.Showroom__c);
            }           
        }
       
        DateTime dtTime = System.now();
        Date dt = date.newinstance(dtTime.year(), dtTime.month(), dtTime.day());
        Date dtB4 = dt.addMonths(-11);
       
        for(Showroom_Target__c  s : stList) {
            showroomMap.put(s.Showroom__c,s);
            showroomMap1.put(s.Id,s.Name);
            showroomMap2.put(s.Name,s.Id);
          
        }                   
        System.debug('******showroomMap  '+showroomMap);
                      
        System.debug('******showroomMap1  '+showroomMap1);
        
        for(Showroom_Target__c  s : stList) {
            stMap.put(s.Id,s);
            stMap1.put(s.Id,s.Name);
            stMap2.put(s.Name,s.Id);
            targetMonthMap.put(s.Id,s.Showroom_Target_Month__c);
            showroomId.put(s.Id,s.Showroom__c);
        }                   
        System.debug('******stMap  '+stMap);
        
        Map<String,String> monthList = new Map<String,String>();
        monthList.put('June 2018','June 2018');
        monthList.put('July 2018','July 2018');
        monthList.put('August 2018','August 2018');
        monthList.put('September 2018','September 2018');
        monthList.put('October 2018','October 2018');
        monthList.put('November 2018','November 2018');
        monthList.put('December 2018','December 2018');
        monthList.put('January 2019','January 2019');
        monthList.put('February 2019','February 2019');
        monthList.put('March 2019','March 2019');
        monthList.put('April 2019','April 2019');
        monthList.put('May 2019','May 2019');
        
        /******************************** WINS CALCULATION START ***********************************************************/              
        
        List<Opportunity> amountWinsList = [SELECT Id, Opportunity_Stage__c , X10_Quote_Amount__c, Opportunity_Status__c , Order_Closed__c ,CreatedDate, Name, 
Appointment_Venue_Square__c, Amount, Order_Book_Date__c, Appointment_Type__c, Time_of_Actual_Appointment_Start__c, Opportunity_Order_Book_Month__c, Time_of_actual_appointment_Month__c
              FROM Opportunity
              WHERE Appointment_Venue_Square__c =: setId 
                    and Order_Book_Date__c != null and Test_Flag__c = false
                    and Order_Book_Date__c >:dtB4 and Order_Book_Date__c <=: Date.Today()                    
                    ORDER BY Order_Book_Date__c DESC];
                    System.debug('------amountWinsList  '+amountWinsList);
                    
         if(!showroomMap.isEmpty()) { 
            for(Opportunity opp : amountWinsList) { 
            System.debug('********stMap.get(Id).Target_Month__c.month()  '+stMap.get(showroomMap.get(opp.Appointment_Venue_Square__c).Id));
            System.debug('*******opp.Order_Book_Date__c.month()  '+opp.Order_Book_Date__c.month());
                // TARGET AMOUNT CALC                
              
                        if(targetAmt.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                            List<Opportunity> oList = targetAmt.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                            oList.add(opp);
                            targetAmt.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        else {
                            List<Opportunity> oList = new List<Opportunity>();
                            oList.add(opp);
                            targetAmt.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                               
                
                
                if(opp.Appointment_Type__c == 'Square Showroom Visit') {
                
                if(mTotalShowroomWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = mTotalShowroomWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    mTotalShowroomWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    mTotalShowroomWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                if(m1TotalShowroomWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = m1TotalShowroomWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    m1TotalShowroomWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    m1TotalShowroomWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                if(m2TotalShowroomWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = m2TotalShowroomWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    m2TotalShowroomWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    m2TotalShowroomWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                if(m3TotalShowroomWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = m3TotalShowroomWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    m3TotalShowroomWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    m3TotalShowroomWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                        
                if(opp.Opportunity_Stage__c == 'Won' || opp.Opportunity_Status__c == '6.Won' || opp.Order_Closed__c == true) {
                    if(TotalShowroom.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = TotalShowroom.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        TotalShowroom.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        TotalShowroom.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mShowroomOrder.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mShowroomOrder.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mShowroomOrder.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mShowroomOrder.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(m1ShowroomOrder.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = m1ShowroomOrder.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        m1ShowroomOrder.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        m1ShowroomOrder.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(m2ShowroomOrder.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = m2ShowroomOrder.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        m2ShowroomOrder.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        m2ShowroomOrder.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }                    
                    
                    if(mShowroomOrder1Time1.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mShowroomOrder1Time1.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mShowroomOrder1Time1.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mShowroomOrder1Time1.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mShowroomOrder2Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mShowroomOrder2Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mShowroomOrder2Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mShowroomOrder2Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mShowroomOrder3Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mShowroomOrder3Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mShowroomOrder3Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mShowroomOrder3Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mShowroomOrder1Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mShowroomOrder1Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mShowroomOrder1Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mShowroomOrder1Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mShowroomOrder2Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mShowroomOrder2Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mShowroomOrder2Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mShowroomOrder2Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mShowroomOrder3Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mShowroomOrder3Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mShowroomOrder3Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mShowroomOrder3Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mShowroomOrder1Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mShowroomOrder1Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mShowroomOrder1Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mShowroomOrder1Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mShowroomOrder2Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mShowroomOrder2Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mShowroomOrder2Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mShowroomOrder2Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                }  
                  
                }
                
                
                if(opp.Appointment_Type__c == 'Virtual Meeting') {
                
                if(mVirtualMeetWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = mVirtualMeetWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    mVirtualMeetWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    mVirtualMeetWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                if(m1VirtualMeetWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = m1VirtualMeetWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    m1VirtualMeetWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    m1VirtualMeetWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                if(m2VirtualMeetWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = m2VirtualMeetWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    m2VirtualMeetWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    m2VirtualMeetWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                if(m3VirtualMeetWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = m3VirtualMeetWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    m3VirtualMeetWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    m3VirtualMeetWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                if(opp.Opportunity_Stage__c == 'Won' || opp.Opportunity_Status__c == '6.Won' || opp.Order_Closed__c == true) {
                    if(VirtualMeet.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = VirtualMeet.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        VirtualMeet.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        VirtualMeet.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mVirtualOrder1Time1.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mVirtualOrder1Time1.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mVirtualOrder1Time1.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mVirtualOrder1Time1.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mVirtualOrder2Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mVirtualOrder2Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mVirtualOrder2Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mVirtualOrder2Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mVirtualOrder3Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mVirtualOrder3Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mVirtualOrder3Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mVirtualOrder3Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mVirtualOrder1Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mVirtualOrder1Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mVirtualOrder1Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mVirtualOrder1Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mVirtualOrder2Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mVirtualOrder2Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mVirtualOrder2Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mVirtualOrder2Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mVirtualOrder3Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mVirtualOrder3Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mVirtualOrder3Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mVirtualOrder3Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mVirtualOrder1Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mVirtualOrder1Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mVirtualOrder1Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mVirtualOrder1Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mVirtualOrder2Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mVirtualOrder2Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mVirtualOrder2Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mVirtualOrder2Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                }                       
            }
             
                if(opp.Appointment_Type__c == 'Residence Visit') {
                
                if(mResidenceVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = mResidenceVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    mResidenceVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    mResidenceVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                if(m1ResidenceVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = m1ResidenceVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    m1ResidenceVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    m1ResidenceVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                if(m2ResidenceVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = m2ResidenceVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    m2ResidenceVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    m2ResidenceVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                if(m3ResidenceVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = m3ResidenceVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    m3ResidenceVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    m3ResidenceVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                if(opp.Opportunity_Stage__c == 'Won' || opp.Opportunity_Status__c == '6.Won' || opp.Order_Closed__c == true) {
                     if(ResidenceVisit.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = ResidenceVisit.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        ResidenceVisit.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        ResidenceVisit.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mResidenceOrder1Time1.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mResidenceOrder1Time1.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mResidenceOrder1Time1.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mResidenceOrder1Time1.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mResidenceOrder2Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mResidenceOrder2Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mResidenceOrder2Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mResidenceOrder2Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mResidenceOrder3Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mResidenceOrder3Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mResidenceOrder3Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mResidenceOrder3Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mResidenceOrder1Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mResidenceOrder1Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mResidenceOrder1Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mResidenceOrder1Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mResidenceOrder2Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mResidenceOrder2Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mResidenceOrder2Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mResidenceOrder2Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mResidenceOrder3Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mResidenceOrder3Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mResidenceOrder3Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mResidenceOrder3Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mResidenceOrder1Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mResidenceOrder1Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mResidenceOrder1Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mResidenceOrder1Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mResidenceOrder2Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mResidenceOrder2Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mResidenceOrder2Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mResidenceOrder2Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    
                }   
                    
                    }
                
                
                
                 if(opp.Appointment_Type__c == 'Site Visit') {
                 
                 if(mSiteVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = mSiteVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    mSiteVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    mSiteVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                if(m1SiteVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = m1SiteVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    m1SiteVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    m1SiteVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                if(m2SiteVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = m2SiteVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    m2SiteVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    m2SiteVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                if(m3SiteVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                    List<Opportunity> oList = m3SiteVisitWins.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                    oList.add(opp);
                    m3SiteVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                else {
                    List<Opportunity> oList = new List<Opportunity>();
                    oList.add(opp);
                    m3SiteVisitWins.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                }
                
                
                 if(opp.Opportunity_Stage__c == 'Won' || opp.Opportunity_Status__c == '6.Won' || opp.Order_Closed__c == true) {
                    if(SiteVisit.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = SiteVisit.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        SiteVisit.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        SiteVisit.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mSiteOrder1Time1.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mSiteOrder1Time1.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mSiteOrder1Time1.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mSiteOrder1Time1.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mSiteOrder2Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mSiteOrder2Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mSiteOrder2Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mSiteOrder2Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mSiteOrder3Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mSiteOrder3Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mSiteOrder3Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mSiteOrder3Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mSiteOrder1Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mSiteOrder1Time2.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mSiteOrder1Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mSiteOrder1Time2.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mSiteOrder2Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mSiteOrder2Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mSiteOrder2Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mSiteOrder2Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mSiteOrder3Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mSiteOrder3Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mSiteOrder3Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mSiteOrder3Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mSiteOrder1Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mSiteOrder1Time3.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mSiteOrder1Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mSiteOrder1Time3.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    } 
                    
                    if(mSiteOrder2Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                        List<Opportunity> oList = mSiteOrder2Time4.get(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                        oList.add(opp);
                        mSiteOrder2Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }
                    else {
                        List<Opportunity> oList = new List<Opportunity>();
                        oList.add(opp);
                        mSiteOrder2Time4.put(opp.Opportunity_Order_Book_Month__c+'/'+opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                    }  
                }   
                    
                    
                }                       
             }
         }    
         
        /******************************** WINS CALCULATION END ***********************************************************/
       
        /************************************ SHOWROOM MEETINGS START****************************************************************/       
        
        List<Opportunity> oppList = new List<Opportunity>([SELECT Id, Name, Amount, Appointment_Venue_Square__c, Order_Book_Month__c, Time_of_Actual_Appointment_Start__c, Appointment_Type__c, Opportunity_Stage__c, Opportunity_Status__c, Order_Closed__c, Opportunity_Order_Book_Month__c, Time_of_actual_appointment_Month__c
                                      FROM Opportunity
                                      WHERE Appointment_Venue_Square__c in: setId and test_flag__c = false and Time_of_Actual_Appointment_Start__c >:dtB4 and Time_of_Actual_Appointment_Start__c <=: system.now()
                                      and (Appointment_Type__c = 'Square Showroom Visit' or Appointment_Type__c = 'Virtual Meeting' or Appointment_Type__c = 'Residence Visit' or Appointment_Type__c = 'Site Visit')
                                      ORDER BY Time_of_Actual_Appointment_Start__c DESC]);
       
        if(!showroomMap.isEmpty()) { 
            for(Opportunity opp : oppList) {
                           
                if(opp.Appointment_Venue_Square__c == showroomMap.get(opp.Appointment_Venue_Square__c).Showroom__c) {
                    if(mainMap.get(showroomMap.get(opp.Appointment_Venue_Square__c).Id) != null) {
                            List<Opportunity> oList = mainMap.get(showroomMap.get(opp.Appointment_Venue_Square__c).Id);
                            oList.add(opp);
                            mainMap.put(showroomMap.get(opp.Appointment_Venue_Square__c).Id,oList);
                        }
                        else {
                            List<Opportunity> oList = new List<Opportunity>();
                            oList.add(opp);
                            mainMap.put(showroomMap.get(opp.Appointment_Venue_Square__c).Id,oList);
                        }
                        
                       if(opp.Appointment_Type__c == 'Square Showroom Visit') {
                           
                           if(mTotalShowroom.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                List<Opportunity> oList = mTotalShowroom.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                oList.add(opp);
                                mTotalShowroom.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            }
                            else {
                                List<Opportunity> oList = new List<Opportunity>();
                                oList.add(opp);
                                mTotalShowroom.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            }
                            
                            if(m1TotalShowroom.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                List<Opportunity> oList = m1TotalShowroom.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                oList.add(opp);
                                m1TotalShowroom.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            }
                            else {
                                List<Opportunity> oList = new List<Opportunity>();
                                oList.add(opp);
                                m1TotalShowroom.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            }
                            
                            if(m2TotalShowroom.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                List<Opportunity> oList = m2TotalShowroom.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                oList.add(opp);
                                m2TotalShowroom.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            }
                            else {
                                List<Opportunity> oList = new List<Opportunity>();
                                oList.add(opp);
                                m2TotalShowroom.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            }
                            
                            if(m3TotalShowroom.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                List<Opportunity> oList = m3TotalShowroom.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                oList.add(opp);
                                m3TotalShowroom.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            }
                            else {
                                List<Opportunity> oList = new List<Opportunity>();
                                oList.add(opp);
                                m3TotalShowroom.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            }
                            
                            if(opp.Opportunity_Stage__c == 'Won' || opp.Opportunity_Status__c == '6.Won' || opp.Order_Closed__c == true) {
                            if(mShowroomTime.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                List<Opportunity> oList = mShowroomTime.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                oList.add(opp);
                                mShowroomTime.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            }
                            else {
                                List<Opportunity> oList = new List<Opportunity>();
                                oList.add(opp);
                                mShowroomTime.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            } 
                            
                            if(m1ShowroomTime.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                List<Opportunity> oList = m1ShowroomTime.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                oList.add(opp);
                                m1ShowroomTime.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            }
                            else {
                                List<Opportunity> oList = new List<Opportunity>();
                                oList.add(opp);
                                m1ShowroomTime.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            } 
                            
                            if(m2ShowroomTime.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                List<Opportunity> oList = m2ShowroomTime.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                oList.add(opp);
                                m2ShowroomTime.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            }
                            else {
                                List<Opportunity> oList = new List<Opportunity>();
                                oList.add(opp);
                                m2ShowroomTime.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            } 
                            
                            if(m3ShowroomTime.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                List<Opportunity> oList = m3ShowroomTime.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                oList.add(opp);
                                m3ShowroomTime.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            }
                            else {
                                List<Opportunity> oList = new List<Opportunity>();
                                oList.add(opp);
                                m3ShowroomTime.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                            }
                            } 
                           
                          
                       } 
                       
                       if(opp.Appointment_Type__c == 'Virtual Meeting') {
                       
                       if(mVirtualMeet.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                            List<Opportunity> oList = mVirtualMeet.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                            oList.add(opp);
                            mVirtualMeet.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        else {
                            List<Opportunity> oList = new List<Opportunity>();
                            oList.add(opp);
                            mVirtualMeet.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        
                        if(m1VirtualMeet.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                            List<Opportunity> oList = m1VirtualMeet.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                            oList.add(opp);
                            m1VirtualMeet.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        else {
                            List<Opportunity> oList = new List<Opportunity>();
                            oList.add(opp);
                            m1VirtualMeet.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        
                        if(m2VirtualMeet.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                            List<Opportunity> oList = m2VirtualMeet.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                            oList.add(opp);
                            m2VirtualMeet.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        else {
                            List<Opportunity> oList = new List<Opportunity>();
                            oList.add(opp);
                            m2VirtualMeet.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        
                        if(m3VirtualMeet.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                            List<Opportunity> oList = m3VirtualMeet.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                            oList.add(opp);
                            m3VirtualMeet.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        else {
                            List<Opportunity> oList = new List<Opportunity>();
                            oList.add(opp);
                            m3VirtualMeet.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                          
                       } 
                       
                       if(opp.Appointment_Type__c == 'Residence Visit') {
                       
                       if(mResidenceVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                            List<Opportunity> oList = mResidenceVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                            oList.add(opp);
                            mResidenceVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        else {
                            List<Opportunity> oList = new List<Opportunity>();
                            oList.add(opp);
                            mResidenceVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        
                        if(m1ResidenceVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                            List<Opportunity> oList = m1ResidenceVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                            oList.add(opp);
                            m1ResidenceVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        else {
                            List<Opportunity> oList = new List<Opportunity>();
                            oList.add(opp);
                            m1ResidenceVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        
                        if(m2ResidenceVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                            List<Opportunity> oList = m2ResidenceVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                            oList.add(opp);
                            m2ResidenceVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        else {
                            List<Opportunity> oList = new List<Opportunity>();
                            oList.add(opp);
                            m2ResidenceVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        
                        if(m3ResidenceVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                            List<Opportunity> oList = m3ResidenceVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                            oList.add(opp);
                            m3ResidenceVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        else {
                            List<Opportunity> oList = new List<Opportunity>();
                            oList.add(opp);
                            m3ResidenceVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }

                       } 
                       
                       if(opp.Appointment_Type__c == 'Site Visit') {
                       
                       if(mSiteVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                            List<Opportunity> oList = mSiteVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                            oList.add(opp);
                            mSiteVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        else {
                            List<Opportunity> oList = new List<Opportunity>();
                            oList.add(opp);
                            mSiteVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        
                        if(m1SiteVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                            List<Opportunity> oList = m1SiteVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                            oList.add(opp);
                            m1SiteVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        else {
                            List<Opportunity> oList = new List<Opportunity>();
                            oList.add(opp);
                            m1SiteVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        
                        if(m2SiteVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                            List<Opportunity> oList = m2SiteVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                            oList.add(opp);
                            m2SiteVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        else {
                            List<Opportunity> oList = new List<Opportunity>();
                            oList.add(opp);
                            m2SiteVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        
                        if(m3SiteVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                            List<Opportunity> oList = m3SiteVisit.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                            oList.add(opp);
                            m3SiteVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }
                        else {
                            List<Opportunity> oList = new List<Opportunity>();
                            oList.add(opp);
                            m3SiteVisit.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                        }

                       }  
                       
                       
                       // COMPARING M MONTH
                        
                            if(opp.Appointment_Type__c == 'Square Showroom Visit') {
                              
                                
                                if(mMonthlyShowroom.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                    List<Opportunity> oList = mMonthlyShowroom.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                    oList.add(opp);
                                    mMonthlyShowroom.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                                else {
                                    List<Opportunity> oList = new List<Opportunity>();
                                    oList.add(opp);
                                    mMonthlyShowroom.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                                
                                if(m1MonthlyShowroom.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                    List<Opportunity> oList = m1MonthlyShowroom.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                    oList.add(opp);
                                    m1MonthlyShowroom.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                                else {
                                    List<Opportunity> oList = new List<Opportunity>();
                                    oList.add(opp);
                                    m1MonthlyShowroom.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                             }                         
                          
                            if(opp.Appointment_Type__c == 'Virtual Meeting') {
                              
                                
                                if(mMonthlyVirtual.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                    List<Opportunity> oList = mMonthlyVirtual.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                    oList.add(opp);
                                    mMonthlyVirtual.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                                else {
                                    List<Opportunity> oList = new List<Opportunity>();
                                    oList.add(opp);
                                    mMonthlyVirtual.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                                
                                if(m1MonthlyVirtual.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                    List<Opportunity> oList = m1MonthlyVirtual.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                    oList.add(opp);
                                    m1MonthlyVirtual.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                                else {
                                    List<Opportunity> oList = new List<Opportunity>();
                                    oList.add(opp);
                                    m1MonthlyVirtual.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                              }
                                                      
                            if(opp.Appointment_Type__c == 'Residence Visit') {
                            
                                
                                if(mMonthlyResidence.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                    List<Opportunity> oList = mMonthlyResidence.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                    oList.add(opp);
                                    mMonthlyResidence.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                                else {
                                    List<Opportunity> oList = new List<Opportunity>();
                                    oList.add(opp);
                                    mMonthlyResidence.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                                
                                if(m1MonthlyResidence.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                    List<Opportunity> oList = m1MonthlyResidence.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                    oList.add(opp);
                                    m1MonthlyResidence.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                                else {
                                    List<Opportunity> oList = new List<Opportunity>();
                                    oList.add(opp);
                                    m1MonthlyResidence.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                            }                          
                           
                            if(opp.Appointment_Type__c == 'Site Visit') {
                              
                                if(mMonthlySite.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                    List<Opportunity> oList = mMonthlySite.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                    oList.add(opp);
                                    mMonthlySite.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                                else {
                                    List<Opportunity> oList = new List<Opportunity>();
                                    oList.add(opp);
                                    mMonthlySite.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                                
                                if(m1MonthlySite.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c) != null) {
                                    List<Opportunity> oList = m1MonthlySite.get(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c);
                                    oList.add(opp);
                                    m1MonthlySite.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                                else {
                                    List<Opportunity> oList = new List<Opportunity>();
                                    oList.add(opp);
                                    m1MonthlySite.put(opp.Time_of_actual_appointment_Month__c+'/'+opp.Appointment_Venue_Square__c,oList);
                                }
                             }                 
                         
                    }                   
                  showroomList.put(showroomMap.get(opp.Appointment_Venue_Square__c).Id,showroomMap.get(opp.Appointment_Venue_Square__c)); 
                }                                 
            }           
            
            for(List<Opportunity> oList : TotalShowroom.values()) {
                Decimal showroomAmt = 0;
                for(Opportunity o : oList) {
                    if(o.X10_Quote_Amount__c != null)
                    showroomAmt = showroomAmt + o.X10_Quote_Amount__c;
                    showroomAmtMap.put(o.Opportunity_Order_Book_Month__c+'/'+o.Appointment_Venue_Square__c, showroomAmt);    
                }
            }
           
            
            for(List<Opportunity> oList : VirtualMeet.values()) {
                Decimal virtualAmt = 0;
                for(Opportunity o : oList) {
                    if(o.X10_Quote_Amount__c != null)
                    virtualAmt = virtualAmt + o.X10_Quote_Amount__c;
                    virtualAmtMap.put(o.Opportunity_Order_Book_Month__c+'/'+o.Appointment_Venue_Square__c, virtualAmt);    
                }
            }
            
            
            for(List<Opportunity> oList : ResidenceVisit.values()) {
                Decimal residenceAmt = 0;
                for(Opportunity o : oList) {
                    if(o.X10_Quote_Amount__c != null)
                    residenceAmt = residenceAmt + o.X10_Quote_Amount__c;
                    residenceAmtMap.put(o.Opportunity_Order_Book_Month__c+'/'+o.Appointment_Venue_Square__c, residenceAmt);    
                }
            }
            
            for(List<Opportunity> oList : SiteVisit.values()) {
                Decimal siteAmt = 0;
                for(Opportunity o : oList) {
                    if(o.X10_Quote_Amount__c != null)
                    siteAmt = siteAmt + o.X10_Quote_Amount__c;
                    siteAmtMap.put(o.Opportunity_Order_Book_Month__c+'/'+o.Appointment_Venue_Square__c, siteAmt);    
                }
            }
            
            for(List<Opportunity> oList : targetAmt.values()) {
                Decimal targetAmount = 0;
                for(Opportunity o : oList) {
                    if(o.Amount != null)
                    targetAmount = targetAmount + o.Amount;
                    targetAmtMap.put(o.Opportunity_Order_Book_Month__c+'/'+o.Appointment_Venue_Square__c, targetAmount);    
                }                    
            }
            SYstem.debug('----targetAmtMap  '+targetAmtMap);
            
            // Stamping all Variables
            for(Showroom_Target__c st : stList) {
             
                if(targetAmtMap.containsKey(st.Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Target_Achieved__c = targetAmtMap.get(st.Showroom_Target_Month__c+'/'+st.Showroom__c);
                else 
                st.Target_Achieved__c = 0;
                
                if(showroomAmtMap.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.M_1_M_1_M_2_M_3_Showroom_Order_Amt__c= showroomAmtMap.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c);
                else 
                st.M_1_M_1_M_2_M_3_Showroom_Order_Amt__c = 0;
                
                if(showroomAmtMap.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.M_2_M_1_M_2_M_3_Showroom_Order_Amt__c= showroomAmtMap.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c);
                else 
                st.M_2_M_1_M_2_M_3_Showroom_Order_Amt__c = 0;
                
                if(showroomAmtMap.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.M_3_M_1_M_2_M_3_Showroom_Order_Amt__c= showroomAmtMap.get(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c);
                else 
                st.M_3_M_1_M_2_M_3_Showroom_Order_Amt__c = 0;
                
                if(virtualAmtMap.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.M1_M1M2M3_Virtual_Order_Amt__c= virtualAmtMap.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c);
                else 
                st.M1_M1M2M3_Virtual_Order_Amt__c= 0;
                
                if(virtualAmtMap.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.M2_M1M2M3_Virtual_Order_Amt__c= virtualAmtMap.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c);
                else 
                st.M2_M1M2M3_Virtual_Order_Amt__c= 0;
                
                if(virtualAmtMap.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.M3_M1M2M3_Virtual_Order_Amt__c= virtualAmtMap.get(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c);
                else 
                st.M3_M1M2M3_Virtual_Order_Amt__c= 0;
                
                if(residenceAmtMap.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.M1_M1M2M3_Residence_Order_Amt__c= residenceAmtMap.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c);
                else 
                st.M1_M1M2M3_Residence_Order_Amt__c= 0;
                
                if(residenceAmtMap.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.M2_M1M2M3_Residence_Order_Amt__c= residenceAmtMap.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c);
                else 
                st.M2_M1M2M3_Residence_Order_Amt__c= 0;
                
                if(residenceAmtMap.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.M3_M1M2M3_Residence_Order_Amt__c= residenceAmtMap.get(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c);
                else 
                st.M3_M1M2M3_Residence_Order_Amt__c= 0;
                
                if(siteAmtMap.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.M1_M1M2M3_Site_Order_Amt__c= siteAmtMap.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c);
                else 
                st.M1_M1M2M3_Site_Order_Amt__c= 0;               
                
                if(siteAmtMap.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.M2_M1M2M3_Site_Order_Amt__c= siteAmtMap.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c);
                else 
                st.M2_M1M2M3_Site_Order_Amt__c= 0;
                
                if(siteAmtMap.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.M3_M1M2M3_Site_Order_Amt__c= siteAmtMap.get(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c);
                else 
                st.M3_M1M2M3_Site_Order_Amt__c= 0;
                              
                                
                if(mTotalShowroom.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M_Total_Showroom_Meetings__c = mTotalShowroom.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M_Total_Showroom_Meetings__c = 0;
                if(mTotalShowroomWins.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M_Total_Showroom_Wins__c = mTotalShowroomWins.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M_Total_Showroom_Wins__c = 0;
                
                if(m1TotalShowroom.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M1_Total_Showroom_Meetings__c = m1TotalShowroom.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M1_Total_Showroom_Meetings__c = 0;
                if(m1TotalShowroomWins.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M1_Total_Showroom_Wins__c = m1TotalShowroomWins.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M1_Total_Showroom_Wins__c = 0;
                
                if(m2TotalShowroom.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M2_Total_Showroom_Meetings__c = m2TotalShowroom.get(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M2_Total_Showroom_Meetings__c = 0;
                if(m2TotalShowroomWins.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M2_Total_Showroom_Wins__c = m2TotalShowroomWins.get(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M2_Total_Showroom_Wins__c = 0;
                
                if(m3TotalShowroom.containsKey(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M3_Total_Showroom_Meetings__c = m3TotalShowroom.get(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M3_Total_Showroom_Meetings__c = 0;
                if(m3TotalShowroomWins.containsKey(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M3_Total_Showroom_Wins__c = m3TotalShowroomWins.get(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M3_Total_Showroom_Wins__c = 0;
                
                if(mVirtualMeet.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M_Total_Virtual_Meetings__c= mVirtualMeet.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M_Total_Virtual_Meetings__c= 0;
                if(mVirtualMeetWins.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M_Total_Virtual_Wins__c= mVirtualMeetWins.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M_Total_Virtual_Wins__c= 0;
                
                if(m1VirtualMeet.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M1_Total_Virtual_Meetings__c= m1VirtualMeet.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M1_Total_Virtual_Meetings__c= 0;
                if(m1VirtualMeetWins.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M1_Total_Virtual_Wins__c= m1VirtualMeetWins.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M1_Total_Virtual_Wins__c= 0;
                
                if(m2VirtualMeet.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M2_Total_Virtual_Meetings__c= m2VirtualMeet.get(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M2_Total_Virtual_Meetings__c= 0;
                if(m2VirtualMeetWins.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M2_Total_Virtual_Wins__c= m2VirtualMeetWins.get(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M2_Total_Virtual_Wins__c= 0;
                
                if(m3VirtualMeet.containsKey(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M3_Total_Virtual_Meetings__c= m3VirtualMeet.get(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M3_Total_Virtual_Meetings__c= 0;
                if(m3VirtualMeetWins.containsKey(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M3_Total_Virtual_Wins__c= m3VirtualMeetWins.get(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M3_Total_Virtual_Wins__c= 0;
                
                if(mResidenceVisit.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M_Total_Residence_Meetings__c= mResidenceVisit.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M_Total_Residence_Meetings__c= 0;
                if(mResidenceVisitWins.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M_Total_Residence_Wins__c= mResidenceVisitWins.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M_Total_Residence_Wins__c= 0;
                
                if(m1ResidenceVisit.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M1_Total_Residence_Meetings__c= m1ResidenceVisit.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M1_Total_Residence_Meetings__c= 0;
                if(m1ResidenceVisitWins.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M1_Total_Residence_Wins__c= m1ResidenceVisitWins.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M1_Total_Residence_Wins__c= 0;
                
                if(m2ResidenceVisit.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M2_Total_Residence_Meetings__c= m2ResidenceVisit.get(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M2_Total_Residence_Meetings__c= 0;
                if(m2ResidenceVisitWins.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M2_Total_Residence_Wins__c= m2ResidenceVisitWins.get(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M2_Total_Residence_Wins__c= 0;
                
                if(m3ResidenceVisit.containsKey(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M3_Total_Residence_Meetings__c= m3ResidenceVisit.get(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M3_Total_Residence_Meetings__c= 0;
                if(m3ResidenceVisitWins.containsKey(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M3_Total_Residence_Wins__c= m3ResidenceVisitWins.get(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M3_Total_Residence_Wins__c= 0;
                
                if(mSiteVisit.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M_Total_Site_Meetings__c= mSiteVisit.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M_Total_Site_Meetings__c= 0;
                if(mSiteVisitWins.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M_Total_Site_Wins__c= mSiteVisitWins.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M_Total_Site_Wins__c= 0;
                
                if(m1SiteVisit.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M1_Total_Site_Meetings__c= m1SiteVisit.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M1_Total_Site_Meetings__c= 0;
                if(m1SiteVisitWins.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M1_Total_Site_Wins__c= m1SiteVisitWins.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M1_Total_Site_Wins__c= 0;
                
                if(m2SiteVisit.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M2_Total_Site_Meetings__c= m2SiteVisit.get(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M2_Total_Site_Meetings__c= 0;
                if(m2SiteVisitWins.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M2_Total_Site_Wins__c= m2SiteVisitWins.get(st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M2_Total_Site_Wins__c= 0;
                
                if(m3SiteVisit.containsKey(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M3_Total_Site_Meetings__c= m3SiteVisit.get(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M3_Total_Site_Meetings__c= 0;
                if(m3SiteVisitWins.containsKey(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M3_Total_Site_Wins__c= m3SiteVisitWins.get(st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M3_Total_Site_Wins__c= 0;              
                
                if(mMonthlyShowroom.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M_Monthly_Showroom_Meetings__c = mMonthlyShowroom.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M_Monthly_Showroom_Meetings__c = 0;
                if(m1MonthlyShowroom.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M1_Monthly_Showroom_Meetings__c = m1MonthlyShowroom.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M1_Monthly_Showroom_Meetings__c= 0;
                
                if(mMonthlyVirtual.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M_Monthly_Virtual_Meetings__c = mMonthlyVirtual.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M_Monthly_Virtual_Meetings__c = 0;
                if(m1MonthlyVirtual.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M1_Monthly_Virtual_Meetings__c= m1MonthlyVirtual.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M1_Monthly_Virtual_Meetings__c = 0;
                
                if(mMonthlyResidence.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M_Monthly_Residence_Meetings__c = mMonthlyResidence.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M_Monthly_Residence_Meetings__c = 0;
                if(m1MonthlyResidence.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M1_Monthly_Residence_Meetings__c = m1MonthlyResidence.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M1_Monthly_Residence_Meetings__c = 0;
                
                if(mMonthlySite.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M_Monthly_Site_Meetings__c = mMonthlySite.get(st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M_Monthly_Site_Meetings__c = 0;
                if(m1MonthlySite.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))   
                st.M1_Monthly_Site_Meetings__c = m1MonthlySite.get(st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else
                st.M1_Monthly_Site_Meetings__c = 0;
                
                if(mShowroomOrder1Time1.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Showroom_Order1_Time1__c = mShowroomOrder1Time1.get(st.M_1_Showroom_Target_Month__c+'/'+st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Showroom_Order1_Time1__c = 0;
                if(mShowroomOrder2Time2.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Showroom_Order2_Time2__c = mShowroomOrder2Time2.get(st.M_2_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Showroom_Order2_Time2__c = 0;
                if(mShowroomOrder3Time3.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Showroom_Order3_Time3__c = mShowroomOrder3Time3.get(st.M_3_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Showroom_Order3_Time3__c = 0;
                if(mShowroomOrder1Time2.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Showroom_Order1_Time2__c = mShowroomOrder1Time2.get(st.M_1_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Showroom_Order1_Time2__c = 0;
                if(mShowroomOrder2Time3.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Showroom_Order2_Time3__c = mShowroomOrder2Time3.get(st.M_2_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Showroom_Order2_Time3__c = 0;
                if(mShowroomOrder3Time4.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Showroom_Order3_Time4__c = mShowroomOrder3Time4.get(st.M_3_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Showroom_Order3_Time4__c = 0;
                if(mShowroomOrder1Time3.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Showroom_Order1_Time3__c = mShowroomOrder1Time3.get(st.M_1_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Showroom_Order1_Time3__c = 0;
                if(mShowroomOrder2Time4.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Showroom_Order2_Time4__c = mShowroomOrder2Time4.get(st.M_2_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Showroom_Order2_Time4__c = 0; 
                
                if(mVirtualOrder1Time1.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Virtual_Order1_Time1__c = mVirtualOrder1Time1.get(st.M_1_Showroom_Target_Month__c+'/'+st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Virtual_Order1_Time1__c = 0;
                if(mVirtualOrder2Time2.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Virtual_Order2_Time2__c = mVirtualOrder2Time2.get(st.M_2_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Virtual_Order2_Time2__c = 0;
                if(mVirtualOrder3Time3.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Virtual_Order3_Time3__c = mVirtualOrder3Time3.get(st.M_3_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Virtual_Order3_Time3__c = 0;
                if(mVirtualOrder1Time2.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Virtual_Order1_Time2__c = mVirtualOrder1Time2.get(st.M_1_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Virtual_Order1_Time2__c = 0;
                if(mVirtualOrder2Time3.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Virtual_Order2_Time3__c = mVirtualOrder2Time3.get(st.M_2_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Virtual_Order2_Time3__c = 0;
                if(mVirtualOrder3Time4.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Virtual_Order3_Time4__c = mVirtualOrder3Time4.get(st.M_3_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Virtual_Order3_Time4__c = 0;
                if(mVirtualOrder1Time3.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Virtual_Order1_Time3__c = mVirtualOrder1Time3.get(st.M_1_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Virtual_Order1_Time3__c = 0;
                if(mVirtualOrder2Time4.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Virtual_Order2_Time4__c = mVirtualOrder2Time4.get(st.M_2_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Virtual_Order2_Time4__c = 0;
                
                if(mResidenceOrder1Time1.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Residence_Order1_Time1__c = mResidenceOrder1Time1.get(st.M_1_Showroom_Target_Month__c+'/'+st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Residence_Order1_Time1__c = 0;
                if(mResidenceOrder2Time2.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Residence_Order2_Time2__c = mResidenceOrder2Time2.get(st.M_2_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Residence_Order2_Time2__c = 0;
                if(mResidenceOrder3Time3.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Residence_Order3_Time3__c = mResidenceOrder3Time3.get(st.M_3_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Residence_Order3_Time3__c = 0;
                if(mResidenceOrder1Time2.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Residence_Order1_Time2__c = mResidenceOrder1Time2.get(st.M_1_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Residence_Order1_Time2__c = 0;
                if(mResidenceOrder2Time3.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Residence_Order2_Time3__c = mResidenceOrder2Time3.get(st.M_2_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Residence_Order2_Time3__c = 0;
                if(mResidenceOrder3Time4.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Residence_Order3_Time4__c = mResidenceOrder3Time4.get(st.M_3_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Residence_Order3_Time4__c = 0;
                if(mResidenceOrder1Time3.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Residence_Order1_Time3__c = mResidenceOrder1Time3.get(st.M_1_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Residence_Order1_Time3__c = 0;
                if(mResidenceOrder2Time4.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Residence_Order2_Time4__c = mResidenceOrder2Time4.get(st.M_2_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Residence_Order2_Time4__c = 0;
                
                if(mSiteOrder1Time1.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Site_Order1_Time1__c = mSiteOrder1Time1.get(st.M_1_Showroom_Target_Month__c+'/'+st.M_1_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Site_Order1_Time1__c = 0;
                if(mSiteOrder2Time2.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Site_Order2_Time2__c = mSiteOrder2Time2.get(st.M_2_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Site_Order2_Time2__c = 0;
                if(mSiteOrder3Time3.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Site_Order3_Time3__c = mSiteOrder3Time3.get(st.M_3_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Site_Order3_Time3__c = 0;
                if(mSiteOrder1Time2.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Site_Order1_Time2__c = mSiteOrder1Time2.get(st.M_1_Showroom_Target_Month__c+'/'+st.M_2_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Site_Order1_Time2__c = 0;
                if(mSiteOrder2Time3.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Site_Order2_Time3__c = mSiteOrder2Time3.get(st.M_2_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Site_Order2_Time3__c = 0;
                if(mSiteOrder3Time4.containsKey(st.M_3_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Site_Order3_Time4__c = mSiteOrder3Time4.get(st.M_3_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Site_Order3_Time4__c = 0;
                if(mSiteOrder1Time3.containsKey(st.M_1_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Site_Order1_Time3__c = mSiteOrder1Time3.get(st.M_1_Showroom_Target_Month__c+'/'+st.M_3_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Site_Order1_Time3__c = 0;
                if(mSiteOrder2Time4.containsKey(st.M_2_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c))
                st.Site_Order2_Time4__c = mSiteOrder2Time4.get(st.M_2_Showroom_Target_Month__c+'/'+st.M_4_Showroom_Target_Month__c+'/'+st.Showroom__c).size();
                else 
                st.Site_Order2_Time4__c = 0;
                
                stToUpdate.add(st);
                
            }
         
            System.debug('******stToUpdate  '+stToUpdate);
        
    
        /************************************ SHOWROOM MEETINGS END****************************************************************/
       
        if(!stToUpdate.isEmpty())
        update stToUpdate;
    }
    global void finish(Database.BatchableContext BC) {
    
    }
    
  
}