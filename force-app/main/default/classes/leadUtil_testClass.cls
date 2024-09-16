@isTest
public class leadUtil_testClass{
    static testMethod void leadUtil_TestMethod(){
        Test.StartTest();
        leadUtil_Test.insertLead('Testutil@gmail.com','8654563631');
        leadUtil_Test.inserUser('TestutilUSer@gmail.com','alus','','00e28000000ehMk');
        leadUtil_Test.insertLeadData('Uwr1@gmail.com', 'Testutil1@gmail.com');
        leadUtil_Test.InsertUserData('Ur1@gmail.com', 'Testutilop@gmail.com');
        Test.StopTest();
    }
}