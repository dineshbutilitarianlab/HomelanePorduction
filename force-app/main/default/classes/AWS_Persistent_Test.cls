/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AWS_Persistent_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        AWS_Persistent persistent = new AWS_Persistent();
        
        AWS_Persistent.genericQuery('WHERE id!= null','USER_MULTISELECT','user');
        AWS_Persistent.queryUser('WHERE name != null','USER_MULTISELECT');
        AWS_Persistent.queryUsersById(new set<id>{userinfo.getuserid()},'USER_PIC_COMMON');
        profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
     	User usr = new User(LastName = 'LIVESTON',
                           FirstName='JASON',
                           Alias = 'jliv',
                           Email = 'jason.liveston@asdf.com',
                           Username = 'jason.liveston@asdf.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        AWS_Persistent.saveUser(new List<user>{usr});
        account acc = new account(lastname='xxxxxxx');
        insert acc;
        EntitySubscription entity = new EntitySubscription(parentid 	= 	acc.id, subscriberid	=	userinfo.getuserid());
        AWS_Persistent.updateUser(new List<user>{new user(id=userinfo.getuserid())});
        AWS_Persistent.totalUserCount('WHERE Name != null');
        AWS_Persistent.saveEntitySubscription(new List<EntitySubscription>{entity});
        AWS_Persistent.queryEntitySubscription();
        AWS_Persistent.queryEntitySubscriptionByIds(new set<id>{userinfo.getuserid()});
        AWS_Persistent.deleteEntitySubscription(new List<EntitySubscription>{entity});
        List < PackageLicense> packages 	=	AWS_Persistent.queryPackageLicense('WHERE id != null ','PACKAGE_LICENSE_FIELDS');
        AWS_Persistent.queryUserPackageLicense('WHERE id != Null','User_Package_License_FIELDS');
        AWS_Persistent.getUserPackageLicenseById(new set<id>{},new set<id>{});
        /*userpackagelicense uPack = new userpackagelicense(userid	=	userinfo.getuserid() , packagelicenseid = packages[0].id);
    	AWS_Persistent.saveUserPackageLicense(new List <UserPackageLicense>{uPack});
    	AWS_Persistent.deleteUserPackageLicense(new List <UserPackageLicense>{uPack});*/
    	AWS_Persistent.queryProfileLicense(' WHERE id != Null ','PROFILE_FIELDS');
    	AWS_Persistent.queryGroup(' WHERE id != Null ','GROUP_MULTISELECT');
    	AWS_Persistent.queryGroupMember(new set<id>{},'GROUP_MULTISELECT');
    	AWS_Persistent.queryGropsById(new set<id>{},'GROUP_MULTISELECT');
    	AWS_Persistent.queryGroupMember(' WHERE id != null ','GROUPMEMBER_FIELDS');
    	AWS_Persistent.queryUserwithPic(new set<id>{userinfo.getUserid()},'USER_PIC_COMMON');
    	Attachment att = new attachment(name='atttt',parentid = acc.id,body=blob.valueof('Test Attachment'));    	
    	AWS_Persistent.saveAttachment(new list<attachment>{att});
    	AWS_Persistent.updateAttachment(new list<Attachment>{att});
    	AWS_Persistent.deleteAttachment(new List<Attachment>{att});
    	AWS_Persistent.queryProfilePhoto(new set<id>{userinfo.getuserid()});
    	
    	
    }
}