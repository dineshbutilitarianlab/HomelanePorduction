@RestResource(urlMapping='/UpdateShowroomAPI/*')
Global class UpdateShowroomAPI {
    @HttpPost
    global static void updateShowroom() {
        ResponseWrapper respWrap = new ResponseWrapper();
        try{
            RestRequest req = RestContext.request;
            system.debug('req.requestBody : '+req.requestBody );
            String inputData = req.requestBody.toString();
            Set<String> typeString = new Set<String>{GenericConstants.Showroom_Type, GenericConstants.Dealer_Showroom_Type};
            
            system.debug('inputData : '+inputData );
            if(!String.isBlank(inputData)){
                RequestWrapper reqWrap = (RequestWrapper)Json.deserialize(inputData, RequestWrapper.Class);
                if(!String.isBlank(reqWrap.recordId) && !String.isBlank(reqWrap.showRoomId)){
                    Master__c showroom = new Master__c();
                    List<Master__c> listOfQuerriedShowroom = new List<Master__c>();
                    listOfQuerriedShowroom = [Select id,IsActive__c,Type__c,Name from Master__c where IsActive__c=True and Type__c IN :typeString and id=:reqWrap.showRoomId limit 1];
                    if(!listOfQuerriedShowroom.isEmpty()){
                        showroom = listOfQuerriedShowroom[0];
                        Id srId = (Id)reqWrap.recordId;
                        String sObjectName = srId.getSObjectType().getDescribe().getName();
                        System.debug('sObjectName: '+sObjectName);
                        if(sObjectName == 'Lead'){
                            
                            //Update the lead
                            Lead leadToUpdate = new Lead();
                            leadToUpdate.id = reqWrap.recordId;
                            leadToUpdate.Appointment_Venue_Square__c = showroom.Id;
                            leadToUpdate.Square_Showroom__c = showroom.Name;
                            leadToUpdate.Cubico__c=reqWrap.cubico;		//Added on 1st April 2024                    
                            update leadToUpdate;
                            System.debug('Lead Updated');
                        }
                        else if(sObjectName == 'Opportunity'){
                            Lead leadToUpdate = new Lead();
                            Opportunity opp = new Opportunity();
                            opp = [Select id,Name,LeadId__c from Opportunity where id=:reqWrap.recordId limit 1];
                            System.debug('opp: '+opp);
                            if(opp.LeadId__c !=null){
                                //Update the Opportuntiy
                                opp.Id = reqWrap.recordId;
                                opp.Appointment_Venue_Square__c = showroom.Id;
                                opp.Square_Showroom__c = showroom.Name;
                                opp.Cubico__c=reqWrap.cubico;	//Added on 1st April 2024
                                update opp;
                                
                                System.debug('Opportunity Updated');
                                //Update Lead associated with the Opportunity
                                leadToUpdate.Id = opp.LeadId__c;
                                leadToUpdate.Appointment_Venue_Square__c = showroom.Id;
                                leadToUpdate.Square_Showroom__c = showroom.Name;
                                leadToUpdate.Cubico__c=reqWrap.cubico;		//Added on 1st April 2024
                            	update leadToUpdate;
                                System.debug('Lead Updated');
                            }
                            else{
                                System.debug('The lead associated with this opportunity is blank or deleted in SF.');
                                respWrap.isSuccess = False;
                                respWrap.errorMessage ='The lead associated with this opportunity is blank or deleted in SF.';
                            }
                        }
                        else{
                            System.debug('No Lead or Opportunity record associated with this recordId found in SF.');
                            respWrap.isSuccess = False;
                            respWrap.errorMessage ='No Lead or Opportunity record associated with this recordId found in SF.'; 
                        }
                        System.debug('Success');
                        respWrap.isSuccess = True;
                        respWrap.errorMessage ='Success';
                    }
                    else{
                        system.debug('There is no Active showroom with this showroomId: '+reqWrap.showRoomId);
                        respWrap.isSuccess = False;
                        respWrap.errorMessage ='There is no Active showroom with this showroomId: '+reqWrap.showRoomId;
                    }
                }
                else{
                    system.debug('Either showroomId or recordId is blank-- showroomId: '+reqWrap.showroomId+' ---recordId : '+reqWrap.recordId );
                    respWrap.isSuccess = False;
                    respWrap.errorMessage ='Either showroomId or recordId is blank';
                }
            }
            else{
                system.debug('inputData is Blank: '+inputData );
                respWrap.isSuccess = False;
                respWrap.errorMessage ='inputData is Blank';
            }
        }
        Catch(Exception e){
            system.debug('Exception: '+e.getMessage()+ e.getStackTraceString());
            Logger.log('Exception','UpdateShowroom class','updateShowroom method',e.getMessage(),e.getStackTraceString(),NULL);
            respWrap.isSuccess = False;
            respWrap.errorMessage ='Exception: '+e.getMessage()+' StackTrace: '+e.getStackTraceString();
        }
        System.debug('respWrap: '+respWrap);
        string repsponseData = json.serialize(respWrap);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(repsponseData);
    }
    Public class RequestWrapper{
        Public String recordId;
        Public String showRoomId;
        Public Boolean cubico;	//Added on 1st April 2024
    }
    Public class ResponseWrapper{
        Public Boolean isSuccess;
        Public String errorMessage;
    }
}