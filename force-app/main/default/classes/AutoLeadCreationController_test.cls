@isTest
public class AutoLeadCreationController_test {
    public static String nam = 'Gachibowli Showroom';
    public static String em = 'abc@homelane.com';
   
    public static testMethod void test2() {
        Test.startTest();
        AutoLeadCreationController a = new AutoLeadCreationController();
        a.lastName = 'Hello';
        a.selectedOption = 'Yes';
        a.cityOption1 = 'Bengaluru';
        a.showroomOption1 = nam;
        a.intDesign = em;
        a.phone = '2999000198';
        a.email = 'email@email.com';
        a.autoLead();  
        Test.stopTest();
    }   
      
    public static testMethod void test3() {
        Test.startTest();
        AutoLeadCreationController a1 = new AutoLeadCreationController();
        a1.lastName = 'test';
        a1.selectedOption = 'Yes';
        a1.cityOption1 = 'Bengaluru';
        a1.showroomOption1 = nam;
        a1.intDesign = em;
        a1.phone = '299900198';
        a1.email = 'emailtest';
        a1.autoLead(); 
        Test.stopTest();
    }
    
     public static testMethod void test4() {
        Test.startTest();
        AutoLeadCreationController a2 = new AutoLeadCreationController();
        a2.lastName = 'test';
        a2.selectedOption = 'Yes';
        a2.cityOption1 = 'Bengaluru';
        a2.showroomOption1 = nam;
        a2.intDesign = em;
        a2.phone = '2999001980';
        a2.email = 'emailtest';
        a2.autoLead();
        Test.stopTest();
    }
    
    public static testMethod void test5() {
        Test.startTest();
        AutoLeadCreationController a3 = new AutoLeadCreationController();
        a3.lastName = 'hello123';
        a3.selectedOption = 'Yes';
        a3.cityOption1 = 'Bengaluru';
        a3.showroomOption1 = nam;
        a3.intDesign = em;
        a3.phone = '2999001980';
        a3.email = 'emailtest@test.com';
        a3.autoLead();
        Test.stopTest();
    }
    
    public static testMethod void test6() {
        Test.startTest();
        AutoLeadCreationController a4 = new AutoLeadCreationController();
        a4.lastName = 'hello12345';
        a4.selectedOption = 'Yes';
        a4.cityOption1 = 'Bengaluru';
        a4.showroomOption1 = nam;
        a4.intDesign = em;
        a4.email = '';
        a4.phone = '2999001981';
        a4.autoLead();
        Test.stopTest();
    }
    
    public static testMethod void test7() {
        Test.startTest();
        AutoLeadCreationController a5 = new AutoLeadCreationController();
        a5.lastName = 'hello1234567';
        a5.selectedOption = 'No';
        a5.cityOption1 = 'Bengaluru';
        a5.showroomOption1 = nam;
        a5.intDesign = em;
        a5.phone = '2999001981';
        a5.email = 'email2345';
        a5.autoLead();
        Test.stopTest();
    }
    
    public static testMethod void test8() {
        Test.startTest();
        AutoLeadCreationController a6 = new AutoLeadCreationController();
        a6.lastName = 'hello12345678';
        a6.selectedOption = '---None---';
        a6.cityOption1 = 'Bengaluru';
        a6.showroomOption1 = nam;
        a6.intDesign = em;
        a6.phone = '2999001981';
        a6.email = 'email2345';
        a6.autoLead();
        Test.stopTest();
    }
    
    public static testMethod void test9() {
        Test.startTest();
        AutoLeadCreationController a7 = new AutoLeadCreationController();
        a7.lastName = '';
        a7.selectedOption = 'No';
        a7.cityOption1 = 'Bengaluru';
        a7.showroomOption1 = nam;
        a7.intDesign = em;
        a7.phone = '2999001981';
        a7.email = 'email2345';
        a7.autoLead();
        Test.stopTest();
    }
    
    public static testMethod void test91() {
        Test.startTest();
        AutoLeadCreationController a8 = new AutoLeadCreationController();
        a8.lastName = 'afdsgdhf';
        a8.selectedOption = 'No';
        a8.cityOption1 = '---None---';
        a8.showroomOption1 = nam;
        a8.intDesign = em;
        a8.phone = '2999001981';
        a8.email = 'email2345';
        a8.autoLead();
        Test.stopTest();
    }
    
    public static testMethod void test92() {
        Test.startTest();
        AutoLeadCreationController a9 = new AutoLeadCreationController();
        a9.lastName = 'dfgh';
        a9.selectedOption = 'No';
        a9.cityOption1 = 'Mumbai';
        a9.showroomOption1 = '---None---';
        a9.intDesign = em;
        a9.phone = '2999001981';
        a9.email = 'email2345';
        a9.autoLead();
        Test.stopTest();
    }
    
    public static testMethod void test93() {
        Test.startTest();
        AutoLeadCreationController a0 = new AutoLeadCreationController();
        a0.lastName = 'dfghgf';
        a0.selectedOption = 'No';
        a0.cityOption1 = 'Mumbai';
        a0.showroomOption1 = 'name';
        a0.intDesign = 'abc@homelane.com';
        a0.phone = '2999001989';
        a0.email = 'email2345@homelane.com';
        a0.autoLead();
        Test.stopTest();
    }
}