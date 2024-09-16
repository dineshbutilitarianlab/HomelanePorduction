/**
* @File Name          : LeadSquaredBatchCallOutHandler.cls
* @Description        : 
* @Author             : Bharatesh Shetty
* @Group              : 
* @Last Modified By   : Bharatesh Shetty
* @Last Modified On   : 9/19/2019, 2:38:15 PM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author                    Modification
*==============================================================================
* 1.0    8/27/2019, 12:24:46 PM   Bharatesh Shetty     Initial Version
**/
public class LeadSquaredBatchCallOutHandler {
    /**
* @description
* @author Bharatesh Shetty | 8/14/2019
* @param Map<Id, Opportunity> mapOfLeads
* @return void
*/
    public static void handleLeadSquaredDetailsCallOuts(Map<Id,SObject> mapOfSobjects,String sObjectName){
        System.debug('handleLeadSquaredDetailsCallOuts method called');
        try{
            if(!mapOfSobjects.isEmpty()){
                List<LeadSquareIntegration_Controller.LeadSquaredResponseWrapper> listOfResponseWrapper = new List<LeadSquareIntegration_Controller.LeadSquaredResponseWrapper>();
                LeadSquareIntegration_Controller.ResponseWrapper wrapper = LeadSquareIntegration_Controller.getLeadSquaredRequestWrapper((List<SObject>)mapOfSobjects.Values(),sObjectName);
                if(wrapper !=null && !String.isBlank(wrapper.sbody) && !wrapper.mapPosition.isEmpty()){
                    //String body = wrapper.sbody;
                    System.debug('body: '+wrapper.sbody);
                    listOfResponseWrapper = LeadSquareIntegration_Controller.calloutToLeadSquared(wrapper.sbody,'LeadSquared API');
                    if(!listOfResponseWrapper.isEmpty()){
                        List<Lead> listOfSucceededLeadsToUpdate = new List<Lead>();
                        List<Opportunity> listOfSucceededOppsToUpdate = new List<Opportunity>();
                        List<Log__c> listOfLogToInsert = new List<Log__c>();
                        for(LeadSquareIntegration_Controller.LeadSquaredResponseWrapper respWrap :listOfResponseWrapper){
                            System.debug('respWrap.LeadCreated: '+respWrap.LeadCreated);
                            System.debug('respWrap.LeadUpdated: '+respWrap.LeadUpdated);
                            if((respWrap.LeadCreated || respWrap.LeadUpdated) && wrapper.mapPosition.containsKey(respWrap.RowNumber)){
                                if(sObjectName == 'Lead'){
                                    Lead recordToUpdate = new Lead();
                                    System.debug('respWrap.RowNumber : '+respWrap.RowNumber);
                                    System.debug(' Id : '+wrapper.mapPosition.get(respWrap.RowNumber).Id);
                                    recordToUpdate.id = wrapper.mapPosition.get(respWrap.RowNumber).Id;
                                    recordToUpdate.Lead_Square_Modified_Date__c = null;
                                    if(((Lead)(wrapper.mapPosition.get(respWrap.RowNumber))).Lead_Squared_Id__c ==null){
                                        recordToUpdate.Lead_Squared_Id__c = respWrap.LeadId;
                                    }
                                    listOfSucceededLeadsToUpdate.add(recordToUpdate);
                                }
                                else if(sObjectName == 'Opportunity'){
                                    Opportunity recordToUpdate = new Opportunity();
                                    System.debug('respWrap.RowNumber : '+respWrap.RowNumber);
                                    System.debug(' Id : '+wrapper.mapPosition.get(respWrap.RowNumber).Id);
                                    recordToUpdate.id = wrapper.mapPosition.get(respWrap.RowNumber).Id;
                                    recordToUpdate.Lead_Square_Modified_Date__c = null;
                                    if(((Opportunity)(wrapper.mapPosition.get(respWrap.RowNumber))).Lead_Squared_Id__c ==null){
                                        recordToUpdate.Lead_Squared_Id__c = respWrap.LeadId;
                                    }
                                    listOfSucceededOppsToUpdate.add(recordToUpdate);
                                }
                            }
                            else if(wrapper.mapPosition.containsKey(respWrap.RowNumber) && !String.isBlank(Label.shouldCaptureLSQBatchLog)){
                                system.debug('Lead neither created nor updated after success');
                                if(Label.shouldCaptureLSQBatchLog.replaceAll(' ','').equalsIgnoreCase('YES')){
                                    Log__c log = Logger.returnLog('Error','LeadSquaredBatchCallOutHandler','handleLeadSquaredDetailsCallOuts method','Lead neither created nor updated after success',respWrap.toString(),wrapper.mapPosition.get(respWrap.RowNumber).Id);
                                    listOfLogToInsert.add(log); 
                                } 
                            }
                            else{
                                System.debug('Lead neither created nor updated after success and key not found in the map');
                            }
                        }
                        if(!listOfSucceededLeadsToUpdate.isEmpty()){
                            System.debug('listOfSucceededLeadsToUpdate is not empty');
                            update listOfSucceededLeadsToUpdate ;
                        }
                        else if(!listOfSucceededOppsToUpdate.isEmpty()){
                            System.debug('listOfSucceededOppsToUpdate is not empty');
                            update listOfSucceededOppsToUpdate ;
                        }
                        if(!listOfLogToInsert.isEmpty()){
                            System.debug('log list is not empty');
                            insert listOfLogToInsert;
                        }
                    }
                }
            }
        }
        catch(Exception e){
            system.debug('Exception : '+e.getStackTraceString() + 'Exception' +e.getMessage());
            Logger.log('Exception','LeadSquaredBatchCallOutHandler','handleLeadSquaredDetailsCallOuts',e.getMessage(),e.getStackTraceString(),null);
        }
    }
}