public class OpportunitySharingHandler {

    Public static String subject = null;
    Public static String emailContent = null;
    Public static String toEmailIds = null;
    
    
     Public static void WorksContractSignOff(List<Opportunity> OpportunityrecordList, Map<Id,Opportunity> oldOpportunityMap) {
        for (Opportunity opp: OpportunityrecordList) {
            system.debug('----opp-----'+opp.Parent_Opportunity__c);
            if((opp.Works_Contract_Sign_Off_Done__c != oldOpportunityMap.get(opp.Id).Works_Contract_Sign_Off_Done__c && opp.Works_Contract_Sign_Off_Done__c != false) || (opp.Works_Contract_Sign_Off_Date__c != oldOpportunityMap.get(opp.Id).Works_Contract_Sign_Off_Date__c) && opp.Works_Contract_Sign_Off_Date__c != null){
               System.debug('********** OPP1 '+opp.Customer_Email__c);
               WorksContractEmailController objWC = new WorksContractEmailController();
               objWC.oppId = opp.Id;
               objWC.SendWorksContact();
           //    SendFeedBackToRoasterAPI.SendToRoaster(opp.Customer_Email__c);
               System.debug('********** OPP2 '+opp.Customer_Email__c);
                              
            }
         } 
        }
    
 Public static void validateParentOpportunity(List<Opportunity> OpportunityrecordList, Map<Id,Opportunity> oldOpportunityMap) {
    Map<String,String> mapCustomerIds = new Map<String,String>();
    Map<String,String> mapOpportunityError = new Map<String,String>();
    Map<String,Opportunity> mapOpportunityParent = new Map<String,Opportunity>();
    Map<String,Opportunity> mapOpportunityData = new Map<String,Opportunity>();
    for (Opportunity opp: OpportunityrecordList) {
        system.debug('----opp-----'+opp.Parent_Opportunity__c);
        if((opp.Parent_Opportunity__c != oldOpportunityMap.get(opp.Id).Parent_Opportunity__c) && opp.Parent_Opportunity__c != null){
            mapCustomerIds.put(opp.Parent_Opportunity__c,opp.Id);
            mapCustomerIds.put(opp.Customer_ID__c,opp.Id);
        }
    } 
    system.debug('----mapCustomerIds-----'+mapCustomerIds);
 if(mapCustomerIds.size() >0){
   for(Opportunity objOpp : [Select Id,Parent_Opportunity__c,Customer_ID__c From Opportunity Where Customer_ID__c IN : mapCustomerIds.keyset() OR Parent_Opportunity__c IN : mapCustomerIds.keyset()]){
     if(objOpp.Parent_Opportunity__c != '' && objOpp.Parent_Opportunity__c != null){ 
         mapOpportunityError.put(objOpp.Customer_ID__c,'Opportunity is already has child.'); 
         mapOpportunityParent.put(objOpp.Parent_Opportunity__c,objOpp); 
     }
     mapOpportunityData.put(objOpp.Customer_ID__c,objOpp);
   }
    system.debug('----mapOpportunityError-----'+mapOpportunityError);
    system.debug('----mapOpportunityParent-----'+mapOpportunityParent);
    system.debug('----mapOpportunityData-----'+mapOpportunityData);
       for (Opportunity oppRec: OpportunityrecordList) {
        system.debug('----oppRec-----'+oppRec);
             if(mapOpportunityParent.get(oppRec.Customer_ID__c) != null){
                 oppRec.addError('You can not make Parent Opportunity to Child Opportunity in other Opportunity');
             }else if(mapOpportunityError.get(oppRec.Parent_Opportunity__c) != null){
                oppRec.addError(mapOpportunityError.get(oppRec.Parent_Opportunity__c));

             }else if(mapOpportunityError.get(oppRec.Customer_ID__c) != null){
                oppRec.addError(mapOpportunityError.get(oppRec.Customer_ID__c));

             }else if(mapOpportunityData.get(oppRec.Parent_Opportunity__c) == null){
                oppRec.addError('Parent Opportunity is not valid or Parent Opportunity with this Customer is not Exists.');
             }else  if(oppRec.Customer_ID__c == oppRec.Parent_Opportunity__c)
                    oppRec.addError('You cann\'t put same opportunity in Parent.');
      
        } 
}


 }     
    

