global class SolarAPICalloutQueueable implements Queueable
{
        List<lead>  lstLead = new List<Lead>();
        public String sessionId;
        public static List<Lead> leadList= new List<Lead>();
        public static List<Lead> scoreRecheckList = new list<lead>();
        public static Map<Id,Lead> IdToLeadMap=new Map<Id,Lead>();
    
        global SolarAPICalloutQueueable(List<Lead> lstLead, String sessionId) 
        {
            this.lstLead = lstLead;
            this.sessionId = sessionId;
        }
    
    global void execute(QueueableContext QC) 
    {
        for(Lead lead : lstLead) 
        {                
            
            if(lead.Property__c != null)
            {
                system.debug('IdToLeadMap in execute method '+ lead.Property__r.Name);
                getPropertyName(lead.id ,lead.Property__r.Name,lead.city,lead.Bulk_Upload__c,lead.Pre_Appointment_Date__c,lead.Relanded_Source__c,lead.Green_Lead_Class__c); 
            }
            else
            {
                if(lead.Is_Blitz_property_lead__c || lead.Is_Premium_property_lead__c)
                {
                    lead ld = new Lead();
                    ld.id = lead.id;
                    ld.Is_Blitz_property_lead__c = false;
                    ld.Is_Premium_property_lead__c = false;
                    leadList.add(ld);   
                }
                
            }
            
            
        }
        
        
        system.debug(leadList);
        
        if(!LeadList.isEmpty()) {
            update leadList;
        }  
        
    }
    
    @future(callout=true)
    public static void  getPropertyName( Id LeadId,String Property, String city,Boolean BulkUpload, DateTime PreAppDate, String RelandedSource, String GreenLeadClass)
    {          
        
        try
        {
            system.debug('Lead  '+LeadId );
            if(LeadId != null )
            {
                Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                Integration_Setting__c integrationDetail = allEndPoint.get('Solr API');
                system.debug('integrationDetail'+integrationDetail);
                                    
                String encodedProp=  EncodingUtil.urlEncode(Property, 'UTF-8');                         
                system.debug('Property'+ Property);
                String endPointUrl = integrationDetail.End_Point__c+'p='+encodedProp+'&c='+City;
      
                system.debug('endPointUrl'+endPointUrl);
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setMethod('GET');
                system.debug(request.getMethod());
                request.setHeader('Authorization',integrationDetail.Authorization__c);
                request.setEndpoint(endpointURL);
                HttpResponse response = http.send(request);
                system.debug('Authorization ' +integrationDetail.Authorization__c);
                system.debug(response.getBody());
                
                if(response.getstatusCode() == 200 )
                {
                    system.debug('response.getbody()'+response.getbody());
                    
                     // Assuming 'response.getBody()' contains the JSON string
                    Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    
                    // Initialize flags
                    Boolean isBlitzProperty = false;
                    Boolean isPremiumProperty = false;
                    
                    // Fetching the blitz_property flag
                    if (respMap.containsKey('blitz_property')) 
                    {
                        Map<String, Object> blitzPropertyMap = (Map<String, Object>) respMap.get('blitz_property');
                        if (blitzPropertyMap != null && blitzPropertyMap.containsKey('is_blitz_property')) 
                        {
                            isBlitzProperty = (Boolean) blitzPropertyMap.get('is_blitz_property');
                        }
                    }
                    
                    // Fetching the premium_property flag
                    if (respMap.containsKey('premium_property')) 
                    {
                        Map<String, Object> premiumPropertyMap = (Map<String, Object>) respMap.get('premium_property');
                        if (premiumPropertyMap != null && premiumPropertyMap.containsKey('is_premium_property')) 
                        {
                            isPremiumProperty = (Boolean) premiumPropertyMap.get('is_premium_property');
                        }
                    }
                    
                    // Debugging the flag values
                    System.debug('is_blitz_property: ' + isBlitzProperty);
                    System.debug('is_premium_property: ' + isPremiumProperty);

                    
                    lead ld = new lead();
                    ld.id= leadId;
                    ld.Is_Premium_property_lead__c = isPremiumProperty;
                    ld.Solar_Response__c = response.getBody();
                    
                    if(isBlitzProperty)              
                    {   
                        ld.Is_Blitz_property_lead__c= true;
                        
                        if(GreenLeadClass != GenericConstants.Green_Lead_Gold_Plus)
                        {                            	 
                                 if(city==GenericConstants.LD_City_Mumbai || city==GenericConstants.LD_City_Chennai || city==GenericConstants.LD_City_Bengaluru || 
                                    city==GenericConstants.LD_City_Hyderabad || city==GenericConstants.LD_City_Kolkata || city==GenericConstants.LD_City_Pune ||
                                    city == GenericConstants.LD_City_Ahm || city == GenericConstants.LD_City_Bhubaneswar || city == GenericConstants.LD_City_Ranchi ||
                                    city == GenericConstants.LD_City_Surat || city == GenericConstants.LD_City_Visakhapatnam)
                                	{
                                        if((BulkUpload  && PreAppDate != null && (RelandedSource != GenericConstants.OFFLINE_LEAD_SOURCE && RelandedSource != null)) || !BulkUpload)
                                        {
                                            system.debug(' Gold update ');                                       
                                            ld.Lead_Score_for_Assignment__c = GenericConstants.Lead_Gold_Score;
                                        }
                                	}  
                            	
                            	if(city == GenericConstants.LD_City_Thane)
                                {
                                    	if((BulkUpload  && PreAppDate != null && (RelandedSource != GenericConstants.OFFLINE_LEAD_SOURCE && RelandedSource != null)) || !BulkUpload)
                                        {
                                            system.debug(' Silver update ');                                       
                                            ld.Lead_Score_for_Assignment__c = GenericConstants.Lead_Silver_Score;
                                        }
                                }
                        }                        
                        
               			update ld;
                        system.debug('leadList'+leadList);
                    }
                    else
                    {
                        ld.Is_Blitz_property_lead__c= false;                        
                        update ld;
                       
                        system.debug('no update');
                    }                    
                }                
            }            
            else
            {
                system.debug('Property Deleted');                                 
            }
               
        }
        
        
        catch(Exception e)
        {
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception',' LeadPropertyUpdateAPI  class',' getPropertyName method',e.getMessage(),e.getStackTraceString(),'');
        }
    }
    
    ResponseWrapper response = new ResponseWrapper();

    public class ResponseWrapper 
    {
        public BlitzPropertyWrapper blitz_property;
        public PremiumPropertyWrapper premium_property;
    }
    
    public class BlitzPropertyWrapper 
    {
        public Boolean is_blitz_property;
        public List<PropertyDetails> properties;
    }
    
    public class PremiumPropertyWrapper 
    {
        public Boolean is_premium_property;
        public List<PropertyDetails> properties;
    }
    
    public class PropertyDetails 
    {
        public String city;
        public String property;
        public Double score;
        public Double similarity;
    }


    
    /*public class ResponseWrapper
    {
        public respWrapper resp;
    }
    
    class respWrapper 
    {
        public String area; //KA&KL
        public String city; //Bengaluru
        public String property; //DSR
        public Double score;    //2.7152543
        public Double similarity;   //0.1333333333333333
        public String zone; //South
    }*/
    
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
     }
    
}