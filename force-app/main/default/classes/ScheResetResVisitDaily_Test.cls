@isTest
public class ScheResetResVisitDaily_Test {
    @isTest static void test() {
        Lead_Round_Robin_Assignment__c ObjRoundRobin = new Lead_Round_Robin_Assignment__c();
        ObjRoundRobin.Assignment_Days__c = 'Monday';
        ObjRoundRobin.Daily_Assignment__c= 1;
        ObjRoundRobin.Daily_Limit__c= 10;
        ObjRoundRobin.Monthly_Assignments__c= 100;
        ObjRoundRobin.Monthly_Limit__c= 10;
        ObjRoundRobin.Showroom_Name__c= 'HSR';
        ObjRoundRobin.Distance_from_ShowRoom__c= 10;

        insert ObjRoundRobin;  
        ScheResetResVisitDaily s = new ScheResetResVisitDaily();
        s.execute(null);
    }
}