    public static void manualShareRead(map < id, Opportunity > newlist, map < id, Opportunity > oldlist) {
        Set<id> setDesignerId = new Set<Id>();
         for (Opportunity opp : newlist.values()) {
             setDesignerId.add(opp.Design_Partner__c); 
             setDesignerId.add(opp.Internal_Buddy__c);
         }
         Map<Id,User> mapUserInfo = new Map<Id,User>();
         if(setDesignerId.size() !=0)
         mapUserInfo = new Map<Id,User>([Select Id,IsActive,Email,UserName from User where Id IN :setDesignerId AND IsActive = true]);
        List < OpportunityShare > OppShrLst = new List < OpportunityShare > ();

        for (Opportunity l: newlist.values()) {
            if (oldlist == null) {
                if (l.Design_Partner__c != null && mapUserInfo.get(l.Design_Partner__c) != null) { //Roaster Change

                    OppShrLst.add(shareRecord(l, l.Design_Partner__c));
                    system.debug('--------change dp-----------');

                }
                if (l.Square_Showroom_Agent__c != null) {
                    system.debug('--------ssa null-----------');
                    OppShrLst.add(shareRecord(l, l.Square_Showroom_Agent__c));
                }
                if (l.Square_Showroom_Manager__c != null) {
                    OppShrLst.add(shareRecord(l, l.Square_Showroom_Manager__c));
                }
                if (l.Welcome_Team_Agent__c != null) {
                    OppShrLst.add(shareRecord(l, l.Welcome_Team_Agent__c));
                }
                   
                  /* if (l.Internal_Buddy__c != null) {
                    OppShrLst.add(shareRecord(l, l.Internal_Buddy__c));
                }*/
                if (l.Square_Showroom_Manager__c!= null) {
                    OppShrLst.add(shareRecord(l, l.Square_Showroom_Manager__c));
                 }


            } else {
                if (l.Design_Partner__c != oldlist.get(l.Id).Design_Partner__c && mapUserInfo.get(l.Design_Partner__c) != null) { //Roaster Change
                    system.debug('--------change dp-----------');
                    OppShrLst.add(shareRecord(l, l.Design_Partner__c));
                }
                if (l.Square_Showroom_Agent__c != oldlist.get(l.Id).Square_Showroom_Agent__c) {
                    OppShrLst.add(shareRecord(l, l.Square_Showroom_Agent__c));
                }
                if (l.Square_Showroom_Manager__c != oldlist.get(l.Id).Square_Showroom_Manager__c) {
                    OppShrLst.add(shareRecord(l, l.Square_Showroom_Manager__c));
                }
                if (l.Welcome_Team_Agent__c != null) {
                    OppShrLst.add(shareRecord(l, l.Welcome_Team_Agent__c));
                }
                if (l.CSR__c != oldlist.get(l.Id).CSR__c && l.StageName == 'D3 Initiated') {
                    OppShrLst.add(shareRecord(l, l.CSR__c));
                    system.debug('*** CSR' + l.CSR__c);
                }
                if (l.Planning_Manager__c != oldlist.get(l.Id).Planning_Manager__c && l.StageName == 'D3 Initiated') {
                    OppShrLst.add(shareRecord(l, l.Planning_Manager__c));
                    system.debug('*** Planning Manager' + l.Planning_Manager__c);

                }
                
   /***************************************************************************************************************/
     // Added by Venkat
     
     if(((l.StageName == 'D3 Initiated' &&  l.Sub_Status__c == 'Project sent to production' ) ||
         l.StageName == 'Project Plan & Estimates Publish' ||
         l.StageName == 'Production Initiated & Order Placed' ||
         l.StageName == 'Production & Procurement Complete' ) && mapUserInfo.get(l.Design_Partner__c) != null){
         
          OppShrLst.add(shareRecordread(l, l.Design_Partner__c)); //Roaster Change
      }
      
       if(l.StageName == 'Install Team Assigned,Material Dispatche' ||
         l.StageName == 'Material Received' ||
         l.StageName == 'Installation Started'){
         
          OppShrLst.add(shareRecordread(l, l.Planning_Manager__c));
      }
      
      if(l.StageName == 'D4 Initiated' &&  
          (l.Sub_Status__c == 'Installation Meeting Proposed'  ||
          l.Sub_Status__c == 'Installation Meeting Confirmed')){
         
          OppShrLst.add(shareRecordread(l, l.CSR__c));
      }
      
      if((l.StageName == 'D4 Initiated' && ( l.Sub_Status__c == 'Meeting for Installation Completed'  || l.Sub_Status__c == 'Installation Completed')) ||
          l.StageName == 'Snaglist Rectification Completed' ||
          l.StageName == 'Snaglist Rectification Completed' ||
          l.StageName == 'Project Sign Off' ||
          l.StageName == 'Installation Completed'){
         
          OppShrLst.add(shareRecordread(l, l.PM__c));
      }
      if (l.PM__c==NULL && l.Event_Created_D1__c==true&& l.StageName =='D1 Initiated') {
                    Id userId = [select id, name from Group where name = 'Pm Group'
                        limit 1
                    ].id;
                    List < GroupMember > PMGroupList = [SELECT UserOrGroupId FROM GroupMember where UserOrGroupId !=: l.PM__c AND GroupId =: userId];
                    System.debug('PMGroupList******* ' + PMGroupList);
                    if (PMGroupList.size() > 0) {
                        for (GroupMember obj: PMGroupList) {
                            OppShrLst.add(shareRecord(l, obj.UserOrGroupId));
                        }
                    }
                    if(mapUserInfo.get(l.Design_Partner__c) != null )
                        OppShrLst.add(shareRecordread(l, l.Design_Partner__c)); //Roaster Change
                    if(mapUserInfo.get(l.Internal_Buddy__c) != null)
                        OppShrLst.add(shareRecordread(l, l.Internal_Buddy__c));
                    OppShrLst.add(shareRecordread(l, l.Square_Showroom_Manager__c));
                    OppShrLst.add(shareRecordread(l, l.Square_Showroom_Agent__c));
                       
                    //System.debug('OppShrLstPPPPPPMMMM' + OppShrLst);

                }
                
                if ((l.PM__c!=NULL || l.PM__c != oldlist.get(l.Id).PM__c) && l.Sub_Status__c =='Site Measurement Proposed') {
                    Id userId = [select id, name from Group where name = 'Pm Group'
                        limit 1
                    ].id;
                    List < GroupMember > PMGroupList = [SELECT UserOrGroupId FROM GroupMember where UserOrGroupId !=: l.PM__c AND GroupId =: userId];
                    System.debug('PMGroupList*****444444444***** ' + PMGroupList);
                    if (PMGroupList.size() > 0) {
                        for (GroupMember obj: PMGroupList) {
                            OppShrLst.add(shareRecordread(l, obj.UserOrGroupId));
                        }
                    }
                     OppShrLst.add(shareRecord(l, l.PM__c));

                }

                if ((l.SMM__c ==NULL && l.Event_Created_D1__c==true)&& l.StageName =='D1 Initiated') {
                    Id userId = [select id, name from Group where name = 'SMM Group'
                        limit 1
                    ].id;
                    List < GroupMember > SMMGroupList = [SELECT UserOrGroupId FROM GroupMember where UserOrGroupId !=: l.SMM__c AND GroupId =: userId];
                    if (SMMGroupList.size() > 0) {
                        for (GroupMember obj: SMMGroupList) {
                            OppShrLst.add(shareRecord(l, obj.UserOrGroupId));
                            System.debug('obj.UserOrGroupId' + obj.UserOrGroupId);
                        }
                    }
                   if(mapUserInfo.get(l.Design_Partner__c) != null )
                        OppShrLst.add(shareRecordread(l, l.Design_Partner__c)); //Roaster Change
                    if(mapUserInfo.get(l.Internal_Buddy__c) != null)
                        OppShrLst.add(shareRecordread(l, l.Internal_Buddy__c));
                    OppShrLst.add(shareRecordread(l, l.Square_Showroom_Manager__c));
                    OppShrLst.add(shareRecordread(l, l.Square_Showroom_Agent__c));
                   
                    
                }
                
                 if ((l.SMM__c !=NULL || l.SMM__c != oldlist.get(l.Id).SMM__c ) && l.Sub_Status__c =='Site Measurement Proposed'){
                    Id userId = [select id, name from Group where name = 'SMM Group'
                        limit 1
                    ].id;
                    List < GroupMember > SMMGroupList = [SELECT UserOrGroupId FROM GroupMember where UserOrGroupId !=: l.SMM__c AND GroupId =: userId];
                    if (SMMGroupList.size() > 0) {
                        for (GroupMember obj: SMMGroupList) {
                            OppShrLst.add(shareRecordread(l, obj.UserOrGroupId));
                            System.debug('obj.UserOrGroupId' + obj.UserOrGroupId);
                        }
                    }
                    OppShrLst.add(shareRecord(l, l.SMM__c));


                }


                if ((l.Internal_Buddy__c!=NULL ||l.Internal_Buddy__c != oldlist.get(l.Id).Internal_Buddy__c) && mapUserInfo.get(l.Internal_Buddy__c) != null) {
                    OppShrLst.add(shareRecord(l, l.Internal_Buddy__c));
                }
                if ((l.ownerid == l.SMM__c && l.Sub_Status__c == 'Site Measurement Completed') && mapUserInfo.get(l.Design_Partner__c) != null) {
                    OppShrLst.add(shareRecordread(l, l.Design_Partner__c)); //Roaster Change
                }

                //if (l.ownerid == l.Design_Partner__c && l.Sub_Status__c != 'Site Measurement Completed') { //Roaster Change
                  if (l.Sub_Status__c != 'Site Measurement Completed' && l.SMM__c !=null) {                 
                     system.debug('--------change dp-----------' + l.SMM__c);
                     OppShrLst.add(shareRecordread(l, l.SMM__c));
                }
                
                if (l.Square_Showroom_Manager__c!= oldlist.get(l.Id).Square_Showroom_Manager__c) {
                    OppShrLst.add(shareRecord(l, l.Square_Showroom_Manager__c));
                }
            }
        }

        System.debug('OppShrLstPPPPPPMMMM' + OppShrLst);
        Database.SaveResult[] OppShareInsertResult = Database.insert(OppShrLst, false);
    }


    /*********************************************************************************************/

    // To share Oppty Records For Finance Users- Added By Venkat 
    List < OpportunityShare > OppShrLst = new List < OpportunityShare > ();

    Public Static void opptyShareToFinanceUsers(List < Opportunity > newOpptyList) {
        
        List < OpportunityShare > OpptyFinanceShareList = new List < OpportunityShare > ();
        List < Group > FinanceGroupList = [select id, name from Group where name = 'Finance Group'];
        system.debug(' FinanceGroupList *** ' + FinanceGroupList);
        system.debug(' FinanceGroupListSIZE *** ' + FinanceGroupList.size());
        for (Opportunity oppty: newOpptyList) {
            OpptyFinanceShareList.add(shareRecord(oppty, FinanceGroupList[0].id));

        }

        Database.SaveResult[] OppShareInsertResult = Database.insert(OpptyFinanceShareList, false);

    }

    /**********************************************************************************************/


    /*********************************************************************************************/

    // To share Oppty Records For SMM and PM Group-Roshi
    List < OpportunityShare > OppShrLst1 = new List < OpportunityShare > ();
    map < id, Event > eventuser = new map < id, Event > ();

