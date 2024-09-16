@RestResource(urlMapping='/UpdateNameAPI/*')
global class Rest_UpdateNameAPI{
   
     
    /*********************************************************************************************************  
    * Name: updateName
    * Description : Roster call this API to Update the Name in Lead ,Account and Opportunity
    ********************************************************************************************************/
     @HttpPost
    global static void updateName(){
        ResponseWrapper respWrap = new ResponseWrapper();
        RestRequest req = RestContext.request;
        RestResponse res = new RestResponse();
        String inputData = req.requestBody.toString();
        list<Account> lstAccount  = new list<Account>();
        list<Lead> lstLead = new list<Lead>();
        list<Opportunity> lstOpportunity = new list<Opportunity>();
        Savepoint sp;
        if(String.isNotBlank(inputData)){
            try{
                RequestWrapper reqWrap = (RequestWrapper)Json.deserialize(inputData, RequestWrapper.Class);
                if(String.isNotBlank(reqWrap.CustomerID) && String.isNotBlank(reqWrap.LastName) && String.isNotBlank(reqWrap.SobjectName)){
                    if(reqWrap.SobjectName == 'Lead' || reqWrap.SobjectName == 'opportunity'){
                        lstLead = [Select id,FirstName,LastName from lead where customer_Id__C =:reqWrap.CustomerID];
                        if(!lstLead.isEmpty()){
                            lstLead[0].FirstName = NULL;
                            lstLead[0].LastName = reqWrap.LastName;

                            if(reqWrap.SobjectName == 'opportunity'){
                                lstAccount = [Select id,LastName,FirstName,Createddate from Account 
                                                        where IsPersonAccount=True and customer_Id__C =:reqWrap.CustomerID ];

                                system.debug('lstAccount'+lstAccount);    
                                lstOpportunity= [Select id,Name from Opportunity where customer_Id__C =:reqWrap.CustomerID ]; 
                                system.debug('lstOpportunity'+lstOpportunity);                          
                                if(!lstAccount.isEmpty() && !lstOpportunity.isEmpty()){
                                    lstAccount[0].LastName = reqWrap.LastName;
                                    lstAccount[0].FirstName = NULL;
                                    lstOpportunity[0].Name = reqWrap.LastName;
                                }
                                else{
                                    
                                    respWrap.isSuccess = False;
                                    respWrap.errorMessage ='Account or Opportunity  with CustomerID doesn\'t exists';  
                                    RestContext.response.addHeader('Content-Type', 'application/json');
                                    RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
                                    RestContext.response.statusCode = 400;                               
                                }
                            }
                            if(String.isBlank(respWrap.errorMessage)){
                                sp= Database.setSavepoint();
                                update lstLead;
                                if(reqWrap.SobjectName == 'opportunity'){
                                    update lstAccount;
                                    update lstOpportunity;
                                }
                                respWrap.isSuccess = True;  
                            }
                        }
                        else{
                            
                            respWrap.isSuccess = False;
                            respWrap.errorMessage ='Lead with CustomerID doesn\'t exists';
                            RestContext.response.addHeader('Content-Type', 'application/json');
                            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));  
                            RestContext.response.statusCode = 400;  
                        }
                    }
                    else{
                        
                        respWrap.isSuccess = False;
                        respWrap.errorMessage ='Error in Sobject Name';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap));
                        RestContext.response.statusCode = 400; 
                    }
                }else{
                   
                    respWrap.isSuccess = False;
                    respWrap.errorMessage ='Parameter\'s are NULL';
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
                    RestContext.response.statusCode = 400; 
                }
            }
            catch(Exception e){
                system.debug('Exception: '+e.getMessage()+ e.getStackTraceString());
                Database.rollback(sp);
                Logger.log('Exception','Rest_UpdateNameAPI class','UpdateNameAPI method',e.getMessage(),e.getStackTraceString(),NULL);
               
                respWrap.isSuccess = False;
                respWrap.errorMessage ='Exception: '+e.getMessage();
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
                RestContext.response.statusCode = 400; 
            }
        }else{
            
            respWrap.isSuccess = False;
            respWrap.errorMessage ='inputData is Blank';
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
            RestContext.response.statusCode = 400; 
        }
        System.debug('respWrap: '+respWrap);
      
        
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(Json.serializePretty(respWrap)); 
    }


    Public class RequestWrapper{
        Public String CustomerID;
        Public String LastName;
        Public String SobjectName;
    }

    Public class ResponseWrapper{
        Public Boolean isSuccess;
        Public String errorMessage;
    }

}