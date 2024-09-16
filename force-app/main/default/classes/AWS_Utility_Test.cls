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
private class AWS_Utility_Test {

    static testMethod void myUnitTest1(){ 
        Test.StartTest();
	        String strVal = AWS_Utility.fingertipNameSpace;
	        Map<String, Map<String, String>> mapStrVSStr = AWS_Utility.kendoOperatorMapping;
	        //AWS_Utility.typeToString(System.type);
	        AWS_Utility.getDateFormat();
	        AWS_Utility.getDateTimeFormat(); 
	    Test.StopTest();
    }
    
    static testMethod void myUnitTest2(){
    	AWS_GenericModels objGModel = new AWS_GenericModels();
    	//AWS_GenericModels.GroupModel model = AWS_GenericModels.GroupModel()
    	Account acc = new Account(lastname='Abcd');
    	insert acc;
    	
    	task tsk = new task(whatid = acc.id, subject='7asdha');
    	insert tsk;
    	List<sobject> sobjs = database.query('SELECT id,subject,OwnerId FROm task Limit 1');
    	AWS_Generic.Modelable models	=  toDTO(sobjs[0],AWS_GenericModels.TaskModel.class.getName());
    	 AWS_Utility.setProfilePic(new list<AWS_Generic.Modelable>{models});
    	 
    	 AWS_GenericModels.ModelMapping wrap = new AWS_GenericModels.ModelMapping('Group','id','Integer');
	    	  
    	 AWS_Utility.createDTOFieldMapping(new list<AWS_GenericModels.ModelMapping>{wrap});
    	 AWS_Utility.ieCompatible();
    	 AWS_Utility.chkUserHasObjectAccess(userinfo.getUserId(),'Account');
    	 AWS_Utility.chkUserLicense(new set<id>{Userinfo.getuserid()});
    	 AWS_Utility.findUserInDB(userinfo.getName(),1,new set<id>{});
    	 AWS_Utility.findUserInDB('�asasoO',1,new set<id>{});
    	 AWS_Utility.findGroupInDB('',1);
    	 AWS_Utility.listIdsToString(new list<string>{'Asddsd','asdadfsf'});
    	 Type t = Type.forName('AWS_Generic');
    	 AWS_Utility.typeToString(t); 
    	 AWS_Utility.UserWrap Aw = new AWS_Utility.UserWrap(new user());
    	 aw.ftUser = false;
    	 Boolean ftuser = aw.ftUser;
    	 AWS_Utility.saveImageCrop(Acc.id,'asdasssssdsd'); 
    	 Attachment attach 	= 	new attachment(parentid=acc.id,body=blob.valueOf('test body'), name=acc.id);
    	 insert attach;
    	 AWS_Utility.saveImageCrop(Acc.id,'asdasssssdsd');
    	 AWS_Utility.describeMultiselect('Account','Salutation');
    	 AWS_Utility.ft_AttachmentType(new List<Attachment>{attach});
    	 
    	 
    }
    
    public static AWS_Generic.Modelable toDTO(sObject obj, String className){
        //className = DTO.Decision.class.getName();
        Type t = Type.forName(className);
        AWS_Generic.Modelable dto = (AWS_Generic.Modelable)t.newInstance();
        if(obj != null){
        	dto.setValue(obj);
        }
        return dto;
    }
}