    /*Public Static void opptyShareToGroupuser(List < Opportunity > newOpptyList) {

        List < OpportunityShare > OpptyPmShareList = new List < OpportunityShare > ();
        List < OpportunityShare > OpptyPmShareList1 = new List < OpportunityShare > ();
        List < Group > PMGroupList = [select id, name from Group where name = 'Pm Group'];
        List < Group > SmmGroupList = [select id, name from Group where name = 'SMM Group'];

        System.debug('PMGroupListPMGroupList' + PMGroupList);
        System.debug('SmmGroupList ' + SmmGroupList);

        for (Opportunity oppty: newOpptyList) {
            //if(oppty.Event_Created_D1__c==true && oppty.PM__c==NULL)
            if (oppty.PM__c == NULL) {
                OpptyPmShareList.add(shareRecord(oppty, PMGroupList[0].id));
            }
            if (oppty.SMM__c == NULL) {
                OpptyPmShareList1.add(shareRecord(oppty, SmmGroupList[0].id));
            }

        }

        System.debug('OpptyPmShareListOpptyPmShareList  ' + OpptyPmShareList);
        Database.SaveResult[] OppShareInsertResult = Database.insert(OpptyPmShareList, false);
        Database.SaveResult[] OppShareInsertResult1 = Database.insert(OpptyPmShareList1, false);

    }
    */
    /**********************************************************************************************/

    private static OpportunityShare shareRecord(Opportunity l, Id UserOrGroupId) {
        OpportunityShare oppShr = new OpportunityShare();
        oppShr.OpportunityId = l.Id;
        oppShr.UserOrGroupId = UserOrGroupId;
        oppShr.OpportunityAccessLevel = 'Edit';
        oppShr.RowCause = Schema.OpportunityShare.RowCause.Manual;

        return oppShr;
    }


    private static OpportunityShare shareRecordread(Opportunity l, Id UserOrGroupId) {
        OpportunityShare oppShr = new OpportunityShare();
        oppShr.OpportunityId = l.Id;
        oppShr.UserOrGroupId = UserOrGroupId;
        oppShr.OpportunityAccessLevel = 'Read';
        oppShr.RowCause = Schema.OpportunityShare.RowCause.Manual;
        return oppShr;
    }


    /**********************************************************************************************************/

 
    // When Oppty Status Changes to 10% Payment Received, Payment Mile Stone is created with the 10% of the Oppty Amount 
    // When Oppty Status Changes to D3 Initiated AND Sub-Status Changes to 40% Payment Received, Payment Mile Stone is created with the 40% of the Oppty Amount

   /* public static void createbillrecord(List < Opportunity > newOpptyList, Map < Id, Opportunity > oldOpptyMap) {

        Map < Id, Opportunity > opportunityMap = new Map < Id, Opportunity > ();
        List < Customer_Bill__c > customerBillList = new List < Customer_Bill__c > ();
        for (Opportunity oppty: newOpptyList) {
            system.debug(' ** oppty ' + oppty + ' oppty.Sub_Status__c ' + oppty.Sub_Status__c + '  oppty.Amount ' + oppty.Amount);
            if ((oppty.StageName != oldOpptyMap.get(oppty.id).StageName && oppty.StageName == 'Initial Quote Approved' && oppty.Amount != null) ||
                (oppty.Sub_Status__c != oldOpptyMap.get(oppty.id).Sub_Status__c && oppty.StageName == 'D3 Initiated' && oppty.Sub_Status__c == 'Final Drawings, Quote & Works Contract Approved' && oppty.Amount != null) ||
                (oppty.StageName != oldOpptyMap.get(oppty.id).StageName && oppty.StageName == 'Production & Procurement Complete' && oppty.Amount != null) ||
                (oppty.StageName != oldOpptyMap.get(oppty.id).StageName && oppty.StageName == 'Snaglist Rectification Completed' && oppty.Amount != null)) {
                opportunityMap.put(oppty.id, oppty);
            }
        }
        system.debug(' opportunityMap *** ' + opportunityMap);

        List < Quote > quoteList = [select id, name, version__c, OpportunityId from Quote where OpportunityId IN: opportunityMap.KeySet() order by createddate desc];
        // List < Customer_Bill__c > paymentmilestoneListwithpaidamounts = [select id, name, Amount_Received__c, Opportunity__c from Customer_Bill__c where Opportunity__c IN: opportunityMap.KeySet() order by Opportunity__c desc];

        Map < Id, Decimal > opptyQuoteVersionMap = new Map < Id, Decimal > ();
        for (Quote quoterec: quoteList) {
            if (!opptyQuoteVersionMap.ContainsKey(quoterec.OpportunityId)) {
                opptyQuoteVersionMap.put(quoterec.OpportunityId, quoterec.version__c);
            }
        }

        /*  Map < Id, Decimal > amountpaidtill50percentage = new Map < Id, Decimal > ();
          Decimal FinalValue = 0;
          for (Customer_Bill__c paymentmilestonerec: paymentmilestoneListwithpaidamounts) {
              if (amountpaidtill50percentage.ContainsKey(paymentmilestonerec.Opportunity__c)) {
                  FinalValue = amountpaidtill50percentage.get(paymentmilestonerec.Opportunity__c);
                  FinalValue = paymentmilestonerec.Amount_Received__c + FinalValue;
                  amountpaidtill50percentage.put(paymentmilestonerec.Opportunity__c, FinalValue);
              } else {
                  amountpaidtill50percentage.put(paymentmilestonerec.Opportunity__c, paymentmilestonerec.Amount_Received__c);
              }
          }  */


     /*----   Customer_Bill__c customerBillrecord;
        for (Opportunity opptyrecord: opportunityMap.values()) {

                system.debug('*** DP IS '+opptyrecord.Design_Partner__c);

            if (opptyrecord.StageName == 'Initial Quote Approved') {
                customerBillrecord = new Customer_Bill__c();
                Decimal bal = opptyrecord.Amount * 0.1;
                customerBillrecord = createpaymentrecord(bal, opptyrecord, opptyrecord.Amount);
                customerBillrecord.Bill_Status__c = '10% Payment Received';
                customerBillrecord.Design_Partner__c = opptyrecord.Design_Partner__c; //Roaster Change
                customerBillrecord.Quote_Version__c = opptyQuoteVersionMap.get(opptyrecord.id);
                customerBillrecord.Customer_Email__c = opptyrecord.Customer_Email__c;
                customerBillList.add(customerBillrecord);
            } else if (opptyrecord.StageName == 'D3 Initiated' && opptyrecord.Sub_Status__c == 'Final Drawings, Quote & Works Contract Approved') {
                customerBillrecord = new Customer_Bill__c();
                //Decimal bal = ((opptyrecord.Amount * 0.5) - (opptyrecord.Total_Amount_Paid_By_the_Customer__c));
                Decimal bal = ((opptyrecord.Amount - opptyrecord.Total_Amount_Paid_By_the_Customer__c) *0.5 );
                
                customerBillrecord = createpaymentrecord(bal, opptyrecord, opptyrecord.Amount);
                customerBillrecord.Bill_Status__c = '40% Payment Received';
                customerBillrecord.Design_Partner__c = opptyrecord.Design_Partner__c; //Roaster Change
                customerBillrecord.Quote_Version__c = opptyQuoteVersionMap.get(opptyrecord.id);
                customerBillrecord.Customer_Email__c = opptyrecord.Customer_Email__c;
                customerBillList.add(customerBillrecord);
            } else if (opptyrecord.StageName == 'Production & Procurement Complete') {
                customerBillrecord = new Customer_Bill__c();
                /*Decimal bal = amountpaidtill50percentage.get(opptyrecord.id);
                bal = opptyrecord.Amount - bal;*/
        /*---   Decimal bal = ( opptyrecord.Amount - (opptyrecord.Total_Amount_Paid_By_the_Customer__c));
                customerBillrecord = createpaymentrecord(bal, opptyrecord, opptyrecord.Amount);
                customerBillrecord.Bill_Status__c = '50% Payment Received';
                customerBillrecord.Design_Partner__c = opptyrecord.Design_Partner__c; //Roaster Change
                customerBillrecord.Quote_Version__c = opptyQuoteVersionMap.get(opptyrecord.id);
                customerBillrecord.Customer_Email__c = opptyrecord.Customer_Email__c;
                customerBillList.add(customerBillrecord);
            }else if(opptyrecord.StageName == 'Snaglist Rectification Completed'){
                Decimal bal = opptyrecord.Total_Outstanding_Balance__c ;
                customerBillrecord = createpaymentrecord(bal, opptyrecord, opptyrecord.Amount);
                customerBillrecord.Bill_Status__c = 'Full and Final Settlement Received';
                customerBillrecord.Design_Partner__c = opptyrecord.Design_Partner__c; //Roaster Change
                customerBillrecord.Quote_Version__c = opptyQuoteVersionMap.get(opptyrecord.id);
                customerBillrecord.Customer_Email__c = opptyrecord.Customer_Email__c;
                customerBillList.add(customerBillrecord);
            }

        }

        system.debug(' customerBillList ***** ' + customerBillList);
        if (!customerBillList.isEmpty()) {
            try {
                insert customerBillList;
            } catch (DMLException dmlEx) {
                system.debug('*** Failed to create Payment Milestone records due to - ' + dmlEx);
            }
        }
    }


    public static Customer_Bill__c createpaymentrecord(Decimal amounttobepaid, Opportunity oppty, Decimal Amount) {
        Customer_Bill__c Billrecord = new Customer_Bill__c();
        Billrecord.Amount_to_be_paid__c = amounttobepaid;
        Billrecord.Opportunity__c = oppty.id;
        Billrecord.Quote_Value__c = Amount;

        return Billrecord;
    }*/



