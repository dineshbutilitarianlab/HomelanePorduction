/*
 *Author: Venkat Arisa
 *Date Created: June 13 2016
 *Date Last Modified: August 9
 *Version: 3
 */

trigger customerBilltrigger on Customer_Bill__c(before insert,before update, after Update) {

  if(trigger.isInsert && trigger.isBefore){
    //When Full & final Settlement record is created manually, update the customer email in bill record
    CustomerBillHandler.InsertCustomerEmail(trigger.new);
    
     // Vaidate Bill Status on CustomerBill record
    CustomerBillHandler.validateBillStatus(trigger.new);
  }
  
 
  if(trigger.isUpdate && trigger.isAfter){
     //When 10,40,50% payments are Approved, Update Oppty Stage as 10,40,50% Payment Collected
    CustomerBillHandler.UpdateOpptyStage(Trigger.New,trigger.oldMap); 
  }
  
}