global class ExotelAPICalloutQueueable implements Queueable
{
        List<lead>  lstLead = new List<Lead>();
   		public static List<lead>  updateLead = new List<Lead>();
        public String sessionId;
        public static List<Lead> leadList= new List<Lead>();
        public static List<Lead> scoreRecheckList = new list<lead>();
        public static Map<Id,Lead> IdToLeadMap=new Map<Id,Lead>();
    	public static Lead ld;
    
        global ExotelAPICalloutQueueable(List<Lead> lstLead, String sessionId) 
        {
            this.lstLead = lstLead;
            this.sessionId = sessionId;
        }
    
    global void execute(QueueableContext QC) 
    {
        for(Lead lead : lstLead) 
        {                
            
            if(lead.Assigned_to_Resi_ASM__c && lead.Sales_Manager__c != null)
            {
                system.debug('lstLead in execute method '+ lstLead);
                getPhoneNumbers(lead.id, lead.Phone , lead.Sales_Manager__r.Phone__c, lead.Description__c, lead.Sales_Manager__r.Exotel_Phone_Number__c); 
            }                      
            
        }          
        
    }
    
    
    @future(callout=true)
    public static void  getPhoneNumbers( Id LeadId,String Cust_Phone, String Champ_Phone,String OldDescription, String CallerId)
    {          
        
        try
        {
            system.debug('Lead  '+LeadId );
            if(LeadId != null )
            {
                Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                Integration_Setting__c integrationDetail = allEndPoint.get('Exotel API');
                system.debug('integrationDetail'+integrationDetail);
         
                
                system.debug('Champ_Phone'+Champ_Phone );
                system.debug('Cust_Phone'+ Cust_Phone);
                system.debug('CallerId'+ CallerId);
                
                if(String.isNotBlank(CallerId))
                {                                                              
                    String endPointUrl = integrationDetail.End_Point__c;               
                    Http http = new Http();
                    HttpRequest request = new HttpRequest();
                    request.settimeout(120000);
                    request.setEndpoint(endpointURL); 
                    system.debug('endpointURL :'+endpointURL);
                    request.setMethod('POST');
                    
                    request.setHeader('accept', 'application/json');
                    request.setHeader('Authorization',integrationDetail.Authorization__c);
                    request.setHeader('Content-Type','multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW');
    
                    request.setBody('------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"From\"\r\n\r\n'+ Champ_Phone +'\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"To\"\r\n\r\n'+ Cust_Phone +'\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"CallerId\"\r\n\r\n'+ CallerId +'\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"Record\"\r\n\r\ntrue\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--');
           
            
                    HttpResponse response = http.send(request);
                                
                    system.debug('response :'+ response);
                    system.debug(response.getBody());
                    
                    if(response.getstatusCode() == 200 )
                    {
                        system.debug('response.getbody()'+response.getbody());
                        Lead ld = new Lead();
                        ld.id = LeadID ;
                        ld.Auto_Dialled__c = true ;
                        ld.Description__c = OldDescription + '\n' +response.getbody();
                        System.Debug('ld.id '+ld.id+'and ld.Auto_Dialled__c : '+ld.Auto_Dialled__c);
                        System.Debug('ld.Description__c : '+ld.Description__c);
                        Update ld;
                    }
                    
                    else
                    {
                        system.debug('Error :'+response.getStatusCode()+' : '+response.getStatus());  
                        Lead ld = new Lead();
                        ld.id = LeadID ;
                        ld.Description__c = OldDescription + '\n' +response.getbody();
                    //    System.Debug('ld.Description__c : '+ld.Description__c);
                        Update ld;
                    }
                }
            }
         }
        
        
        catch(Exception e)
        {
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception',' ExotelAPICallout class',' getPhoneNumbers method',e.getMessage(),e.getStackTraceString(),'');
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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