    /************************************************************************************************************************************/
    //Update Customer_Email__c on opportunity from Account.

    Public static void updateCustomerEmail(map < id, Opportunity > opplist, map < id, Opportunity > opplistold) {
        map < id, Account > accountmap = new map < id, Account > ();
        map < id, Opportunity > oppmap = new map < id, Opportunity > ();
        Set < Id > actid = new Set < Id > ();
        List < Opportunity > updateopp = new List < Opportunity > ();
        List <String> newcustomeremail = new List<String>();
        List <String> oldcustomeremail = new List<String>();

        for (Opportunity opp: opplist.values()) {
            if (opplistold == NULL) {
                if (opp.AccountId != NULL) {
                    oppmap.put(opp.AccountId, opp);

                }
            } else if (opp.AccountId != opplistold.get(opp.Id).AccountId) {
                
                oppmap.put(opp.AccountId, opp);

            }
            else if (opplistold != NULL){
              if(opp.Customer_Email__c != opplistold.get(opp.Id).Customer_Email__c){
                newcustomeremail.add(opp.Customer_Email__c);
                oldcustomeremail.add(opplistold.get(opp.Id).Customer_Email__c);
                }
            }
        }
        if(!oppmap.isEmpty()){
            for (Account actobj: [SELECT id, PersonEmail from Account Where id In: oppmap.keyset()]) {
                accountmap.put(actobj.id, actobj);
            }
        }   

        for (Opportunity opp: oppmap.values()) {
            if (accountmap.containskey(opp.AccountId)) {
                Opportunity oppr = new Opportunity(id = opp.id);
                oppr.Customer_Email__c = accountmap.get(opp.AccountId).PersonEmail;

                updateopp.add(oppr);
            }
        }

        if (RecursiveTriggerHandlerOpp.isFirstTime) {
            RecursiveTriggerHandlerOpp.isFirstTime = false;
            if (updateopp.size() > 0) {
                update updateopp;


            }
        }
         if(!test.isrunningtest() && newcustomeremail.size() > 0){
           // Changecustomeremail.customeremailChange(oldcustomeremail, newcustomeremail);
            Changecustomeremail.customeremailChange(newcustomeremail,oldcustomeremail);
        }
    }

    /***********************************************************************************************************************/


    Public static void updateSmeEmail(map < id, Opportunity > opplist, map < id, Opportunity > oldopplist) {
        map < id, Contact > contactmap = new map < id, Contact > ();
        Set < Id > oppid = new Set < Id > ();
        Set < Id > smeid = new Set < Id > ();
        List < Opportunity > opprlist = new List < Opportunity > ();
        List < Opportunity > updateopplist = new List < Opportunity > ();


        for (Opportunity opp: opplist.values()) {
            if (opp.SME1__c != oldopplist.get(opp.Id).SME1__c) {
                oppid.add(opp.id);
                smeid.add(opp.SME1__c);
            }
        }

        if(smeid.size() !=0){
            for (Contact contobj: [SELECT id, Email, AccountId, Name from Contact Where id In: smeid]) {
                contactmap.put(contobj.id, contobj);
                system.debug('contactmapcontactmap' + contactmap);
            }
        }

        if(oppid.size() !=0)
            opprlist = [Select id, SME_Email__c, SME1__c, AccountId from Opportunity where id IN: oppid];
        for (Opportunity opp: opprlist) {
            if (contactmap.containskey(opp.SME1__c)) {
                opp.SME_Email__c = contactmap.get(opp.SME1__c).Email;
                updateopplist.add(opp);
            }
        }

        if (RecursiveTriggerHandlerOppnext.isFirstTimenext) {
            RecursiveTriggerHandlerOppnext.isFirstTimenext = false;

            //update the field
            if (updateopplist.size() > 0) {
                update updateopplist;

            }
        }
    }


    /****************************************************************************************************************/

