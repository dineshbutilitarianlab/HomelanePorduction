public with sharing class AWS_GenericModels {

    // GroupMember
    public class GroupMemberModel implements AWS_Generic.Modelable{
        
        @AuraEnabled
        public Id groupId {get; set;}
        
        @AuraEnabled
        public Id usrOrGrpId {get; set;}
            
        @AuraEnabled
        public Id id {get; set;}
        
        public sObject toSObject(){
            GroupMember m =  new GroupMember();
            m.GroupId = this.groupId ;
            m.id = this.id;
            m.UserOrGroupId = this.usrOrGrpId; 
            return m;
        }
        public void setValue(sObject obj){
            
            GroupMember m = (GroupMember) obj;
            this.groupId = m.GroupId;
            this.id = m.id;
            this.usrOrGrpId = m.UserOrGroupId; 
        }
    }
    
    // Group
    public class GroupModel implements AWS_Generic.Modelable{
        
        @AuraEnabled
        public String name {get; set;}
        
        @AuraEnabled
        public Boolean isGroup {get; set;}
            
        @AuraEnabled
        public Id id {get; set;}
        
        @AuraEnabled
        public String desr {get; set;}
        
        public sObject toSObject(){
            Group u =  new Group();
            u.Id = this.id;
            //u.Name = this.name;
            //u.SmallPhotoUrl = this.smallPhotoUrl;
            return u;
        }
        public void setValue(sObject obj){
            Group u = (Group) obj;
            this.isGroup = true;
            this.id = u.id;
            this.name = u.Name; 
            this.desr = 'Public Group';
        }
    }
    
    // User
    public class UserModel implements AWS_Generic.Modelable{
        
        @AuraEnabled
        public String name {get; set;}
        
        @AuraEnabled
        public String smallPhotoUrl {get; set;}
        
        @AuraEnabled
        public Id id {get; set;}
        
        @AuraEnabled
        public String desr {get; set;}
        
        @AuraEnabled
        public String firstName{get; set;}
        
        @AuraEnabled
        public String lastName {get; set;}
        
        @AuraEnabled
        public String email {get; set;}
        
        @AuraEnabled
        public String phone {get; set;}
        
        @AuraEnabled
        public String username{get; set;}
        
        @AuraEnabled
        public String source{get; set;}
        
        @AuraEnabled
        public String ProfileID{get;set;}
        
        @AuraEnabled
        public Boolean isActive{get;set;}
        
        @AuraEnabled
        public Boolean isFingertipUser{get;set;}

        @AuraEnabled
        public String isFollowing{get;set;}
        
        public sObject toSObject(){
            User u =  new User();
            //u.Id = this.id;
            //u.Name = this.name;
            //u.SmallPhotoUrl = this.smallPhotoUrl;
             if(this.source == 'MANAGE_USER_NEW')
            {
                u.FirstName = this.firstName;
                u.lastName = this.lastName ;
                u.email = this.email ;
                u.phone = this.phone ;
                u.username = this.username;
                u.isActive = this.isactive;
                
                  if(lastName.length() > 5)
                {
                    u.Alias = lastName.substring(0,5);
                    u.CommunityNickname = lastName.substring(0,5) + DateTime.now().millisecond();
                }
                else
                {
                    u.Alias = lastName;
                    u.CommunityNickname = lastName + DateTime.now().millisecond();
                }              
                
                u.LocaleSidKey = 'en_US';
                u.TimeZoneSidKey = 'GMT';                
                u.LanguageLocaleKey = 'en_US';
                u.EmailEncodingKey = 'UTF-8';
                u.ProfileID = this.ProfileID;
            }
            else if(this.source == 'MANAGE_USER_EDIT')
            {
                u.Id = this.id;  
                u.FirstName = this.firstName;
                u.lastName = this.lastName ;
                u.email = this.email ;
                u.phone = this.phone ;
                u.username = this.username; 
                 u.isActive = this.isactive; 
            } 
            else if(this.source == 'MANAGE_USER_DEACTIVATE')
            {
                u.Id = this.id; 
                u.isActive = this.isActive ;
            }
            else
            {
                 u.Id = this.id;
            }
            return u;
        }
        public void setValue(sObject obj){
            User u = (User) obj;
            this.id = u.id;
            this.name = u.Name; 
            this.desr = 'Non-Fingertip User'; 
            this.smallPhotoUrl = u.SmallPhotoUrl; 
            this.phone = u.phone;
            this.firstName = u.firstName;
            this.lastName = u.lastName;
            this.email = u.email;
            this.username = u.username;
            this.isActive= u.isActive;
        }
    }
    
    // PackageLicense
    public class PackageLicenseModel implements AWS_Generic.Modelable{
    
        @AuraEnabled
        public Integer AllowedLicenses{get; set;}
        
        @AuraEnabled
        public Integer UsedLicenses{get; set;}
        
        @AuraEnabled
        public DateTime ExpirationDate{get; set;}
        
        @AuraEnabled
        public String Id{get; set;}
        
        @AuraEnabled
        public boolean doesFTLicenseNeeded{get; set;}
    
         public sObject toSObject(){
             PackageLicense pl =  new PackageLicense();
             return pl;
         }
         
         public void setValue(sObject obj){
             PackageLicense pl = (PackageLicense)obj;   
             this.AllowedLicenses = pl.AllowedLicenses;
             this.UsedLicenses = pl.UsedLicenses;
             this.ExpirationDate = pl.ExpirationDate;
             this.doesFTLicenseNeeded = true;
             this.Id = pl.Id; 
         }
    }
    
    // UserPackageLicense
    public class UserPackageLicenseModel implements AWS_Generic.Modelable{
    
        @AuraEnabled
        public String UserId{get; set;}  
        
        @AuraEnabled
        public String PackageLicenseId{get; set;}      
                
        @AuraEnabled
        public String Id{get; set;}
    
         public sObject toSObject(){
             UserPackageLicense pl =  new UserPackageLicense();  
             pl.UserId = this.UserId;
             pl.PackageLicenseId = this.PackageLicenseId;           
             return pl;
         }
         
         public void setValue(sObject obj){
             UserPackageLicense  pl = (UserPackageLicense)obj;   
             this.UserId = pl.UserId;
             this.PackageLicenseId = pl.PackageLicenseId;             
             //this.Id = pl.Id; 
         }
    }
    
    //ProfileLicense
    public class ProfileModel implements AWS_Generic.Modelable{    
              
        @AuraEnabled
        public String Id{get; set;}
    
         public sObject toSObject(){
             Profile pl =  new Profile();             
             return pl;
         }
         
         public void setValue(sObject obj){
             Profile pl = (Profile)obj;             
             this.Id = pl.Id; 
         }
    }
    
    public class TaskModel implements AWS_Generic.UserPicModelable{
        @AuraEnabled
        public Id id {get; set;}
        
        @AuraEnabled
        public String assignTo {get; set;}
        
        @AuraEnabled
        public Id assignToId {get; set;}
        
        @AuraEnabled
        public Decimal estimateHr {get; set;}
        
        @AuraEnabled
        public Decimal actualHr {get; set;}
        
        @AuraEnabled
        public Datetime startdate {get; set;}
        
        @AuraEnabled
        public Datetime enddate {get; set;}
        
        @AuraEnabled
        public String PI {get; set;}
        
        @AuraEnabled
        public String subjectForTask {get; set;}
        
        @AuraEnabled
        public Id relatedToObjId {get; set;}
        
        @AuraEnabled
        public String status {get; set;}
        
        @AuraEnabled
        public Date dueDate {get; set;}
        
        @AuraEnabled
        public String comment {get; set;}
        
        @AuraEnabled
        public String reminderDt {get; set;}
        
        @AuraEnabled
        public Boolean reminderSet {get; set;}
        
        @AuraEnabled
        public String priority{get; set;}
        
        @AuraEnabled
        public String complexity {get; set;}
        
        @AuraEnabled
        public String skilllevel {get; set;}
        
        @AuraEnabled
        public String relatedToName {get; set;}
        
        @AuraEnabled
        public String pic {get; set;}
        
        @AuraEnabled
        public String onr {get; set;}
        
        @AuraEnabled
        public String actionOrigin {get; set;} //this variable will be used convert based on the different origins
        
        public void setPhoto(String userImg){
            this.pic = userImg;
        }
       
        public Id getUserId(){
            return this.assignToId;
        }
        public sObject toSObject(){
            Task t = new Task();
            t.Id = this.id;
            t.Subject = this.subjectForTask;
            t.OwnerId = this.assignToId;
            
            
            return t;
        }
        
        public void setValue(sObject obj){
            Task t = (Task) obj;
            this.id = t.id;
            this.subjectForTask = t.Subject;
            this.assigntoid = t.ownerid;
            
        }
            
    }
   
    /**/
    public class ModelData{ 
        @AuraEnabled
        public List<AWS_Generic.Modelable> models {set; get;}
        @AuraEnabled
        public Integer total {set; get;} 
    }
    /*FT Common Modals*/
    public class ModelMapping{
        public String sObjField {set; get;}
        public String modelField {set; get;}
        public String dataType {set; get;}
        /*public String maxLength {set; get;}*/
        
        public ModelMapping(String dataType, String modelField, String sObjField){
            this.sObjField = sObjField;
            this.modelField = modelField;
            this.dataType = dataType;
            //this.maxLength = maxLength;
        }
    }   
 
}