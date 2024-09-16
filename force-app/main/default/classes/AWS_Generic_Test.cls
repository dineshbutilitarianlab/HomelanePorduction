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
private class AWS_Generic_Test {

    public static testMethod void myUnitTest() {
        // TO DO: implement unit test
        AWS_GenericModels.GroupMemberModel grpModel = new AWS_GenericModels.GroupMemberModel();
        grpModel.toSObject();        
        grpModel.setValue(new GroupMember());
        
        AWS_GenericModels.GroupModel grp = new AWS_GenericModels.GroupModel();
        grp.toSObject();        
        grp.setValue( new Group());
        
        AWS_GenericModels.UserModel usr = new AWS_GenericModels.UserModel();
        
        usr.toSObject();        
        usr.setValue( new user());
        usr.source ='MANAGE_USER_NEW';
        
        usr.lastname ='ABC';
        usr.toSObject();
        usr.lastname ='ABCDEF';
        usr.toSObject();
        usr.source ='MANAGE_USER_EDIT';
        usr.toSObject();
        usr.source ='MANAGE_USER_DEACTIVATE';
        usr.toSObject();
        usr.isFingertipUser = 	false;
        usr.isFollowing 	=	'';
        
        AWS_GenericModels.PackageLicenseModel pack = new AWS_GenericModels.PackageLicenseModel();
        pack.toSObject();        
        pack.setValue( new PackageLicense());
        
        AWS_GenericModels.UserPackageLicenseModel userPack = new AWS_GenericModels.UserPackageLicenseModel();
        userPack.toSObject();        
        userPack.setValue( new UserPackageLicense());
        userPack.id 	=	null;
        
        AWS_GenericModels.ProfileModel profile = new AWS_GenericModels.ProfileModel();
        profile.toSObject();        
        profile.setValue( new Profile());
        
        AWS_GenericModels.ModelData md = new AWS_GenericModels.ModelData();
    	md.models	= new List<AWS_Generic.Modelable>();
    	md.total	=	0;
 		AWS_GenericModels.ModelMapping mdMap = new AWS_GenericModels.ModelMapping('Integer','id','Group');
        
        AWS_Generic.UIConfigurable UI;
        AWS_Generic.DataSource dt;
        AWS_Generic.Modelable mdl;
        AWS_Generic.UserPicModelable usrPic;
        AWS_GenericModels.taskmodel tsk = new AWS_GenericModels.taskmodel();
        
        tsk.toSObject(); 
    }
    
}