    // When D3 Substatus Changes from Project Kick-off Proposed to Project Kick-off MEeting Confirmed , Send Event Details
    public static void sendProjectDetailsToCustomer(List < Opportunity > opptyList, Map < Id, Opportunity > oldOpptyMap) {

        String esubject = null;
        String eContent = null;
        String eventlocationdetails = null;
        Event eventdetailrecord;
        List < Contact > pmContactgroup = new List < Contact > ();
        List < Opportunity > newOpptyList = new List < Opportunity > ();
        for (Opportunity oppty: opptyList) {
            if ((oppty.StageName == 'D3 Initiated' && oppty.sub_status__c == 'Project Kick-off Meeting Confirmed' && oldOpptyMap.get(oppty.id).sub_status__c == 'Project Kick-off Proposed') ||
                (oppty.StageName == 'D1 Initiated' && oppty.sub_status__c == 'Site Measurement Meeting Confirmed' && oldOpptyMap.get(oppty.id).sub_status__c == 'Site Measurement Proposed') ||
                (oppty.StageName == 'D2 Initiated' && oppty.sub_status__c == 'Design Presentation Confirmed' && oldOpptyMap.get(oppty.id).sub_status__c == 'Design Presentation Proposed') ||
                (oppty.StageName == 'D4 Initiated' && oppty.sub_status__c == 'Installation Meeting Confirmed' && oldOpptyMap.get(oppty.id).sub_status__c == 'Installation Meeting Proposed')) {
                newOpptyList.add(oppty);
            }


            if (oppty.StageName == 'D1 Initiated') {
                pmContactgroup = [select id, name, email from contact where name = 'SMM Group'
                    OR name = 'Pm Group'
                ];
            }

        }




        for (Opportunity oppty: newOpptyList) {


            if (oppty.sub_status__c == 'Project Kick-off Meeting Confirmed' ||
                oppty.sub_status__c == 'Installation Meeting Confirmed') {
                List < Opportunity > useremails = [select id, name, Design_Partner__r.email, PM__r.email, Internal_Buddy__r.email, SMM__r.email, SME1__r.email, Appointment_Venue_Site_Residence_Add1__c, Appointment_Venue_Site_Resi_State__c, Appointment_Venue_Site_Resi_Locality__c, Appointment_Venue_Site_Resi_Landmark__c, Appointment_Venue_Site_Residence_City__c, Residence_Address__c from Opportunity where id =: oppty.id];

                if (oppty.sub_status__c == 'Project Kick-off Meeting Confirmed') {
                    eventdetailrecord = returnEventDetails('D3: Project Kick-off Proposed', oppty.Id);
                } else if (oppty.sub_status__c == 'Installation Meeting Confirmed') {
                    eventdetailrecord = returnEventDetails('D4: Installation Meeting Proposed', oppty.Id);
                }

                if (eventdetailrecord.Event_Location__c == 'Site Visit') {
                    eventlocationdetails = useremails[0].Appointment_Venue_Site_Residence_Add1__c + ', \n ' +
                        useremails[0].Appointment_Venue_Site_Resi_State__c + ',\n ' +
                        useremails[0].Appointment_Venue_Site_Resi_Locality__c + ',\n ' +
                        useremails[0].Appointment_Venue_Site_Resi_Landmark__c + ',\n ' +
                        useremails[0].Appointment_Venue_Site_Residence_City__c + '\n ';
                } else if (eventdetailrecord.Event_Location__c == 'Square Showroom Visit') {
                    eventlocationdetails = oppty.Appointment_Venue_Square__c;
                } else if (eventdetailrecord.Event_Location__c == 'Remote Visit') {
                    eventlocationdetails = eventdetailrecord.If_Remote_Visit_Specify_Addres__c;
                } else if (eventdetailrecord.Event_Location__c == 'Residence Visit') {
                    eventlocationdetails = oppty.Residence_Address__c;
                }

                if (oppty.sub_status__c == 'Project Kick-off Meeting Confirmed') {
                    esubject = 'D3 Project Kick-off Meeting Details ';
                } else if (oppty.sub_status__c == 'Installation Meeting Confirmed') {
                    esubject = 'D4 Installation Meeting Details ';
                }

                eContent = ' Meeting Subject is: ' + eventdetailrecord.subject + ', \n ' + ' Meeting Description: ' + eventdetailrecord.Description + ', \n ' + ' Meeting StartTime ' + eventdetailrecord.StartDateTime + ', \n ' + ' Meeting End Time ' + eventdetailrecord.EndDateTime + ', \n ' + ' Meeting Location' + ', \n ' + eventlocationdetails + ', \n ';
                EmailUtils.sendLeadDuplicationEmailNotification(esubject, eContent, oppty.customer_email__c);
                if (null != useremails[0].PM__r.email) {
                    EmailUtils.sendLeadDuplicationEmailNotification(esubject, eContent, useremails[0].PM__r.email);
                }
                if (null != useremails[0].Internal_Buddy__r.email && oppty.sub_status__c == 'Project Kick-off Meeting Confirmed') {
                    EmailUtils.sendLeadDuplicationEmailNotification(esubject, eContent, useremails[0].Internal_Buddy__r.email);
                }
                if (null != useremails[0].SMM__r.email) {
                    EmailUtils.sendLeadDuplicationEmailNotification(esubject, eContent, useremails[0].SMM__r.email);
                }
                if (null != useremails[0].SME1__r.email && oppty.sub_status__c == 'Project Kick-off Meeting Confirmed') {
                    EmailUtils.sendLeadDuplicationEmailNotification(esubject, eContent, useremails[0].SME1__r.email);
                }
                if (null != useremails[0].Design_Partner__r.email) {
                    EmailUtils.sendLeadDuplicationEmailNotification(esubject, eContent, useremails[0].Design_Partner__r.email);
                }
            } else if (oppty.sub_status__c == 'Site Measurement Meeting Confirmed') {

                eventdetailrecord = returnEventDetails('D1: Site Measurement Proposed', oppty.Id);

                if (eventdetailrecord.Event_Location__c == 'Site Visit') {
                    eventlocationdetails = oppty.Appointment_Venue_Site_Residence_Add1__c + ', \n ' +
                        oppty.Appointment_Venue_Site_Resi_State__c + ',\n ' +
                        oppty.Appointment_Venue_Site_Resi_Locality__c + ',\n ' +
                        oppty.Appointment_Venue_Site_Resi_Landmark__c + ',\n ' +
                        oppty.Appointment_Venue_Site_Residence_City__c + '\n ';


                } else if (eventdetailrecord.Event_Location__c == 'Square Showroom Visit') {
                    eventlocationdetails = oppty.Appointment_Venue_Square__c;
                } else if (eventdetailrecord.Event_Location__c == 'Remote Visit') {
                    eventlocationdetails = eventdetailrecord.If_Remote_Visit_Specify_Addres__c;
                } else if (eventdetailrecord.Event_Location__c == 'Residence Visit') {
                    eventlocationdetails = oppty.Residence_Address__c;
                }


                esubject = 'D1 Site Measurement Proposed Meeting Details ';
                eContent = ' Meeting Subject is: ' + eventdetailrecord.subject + ', \n ' + ' Meeting Description: ' + eventdetailrecord.Description + ', \n ' + ' Meeting StartTime ' + eventdetailrecord.StartDateTime + ', \n ' + ' Meeting End Time ' + eventdetailrecord.EndDateTime + ', \n ' + ' Meeting Location ' + ', \n ' + eventlocationdetails + ', \n ';
                if(pmContactgroup.size() != 0){
                    if (null != pmContactgroup[0].email) {
                        EmailUtils.sendLeadDuplicationEmailNotification(esubject, eContent, pmContactgroup[0].email);
                    }
                    if (null != pmContactgroup[1].email) {
                        EmailUtils.sendLeadDuplicationEmailNotification(esubject, eContent, pmContactgroup[1].email);
                    }
                }
            } else if (oppty.sub_status__c == 'Design Presentation Confirmed') {

                eventdetailrecord = returnEventDetails('D2: Design Presentation Proposed', oppty.Id);
                if (eventdetailrecord.Event_Location__c == 'Site Visit') {
                    eventlocationdetails = oppty.Appointment_Venue_Site_Residence_Add1__c + ', \n ' +
                        oppty.Appointment_Venue_Site_Resi_State__c + ',\n ' +
                        oppty.Appointment_Venue_Site_Resi_Locality__c + ',\n ' +
                        oppty.Appointment_Venue_Site_Resi_Landmark__c + ',\n ' +
                        oppty.Appointment_Venue_Site_Residence_City__c + '\n ';


                } else if (eventdetailrecord.Event_Location__c == 'Square Showroom Visit') {
                    eventlocationdetails = oppty.Appointment_Venue_Square__c;
                } else if (eventdetailrecord.Event_Location__c == 'Remote Visit') {
                    eventlocationdetails = eventdetailrecord.If_Remote_Visit_Specify_Addres__c;
                } else if (eventdetailrecord.Event_Location__c == 'Residence Visit') {
                    eventlocationdetails = oppty.Residence_Address__c;
                }


                esubject = 'D2 Design Presentation Proposed Meeting Details ';
                eContent = ' Meeting Subject is: ' + eventdetailrecord.subject + ', \n ' + ' Meeting Description: ' + eventdetailrecord.Description + ', \n ' + ' Meeting StartTime ' + eventdetailrecord.StartDateTime + ', \n ' + ' Meeting End Time ' + eventdetailrecord.EndDateTime + ', \n ' + ' Meeting Location' + ', \n ' + eventlocationdetails + ', \n ';
                EmailUtils.sendLeadDuplicationEmailNotification(esubject, eContent, oppty.PM__c);

            }
        }
    }



    // The Following method Queries Ebent table and retirns the event record based on Subject and Opportunity Id
    public static Event returnEventDetails(String emailSubject, Id recordId) {
             Event objEvt = new Event();

        List < Event > eventdetails = [Select id, ActivityDate, subject, Description, StartDateTime, Type, EndDateTime, Location, Event_Location__c, If_Remote_Visit_Specify_Addres__c from Event where EventType__c =: emailSubject and WhatId =: recordId order by createddate desc limit 1];

        //system.debug('*** Event Details are ? ' + eventdetails[0]);
        if(eventdetails.size() !=0)
            return eventdetails[0];
        else
          return objEvt;    

    }



    public static void assignInternalBuddy(List < Opportunity > newOpptyList) {
        Set < Id > dpIds = new Set < Id > ();
        Set < Id > oppid = new Set < Id > ();
        Set < Id > actid = new Set < Id > ();
        map < id, Id > usrmap = new map < id, Id > ();
        List < User > users = new list < User > ();
        map < id, Account > accountmap = new map < id, Account > ();

        for (Opportunity opp: newOpptyList) {
            dpIds.add(opp.Design_Partner__c); //Roaster Change
            actid.add(opp.AccountId);
            oppid.add(opp.id);
        }

        users = [Select Id, Name, Internal_Buddy__c From User Where Id IN: dpIds LIMIT 1000];
        for (User usr: users) {
            if (usr.Internal_Buddy__c != null) {
                usrmap.put(usr.Id, usr.Internal_Buddy__c);
            }
        }

        for (Opportunity opp: newOpptyList) {
            opp.Internal_Buddy__c = usrmap.get(opp.Design_Partner__c);//Roaster Change
           /* if (opp.Design_Partner__c != NULL) { //Roaster Change
                opp.ownerId = opp.Design_Partner__c; //Roaster Change
            }*/
        }
    }

    /********************OPPOTUNITY RESTRICTION*****************************************************/


