public class MassEditGlobalController {
    public Opportunity Opp{get;set;}
    public List<Opportunity> OpportunityList {get;set;}
    // create a list of strings to hold the conditions
    List<string> conditions = new List<string>();
    private integer totalRecs = 0;
    private integer OffsetSize = 0;
    private integer LimitSize= 150;
    public string OppNumber{set;get;}
    public String OppName{set;get;}
    public boolean AllSelect{set;get;}
    public boolean indiselect{set;get;}
    public MassEditGlobalController(ApexPages.StandardSetController contr){
        system.debug('==>AccountMultipleSearchWithPagenationCLS  is calling==>');
        Opp = new Opportunity();
        searchAcc();
        //accountList  = new List<Account>();
    }
    
    public void searchAcc(){
        totalRecs = 0;
        OffsetSize = 0;
        if(OpportunityList !=null && OpportunityList.size()>0){
            OpportunityList=null;
        }
        searchOpps ();
        conditions.clear();
    }
    
    
    public Void searchOpps(){
        
        System.debug('Total Records is ==>'+totalRecs);
        System.debug('OffsetSize is ==>'+OffsetSize);
        System.debug('OppName ==>'+OppName);
        System.debug('OppNumber ==>'+OppNumber);
        System.debug('Opp.Appointment_Venue_Square__c ==>'+Opp.Appointment_Venue_Square__c);
        
        if(OpportunityList != null && !OpportunityList.isEmpty()){
            OpportunityList.clear();
        }
        String strQuery ='SELECT Id,Name,Account.phone,Select_Update__c ,Customer_Phone_Number__c,Customer_Email__c,LeadSource,Property_Name__c,Property_Config__c,Time_of_Actual_Appointment_Start__c,Customer_ID__c,Appointment_Venue_Square__c,Appointment_Type__c,Interior_Design_Partner__c,Property_Move_In_Date__c,Quote_Link__c,Quote_Sent_Time__c,Last_Open_Time__c,amount,Total_Quote_Views__c,Count_of_Quotes_Sent__c,DescriptionCopy__c,No_of_Meetings_Done__c,Meeting_Stage__c,Order_Book_Date__c,Second_Meeting_Time__c From Opportunity'; 
        if(OppName !=null && OppName !=''){
            conditions.add('Name Like \'%' +OppName +'%\' ');
        }
        if(OppNumber !=null && OppNumber !=''){
            conditions.add('Customer_Phone_Number__c Like\'%' +OppNumber.trim() +'%\' ');
        }
        if(Opp.Appointment_Venue_Square__c!=null)
        {
            conditions.add('Appointment_Venue_Square__c = \''+Opp.Appointment_Venue_Square__c+'\'');
        }
        if (conditions.size() > 0) {
            strQuery += '  WHERE ' + conditions[0];
            for (Integer i = 1; i < conditions.size(); i++)
                strQuery += '  AND ' + conditions[i];
        }
        System.debug('strQuery query before total rec--> '+strQuery);
        if(totalRecs !=null && totalRecs ==0){
            List<Opportunity> accTemp = Database.query(strQuery);
            totalRecs = (accTemp !=null &&accTemp.size()>0)?accTemp.size():0;
        }
        system.debug('strQuery ==>'+strQuery );
        // add sort and limits at the end  
        if(!test.isRunningTest())
        strQuery += ' ORDER BY Name  ASC, CreatedDate DESC LIMIT :LimitSize OFFSET :OffsetSize';
        
        OpportunityList  =Database.query(strQuery);
        
        
        
        //conditions.clear();
        //return accountList.size();
    }
    
    public void FirstPage()
    {
        OffsetSize = 0;
        searchOpps();
    }
    public void previous()
    {
        OffsetSize = (OffsetSize-LimitSize);
        searchOpps();
    }
    public void next()
    {
        OffsetSize = OffsetSize + LimitSize;
        searchOpps();
    }
    public void LastPage()
    {
        OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
        searchOpps();
    }
    public boolean getprev()
    {
        
        if(OffsetSize == 0){
            
            return true;
        }
        else {
            
            return false;
        }
    }
    public boolean getnxt()
    {
        if((OffsetSize + LimitSize) > totalRecs){
            
            return true;
        }
        else {
            
            return false;
        }
    }
    public void saveRec()
    {
        List<Opportunity> oplst = new List<Opportunity>();
        for(Opportunity op : OpportunityList)
        {
            if(op.Select_Update__c==true)
            { 
              op.Select_Update__c = false;
              oplst.add(op);
            }
        }
        System.debug('oplst --> '+oplst);
        if(!oplst.isEmpty())
            update oplst;
    }
}