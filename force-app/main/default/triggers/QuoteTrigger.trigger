trigger QuoteTrigger on Quote (before Insert, before Update, after Insert, after Update) {
    if(Trigger.isBefore && Trigger.isUpdate){
    system.debug('label.WhatsApp_Quotes'+label.WhatsApp_Quotes);
        if(label.WhatsApp_Quotes.equalsIgnoreCase('True')){
            //Stopped because of no Verloop contract as suggested by pavan on 09/09/2020
            //WhatsappTrigger.whatsappQuote(Trigger.new,Trigger.oldMap);
        }    
    }
}