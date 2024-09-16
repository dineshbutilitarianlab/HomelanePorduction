@isTest 
Public class ScheduleSendEmailToDPAndManagers_Test {
    public static testMethod void execute() {
        Test.startTest();
        ScheduleSendEmailToDPAndManagers ss = new ScheduleSendEmailToDPAndManagers ();
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, ss);
        Test.stopTest();
    }
}