/*********************************************
@Class Name    :    HierarchyClasslightning_Test
@Created Date  :    26-09-16
@Test Coverage :    0%
@Description   :    Test class for test coverage of HierarchyClassLightning.
*********************************************/
@IsTest
private class HierarchyClasslightning_Test{
    //Varibales
    
    /*****************************************
    @Method Name    :   HierarchyClassCoverageForOpp
    @Description    :   0% 
    *****************************************/ 
    static testMethod void HierarchyClassCoverageForOpp(){ 
        //Creating records
        RecursiveTriggerHandlerOpp.isFirstTime = false;
        
        //Json String formated as wrapper class "wrapperFiles"
        //String jsonInput = '[{ "eleId" :"Test","name" :  "Test Attachment",  "ext" : "txt", "size" : "5kb", "descp" : "Test descp", "fileurl" : "Test fileurl", "createdDate" : system.now(), "isSelected" : true}]';
        
        Test.StartTest();
            SC_isTriggerExecute__c objCustomSetting = new SC_isTriggerExecute__c(Name = 'Sales Coach Trigger on Opportunity',  isTriggerExecute__c = false);
            SC_OpportunityCustDate__c startDate = new SC_OpportunityCustDate__c(Name = 'StartDate', SC_StartDate__c = system.today().addDays(-1));
            AWS_Keys__c key = new AWS_Keys__c(Name = 'salesforcekvpbucket');
            URL__c url = new URL__c(Name = 'Env', URL__c = 'hlqa-homelane-qadev.cs6.force.com/Homelaneqadev');
            insert objCustomSetting;
            insert startDate;
            insert key;
            insert url;
            
            RecordType recType = [SELECT Id FROM RecordType WHERE Name='Person Account']; 
        
            Account objPersonAcc = new Account(LastName='Test Acc', recordTypeId=recType.Id,PersonEmail='Test@gmail.com', phone='045612541');
            insert objPersonAcc;
            
            Opportunity objTestOpp = new Opportunity(Name='Test Opp', AccountId=objPersonAcc.Id, StageName='Initial Quote Sent', CloseDate=system.today(), 
                                                    Amount=5000);
            
            
            
            insert objTestOpp ;
            
            PageReference objPageRef = Page.AWSTreeStructure;
            Test.setCurrentPageReference(objPageRef);
            ApexPages.CurrentPage().getparameters().put('id', objTestOpp.id);
            system.debug('objTestOpp.id---------------------------------------------->'+objTestOpp.id);
            
            HierarchyClassLightning objClass = new HierarchyClassLightning(new ApexPages.StandardController(objTestOpp)); 
            
            Profile pf1 = [Select Id from Profile where Name = 'Standard User'];
            User u1 = new User();        
            u1 .LastName = 'Manager1';
            u1 .Email = 'test@test123456789.com';
            u1 .CompanyName = 'test.com';
            u1 .Title = 'Test User1';
            u1 .Username = 'testuser12345678@test133456789.com';
            u1 .Alias = 'test';
            u1 .CommunityNickname = 'Test User12';
            u1 .TimeZoneSidKey = 'America/Mexico_City';
            u1.LocaleSidKey = 'en_US';
            u1.EmailEncodingKey = 'ISO-8859-1';
            u1.ProfileId = pf1.Id;            
            u1.LanguageLocaleKey = 'en_US';
            insert u1;
            
            //CLass variables
            objClass.renderListBucketResults = true;
            objClass.listBucketErrorMsg = '';
            objClass.createBucketErrorMsg  = '';
            objClass.deleteBucketErrorMsg = '';
            objClass.deleteObjectErrorMsg = '';
            objClass.selectedBucket = '';
            objClass.OwnerId = '';
            objClass.ParentName = '';
            objClass.eTemplateName  = '';
            objClass.eTemplateId = objTestOpp.Id;
            objClass.fileBlob = null;
            objClass.uploadObjectErrorMsg = '';
            Bucket__c b = new Bucket__c();
            b.Name = 'Test';
            b.Related_Object_ID__c = objTestOpp.id;
            insert b;
            Element__c ele = new Element__c();
            ele.bucket__c = b.Id;
            ele.Related_Object_ID__c = objTestOpp.id;
          insert ele;
            Project_Name__c obj = HierarchyClassLightning.relatedIdpro;
            //objClass.allBuckets.add(''); 
            
            List<Bucket__c> lstBucket = [Select Id, Name, Related_Object_ID__c From Bucket__c Where Related_Object_ID__c =: objTestOpp.id limit 1];
            system.debug('***** objBucket' + lstBucket);
            List<Element__c> lstElements = [Select Id, Name, Bucket__c, Parent_Element__c, Related_Object_ID__c, Type__c From Element__c Where Bucket__c =: lstBucket[0].Id And Related_Object_ID__c =: objTestOpp.id];
            system.debug('***** lstElements' + lstElements);
            objClass.fileName = lstElements[0].Name;
            
            List<Element__c> lstClildElements = new List<Element__c>();
            lstClildElements.add(new Element__c(Name='Test1 Elm', Bucket__c = lstBucket[0].Id, Parent_Element__c = lstElements[0].Id, Related_Object_ID__c = objTestOpp.id, Type__c = 'File'));
            lstClildElements.add(new Element__c(Name='Test2 Elm', Bucket__c = lstBucket[0].Id, Parent_Element__c = lstElements[0].Id, Related_Object_ID__c = objTestOpp.id)); 
            insert lstClildElements;
            
            //Json Data
            String jsonInput = '[{"size":"2.03 KB","name":"bc1.png","isSelected":true,"fileurl":"https://s3-ap-southeast-1.amazonaws.com/salesforcekvpbucket/bc1.png","ext":"png","eleId":"000AB1234567890","descp":null,"createdDate":"2016-09-29T04:52:13.000Z"}]';
            
            //Remote methods
            String strNewBucket = HierarchyClassLightning.createNew_Bucket('Test Bucket12345', 'Test record', objTestOpp.Id);
            String strSharePeople = HierarchyClassLightning.SharePeople(lstBucket[0].Id, u1.Id, objTestOpp.Id);
            String strGetFile = HierarchyClassLightning.getFiles('[Test]', lstBucket[0].Id, objTestOpp.Id);
            String strGetAllFiles = HierarchyClassLightning.getAllFiles(objTestOpp.Id);
            system.debug('-----lstBucket[0].Name-----' + lstBucket[0].Name);
            String strUploadFile = HierarchyClassLightning.uploadFile('Test File 12345', 'Test Description', lstBucket[0].Name, 'file', 'txt', '5kb', String.valueof(objTestOpp.Id) ,'https://phoenixartifacts-dev.s3.amazonaws.com/customers/0280/quotations/0280-initial-quote-draft-7.pdf?AWSAccessKeyId=AKIAIDNKID72WTU43YAA&Expires=1476440476&Signature=HvR6%2BZCNfirAVmE37TbJkcm%2BoJk%3D' );
            String strCreateNewDocument = HierarchyClassLightning.createNewDocument('Test', 'Test');
            String strHierarchyGenerator = HierarchyClassLightning.HierarchyGenerator(lstElements[0].Name, true, objTestOpp.Id);
            String strGetFileLinks = HierarchyClassLightning.getFileLinks(jsonInput);
            String strDeleteFiles = HierarchyClassLightning.deleteFiles(jsonInput);
            
            String upld = HierarchyClassLightning.updateOppFileNumber(objTestOpp.Id);
            HierarchyClassLightning.updateOpp(objTestOpp.Id);
            HierarchyClassLightning.dummy();
            
            objClass.UploadFileNonRemoting();
            objClass.toString();
            
            //Wrapper class coverage 
            HierarchyClassLightning.wrapperFiles objWrapper = new HierarchyClassLightning.wrapperFiles();
            HierarchyClassLightning.SobjectDetails objSobjectDetails = new HierarchyClassLightning.SobjectDetails();
            
            //Wrapper class variables
            objWrapper.name = ''; 
            objWrapper.ext = '';
            objWrapper.size = '';
            objWrapper.descp = '';
            objWrapper.fileurl = '';
            objWrapper.createdDate = system.now();   
            
            
                   
        Test.StopTest();
    }
    
    
    
}