   /* Public static void ProjectPlannerStatusRestriction(map < id, Opportunity > opplist, map < id, Opportunity > oldopplist) {


     id projectid;
     Set < id > oppId = new Set < id > ();
     List < Milestone__c > lstmilestone = new List < Milestone__c > ();
     List < Task__c > lsttask = new List < Task__c > ();

     for (Opportunity opp: opplist.values()) {
         if (opp.StageName != oldopplist.get(opp.id).StageName || opp.Sub_Status__c != oldopplist.get(opp.id).Sub_Status__c ) {
             oppId.add(opp.id);
         }
     }

     if (oppId.size() > 0) {
     
         List<Project_Name__c> projectPerOpportunity = [Select id from Project_Name__c where Opportunity_Project__c IN: oppId];
         
         if(!projectPerOpportunity.isEmpty()){
             projectid = projectPerOpportunity[0].id;
           }
         System.debug('projectid' + projectid);
     }

     if(projectid!=NULL){
     lstmilestone = [select id, Title__c, Status__c, OpportunityStatus__c from Milestone__c where Project__c =: projectid];
     lsttask = [select id, Title__c, Status__c, OpportunityStatus__c from Task__c where Project__c =: projectid];
     }
     System.debug('lstmilestone ' + lstmilestone);
     System.debug('lsttask ************ ' + lsttask );

     for (Opportunity oppStatus: opplist.values()) {
         if (lstmilestone.size() > 0) {
             for (Milestone__c objmile: lstmilestone) {
                 if (oppStatus.StageName == 'Project Plan & Estimates Publish') {
                     if (objmile.OpportunityStatus__c == oppStatus.StageName && objmile.Status__c != 'Completed') {
                         oppStatus.adderror('Status cannot be changed as the Milestone ' + objmile.Title__c + ' related to this is not completed');
                     }

                 }


                 if (oppStatus.StageName == 'Production Initiated & Order Placed') {
                     if (objmile.OpportunityStatus__c == oppStatus.StageName && objmile.Status__c != 'Completed') {
                         oppStatus.adderror('Status cannot be changed as the Milestone ' + objmile.Title__c + ' related to this is not completed');
                     }

                 }


                 if (oppStatus.StageName == 'Production & Procurement Complete') {
                     if (objmile.OpportunityStatus__c == oppStatus.StageName && objmile.Status__c != 'Completed') {
                         oppStatus.adderror('Status cannot be changed as the Milestone ' + objmile.Title__c + ' related to this is not completed');
                     }

                 }



                 if (oppStatus.StageName == '50% Payment Collected') {
                     if (objmile.OpportunityStatus__c == oppStatus.StageName && objmile.Status__c != 'Completed') {
                         oppStatus.adderror('Status cannot be changed as the Milestone ' + objmile.Title__c + ' related to this is not completed');
                     }

                 }


                 if (oppStatus.StageName == 'Install Team Assigned,Material Dispatche') {
                     if (objmile.OpportunityStatus__c == oppStatus.StageName && objmile.Status__c != 'Completed') {
                         oppStatus.adderror('Status cannot be changed as the Milestone ' + objmile.Title__c + ' related to this is not completed');
                     }

                 }

                 if (oppStatus.StageName == 'Material Received') {
                     if (objmile.OpportunityStatus__c == oppStatus.StageName && objmile.Status__c != 'Completed') {
                         oppStatus.adderror('Status cannot be changed as the Milestone ' + objmile.Title__c + ' related to this is not completed');
                     }

                 }

                 if (oppStatus.StageName == 'Installation Started') {
                     if (objmile.OpportunityStatus__c == oppStatus.StageName && objmile.Status__c != 'Completed') {
                         oppStatus.adderror('Status cannot be changed as the Milestone ' + objmile.Title__c + ' related to this is not completed');
                     }

                 }


                 if (oppStatus.StageName == 'Installation Completed') {
                     if (objmile.OpportunityStatus__c == oppStatus.StageName && objmile.Status__c != 'Completed') {
                         oppStatus.adderror('Status cannot be changed as the Milestone ' + objmile.Title__c + ' related to this is not completed');
                     }

                 }


                 if (oppStatus.StageName == 'Snaglist Rectification Completed') {
                     if (objmile.OpportunityStatus__c == oppStatus.StageName && objmile.Status__c != 'Completed') {
                         oppStatus.adderror('Status cannot be changed as the Milestone ' + objmile.Title__c + ' related to this is not completed');
                     }

                 }


                 if (oppStatus.StageName == 'Project Sign Off') {
                     if (objmile.OpportunityStatus__c == oppStatus.StageName && objmile.Status__c != 'Completed') {
                         oppStatus.adderror('Status cannot be changed as the Milestone ' + objmile.Title__c + ' related to this is not completed');
                     }

                 }
                 
                   
                   
                  if (oppStatus.StageName =='D4 Initiated' && oppStatus.Sub_Status__c == 'Meeting for Installation Completed') {
                   System.debug('objmile.OpportunityStatus__c'+objmile.OpportunityStatus__c);
                   System.debug('oppStatus.Sub_Status__c'+oppStatus.Sub_Status__c);
                     if (objmile.OpportunityStatus__c == oppStatus.Sub_Status__c && objmile.Status__c == 'Not Started') {
                     System.debug('oppStatus.Sub_Status__c44444'+oppStatus.Sub_Status__c);
                         oppStatus.adderror('Status cannot be changed as the Milestone ' + objmile.Title__c + '  is not Started');
                     }

                 }
             }
         }


         if (lsttask.size() > 0) {

             for (Task__c objtask: lsttask) {
                 if (oppStatus.StageName =='D4 Initiated' && oppStatus.Sub_Status__c == 'Installation Meeting Confirmed') {
                  system.debug('*********hello***********'+objtask.OpportunityStatus__c);
                  system.debug('*********hello*title*********'+objtask.Title__c);
                   system.debug('*********hello33333***********'+oppStatus.Sub_Status__c);
                     system.debug('*********hello33333***********'+objtask.id);
                 
                     if (objtask.OpportunityStatus__c == oppStatus.Sub_Status__c && objtask.Status__c != 'Completed' && oppStatus.Sub_Status__c=='Chimney Duct Paneling') {
                         system.debug('*********hello*****inside*****');
                         oppStatus.adderror('Status cannot be changed as the Milestone ' + objtask.Title__c + ' related to this is not completed');
                     }

                 }

               /*  if (oppStatus.StageName =='D4 Initiated' && oppStatus.Sub_Status__c == 'Meeting for Installation Completed') {
                     if (objtask.OpportunityStatus__c == oppStatus.Sub_Status__c && objtask.Status__c != 'Completed') {
                         oppStatus.adderror('Status cannot be changed as the Milestone ' + objtask.Title__c + ' related to this is not completed');
                     }
                 }---End Comment 
             }
         }

     }

 }*/

    /******************************************************************************************/
    
