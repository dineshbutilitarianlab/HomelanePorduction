global with sharing class HierarchyClass{
    public Static String jsonstr {get;set;}
    public  Boolean renderListBucketResults {get;set;}
    public  String listBucketErrorMsg {get;set;}
    public  String createBucketErrorMsg {get;set;}
    public  String deleteBucketErrorMsg {get;set;}
    public  String deleteObjectErrorMsg {get;set;}
    public  String selectedBucket {get;set;}
    public  String OwnerId {get;set;}
    private  String AWSCredentialName = 'AWSUPLOADDEMO1';
    public  String bucketToUploadObject = 'salesforcekvpbucket';
    public String ParentName {get;set;}
    public String eTemplateName {get; set;}
    public Id eTemplateId {get; set;}
    private final Element__c ele;
    private final Opportunity objOpp;
    private final Lead objLead;
    public static Opportunity relatedId{get;set;}
    public static Lead relatedIdlead{get;set;}
    public static Project_Name__c relatedIdpro{get;set;}
    public  String[] allBuckets { get ; set; }
    public  String leadPrefix = Lead.sObjectType.getDescribe().getKeyPrefix();
    public  String oppPrefix = Opportunity.sObjectType.getDescribe().getKeyPrefix();
    public  String proPrefix = Project_Name__c.sObjectType.getDescribe().getKeyPrefix();
    public  string id=ApexPages.currentPage().getParameters().get('id').substring(0, 3);
    public  String strOfobjOpp;
    public static List<wrapperFiles> lstGlobaljsonWrapp;
    
    public HierarchyClass(ApexPages.StandardController ctd){
      objSobjectDetails = new SobjectDetails();
       
        //this.ele = (Element__c)ctd.getRecord();
        system.debug('idIGGGGGG'+id);
        if(id=='006'){
        this.objOpp =   (Opportunity)ctd.getRecord();
        relatedId = (Opportunity)ctd.getRecord();
        system.debug(' this.objOpp'+ this.objOpp);
        }
        
        if(id=='00Q'){
        this.objLead=   (Lead)ctd.getRecord();
        relatedIdlead= (Lead)ctd.getRecord();
        system.debug(' this.objLead'+ this.objLead);
        
        }
        
        
        
        //this.objLead =    (Lead)ctd.getRecord();
        //this.objPro   =   (Project_Name__c)ctd.getRecord();
        
        jsonstr = '[';
        hierarchyMethod();
    }
    
    map<id,List<element__c>> elementMap = new map<id,List<element__c>>();
        
    public void hierarchyMethod(){
        
        if(id=='006'){
         strOfobjOpp = String.valueOf(objOpp.id);
         objSobjectDetails.sobjectName='Opportunity';
         opportunity op = [select name, id from opportunity Where id=: strOfobjOpp];
         objSobjectDetails.Name = op.Name;
         objSobjectDetails.imgUrl = 'https://hmldev--HLDevbox.cs6.my.salesforce.com/img/icon/t4v35/standard/opportunity_120.png';
        }
        
        if(id=='00Q'){
          strOfobjOpp = String.valueOf(objLead.id);
          objSobjectDetails.sobjectName='Lead';
          Lead op = [select name, id from Lead Where id=: strOfobjOpp];
          objSobjectDetails.Name = op.Name;
          objSobjectDetails.imgUrl = 'https://hmldev--HLDevbox.cs6.my.salesforce.com/img/icon/t4v35/standard/lead_120.png';
        }
        
        System.debug('strOfobjOpp : '+strOfobjOpp);
        Map<id,Bucket__c> bucketMap = new map<id,bucket__c>([Select id,name from Bucket__c WHERE Related_Object_ID__c=: strOfobjOpp]);
        System.debug('bucketMap : '+bucketMap);
        List<element__c> elementList = [Select id,name, Bucket__c,Type__c,parent_element__c FROM Element__c where bucket__c IN:bucketMap.keySet() and type__c =: 'Folder'];
        for(element__c ele :elementList) {
            if(ele.Parent_element__c == null) {
                if(elementMap.containsKey(ele.bucket__c) && elementMap.get(ele.bucket__c) != null) {
                    elementMap.get(ele.bucket__c).add(ele);
                    
                } else {
                    elementMap.put(ele.bucket__c,new List<element__c>{ele});
                }
            } else {
                if(elementMap.containsKey(ele.Parent_element__c) && elementMap.get(ele.Parent_element__c) != null) {
                    elementMap.get(ele.Parent_element__c).add(ele);
                    
                } else {
                    elementMap.put(ele.parent_element__c,new List<element__c>{ele});
                }
            }
            
        }
        
        
        for(bucket__c buc : bucketMap.values()){
            jsonstr = jsonstr +'{ "text":"'+buc.name+'","name":"'+buc.name+'","id":"'+buc.id+'"';
            if(elementMap.get(buc.id) != null) {
                jsonstr = jsonstr +',"items":[';
                prepareJson(elementMap.get(buc.id));
            } 
            jsonstr = jsonstr+'},';
            
        }
        if(jsonstr.endsWith(',')) {
            jsonstr = replaceEndString(jsonstr);
        }
        jsonstr = jsonstr +']';  
        System.debug('*************'+jsonstr); 
       
        
        // simpleUpload ************************************************************************************
        
        awsKeySet= AWS_Keys__c.getInstance('salesforcekvpbucket');
        currentURL = URL__c.getInstance('Env');
        appParentId = ApexPages.currentPage().getParameters().get('parentIdForRedirect');
        ForRedirect = 'https://'+currentURL.URL__c+'/apex/AWSTreeStructure?id='+ strOfobjOpp;  //objOpp.id;
        Content_Type ='multipart/form-data';
        acessType ='public-read';
      
        system.debug('awsKeySet'+awsKeySet); 
        system.debug('policy'+policy);
    }
    
	    Datetime expire = system.now().addDays(1);
	    String formattedexpire = expire.formatGmt('yyyy-MM-dd')+'T'+ expire.formatGmt('HH:mm:ss')+'.'+expire.formatGMT('SSS')+'Z';           
          
      	string policy { get {return 
        '{ "expiration": "'+formattedexpire+'","conditions": [ {"bucket": "'+
         awsKeySet.Name +'" } ,{ "acl": "'+acessType+'" },'+
        '{"content-type":"'+Content_Type+'"},'+
        '{"success_action_redirect": "'+ForRedirect+'"},' +
        '["starts-with", "$key", ""] ]}';   } } 
    
    public String getPolicy() {
        return EncodingUtil.base64Encode(Blob.valueOf(policy));
    }
    
    public SobjectDetails objSobjectDetails{get;set;}
    public class SobjectDetails{
      public String imgUrl {get;set;}
      public String sObjectName {get;set;}
      public String name {get;set;}
    }
    
    public String getSignedPolicy() {    
        return make_sig(EncodingUtil.base64Encode(Blob.valueOf(policy)));        
    }
     
    
    //method that will sign
    private String make_sig(string canonicalBuffer) {        
        String macUrl ;
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(awsKeySet.AWS_Secret_Key__c));  
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }
    
    
    private void prepareJson(List<Element__c> elements){ 
        for(element__c ele : elements){
            jsonstr = jsonstr +'{ "text":"'+ele.name+'","name":"'+ele.name+'","id":"'+ele.id+'"';
            if(ele.Type__c == 'Folder'){
                jsonstr = jsonstr +',"spriteCssClass":"folder"'; 
            }else if(ele.Type__c == 'File'){
                jsonstr = jsonstr +',"spriteCssClass":"html"'; 
            }
            if(elementMap.get(ele.id) != null) {
                jsonstr = jsonstr +',"items":[';
                prepareJson(elementMap.get(ele.id));
            } 
            jsonstr = jsonstr+'},';
        }
        if(jsonstr.endsWith(',')) {
            jsonstr = replaceEndString(jsonstr);
        }
        jsonstr = jsonstr +']';  
    }
    
    private string replaceEndString(string souurceStr) {
        integer len = souurceStr.length();
        return souurceStr.Substring(0,len-1);
    }
    
    @Remoteaction
    global static String createNew_Bucket(String bucName , String bucDescription,String rId){
        List<Bucket__c> lstBucs = [select id from Bucket__c where Name = : bucName];
        String result;
        if(lstBucs.size() > 0){
            result = 'failed';
        } else {
          Bucket__c t = new Bucket__c();
          t.Name = bucName;
          //t.Description__c = topicDescription;
         
          System.debug('String.valueOf(relatedId) : '+String.valueOf(relatedId));
          
          t.Related_Object_ID__c = rId;
          insert t; 
          result = 'success';
        }
        return result;
    }
    
     @Remoteaction
     global static string uploadFile(String topicName , String topicDescription,String parentName,String creationType,String ext,String uploadSize,String rId){
        system.debug('parentName : '+parentName);
        List<Element__c> lstElements = [select id from Element__c where Name = : topicName AND Related_Object_ID__c =: rId];
        String result;
        if(lstElements.size() > 0){
            result = 'failed';
        } else {
                Element__c t = new Element__c();
                if(creationType == 'file'){
                    String fileName = topicName.substring(topicName.lastIndexOf('\\')+1);
                    integer dotIndex=fileName.lastIndexOf('.');
                    if(dotIndex>=0) { // to prevent exception if there is no dot
                      fileName=fileName.substring(0,dotIndex);
                    }
                    t.Name = topicName.substring(topicName.lastIndexOf('\\')+1);
                    t.Type__c = 'File';
                    t.File_URL__c =  'https://s3-ap-southeast-1.amazonaws.com/salesforcekvpbucket/'+t.Name;
                    t.Extension__c = ext;
                    t.File_Size__c = uploadSize;
                }else{
                    t.Name = topicName;
                    t.Type__c = 'Folder';
                }
                List<Element__c> lstParentId = [select id,bucket__c,bucket__r.name,parent_Element__c,parent_Element__r.name from Element__c where name = : parentName AND Related_Object_ID__c =: rId];
                if(!lstParentId.isEmpty()){
                     t.parent_Element__c = lstParentId[0].id;
                     t.bucket__c = lstParentId[0].bucket__c;
                }else{
                	system.debug('&&&&&&&&&& parentName' + parentName);
                    List<Bucket__c> lstBucs = [select id from Bucket__c where Name = : parentName AND Related_Object_ID__c =: rId];
                    system.debug('lstBucs' + lstBucs);
                    t.bucket__c = lstBucs[0].id;
                }
                t.Related_Object_ID__c = rId;
                t.Description__c = topicDescription;    
                insert t; 
                result = 'success';
        }
        return result;
     }
     
     @Remoteaction
     global static string SharePeople(string parentName,string peopleStr,String rId){
        List<Element__Share> lstEleShares = new List<Element__Share>();
        set <Id> people;
        set <Id> bucEle;
        map<id,Bucket__c> mapBuc = new map<id,Bucket__c>();
        map<id,Element__c> mapele = new map<id,Element__c>();
        map<id,list<Element__c>> mapBucele = new map<id,list<Element__c>>();
        map<id,list<Element__c>> mapBuceleFolder = new map<id,list<Element__c>>();
        
        people = convertIdParamsToSetStatic(peopleStr);
        bucEle = convertIdParamsToSetStatic(parentName);
        
        List<Bucket__c> lstBucs = [select id from Bucket__c where Related_Object_ID__c =: rId];
        List<Element__c> lstelemes = [select id,Bucket__c from Element__c where Related_Object_ID__c =: rId];
        List<Element__c> lstelemesFolder = [select id,Bucket__c from Element__c where Related_Object_ID__c =: rId AND type__c =: 'folder'];
        if(!lstBucs.isEmpty()){
        	for(Bucket__c eachB : lstBucs){
        		mapBuc.put(eachB.id,eachB);
        	}
        }
        if(!lstelemes.isEmpty()){
        	for(Element__c ele : lstelemes){
        		mapele.put(ele.id,ele);
        		if(!mapBucele.isempty() && mapBucele.containsKey(ele.bucket__c) && mapBucele.get(ele.bucket__c) != null){
	        		mapBucele.get(ele.bucket__c).add(ele);
	        	} else{
	        		mapBucele.put(ele.bucket__c,new list<Element__c>{ele});
	        	}
        	}
        }
        
        if(!lstelemesFolder.isEmpty()){
            for(Element__c ele : lstelemesFolder){
                if(!mapBuceleFolder.isempty() && mapBuceleFolder.containsKey(ele.bucket__c) && mapBuceleFolder.get(ele.bucket__c) != null){
                    mapBuceleFolder.get(ele.bucket__c).add(ele);
                } else{
                    mapBuceleFolder.put(ele.bucket__c,new list<Element__c>{ele});
                }
            }
        }
        
        for(id eachId : bucEle){
        	if(mapBuc.containsKey(eachId)){
        		List<Element__c> lstParents = mapBucele.get(eachId);
	            if(!lstParents.isEmpty() && !people.isEmpty()){
	                lstwrapperFiles = new list<wrapperFiles>();
	                for(Element__c eachele : lstParents){
	                   for(Id each : people){
	                        Element__Share objEleShare = new Element__Share();
	                        objEleShare.ParentId = eachele.id;
	                        objEleShare.AccessLevel = 'Edit';
	                        objEleShare.UserOrGroupId = each;
	                        lstEleShares.add(objEleShare);
	                    }
	                }
	            }
        	}else if(mapele.containskey(eachId)){
	            HierarchyGenerator(eachId,false,rId); 
	            if(!lstRetrivalElements.isEmpty() && !people.isEmpty()){
                    List<Element__c> lstParents = mapBuceleFolder.get(eachId);
                    if(!lstParents.isEmpty() && !people.isEmpty()){
                        for(Element__c eachele : lstParents){
                           for(Id each : people){
                               if(eachele.ownerId != UserInfo.getUserId()){
                                  Element__Share objEleShare = new Element__Share();
                                  objEleShare.ParentId = eachele.id;
                                  objEleShare.AccessLevel = 'Edit';
                                  objEleShare.UserOrGroupId = each;
                                  lstEleShares.add(objEleShare);
                               }
                            }
                        }
                    }
	                System.debug('lstEleShares : 1234******************** : '+lstEleShares);
	                for(Element__c eachele : lstRetrivalElements){
	                    if(eachele.type__c == 'file' && eachele.ownerId != UserInfo.getUserId()){
	                        for(Id each : people){
	                            Element__Share objEleShare = new Element__Share();
	                            objEleShare.ParentId = eachele.id;
	                            objEleShare.AccessLevel = 'Edit';
	                            objEleShare.UserOrGroupId = each;
	                            lstEleShares.add(objEleShare);
	                        }
	                    }
	                }
	            }
        	}
        }
        
        System.debug('lstEleShares : ******************** : '+lstEleShares);
        
        AWS_RunInSystemMode.insertAsAdmininstrator(lstEleShares);
        
        return '';
     }
     
     public static Set<Id> convertIdParamsToSetStatic(String param){
        Set<Id> output;
        
        if (param != null && param != '') {
            output = new Set<Id> ((List<Id>) param.split(','));
        }  else {
            output = new Set<Id>();
        }
        
        return output;
    }
     
     @Remoteaction
     global static String getFiles(String jsonData, String parentName, String rId){ 
        System.debug('gggggparentNameparentNameparentNameggggggg : '+parentName);
        List<Bucket__c> lstBucs = [select id from Bucket__c where Name = : parentName AND Related_Object_ID__c =: rId];
        if(!lstBucs.isEmpty()){
            List<Element__c> lstParents = [select id,bucket__c,bucket__r.name,parent_Element__c,parent_Element__r.name,file_size__c,Name,type__c,Extension__c,createddate,File_URL__c from Element__c 
                                           where bucket__c = : lstBucs[0].id AND type__c =: 'File' AND Related_Object_ID__c =: rId]; 
            if(!lstParents.isEmpty()){
                lstwrapperFiles = new list<wrapperFiles>();
                for(Element__c each : lstParents){
                    wrapperFiles ob = new wrapperFiles();
                    ob.name = each.name;
                    ob.isSelected = false;
                    //ob.Subfolder = each.parent_Element__r.name;
                    ob.ext = each.Extension__c;
                    ob.createdDate = each.createddate;
                    ob.fileurl = each.File_URL__c;
                    ob.size = each.file_size__c;
                    ob.eleId = each.id;
                    lstwrapperFiles.add(ob);
                }
                System.debug('ggggggggggglstwrapperFilesggggggggggggg : '+lstwrapperFiles);
            }
        }else{
            HierarchyGenerator(parentName,true,rId); 
            
            /*List<Element__c> lstParents = [select id,bucket__c,bucket__r.name,parent_Element__c,parent_Element__r.name,Name,type__c from Element__c 
                                           where parent_Element__r.name =: parentName and type__c =: 'File'];
            System.debug('gggggggggggggggggggggggg : '+g);
            System.debug('ggggggggggglstParentsggggggggggggg : '+lstParents);*/
            
            if(!lstRetrivalElements.isEmpty()){
                lstwrapperFiles = new list<wrapperFiles>();
                for(Element__c each : lstRetrivalElements){
                    wrapperFiles ob = new wrapperFiles();
                    ob.name = each.name;
          ob.isSelected = false;
                    //ob.Subfolder = each.parent_Element__r.name;
                    ob.ext = each.Extension__c;
                    ob.createdDate = each.createddate;
                    ob.fileurl = each.File_URL__c;
                    ob.size = each.file_size__c;
                    ob.eleId = each.id;
                    lstwrapperFiles.add(ob);
                }
                System.debug('ggggggggggglstwrapperFilesggggggggggggg : '+lstwrapperFiles);
            }
        }
        
        return json.serialize(lstwrapperFiles);
     }
     
      @Remoteaction
    global static String getAllFiles(String relId){ 
        System.debug('gggggparentNameparentNameparentNameggggggg : '+relId);
        List<Bucket__c> lstBucs = [select id,Related_Object_ID__c from Bucket__c where Related_Object_ID__c = : relId];
        if(!lstBucs.isEmpty()){
            List<Element__c> lstParents = [select id,bucket__c,bucket__r.name,parent_Element__c,parent_Element__r.name,file_size__c,Name,type__c,Extension__c,createddate,File_URL__c from Element__c 
                                           where bucket__c = : lstBucs and type__c =: 'File' ];
            if(!lstParents.isEmpty()){
                lstwrapperFiles = new list<wrapperFiles>();
                for(Element__c each : lstParents){
                    wrapperFiles ob = new wrapperFiles();
                    ob.name = each.name;
                    ob.isSelected = false;
                    //ob.Subfolder = each.parent_Element__r.name;
                    ob.ext = each.Extension__c;
                    ob.createdDate = each.createddate;
                    ob.fileurl = each.File_URL__c;
                    ob.size = each.file_size__c;
                    ob.eleId = each.id;
                    lstwrapperFiles.add(ob);
                }
                System.debug('ggggggggggglstwrapperFilesggggggggggggg : '+lstwrapperFiles);
            }
        }
        return json.serialize(lstwrapperFiles);
    }
     
     static String relationship;
     static List<String> fields = new List<String>();
     static JsonGenerator g = Json.createGenerator(false);
     static Map<Id,SObject> id2parent = new Map<Id,SObject>();
     static Map<Id,List<SObject>> id2children = new Map<Id,List<SObject>>();
     static List<Element__c> lstRetrivalElements = new List<Element__c>();
     
     public static String HierarchyGenerator(String parentName,boolean retriveCheck,String rId){
        System.debug('parentName : '+parentName);
        List<Element__c> lstParents = [select id,bucket__c,bucket__r.name,parent_Element__c,parent_Element__r.name,file_Size__c from Element__c where name = : parentName AND Related_Object_ID__c =: rId];
        set<id> setParentids = new set<id>();
        if(!lstParents.isEmpty()){
            Id rootId ;
            for(element__c each : lstParents){
                rootId = each.id;
                break;
            }
            
            SObjectType objectType = Element__c.SObjectType;
            SObjectField parentField = Element__c.parent_Element__c;
            SObjectField[] objectFields = new List<SObjectField>{Element__c.Id,ELement__c.OwnerId, Element__c.Name,Element__c.Type__c,Element__c.Bucket__c,Element__c.Extension__c,Element__c.createddate,Element__c.File_URL__c,Element__c.file_Size__c}; 
            
            
            for (ChildRelationship cr : objectType.getDescribe().getChildRelationships())
            if (cr.getField() == parentField) relationship = cr.getRelationshipName();
            
            //stringify field names
            for (SObjectField objectField : objectFields)
            fields.add(String.valueOf(objectField));
            
            //query all parents and children
            List<SObject> parents = Database.query(''
                + 'SELECT ' + String.join(fields, ',') + ','
                + '(SELECT ' + String.join(fields, ',') + ' FROM ' + relationship + ')'
                + 'FROM ' + objectType + ' '
                + 'LIMIT 10000' 
            );
            
            //associate collections by id
            for (SObject parent : parents) {
                id2parent.put(parent.Id, parent);
                id2children.put(parent.Id, parent.getSObjects(relationship));
            }
            
            //start with root
            traverseChildren(rootId,retriveCheck);
            
        }
        return '';
     } 
     
     static void traverseChildren(Id parentId,boolean retriveCheck) {
        
        //grab hydrated record
        SObject parent = id2parent.get(parentId);
        List<SObject> children = id2children.get(parentId);
        
        if (children == null) {
            //nothing to do
            children = new List<SObject>();
        }else{
            if(!((List<Element__c>)id2children.get(parentId)).isEmpty()){
                for(Element__c each :(List<Element__c>)id2children.get(parentId)){
                    if(retriveCheck == true){
                        if(each.Type__c == 'File'){
                            lstRetrivalElements.add(each);
                        }
                    }else{
                        lstRetrivalElements.add(each);
                    }
                    
                }
            }
            
        }
        
        //populate non-null keys
        g.writeStartObject();
        for (String key : fields) {
            Object value = parent.get(key);
            if (value == null) break;
            g.writeObjectField(key, value);
        }
        
        //imitate serialized relationship
        g.writeFieldName(relationship);
        g.writeStartObject();
        g.writeNumberField('totalSize', children.size());
        g.writeBooleanField('done', true);
        g.writeFieldName('records');
        g.writeStartArray();
        for (SObject child : children) traverseChildren(child.Id,retriveCheck);
        g.writeEndArray();
        g.writeEndObject();
        g.writeEndObject();
    }
    
    override public String toString() {
        return g.getAsString();
    }
     public static list<wrapperFiles> lstwrapperFiles{get;set;}
     public class wrapperFiles {
       	public String eleId{get;set;}
        public String name {set;get;}
        public String ext {set;get;}
        public String size {set;get;}
        //String Subfolder {set;get;}
        public String descp {set;get;}
        public String fileurl {set;get;}
        public DateTime createdDate {set;get;}
        public Boolean isSelected{get;set;}
     } 
     
     
     public  String accessTypeSelected = 'public-read';
     public  Blob fileBlob {get;set;}
     public  Integer fileSize {get;set;}
     public  String fileName {get;set;}
     public  String uploadObjectErrorMsg {get;set;}
     public  boolean checkUpload = false;
     

       Public  static AWS_Keys__c awsKeySet{get;set;}
       Public  static URL__c currentURL{get;set;}
       public string ForRedirect{get;set;}  
       public static string appParentId{get;set;}
       public string Content_Type {get;set;}  
       Public String acessType{get;set;}
      
      public void  UploadFileNonRemoting(){
        System.debug('body length:123 ' + fileSize);
        
        String onlyFileName = '';
        onlyFileName = fileName.substring(fileName.lastIndexOf('\\')+1);
            List<Element__c> lstElements = [select id from Element__c where Name = : onlyFileName];
            String result;
            if(lstElements.size() > 0){
                result = 'failed';
            } else {
                if(checkUpload == true){
                    Element__c t = new Element__c();
                        t.Name = fileName.substring(fileName.lastIndexOf('\\')+1);
                        t.Type__c = 'File';
                    
                    List<Element__c> lstParentId = [select id,bucket__c,bucket__r.name,parent_Element__c,parent_Element__r.name from Element__c where name = : parentName];
                    if(!lstParentId.isEmpty()){
                         t.parent_Element__c = lstParentId[0].id;
                         t.bucket__c = lstParentId[0].bucket__c;
                    }else{
                        List<Bucket__c> lstBucs = [select id from Bucket__c where Name = : parentName];
                        t.bucket__c = lstBucs[0].id;
                    }
                    //t.Description__c = topicDescription;    
                    insert t; 
                }
            }
      }
      
      public void setParentName(){
        //dummy
        System.debug('body length: ' + fileSize);
        System.debug('parentName ' + parentName);
      }
      
      
        @RemoteAction
    global static String createNewDocument(String uploadedFilename,string bucketName){
         //stem.debug('ApexPages.currentPage().getParameters() '+ApexPages.currentPage().getParameters().get('parentIdForRedirect')); 
        //Document__c newDocument = new Document__c();
            //newDocument.Application__c = appID;
            //newDocument.Subscriber__c = appID;
            //newDocument.Name = uploadedFilename;
            
            //newDocument.Document_URL__c =  'https://s3-ap-southeast-1.amazonaws.com/aviatordocument/'+bucketName+'/'+uploadedFilename;
            //newDocument.Status__c ='Uploaded';
            
         //insert  newDocument;
         
         return 'success';  
    
    } 
    
    @RemoteAction
    global static String getFileLinks(String jsonData){
        List<wrapperFiles> lstWrpp = new List<wrapperFiles>();
        List<wrapperFiles> jsonWrappList =  (List<wrapperFiles>)Json.deserialize(jsonData,List<wrapperFiles>.class);
        System.debug('jsonWrappList : '+jsonWrappList);
        if(!jsonWrappList.isEmpty()){
            for(wrapperFiles each : jsonWrappList){
                if(each.isSelected == true){
                    lstWrpp.add(each);
                }
            }
        }
        
        System.debug('lstWrpp : '+lstWrpp);
        
        if(!lstWrpp.isEmpty())
        return json.serialize(lstWrpp);
        else
        return 'Failed';    
    }
    
    @RemoteAction
    global static String deleteFiles(String jsonData){
        List<wrapperFiles> lstWrpp = new List<wrapperFiles>();
        List<wrapperFiles> jsonWrappList =  (List<wrapperFiles>)Json.deserialize(jsonData,List<wrapperFiles>.class);
        set<String> idToDelete = new set<String>();
        
        System.debug('jsonWrappList : '+jsonWrappList);
        if(!jsonWrappList.isEmpty()){
            for(wrapperFiles each : jsonWrappList){
                if(each.isSelected == false){
                    lstWrpp.add(each);
                }else if(each.isSelected == true){
                	idToDelete.add(each.eleId);
                }
            }
        }
        
        if(!idToDelete.isEmpty()){
        	delete [Select id from Element__c where id in: idToDelete ];
        }
        System.debug('lstWrpp : '+lstWrpp);
        if(!idToDelete.isEmpty())
        	return json.serialize(lstWrpp); 
        else
        	return 'Empty'; 
    }
     
}