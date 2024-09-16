global  class IronManPaintSpecialistScheduleEmail implements Schedulable{
    
    global void execute (SchedulableContext ctx){
        
        dateTime todayDate = Date.Today();
        String todayDayInString = todayDate.format('EEEE');
        
        
        List<Showroom_User__c> showroomUserList = [select Name, Daily_Assignment__c,Daily_Assignment_Limit__c, Weekly_Off_Days__c, Monthly_Assignment__c,Monthly_Assignment_Limit__c,IsActive__c 
                                                   From Showroom_User__c 
                                                   where Weekly_Off_Days__c Excludes(:todayDayInString) 
                                                   and IsActive__c = True and Specialisation__c = 'Paint'];
        System.debug('showroomUserList '+showroomUserList );
        
        
        
        Decimal DailyAssignmentSum = 0;
        Decimal SumOfDailyAssignmentLimit =0;
        Decimal MonthlyAssignmentSum = 0;
        Decimal sumOfMonthlyAssignmentLimit = 0;
        Decimal cumulativeValue ;
        
        list<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>(); 
        String email = system.label.Hl_paint_Email;
        toAddresses.add(email);
        mail.setToAddresses(toAddresses);
        
        if(showroomUserList.isEmpty()){
            mail.setSubject('No Pronto Paint specialist available');
            String messageBody = '<html><body> Team, <br> No active Pronto Paint specialist is available to take any new Pronto Paint meetings. Please check the daily and monthly limits for these specialists<br>Thanks</body></html>';
            mail.setHtmlBody(messageBody);
            mailList.add(mail);      
        }
        
        else{
            for(Showroom_User__c su :showroomUserList){
                DailyAssignmentSum += su.Daily_Assignment__c;
                SumOfDailyAssignmentLimit += su.Daily_Assignment_Limit__c;
                MonthlyAssignmentSum += su.Monthly_Assignment__c;
                sumOfMonthlyAssignmentLimit += su.Monthly_Assignment_Limit__c;
            }
            
            system.debug('DailyAssignmentSum ' + DailyAssignmentSum);
            system.debug('SumOfDailyAssignmentLimit' + SumOfDailyAssignmentLimit);
            system.debug(' MonthlyAssignmentSum' + MonthlyAssignmentSum);
            system.debug('sumOfMonthlyAssignmentLimit' + sumOfMonthlyAssignmentLimit );
            
            Decimal DailyCumulativeUtilizationPercentage = (DailyAssignmentSum/SumOfDailyAssignmentLimit)*100;
            Decimal MonthlyCumulativeUtilizationPercentage =(MonthlyAssignmentSum/sumOfMonthlyAssignmentLimit)*100;
            
            
            system.debug('DailyCumulativeUtilizationPercentage'+ DailyCumulativeUtilizationPercentage);
            system.debug('MonthlyCumulativeUtilizationPercentage '+ MonthlyCumulativeUtilizationPercentage);
            
            
            String strLabelvalue    = system.label.Daily_Cumulative_Utilisation_Percentage;
            
            if(String.isNotBlank(strLabelvalue.trim())){
                try{
                    cumulativeValue  = decimal.valueOf(system.label.Daily_Cumulative_Utilisation_Percentage);
                }catch(Exception e){
                    System.debug('Please give a valid value');
                    cumulativeValue = 80;
                }
            }
            
            System.debug('cumulativeValue '+cumulativeValue);
            
            if(DailyCumulativeUtilizationPercentage > cumulativeValue || MonthlyCumulativeUtilizationPercentage > cumulativeValue){
                String htmlBody='';
                htmlBody = '<table border="1" style="border-collapse: collapse"><caption>Request Summary Data</caption><tr><th>Name</th><th>Daily Assignment</th><th>Daily Assignment limit</th><th>Monthly Assignment</th><th>Daily Assignment limit</th></tr>';
                
                for(Showroom_User__c su :showroomUserList){
                    String userName = su.Name;
                    Decimal userDailyAssg = su.Daily_Assignment__c;
                    Decimal userDailyLimit = su.Daily_Assignment_Limit__c;
                    Decimal userMonthlyAssg = su.Monthly_Assignment__c;
                    Decimal userMonthlyLimit = su.Monthly_Assignment_Limit__c;
                    htmlBody += '<tr><td style= "text-align: center">' + userName + '</td><td style= "text-align: center">' + userDailyAssg  + '</td><td style= "text-align: center">' + userDailyLimit + '</td><td style= "text-align: center">' +  userMonthlyAssg  + '</td><td style= "text-align: center">' + userMonthlyLimit   + '</td></tr>';
                }
                
                htmlBody += '</table>';
                
                String subject = 'Daily/Monthly limit for Pronto Paint has reached '+ cumulativeValue +'% utilization';
                String messageBody = '<html><body> Team,<br>The daily/monthly cumulative assignment for the Pronto Paint specialist has reached '+ cumulativeValue +'%. Please check if the limit needs to be changed.<br>Thanks </body></html>';
                
                mail.setSubject(subject);
                mail.setHtmlBody(messageBody+htmlBody);
                mailList.add(mail); 
                
            }
        }
        
        if(!mailList.isEmpty()){
            Messaging.sendEmail(mailList);
        }
    }
    
    
    
}