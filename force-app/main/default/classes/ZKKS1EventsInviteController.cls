public with sharing class ZKKS1EventsInviteController {
    
    
    List<String> lstIds {get;set;}
    public ZKKS1EventsInviteController(ApexPages.StandardController stdController) {
        lstIds = new list<String>();
    }

    @RemoteAction
    public static String addInvitees( Id evtId,List<String> lstIds){
        returnData ret = new returnData();
        ret.success = true;
        ret.message = 'Invitees Successfully added';

        Set<String> sids = new Set<String>();
        sids.addAll(lstIds);
        try{
            List<EventRelation> es = [SELECT Id,EventId,RelationId FROM EventRelation WHERE EventId = :evtId AND RelationId IN :sids];
            for(EventRelation e:es){
                String relId = e.RelationId;
                sids.remove(relId);
            }
            if(sids.size()>0){
                List<EventRelation> erlist = new List<EventRelation>();
                for(String s:sids){
                    EventRelation er = new EventRelation();
                    er.EventId = evtId;
                    //er.isInvitee = true;
                    er.RelationId = s;
                    erlist.add(er);
                }
                Database.DMLOptions dlo = new Database.DMLOptions();
                dlo.EmailHeader.triggerUserEmail = true; // used if InviteeId is a userId
                dlo.EmailHeader.triggerOtherEmail = true; // used if InviteeId is lead or contact
                Database.insert(erlist,dlo);
            }

        }catch(Exception e){
            ret.success = false;
            ret.message = 'Error in getting recently viewed records ' + e.getMessage() + ' at line number: ' + e.getLineNumber();
        }
        return JSON.serialize(ret);
    }

  /*  @RemoteAction
    public static String getRecentlyViewedPeople(){
        
        returnData ret = new returnData();
        ret.success = false;
        ret.message = 'Error in getting recently viewed records';

        try{
            
            Set<String> oTypes = new Set<String>();
            oTypes.add('Contact');
            oTypes.add('Lead');
            oTypes.add('User');
            List<RecentlyViewed> rvList = [SELECT Id, Type, LastViewedDate FROM RecentlyViewed WHERE Type IN :oTypes];
            Set<Id> oIds = (new Map<Id,SObject>(rvList)).keySet();
            List<result> resList = new List<result>();


            List<Contact> contacts = [SELECT Id,Name,Email FROM Contact WHERE Id IN :oIds];
            List<Lead> leads = [SELECT Id,Name,Email FROM Lead WHERE Id IN :oIds];
            List<User> users = [SELECT Id,Name,Email FROM User WHERE Id IN :oIds];

            resList.addAll(getResultList(contacts));
            resList.addAll(getResultList(leads));
            resList.addAll(getResultList(users));

            ret.success = true;
            ret.message = JSON.serialize(resList);
            

        }catch(Exception e){
            ret.success = false;
            ret.message = 'Error in getting recently viewed records ' + e.getMessage() + ' at line number: ' + e.getLineNumber();
        } 

        return JSON.serialize(ret);
    }*/

    @RemoteAction
    public static String searchPeople(String q){
        
        returnData ret = new returnData();
        ret.success = false;
        ret.message = 'Error in searching for people to invite';

        try{
                // Run a SOSL on Contact, Lead and 
                List<List<SObject>> searchList = [FIND :q IN ALL FIELDS RETURNING Contact(Id,Name,Email), Lead(Id,Name,Email), User(Id,Name,Email) LIMIT 200];
                List<result> resList = new List<result>();

                resList.addAll(getResultList(searchList[0]));
                resList.addAll(getResultList(searchList[1]));
                resList.addAll(getResultList(searchList[2]));

                Set<result> uniq = new Set<result>();
                for(result res:resList){
                    uniq.add(res);
                }
                ret.success = true;
                ret.message = JSON.serialize(uniq);

            }catch(Exception e){
                ret.success = false;
                ret.message = 'Error in searchPeople ' + e.getMessage() + ' at line number: ' + e.getLineNumber();
            }

        return JSON.serialize(ret);

    }

    
    
    public static List<result> getResultList(List<SObject> slist){
        List<result> resultList = new List<result>();
        for(SObject s:slist){
            result res = new result();
            res.id = (Id)s.get('Id');
            res.name = (String)s.get('Name');
            res.email = (String)s.get('Email');
            res.type = String.valueOf(s.getSObjectType());
            resultList.add(res);
        }
        return resultList;
    }

    private class returnData{
        Boolean success {get;set;}
        String message {get;set;}
    }

    private class result{
        String type {get;set;}
        Id id {get;set;}
        String name {get;set;}
        String email {get;set;}
    }
}