       //Folder Creation - Folder Structure
    /*Public Static void createFolderStructure(List < Opportunity > newOpptyList) { 
    list<Bucket__c> lstBucks = new list<Bucket__c>();
    list<Element__c> lstEles = new list<Element__c>();
    
    map<String,Bucket__c> mapoppIdBuc = new map<String,Bucket__c>();
        for (Opportunity oppty: newOpptyList) {
          lstBucks.add(createBucket('Site Measurement',oppty.id));
          lstBucks.add(createBucket('3D Drawings',oppty.id));
          lstBucks.add(createBucket('2D Drawings',oppty.id));
          lstBucks.add(createBucket('Others',oppty.id));
        }
        
        if(!lstBucks.isEmpty()){
          insert lstBucks;
        }
        for (Opportunity oppty: newOpptyList) {
          for (Bucket__c buckt: lstBucks) {
            if(buckt.Related_Object_ID__c == oppty.id){
              if(buckt.Name == 'Site Measurement'){
                lstEles.add(CreateSubFolder('Bedroom - SM',buckt));
                lstEles.add(CreateSubFolder('Kitchen - SM',buckt));
                lstEles.add(CreateSubFolder('Dining - SM',buckt));
                lstEles.add(CreateSubFolder('Study - SM',buckt));
                lstEles.add(CreateSubFolder('Foyer - SM',buckt));
                lstEles.add(CreateSubFolder('Bathroom - SM',buckt));
                lstEles.add(CreateSubFolder('Utility - SM',buckt));
                lstEles.add(CreateSubFolder('Servant\'s Room - SM',buckt));
                lstEles.add(CreateSubFolder('Store Room - SM',buckt));
                lstEles.add(CreateSubFolder('Under StairCase Unit - SM',buckt));
                lstEles.add(CreateSubFolder('Others - SM',buckt));
              }
              if(buckt.Name == '3D Drawings' ){
                lstEles.add(CreateSubFolder('Bedroom - 3D',buckt));
                lstEles.add(CreateSubFolder('Kitchen - 3D',buckt));
                lstEles.add(CreateSubFolder('Dining - 3D',buckt));
                lstEles.add(CreateSubFolder('Study - 3D',buckt));
                lstEles.add(CreateSubFolder('Foyer - 3D',buckt));
                lstEles.add(CreateSubFolder('Bathroom - 3D',buckt));
                lstEles.add(CreateSubFolder('Utility - 3D',buckt));
                lstEles.add(CreateSubFolder('Servant\'s Room - 3D',buckt));
                lstEles.add(CreateSubFolder('Store Room - 3D',buckt));
                lstEles.add(CreateSubFolder('Under StairCase Unit - 3D',buckt));
                lstEles.add(CreateSubFolder('Others - 3D',buckt));
              }
              if(buckt.Name == '2D Drawings'){
                lstEles.add(CreateSubFolder('Bedroom - 2D',buckt));
                lstEles.add(CreateSubFolder('Kitchen - 2D',buckt));
                lstEles.add(CreateSubFolder('Dining - 2D',buckt));
                lstEles.add(CreateSubFolder('Study - 2D',buckt));
                lstEles.add(CreateSubFolder('Foyer - 2D',buckt));
                lstEles.add(CreateSubFolder('Bathroom - 2D',buckt));
                lstEles.add(CreateSubFolder('Utility - 2D',buckt));
                lstEles.add(CreateSubFolder('Servant\'s Room - 2D',buckt));
                lstEles.add(CreateSubFolder('Store Room - 2D',buckt));
                lstEles.add(CreateSubFolder('Under StairCase Unit - 2D',buckt));
                lstEles.add(CreateSubFolder('Others - 2D',buckt));
              }
              if(buckt.Name == 'Others'){
                lstEles.add(CreateSubFolder('Quotation',buckt));
                lstEles.add(CreateSubFolder('Checklist',buckt));
                lstEles.add(CreateSubFolder('Bills',buckt));
                lstEles.add(CreateSubFolder('Scope of Work',buckt));
                lstEles.add(CreateSubFolder('Floor Plan',buckt));
              }
            }
          }  
        }
        
        if(!lstEles.isEmpty()){
          insert lstEles;
        }
        
    }*/
    
    /*public static Bucket__c CreateBucket(String BucketName,Id oppId){
      Bucket__c objBuc = new Bucket__c();
    objBuc.Name = BucketName;
    objBuc.Related_Object_ID__c = oppId;
    
    return objBuc;
    }
    
    public static Element__c CreateSubFolder(String SubName,Bucket__c objBucket){
    Element__c objele = new Element__c();
    objele.Name = SubName;
    objele.Type__c = 'Folder';
    objele.Related_Object_ID__c = objBucket.Related_Object_ID__c;
    objele.Bucket__c = objBucket.id;
    
    return objele;
    }*/
   Public Static void opptyChangeStage(List<Opportunity> newOpptyList, Map<Id,Opportunity> oldOpptyMap) {
        
        for (Opportunity oppty: newOpptyList) {
           if(oppty.StageName == 'Quote Required' && oppty.StageName != oldOpptyMap.get(oppty.id).StageName){
              oppty.Opportunity_Stage__c = 'Appointment Successful'; 
           }else if(oppty.StageName == 'Initial Quote Sent' && oppty.StageName != oldOpptyMap.get(oppty.id).StageName){
              oppty.Opportunity_Stage__c = 'Initial Quote Sent'; 
           }else if(oppty.Opportunity_Stage__c == 'IQ Follow up - Done' && oppty.Opportunity_Stage__c != oldOpptyMap.get(oppty.id).Opportunity_Stage__c){
              oppty.StageName = 'IQ Follow Up'; 
           }else if(oppty.Opportunity_Stage__c == 'Lost' && oppty.Opportunity_Stage__c != oldOpptyMap.get(oppty.id).Opportunity_Stage__c){
              oppty.StageName = 'Opportunity Lost'; 
           }

           if(oppty.SCVM_Incentive__c != null && oppty.SCVM_Incentive__c != oldOpptyMap.get(oppty.Id).SCVM_Incentive__c){
                 String strMeetingDate = String.valueOf(Date.valueOf(oppty.Time_of_Actual_Appointment_Start__c));
                SendFeedBackToRoasterAPI.SendDPIncentive(oppty.Customer_Email__c,oppty.Quote_Sent_DP__c,strMeetingDate,String.valueOf(oppty.SCVM_Incentive__c));
              }
        }
    }
    // Change the Opportunity Stage based on Status
    Public Static void opptyStages(List<Opportunity> newOpptyList) {
        
        for (Opportunity oppty: newOpptyList) {
           if(oppty.StageName == 'Quote Required'){
              oppty.Opportunity_Stage__c = 'Appointment Successful'; 
           }else if(oppty.StageName == 'Initial Quote Sent'){
              oppty.Opportunity_Stage__c = 'Initial Quote Sent'; 
           }else if(oppty.Opportunity_Stage__c == 'IQ Follow up - Done'){
              oppty.StageName = 'IQ Follow Up'; 
           }else if(oppty.Opportunity_Stage__c == 'Lost'){
              oppty.StageName = 'Opportunity Lost'; 
           }
        }
    }
   /***********************************************Update NPS Score in Account****************************/ 
   /* public static void UpdateNPSOnAccount(List<Opportunity> newOpptyList, Map<Id,Opportunity> oldOpptyMap){
        Set<String> setAccountIds = new Set<String>(); 
        List<Account> lstAccounts = new List<Account>();
        try{
            for (Opportunity opp: newOpptyList) {
              
             if(opp.Customer_s_Recommendation_Of_Homelane__c !='' && opp.Customer_s_Recommendation_Of_Homelane__c != null && opp.Customer_s_Recommendation_Of_Homelane__c != oldOpptyMap.get(opp.Id).Customer_s_Recommendation_Of_Homelane__c){
                setAccountIds.add(opp.AccountId);
             }
           }
           for(Account objAcc : [Select Id,NPS_Collected__c from Account Where Id IN : setAccountIds]){
               objAcc.NPS_Collected__c = 'yes';
               lstAccounts.add(objAcc);
               
           }
          update lstAccounts;
        }catch(exception exp){
            system.debug('------Error OpportunitySharingHandler----'+exp.getMessage());
        }
    } 

/****************************************************************************************************************************************/

 // update opportunity outstanding balance when Bills, payment's are approved. - Added by Venkat
 
