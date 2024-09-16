@RestResource(urlMapping='/assignment_trigger/*')
    global class assignment_trigger{
        @HttpPost
        global static Date index(){
           
            //created for CX-DP assignment trigger we will be passing the data as params in dd-mm-yyyy (17-01-2019) format and key will be 'trigger_date'
            RestRequest req = RestContext.request;
            String leadinput = req.requestBody.toString();
         //   String leadinput = '{"date":"2019-01-22"}';            
            system.debug('******leadinput *******'+leadinput );
            Map<String, Object> json_req_input = (Map<String, Object>)JSON.deserializeUntyped(leadinput);           
            system.debug('******json_req_input assignment_trigger*******'+json_req_input );
            String dat = (String)json_req_input.get('date');
            system.debug('******dat *******'+dat );
            List<String> strDate = dat.split('-');
            Integer myIntDate = integer.valueOf(strDate[2]);
            Integer myIntMonth = integer.valueOf(strDate[1]);
            Integer myIntYear = integer.valueOf(strDate[0]);
            system.debug('******myIntDate *******'+myIntDate+'******myIntMonth  '+myIntMonth +'********myIntYear   '+myIntYear );
            Date myDate = Date.newInstance(myIntYear, myIntMonth, myIntDate);
            system.debug('******myDate *******'+myDate );
            system.debug('******Date.Today()*******'+Date.Today());
            if(myDate >= Date.Today())
            DPAssignmentcallBatchV2.MeetingCreation(myDate );
           
            return null;
        }
        
    }