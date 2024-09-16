@isTest 
public class CallOzoneTelAPIProcessBuilder_Test {
    @isTest static void call() {
        Map<String,Id> profileData = new Map<String,Id>();
        for(Profile obj : [SELECT Name,Id FROM Profile WHERE Name IN ('WTA Profile','Square Sales Profile','Square Profile','Design Partner Profile')]){
            profileData.put(obj.Name,obj.Id);
        }
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        User wta_user=leadUtil_Test.inserUser('tetWta1@gmail.com','TesWT1','',profileData.get('WTA Profile')); 
        insert wta_user;
        
         List<id> leadList = new List<id>();
           Lead l = new Lead(
           FirstName='Vaniya',
            LastName='Sowmyala',
            Email='testWLffdfd@hamelane.com',
            Phone='9844318107',
            OwnerId = wta_user.Id,
            WT_Agent__c = wta_user.Id,
            City='Bengaluru',
            Status='Fresh Lead',
             Sub_Status__c ='New',
             LeadSource='Website'
             ); 
        System.debug('Lead is : '+l); 
         leadList.add(l.Id); 
        Test.startTest();
        CallOzoneTelAPIProcessBuilder.callApi(leadList);
        Test.stopTest();
    }
}