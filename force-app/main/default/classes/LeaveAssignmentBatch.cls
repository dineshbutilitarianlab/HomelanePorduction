global class LeaveAssignmentBatch implements Database.Batchable<sObject>, Database.Stateful{
    global String query;
    global Set<String> setRoundRobin = new Set<String>();
    global Map<String,String> mapUserData= new Map<String,String>();
    global Map<String,String> listAddedUsers = new Map<String,String>();
    global Map<String,List<Lead_Assignment__c>> mapRoundRobinAssignment = new Map<String,List<Lead_Assignment__c>>();
    global Map<String,Set<String>> mapExistsRoundRobin = new Map<String,Set<String>>();
    List<Agent_Roster__c> lstUpdatedLeaves = new List<Agent_Roster__c>();
    Map<String,Agent_Roster__c> mapOnLeaveUser = new Map<String,Agent_Roster__c>();
    global static boolean isBatchExecuted{get;set;}
    global boolean isError{get;set;}
    global String StrErrMessage{get;set;}
    global RR_Deactivate_Time__c RRDT{get;set;}
    global Integer strNextShift;
    List<Lead_Assignment__c> listUpdateLeadAssignment = new List<Lead_Assignment__c>();
    global LeaveAssignmentBatch(){
         StrErrMessage = '';
         isBatchExecuted = false;
         isError = false;
        try{
         
          query = 'Select Id,User__c,User__r.Name,Assign_Percent__c,Round_Robin__c From Lead_Assignment__c';      
          system.debug('-------query-----------'+query);
        }catch(exception exp){
            system.debug('-------exp-----------'+exp.getmessage());
            isError = true;
             StrErrMessage  = 'Error Message -'+exp.getmessage()+'-In Line-'+exp.getLineNumber()+'-Cause-'+exp.getCause()+'-StackTrack-'+exp.getStackTraceString();
        }
             
        
    }
    
     global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
      global void execute(Database.BatchableContext BC, List<Lead_Assignment__c> lstLeadAssignment){
       try{
         RRDT = RR_Deactivate_Time__c.getvalues('Daily Time');
         Date LeaveDate = System.Today();
         String[] patternArray = RRDT.Pattern__c.split(',');
         List<Agent_Roster__c> lstLeaveHolidays = [Select Id,Reporting_Time__c,Login_Active_Status__c,Apply_Date__c,User__c,Round_Robin__c From Agent_Roster__c Where Apply_Date__c =: LeaveDate];
          for(Agent_Roster__c objLeaves : lstLeaveHolidays){
              if(objLeaves.Reporting_Time__c =='OFF' || objLeaves.Reporting_Time__c =='Leave'){
                  setRoundRobin.add(objLeaves.Round_Robin__c);
                  mapUserData.put(objLeaves.User__c,objLeaves.Id);
                }else {
                    Integer index = objLeaves.Reporting_Time__c.indexOf(':');
                    system.debug('-------RRDT.Reporting_Time__c)-----------'+RRDT.Reporting_Time__c);
                    Integer strReportingtime = Integer.valueOf(objLeaves.Reporting_Time__c.subString(0,index));
                    system.debug('-------strReportingtime-----------'+strReportingtime);
                        if(strReportingtime == RRDT.Reporting_Time__c){
                            system.debug('-------Equeal-----------'+patternArray);
                            Integer strIndex = 0;
                            for(Integer j=0;j<patternArray.size();j++){
                                if(Integer.valueOf(patternArray[j]) == RRDT.Reporting_Time__c)
                                    strIndex = j;
                            }
                            if(objLeaves.Login_Active_Status__c == false){
                                objLeaves.Reporting_Time__c = 'Leave';
                                lstUpdatedLeaves.add(objLeaves);
                                mapOnLeaveUser.put(objLeaves.User__c,objLeaves);
                            }
                            if(strIndex == patternArray.size()-1){
                                strNextShift = Integer.valueOf(patternArray[0]);
                            }else{
                                strNextShift = Integer.valueOf(patternArray[strIndex+1]);
                            }
                            system.debug('-------strNextShift-----------'+strNextShift);
                    }
                }
              
            }
           system.debug('-------lstLeadAssignment-----------'+lstLeadAssignment);  
          for(Lead_Assignment__c objLA : lstLeadAssignment){
              if(mapRoundRobinAssignment.containsKey(objLA.Round_Robin__c)){
                 mapRoundRobinAssignment.get(objLA.Round_Robin__c).add(objLA);
                 system.debug('-------mapRoundRobinAssignment existing-----------'+mapRoundRobinAssignment);                 
              }else {
                  List<Lead_Assignment__c> listUserId = new List<Lead_Assignment__c>();
                  listUserId.add(objLA);
                  mapRoundRobinAssignment.put(objLA.Round_Robin__c,listUserId);
                  system.debug('-------mapRoundRobinAssignment-----------'+mapRoundRobinAssignment);                  
              }
              if(mapUserData.containsKey(objLA.User__c) || mapOnLeaveUser.containsKey(objLA.User__c)){
                  if(mapExistsRoundRobin.containsKey(objLA.Round_Robin__c)){
                      mapExistsRoundRobin.get(objLA.Round_Robin__c).add(objLA.User__c);
                     
                  }else{
                      Set<String> setUserIds = new Set<String>();
                      setUserIds.add(objLA.User__c);
                      mapExistsRoundRobin.put(objLA.Round_Robin__c,setUserIds);
                  }
            }
            }
        for(Lead_Assignment__c objScoendLA : lstLeadAssignment){
              Integer teamSize = 0;
            //if((mapUserData.containsKey(objScoendLA.User__c)) && (!listAddedUsers.containsKey(objScoendLA.User__c))){
                if(mapExistsRoundRobin.containsKey(objScoendLA.Round_Robin__c))
                    teamSize = mapRoundRobinAssignment.get(objScoendLA.Round_Robin__c).size() - mapExistsRoundRobin.get(objScoendLA.Round_Robin__c).size();
                else
                    teamSize = mapRoundRobinAssignment.get(objScoendLA.Round_Robin__c).size();
                system.debug('-------teamSize-----------'+teamSize);
                if(teamSize >0){
                Integer assignPersent = 100/teamSize;
                system.debug('-------assignPersent-----------'+assignPersent);              
                for(Lead_Assignment__c objMap : mapRoundRobinAssignment.get(objScoendLA.Round_Robin__c)){
                    if((mapUserData.containsKey(objMap.User__c) || mapOnLeaveUser.containsKey(objMap.User__c)) && (!listAddedUsers.containsKey(objMap.User__c))){
                        objMap.Assign_Percent__c = 0;
                        listUpdateLeadAssignment.add(objMap);
                        
                    }else if(!listAddedUsers.containsKey(objMap.User__c)){
                        objMap.Assign_Percent__c = assignPersent;
                        listUpdateLeadAssignment.add(objMap);
                    }
                 listAddedUsers.put(objMap.User__c,'Added');    
                }
                system.debug('-------listUpdateLeadAssignment-----------'+listUpdateLeadAssignment);    
                system.debug('-------listAddedUsers-----------'+listAddedUsers);
                }               
         //}
              
           
        }   
        if(!listUpdateLeadAssignment.isEmpty()){
            update listUpdateLeadAssignment;
        }
        if(!lstUpdatedLeaves.isEmpty()){
             update lstUpdatedLeaves;
        }       
      }catch(Exception exp){
        system.debug('-------Exception-----------'+exp.getMessage());
        isError = true;
        StrErrMessage  = 'Error Message -'+exp.getmessage()+'-In Line-'+exp.getLineNumber()+'-Cause-'+exp.getCause()+'-StackTrack-'+exp.getStackTraceString();      
      } 
      }
    
     global void finish(Database.BatchableContext BC){
        try{ 
        isBatchExecuted = true;
        List<Lead> listNewLead = new List<Lead>();      
        Map<Id,Group> mapQueue = new Map<Id,Group>([Select Id,Name From Group Where Type = 'Queue']);
        system.debug('-------mapQueue-----------'+mapQueue);
        
        system.debug('-------RRDT-----------'+RRDT.Deactivation_Time__c);
        for(Lead objLead : [Select Id,Lead_Assingment__c from Lead Where OwnerId IN : mapQueue.keyset() AND CreatedDate >=: 
        RRDT.Deactivation_Time__c]){
            system.debug('-------objLead-----------'+objLead);
            objLead.Lead_Assingment__c = false;
            listNewLead.add(objLead);
        }
        update listNewLead;
        if(strNextShift != null){
            RRDT.Reporting_Time__c = strNextShift;
            update RRDT;
        }       
        }catch(exception exp){
            system.debug('-------exp finish-----------'+exp.getmessage());
            isError = true;
             StrErrMessage  = 'Error Message -'+exp.getmessage()+'-In Line-'+exp.getLineNumber()+'-Cause-'+exp.getCause()+'-StackTrack-'+exp.getStackTraceString();
        }
      if(isError){
          String[] sendTo = new List<String>();
          if(RRDT != null){
              sendTo = RRDT.Error_Email_Address__c.split(',');
           }else{
               sendTo.add('sfadmin@homelane.com');
           }           
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              mail.setToAddresses(sendTo);
              mail.setSubject('Exception in Round Robin Assignment Batch');
              String body = 'Dear Admin,';
              body +='Please check the error.';
              body += StrErrMessage;
              mail.setPlainTextBody(body);
              Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
              Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
          }  
      }     
    }