 Public Static void updateOpptyBalance(List<Opportunity> newOpptyList, Map<Id,Opportunity> oldOpptyMap){
 
   for(Opportunity oppty: newOpptyList){
     if((oppty.StageName == '10% Payment Collected' && oppty.StageName != oldOpptyMap.get(oppty.Id).StageName) ||
        (oppty.StageName == 'D3 Initiated' && oppty.Sub_Status__c == '40% Payment Collected' && oppty.Sub_Status__c != oldOpptyMap.get(oppty.Id).Sub_Status__c ) ||
        (oppty.StageName == '50% Payment Collected' && oppty.StageName != oldOpptyMap.get(oppty.Id).StageName) ||
        (oppty.StageName == 'Full and Final Settlement Collected' && oppty.StageName != oldOpptyMap.get(oppty.Id).StageName)){
        
        oppty.Total_Outstanding_Balance__c = oppty.Amount - oppty.Total_Amount_Paid_By_the_Customer__c ;
        
     }
   }
 }
 
/****************************************************************************************************************************************/
/* Public static void InsertEmailForCommunication(List < Opportunity > opprecordList) {
        try{
         for (Opportunity newopprecord: opprecordList) {
             system.debug('---Customer_Email__c----'+newopprecord.Customer_Email__c);
             if(newopprecord.Customer_Email__c.Contains('duplicate')){
                Integer startIndex = newopprecord.Customer_Email__c.indexOf('_');
                system.debug('---startIndex----'+startIndex);
                String strEmail = newopprecord.Customer_Email__c.subString(startIndex+1,newopprecord.Customer_Email__c.length());
                system.debug('---strEmail----'+strEmail);
                newopprecord.Email_For_Communication__c = strEmail;
                newopprecord.Update_Email_Communication__c = true;
                system.debug('---newopprecord----'+newopprecord);               
             }else{
                  
                newopprecord.Email_For_Communication__c = newopprecord.Customer_Email__c;
                system.debug('---newopprecord-else---'+newopprecord);               
             }
             system.debug('---newopprecord----'+newopprecord);
         }
        }
        catch(exception exp){
            system.debug('---exp----'+exp.getMessage());
        }
    }*/
    Public static void UpdateEmailForCommunication(List < Opportunity > opprecordList) {
        
         for (Opportunity newopprecord: opprecordList) {
             if(newopprecord.Update_Email_Communication__c == true && newopprecord.Customer_Email__c.Contains('duplicate')){
                Integer startIndex = newopprecord.Customer_Email__c.indexOf('_');
                String strEmail = newopprecord.Customer_Email__c.subString(startIndex+1,newopprecord.Customer_Email__c.length());
                newopprecord.Email_For_Communication__c = strEmail;             
             }else{
                newopprecord.Email_For_Communication__c = newopprecord.Customer_Email__c; 
             }
         }
        
    }



/****************************************************************************************************************************************/

// function to update the DP information on IQ by hitting the IQ API.
 Public Static void updateDP(List<Opportunity> newOpptyList, Map<Id,Opportunity> oldOpptyMap){ 
     System.debug('newOpptyList------------------------------->'+newOpptyList);
     list<String> designeremail = new list<String>();
     list<String> newdesigneremail = new list<String>();
     list<String> customeremail = new list<String>();
     boolean isDPChange = false;
     System.debug('oldOpptyMap-------------------------------->'+oldOpptyMap);
     for(Opportunity newopp:newOpptyList){ //Roaster Change
         if(newopp.Interior_Design_Partner__c!= null && newopp.Design_Partner_Email__c!=null && newopp.Customer_Email__c!=null){
            newdesigneremail.add(newopp.Design_Partner_Email__c);
            customeremail.add(newopp.Customer_Email__c);
         }
         if(oldOpptyMap.get(newopp.Id) !=null){
          if(newopp.Interior_Design_Partner__c != oldOpptyMap.get(newopp.Id).Interior_Design_Partner__c) //Roaster Change
            isDPChange = true; 
         }
        System.debug('oldOpptyMap.get(newopp.Id) ------------------->'+oldOpptyMap.get(newopp.Id) );
     System.debug('customeremail------------------->'+customeremail); 
     }
     System.debug('newdesigneremail ------------------->'+newdesigneremail );
     System.debug('isDPChange------------------->'+isDPChange);
     for(Opportunity oldopp:oldOpptyMap.values()){
         if(oldopp.Interior_Design_Partner__c!= null && oldopp.Design_Partner_Email__c!=null){ //Roaster Change
            designeremail.add(oldopp.Design_Partner_Email__c);
         }
     }
     System.debug('designeremail------------------->'+designeremail);
     
       if(!test.isrunningtest())
    { if(isDPChange == true)
        ChangeDPRestAPI.handleDPchange(designeremail, newdesigneremail, customeremail);
     }
     
 }
 
 


Public static void validateOpportunityUpdate(List < Opportunity > OpportunityrecordList, Map < Id, Opportunity > oldOpportunityMap) {
          system.debug('---oldOpportunityMap----'+oldOpportunityMap);
          Map < String, String > duplicateOpportunitys = new Map < String, String > ();
        for (Opportunity lrec: OpportunityrecordList) {
            if ((lrec.Customer_Phone_Number__c != oldOpportunityMap.get(lrec.id).Customer_Phone_Number__c || lrec.Customer_Email__c != oldOpportunityMap.get(lrec.id).Customer_Email__c) && (null != lrec.Customer_Phone_Number__c && null != lrec.Customer_Email__c) && (oldOpportunityMap.get(lrec.id).Customer_Email__c != null)) {
                duplicateOpportunitys.put(lrec.Customer_Phone_Number__c, lrec.Customer_Email__c);
            }
        }
        system.debug('---duplicateOpportunitys----'+duplicateOpportunitys); 
        if (!duplicateOpportunitys.isEmpty()) {
          Map <Id, Lead> existingLeadrecordsMap = new Map <Id, Lead> ();
           /* Map < Id, Lead > existingLeadrecordsMap1 = new Map < Id, Lead > ([select id,ConvertedOpportunityId, name, Phone, email, city, Company, Customer_ID__c, Status,
                Duplicate_Record__c from Lead where Phone IN : duplicateOpportunitys.KeySet()]);
            Map < Id, Lead > existingLeadrecordsMap2 = new Map < Id, Lead > ([select id,ConvertedOpportunityId, name, Phone, email, city, Company, Customer_ID__c, Status,
                Duplicate_Record__c from Lead where email IN: duplicateOpportunitys.values()]);
            existingLeadrecordsMap.putAll(existingLeadrecordsMap1);
             existingLeadrecordsMap.putAll(existingLeadrecordsMap2);*/
             Map < Id, Opportunity > existingOpportunityrecordsMap = new Map < Id, Opportunity > ([select id, name, Customer_Phone_Number__c, Customer_Email__c, Account.Customer_ID__c, StageName from Opportunity where
                Customer_Phone_Number__c IN: duplicateOpportunitys.KeySet() OR Customer_Email__c IN: duplicateOpportunitys.values()
            ]);
           system.debug('---existingLeadrecordsMap----'+existingLeadrecordsMap);
           system.debug('---existingOpportunityrecordsMap----'+existingOpportunityrecordsMap);
           system.debug('---OpportunityrecordList----'+OpportunityrecordList);
            for (Opportunity lrecord: OpportunityrecordList) {
                for (Lead Opportunityrecord: existingLeadrecordsMap.Values()) {
                   if ((lrecord.Customer_Phone_Number__c == Opportunityrecord.Phone || lrecord.Customer_Email__c == Opportunityrecord.Email)&& (Opportunityrecord.ConvertedOpportunityId !=lrecord.Id)) {
                        lrecord.addError('Lead with the same Email or Phone no. exists: Please update the existing Lead instead of creating a new record ' + ', \n ' + ' Existing Customer ID is ' + Opportunityrecord.Customer_ID__c + ' Existing Customer Status is ' + Opportunityrecord.Status);
                    }
                }
                for (Opportunity Opportunityrecord: existingOpportunityrecordsMap.Values()) {
                   if ((lrecord.Customer_Phone_Number__c == Opportunityrecord.Customer_Phone_Number__c || lrecord.Customer_Email__c == Opportunityrecord.Customer_Email__c)&& ((Opportunityrecord.Id !=lrecord.Id))) {
                        lrecord.addError('Lead or Opportunity with the same Email or Phone no. exists: Please update the existing Lead or Opportunity instead of creating a new record ' + ', \n ' + ' Existing Customer ID is ' + Opportunityrecord.Account.Customer_ID__c + ' Existing Customer Status is ' + Opportunityrecord.StageName);
                    }
                }
            }
            

        }


    }
    
     public static void WorksContractTrue(List<Opportunity> oppList,Map<Id,Opportunity> oldOppMap){
        for(Opportunity oppty : oppList) {
            if(oppty.Works_Contract_Sign_Off_Done__c == true && oppty.Works_Contract_Sign_Off_Date__c != null &&  oppty.Works_Contract_Sign_Off_Date__c != oldOppMap.get(oppty.Id).Works_Contract_Sign_Off_Date__c ) { 
               System.debug('***INSIDE***');        
               SendFeedBackToRoasterAPI.SendToRoaster(oppty.Customer_Email__C);         
            }
        }
    }
/****************************************************************************************************************************************/

}