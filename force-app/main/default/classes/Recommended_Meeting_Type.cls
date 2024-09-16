Public Class Recommended_Meeting_Type{


    /*********************************************************************************************************  
    * Name: updateMeetingType
    * Description : Updated the Recommended meeting in lead using Recommended_Meeting_Type__c custom setting.
                    Can't use formula field since it will hit the limit 
    *=============================== Modification Log ================================
    
    *********************************************************************************************************/ 
    public static void updateMeetingType(Map<Id,Lead> newMap,Map<Id,Lead> OldMap){
        try{
            if(!newMap.isEmpty()){
                map<String,List<Recommended_Meeting_Type__c>> mapMeetingType = new  map<String,List<Recommended_Meeting_Type__c>>();
                List<Recommended_Meeting_Type__c> lstMeetingType = Recommended_Meeting_Type__c.getall().values();
                List<Recommended_Meeting_Type__c> lstMeetingTypeShowRoom = Recommended_Meeting_Type__c.getall().values();

                if(lstMeetingType != NULL){

                    for(Recommended_Meeting_Type__c objMeeting : lstMeetingType){
                       if(mapMeetingType.containsKey(objMeeting.ShowRoom_Name__c.toLowerCase())){
                           mapMeetingType.get(objMeeting.ShowRoom_Name__c.toLowerCase()).add(objMeeting);
                       }else{
                           mapMeetingType.put(objMeeting.ShowRoom_Name__c.toLowerCase(), new list<Recommended_Meeting_Type__c>{objMeeting});
                       }
                    }

                    system.debug('mapMeetingType*********'+mapMeetingType);

                    for(lead objLead:newMap.values()){
                        if(String.isNotBlank(ObjLead.closest_Showroom__C) && newMap.get(ObjLead.id).closest_Showroom__C != oldMap.get(ObjLead.id).closest_Showroom__C ){
                            if(ObjLead.closest_Showroom__C.length()>5){
                                String ShowRoomName = objLead.closest_Showroom__C.substring(0,ObjLead.closest_Showroom__C.length()-6).toLowerCase().trim();
                                system.debug('ShowRoomName**********'+ShowRoomName.length());
                                 system.debug('lstMeetingTypeShowRoom**********'+mapMeetingType.get(ShowRoomName));
                                if(String.isNotBlank(ShowRoomName) && mapMeetingType.containsKey(ShowRoomName)){
                                    lstMeetingTypeShowRoom = mapMeetingType.get(ShowRoomName);
                                    system.debug('lstMeetingTypeShowRoom**********'+lstMeetingTypeShowRoom);
                                    Decimal distance = Decimal.valueOf(objLead.closest_Showroom__C.substring(ObjLead.closest_Showroom__C.length()-6,ObjLead.closest_Showroom__C.length()-2).trim());
                                    system.debug('distance**********'+distance);
                                    
                                    for(Recommended_Meeting_Type__c mettingObj:lstMeetingTypeShowRoom){
                                    system.debug('Inside IF *******'+mettingObj.Min_Distance__c+''+mettingObj.Max_Distance__c);
                                        if(distance > mettingObj.Min_Distance__c && distance<= mettingObj.Max_Distance__c){
                                            system.debug('Inside IF *******');
                                            objLead.Recommended_Meeting_Type__c = mettingObj.Meeting_Type__c;
                                            break; 
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        catch(Exception e){
            system.debug('Exception '+ e.getMessage()+'-----'+e.getStackTraceString());
        }
    }
}