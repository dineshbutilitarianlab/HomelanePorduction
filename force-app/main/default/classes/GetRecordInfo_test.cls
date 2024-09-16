@isTest
public class GetRecordInfo_test{
     
    static testMethod void testGetRecordInfo(){
        leadUtil_Test.insertLeadData('@abtest.com', 'testMetr@hlc.com');
        GetRecordInfo.strBody = '{"customeremail": "testMetr@hlc.com"}';
        GetRecordInfo.GetRecordInfo();
    }
 }