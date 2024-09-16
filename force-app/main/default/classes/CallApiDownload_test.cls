@isTest(SeeAllData=true)
private class CallApiDownload_test{
 
       static testMethod void testapiquote(){
           RecordType recType=[SELECT Id FROM RecordType WHERE Name='Person Account'];
        Account personAcc=new Account(LastName='prathap',recordTypeId=recType.Id,PersonEmail='prathap44@gmail.com',phone='04561254144');
        insert personAcc;
        
           Opportunity opp=new Opportunity(Name='prathik',AccountId=personAcc.Id,stageName='Quote Required',
                                        closeDate=system.today(),Amount=5000);
        insert opp;
        
           Element__c elemt2 = new Element__c( name='testelem2',Related_Object_ID__c = opp.id );
           insert elemt2 ;
           Element__c elemt = new Element__c( name='testelem1',Related_Object_ID__c = opp.id,Parent_Element__c=elemt2.id  );
           insert elemt;
                      ApexPages.CurrentPage().getparameters().put('elementId', elemt.id);

           CallApiDownload callmthd = new CallApiDownload(); 
           callmthd.CallApiDownloadAction();
           callmthd.dummy();
           
         
       }
}