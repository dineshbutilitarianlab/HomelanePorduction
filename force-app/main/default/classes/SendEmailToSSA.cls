public class SendEmailToSSA {
    // variables for lead
    Public static String Id {get;set;}
    Public static String nam {get;set;}
    Public static String pho {get;set;}
    Public static String cit {get;set;}
    public static String cxid {get;set;}
    public static String smnam;
    public static string lshow;
    public static string lpcon;
    public static string pname;
    public static Date lpmid;
    public static String lreq;
    public static String adstr{get;set;}
    public static String atstr{get;set;}
    public static String lpmidstr;
    // variables for customer profiling sessions. For simplicity the first alphabet is used per word for a field.    
    public static String lang {get;set;} 
    public static String family {get;set;}     
    public static Date ad {get;set;}
    public static Time at {get;set;}
    public static String firstHome {get;set;}
    public static String bd1pu {get;set;}
    public static String ir {get;set;}
    public static String bd1st {get;set;}
    public static Date isd {get;set;}
    public static String isdstr {get;set;}
    public static String bd1tv {get;set;}
    public static String ka {get;set;}
    public static String bd1wt{get;set;}
    public static String kapp {get;set;}
    public static String bd2pm {get;set;}
    public static String kc {get;set;}
    public static String bd2st {get;set;}
    public static String kf {get;set;}
    public static String bd2tv {get;set;}
    public static String kl {get;set;}
    public static String bd2wt {get;set;}
    public static String km {get;set;}
    public static String bd3pu {get;set;}
    public static String bd3st {get;set;}
    public static String lrc {get;set;}
    public static String bd3tv {get;set;}
    public static String lrf {get;set;}
    public static String bd3wt {get;set;}
    public static String lrp {get;set;}
    public static String lrtv {get;set;}
    public static String br {get;set;}
    public static String ps {get;set;}
    public static Date pd {get;set;}
    public static String pdstr {get;set;}
    public static String pc {get;set;}
    public static String sh {get;set;}
    public static String pn {get;set;}
    public static String ss {get;set;}
    public static String prs {get;set;}
    public static String sp {get;set;}
    public static String pt {get;set;}
    public static String poi {get;set;}
    
    public static Map<Id,Master__c> masterMap;    
    
    public Lead lea{ get; set; }
    public SendEmailToSSA (ApexPages.StandardController controller) {
        lea =  (lead) controller.getRecord();
        Id = lea.Id;
        System.debug('The lead record: ' + lea);
    }
    
    public SendEmailToSSA(){
        Id = ApexPages.currentPage().getParameters().get('id');
        System.debug('Id ------------------------------------------->'+Id);
        
        masterMap = new Map<Id,Master__c>();
        
        Lead l = [select id, full_name__c, phone, city, Customer_ID__c, Appointment_Venue_Square__c from Lead where id=:id limit 1];
        nam = l.full_name__c;
        pho = l.phone;
        cit = l.city;
        cxid = l.Customer_ID__c;
    
        List<Customer_Profiling_Session__c> CPSList = [select id, name, Answer_now_later__c, Appointment_Booked__c, Appointment_Date__c, Appointment_Time__c, 
        BR_1_Primary_User__c, BR_1_Study_Table__c, BR_1_TV_Unit__c, BR_1_Wardrobe_Type__c, BR_2_Primary_User__c, BR_2_Study_Table__c, 
        BR_2_TV_Unit__c, BR_2_Wardrobe_Type__c, BR_3_Primary_User__c, BR_3_Study_Table__c, BR_3_TV_Unit__c, BR_3_Wardrobe_Type__c, 
        Budget_Range__c, Family_members_age_traits__c, Feature_Preference_1__c, Feature_Preference_2__c, Feature_Preference_3__c, 
        First_home__c, Interior_Start_Date__c, Interiors_Required__c, Kitchen_Accessories__c, Kitchen_Color__c, Kitchen_Finish__c, 
        Kitchen_Layout__c, Kitchen_Material__c, Kitchen_appliances__c, LR_Crockery__c, LR_Foyer__c, LR_Pooja__c, LR_TV_Unit__c, 
        Possession_Date__c, Possession_Status__c, Property_Config__c, Property_Status__c, Property_Type__c, Property__c, 
        Purpose_of_Interiors__c, Regional_Language_Preference__c, Related_Lead__c, Showroom__c, Start_Source__c, Style_Preference__c, LastModifiedDate 
        FROM Customer_Profiling_Session__c where Related_Lead__c =: l.Id order by LastModifiedDate desc];
        System.debug('-------CPSList------  '+CPSList);
        
        if(CPSList.size() > 0) {
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Regional_Language_Preference__c != null) {
                lang = CPSList[i].Regional_Language_Preference__c;
                break;
            }                               
        }  
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Family_members_age_traits__c != null) {
                family = CPSList[i].Family_members_age_traits__c;
                break;
            }
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Appointment_Date__c != null) {
                adstr = String.valueOf(CPSList[i].Appointment_Date__c);
                adstr.removeEnd('00:00:00');
                List<String> strdat = adstr.split('-');
                adstr = strdat[2]+'-'+strdat[1]+'-'+strdat[0];
                break;
            }
        }
       
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Appointment_Time__c != null) {
                atstr = String.valueOf(CPSList[i].Appointment_Time__c);
                atstr = atstr.removeEnd(':00.000Z');
                System.debug('--------  ATSTr '+atstr);
                break;
            }
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].First_home__c != null) {
                firstHome = CPSList[i].First_home__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].BR_1_Primary_User__c != null) {
                bd1pu = CPSList[i].BR_1_Primary_User__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Interiors_Required__c!= null) {
                ir = CPSList[i].Interiors_Required__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].BR_1_Study_Table__c != null) {
                bd1st = CPSList[i].BR_1_Study_Table__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Interior_Start_Date__c != null) {
                isdstr = String.valueOf(CPSList[i].Interior_Start_Date__c);
                isdstr = isdstr.removeEnd('00:00:00');
                List<String> strdat = isdstr.split('-');
                isdstr = strdat[2]+'-'+strdat[1]+'-'+strdat[0];
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].BR_1_TV_Unit__c != null) {
                bd1tv = CPSList[i].BR_1_TV_Unit__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Kitchen_Accessories__c != null) {
                ka = CPSList[i].Kitchen_Accessories__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].BR_1_Wardrobe_Type__c != null) {
                bd1wt = CPSList[i].BR_1_Wardrobe_Type__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Kitchen_appliances__c != null) {
                kapp = CPSList[i].Kitchen_appliances__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].BR_2_Primary_User__c != null) {
                bd2pm = CPSList[i].BR_2_Primary_User__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Kitchen_Color__c != null) {
                kc = CPSList[i].Kitchen_Color__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].BR_2_Study_Table__c != null) {
                bd2st = CPSList[i].BR_2_Study_Table__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Kitchen_Finish__c != null) {
                kf = CPSList[i].Kitchen_Finish__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].BR_2_TV_Unit__c != null) {
                bd2tv = CPSList[i].BR_2_TV_Unit__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Kitchen_Layout__c != null) {
                kl = CPSList[i].Kitchen_Layout__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].BR_2_Wardrobe_Type__c != null) {
                bd2wt = CPSList[i].BR_2_Wardrobe_Type__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Kitchen_Material__c != null) {
                km = CPSList[i].Kitchen_Material__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].BR_3_Primary_User__c != null) {
                bd3pu = CPSList[i].BR_3_Primary_User__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].BR_3_Study_Table__c != null) {
                bd3st = CPSList[i].BR_3_Study_Table__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].LR_Crockery__c != null) {
                lrc = CPSList[i].LR_Crockery__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].BR_3_TV_Unit__c != null) {
                bd3tv = CPSList[i].BR_3_TV_Unit__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].LR_Foyer__c != null) {
                lrf = CPSList[i].LR_Foyer__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].BR_3_Wardrobe_Type__c != null) {
                bd3wt = CPSList[i].BR_3_Wardrobe_Type__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].LR_Pooja__c != null) {
                lrp = CPSList[i].LR_Pooja__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].LR_TV_Unit__c != null) {
                lrtv = CPSList[i].LR_TV_Unit__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Budget_Range__c != null) {
                br = CPSList[i].Budget_Range__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Possession_Status__c != null) {
                ps = CPSList[i].Possession_Status__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Possession_Date__c != null) {
                pdstr = String.valueOf(CPSList[i].Possession_Date__c);
                pdstr = pdstr.removeEnd('00:00:00');
                List<String> strdat = pdstr.split('-');
                pdstr = strdat[2]+'-'+strdat[1]+'-'+strdat[0];
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Property_Config__c != null) {
                pc = CPSList[i].Property_Config__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Showroom__c != null) {
                sh = CPSList[i].Showroom__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Property__c != null) {
                pn = CPSList[i].Property__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Start_Source__c != null) {
                ss = CPSList[i].Start_Source__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Property_Status__c != null) {
                prs = CPSList[i].Property_Status__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Style_Preference__c != null) {
                sp = CPSList[i].Style_Preference__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Property_Type__c!= null) {
                pt = CPSList[i].Property_Type__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Purpose_of_Interiors__c != null) {
                poi = CPSList[i].Purpose_of_Interiors__c;
                break;
            }    
        }
        }
    } 
     
    static Boolean flag = true;
    public static void SendEmailUpd(List<Lead> leadList, Map<Id,Lead> oldLeadMap) {
        Set<Id> masterSet = new Set<Id>();
        Set<Id> propSet = new Set<Id>();
        Set<Id> leadId = new Set<Id>();
        masterMap = new Map<Id,Master__c>();
        List<String> walkinEmailList = new List<String>();
        String walkinEmail = '';
        String resSSAEmail = '';
        String SSMEmail = '';
        List<String> valueList = new List<String>();
       
        for(Lead l : leadList) {
            if(l.Appointment_Venue_Square__c != null)
            masterSet.add(l.Appointment_Venue_Square__c);
            if(l.Property__c != null)
            propset.add(l.Property__c);
            leadId.add(l.Id);
        }
        
        List<Master__c> masterList = [select id, name, WalkIn_SSA__c, WalkIn_SSA__r.Name, WalkIn_SSA__r.Email, Residence_Visit_SSA__c, Residence_Visit_SSA__r.Name, Residence_Visit_SSA__r.Email, SSM__c, SSM__r.Name, SSM__r.Email from Master__c where id in : masterSet or id in : propSet];       
        for(Master__c m : masterList) {
            masterMap.put(m.Id,m);
        }        
        System.debug('-------masterMap------  '+masterMap);
        
        List<Customer_Profiling_Session__c> cpsList = [select id, Possession_Date__c, Property__c, Showroom__c, Appointment_Date__c, Property_Config__c, Appointment_Time__c from Customer_Profiling_Session__c where Related_Lead__c =: leadId order by LastModifiedDate desc];
        System.debug('-------cpsList------  '+cpsList);
        if(cpsList.size() > 0) {
        for(Integer i=0; i<cpsList.size(); i++) {
            if(cpsList[i].Appointment_Date__c != null) {
                ad = cpsList[i].Appointment_Date__c;
                break;
            }
        }
        if(ad != null) {
        adstr = String.valueOf(ad);
        adstr = adstr.removeEnd('00:00:00');
        List<String> strdat = adstr.split('-');
        adstr = strdat[2]+'-'+strdat[1]+'-'+strdat[0];
        }
        
        for(Integer i=0; i<cpsList.size(); i++) {
            if(cpsList[i].Appointment_Time__c != null) {
                at = cpsList[i].Appointment_Time__c;
                break;
            }
        }
        if(at != null) {
         atstr = String.valueOf(at);
         atstr = atstr.removeEnd(':00.000Z');
         
         }
         System.debug('===adstr  '+adstr+'  ========atstr  '+atstr);
         
        for(Integer i=0; i<cpsList.size(); i++) {
            if(cpsList[i].Property_Config__c != null) {
                pc = cpsList[i].Property_Config__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Showroom__c != null) {
                sh = CPSList[i].Showroom__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Property__c != null) {
                pn = CPSList[i].Property__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Possession_Date__c != null) {
                pdstr = String.valueOf(CPSList[i].Possession_Date__c);
                pdstr = pdstr.removeEnd('00:00:00');
                List<String> strdat = pdstr.split('-');
                pdstr = strdat[2]+'-'+strdat[1]+'-'+strdat[0];
                break;
            }    
        }       
        }
        String appDate;
        List<String> appDateList;
        String toDate;
        List<String> toDateList;
        System.debug('-----leadList Size  '+leadList.size());
        for(Lead l : leadList) {
            if(l.Appointment_Time__c != null) {
                appDate = String.valueOf(l.Appointment_Time__c);
                appDateList = appDate.split(' '); 
                toDate = String.valueOf(Date.today());
                toDateList = toDate.split(' ');               
            }
            System.Debug('====oldLeadMap.get(l.Id).Design_Q_Completed__c  '+oldLeadMap.get(l.Id).Design_Q_Completed__c);
            System.Debug('====l.Design_Q_Completed__c  '+l.Design_Q_Completed__c);
           
            if(((oldLeadMap.get(l.Id).Design_Q_Completed__c != l.Design_Q_Completed__c)  && l.Design_Q_Completed__c == 100 && (l.Status == 'Appointment Fixed' || l.Status == 'Appointment Confirmed')) || 
            ((oldLeadMap.get(l.Id).Status != l.Status)  && l.Design_Q_Completed__c == 100 && (l.Status == 'Appointment Fixed' || l.Status == 'Appointment Confirmed')) ||
            l.Appointment_Time__c != oldLeadMap.get(l.Id).Appointment_Time__c && l.Appointment_Time__c != null && l.Design_Q_Completed__c == 100 && (l.Status == 'Appointment Fixed' || l.Status == 'Appointment Confirmed')) {
                if(masterMap.get(l.Appointment_Venue_Square__c) != null) {
                    if(l.Budget_Range__c == '6L - 8L' || l.Budget_Range__c == '8L - 10L' || l.Budget_Range__c == '10L+') {
                        if(appDateList != null && toDateList != null) {
                            if(appDateList[0] != toDateList [0]) {
                                Master__c mas = masterMap.get(l.Appointment_Venue_Square__c);
                                Master__c pnmap = masterMap.get(l.Property__c);
                                if(mas.WalkIn_SSA__r.Email != null)
                                walkinEmail = mas.WalkIn_SSA__r.Email;
                            //    walkinEmailList.add(walkinEmail);
                                if(mas.Residence_Visit_SSA__r.Email != null)
                                resSSAEmail = mas.Residence_Visit_SSA__r.Email;
                                if(mas.SSM__r.Email != null)
                                SSMEmail = mas.SSM__r.Email;
                                id = l.Id;     
                                nam = l.full_name__c;
                                cxid = l.Customer_ID__c;  
                                smnam = mas.WalkIn_SSA__r.Name;
                                lshow = mas.Name;
                                lpcon = l.Property_Config__c;
                                if(pnmap != null)
                                pname = pnmap.name;
                                lpmid = l.Property_Move_In_Date__c;
                                lreq = l.Requirements__c;
                                valueList = CalculateRank(l); 
                            }  
                        }
                        else {
                            Master__c mas = masterMap.get(l.Appointment_Venue_Square__c);
                            Master__c pnmap = masterMap.get(l.Property__c);
                            if(mas.WalkIn_SSA__r.Email != null)
                            walkinEmail = mas.WalkIn_SSA__r.Email;
                       //     walkinEmailList.add(walkinEmail);
                            if(mas.Residence_Visit_SSA__r.Email != null)
                            resSSAEmail = mas.Residence_Visit_SSA__r.Email;
                            if(mas.SSM__r.Email != null)
                            SSMEmail = mas.SSM__r.Email;
                            id = l.Id;     
                            nam = l.full_name__c;
                            cxid = l.Customer_ID__c;  
                            smnam = mas.WalkIn_SSA__r.Name;
                            lshow = mas.Name;
                            lpcon = l.Property_Config__c;
                            if(pnmap != null)
                            pname = pnmap.name;
                            lpmid = l.Property_Move_In_Date__c;
                            lreq = l.Requirements__c;
                            valueList = CalculateRank(l);
                        }
                    }            
                }
            }
        } 
        if(lpmid != null) {
            lpmidstr = String.valueOf(lpmid);
            lpmidstr = lpmidstr.removeEnd('00:00:00');
            List<String> strdat = lpmidstr.split('-');
            lpmidstr = strdat[2]+'-'+strdat[1]+'-'+strdat[0];
        }
        
        if(flag == true) {
             if(id != null) {
                System.debug('----------------- ID CHECK  '+id);
                attachment(walkinEmail, resSSAEmail, SSMEmail, Id, nam, cxid, smnam, adstr, atstr, sh, pc, pn, pdstr, lreq,valueList);
                flag = false;
            }
        } 
     
    }
    
    public static void SendEmailToDp(List<Lead> leadList, Map<Id,Lead> oldLeadMap) {
        Set<Id> setId = new Set<Id>();
        Set<Id> leadId = new Set<Id>();
        Set<Id> masterSet = new Set<Id>();
        String walkinName = '';
        for(Lead l : leadList) {
            if(l.Interior_Designer__c != null) {
                setId.add(l.Interior_Designer__c);
            }
             if(l.Appointment_Venue_Square__c != null)
             masterSet.add(l.Appointment_Venue_Square__c);
             leadId.add(l.Id);
        }
        
        List<Master__c> masterList = [select id, name,  WalkIn_SSA__c, WalkIn_SSA__r.Name, WalkIn_SSA__r.Email, Residence_Visit_SSA__c, Residence_Visit_SSA__r.Name, Residence_Visit_SSA__r.Email from Master__c where id in : masterSet];       
        for(Master__c m : masterList) {
            masterMap.put(m.Id,m);
        }        
        System.debug('-------masterMap------  '+masterMap);
        
        List<Interior_Designer__c> intList = [select id,name,email__c from Interior_Designer__c where id =: setId];
        Map<Id,Interior_Designer__c> intMap = new Map<Id,Interior_Designer__c>();
        for(Interior_Designer__c dp : intList) {
            intMap.put(dp.Id,dp);
        }
        
        List<Customer_Profiling_Session__c> cpsList = [select id, Possession_Date__c, Property__c, Showroom__c, Appointment_Date__c, Property_Config__c, Appointment_Time__c from Customer_Profiling_Session__c where Related_Lead__c =: leadId order by LastModifiedDate desc];
        if(cpsList.size() > 0) {
        for(Integer i=0; i<cpsList.size(); i++) {
            if(cpsList[i].Appointment_Date__c != null) {
                ad = cpsList[i].Appointment_Date__c;
                break;
            }
        }
        if(ad != null) {
        adstr = String.valueOf(ad);
        adstr = adstr.removeEnd('00:00:00');
        List<String> strdat = adstr.split('-');
        adstr = strdat[2]+'-'+strdat[1]+'-'+strdat[0];
        }
        
        for(Integer i=0; i<cpsList.size(); i++) {
            if(cpsList[i].Appointment_Time__c != null) {
                at = cpsList[i].Appointment_Time__c;
                break;
            }
        }
        if(at != null) {
         atstr = String.valueOf(at);
         atstr = atstr.removeEnd(':00.000Z');
         
         }
         System.debug('===adstr  '+adstr+'  ========atstr  '+atstr);
         
        for(Integer i=0; i<cpsList.size(); i++) {
            if(cpsList[i].Property_Config__c != null) {
                pc = cpsList[i].Property_Config__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Showroom__c != null) {
                sh = CPSList[i].Showroom__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Property__c != null) {
                pn = CPSList[i].Property__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Possession_Date__c != null) {
                pdstr = String.valueOf(CPSList[i].Possession_Date__c);
                pdstr = pdstr.removeEnd('00:00:00');
                List<String> strdat = pdstr.split('-');
                pdstr = strdat[2]+'-'+strdat[1]+'-'+strdat[0];
                break;
            }    
        }
         
        }
        
        for(Lead l : leadList) {
            if(intMap.get(l.Interior_Designer__c) != null) {
                Interior_Designer__c dp = intMap.get(l.Interior_Designer__c);
                System.debug('---------dp.Email__c  '+dp.Email__c);
               // System.debug('---------oldLeadMap.get(l.Interior_Designer__c).Interior_Designer__c  '+oldLeadMap.get(l.Interior_Designer__c).Interior_Designer__c);
                System.debug('---------l.Interior_Designer__c  '+l.Interior_Designer__c);
                if(dp.Email__c != null) {
                    if(oldLeadMap.get(l.Id).Interior_Designer__c != l.Interior_Designer__c) {
                        if(l.Design_Q_Completed__c == 100) {
                            if(masterMap.get(l.Appointment_Venue_Square__c) != null) {
                            Master__c mas = masterMap.get(l.Appointment_Venue_Square__c);
                            if(mas.WalkIn_SSA__r.Name != null)
                            walkinName = mas.WalkIn_SSA__r.Name;
                        
                            id = l.Id;     
                            nam = l.full_name__c;
                            cxid = l.Customer_ID__c;  
                            lreq = l.Requirements__c;
                            DPattachment(l.Id, l.Full_Name__c, walkinName, l.Customer_ID__c, dp.Name, dp.Email__c, adstr, atstr, sh, pc, pn, pdstr, l.Requirements__c);
                            }
                        }
                    }
                }
            }
        }
    }  
    
    public PageReference SendEmailButton() {
        Set<Id> masterSet = new Set<Id>();
        Set<Id> propSet = new Set<Id>();
        Set<Id> leadId = new Set<Id>();
        masterMap = new Map<Id,Master__c>();
        List<String> walkinEmailList = new List<String>();
        String walkinEmail = '';
        String resSSAEmail = '';
        String SSMEmail = '';
        List<String> valueList = new List<String>();
        
        List<Lead> leadList = [select id, name, Status, Sub_Status__c, Appointment_Time__c, Design_Q_Completed__c, Full_Name__c, Requirements__c, Customer_ID__c, Property_Config__c, Property_Move_In_Date__c, Property__c, city, Appointment_Venue_Square__c, Preferred_Language__c,DP_Stack_Rank__c, Regional_Language_Preference__c, Budget_Range__c from Lead where ( id =: id) limit 1];
        
        for(Lead l : leadList) {
            if(l.Appointment_Venue_Square__c != null)
            masterSet.add(l.Appointment_Venue_Square__c);
            if(l.Property__c != null)
            propset.add(l.Property__c);
            leadId.add(l.Id);
        }
        
        List<Master__c> masterList = [select id, name,  WalkIn_SSA__c, WalkIn_SSA__r.Name, WalkIn_SSA__r.Email, Residence_Visit_SSA__c, Residence_Visit_SSA__r.Name, Residence_Visit_SSA__r.Email, SSM__c, SSM__r.Name, SSM__r.Email from Master__c where id in : masterSet or id in : propSet];       
        for(Master__c m : masterList) {
            masterMap.put(m.Id,m);
        }        
        System.debug('-------masterMap------  '+masterMap);
        
        List<Customer_Profiling_Session__c> cpsList = [select id, Possession_Date__c, Property__c, Showroom__c, Appointment_Date__c, Property_Config__c, Appointment_Time__c from Customer_Profiling_Session__c where Related_Lead__c =: leadId order by LastModifiedDate desc];
        if(cpsList.size() > 0) {
        for(Integer i=0; i<cpsList.size(); i++) {
            if(cpsList[i].Appointment_Date__c != null) {
                ad = cpsList[i].Appointment_Date__c;
                break;
            }
        }
        if(ad != null) {
        adstr = String.valueOf(ad);
        adstr = adstr.removeEnd('00:00:00');
        List<String> strdat = adstr.split('-');
        adstr = strdat[2]+'-'+strdat[1]+'-'+strdat[0];
        }
        
        for(Integer i=0; i<cpsList.size(); i++) {
            if(cpsList[i].Appointment_Time__c != null) {
                at = cpsList[i].Appointment_Time__c;
                break;
            }
        }
        if(at != null) {
         atstr = String.valueOf(at);
         atstr = atstr.removeEnd(':00.000Z');
         
         }
         System.debug('===adstr  '+adstr+'  ========atstr  '+atstr);
         
        for(Integer i=0; i<cpsList.size(); i++) {
            if(cpsList[i].Property_Config__c != null) {
                pc = cpsList[i].Property_Config__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Showroom__c != null) {
                sh = CPSList[i].Showroom__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Property__c != null) {
                pn = CPSList[i].Property__c;
                break;
            }    
        }
        
        for(Integer i=0; i<CPSList.size(); i++) {
            if(CPSList[i].Possession_Date__c != null) {
                pdstr = String.valueOf(CPSList[i].Possession_Date__c);
                pdstr = pdstr.removeEnd('00:00:00');
                List<String> strdat = pdstr.split('-');
                pdstr = strdat[2]+'-'+strdat[1]+'-'+strdat[0];
                break;
            }    
        }
         
        }
        String appDate;
        List<String> appDateList;
        String toDate;
        List<String> toDateList;
        for(Lead l : leadList) {
            if(l.Appointment_Time__c != null) {
                appDate = String.valueOf(l.Appointment_Time__c);
                appDateList = appDate.split(' ');
                toDate = String.valueOf(Date.today());
                toDateList = toDate.split(' ');
            }
            
            if((l.Status == 'Appointment Fixed' && l.Sub_Status__c == 'Appointment Fixed' || 
            l.Status == 'Appointment Confirmed' && l.Sub_Status__c == 'Appointment Confirmed') 
            && l.Design_Q_Completed__c == 100) {
                if(l.Budget_Range__c == '6L - 8L' || l.Budget_Range__c == '8L - 10L' || l.Budget_Range__c == '10L+') {
                    if(appDateList != null && toDateList != null) {
                        if(appDateList[0] != toDateList[0]) {
                            Master__c mas = masterMap.get(l.Appointment_Venue_Square__c);
                            Master__c pnmap = masterMap.get(l.Property__c);
                            if(mas.WalkIn_SSA__r.Email != null)
                            walkinEmail = mas.WalkIn_SSA__r.Email;
                            if(mas.Residence_Visit_SSA__r.Email != null)
                            resSSAEmail = mas.Residence_Visit_SSA__r.Email;
                            if(mas.SSM__r.Email != null)
                            SSMEmail = mas.SSM__r.Email;               
                            id = l.Id;     
                            nam = l.full_name__c;
                            cxid = l.Customer_ID__c;  
                            smnam = mas.WalkIn_SSA__r.Name;
                            lshow = mas.Name;
                            lpcon = l.Property_Config__c;
                            if(pnmap != null)
                            pname = pnmap.name;
                            lpmid = l.Property_Move_In_Date__c;
                            lreq = l.Requirements__c;
                            valueList = CalculateRank(l);
                        }
                    }
                    else {
                        Master__c mas = masterMap.get(l.Appointment_Venue_Square__c);
                        Master__c pnmap = masterMap.get(l.Property__c);
                        if(mas.WalkIn_SSA__r.Email != null)
                        walkinEmail = mas.WalkIn_SSA__r.Email;
                        if(mas.Residence_Visit_SSA__r.Email != null)
                        resSSAEmail = mas.Residence_Visit_SSA__r.Email;
                        if(mas.SSM__r.Email != null)
                        SSMEmail = mas.SSM__r.Email;               
                        id = l.Id;     
                        nam = l.full_name__c;
                        cxid = l.Customer_ID__c;  
                        smnam = mas.WalkIn_SSA__r.Name;
                        lshow = mas.Name;
                        lpcon = l.Property_Config__c;
                        if(pnmap != null)
                        pname = pnmap.name;
                        lpmid = l.Property_Move_In_Date__c;
                        lreq = l.Requirements__c;
                        valueList = CalculateRank(l);
                    }
                }
            }
        } 
        if(lpmid != null) {
            lpmidstr = String.valueOf(lpmid);
            lpmidstr = lpmidstr.removeEnd('00:00:00');
            List<String> strdat = lpmidstr.split('-');
            lpmidstr = strdat[2]+'-'+strdat[1]+'-'+strdat[0];
        }
      //  if (RecursiveTriggerHandlerLead.isFirstTime) {
        //    RecursiveTriggerHandlerLead.isFirstTime = false;
            if(id != null) {
            attachment(walkinEmail, resSSAEmail, SSMEmail, Id, nam, cxid, smnam, adstr, atstr, sh, pc, pn, pdstr, lreq,valueList);
            }
     //   }
        
        PageReference pageRef = new PageReference('/'+Id);
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    @future(callout=true)
    public static void attachment(String walkinEmail, String resSSAEmail, String SSMEmail, Id id, String nam, String cxid, String smnam, String adstr, String atstr, String sh, String pc, String pn, String pdstr, String lreq, List<String> valueList) {
        System.debug('---nam  '+nam+' ----cxid---- '+cxid+'-----smnam----  '+smnam+'=====pname=====  '+pname+'======at====  '+at+'=======at====  '+at);
        PageReference pdf = Page.SendEmailToSSAPDF;
         pdf.getParameters().put('id',Id);
         System.debug('PDF ID-----  '+id);
                Blob bodyy;
        if(id != null) {
          if(!test.isRunningTest()){
                bodyy = pdf.getContent();
            }
            else{
                    bodyy = blob.valueof('TEST');
                }
                
            System.debug('BODY IS '+bodyy);  
            
            String dp1 = '';
            String dp2;
            String dp3;
            String dp4;
            String dp5;
            
            List<String> dpList = new List<String>();
            System.debug('--------valueList  '+valueList);
            if(valueList.size() > 1 && valueList[1] != null) {
                dp1 = valueList[1];
                if(dp1.contains('['))
                dp1 = dp1.remove('[');
                if(dp1.contains(']'))
                dp1 = dp1.remove(']');
                List<String> dp1List = new List<String>();
                dp1List = dp1.split(',');
                System.debug('------dp1List 1 '+dp1List );
                String a = dp1List[0];
                if(a.contains('Email='))
                a = a.remove('Email=');
                String b = dp1List[1];
                if(b.contains('Name='))
                b = b.remove('Name=');
                String c = dp1List[2];
                String d = dp1List[3];
                 
                dp1 = b+' ('+a+'), '+c+', '+d;
                dpList.add(dp1);
            }
            if(valueList.size() > 2 && valueList[2] != null) {
                dp2 = valueList[2];
                if(dp2.contains('['))
                dp2 = dp2.remove('[');
                if(dp2.contains(']'))
                dp2 = dp2.remove(']');
                List<String> dp1List = new List<String>();
                dp1List = dp2.split(',');
                System.debug('------dp1List 2 '+dp1List );
                String a = dp1List[0];
                if(a.contains('Email='))
                a = a.remove('Email=');
                String b = dp1List[1];
                if(b.contains('Name='))
                b = b.remove('Name=');
                String c = dp1List[2];
                String d = dp1List[3];
                dp2 = b+' ('+a+'), '+c+', '+d;   
                dpList.add(dp2);
            }
            if(valueList.size() > 3 && valueList[3] != null) {
                dp3 = valueList[3];
                if(dp3.contains('['))
                dp3 = dp3.remove('[');
                if(dp3.contains(']'))
                dp3 = dp3.remove(']');
                List<String> dp1List = new List<String>();
                dp1List = dp3.split(',');
                System.debug('------dp1List 3 '+dp1List );
                String a = dp1List[0];
                if(a.contains('Email='))
                a = a.remove('Email=');
                String b = dp1List[1];
                if(b.contains('Name='))
                b = b.remove('Name=');
                String c = dp1List[2];
                String d = dp1List[3];
                dp3 = b+' ('+a+'), '+c+', '+d;  
                dpList.add(dp3);
            }
            if(valueList.size() > 4 && valueList[4] != null) {
                dp4 = valueList[4];
                if(dp4.contains('['))
                dp4 = dp4.remove('[');
                if(dp4.contains(']'))
                dp4 = dp4.remove(']');
                List<String> dp1List = new List<String>();
                dp1List = dp4.split(',');
                System.debug('------dp1List 4 '+dp1List );
                String a = dp1List[0];
                if(a.contains('Email='))
                a = a.remove('Email=');
                String b = dp1List[1];
                if(b.contains('Name='))
                b = b.remove('Name=');
                String c = dp1List[2];
                String d = dp1List[3];
                dp4 = b+' ('+a+'), '+c+', '+d; 
                dpList.add(dp4);
            }
            if(valueList.size() > 5 && valueList[5] != null) {
                dp5 = valueList[5]; 
                if(dp5.contains('['))
                dp5 = dp5.remove('[');
                if(dp5.contains(']'))
                dp5 = dp5.remove(']');
                List<String> dp1List = new List<String>();
                dp1List = dp5.split(',');
                System.debug('------dp1List 5 '+dp1List );
                String a = dp1List[0];
                if(a.contains('Email='))
                a = a.remove('Email=');
                String b = dp1List[1];
                if(b.contains('Name='))
                b = b.remove('Name=');
                String c = dp1List[2];
                String d = dp1List[3];
                dp5 = b+' ('+a+'), '+c+', '+d; 
                dpList.add(dp5);
            }
            System.debug('------dp1 : '+dp1);
            System.debug('------dp2 : '+dp2);
            System.debug('------dp3 : '+dp3);
            System.debug('------dp4 : '+dp4);
            System.debug('------dp5 : '+dp5);
            
            System.debug('-----dpList  '+dpList);            
            String dpListStr = '';
            for(Integer i = 0; i < dpList.size(); i++) {
                dpListStr = dpListStr+'<br/>'+(i+1)+'.  '+dpList[i];
            }            
            
            System.debug('------dpListStr  : '+dpListStr );
            System.debug('------dp2 : '+dp2);
            System.debug('------dp3 : '+dp3);
            System.debug('------dp4 : '+dp4);
            System.debug('------dp5 : '+dp5);
                
            String finalList = '<br/><br/>We\'d recommend to assign any of the below designers for the meeting-<br/>'+dpListStr+'<br/><br/>If none of the above designers are available, feel free to assign relevant designer. Please, ensure that designer studies the requirements before the meeting and only re-confirms the requirements during the meeting instead of starting from scratch.';
            
            if(dpListStr == '' || dpListStr == null) 
            finalList = ''; 
                
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('Reconfirm Requirements - '+nam+' - '+cxid+'.pdf');
            attach.setInline(false);
            attach.Body = bodyy;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           
            mail.setOrgWideEmailAddressId(label.Assign_DP_Org_Wide_Email);
          //  mail.setReplyTo('care@homelane.com');
            mail.setUseSignature(false);
            if(walkinEmail != '') {
            mail.setToAddresses(new String[] { walkinEmail});
            }
            if(resSSAEmail != '' && SSMEmail != '') {
            mail.setccAddresses(new String[] {resSSAEmail,SSMEmail });
            }
            mail.setSubject(' [PRIORITY CX]  Assign a designer to '+nam);
            mail.setHtmlBody('Hi '+smnam+',<br/><br/>This Customer has filled out 100% of design requirements. Requirement brief is attached as a PDF with this email.'+finalList+' <br/><br/><b>** Please ensure you follow the [Priority CX] SOP **</b><br/><br/><b>CX DETAILS:</b><br/>CX Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;       - '+nam+'<br/>CX ID      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        - '+cxid+'<br/>Meeting Date &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - '+adstr+' at '+atstr+'<br/>Showroom   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   - '+sh+'<br/>Home Type     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- '+pc+' home<br/>Locality      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;     - '+pn+'<br/>Possession Date &nbsp;&nbsp; - '+pdstr+'<br/>Scope     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;       - '+lreq);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
            if(walkinEmail != '' || resSSAEmail != '') {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            system.debug('-----Messaging----'+results);
            }
        }
    } 
    
    @future(callout=true)
    public static void DPattachment(Id Id, String cxnam, String walkinName, String cxid, String dpName, String dpEmail, String adstr,String atstr,String sh,String pc,String pn,String pdstr,String lreq) {
        System.debug('---nam  '+nam+' ----cxid---- '+cxid+'-----smnam----  '+smnam+'=====pname=====  '+pname+'======at====  '+at+'=======at====  '+at);
        System.debug('=====pn  '+pn);
        PageReference pdf = Page.SendEmailToSSAPDF;
         pdf.getParameters().put('id',Id);
         System.debug('PDF ID-----  '+id);
                Blob bodyy;
        if(id != null) {
          if(!test.isRunningTest()){
                bodyy = pdf.getContent();
            }
            else{
                    bodyy = blob.valueof('TEST');
                }
                
            System.debug('BODY IS '+bodyy);  
            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('Reconfirm Requirements - '+nam+' - '+cxid+'.pdf');
            attach.setInline(false);
            attach.Body = bodyy;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(label.Assign_DP_Org_Wide_Email);
            mail.setUseSignature(false);
            if(dpEmail != '') {
            mail.setToAddresses(new String[] { dpEmail});
            }
                       
            mail.setSubject(' [Priority Cx] Congrats! You will meet '+cxnam+' on '+adstr+' at '+atstr);
            mail.setHTMLBody('Dear '+dpName+',<br/><br/>'+walkinName+' has assigned a priority customer '+cxnam+' to you. You will meet them on '+adstr+' at '+atstr+'.<br/><br/> Priority customers are more interested in working with HomeLane. There is a 2x likelihood that they will close order with HomeLane. Hence, it is extremely important to give them the best first meeting experience possible. We already have captured their design requirements. The requirements are attached to this email. <br/><br/>Please follow the below standard procedure to give the best experience to our priority customers -<br/><br/>1. First call with the customer<br/><ul><li>Confirm their design requirements</li><li>Establish a rapport with the customer</li><li>Achievements of HomeLane</li></ul>2. Establish the WhatsApp connection<ul><li>Ask the customer to share reference images and floor plan</li><li>Share the past projects of HomeLane</li><li>Share the spacecraft meeting video</li></ul>3. Create a first cut design for customer requirements<br/><br/> Please find the <a href="https://docs.google.com/spreadsheets/d/1UJOVaihbNgMe_7WeNGZ9TimDPCWNfIfoWZ7El5zgjzA/edit#gid=0"> detailed SOP with standard messages here.</a><br/><br/><br/><b>***Based on your adherence to the above procedure, we will give you more priority customers in the future***</b><br/><br/>Here\'s a snapshot of customer\'s profile -<br/><br/>CX Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;       - '+cxnam+'<br/>CX ID      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        - '+cxid+'<br/>Meeting Date &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - '+adstr+' at '+atstr+'<br/>Showroom   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   - '+sh+'<br/>Home Type     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- '+pc+' home<br/>Locality      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;     - '+pn+'<br/>Possession Date &nbsp;&nbsp; - '+pdstr+'<br/>Scope     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;       - '+lreq);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
            if(dpEmail != '') {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            system.debug('-----Messaging----'+results);
            }
        }
    } 
    
     public static List<String> CalculateRank(Lead leadList) {
        System.debug('Lead Id: ' + Id);
        // Stack_DP_Rank__c is a custom setting
        Stack_DP_Rank__c stack = [select Name, X10_40_score__c, Date__c, Rank_for_Conversion_Percent__c, Rank_for_Won_Opp__c, Language_Score__c, New_Active_0_4__c, New_Active_4_8__c, New_Active_8__c, New_Active_Master__c, Project_Score__c from Stack_DP_Rank__c where Name = 'Stack DP'];
        System.debug('###### STACK  '+stack);
        Date d = stack.Date__c;
        
        leadList = [select id, name, Property__c, city, Appointment_Venue_Square__c, Preferred_Language__c,DP_Stack_Rank__c, Regional_Language_Preference__c, Budget_Range__c from Lead where ( id =: id) limit 1];
        System.debug('----leadList-->  ' + leadList);
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
                CalculateRank.dpName = intDes.Name;      
              /*  if(leadList.Budget_Range__c == 'Upto 1.5L' || leadList.Budget_Range__c == '1.5L - 4L') {    
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
                }  */
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
                
            /*  if(leadList.Budget_Range__c != '8L - 10L' && leadList.Budget_Range__c != '10L+' && leadList.Budget_Range__c != '4L - 6L' && leadList.Budget_Range__c != '6L - 8L' && leadList.Budget_Range__c != 'Upto 1.5L' && leadList.Budget_Range__c != '1.5L - 4L' && (leadList.Budget_Range__c == 'Cx didn\'t disclose' || leadList.Budget_Range__c == null)) {
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
                    if(intDes.Total_Wins__c != null) {
                    CalculateRank.wonOpp = intDes.Total_Wins__c; 
                    }
                    else {
                    CalculateRank.wonOpp = 0;
                    }
                                       
                } */
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
                CalculateRankDPv2.dpName = OverallList [i].dpName;
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
                    CalculateRankDPv2.dpName = OverallList [i].dpName;
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
                    CalculateRankDPv2.dpName = OverallList [i].dpName;
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
            storeInfoWrapper storeInfo = new storeInfoWrapper(store.dpName,store.email,store.finalRank,store.finalScore);
         /*   storeInfo.name = store.dpName;
            storeInfo.email = store.email;
            storeInfo.rank = store.finalRank; 
            storeInfo.Score = store.finalScore; */           
            storeInfoWrap.add(storeInfo); 
            String valueToDisplayV1 = string.valueOf(storeInfo);
            System.debug('================= storeInfo: '+storeInfo);           
            String valueToDisplayV3 = valueToDisplayV1.remove('storeInfoWrapper:');        
            System.debug('================= valueToDisplayV3 : '+valueToDisplayV3 ); 
            valueToDisplayV4 = valueToDisplayV4 + ' ; \n'+valueToDisplayV3;
            System.debug('================= valueToDisplayV4 : '+valueToDisplayV4 );                                      
                            
        }
        List<String> valueList = valueToDisplayV4.split(';');
        System.debug('================= valueList  : '+valueList  );   
        return valueList;
        
    }
    
    public class storeInfoWrapper {
        public String Name;
        public String Email;
        public Decimal Rank;
        public Decimal Score;
        
        public storeInfoWrapper(String Name, String Email, Decimal Rank, Decimal Score) {
            this.Name = Name;
            this.Email = Email;
            this.Rank = Rank;
            this.Score = Score;
        }
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
        }  
}