public class Waterfallreportcontroller {
    
    public Integer selectedYear {get; set;}
    public String renderedContentType {get;set;}
    public List<aggregateResult> reportresult {get;set;}
    public List<aggregateResult> reportresult2 {get;set;}
    public List<aggregateResult> Opplist{get;set;}
    public Map<String,String> mapOppData{get;set;}
    public Map<String,String> mapLeadData{get;set;}
    public Map<String,String> mapConvertedData{get;set;}
    public Map<Integer,Integer> mapDefault{get;set;}
    public map<string,map<integer,integer>> leadMap{get;set;}
    public map<string,map<integer,integer>> convertedandlead{get;set;}
    public map<string,map<integer,integer>> oppdatamap{get;set;}
    
    public Waterfallreportcontroller (){
        
        selectedYear = System.Today().year();
        leadMap = new map<string,map<integer,integer>>();
        convertedandlead = new map<String,map<integer,integer>>();
        oppdatamap = new map<String,map<integer,integer>>();
        mapOppData = new Map<String,String>();
        mapLeadData = new Map<String,String>();
        mapDefault = new map<integer,integer>{1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0,12=>0};
        mapConvertedData = new Map<String,String>();
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
        Set<String> CityData = new Set<String>();
        for(City_Names__c city : City_Names__c.getall().values()){
            System.debug('CityDataloop ------------------->'+city.Name);
            CityData.add(city.Name);
        }
        Map<String,String> GroupedCity = new Map<String,String>();
        GroupedCity.put('New Delhi','NCR');
        GroupedCity.put('Noida','NCR');
        GroupedCity.put('Gurgaon','NCR');
        GroupedCity.put('Ghaziabad','NCR');
        GroupedCity.put('ghaziabad','NCR');
        GroupedCity.put('Gurgoan','NCR');
        GroupedCity.put('Greater Noida','NCR');
        System.debug('CityData ------------------->'+CityData);
        System.debug('GroupedCity ------------------->'+GroupedCity);
        System.debug('selectedyear ------------------->'+selectedyear);
        //list for all the leads per city
        reportresult =[SELECT city, CALENDAR_MONTH(Creation_Date__c), count(name) total,count(email) FROM lead WHERE  CALENDAR_YEAR(Creation_Date__c)=:selectedyear AND City IN : CityData AND LeadSource !='Test Source' GROUP BY city,CALENDAR_MONTH(Creation_Date__c)];
        System.debug('reportresult size()-------------------->'+reportresult.size());
        
        for (AggregateResult ar : reportresult){
            System.debug('reportresult city-------------------->'+string.valueOf(ar.get('city')));
            if(!leadMap.ContainsKey(string.valueOf(ar.get('city'))))
            if(GroupedCity.ContainsKey(string.valueOf(ar.get('city')))){
                leadMap.put('NCR',new map<integer,integer>{1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0,12=>0});
            }else{  
            leadMap.put(string.valueOf(ar.get('city')),new map<integer,integer>{1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0,12=>0});
            }
        }
        for (AggregateResult ar : reportresult){if(!leadMap.isEmpty() && (leadMap.containskey(string.valueOf(ar.get('city'))) ||leadMap.containskey('NCR')) && (leadMap.get(string.valueOf(ar.get('city'))) != null || leadMap.get('NCR') != null)){
            System.debug('reportresult city-------------------->'+string.valueOf(ar.get('city')));
            if(GroupedCity.ContainsKey(string.valueOf(ar.get('city')))){
                 leadMap.get('NCR').put(integer.valueOf(ar.get('expr0')),integer.valueOf(ar.get('expr1')));
                 System.debug('leadMap contains-------------------->'+leadMap);
            }else{
             leadMap.get(string.valueOf(ar.get('city'))).put(integer.valueOf(ar.get('expr0')),integer.valueOf(ar.get('expr1')));
             }
            }
            else{
                System.debug('reportresult cityelse-------------------->'+string.valueOf(ar.get('city')));
                if(GroupedCity.ContainsKey(string.valueOf(ar.get('city')))){
                    leadMap.put('NCR',new map<integer,integer>{
                    integer.valueOf(ar.get('expr0'))=>integer.valueOf(ar.get('expr1'))});
                    System.debug('leadMap contains-------------------->'+leadMap);
                }else{
                leadMap.put(string.valueOf(ar.get('city')),new map<integer,integer>{
                    integer.valueOf(ar.get('expr0'))=>integer.valueOf(ar.get('expr1'))
                    });
                }
            }
        }  
          System.debug('testmap -------------------->'+leadMap);
        
      // list for visits data    
        reportresult2 =[SELECT city, CALENDAR_MONTH(Creation_Date__c), count(name) total,count(email) FROM lead WHERE  CALENDAR_YEAR(Creation_Date__c)=:selectedyear and (Status='Appointment Successful' or Status='Appoinment Success - Waiting Floorplan') AND City IN : CityData AND LeadSource !='Test Source' GROUP BY city,CALENDAR_MONTH(Creation_Date__c)];
        System.debug('reportresult2 -------------------->'+reportresult2);
            for(AggregateResult leaddata:reportresult2){
                if (!convertedandlead.ContainsKey(String.valueOf(leaddata.get('city')))){
                    if(GroupedCity.ContainsKey(string.valueOf(leaddata.get('city')))){
                convertedandlead.put('NCR',new map<integer,integer>{1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0,12=>0});
            }else{  
                    convertedandlead.put(string.valueOf(leaddata.get('city')),new map<integer,integer>{1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0,12=>0});
                }
             }
            }
            for(AggregateResult leaddata:reportresult2){
                if(!convertedandlead.isEmpty() && (convertedandlead.ContainsKey(string.valueOf(leaddata.get('city'))) ||convertedandlead.containskey('NCR')) && (convertedandlead.get(string.valueOf(leaddata.get('city'))) != null || convertedandlead.get('NCR') != null)){
                if(GroupedCity.ContainsKey(string.valueOf(leaddata.get('city')))){
                 convertedandlead.get('NCR').put(integer.valueOf(leaddata.get('expr0')),integer.valueOf(leaddata.get('expr1')));
                }else{
                    convertedandlead.get(string.valueOf(leaddata.get('city'))).put(integer.valueOf(leaddata.get('expr0')),integer.valueOf(leaddata.get('expr1')));
                  }
                }
                else{
                    if(GroupedCity.ContainsKey(string.valueOf(leaddata.get('city')))){
                        convertedandlead.put('NCR',new map<integer,integer>{integer.valueOf(leaddata.get('expr0'))=>integer.valueOf(leaddata.get('expr1'))});
                 }else{
                    convertedandlead.put(string.valueOf(leaddata.get('city')),new map<integer,integer>{integer.valueOf(leaddata.get('expr0'))=>integer.valueOf(leaddata.get('expr1'))});
                }
            }       
        }
        System.debug('convertedandlead --------------------------->'+convertedandlead);
       
     //list for order close   
       Opplist = [SELECT CityfromLead__c, CALENDAR_MONTH(Lead_Created_Date__c), count(name) total,count(Customer_Email__c) FROM opportunity WHERE  CALENDAR_YEAR(Lead_Created_Date__c)=:selectedyear AND CityfromLead__c IN : CityData AND LeadSource !='Test Source' AND (Opportunity_Status__c='WON' OR Opportunity_Stage__c = 'Won') GROUP BY CityfromLead__c,CALENDAR_MONTH(Lead_Created_Date__c)];
        system.debug('Opplist --------->'+Opplist);
        for (AggregateResult oppmapdata : Opplist){
            if(!oppdatamap.ContainsKey(string.valueOf(oppmapdata.get('CityfromLead__c'))))
                if (!oppdatamap.ContainsKey(String.valueOf(oppmapdata.get('CityfromLead__c')))){
                    if(GroupedCity.ContainsKey(string.valueOf(oppmapdata.get('CityfromLead__c')))){
                oppdatamap.put('NCR',new map<integer,integer>{1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0,12=>0});
            }else{
                oppdatamap.put(string.valueOf(oppmapdata.get('CityfromLead__c')),new map<integer,integer>{1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0,12=>0});
            }
         }
        } 
        for(AggregateResult oppmapdata:Opplist){
                if(!oppdatamap.isEmpty() && (oppdatamap.ContainsKey(string.valueOf(oppmapdata.get('CityfromLead__c'))) ||oppdatamap.containskey('NCR')) && ((oppdatamap.get(string.valueOf(oppmapdata.get('CityfromLead__c'))) != null) || oppdatamap.get('NCR') != null)){
                    if(GroupedCity.ContainsKey(string.valueOf(oppmapdata.get('CityfromLead__c')))){
                        oppdatamap.get('NCR').put(integer.valueOf(oppmapdata.get('expr0')),integer.valueOf(oppmapdata.get('expr1')));
                }else{
                    oppdatamap.get(string.valueOf(oppmapdata.get('CityfromLead__c'))).put(integer.valueOf(oppmapdata.get('expr0')),integer.valueOf(oppmapdata.get('expr1')));
                    }
                }
                else{
                    if(GroupedCity.ContainsKey(string.valueOf(oppmapdata.get('CityfromLead__c')))){
                        oppdatamap.put('NCR',new map<integer,integer>{integer.valueOf(oppmapdata.get('expr0'))=>integer.valueOf(oppmapdata.get('expr1'))});
                        
                 }else{
                    oppdatamap.put(string.valueOf(oppmapdata.get('CityfromLead__c')),new map<integer,integer>{integer.valueOf(oppmapdata.get('expr0'))=>integer.valueOf(oppmapdata.get('expr1'))});
                  }
                }
            }
        system.debug('oppdatamap --------->'+oppdatamap);
        cityData.add('NCR');
      for(String str : cityData){
            if(leadMap.get(str) != null){
                mapLeadData.put(str,'true');
            }else{
                mapLeadData.put(str,'false');
            }
            if(oppdatamap.get(str) != null){
                mapOppData.put(str,'true');
            }else{
                mapOppData.put(str,'false');
            }
            if(convertedandlead.get(str) != null){
                mapConvertedData.put(str,'true');
            }else{
                mapConvertedData.put(str,'false');
            }
            
        } 
    }
    
    public pagereference Download(){
          PageReference exdownload = null;
          exdownload = new PageReference('https://homelane--hmldevop--c.cs6.visual.force.com/apex/waterfallexcell');
          exdownload.setRedirect(false);
          getReportdata();
          return exdownload ;
      }
    

}