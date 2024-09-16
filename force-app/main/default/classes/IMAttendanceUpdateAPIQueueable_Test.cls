@isTest
global class IMAttendanceUpdateAPIQueueable_Test {
    
    public  static Showroom_User__c showroomUser;
    public static String accessToken;
    public static Integer isCheckAttendance;
    
    @testSetup static void setUp(){
        showroomUser = TestData_Factory.createShowroomUser(false);
        showroomUser.IsActive__c = false;
        showroomUser.City__c='Bengaluru';
        insert showroomUser; 
        
        Integration_Setting__c intSet= new Integration_Setting__c();
        intSet.Name = 'DarwinBOX Auth Token';
        intSet.End_Point__c = 'https://dp-score.homelane.com/user/login';
        intSet.Username__c = 'roster';
        intSet.Password__c = '4@rosTer!2k2o';
        intSet.ContentType__c = 'json';
        insert intSet;
        
        Integration_Setting__c intSet1= new Integration_Setting__c();
        intSet1.Name = 'DarwinBOX IRM Attendance_API';
        intSet1.End_Point__c = 'https://dp-score.homelane.com/api/v1/get_irm_attendence';
        insert intSet1;
    }
    
    @isTest
    public static  void testschedule1() {
        Test.StartTest();
        IMAttendanceUpdateAPIScheduler sh1 = new IMAttendanceUpdateAPIScheduler(0);      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
        
    }
    @isTest
    public static  void testschedule2() {
        Test.StartTest();
        IMAttendanceUpdateAPIScheduler sh1 = new IMAttendanceUpdateAPIScheduler();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
    @isTest
    public static void testQueueable1() {
        Test.setMock(HttpCalloutMock.class, new HttpMockClassCallout_Test());
        test.startTest();
        IMAttendanceUpdateAPIQueueable updater = new IMAttendanceUpdateAPIQueueable(0);
        System.enqueueJob(updater);
        test.stopTest();
    }
    @isTest
    public static void testQueueable2() {
        test.startTest();
        IMAttendanceUpdateAPIQueueable IMAttendanceUpdateAPIQueueableInst = new IMAttendanceUpdateAPIQueueable();
        IMAttendanceUpdateAPIQueueable.getIRMAttendanceAPICallout('vsgshs',1);
        test.stopTest();
    }
}