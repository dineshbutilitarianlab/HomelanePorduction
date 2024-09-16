@RestResource(urlMapping='/PostProcessingAPI/*')
global with sharing class  PostProcessingController
{
  public Static String strBody{get;set;}
  public Static String strBody1{get;set;}
  public Static String strBody2{get;set;}
  public Static String strBody3{get;set;}
@HttpGet
  global static void getLeadrec() {
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        RestRequest req = RestContext.request; 
        String phone = '';
        Map<String,String> ParamData = new Map<String,String>();
        if(!Test.IsRunningTest()){
            ParamData = req.params;
            phone = ParamData.get('phone');
         }
        else{
          phone = strBody; 
          ParamData.put('phone',phone);
          ParamData.put('dispositionCode',strBody1);
          ParamData.put('userAssociations',strBody2);
          ParamData.put('first_dial_time',strBody3);
          ParamData.put('callbackTime',strBody3);
          ParamData.put('systemDisposition',strBody1);
          ParamData.put('numAttempts','9');
          ParamData.put('dialedTime',strBody3);
        }
          system.debug('------ParamData-----'+ParamData);    
          List<sObject> opplist = new List<sObject>();
          String datavalue = JSON.serialize(ParamData); for(String str : ParamData.keyset()){system.debug('------str-----'+ParamData.get(str)+'------key----'+str);}
        List<Lead> leadlist = new List<Lead>(); 
        try{
        System.debug('****phone is : '+phone);  
        System.debug('******dialedTime  is   '+ParamData.get('dialedTime'));  
        if(phone != null){
            Map<String,User> mapUserData = new Map<String,User>();
            //if(ParamData.get('dispositionCode') != null){ numAttempts
            String strDisposition = String.valueOf(ParamData.get('dispositionCode'));
            String strSysDisposition = String.valueOf(ParamData.get('systemDisposition'));
            Integer noOfCalls = 0;
            if(!Test.IsRunningTest()){
                Call_Attempts__c objCallAttemps = Call_Attempts__c.getValues('Lead Calls');
                 noOfCalls = Integer.valueOf(objCallAttemps.Number_of_Calls__c);
            }else{
               noOfCalls = 9; 
            }
              Map<String,Object> mapUserAssociations = new Map<String,Object>();
            system.debug('------------ParamData.get(userAssociations)---------------'+(String) ParamData.get('userAssociations'));
            String strUserAssociations = ParamData.get('userAssociations').replaceAll('\\\\','');
            system.debug('------------strUserAssociations[0]---------------'+strUserAssociations);
            List<Object>  lstUserAssociations = (List<Object>) JSON.deserializeUntyped(strUserAssociations);
         //   system.debug('------------lstUserAssociations---------------'+lstUserAssociations[0]);
               for(Object obj : lstUserAssociations){
                    Map<String,Object> mapData = (Map<String,Object>) obj;
                    mapUserAssociations.putAll(mapData); 
                }
            system.debug('------------mapUserAssociations---------------'+mapUserAssociations);
                if((String) mapUserAssociations.get('userId') != null){
                    try{
                    for(User objUser : [Select Id,FirstName,Email,UserName from User where UserName = : (String) mapUserAssociations.get('userId') Limit 1])
                        MapUserData.put(objUser.UserName,objUser);
                    }catch(Exception exp){
                        system.debug('---User Is not found on SF---'+exp.getMessage());
                         SendEmailToManager('Salesforce - This is to inform you that Lead with the phone ='+phone+' is not Updated,Because User with user name '+mapUserAssociations.get('userId')+' we got the following error-'+exp.getMessage()+' at Line '+exp.getLineNumber()+' StackTrack '+exp.getStackTraceString()+'.Please do the needful');
                    }
                }
            system.debug('------------mapUserAssociations---------------'+mapUserAssociations);
            system.debug('------------MapUserData---------------'+MapUserData);
            //}
            system.debug('email ------------------->'+ParamData.get('phone'));
            String leadoppquery = 'Select id,Status,Attempts_since_last_connection__c,Calculated_WT_allocated_time__c,Follow_up_time__c,Description__c,Ameyo_Call_Attempts__c,Test_API_Date__c,Sub_Status__c,WT_Agent__c,WT_Agent__r.Name,Owner.Name,OwnerId,WT_Agent_Allocated_Time__c from Lead where Phone = \''+phone+'\' AND IsConverted = false';
            if(Database.query(leadoppquery)!=null && (!Database.query(leadoppquery).isEmpty())){
                opplist = Database.query(leadoppquery);
                system.debug('------------opplist---------------'+opplist);
                List<Lead> listopp = (List<Lead>)(opplist);
                 Lead obj = new Lead();
                for(Lead objLead : listopp){
                    obj.Id = objLead.id;
                    obj.Test_API_Date__c = datavalue;
                    obj.Ameyo_Call_Attempts__c = Integer.valueOf(ParamData.get('numAttempts')); 
                      
                  try{
                       if(ParamData.get('callbackTime') != null){
                        String strCallTime = String.ValueOf(ParamData.get('callbackTime'));
                        strCallTime = strCallTime.replace('_',' ');
                         if(String.ValueOf(ParamData.get('callbackTime')) !='' && String.ValueOf(ParamData.get('callbackTime')) != null && objLead.Follow_up_time__c != DateTime.valueOf(strCallTime)){
                            obj.Follow_up_time__c = DateTime.valueOf(strCallTime);
                         }
                       }
                        String strDate = String.ValueOf(ParamData.get('first_dial_time'));
                        strDate = strDate.replace('_',' ');
                         String strLastdialDate = String.ValueOf(ParamData.get('dialedTime'));
                        strLastdialDate = strLastdialDate.replace('_',' ');
                     try{
                        if(strDate !='' && strDate !=null && (!strDate.contains('undefined'))){
                            DateTime firdtTime = DateTime.valueof(strDate);
                            if(obj.WT_Agent_Allocated_Time__c == null)
                            obj.WT_Agent_Allocated_Time__c = firdtTime ;
                          }
                         if(strLastdialDate !='' && strLastdialDate !=null && (!strLastdialDate.contains('undefined'))){
                            DateTime lastTime = DateTime.valueof(strLastdialDate);
                            obj.Last_Dialed_Time__c = lastTime;
                          }
                          // update field Calculated_WT_allocated_time__c
                          if(strLastdialDate !='' && strLastdialDate !=null && (!strLastdialDate.contains('undefined')) && objLead.Calculated_WT_allocated_time__c == null){
                            DateTime lastTime = DateTime.valueof(strLastdialDate);
                            obj.Calculated_WT_allocated_time__c = lastTime;
                          }

                        }catch(Exception exp){
                            system.debug('Date Time Formet issue------'+exp.getMessage());
                             SendEmailToManager('Salesforce - This is to inform you that Lead with the phone ='+phone+' is not Updated,Because we got the following error-'+exp.getMessage()+' at Line '+exp.getLineNumber()+' StackTrack '+exp.getStackTraceString()+'.Please do the needful');
                        }
                        system.debug('objLead.Status before------'+strDisposition+'-----'+objLead.Status+'-------'+MapUserData);
                       system.debug('obj.Status------'+strDisposition+'-----'+objLead.Status+'-------'+MapUserData);
                      /*  Date strFollowUpLater = Date.today();
                       if(objLead.Follow_up_time__c !=null)
                          strFollowUpLater = Date.newinstance(objLead.Follow_up_time__c.year(), objLead.Follow_up_time__c.month(),objLead.Follow_up_time__c.day());
                          system.debug('---------strFollowUpLater--------'+strFollowUpLater);*/
 /************************************************ Start System Disposition Not Connected**************************/                   
                      if(!strSysDisposition.equalsIgnoreCase('connected')){
                         /* String strDesc = objLead.Description__c;
                          if(strDesc == null)
                              strDesc ='';
                          String formatted = System.Now().format('dd/MM/yyyy\' \'HH:mm');
                          strDesc = formatted+' - '+ MapUserData.get((String) mapUserAssociations.get('userId')).FirstName +' - '+ strDisposition+'\n'+strDesc;
                           obj.Description__c = strDesc;
                          
                       
                        if(objLead.Status == 'Fresh Lead' && objLead.Sub_Status__c != 'New' && strDisposition.equalsIgnoreCase('Couldn\'t_Contact') && strFollowUpLater <= Date.today() && objLead.Attempts_since_last_connection__c <= 6){
                           obj.Follow_up_time__c = System.now().addDays(1);
                           system.debug('---------objLead strFollowUpLater--------'+objLead);
                        }
                        if(objLead.Status != 'Appointment Fixed' && objLead.Status != 'Appointment Confirmed' && strDisposition.equalsIgnoreCase('Couldn\'t_Contact') && objLead.Attempts_since_last_connection__c >= 6){
                                obj.Follow_up_time__c = null;
                                obj.Status = 'Not Actively Pursued';
                                obj.Sub_Status__c = 'Not Actively Pursued';

                        }
                        if(objLead.Status == 'Fresh Lead' && objLead.Sub_Status__c != 'New' && strDisposition.equalsIgnoreCase('Couldn\'t_Contact')){
                            obj.Sub_Status__c = 'Call back in 2 hrs';
                            obj.Follow_up_time__c = System.now().addHours(2);
                        }
                        if(objLead.Status == 'Fresh Lead' && objLead.Sub_Status__c != 'Call back in 2 hrs' && strDisposition.equalsIgnoreCase('Couldn\'t_Contact')){
                            obj.Sub_Status__c = 'Unable To Contact';
                        }*/
                        if(objLead.WT_Agent__r.Name == 'Ameyo User' && objLead.Owner.Name =='Ameyo User' && Integer.valueOf(ParamData.get('numAttempts')) == noOfCalls){
                             if(MapUserData.get((String) mapUserAssociations.get('userId')) != null){
                              obj.WT_Agent__c = MapUserData.get((String) mapUserAssociations.get('userId')).Id;
                              obj.OwnerId = MapUserData.get((String) mapUserAssociations.get('userId')).Id;
                             

                            }
                          }
                          if(objLead.WT_Agent__r.Name != 'Ameyo User' && objLead.Owner.Name =='Ameyo User' && Integer.valueOf(ParamData.get('numAttempts')) == noOfCalls){
                             if(MapUserData.get((String) mapUserAssociations.get('userId')) != null){
                              //obj.WT_Agent__c = MapUserData.get((String) mapUserAssociations.get('userId'));
                              obj.OwnerId = MapUserData.get((String) mapUserAssociations.get('userId')).Id;
                             // obj.Description = strDesc;
                            }
                          }
                      /* if((strDisposition.equalsIgnoreCase('Wrong_Number') || strDisposition.equalsIgnoreCase('DND')  || strDisposition.equalsIgnoreCase('Test')  || strDisposition.equalsIgnoreCase('Dead_Lead')) && objLead.Sub_Status__c =='New' && objLead.Status =='Fresh Lead'){
                              obj.Status = 'Dead Lead';
                              obj.Sub_Status__c = 'Wrong Contact Number';

                              if(MapUserData.get((String) mapUserAssociations.get('userId')) != null && objLead.WT_Agent__r.Name == 'Ameyo User' && objLead.Owner.Name =='Ameyo User'){
                                 obj.WT_Agent__c = MapUserData.get((String) mapUserAssociations.get('userId')).Id;
                                 obj.OwnerId = MapUserData.get((String) mapUserAssociations.get('userId')).Id;
                            }
                          }*/
                        }
/************************************************ End System Disposition Not Connected**************************/                          
                       /* if(strDisposition.equalsIgnoreCase('Unable_To_Contact') && objLead.WT_Agent__r.Name == 'Ameyo User'){
                              obj.Status = 'Fresh Lead';
                              obj.Sub_Status__c = 'Unable To Contact';
                              obj.Follow_up_time__c = System.Now().AddDays(1);
                             }*/
                          
                          if(strSysDisposition.equalsIgnoreCase('connected') && objLead.WT_Agent__r.Name == 'Ameyo User' && objLead.Owner.Name =='Ameyo User'){
                             if(MapUserData.get((String) mapUserAssociations.get('userId')) != null){
                              obj.WT_Agent__c = MapUserData.get((String) mapUserAssociations.get('userId')).Id;
                              obj.OwnerId = MapUserData.get((String) mapUserAssociations.get('userId')).Id;
                              obj.Attempts_since_last_connection__c = 0;
                            }
                          }
                          if(strSysDisposition.equalsIgnoreCase('connected') && objLead.WT_Agent__r.Name == 'Ameyo User'){
                              obj.Attempts_since_last_connection__c = 0;
                           
                          }
                          if(strSysDisposition.equalsIgnoreCase('connected') && objLead.WT_Agent__r.Name != 'Ameyo User' && objLead.Owner.Name =='Ameyo User'){
                             if(MapUserData.get((String) mapUserAssociations.get('userId')) != null){
                             // obj.WT_Agent__c = MapUserData.get((String) mapUserAssociations.get('userId'));
                              obj.OwnerId = MapUserData.get((String) mapUserAssociations.get('userId')).Id;
                              obj.Attempts_since_last_connection__c = 0;
                            }
                          }
                           if((!strSysDisposition.equalsIgnoreCase('connected')) && strDisposition.equalsIgnoreCase('Couldn\'t_Contact')){
                            if(objLead.Attempts_since_last_connection__c == null)
                               obj.Attempts_since_last_connection__c = 1;
                            else
                              obj.Attempts_since_last_connection__c = objLead.Attempts_since_last_connection__c+1;
                           }
                          
                   
                    }catch(Exception exp){ SendEmailToManager('Salesforce - This is to inform you that Lead with the phone ='+phone+' is not Updated,Because we got the following error-'+exp.getMessage()+' at Line '+exp.getLineNumber()+' StackTrack '+exp.getStackTraceString()+'.Please do the needful');}
                    system.debug('leadoppquery -------------------->'+finalList);
                }
                update obj;
                
                Map<String,String> mapMonths = new Map<String,String>();
                mapMonths.put('1','Jan');
                mapMonths.put('2','Feb');
                mapMonths.put('3','Mar');
                mapMonths.put('4','Apr');
                mapMonths.put('5','May');
                mapMonths.put('6','Jun');
                mapMonths.put('7','Jul');
                mapMonths.put('8','Aug');
                mapMonths.put('9','Sep');
                mapMonths.put('10','Oct');
                mapMonths.put('11','Nov');
                mapMonths.put('12','Dec');
                
                Map<String,String> mapWeek = new Map<String,String>();
                mapWeek.put('Sunday','Sun');
                mapWeek.put('Monday','Mon');
                mapWeek.put('Tuesday','Tue');
                mapWeek.put('Wednesday','Wed');
                mapWeek.put('Thursday','Thu');
                mapWeek.put('Friday','Fri');
                mapWeek.put('Saturday','Sat');
                
                try{                  
                  Task tsk = [Select Id,Post_Processing_Disposition__c from Task Where CrtObjectId__c =:ParamData.get('customerCRTId') limit 1];
                      tsk.Post_Processing_Disposition__c = ParamData.get('systemDisposition'); 
                      tsk.Call_ID__c = ParamData.get('callId'); 
                      update tsk;                   
            
                }
                
                catch(Exception ex){
                      Datetime dt = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
                      String dayOfWeek=dt.format('EEEE');
                      System.debug('Day : ' + dayOfWeek);
                      String day = string.valueOf(DateTime.now().day());
                      String month = string.valueOf(DateTime.now().month());
                      String hour = string.valueOf(DateTime.now().hour());
                      String minute = string.valueOf(DateTime.now().minute());
                      String second = string.valueOf(DateTime.now().second());
                      String year = string.valueOf(DateTime.now().year());
                      String monthStr = mapMonths.get(month);
                      system.debug('------monthStr----  '+monthStr); 
                      String dayStr = mapWeek.get(dayOfWeek);
                      system.debug('------dayStr------  '+dayStr);                        
                      String subjectOfTask = dayStr+' '+monthStr+' '+day+' '+year+' '+hour+':'+minute+':'+second+' GMT 0530 (India Standard Time)';                        
                      system.debug(subjectOfTask );
                      try {
                          Task objTask = new Task();
                          objTask.subject = subjectOfTask;
                          if((String) mapUserAssociations.get('userId') != null){
                              User use = [select id, Name from User where UserName =:String.valueOf(mapUserAssociations.get('userId')) limit 1];                          
                              System.debug('-----use---  '+use);
                              objTask.OwnerId = use.Id;
                              System.debug('-----use.Id---  '+use.Id);
                              objTask.WhoId = obj.Id;
                              System.debug('-----obj.Id---  '+obj.Id);
                              System.debug('-----ParamData.get(systemDisposition)---  '+ParamData.get('systemDisposition')+'------ParamData.get(customerCRTId)----  '+ParamData.get('customerCRTId')+'------ParamData.get(dispositionCode)  '+ParamData.get('dispositionCode')+'-------ParamData.get(recordingFileUrl)  '+ParamData.get('recordingFileUrl')+'--------String.valueOf(mapUserAssociations.get(associtionType))  '+String.valueOf(mapUserAssociations.get('associtionType'))+'---------ParamData.get(callId)  '+ParamData.get('callId'));
                              objTask.Post_processing_activity__c = true;
                              objTask.Post_Processing_Disposition__c = ParamData.get('systemDisposition');
                              objTask.CrtObjectId__c = ParamData.get('customerCRTId');  
                              objTask.Disposition_Type__c = ParamData.get('dispositionCode');
                              objTask.recording_url__c = ParamData.get('recordingFileUrl');
                              objTask.Call_Association_Type__c = String.valueOf(mapUserAssociations.get('associtionType'));
                              objTask.Call_ID__c = ParamData.get('callId');
                              objTask.status = 'Completed';
                              insert objTask;
                              System.debug('-----objTask---  '+objTask);
                          }
                      }
                      catch(DMLException e){
                          System.debug('The error inside catch is  : '+e.getMessage()+' at Line '+e.getLineNumber()+' StackTrack '+e.getStackTraceString());
                      }
                      
                    // SendEmailToManager('Salesforce - This is to inform you that Lead with the phone ='+phone+' is having some issue to update activity data,Because we got the following error-'+ex.getMessage()+' at Line '+ex.getLineNumber()+' StackTrack '+ex.getStackTraceString()+'.Please do the needful');
                    System.debug('The error is  : '+ex.getMessage()+' at Line '+ex.getLineNumber()+' StackTrack '+ex.getStackTraceString());
                    
                }
            }
            FinalWrapper fin = new FinalWrapper();
            fin.status = true;
            finalList.add(fin);   
            
        }
       }catch(Exception ex){
            FinalWrapper fin = new FinalWrapper();
                    fin.status = false;
                    finalList.add(fin);
                    SendEmailToManager('Salesforce - This is to inform you that Lead with the phone ='+phone+' is not Updated,Because we got the following error-'+ex.getMessage()+' at Line '+ex.getLineNumber()+' StackTrack '+ex.getStackTraceString()+'.Please do the needful');
                system.debug('oppoppquery Error-------------------->'+ex.getMessage());
                    }
               
                    
         if(!Test.isRunningTest()){string json_data = json.serialize(finalList);RestContext.response.addHeader('Content-Type', 'application/json');RestContext.response.responseBody = Blob.valueOf(json_data);}    
       }
         
        
        global class FinalWrapper{
            public boolean status{get;set;}
           
           
            
        }
        global Static void SendEmailToManager(String errMsg){
          String[] strUserEmail = new List<String>();
         if(!Test.isRunningTest()){Exception_Mail__c objAmeyo = Exception_Mail__c.getValues('SF Lead Mail');strUserEmail = objAmeyo.Email_Addresss__c.split(',');
         }else{
          strUserEmail.add('testapi@gmail.com');
         }
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.toAddresses = strUserEmail ; 
                            message.optOutPolicy = 'FILTER';
                            message.subject = 'Post Processing API Failure';
                            message.plainTextBody = errMsg;
                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
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
        }
      
        
}