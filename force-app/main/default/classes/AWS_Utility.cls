global with sharing class AWS_Utility {
	@TestVisible
    static final String fingertipNameSpace {
        set;
        get;
    }
    @TestVisible
    static final Map < String, Map < String, String >> kendoOperatorMapping;

    public static String typeToString(System.Type typ) {
        return typ.getName();
    }
 
    public static String getDateFormat() {
        return '{0:dd/MM/yyyy}';
    }

    public static String getDateTimeFormat() {
        return '{0:dd-MMM-yyyy hh:mm:ss tt}';
    }

    public static void setProfilePic(List < AWS_Generic.Modelable > models) {
        Map < Id, User > userWithPic;
        Set < Id > userIds = new Set < Id > ();

        for (AWS_Generic.Modelable m: models) {
            AWS_Generic.UserPicModelable picM = (AWS_Generic.UserPicModelable) m;
            userIds.add(picM.getUserId());
        }

        //querying data from databse
        userWithPic = new Map < Id, User > (AWS_Persistent.queryUserwithPic(userIds, AWS_Persistent.USER_PIC_COMMON));

        for (AWS_Generic.Modelable m: models) {
            AWS_Generic.UserPicModelable picM = (AWS_Generic.UserPicModelable) m;
            User u = userWithPic.get(picM.getUserId());
            if (u != null) {
                picM.setPhoto(u.SmallPhotoUrl);
            }
        }

    }

   /* public static void approveRejectApproval(Id pid, String action, String comment) {
        List < ProcessInstanceWorkitem > piwi = [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId, p.ProcessInstanceId, p.Id, p.CreatedDate, p.CreatedBy.Name, p.CreatedById, p.Actor.Name, p.ActorId From ProcessInstanceWorkitem p where p.id = : pid];
        if (piwi.size() > 0) {
            Approval.ProcessWorkItemRequest pwiReq = new Approval.ProcessWorkItemRequest();
            pwiReq.setWorkitemId(piwi[0].id);
            pwiReq.setComments(comment);
            pwiReq.setAction(action);
            Approval.process(pwiReq);
        }
    }


    private static String convertKendoLiteral(String literal, String ltype) {
        String newVal = kendoOperatorMapping.get(ltype).get(literal);
        return newVal != null ? newVal : literal;
    }
    */
    /*Kendo Filter to SOQL query end*/

    /*DTO Converter Methods starts*/
    //Create a map of DTOField and object field name
    public static Map < String, AWS_GenericModels.ModelMapping > createDTOFieldMapping(List < AWS_GenericModels.ModelMapping > lst) {
        Map < String, AWS_GenericModels.ModelMapping > m = new Map < String, AWS_GenericModels.ModelMapping > ();
        for (AWS_GenericModels.ModelMapping mapping: lst) {
            m.put(mapping.modelField, mapping);
        }

        return m;
    }


    /***************************************KVP OLD CODE***************************************/

   /* public static Map < String, Set < String >> specialMap = new Map < String, Set < String >> ();
    public static set < String > hasModifyAllPermissionForPlan(String objApi) {
        set < String > permissions = new set < String > ();
        PermissionSet permissionset = [SELECT Id FROM PermissionSet where ProfileId = : userinfo.getProfileId() Limit 1];
        System.debug('-------->' + permissionset);
        List < PermissionSetAssignment > psa = [SELECT AssigneeId, PermissionSetId FROM PermissionSetAssignment where AssigneeId = : Userinfo.getUserId() or PermissionSetId = : permissionset.Id];
        set < Id > psaSet = new set < Id > ();
        for (PermissionSetAssignment p: psa) {
            psaSet.add(p.PermissionSetId);
        }
        List < ObjectPermissions > objPermissins = [SELECT Id, PermissionsDelete, PermissionsModifyAllRecords FROM ObjectPermissions WHERE SobjectType = : objApi AND ParentId IN: psaSet];
        for (ObjectPermissions op: objPermissins) {
            if (op.PermissionsDelete) {
                permissions.add('delete');
            }
            if (op.PermissionsModifyAllRecords) {
                permissions.add('modifyall');
            }
        }
        System.debug('-------->' + permissions);
        return permissions;
    }*/

    public static void ieCompatible() {
        //Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=9');
    }

    public static Boolean chkUserHasObjectAccess(String userId, String objApi) {
        List < PermissionSetAssignment > psa = [SELECT AssigneeId, PermissionSetId FROM PermissionSetAssignment where AssigneeId = : Id.valueOf(userId)];
        set < Id > psaSet = new set < Id > ();
        for (PermissionSetAssignment p: psa) {
            psaSet.add(p.PermissionSetId);
        }
        List < ObjectPermissions > objPermissins = [SELECT Id, PermissionsDelete, PermissionsModifyAllRecords FROM ObjectPermissions WHERE SobjectType = : objApi AND ParentId IN: psaSet];
        System.debug('-----objPermissins----->' + objPermissins);
        return objPermissins.size() > 0 ? true : false;
    }

    public static map < Id, Boolean > chkUserLicense(set < Id > userIds) {
        map < Id, Boolean > mapHasChatterLicense = new map < Id, Boolean > ();
        Map < Id, Profile > profileIds = new Map < id, profile > ([SELECT Id, UserLicenseId FROM Profile where UserLicenseId in (SELECT Id FROM UserLicense where Name = 'Chatter Free'
            or Name = 'Guest License'
            or Name = 'Guest User License'
            or Name = 'Chatter External')]);
        List < User > standardProfileUsers = [select id from user where profileId in : profileIds.Keyset() and Id IN: userIds];
        for (User u: standardProfileUsers) {
            system.debug('-----u.Id---->' + u.Id);
            mapHasChatterLicense.put(u.Id, true);
        }
        return mapHasChatterLicense;
    }
    public static List < UserWrap > findUserInDB(String filter, Integer lmt, Set < Id > filterUsers) {
        system.debug('------------------filter-----------------' + filter);
        system.debug('------------------lmt-----------------' + lmt);
        system.debug('------------------filterUsers-----------------' + filterUsers);
        Map < Id, UserWrap > selectedUsr = new Map < Id, UserWrap > ();
        List < String > searchPhraseLst = new List < String > ();
        if (filter != '') {

            String SearchtextList = filter.replaceAll('\\*', '');
            SearchtextList = SearchtextList.trim();
            searchPhraseLst = getFilterCombinations(SearchtextList);
            system.debug('-------------------searchPhraseLstsearchPhraseLstsearchPhraseLst------------------------' + searchPhraseLst);
        } else {
            searchPhraseLst.add('%');
        }
        for (User u: [select id, Name, LastName, FirstName, UserName, Department, ProfileId, SmallPhotoUrl from User WHERE id not in : filterUsers and IsActive = true and(Name like: searchPhraseLst) limit: lmt]) {
            selectedUsr.put(u.id, new UserWrap(u));
        }
        system.debug('------------------selectedUsr-----------------' + selectedUsr.values());
        return selectedUsr.values();
    }

    public static List < Group > findGroupInDB(String filter, Integer lmt) {
        return [select id, name from Group WHERE type = 'Regular'
            and name like: '%' + filter + '%'
            limit: lmt
        ];
    }


    // Method to convert List if Ids to comma separated string
    public static String listIdsToString(List < String > ids) {
        return String.join(ids, ',');
    }

    // Method to return list of all special characters combinations
    public static Set < String > getCombiantions(String str, String exp, List < String > special) {
            Set < String > comb = new Set < String > ();
            special.add('&&');
            for (integer k = 0; k < special.size(); k++) {
                String level1 = str.toLowerCase().replaceFirst(exp, special[k]);
                comb.add(level1.replaceAll('&&', exp));
                for (integer i = 0; i < special.size(); i++) {
                    String level2 = level1.replaceFirst(exp, special[i]);
                    comb.add(level2.replaceAll('&&', exp));
                    for (integer j = 0; j < special.size(); j++) {
                        String level3 = level2.replaceFirst(exp, special[j]);
                        comb.add(level3.replaceAll('&&', exp));
                        for (integer l = 0; l < special.size(); l++) {
                            String level4 = level3.replaceFirst(exp, special[l]);
                            comb.add(level4.replaceAll('&&', exp));
                        }
                    }
                }

            }
            return comb;
        }
        // list string all combinations         

    // method to get combination of special characters
    public static List < String > getFilterCombinations(String str) {

        List < String > lstwithSpecialVal = new List < String > ();
        List < String > lstwithSpecialLikeVal = new List < String > ();
        str = str.replaceAll('�', 'a').replaceAll('�', 'a').replaceAll('�', 'A').replaceAll('�', 'A').replaceAll('�', 'o').replaceAll('�', 'O');
        for (String s: AWS_Utility.getCombiantions(str, 'a', new String[] {
                '�',
                '�',
                '�',
                '�'
            })) {
            lstwithSpecialVal.addAll(AWS_Utility.getCombiantions(s, 'o', new String[] {
                '�',
                '�'
            }));
        }
        for (String s: lstwithSpecialVal) {
            lstwithSpecialLikeVal.add('%' + s + '%');
            system.debug('---------------sssssssssssssssssssss-------------------' + s);
        }
        return lstwithSpecialLikeVal;
    }

    global Class UserWrap {
        public String Id {
            set;
            get;
        }
        public String UserName {
            set;
            get;
        }
        public String LastName {
            set;
            get;
        }
        public String FirstName {
            set;
            get;
        }
        public String SmallPhotoUrl {
            set;
            get;
        }
        public String Department {
            set;
            get;
        }
        public Boolean ftUser {
            set;
            get;
        }

        public UserWrap(User u) {
            Id = u.id;
            LastName = u.LastName != null ? u.LastName : '';
            FirstName = u.FirstName != null ? u.FirstName : '';
            Department = u.Department != null ? u.Department : '';
            UserName = u.Name != null ? u.Name : '';
            SmallPhotoUrl = u.SmallPhotoUrl;
        }
    }

    // Method to save the image coordinates 
    public static Boolean saveImageCrop(Id decisionId, String description) {
        String attachmentName = string.valueOf(decisionId);
        //profileCoordinate = description;
        Attachment existing;
        Attachment tmp;
        for (Attachment t: [select id, body, name, Description from Attachment WHERE  ParentID = : decisionId AND ( Name = : decisionId or Name = : attachmentName+'_' )]) {
            if (t.name == attachmentName) {
                existing = t;
            } else {
                tmp = t;
            }
        }
       system.debug(tmp);
       system.debug(existing );
     
       if (tmp != null) {
            if (existing != null) {
                delete existing;
            }
            existing = tmp;
            existing.name = decisionId;
        }
        if(existing != null){
            existing.Description = description;
            update existing;       
        }
        
        return true;
    }


 
    public static List<List<String>> describeMultiselect(String obj, String field){
        List<List<String>> output = new List<List<String>>();
        //obj = AWS_Utility.chkNS(obj);
        //field = AWS_Utility.chkNS(field);
        Map<String,Schema.SobjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectField sfField = gd.get(obj).getDescribe().fields.getMap().get(field);
        for(Schema.PicklistEntry f : sfField.getDescribe().getPicklistValues()) {
            output.add(new List<String>{
                f.getValue(), f.getLabel(), f.isDefaultValue() ? 'DEFAULT' : ''
            });
        }  
        
        return output;
    }

    public static List<Attachment> ft_AttachmentType(List<Attachment> lstAttachment){
        List<Attachment> ft_lstAttachment = new List<Attachment>();
        if(lstAttachment != null) {
            for(Attachment a : lstAttachment){
                    ft_lstAttachment.add(a);
            }
        }
        
        return ft_lstAttachment;
    }
}