@isTest
public class LuxeLeadAssignmentHandler_Test {
 
     public static lead objLead ;
    public static Showroom_User__c objShowroom;
    public static Territory__c objTerr;
    public static master__c showroom;
  public static testMethod void DirectAssignment(){
        test.startTest();
        Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.Threashold__c = 10;
        objShowroom1.Backlogs__c = 2;
        objShowroom1.Daily_Assignment__c = 1;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        //
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Silver';
        
        insert ObjShowroom1;
        
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
        objShowroom2.Email__c = 'TestSHowRoomasdUSer@test.com';
        objShowroom2.Threashold__c = 10;
        objShowroom2.Backlogs__c = 2;
        objShowroom2.Daily_Assignment__c = 4;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true;
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.Outskirts_Assignment__c=1;
        
        objShowroom2.Outskirts_Assignment_Limit__c=3;
        ObjShowroom2.IM_Class__c='Gold';
        
        insert objShowroom2;
        
        
        
        
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
        objTerr.Lat_Long__Latitude__s = 20.0936477440000;
        objTerr.Lat_Long__Longitude__s =  89.7849897840000;
        objTerr.Cluster_Brand__c ='Homelane';
        
        Insert objTerr ;
        
        Territory__c objTerr1 = TestData_Factory.createTerritory('Area b',ObjShowroom2.id,'Bengaluru','Cluster A','123457',False);
        objTerr1.Lat_Long__Latitude__s = 25.0936477440000;
        objTerr1.Lat_Long__Longitude__s =  88.7849897840000;
        objTerr1.Cluster_Brand__c ='Homelane';
        //objTerr1.Sales_Campaign__c ='Green Channel';
        Insert objTerr1;            
        
        Account ac = new account();
        ac.Name='testacc';
        insert ac;
        lead objLead = new Lead();
        objlead = TestData_Factory.CreateFreshLead(false);
        objlead.Postalcode = '123457';
        objLead.Brand__c ='Homelane';
        objLead.City='Bengaluru';
        objLead.IM_Assignment_Stage__c ='Lead Creation';
        objLead.Account__c= ac.id;
        objLead.Sign_Up_Source__c ='HomeLaneLuxeLeadForm';
        Insert objlead;
        list<Lead> lstLead = [Select Id,email,LastName,LeadSource,Postalcode,city,Assigned_To_Resi_ASM__c,Should_run_Ironman_assignment__c,phone,Squad_IQ_Status__c,Status,Sub_Status__c,Bulk_Upload__C,Brand__c From Lead];
        Set<String>  setString= new set<String>();
        setString.add(lstLead[0].Postalcode);
        
        LuxeLeadAssignmentHandler.getLuxeShowroomUserDetails(lstLead,setString);
        list<Territory__c > lst = [Select id,Name,Cluster__C,Assignment__c,Lat_Long__Latitude__s,Lat_Long__Longitude__s,IronMan__c,Is_Active__c,Cluster_Brand__c 
                                   from Territory__c];
        System.debug('+++++++lst ++++'+lst );
      test.stopTest();
        
    }
    public static testMethod void DirectAssignment2(){
        
        
         test.startTest();
        Showroom_User__c objShowroom1= TestData_Factory.createShowroomUser(false);
        objShowroom1.Threashold__c = 10;
        objShowroom1.Backlogs__c = 2;
        objShowroom1.Daily_Assignment__c = 10;
        objShowroom1.Daily_Assignment_Limit__c = 10;
        objShowroom1.IsActive__c = true; 
        objShowroom1.Monthly_Assignment__c = 0;
        objShowroom1.Monthly_Assignment_Limit__c = 100;
        objShowroom1.Role__c ='Iron Man';
        objShowroom1.Outskirts_Assignment__c=1;
        //
        objShowroom1.Outskirts_Assignment_Limit__c=3;
        objShowroom1.IM_Class__c= 'Silver';
        
        insert ObjShowroom1;
        
         Showroom =TestData_Factory.CreateShowRoom(false);
        Showroom.Luxe_service__c =True;
        showroom.Property_City__c ='Bengaluru';
        insert showroom;
        
        Showroom_User__c objShowroom2= TestData_Factory.createShowroomUser(false);
        objShowroom2.Email__c = 'TestSHowRoomasdUSer@test.com';
        objShowroom2.Threashold__c = 10;
        objShowroom2.Backlogs__c = 2;
        objShowroom2.Daily_Assignment__c = 4;
        objShowroom2.Daily_Assignment_Limit__c = 10;
        objShowroom2.IsActive__c = true;
        objShowroom2.Monthly_Assignment__c = 0;
        objShowroom2.Monthly_Assignment_Limit__c = 100;
        objShowroom2.Outskirts_Assignment__c=1;
        objShowroom2.Role__c='Iron Man';
        objShowroom2.Outskirts_Assignment_Limit__c=3;
        ObjShowroom2.IM_Class__c='Gold';
        ObjShowroom2.Showroom_Name__c =showroom.id;
        
        insert objShowroom2;
        
       
        Territory__c objTerr = TestData_Factory.createTerritory('Area a',ObjShowroom1.id,'Bengaluru','Cluster A','123456',False);
        objTerr.Lat_Long__Latitude__s = 20.0936477440000;
        objTerr.Lat_Long__Longitude__s =  89.7849897840000;
        objTerr.Cluster_Brand__c ='Homelane';
        
        Insert objTerr ;
        Account acc= new account();
        acc.name='luxe acc';
        insert acc;
        Lead ld= new Lead();
        ld.leadSource ='HomeLaneLuxeLeadForm';
        ld.postalcode='123456';
        ld.LastName='luxe';
        ld.City='Bengaluru';
        ld.Phone ='9790789089';
        ld.Email ='luse@gmail.com';
        ld.Account__c =acc.id;
        insert ld;
         test.stopTest();
    }
}