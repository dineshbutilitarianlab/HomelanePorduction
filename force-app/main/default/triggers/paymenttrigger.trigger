trigger paymenttrigger on Payment_Milestone__c (before insert,before Update) {

 if(trigger.isBefore){
        if(trigger.isInsert ){
      
             // update the customer email in payment record
             paymentHandler.updateCustomerEmail(Trigger.new);
         
             //validate the paymenttype
            paymentHandler.validatePaymentType(Trigger.new);
       }
  
       if(trigger.isUpdate){
          paymentHandler.validatePaymentTypeinUpdate(Trigger.new,trigger.oldMap);
       }
  }
  
 
}