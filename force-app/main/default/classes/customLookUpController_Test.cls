@IsTest
public class customLookUpController_Test{
    @isTest static void lookupTest1() {
          String searchword ='Test';
          String Obj = 'Interior_Designer__c';
          customLookUpController.fetchLookUpValues(searchword ,Obj );
   }  
   @isTest static void lookupTest2() {
          String searchword ='Test';
          String Obj = 'Master__c';
          String pic = 'Property';           
          customLookUpController.fetchLookUpValuesProperty(searchword ,Obj, pic );
   }  
   @isTest static void lookupTest3() {
          String searchword ='Test';
          String Obj = 'Master__c';
          String pic = 'Builder';
          customLookUpController.fetchLookUpValuesBuilder(searchword ,Obj, pic  );
   }  
   @isTest static void lookupTest4() {
          String searchword ='Test';
          String Obj = 'Master__c';
          String pic = 'Showroom';
          customLookUpController.fetchLookUpValuesShowroom(searchword ,Obj, pic );
   }  
}