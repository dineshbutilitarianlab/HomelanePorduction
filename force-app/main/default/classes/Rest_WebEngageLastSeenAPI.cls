@RestResource(urlMapping='/UpdateLastSeen/*')
    global class Rest_WebEngageLastSeenAPI{
    /*
    Description : This API is called by WebEngage and to update LastSeen field on Lead.
                  If the customerID is present in salesforce we send success response and then Update the Lead in future.
                  WebEngage can update maximum of 100 records in one request
    JSON : "[{"CustomerID":"Mum-r-3000006755","LastSeen":"2019-10-22T20:29:00Z"},{"CustomerID":"Tha-r-3000006754","LastSeen":"2019-10-22T20:29:00Z"}]"
    */
        @HttpPost
        global static void updateLastSeen(){
            list<RequestWrapper> lstWarpper = new list<RequestWrapper>();
            RestRequest req = RestContext.request;
            RestResponse res = new RestResponse();
            SFResponse responseObj = new SFResponse();
            String inputData = req.requestBody.toString();
            boolean bIsError = false;
            list<Lead> lstLeadtoUpdate = new list<Lead>();
            list<Opportunity> lstOpportunitytoUpdate = new list<Opportunity>();
            list<ResponseWrapper> lstResponseWrapper = new list<ResponseWrapper>();

            Map<String,Datetime> mapCustomerID_LastSeen = new Map<String,Datetime>();
            Map<String,Opportunity> mapCustomerID_Opportunity = new Map<String,Opportunity>();
            Map<String,Lead> mapCustomerID_Lead = new Map<String,Lead>();
            if(String.isNotBlank(inputData)){
                try{
                    lstWarpper = (List<RequestWrapper>)Json.deserialize(inputData, List<RequestWrapper>.Class);
                    for(RequestWrapper wrapper:lstWarpper){
                        if(String.isNotBlank(wrapper.CustomerID)){
                            mapCustomerID_LastSeen.put(wrapper.CustomerID,wrapper.LastSeen);
                        }
                    }

                    if(!mapCustomerID_LastSeen.isEmpty()){ 
                        system.debug('mapCustomerID_LastSeen.size()'+mapCustomerID_LastSeen.size());  
                        if(mapCustomerID_LastSeen.size() <= 100){  
                            system.debug('mapCustomerID_LastSeen size'+mapCustomerID_LastSeen.size());
                            List<Lead> lstLead = [Select id,Name,Customer_ID__C,WebEngage_Last_Seen__c 
                                                                From Lead
                                                                where Customer_ID__C IN: mapCustomerID_LastSeen.keySet()];    

                            for(Lead objLead:lstLead){
                                mapCustomerID_Lead.put(objLead.Customer_ID__C,objLead);
                            }     

                    /*    List<Opportunity> lstOpportunity = [Select id,Name,Customer_ID__C,WebEngage_Last_Seen__c 
                                    From Opportunity
                                    where Customer_ID__C IN: mapCustomerID_LastSeen.keySet()];

                        for(Opportunity objOpp:lstOpportunity){
                            mapCustomerID_Opportunity.put(objOpp.Customer_ID__C,objOpp);
                        } */           

                   

                            for(RequestWrapper wrapper:lstWarpper){
                                if(mapCustomerID_Lead.containsKey(wrapper.CustomerID)){
                                    wrapper.LastSeen.getTime();
                                    mapCustomerID_Lead.get((wrapper.CustomerID)).WebEngage_Last_Seen__c = wrapper.LastSeen;
                                    lstLeadtoUpdate.add(mapCustomerID_Lead.get((wrapper.CustomerID)));
                                    ResponseWrapper resp = new ResponseWrapper();
                                    resp.CustomerID = wrapper.CustomerID;
                                    resp.RecordStatus = 'Success';                               
                                    lstResponseWrapper.add(resp);
                                }else{
                                    bIsError = true;
                                    ResponseWrapper resp = new ResponseWrapper();
                                    resp.CustomerID = wrapper.CustomerID;
                                    resp.RecordStatus = 'Error'; 
                                    resp.ErrorMessage = 'User Not Present in Salesforce';
                                    lstResponseWrapper.add(resp);
                                }
                            }

                            if(bIsError){
                                responseObj.Status = 'Failure';
                                responseObj.Message = 'Falied to update some record';
                                responseObj.Response = lstResponseWrapper;
                                string repsponseData = Json.serializePretty(responseObj);
                                System.debug('responseObj :'+responseObj);
                                System.debug('repsponseData :'+repsponseData);
                                RestContext.response.addHeader('Content-Type', 'application/json');
                                RestContext.response.responseBody = Blob.valueOf(repsponseData); 
                                RestContext.response.statusCode = 200;
                            }else{
                                responseObj.Status = 'Success';
                                responseObj.Message = 'Success';
                                responseObj.Response = lstResponseWrapper;
                                string repsponseData = Json.serializePretty(responseObj);
                                System.debug('responseObj :'+responseObj);
                                System.debug('repsponseData :'+repsponseData);
                                RestContext.response.addHeader('Content-Type', 'application/json');
                                RestContext.response.responseBody = Blob.valueOf(repsponseData); 
                                RestContext.response.statusCode = 200;
                            }

                            if(!mapCustomerID_Lead.isEmpty()){
                                system.debug('mapCustomerID_Lead-----'+mapCustomerID_Lead);
                                System.enqueueJob(new WebEngage_LeadUpdate(lstLeadtoUpdate));
                            }
                        }else{
                            responseObj.Status = 'Error';
                            responseObj.Message = 'List has more than 100 element';
                            responseObj.Response = lstResponseWrapper;

                            string repsponseData = Json.serializePretty(responseObj);
                            RestContext.response.addHeader('Content-Type', 'application/json');
                            RestContext.response.responseBody = Blob.valueOf(repsponseData); 
                            RestContext.response.statusCode = 400;
                        }   
                    }    

                }catch(Exception e){
                    System.debug('Exception msg :'+e.getMessage());
                    System.debug('Exception Trace :'+e.getStackTraceString());
                    responseObj.Status = 'Error';
                    responseObj.Message = e.getMessage();
                    responseObj.Response = lstResponseWrapper;
                    
                    string repsponseData = Json.serializePretty(responseObj);
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(repsponseData); 
                    RestContext.response.statusCode = 400;
                }
            }  
        }
   
    public class RequestWrapper{
        public String CustomerID;
        public Datetime LastSeen;
    }

    public class ResponseWrapper{
        public String CustomerID;
        public String RecordStatus;
        public String ErrorMessage;
    }

    public class SFResponse{
        public String Status;
        public String Message;
        public list<ResponseWrapper> Response;
    }
}