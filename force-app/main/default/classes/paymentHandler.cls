public class paymentHandler{

  public static Map<Id,String> paymentMilestoneMap;
  public static List<Payment_Milestone__c> paymentMilestonewithsamePaymentType; 
 public static void updateCustomerEmail(List<Payment_Milestone__c > paymentMilestoneList){
 
       Set<Id> billIds = new Set<Id>();
      for(Payment_Milestone__c paymentrec: paymentMilestoneList){
        if(null != paymentrec.Bill__c){
            billIds.add(paymentrec.Bill__c);
        }
       }
       
       
   Map<Id,Customer_Bill__c> customerBillrecords = new Map<Id,Customer_Bill__c>([select id,name,Customer_Email__c,Interior_Design_Partner__c from Customer_Bill__c where id in: billIds ]);
    
    for(Payment_Milestone__c paymentrec: paymentMilestoneList){
         if(customerBillrecords.ContainsKey(paymentrec.Bill__c)){
            paymentrec.Customer_Email__c = customerBillrecords.get(paymentrec.Bill__c).Customer_Email__c;
             paymentrec.Interior_Design_Partner__c = customerBillrecords.get(paymentrec.Bill__c).Interior_Design_Partner__c;
         }
     }
 
 }

/**************************************************************************************************************************/

 public static void validatePaymentType(List<Payment_Milestone__c> paymentMilestoneList){
 
   system.debug(' *** IN INSERT ');
   paymentMilestoneMap = new Map<Id,String>();
   for(Payment_Milestone__c paymentrec: paymentMilestoneList){
        if(null != paymentrec.Payment_Type__c){
            paymentMilestoneMap.put(paymentrec.Bill__c,paymentrec.Payment_Type__c);
        }
       }
 system.debug(' *** paymentMilestoneMap'+paymentMilestoneMap); 
 paymentMilestonewithsamePaymentType = new List<Payment_Milestone__c>([select id,name,Payment_Type__c,Bill__c from Payment_Milestone__c where 
                                                                            Bill__c IN: paymentMilestoneMap.KeySet() AND 
                                                                            Payment_Type__c IN: paymentMilestoneMap.values()]);
    system.debug(' *** paymentMilestonewithsamePaymentType  '+paymentMilestonewithsamePaymentType );
                                                                           
     for(Payment_Milestone__c paymentrec: paymentMilestoneList){
       for(Payment_Milestone__c paymentrecexisting: paymentMilestonewithsamePaymentType){
            if(paymentrec.Bill__c == paymentrecexisting.Bill__c &&
               paymentrec.Payment_Type__c == paymentrecexisting.Payment_Type__c ){
                 paymentrec.Payment_Type__c.addError('Record with Payment Type '+paymentrec.Payment_Type__c + ' already exists. Please, change the type and Save again. ');
            }
        }
       }                                                                        
 
 }

/**************************************************************************************************************************/

 public static void validatePaymentTypeinUpdate(List<Payment_Milestone__c> paymentMilestoneList, Map<Id,Payment_Milestone__c> oldpaymentMilestoneMap){
 
    system.debug(' *** IN UPDATE');

   paymentMilestoneMap = new Map<Id,String>();
   for(Payment_Milestone__c paymentrec: paymentMilestoneList){
        if(null != paymentrec.Payment_Type__c && paymentrec.Payment_Type__c != oldpaymentMilestoneMap.get(paymentrec.id).Payment_Type__c){
            paymentMilestoneMap.put(paymentrec.Bill__c,paymentrec.Payment_Type__c);
        }
       }
    system.debug(' *** paymentMilestoneMap'+paymentMilestoneMap); 
   paymentMilestonewithsamePaymentType = new List<Payment_Milestone__c>([select id,name,Payment_Type__c,Bill__c from Payment_Milestone__c where 
                                                                            Bill__c IN: paymentMilestoneMap.KeySet() AND 
                                                                            Payment_Type__c IN: paymentMilestoneMap.values()]); 
   system.debug(' *** paymentMilestonewithsamePaymentType  '+paymentMilestonewithsamePaymentType );
                                                                           
     for(Payment_Milestone__c paymentrec: paymentMilestoneList){
       for(Payment_Milestone__c paymentrecexisting: paymentMilestonewithsamePaymentType){
            if(paymentrec.Payment_Type__c != oldpaymentMilestoneMap.get(paymentrec.id).Payment_Type__c &&
               paymentrec.Bill__c == paymentrecexisting.Bill__c &&
               paymentrec.Payment_Type__c == paymentrecexisting.Payment_Type__c ){
                 paymentrec.Payment_Type__c.addError('Record with Payment Type '+paymentrec.Payment_Type__c + ' already exists. Please, change the type and Save again. ');
            }
        }
       }  
 
 }

/**************************************************************************************************************************/

}