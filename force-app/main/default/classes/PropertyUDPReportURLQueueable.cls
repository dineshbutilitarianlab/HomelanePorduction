global class PropertyUDPReportURLQueueable implements Queueable{
    private Map<String,String> mapOfLeadAndPropertyName;
    global PropertyUDPReportURLQueueable(Map<String,String> mapOfLeadAndPropertyName) {
        this.mapOfLeadAndPropertyName = mapOfLeadAndPropertyName;
    }
    global void execute(QueueableContext QC) {
        if(!mapOfLeadAndPropertyName.isEmpty()){
            calloutToPropertyUDPReportAPI(mapOfLeadAndPropertyName);
        }
    }
    @future(callout=true)
    public static void calloutToPropertyUDPReportAPI(Map<String,String> mapOfLeadAndPropertyName){
        try{
            List<Log__c> listOfLogsToInsert = new List<Log__c>();
            List<Lead> listOfLeadsToUpdate = new List<Lead>();
            if(!mapOfLeadAndPropertyName.isEmpty()){
                System.debug('mapOfLeadAndPropertyName is not empty: '+mapOfLeadAndPropertyName);
                Map<String,Integration_Setting__c> allEndPoint = Integration_Setting__c.getAll();
                Integration_Setting__c integrationDetail = allEndPoint.get('UDP_Property_Report_URL_API');
                String endPointUrl = integrationDetail.End_Point__c;
                String contentType = integrationDetail.ContentType__c;
                String authKey = integrationDetail.Authorization__c;
                for(String LeadId: mapOfLeadAndPropertyName.keySet()){
                    Lead leadToupdate = new Lead();
                    leadToupdate.Id = LeadId;
                    if(Limits.getCallouts() < Limits.getLimitCallouts()){
                        PropertyUDPReportRequestWrapper requestBody = new PropertyUDPReportRequestWrapper();
                        PropertyUDPReportResponseWrapper respWrap;
                        
                        requestBody.property_name = mapOfLeadAndPropertyName.get(LeadId);
                        
                        String body = Json.serialize(requestBody);
                        Http http = new Http();
                        HttpRequest request = new HttpRequest();
                        Httpresponse response = new Httpresponse();
                        
                        request.setMethod('POST');
                        request.setBody(body);
                        request.setHeader('Content-Type', contentType);
                        request.setHeader('Accept', contentType);
                        request.setHeader('Authorization','Bearer '+authKey);
                        request.setEndPoint(endPointUrl);
                        request.setTimeout(120000);
                        
                        System.debug('request: '+request);
                        System.debug('request body: '+body);
                        
                        response = http.send(request);
                        System.debug('response: '+response);
                        
                        String resJson;
                        if(response.getStatusCode()==200){
                            resJson = response.getBody();
                            System.debug('response.getStatusCode(): '+response.getStatusCode());
                            System.debug('resJson: '+resJson);
                            respWrap = (PropertyUDPReportResponseWrapper)JSON.deserialize(resJson,PropertyUDPReportResponseWrapper.class);
                            if(respWrap !=null){
                                if(!String.isBlank(respWrap.link)){
                                    leadToupdate.Property_Report_UDP_URL__c = respWrap.link;
                                    System.debug('leadToupdate.Property_Report_UDP_URL__c: '+leadToupdate.Property_Report_UDP_URL__c);
                                    System.debug('respWrap.link: '+respWrap.link);
                                    listOfLeadsToUpdate.add(leadToupdate);
                                    System.debug('Property report link present in UDP for property: '+respWrap.link);
                                }
                                else{
                                    leadToupdate.Property_Report_UDP_URL__c = 'Property report link not present in UDP for property name:  '+String.valueOf(mapOfLeadAndPropertyName.get(LeadId));
                                    listOfLeadsToUpdate.add(leadToupdate);
                                    System.debug('Property report link not present in UDP for property name:  '+String.valueOf(mapOfLeadAndPropertyName.get(LeadId)));
                                    //listOfLogsToInsert.add(Logger.returnLog('Error','PropertyUDPReportURLQueueable class','calloutToPropertyUDPReportAPI method','Lead ID: '+LeadId,String.ValueOf(respWrap),null));
                                }
                            }
                            else{
                                leadToupdate.Property_Report_UDP_URL__c = 'Success but blank response from UDP for property name:  '+String.valueOf(mapOfLeadAndPropertyName.get(LeadId));
                                listOfLeadsToUpdate.add(leadToupdate);
                                System.debug('Success but blank response from UDP'+respWrap);
                                listOfLogsToInsert.add(Logger.ReturnLog('Error','PropertyUDPReportURLQueueable class','calloutToPropertyUDPReportAPI method','respWrap is null',String.ValueOf(respWrap),null));
                            }
                        }
                        else{
                            leadToupdate.Property_Report_UDP_URL__c = 'Status code error'+String.ValueOf(response.getStatusCode());
                            listOfLeadsToUpdate.add(leadToupdate);
                            System.debug('response.getStatusCode(): '+response.getStatusCode());
                            listOfLogsToInsert.add(Logger.ReturnLog('Error','PropertyUDPReportURLQueueable class','calloutToPropertyUDPReportAPI method','Status code error',String.ValueOf(response.getStatusCode()),null));
                        }
                    }
                    else{
                        leadToupdate.Property_Report_UDP_URL__c = 'API callouts limit hit. Limits.getCallouts(): '+Limits.getCallouts();
                        listOfLeadsToUpdate.add(leadToupdate);
                        System.debug('API callouts limit hit. Limits.getCallouts(): '+Limits.getCallouts());
                        listOfLogsToInsert.add(Logger.ReturnLog('Error','PropertyUDPReportURLQueueable class','calloutToPropertyUDPReportAPI method','API callouts limit hit. Limits.getCallouts(): '+Limits.getCallouts(),'',null));
                    }
                }
            }
            else{
                System.debug('empty mapOfLeadAndPropertyName: '+mapOfLeadAndPropertyName);
                listOfLogsToInsert.add(Logger.Returnlog('Error','PropertyUDPReportURLQueueable class','calloutToPropertyUDPReportAPI method','empty listOfJSON:','',null));
            }
            if(!listOfLeadsToUpdate.isEmpty()){
                system.debug('listOfLeadsToUpdate is not empty');
                Database.SaveResult[] leadUpdateResult = Database.update(listOfLeadsToUpdate,false);
            }
            if(!listOfLogsToInsert.isEmpty()){
                system.debug('listOfLogsToInsert is not empty');
                Database.SaveResult[] leadUpdateResult = Database.insert(listOfLogsToInsert,false);
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString());
            system.debug('Exception Message : '+e.getMessage());
            Logger.log('Exception','PropertyUDPReportURLQueueable class','calloutToPropertyUDPReportAPI method',e.getMessage(),e.getStackTraceString(),null);
        }
    }
    
    Public class PropertyUDPReportResponseWrapper{
        public String link {get;set;}
    }
    Public class PropertyUDPReportRequestWrapper{
        public String property_name {get;set;}
    }
}