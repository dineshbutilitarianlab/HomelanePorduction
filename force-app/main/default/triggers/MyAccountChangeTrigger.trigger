trigger MyAccountChangeTrigger on AccountChangeEvent (after insert) {
    List<Task> tasks = new List<Task>();
    
    // Iterate through each event message.
    for (AccountChangeEvent event : Trigger.New) {
        // Get some event header fields
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
        System.debug('Received change event for ' + header.entityName +
                    ' for the ' + header.changeType + ' operation.');         

        // Get account record fields
        System.debug('Account Name: ' + event.Name);
        System.debug('Account Phone: ' + event.Phone);
        
        // Create a followup task
        if (header.changetype == 'CREATE') {
            Task tk = new Task();
            tk.Subject = 'Follow up on new account for record or group of records: ' +
              header.recordIds;
            // Explicitly set the task owner ID to a valid user ID so that
            // it is not Automated Process.
            // For simplicity, we set it to the CommitUser header field, 
            // which is available for all operations. 
            tk.OwnerId = header.CommitUser; 
            tasks.add(tk);
        }        
        else if ((header.changetype == 'UPDATE')) {
            // For update operations, iterate over the list of changed fields
            System.debug('Iterate over the list of changed fields.'); 
            for (String field : header.changedFields) {
                if (null == event.get(field)) {
                    System.debug('Deleted field value (set to null): ' + field); 
                } else {
                    System.debug('Changed field value: ' + field + 
                        '. New Value: ' + event.get(field)); 
                }
            }
        }     
    }
    
    // Insert all tasks in bulk.


}