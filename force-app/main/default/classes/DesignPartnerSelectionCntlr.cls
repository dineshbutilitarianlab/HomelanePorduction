Public class DesignPartnerSelectionCntlr{
    public String strShowroomId{get;set;}
    public String strRecordId{get;set;}
    public String strDPId{get;set;}
    public string strRowId{get;set;}
    public String objectName{get;set;}
    public String recordName{get;set;}
    public String strSearchDP{get;set;}
    public String ErrorMsg{get;set;}
    public String strPropertyId{get;set;}
    public List<String> NoDataList{get;set;}
    public List<Interior_Designer__c> HLHCList{get;set;}
    public List<Interior_Designer__c> LLHCList{get;set;}
    public List<Interior_Designer__c> LLLCList{get;set;}
    public List<Interior_Designer__c> HLLCList{get;set;}
    public List<Interior_Designer__c> NJList{get;set;}
    public List<Interior_Designer__c> lstSerchData{get;set;}
    public Map<String,Interior_Designer__c> mapIDP;

     public DesignPartnerSelectionCntlr(){
       strShowroomId = ApexPages.currentPage().getParameters().get('id');
       strRecordId = ApexPages.currentPage().getParameters().get('recordId');
       objectName = ApexPages.currentPage().getParameters().get('objectName');
       recordName = ApexPages.currentPage().getParameters().get('name');
       strPropertyId = ApexPages.currentPage().getParameters().get('property');
       NoDataList = new List<String>();
       NoDataList.add('No DP exists for this category in this Showroom');
       mapIDP = new Map<String,Interior_Designer__c>();
       strRowId = '0';
       
     }
    
    
    public void getDesginPartnerData(){
        HLHCList = new List<Interior_Designer__c>();
        LLHCList = new List<Interior_Designer__c>();
        HLLCList = new List<Interior_Designer__c>();
        LLLCList = new List<Interior_Designer__c>();
        NJList = new List<Interior_Designer__c>();
        Map<String,boolean> mapOppPropertyEap = new Map<String,boolean>();
        
        
        try{
            Master__c masterObj = [Select Id,Name,Avg_Conversion__c,Avg_Opportunites_Month__c,Total_DP_With_Opportunity__c From Master__c Where Id =: strShowroomId Limit 1];
        if(masterObj.Name != null && masterObj.Name !=''){
            String strSearchText = masterObj.Name;
            system.debug('-----------strSearchText----------------'+strSearchText);
            system.debug('-----------list----------------'+[Select Id,Name,Available_at_Showroom__c,Avg_Opportunites_Month__c,Conversion__c,New_joinee__c from Interior_Designer__c Where Available_at_Showroom__c includes (: strSearchText)]);
            for(Interior_Designer__c objIDP : [Select Id,DP_position__c,Property_Exp_Data__c,Property_Exp__c,OverLoaded__c,Name,Email__c,Mobile__c,Available_at_Showroom__c,Avg_Opportunites_Month__c,Conversion__c,New_joinee__c from Interior_Designer__c Where Available_at_Showroom__c includes (: strSearchText) AND Active__c = true]){
                system.debug('-----------objIDP----------------'+objIDP);
                mapIDP.put(objIDP.Id,objIDP);
                if(objIDP.Property_Exp_Data__c != null && objIDP.Property_Exp_Data__c !=''){
                    List<String> lstProperty = objIDP.Property_Exp_Data__c.split(',');
                     for(String ObjProperty :lstProperty){
                        List<String> lstProp = ObjProperty.split('<@>');
                        Integer proprtyNumbr = Integer.valueof(lstProp[2]);
                        if(lstProp[0].contains(strPropertyId) &&  proprtyNumbr !=0)
                            objIDP.Property_Exp__c = true;

                     }
                }
                system.debug('-----------mapIDP----------------'+mapIDP);
               /* if(objIDP.Avg_Opportunites_Month__c > masterObj.Avg_Opportunites_Month__c && objIDP.Conversion__c >masterObj.Avg_Conversion__c){
                    HLHCList.add(objIDP);
                }else if(objIDP.Avg_Opportunites_Month__c < masterObj.Avg_Opportunites_Month__c && objIDP.Conversion__c <masterObj.Avg_Conversion__c){
                    LLLCList.add(objIDP);
                }else if(objIDP.Avg_Opportunites_Month__c < masterObj.Avg_Opportunites_Month__c && objIDP.Conversion__c >masterObj.Avg_Conversion__c){
                    LLHCList.add(objIDP);
                }else if(objIDP.Avg_Opportunites_Month__c > masterObj.Avg_Opportunites_Month__c && objIDP.Conversion__c <masterObj.Avg_Conversion__c){
                    HLLCList.add(objIDP);
                }else if(objIDP.New_joinee__c){
                    NJList.add(objIDP);
                }*/
                
                
            }
            HLHCList = [Select Id,DP_position__c,Property_Exp_Data__c,Property_Exp__c,OverLoaded__c,Name,Email__c,Mobile__c,Available_at_Showroom__c,Avg_Opportunites_Month__c,Conversion__c,New_joinee__c from Interior_Designer__c Where Available_at_Showroom__c includes (: strSearchText) AND Avg_Opportunites_Month__c >: masterObj.Avg_Opportunites_Month__c AND Conversion__c >: masterObj.Avg_Conversion__c AND Active__c = true Order By OverLoaded__c ASC];
            LLLCList =  [Select Id,DP_position__c,Property_Exp_Data__c,Property_Exp__c,OverLoaded__c,Name,Email__c,Mobile__c,Available_at_Showroom__c,Avg_Opportunites_Month__c,Conversion__c,New_joinee__c from Interior_Designer__c Where Available_at_Showroom__c includes (: strSearchText) AND Avg_Opportunites_Month__c <: masterObj.Avg_Opportunites_Month__c AND Conversion__c <: masterObj.Avg_Conversion__c AND Active__c = true Order By OverLoaded__c ASC];
            LLHCList =  [Select Id,DP_position__c,Property_Exp_Data__c,Property_Exp__c,OverLoaded__c,Name,Email__c,Mobile__c,Available_at_Showroom__c,Avg_Opportunites_Month__c,Conversion__c,New_joinee__c from Interior_Designer__c Where Available_at_Showroom__c includes (: strSearchText) AND Avg_Opportunites_Month__c <: masterObj.Avg_Opportunites_Month__c AND Conversion__c >: masterObj.Avg_Conversion__c AND Active__c = true Order By OverLoaded__c ASC];
            HLLCList =  [Select Id,DP_position__c,Property_Exp_Data__c,Property_Exp__c,OverLoaded__c,Name,Email__c,Mobile__c,Available_at_Showroom__c,Avg_Opportunites_Month__c,Conversion__c,New_joinee__c from Interior_Designer__c Where Available_at_Showroom__c includes (: strSearchText) AND Avg_Opportunites_Month__c >: masterObj.Avg_Opportunites_Month__c AND Conversion__c <: masterObj.Avg_Conversion__c AND Active__c = true Order By OverLoaded__c ASC];
            NJList =  [Select Id,DP_position__c,Property_Exp_Data__c,Property_Exp__c,OverLoaded__c,Name,Email__c,Mobile__c,Available_at_Showroom__c,Avg_Opportunites_Month__c,Conversion__c,New_joinee__c from Interior_Designer__c Where Available_at_Showroom__c includes (: strSearchText) AND New_joinee__c = true Order By OverLoaded__c ASC];

           
           HLHCList = SortListData(HLHCList,mapIDP);
           LLHCList = SortListData(LLHCList,mapIDP);
           LLLCList = SortListData(LLLCList,mapIDP);
           NJList = SortListData(NJList,mapIDP);
           HLLCList = SortListData(HLLCList,mapIDP);
            system.debug('-----------HLHCList----------------'+HLHCList);
            system.debug('-----------LLLCList----------------'+LLLCList);
            system.debug('-----------LLHCList----------------'+LLHCList);
            system.debug('-----------HLLCList----------------'+HLLCList);
            system.debug('-----------NJList----------------'+NJList);
        }
        }catch(exception exp){
           ErrorMsg = 'Some Exception occured,Please try again.';
            system.debug('-----------exp----------------'+exp.getMessage());
       }    
    }

    public List<Interior_Designer__c> SortListData(List<Interior_Designer__c> listOPP,Map<String,Interior_Designer__c> mapDP){
         for(Integer i=0;i<listOPP.size()-1;i++){
                listOPP[i].Property_Exp__c = mapDP.get(listOPP[i].Id).Property_Exp__c;
                if(listOPP[i].OverLoaded__c == false && mapDP.get(listOPP[i].Id).Property_Exp__c ==true){
                      Integer lengthList = listOPP.Size();
                      Interior_Designer__c oppTemp = listOPP[0];
                      listOPP[0] = listOPP[i];
                      listOPP[i] = oppTemp;
                 }
                 if(listOPP[i].OverLoaded__c == true && mapDP.get(listOPP[i].Id).Property_Exp__c ==false){
                      Integer lengthList = listOPP.Size();
                      Interior_Designer__c oppTemp = listOPP[lengthList-1];
                      listOPP[lengthList-1] = listOPP[i];
                      listOPP[i] = oppTemp;
                 }  
             }

             return SortListDataOverLoaded(listOPP,mapDP);
    }
     public List<Interior_Designer__c> SortListDataOverLoaded(List<Interior_Designer__c> listPropOPP,Map<String,Interior_Designer__c> mapDPs){
         for(Integer i=listPropOPP.size()-1;i>=0;i--){
                listPropOPP[i].Property_Exp__c = mapDPs.get(listPropOPP[i].Id).Property_Exp__c;
                 if(listPropOPP[i].OverLoaded__c == true && mapDPs.get(listPropOPP[i].Id).Property_Exp__c ==true && listPropOPP[i-1].OverLoaded__c == true){
                      Integer lengthList = listPropOPP.Size();
                      Interior_Designer__c oppTemp = listPropOPP[lengthList-1];
                      listPropOPP[i-1] = listPropOPP[i];
                      listPropOPP[i] = oppTemp;
                 } 
               }
                
             return listPropOPP;
    }
    
    public void GetSearchData(){
        lstSerchData = new List<Interior_Designer__c>();
        if(strSearchDP !=null && strSearchDP !=''){
            String searchString = '%'+strSearchDP+'%';
            for(Interior_Designer__c obj : [Select Id,DP_position__c,Property_Exp_Data__c,Property_Exp__c,OverLoaded__c,Name,Email__c,Mobile__c,Available_at_Showroom__c,Avg_Opportunites_Month__c,Conversion__c,New_joinee__c from Interior_Designer__c Where Name Like :searchString AND Active__c = true]){
                mapIDP.put(obj.Id,obj);
                if(obj.Property_Exp_Data__c != null && obj.Property_Exp_Data__c !=''){
                    List<String> lstProperty = obj.Property_Exp_Data__c.split(',');
                     for(String ObjProperty :lstProperty){
                        List<String> lstProp = ObjProperty.split('<@>');
                        Integer proprtyNumbr = Integer.valueof(lstProp[2]);
                        if(lstProp[0].contains(strPropertyId) &&  proprtyNumbr !=0)
                            obj.Property_Exp__c = true;
                     }
                }
                lstSerchData.add(obj);
            }
        }
         system.debug('-----------lstSerchData----------------'+lstSerchData);
    }
    
    public Pagereference updateDesignPartner(){
        try{
        if(strRecordId != null && strRecordId !='' && strDPId != null && strDPId != ''){
            if(objectName == 'Lead'){
                Lead objLead = new Lead();
                objLead.Id = strRecordId;
                objLead.Interior_Designer__c = strDPId;
                objLead.DP_Position__c = strRowId;
                update objLead;
            }else if(objectName == 'Opportunity'){
                Opportunity objOpp = new Opportunity();
                objOpp.Id = strRecordId;
                objOpp.Interior_Design_Partner__c = strDPId;
                objOpp.DP_Position__c = strRowId;
                update objOpp;
            }
            /*if(mapIDP.get(strDPId) != null){
                Interior_Designer__c objDP = new Interior_Designer__c();
                objDP.id = strDPId;
                objDP.DP_position__c =1;
                if(mapIDP.get(strDPId).DP_position__c != 0 && mapIDP.get(strDPId).DP_position__c != null)
                    objDP.DP_position__c = mapIDP.get(strDPId).DP_position__c+1;
                update objDP;
            }*/
            Pagereference objPage = new Pagereference('/'+strRecordId);
            return objPage;
        }else{
            ErrorMsg = 'Something went worng,Please try again.';
            return null;
        }
        }catch(exception exp){
            ErrorMsg = 'Some Exception occured,Please try again.';
            system.debug('-----------expupdateDesignPartner----------------'+exp.getMessage());
            return null;
        }
    }


}