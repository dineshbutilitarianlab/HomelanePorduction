public class SourceWaterfallreportcontroller {

    public Integer selectedYear {get; set;}
    public String selectedcity{get; set;}
    
    public List<aggregateResult> reportresult {get;set;}
    public List<aggregateResult> reportresult2 {get;set;}
    public List<aggregateResult> Opplist{get;set;}
    public map<string,map<integer,integer>> leadMap{get;set;}
    public map<string,map<integer,integer>> convertedandlead{get;set;}
    public map<string,map<integer,integer>> oppdatamap{get;set;}
   
    public SourceWaterfallreportcontroller(){
        
        selectedYear = System.Today().year();
        leadMap = new map<string,map<integer,integer>>();
        convertedandlead = new map<String,map<integer,integer>>();
        oppdatamap = new map<String,map<integer,integer>>();
  
        reportresult = new List<aggregateResult>();
        reportresult2 = new List<aggregateResult>();
        Opplist = new List<aggregateResult>();
    }
    
    public List<SelectOption> getYears() {
        List<SelectOption> options = new List<SelectOption>();
        for (Integer i = System.Today().year() - 3; i <= System.Today().year(); i++) {
            options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        return options;
    }
    
    
    public void getReportdata() {
    
        leadMap = new map<string,map<integer,integer>>();
        convertedandlead = new map<String,map<integer,integer>>();
        oppdatamap = new map<String,map<integer,integer>>();
        
        System.debug('selectedyear ------------------->'+selectedyear);
        System.debug('selectedcity------------------->'+selectedcity);
        //list for all the leads per city
        if(selectedcity =='Bengaluru' || selectedcity =='Hyderabad' || selectedcity =='Mumbai' || selectedcity =='Chennai' || selectedcity =='Thane'){
            reportresult =[SELECT Test_Flag__c, LeadSource, CALENDAR_MONTH(Creation_Date__c), count(name) total,count(email) FROM lead WHERE city =:selectedcity AND CALENDAR_YEAR(Creation_Date__c)=:selectedyear and Test_Flag__c = false AND (NOT Name like '%test%') AND (NOT Email like '%test%') GROUP BY Test_Flag__c ,LeadSource,CALENDAR_MONTH(Creation_Date__c)];
            System.debug('reportresult-------------------->'+reportresult);
        }else if(selectedcity =='NCR'){
            reportresult =[SELECT Test_Flag__c, LeadSource, CALENDAR_MONTH(Creation_Date__c), count(name) total,count(email) FROM lead WHERE CALENDAR_YEAR(Creation_Date__c)=:selectedyear AND (City ='New Delhi' Or City='Noida' Or City='Gurgaon' Or City='Ghaziabad'  Or City='Thane') and Test_Flag__c = false AND (NOT Name like '%test%') AND (NOT Email like '%test%') GROUP BY Test_Flag__c ,LeadSource,CALENDAR_MONTH(Creation_Date__c)];
            System.debug('reportresult-------------------->'+reportresult);
        }
        else{
            reportresult =[SELECT Test_Flag__c, LeadSource, CALENDAR_MONTH(Creation_Date__c), count(name) total,count(email) FROM lead WHERE CALENDAR_YEAR(Creation_Date__c)=:selectedyear AND (City ='Bangalore' Or City='Bengaluru' Or City='Mumbai' Or City='Chennai' Or City='Hyderabad' Or City='hyderabad' Or City='bangalore' Or City='bengaluru' Or City='mumbai' Or City='chennai' Or City ='New Delhi' Or City='Noida' Or City='Gurgaon' Or City='Ghaziabad' or City='Thane') AND Test_Flag__c = false AND (NOT Name like '%test%') AND (NOT Email like '%test%') GROUP BY Test_Flag__c ,LeadSource, CALENDAR_MONTH(Creation_Date__c)];
        }
        for (AggregateResult ar : reportresult){
            If(!leadMap.ContainsKey(string.valueOf(ar.get('LeadSource'))))
                leadMap.put(string.valueOf(ar.get('LeadSource')),new map<integer,integer>{1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0,12=>0});
        }
        for (AggregateResult ar : reportresult){
            if(!leadMap.isEmpty() && leadMap.containskey(string.valueOf(ar.get('LeadSource'))) && leadMap.get(string.valueOf(ar.get('LeadSource'))) != null){
                leadMap.get(string.valueOf(ar.get('LeadSource'))).put(integer.valueOf(ar.get('expr0')),integer.valueOf(ar.get('expr1')));
            }
            else{
                leadMap.put(string.valueOf(ar.get('LeadSource')),new map<integer,integer>{integer.valueOf(ar.get('expr0'))=>integer.valueOf(ar.get('expr1'))});
            }
        }  
          System.debug('leadMap -------------------->'+leadMap);// leadMap Map Completed
          
          
      // list for visits data 
      if(selectedcity =='Bengaluru' || selectedcity =='Hyderabad' || selectedcity =='Mumbai' || selectedcity =='Chennai' || selectedcity =='Thane'){   
            reportresult2 =[SELECT Test_Flag__c, LeadSource, CALENDAR_MONTH(Creation_Date__c), count(name) total,count(email) FROM lead WHERE city =:selectedcity AND CALENDAR_YEAR(Creation_Date__c)=:selectedyear and (Status='Appointment Successful' or Status='Appoinment Success - Waiting Floorplan') and Test_Flag__c = false AND (City ='Bangalore' Or City='Bengaluru' Or City='Mumbai' Or City='Chennai' Or City='Hyderabad' Or City='hyderabad' Or City='bangalore' Or City='bengaluru' Or City='mumbai' Or City='chennai' Or City='Thane' ) AND Test_Flag__c = false AND (NOT Name like '%test%') AND (NOT Email like '%test%') GROUP BY Test_Flag__c,LeadSource ,CALENDAR_MONTH(Creation_Date__c)];
            System.debug('reportresult2 -------------------->'+reportresult2);
        }else if(selectedcity =='NCR'){   
            reportresult2 =[SELECT Test_Flag__c, LeadSource ,CALENDAR_MONTH(Creation_Date__c), count(name) total,count(email) FROM lead WHERE city =:selectedcity AND CALENDAR_YEAR(Creation_Date__c)=:selectedyear and (Status='Appointment Successful' or Status='Appoinment Success - Waiting Floorplan') and Test_Flag__c = false AND (City ='New Delhi' Or City='Noida' Or City='Gurgaon' Or City='Ghaziabad' Or City='Thane' ) AND Test_Flag__c = false AND (NOT Name like '%test%') AND (NOT Email like '%test%') GROUP BY Test_Flag__c,LeadSource ,CALENDAR_MONTH(Creation_Date__c)];
            System.debug('reportresult2 -------------------->'+reportresult2);
        }
        else{
            reportresult2 =[SELECT Test_Flag__c, LeadSource ,CALENDAR_MONTH(Creation_Date__c), count(name) total,count(email) FROM lead WHERE CALENDAR_YEAR(Creation_Date__c)=:selectedyear and (Status='Appointment Successful' or Status='Appoinment Success - Waiting Floorplan') and Test_Flag__c = false AND (City ='Bangalore' Or City='Bengaluru' Or City='Mumbai' Or City='Chennai' Or City='Hyderabad' Or City='hyderabad' Or City='bangalore' Or City='bengaluru' Or City='mumbai' Or City='chennai' Or City ='New Delhi' Or City='Noida' Or City='Gurgaon' Or City='Ghaziabad' Or City='Thane') AND Test_Flag__c = false AND (NOT Name like '%test%') AND (NOT Email like '%test%') GROUP BY Test_Flag__c,LeadSource ,CALENDAR_MONTH(Creation_Date__c)];
        }
          for(AggregateResult leaddata:reportresult2){
                If (!convertedandlead.ContainsKey(String.valueOf(leaddata.get('LeadSource')))){
                    convertedandlead.put(string.valueOf(leaddata.get('LeadSource')),new map<integer,integer>{1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0,12=>0});
                }
            }
            for(AggregateResult leaddata:reportresult2){If(!convertedandlead.isEmpty() && convertedandlead.ContainsKey(string.valueOf(leaddata.get('LeadSource'))) && convertedandlead.get(string.valueOf(leaddata.get('LeadSource'))) != null){convertedandlead.get(string.valueOf(leaddata.get('LeadSource'))).put(integer.valueOf(leaddata.get('expr0')),integer.valueOf(leaddata.get('expr1')));
                }
                else{
                    convertedandlead.put(string.valueOf(leaddata.get('LeadSource')),new map<integer,integer>{integer.valueOf(leaddata.get('expr0'))=>integer.valueOf(leaddata.get('expr1'))});
                }
            }     
        
        System.debug('convertedandlead --------------------------->'+convertedandlead);
     //list for order close 
     if(selectedcity =='Bengaluru' || selectedcity =='Hyderabad' || selectedcity =='Mumbai' || selectedcity =='Chennai' || selectedcity =='Thane'){
     System.debug('Selected city is -------------> '+selectedcity);  
        Opplist = [SELECT Test_Flag__c, LeadSource ,CALENDAR_MONTH(Lead_Created_Date__c), count(name) total,count(Customer_Email__c) FROM opportunity WHERE  CityfromLead__c =:selectedcity AND CALENDAR_YEAR(Lead_Created_Date__c)=:selectedyear and CityfromLead__c != NULL AND (CityfromLead__c ='Bangalore' Or CityfromLead__c='Bengaluru' Or CityfromLead__c='Mumbai' Or CityfromLead__c='Chennai' Or CityfromLead__c='Hyderabad' Or CityfromLead__c='hyderabad' Or CityfromLead__c='bangalore' Or CityfromLead__c='bengaluru' Or CityfromLead__c='mumbai' Or CityfromLead__c='chennai' Or CityfromLead__c='Thane' ) and Opportunity_Stage__c='Won' AND Test_Flag__c = false AND (NOT Name like '%test%') AND (NOT Customer_Email__c like '%test%') GROUP BY Test_Flag__c,LeadSource ,CALENDAR_MONTH(Lead_Created_Date__c)];
        system.debug('Opplist --------->'+Opplist);
      }else if(selectedcity =='NCR'){
     System.debug('Selected city is -------------> '+selectedcity);  
       Opplist = [SELECT Test_Flag__c, LeadSource ,CALENDAR_MONTH(Lead_Created_Date__c), count(name) total,count(Customer_Email__c) FROM opportunity WHERE  CityfromLead__c =:selectedcity AND CALENDAR_YEAR(Lead_Created_Date__c)=:selectedyear and CityfromLead__c != NULL AND (CityfromLead__c ='New Delhi' Or CityfromLead__c='Noida' Or CityfromLead__c='Gurgaon' Or CityfromLead__c='Ghaziabad' Or CityfromLead__c='Thane' ) and Opportunity_Stage__c='Won' AND Test_Flag__c = false AND (NOT Name like '%test%') AND (NOT Customer_Email__c like '%test%') GROUP BY Test_Flag__c,LeadSource ,CALENDAR_MONTH(Lead_Created_Date__c)];
        system.debug('Opplist --------->'+Opplist);
      }
      else{
          Opplist = [SELECT Test_Flag__c,LeadSource , CALENDAR_MONTH(Lead_Created_Date__c), count(name) total,count(Customer_Email__c) FROM opportunity WHERE CALENDAR_YEAR(Lead_Created_Date__c)=:selectedyear and CityfromLead__c != NULL AND (CityfromLead__c ='Bangalore' Or CityfromLead__c='Bengaluru' Or CityfromLead__c='Mumbai' Or CityfromLead__c='Chennai' Or CityfromLead__c='Hyderabad' Or CityfromLead__c='hyderabad' Or CityfromLead__c='bangalore' Or CityfromLead__c='bengaluru' Or CityfromLead__c='mumbai' Or CityfromLead__c='chennai' Or CityfromLead__c ='New Delhi' Or CityfromLead__c='Noida' Or CityfromLead__c='Gurgaon' Or CityfromLead__c='Ghaziabad' Or CityfromLead__c='Thane') and Opportunity_Stage__c ='Won' AND Test_Flag__c = null AND (NOT Name like '%test%') AND (NOT Customer_Email__c like '%test%') GROUP BY Test_Flag__c,LeadSource ,CALENDAR_MONTH(Lead_Created_Date__c)]; 
      }
        for (AggregateResult oppmapdata : Opplist){
            If(!oppdatamap.ContainsKey(string.valueOf(oppmapdata.get('LeadSource'))))
                oppdatamap.put(string.valueOf(oppmapdata.get('LeadSource')),new map<integer,integer>{1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0,12=>0});
        } 
        for(AggregateResult oppmapdata:Opplist){
                If(!oppdatamap.isEmpty() && oppdatamap.ContainsKey(string.valueOf(oppmapdata.get('LeadSource'))) && oppdatamap.get(string.valueOf(oppmapdata.get('LeadSource'))) != null){
                    oppdatamap.get(string.valueOf(oppmapdata.get('LeadSource'))).put(integer.valueOf(oppmapdata.get('expr0')),integer.valueOf(oppmapdata.get('expr1')));
                }
                else{
                    oppdatamap.put(string.valueOf(oppmapdata.get('LeadSource')),new map<integer,integer>{integer.valueOf(oppmapdata.get('expr0'))=>integer.valueOf(oppmapdata.get('expr1'))});
                }
            }
        system.debug('oppdatamap --------->'+oppdatamap);

          
           for(String lmap : leadMap.keySet()){
             System.debug('Map Key -------------------------->'+convertedandlead.get(lmap));
             if(convertedandlead.get(lmap)==null){
                 convertedandlead.put(lmap,new map<integer,integer>{1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0,12=>0});
             }
             if(oppdatamap.get(lmap)==null){
                 oppdatamap.put(lmap,new map<integer,integer>{1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0,12=>0});
             }
             
          }

          
        
    }
    
   

}