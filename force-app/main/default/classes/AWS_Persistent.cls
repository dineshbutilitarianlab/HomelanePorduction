public with sharing class AWS_Persistent {

    //private static Map<String, Object> qryPrm;

    public static final String GRID_DECISION_FULL = 'A';
    public static final String GRID_DECISION_COMMON = 'B';
    public static final String GRID_SI_DECISION_COMMON = 'B1';
    public static final String GRID_SI_FOR_DECISION = 'B2';
    public static final String GRID_PLAN_COMMON = 'C';
    public static final String GRID_PEOPLE_COMMON = 'D';
    public static final String GRID_TASK_COMMON = 'E';
    public static final String GRID_RELATION_COMMON = 'F';
    public static final String USER_PIC_COMMON = 'G';
    public static final String PEOPLE_APPROVAL = 'H';
    public static final String USER_MULTISELECT = 'I';
    public static final String GRID_SHEDULER_COMMON = 'J';
    public static final String GROUP_MULTISELECT = 'K';
    public static final String GROUPMEMBER_FIELDS = 'L';
    public static final String SOCIAL_FIELDS = 'M';
    public static final String GRID_USER_FIELDS = 'N';
    public static final String PACKAGE_LICENSE_FIELDS = 'O';
    public static final String PROFILE_FIELDS = 'P'; 
    public static final String User_Package_License_FIELDS = 'Q';
    public static final String TIMING_FIELDS= 'R';
   
    static final Map < String, String > QRY_MAP;
    static {
        QRY_MAP = new Map < String, String > {
            GRID_DECISION_COMMON => 'Progress__c,CreatedDate, Problem_Idea_Advice__c, Title__c,Due_Date__c, Decision_Taken__c, Phase__c, Comments__c,Nearest_Due_Date__c,Owner.Name,Priority__c,SYS_From_Quick_Decision__c,Propose_Immediately__c,Reason_for_Close__c',
            GRID_SI_DECISION_COMMON=> 'Last_Seen__c,Accountable__c,Responsible__c,Consulted__c,Informed__c,Veto_Rights__c,Backup_for_Accountable__c,user__c,Decision__r.status__c,user__r.name, Role_Acceptance_Status__c,Stance_Approval_Status__c,Final_Approval_Status__c,Decision__r.Progress__c,Decision__r.CreatedDate, Decision__r.Problem_Idea_Advice__c, Decision__r.Title__c, Decision__r.Due_Date__c, Decision__r.Decision_Taken__c, Decision__r.Phase__c, Decision__r.Comments__c,Decision__r.Nearest_Due_Date__c,Decision__r.Owner.Name,Decision__r.Priority__c,Decision__r.SYS_From_Quick_Decision__c,Decision__r.Propose_Immediately__c,Decision__r.Reason_for_Close__c,Decision__r.Social__r.Total_Stance_Approved__c,Decision__r.Social__r.Total_Stance_Pending__c,Decision__r.Social__r.Total_Stance_Rejected__c,Decision__r.Social__r.Total_Number_of_Decision_Views__c,Decision__r.Social__r.id,Decision__r.LastModifiedDate' ,
            GRID_SI_FOR_DECISION => 'Last_Seen__c,Accountable__c,Responsible__c,Consulted__c,Informed__c,Veto_Rights__c,Backup_for_Accountable__c,user__c,user__r.name, Decision__c, Role_Acceptance_Status__c,Stance_Approval_Status__c,Final_Approval_Status__c' ,
            //GRID_DECISION_FULL => 'Title__c, Status__c, Reason_for_Close__c, Propose_Immediately__c, Progress__c, Problem_Statement__c, Problem_Idea_Advice__c, Priority__c, Phase__c, Parent_Decision__c, Nearest_Due_Date__c, Name, Identifier__c, FeedItem_Id__c, FeedItem_Id_Propose__c, FeedItem_Id_Execute__c, FeedItem_Id_Evaluate__c, Estimated_Revenue__c, Estimated_Revenue_Desc__c, Estimated_People_Involved__c, Estimated_People_Involved_Desc__c, Estimated_Net_Present_Value__c, Estimated_Net_Present_Value_Desc__c, Estimated_Investment__c, Estimated_Investment_Desc__c, Estimated_Full_time_Equivalent_FTE__c, Estimated_Full_time_Equivalent_Desc__c, Estimated_Direct_Cost__c, Estimated_Direct_Cost_Desc__c, Due_Date__c, Decision__c, Decision_Type__c, Decision_Taken__c, Decision_Making_Style__c, Decision_Approach__c, Comments__c, Classification__c, Category__c, Add_C_I_Members__c, Actual_Revenue__c, Actual_Revenue_Desc__c, Actual_People_Involved__c, Actual_People_Involved_Desc__c, Actual_Net_Present_Value__c, Actual_Net_Present_Value_Desc__c, Actual_Investment__c, Actual_Investment_Desc__c, Actual_Full_time_Equivalent_FTE__c, Actual_Full_time_Equivalent_Desc__c, Actual_Direct_Cost__c, Actual_Direct_Cost_Desc__c, Accountable__c',
            GRID_PLAN_COMMON => 'Name, Description__c, Start_Time__c, End_Time__c,LastModifiedDate',
            GRID_PEOPLE_COMMON => 'Last_Seen__c,Like__c,Dislike__c,Mood__c,Rating__c,Informed__c,Accountable__c,Responsible__c,Backup_for_Accountable__c,Veto_Rights__c,Consulted__c,User_or_Group_Name__c,user__r.name,user__r.Email,user__r.SmallPhotoUrl,GroupId__c,Is_Group__c,Role_Acceptance_Status__c,Role__c,Stance_Approval_Status__c,Approved_for__c,user__c',
            PEOPLE_APPROVAL => 'Decision__c,Final_Approval_Status__c,Stance_Approval_Status__c,Role_Acceptance_Status__c',
            GRID_TASK_COMMON => 'Subject,Owner.name,Status,Priority,ActivityDate,Description,Progress__c',
            GRID_RELATION_COMMON => 'To_Relation__c,Type__c,Parent_Record_Name__c,Parent_Id__c,Parent_Object_Name__c,Child_Object_Name__c,Child_Record_Name__c,Child_Id__c,From_Relation__c',
            USER_PIC_COMMON => 'SmallPhotoUrl',
            USER_MULTISELECT => 'Name,SmallPhotoUrl,FirstName,LastName,Email,Phone,Username,isActive',
            GROUP_MULTISELECT => 'Name',
            GRID_SHEDULER_COMMON => 'start__c,end__c,Parent_ID__c,Parent_Object__c,Parent_Title__c,Description__c,Event_Type__c,OwnerId,recurrenceID__c',
            GROUPMEMBER_FIELDS => 'GroupId,UserOrGroupId',
            GRID_USER_FIELDS => 'FirstName,LastName,Email,Phone,Name,Username,SmallPhotoUrl,isActive',
            PACKAGE_LICENSE_FIELDS => 'Id, AllowedLicenses,UsedLicenses,ExpirationDate',
            User_Package_License_FIELDS => 'UserId,PackageLicenseId',
            PROFILE_FIELDS  => 'Id ',
            SOCIAL_FIELDS => 'Average_Mood__c,Avg_Rating__c,Avg_Mood__c,Avg_Effort__c,Avg_Relt__c   ,Effort_Count__c,Mood_Count__c,People_Count__c,Rating_Count__c,Relt_Count__c,Total_Diike_c,Total_Effort__c,Total_Iue_c,Total_Like_c,Total_Mood__c,Total_Rating__c,Total_Relt__c,Total_Stance_Approved__c    ,Total_Stance_Pending__c,Total_Stance_Rejected__c',
            TIMING_FIELDS => 'Actual_End_Date__c,Actual_Start_Date__c,End_Date_Time__c,Related_Decision__c,Stage_No__c,Start_Date_Time__c'
        };
    }

    /*GENERIC*/
    public static List < sObject > genericQuery(String filter, String fieldSet, String objName) {
        return query(fieldSet, filter, objName);
    }

    /*User*/
    public static List < User > queryUser(String filter, String fieldSet) {
        return (List < User > ) query(fieldSet, filter, 'User');
    }
    public static List < User > queryUsersById(Set < Id > ids, String fieldSet) {
        return (List < User > ) queryById(fieldSet, ids, 'User');
    }
    
    public static List < Database.SaveResult> saveUser(List < user> user) {
        Database.DMLOptions dmlo = new Database.DMLOptions();
        dmlo.EmailHeader.triggerUserEmail = true;
        dmlo.optAllOrNone = false;
        //dmlo.EmailHeader.triggerAutoResponseEmail= true;
        return Database.insert(user,dmlo);
    }
    
    public static List < Database.SaveResult> updateUser(List < user> user) {
        return Database.update(user);
    }
    
    public static Integer totalUserCount(String filter) {
        return countQuery(filter, 'User');
    }

    /*Entity Subscription*/
   public static List < Database.SaveResult> saveEntitySubscription(List <EntitySubscription> lsEntitySubscription) {
        return Database.insert(lsEntitySubscription);
    }
    
     public static List <EntitySubscription> queryEntitySubscription() {
        List<EntitySubscription> output = [select parentid from entitysubscription where subscriberid=:UserInfo.getUserId() and Parent.Type = 'User'];
        return output;
    }
    
    public static List <EntitySubscription> queryEntitySubscriptionByIds(Set<Id> parentsIds) {
        List<EntitySubscription> output = [select parentid from entitysubscription where parentId in :parentsIds and subscriberid=:UserInfo.getUserId() and Parent.Type = 'User'];
        return output;
    }
    
       public static List < Database.DeleteResult > deleteEntitySubscription(List < EntitySubscription > lsEntitySubscription) {
        return Database.delete(lsEntitySubscription);
    }
    
    /*Package License */
    public static List <PackageLicense> queryPackageLicense(String filter, String fieldSet) {
        return (List < PackageLicense> ) query(fieldSet, filter, 'PackageLicense');
    }
    
    /*Package License User */
    public static List <UserPackageLicense> queryUserPackageLicense(String filter, String fieldSet) {
        return (List <UserPackageLicense> ) query(fieldSet, filter, 'UserPackageLicense');
    }
    
    /*Package License User */
    public static List <UserPackageLicense> getUserPackageLicenseById(set<Id> usrIds, set<Id> pkgIds ) {
        return [select Id from UserPackageLicense where UserId in :usrIds and PackageLicenseId in :pkgIds];
    }
    
    public static List < Database.SaveResult> saveUserPackageLicense(List <UserPackageLicense> userPackageLicense) {
        return Database.insert(userPackageLicense);
    }
    
    public static List < Database.DeleteResult > deleteUserPackageLicense(List < UserPackageLicense > userPackageLicense) {
        return Database.delete(userPackageLicense);
    }
   
    /*Profile*/
    public static List <Profile> queryProfileLicense(String filter, String fieldSet) {
        return (List < Profile> ) query(fieldSet, filter, 'Profile');
    }

    /*Group*/
    public static List < Group > queryGroup(String filter, String fieldSet) {
        return (List < Group > ) query(fieldSet, filter, 'Group');
    }
    public static List < Group > queryGropsById(Set < Id > ids, String fieldSet) {
        return (List < Group > ) queryById(fieldSet, ids, 'Group');
    }

    /*GroupMember*/
    public static List < GroupMember > queryGroupMember(String filter, String fieldSet) {
        return (List < GroupMember > ) query(fieldSet, filter, 'GroupMember');
    }

    public static List < GroupMember > queryGroupMember(Set < Id > grupIds, String fieldSet) {
        String query = 'Select ' + getFieldSet(fieldSet) + ' from GroupMember where GroupId in :grupIds';
        System.debug(query);
        List < sObject > op = Database.query(query);
        return (List < GroupMember > ) op;
    }

    public static List < User > queryUserwithPic(Set < Id > userIds, String fieldSet) {
        /*qryPrm = new Map<String, Object>{
            'userId' => userIds
        };*/
        System.debug('userIds=' + userIds);
        return Database.query('select SmallPhotoUrl from User where id in :userIds');
    }

    /*ATTACHMENT*/
     public static List <Database.SaveResult> updateAttachment(List <Attachment> att) {
        return Database.update(att);
    }

    public static List <Database.SaveResult> saveAttachment(List <Attachment> att) {
        return Database.insert(att);
    }

    public static List <Database.DeleteResult> deleteAttachment(List <Attachment> att) {
        return Database.delete(att);
    }
    
    public static Map < Id, Attachment > queryProfilePhoto(Set < Id > parentIds) {
        Map < Id, Attachment > output = new Map < Id, Attachment > ();
        for (Attachment a: [select id,Description, name, ParentID from Attachment WHERE Name in : parentIds and ParentID in : parentIds]) {
            if (a.Name == a.ParentID) {
                output.put(a.Name, a);
            }
        }
        return output;
    }


    /*COMMON Private methods*/
    //generic method to query sObject by Id 
    private static List<sObject> queryById(string fieldSet, Set<Id> ids, String objectName){
        return queryBySet(fieldSet, ids, objectName, 'id', null);
    }
    
    private static List<sObject> queryBySet(string fieldSet, Set<Id> ids, String objectName, String listField, String otherFilter){
        if(otherFilter == null){
            otherFilter = '';
        } else {
            otherFilter = ' and ' + otherFilter;
        }
        String query = 'Select ' + getFieldSet(fieldSet)  + ' from ' + objectName +' where ' + listField + ' in :ids' + otherFilter;
        System.debug(query);
        List<sObject> op = Database.query(query);
        //qryPrm = null;
        return op;
    }

    //generic method to query from database
    private static List < sObject > query (string fieldSet, String filter, String objectName) {
        if (filter == '') {
            filter = 'order By LastModifiedDate limit 20';
        }
        String query = 'Select ' + getFieldSet(fieldSet) + ' from ' + objectName + ' ' + filter;
        System.debug(query);
        List < sObject > op = Database.query(query);
        //qryPrm = null;
        return op;
    }


    //generic method to query into database
    private static Integer countQuery(String filter, String objectName) {
        System.debug('Select count(Id) from ' + objectName + ' ' + filter);
        AggregateResult[] groupedResults = Database.query('Select count(Id) cnt from ' + objectName + ' ' + filter);
        return (Integer) groupedResults[0].get('cnt');
    }

    //This methods will return a CSV fields for given field
    private static String getFieldSet(String fieldSetName) {
        String output = '';
        String[] fieldNames = (QRY_MAP.get(fieldSetName) != null) ? QRY_MAP.get(fieldSetName).replaceAll(' ', '').split(','):new string[]{'Id'};
        for (String fieldName: fieldNames) {
            output += ',' + fieldName;
        }
        return output.substring(1);
    }

}