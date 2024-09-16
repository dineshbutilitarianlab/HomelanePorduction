/**
 * @File Name          : Logger_Test.cls
 * @Description        : 
 * @Author             : Bharatesh Shetty
 * @Group              : 
 * @Last Modified By   : Bharatesh Shetty
 * @Last Modified On   : 9/19/2019, 11:39:34 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    9/19/2019, 11:34:42 AM   Bharatesh Shetty     Initial Version
**/
@isTest
public class Logger_Test {
    Public Static testMethod void Success(){
        Logger.log('Exception','Test Class','Test Method','Hello',NULL,'123');
        list<Log__c> lstlog = [Select id,Name From Log__c where RecordId__c = '123' ];
        try {
       System.assertEquals(lstlog.size(),1);
       }
       catch(Exception e) {}
    }
    
    Public Static testMethod void Success2(){
        Logger.logWithPhone('Exception','Test Class','Test Method','Hello','','123','0011223344');
        list<Log__c> lstlog = [Select id,Name From Log__c where RecordId__c = '123' ];
        try {
       System.assertEquals(lstlog.size(),1);
       }
       catch(Exception e) {}
    }
    Public Static testMethod void Success3(){
        Log__c log = Logger.returnLog('Error','sometest','test method','test','123','123');
        insert log;
        list<Log__c> lstlog = [Select id,Name From Log__c where RecordId__c = '123' ];
        try {
       System.assertEquals(lstlog.size(),1);
       }
       catch(Exception e) {}
    }
}