({
    closemodal : function(component, event, helper) {
        console.log('close modal');
        $( "#mainmodal" ).removeClass( "slds-fade-in-open" );
        $( "#mainmodal" ).addClass( "slds-fade-in-close" );
        $( "#fadediv" ).removeClass( "slds-backdrop_open" );
        $( "#fadediv" ).addClass( "slds-backdrop_close" );
        $( "#phonealert" ).addClass( "showdiv" );
        
    },
    closemodal2 : function(component, event, helper) {
        console.log('close modal');
        $( "#phonealert" ).addClass( "showdiv" );
        $( "#mainmodalnc" ).removeClass( "slds-fade-in-open" );
        $( "#mainmodalnc" ).addClass( "slds-fade-in-close" );
        $( "#fadediv" ).removeClass( "slds-backdrop_open" );
        $( "#fadediv" ).addClass( "slds-backdrop_close" );
        
    }, 
    changepropertytype: function(component, event, helper) {
    	console.log('Property type changed');
        var selectval = component.get("v.newLead.Property_Type__c");
        console.log('selectval ----->',selectval);
        if(selectval =='Independent House'){
            $( "#independentdiv" ).removeClass( "showdiv" );
        }
        else {
            $( "#independentdiv" ).addClass( "showdiv" );
        }
  },
    changeotherreason: function(component, event, helper) {
        var newLed = component.get("v.newLead");
        console.log('How did you hear');
        var selectval = component.get("v.newLead.How_did_you_hear_about_us__c");
        console.log('selectval ----->',selectval);
        var flag=0;
        if(selectval =='Others'){
            $( "#otherdiv" ).removeClass( "showdiv" ); 
            $( "#referrerphone" ).addClass( "showdiv" ); 
            flag=1;
        }
        if(selectval =='Refered by a friend who has used HL'){
            $( "#referrerphone" ).removeClass( "showdiv" ); 
            $( "#otherdiv" ).addClass( "showdiv" );
            flag=1;
        }
        if(selectval =='Refered by a friend who knows about HL'){
            $( "#referrerphone" ).removeClass( "showdiv" ); 
            $( "#otherdiv" ).addClass( "showdiv" );
            flag=1;
        }
        if(selectval =='Broker/Channel Partner'){
            $( "#BrokerLookup" ).removeClass( "showdiv" ); 
            $( "#otherdiv" ).addClass( "showdiv" );
            $( "#referrerphone" ).addClass( "showdiv" );
            flag=1;
        }
        if(selectval != 'Broker/Channel Partner'){
            $( "#BrokerLookup" ).addClass( "showdiv" );
            component.set("v.newLed.Channel_Partner__c","");
           // console.log('v.newLed.Channel_Partner__c: ',component.get("v.newLed.Channel_Partner__c");
            console.log('newLed.Channel_Partner__c: '+newLed.Channel_Partner__c);
            flag=1;
        }
        if(flag == 0){
            $( "#referrerphone" ).addClass( "showdiv" ); 
            $( "#otherdiv" ).addClass( "showdiv" );
        } 
    },
    
    openmodal : function(component, event, helper) {
        console.log('close modal');
        $( "#mainmodal" ).removeClass( "slds-fade-in-close" );
        $( "#mainmodal" ).addClass( "slds-fade-in-open" );
        $( "#fadediv" ).removeClass( "slds-backdrop_close" );
        $( "#fadediv" ).addClass( "slds-backdrop_open" );
        $( "#phonealert" ).addClass( "showdiv" );
        $( "#ChannelPartnerAlert" ).addClass( "showdiv" );
    },
    openmodal2 : function(component, event, helper) {
        console.log('close modal 1');
        $( "#pgalert2" ).hide();
        $( "#mainmodalnc" ).removeClass( "slds-fade-in-close" );
        $( "#mainmodalnc" ).addClass( "slds-fade-in-open" );
        $( "#fadediv" ).removeClass( "slds-backdrop_close" );
        $( "#fadediv" ).addClass( "slds-backdrop_open" );
        
    }, 
    createLead : function(component, event) {
        debugger;
        console.log('Saving.....');
        var selectval = component.get("v.newLead.How_did_you_hear_about_us__c");
        console.log('selectval ----->',selectval);
        var oldLead = component.get("v.existingLead");
        console.log('oldLead lead ----------->',oldLead);
        
        console.log('Saving.....1');
        var newLed = component.get("v.newLead");
        console.log('Saving.....2');
        console.log('newLed.Channel_Partner__c: '+newLed.Channel_Partner__c);
        component.set("v.newLead.Builder_Name__c",component.get("v.selectedLookUpRecord").Id);
        component.set("v.newLead.Property__c",component.get("v.selectedLookUpProperty").Id);
        component.set("v.newLead.Appointment_Venue_Square__c",component.get("v.selectedLookUpAppointmentvenue").Id);
        component.set("v.newLead.Interior_Designer__c",component.get("v.selectedLookUpDP").Id);
        component.set("v.newLead.Customer_ID_of_Referrer__c",component.get("v.selectedLookUpReferalname").Id);
        component.set("v.newLead.Employee_Referrer_Name__c",component.get("v.selectedLookUpempReferalname").Id); 
      //  newLed.LeadSource = 'Walk-in';
        newLed.LeadSource = oldLead.LeadSource;
        var sourceChange;
        var flag = 0;
        var phno = component.get("v.newLead.HL_Referrer_Phone__c");        
        oldLead.HL_Referrer_Phone__c = phno;
        console.log('oldLead.HL_Referrer_Phone__c.....'+oldLead.HL_Referrer_Phone__c);
        var phoneno = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;
        
            
        if(selectval == 'Refered by a friend who has used HL' || selectval == 'Refered by a friend who knows about HL') {
            if(oldLead.HL_Referrer_Phone__c != null) {
                if(phoneno.test(phno) == false) {            
                    flag = 2;               
                }
                if(phno == undefined) {
                    flag = 2;
                }
                sourceChange = 'Walk-in Referral';
                newLed.LeadSource = sourceChange;
            }
        }
        if(selectval =='Others') {
            flag = 1;
        }
        
        console.log('newLed.LeadSource.....',newLed.LeadSource);
        console.log('Saving.....3');
        newLed.Status = 'Appointment Fixed';
        newLed.Sub_Status__c = 'Appointment Fixed';
        console.log('Saving.....4');
        newLed.Id = oldLead.Id;
        //newLed.LeadSource = oldLead.LeadSource;
        console.log('lead ----------->',oldLead);
        console.log('new lead ----------->',newLed);
        var HLawai = component.get("v.newLead.How_did_you_hear_about_us__c");
        var builder = component.get("v.newLead.Builder_Name__c");
        var property = component.get("v.newLead.Property__c");
        var appointmentvenue = component.get("v.newLead.Appointment_Venue_Square__c");
        var DP = component.get("v.newLead.Interior_Designer__c");
        var channelPartner = component.get("v.newLead.Channel_Partner__c");
        
        console.log('lead ----------->',HLawai,'lead ----------->',builder,'lead ----------->',property,'lead ----------->',appointmentvenue,'lead ----------->',DP,'referral phone ----------->',phno);
        if(builder == undefined || property == undefined || appointmentvenue == undefined || DP == undefined || HLawai =='None' || flag ==1){
            console.log('INSIDE UNDEFINED');
            $( "#pgalert" ).removeClass( "showdiv" );       
            $( "#spnr" ).addClass( "showspr" );  
        }
        else if(flag == 2) {
            $( "#phonealert" ).removeClass( "showdiv" );
             $( "#pgalert" ).addClass( "showdiv" );
        }
        else if(HLawai == 'Broker/Channel Partner' && (channelPartner == undefined || channelPartner =="")){
            $( "#spnr" ).addClass( "showspr" );
            $( "#ChannelPartnerAlert" ).removeClass( "showdiv" );
        }
        else if(flag == 0) {            
            $( "#spnr" ).removeClass( "showspr" );
            $( "#pgalert" ).addClass( "showdiv" );
            $( "#phonealert" ).addClass( "showdiv" );
            var action = component.get("c.saveLead ");
            action.setParams({ 
                "led": newLed
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS") {
                    var name = a.getReturnValue();
                   // $( "#spnr" ).addClass( "showspr" );
                    if(name != null){
                         $( "#spnr" ).addClass( "showspr" );
                         component.set("v.errorMsg",name);
                        $( "#pgDupalert" ).removeClass( "showdiv" );

                    }else{    
                    location.reload();
                    }
                }
            }); 
        }
        $A.enqueueAction(action) 
    },
changepathform : function(component, event) {
    	//debugger;
        $( "#spnr" ).removeClass( "showspr" );
        console.log('path clicked');
        console.log(event.target.id);
        $( "#pgDupalert" ).addClass( "showdiv" );
    $( "#phonealert" ).addClass( "showdiv" );
        if(event.target.id =='path-1'){
            
            $( "#path-1Div" ).removeClass( "showdiv" );
            $( "#path-2Div" ).addClass( "showdiv" );
            $( "#path-3Div" ).addClass( "showdiv" );
            $( "#path-4Div" ).addClass( "showdiv" );
            $( "#path-5Div" ).addClass( "showdiv" );
             $( "#spnr" ).addClass( "showspr" );
        }
        else if(event.target.id =='path-2'){
            component.set("v.btnn", 'Property Details');
            console.log('property details clicked-2');
            var newLed = component.get("v.newLead");
            console.log('lead data --------->',newLed);
            var oldLead = component.get("v.existingLead");
            var fname = component.get("v.newLead.FirstName");
            var lname = component.get("v.newLead.LastName");
            var lsource = component.get("v.newLead.LeadSource");
            var city = component.get("v.newLead.City");
            var email = component.get("v.newLead.Email");
            var phno = component.get("v.newLead.Phone");
            var whats = component.get("v.whatsapp");
            var whatsappvalue;
            console.log('Whatsapp PATH 2 ---> '+whats);
            if(whats == 'Yes') {
                whatsappvalue = true;
            }
            else if(whats == 'No') {
                whatsappvalue = false;
            }
            console.log('Whatsapp 2 PATH 2---> '+whatsappvalue);  
            
            component.set("v.newLead.Whatsapp_Opt_in__c",whatsappvalue);
            
            var phoneno = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;
            var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
            var FLname = /^[A-Za-z," "]+$/;
            console.log('emailReg ----------->',FLname.test(fname));
            if(fname == '' || (lname == '' || lname == null) || city == 'None' || email == '' || phno == '' || phoneno.test(phno) == false
               || emailReg.test(email) == false || FLname.test(fname) == false || FLname.test(lname) == false || whats == 'None' || lsource == 'None'){
                $( "#pgalert" ).removeClass( "showdiv" );
                console.log('filter.testphno --->',phoneno.test(phno));
                if(phoneno.test(phno) == false){
                    $( "#inputphone" ).addClass( "slds-has-error" ); 
                }
                if(emailReg.test(email) == false){
                    $( "#inputemail" ).addClass( "slds-has-error" ); 
                }
                if(FLname.test(fname) == false){
                    $( "#inputFname" ).addClass( "slds-has-error" ); 
                }
                if(FLname.test(lname) == false){
                    $( "#inputLname" ).addClass( "slds-has-error" ); 
                }
                $( "#spnr" ).addClass( "showspr" );  
            }
         
            else{
                console.log('emailRegElse ----------->');
                $( "#pgalert" ).addClass( "showdiv" );
              //  console.log('OLD LEAD PATH 2 ----------->',oldLead);
                if(component.get("v.btnn") == 'Property Details') {
                    console.log('INSIDE DISABLED');
                    document.getElementById('customdetails').classList.remove('slds-is-current');
                    document.getElementById('customdetails').classList.add('slds-is-incomplete');
                    document.getElementById('customdetails').style.pointerEvents = 'none';
                }
                var action = component.get("c.checkExistingLead");
               
                var phoneStr = component.get("v.newLead.Phone");
                var emailStr = component.get("v.newLead.Email");
                var leadCity = component.get("v.newLead.City");
                var leadsource = component.get("v.newLead.LeadSource");
               // var existingLead = component.get("v.newLead");
                console.log('emailRegElse ----------->'+phoneStr+'----email---'+emailStr+'-----leadSource---'+leadsource);
                console.log('Action---> '+action);
                
            action.setParams({"leadObj": newLed});
            action.setCallback(this, function(a) {
                console.log('a.getState()--->  '+a.getState());
                var state = a.getState();
               // alert(state);
                if (state === "SUCCESS") {
                    var objLead = a.getReturnValue();
                    console.log('------returndata---'+objLead);
                    console.log('------Button Cust Details---'+component.get("v.btnn"));
                   if(objLead == null) {
                            console.log('INSIDE FIRST IF');
                            component.set("v.errorMsg","Lead already exists with same email or phone."); 
                            $( "#phonealert2" ).removeClass( "showdiv" );
                            $( "#spnr" ).addClass( "showspr" );
                        }
                    else if(objLead != null){
                        
                         if(objLead.Status == 'Appointment Confirmed' || objLead.Status == 'DP Assigned' || objLead.Status == 'Appointment Successful'){
                            console.log('INSIDE SECOND IF');
                           component.set("v.errorMsg","Lead already exists with same email or phone."); 
                           $( "#phonealert2" ).removeClass( "showdiv" );
                        }
                         else{
                            console.log('INSIDE ELSE');   
                            $( "#pgalert" ).addClass( "showdiv" );
                		 $( "#path-1Div" ).addClass( "showdiv" );
               			 $( "#path-3Div" ).addClass( "showdiv" );
               			 $( "#path-2Div" ).removeClass( "showdiv" );
               			 $( "#propdetails" ).removeClass( "slds-is-incomplete" );
               			 $( "#propdetails" ).addClass( "slds-is-current" );
               			 $( "#path-4Div" ).addClass( "showdiv" );
               			 $( "#path-5Div" ).addClass( "showdiv" );
                         $( "#pgDupalert" ).addClass( "showdiv" );
                         $( "#phonealert2" ).addClass( "showdiv" );
                         component.set("v.existingLead",objLead);
                             console.log('v.existingLead - Path 2 '+objLead);  
                        }                                                       
                    } 
                    else {
                        console.log('INSIDE MAIN ELSE'); 
                         $( "#pgalert" ).addClass( "showdiv" );
                		 $( "#path-1Div" ).addClass( "showdiv" );
               			 $( "#path-3Div" ).addClass( "showdiv" );
               			 $( "#path-2Div" ).removeClass( "showdiv" );
               			 $( "#propdetails" ).removeClass( "slds-is-incomplete" );
               			 $( "#propdetails" ).addClass( "slds-is-current" );
               			 $( "#path-4Div" ).addClass( "showdiv" );
               			 $( "#path-5Div" ).addClass( "showdiv" );
                        $( "#phonealert2" ).addClass( "showdiv" );
                    }
                    $( "#spnr" ).addClass( "showspr" );  
                }
            }); 
        
        	$A.enqueueAction(action);
        	}
        }
        else if(event.target.id =='path-3'){
            component.set("v.btnn", 'Requirement Details');
            console.log('Property details clicked-3');
            var oldLead = component.get("v.existingLead");
            var newLed = component.get("v.newLead");
            console.log('lead data in requirement section--------->',newLed);
            var builder = component.get("v.newLead.Builder_Name__c");
            var property = component.get("v.newLead.Property__c");
            var propertytype = component.get("v.newLead.Property_Type__c");
            var propertyconfg = component.get("v.newLead.Property_Config__c");
            var propertystatus = component.get("v.newLead.Property_Status__c");
            var propertymovein = component.get("v.newLead.Property_Move_In_Date__c");
            var interiordate = component.get("v.newLead.Interior_Start_Date__c");
            
            var whats = component.get("v.whatsapp");
            var whatsappvalue;
            console.log('Whatsapp PATH 3 ---> '+whats);
            if(whats == 'Yes') {
                whatsappvalue = true;
            }
            else if(whats == 'No') {
                whatsappvalue = false;
            }
            console.log('Whatsapp 2 PATH 3---> '+whatsappvalue);  
            
            console.log('lead data in requirement section part 2--------->',oldLead);
            
            if(propertytype == 'None' || propertyconfg == 'None' || propertystatus == 'None' || interiordate == null || propertymovein == null){
                console.log('INSIDE IF 1 - PATH 3');
                $( "#pgalert" ).removeClass( "showdiv" );
                $( "#spnr" ).addClass( "showspr" ); 
            }
            else{
                if(component.get("v.btnn") == 'Requirement Details') {
                    console.log('INSIDE DISABLED');
                    document.getElementById('propdetails').classList.remove('slds-is-current');
                    document.getElementById('propdetails').classList.add('slds-is-incomplete');
                    document.getElementById('propdetails').style.pointerEvents = 'none';
                }
                console.log('INSIDE ELSE - PATH 3');
                if(oldLead != null){
                    console.log('INSIDE IF 2 - PATH 3');
                    oldLead.FirstName = component.get("v.newLead.FirstName");
                    oldLead.LastName = component.get("v.newLead.LastName");
                    oldLead.City = component.get("v.newLead.City");
                    oldLead.Email = component.get("v.newLead.Email");
                    oldLead.Phone = component.get("v.newLead.Phone");
                    oldLead.Builder_Name__c = component.get("v.selectedLookUpRecord").Id;
                    oldLead.Property__c = component.get("v.selectedLookUpProperty").Id;
                    oldLead.Property_Type__c = propertytype;
                    oldLead.Property_Config__c = propertyconfg;
                    oldLead.Property_Status__c = propertystatus;
                    oldLead.Interior_Start_Date__c = interiordate; 
                    oldLead.Property_Move_In_Date__c = propertymovein;
                    oldLead.Whatsapp_Opt_in__c = whatsappvalue;
                    oldLead.Independent_House_Address__c = component.get("v.newLead.Independent_House_Address__c"); 
                   var action = component.get("c.updateExistigLead");
                    console.log('action--------->',action);
                   action.setParams({"newLead":oldLead});
                     console.log('lead data newLed--------->',newLed);
            	   action.setCallback(this, function(a) {
                    var state = a.getState();
                    var errormsg = a.getReturnValue();
                       console.log('errormsg--------->',errormsg);
               // alert(state);
                       if (errormsg != null) {
                          console.log('INSIDE ERROR - PATH 3');
                          component.set("v.errorMsg",errormsg);
                       	 $( "#pgDupalert" ).removeClass( "showdiv" );
                       }
                       $( "#spnr" ).addClass( "showspr" ); 
                   });
                    console.log('JUST BEFORE ENQUEUE - PATH 3');
                 $A.enqueueAction(action);
            	}
                 
                $( "#pgalert" ).addClass( "showdiv" );
                $( "#path-1Div" ).addClass( "showdiv" );
                $( "#path-2Div" ).addClass( "showdiv" );
                $( "#path-3Div" ).removeClass( "showdiv" );
                $( "#path-4Div" ).addClass( "showdiv" );
                $( "#path-5Div" ).addClass( "showdiv" );
                $( "#reqdetails" ).removeClass( "slds-is-incomplete" );
                $( "#reqdetails" ).addClass( "slds-is-current" );
                $( "#phonealert2" ).addClass( "showdiv" );
              //  $( "#spnr" ).addClass( "showspr" );
            }
            
        }
        else if(event.target.id =='path-4'){
            component.set("v.btnn", 'Appointment Details');
            console.log('requirement details clicked');
            var oldLead = component.get("v.existingLead");
            var newLed = component.get("v.newLead");
            console.log('lead data in requirement section--------->',newLed);
            var kitchen = component.get("v.newLead.Kitchen__c");
            var crock = component.get("v.newLead.Crockery_Unit__c");
            var vanity = component.get("v.newLead.Vanity_Unit__c");
            var study = component.get("v.newLead.Study_Table_Book_Shelf__c");
            var wardrobe = component.get("v.newLead.Wardrobes__c");
            var utility = component.get("v.newLead.Utility_Unit__c");
            var entertainment = component.get("v.newLead.Entertainment_Unit__c");
            var foyer = component.get("v.newLead.Foyer_Shoe_Rack__c");
            var poojaunit = component.get("v.newLead.Pooja__c");
          //  oldLead = JSON.parse(oldLead);
            if(kitchen == 'None' || crock == 'None' || vanity == 'None' || study == 'None'
               || utility == 'None' || entertainment == 'None' || foyer == 'None' || poojaunit == 'None'){
                
                $( "#pgalert" ).removeClass( "showdiv" );
                $( "#spnr" ).addClass( "showspr" ); 
            }
            else{
               /* if(component.get("v.btnn") == 'Appointment Details') {
                    console.log('INSIDE DISABLED');
                    document.getElementById('reqdetails').classList.remove('slds-is-current');
                    document.getElementById('reqdetails').classList.add('slds-is-incomplete');
                    document.getElementById('reqdetails').style.pointerEvents = 'none';
                }*/
                if(oldLead != null){
                  oldLead.Kitchen__c = component.get("v.newLead.Kitchen__c");
           		  oldLead.Crockery_Unit__c = component.get("v.newLead.Crockery_Unit__c");
           		  oldLead.Vanity_Unit__c = component.get("v.newLead.Vanity_Unit__c");
           		  oldLead.Study_Table_Book_Shelf__c = component.get("v.newLead.Study_Table_Book_Shelf__c");
           		  oldLead.Wardrobes__c = component.get("v.newLead.Wardrobes__c");
           		  oldLead.Utility_Unit__c = component.get("v.newLead.Utility_Unit__c");
           	      oldLead.Entertainment_Unit__c = component.get("v.newLead.Entertainment_Unit__c");
           		  oldLead.Foyer_Shoe_Rack__c = component.get("v.newLead.Foyer_Shoe_Rack__c");
           		  oldLead.Pooja__c = component.get("v.newLead.Pooja__c"); 
                   var action = component.get("c.updateExistigLead");
                   action.setParams({"newLead":oldLead});
                     console.log('lead data newLed--------->',oldLead);
            	   action.setCallback(this, function(a) {
                    var state = a.getState();
                    var errormsg = a.getReturnValue();
                       console.log('errormsg--------->',errormsg);
                    if (errormsg != null) {
                          component.set("v.errorMsg",errormsg);
                       	 $( "#pgDupalert" ).removeClass( "showdiv" );
                       }
                       $( "#spnr" ).addClass( "showspr" ); 
                   });
                 $A.enqueueAction(action);
            	}
                $( "#pgalert" ).addClass( "showdiv" );
                $( "#path-1Div" ).addClass( "showdiv" );
                $( "#path-2Div" ).addClass( "showdiv" );
                $( "#path-3Div" ).addClass( "showdiv" );
                $( "#path-4Div" ).removeClass( "showdiv" );
                $( "#path-5Div" ).addClass( "showdiv" );
                $( "#appointdetails" ).removeClass( "slds-is-incomplete" );
                $( "#appointdetails" ).addClass( "slds-is-current" );
                $( "#phonealert2" ).addClass( "showdiv" );
            }
            
        }
        else if(event.target.id =='path-5'){
            debugger;
            component.set("v.btnn", 'HL Awareness');
            console.log('HL Awareness details clicked');
            
            var oldLead = component.get("v.existingLead");
            var newLed = component.get("v.newLead");
            console.log('lead data in requirement section--------->',newLed);
            var appointmenttime = component.get("v.newLead.Appointment_Time__c");
            var timeofapp = component.get("v.newLead.Time_of_Actual_Appointment_Start__c");
            var CurrentDate = new Date();
            console.log('CurrentDate--->  ',CurrentDate,'  timeofapp--->  ',timeofapp);
            
             if(appointmenttime == '' || timeofapp == '' || appointmenttime == undefined || timeofapp == undefined){
                
                $( "#pgalert" ).removeClass( "showdiv" );
               $( "#spnr" ).addClass( "showspr" );  
            }
            else{
                if(oldLead != null){
                  oldLead.Appointment_Time__c = component.get("v.newLead.Appointment_Time__c");
           		  oldLead.Time_of_Actual_Appointment_Start__c = component.get("v.newLead.Time_of_Actual_Appointment_Start__c");
           		  oldLead.Appointment_Venue_Square__c = component.get("v.selectedLookUpAppointmentvenue").Id;
        		  oldLead.Interior_Designer__c = component.get("v.selectedLookUpDP").Id;
                  oldLead.Appointment_Type__c = component.get("v.newLead.Appointment_Type__c");
                  
                    var action = component.get("c.updateExistigLead");
                    var errormsg;
                    action.setParams({"newLead":oldLead});
                    console.log('lead data newLed HL--------->',oldLead);
                    action.setCallback(this, function(a) {
                        var state = a.getState();
                        errormsg = a.getReturnValue();
                        console.log('errormsg in--------->',errormsg);
                    
                    if (errormsg != null) {
                            console.log('INSIDE TIME OF ACTUAL APPT START');
                            $( "#timeCheck" ).removeClass( "showdiv" );
                            $( "#spnr" ).addClass( "showspr" ); 
                            //   component.set("v.errorMsg",errormsg);
                            // $( "#pgDupalert" ).removeClass( "showdiv" );
                        } 
                        else{
                          /*  if(component.get("v.btnn") == 'HL Awareness') {
                                console.log('INSIDE DISABLED');
                                document.getElementById('appointdetails').classList.remove('slds-is-current');
                                document.getElementById('appointdetails').classList.add('slds-is-incomplete');
                                document.getElementById('appointdetails').style.pointerEvents = 'none';
                            }  */                       
                            $( "#pgalert" ).addClass( "showdiv" );
                            $( "#path-1Div" ).addClass( "showdiv" );
                            $( "#path-2Div" ).addClass( "showdiv" );
                            $( "#path-3Div" ).addClass( "showdiv" );
                            $( "#path-4Div" ).addClass( "showdiv" );
                            $( "#path-5Div" ).removeClass( "showdiv" );
                            $( "#awairdetails" ).removeClass( "slds-is-incomplete" );
                            $( "#awairdetails" ).addClass( "slds-is-current" );
                            $( "#phonealert2" ).addClass( "showdiv" );
                            $( "#timeCheck" ).addClass( "showdiv" );
                            $( "#spnr" ).addClass( "showspr" ); 
                        }  
                            
                    });
                      	}
            }
                 
          $A.enqueueAction(action);  
        }
        console.log('Button--->',btn);
 		console.log('Button aura ===> ',component.get("v.btnn"));
        //console.log(component.get("v.selectedLookUpRecord").Id);
      // $( "#spnr" ).addClass( "showspr" );  
    },
    createLead2 : function(component, event) { 
        $( "#spnr" ).removeClass( "showspr" );
        console.log('path clicked');
        console.log(event.target.id);
        $( "#pgDupalert" ).addClass( "showdiv" );
        if(event.target.id =='path-10'){
            $( "#path-10Div" ).removeClass( "showdiv" );
           console.log('In path-10');
             $( "#spnr" ).addClass( "showspr" );
        }
        if(event.target.id =='leadbutton'){
            console.log('property details clicked-2');
            var newLed = component.get("v.newLead");
            console.log('lead data --------->',newLed);
            var fname = component.get("v.newLead.FirstName");
            var lname = component.get("v.newLead.LastName");
          //  component.set("v.newLead.city",component.get("v.selectedLookUpAppointmentvenue").Id);
            var discuss = component.get("v.newLead.Why_we_didn_t_offer_design_discussion__c");
            var email = component.get("v.newLead.Email");
            var phno = component.get("v.newLead.Phone");
            component.set("v.newLead.Appointment_Venue_Square__c",component.get("v.selectedLookUpAppointmentvenue").Id);
            var show = component.get("v.newLead.Appointment_Venue_Square__c");
            console.log('fname: '+fname +' lname : '+lname+' email : '+email+' phno: '+phno+' show: '+show+' discuss: '+discuss);			
            
            var phoneno = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;
            var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
            var FLname = /^[A-Za-z," "]+$/;
          //  console.log('emailReg ----------->',FLname.test(fname));
            console.log('emailReg ----------->',emailReg.test(email));
            if(fname == '' || lname == '' ||  phno == '' || phoneno.test(phno) == false || discuss == 'None'
               ||  FLname.test(fname) == false || FLname.test(lname) == false){
                $( "#pgalert2" ).show();
               // $( "#pgalert2" ).removeClass( "showdiv2" );
                console.log('filter.testphno --->',phoneno.test(phno));
                if(phoneno.test(phno) == false || phno == undefined){
                    console.log('phno : '+phno);
                    $( "#inputphone2" ).addClass( "slds-has-error" ); 
                }   
                 else {
                    $( "#inputphone2" ).removeClass( "slds-has-error" ); 
                }
                if(FLname.test(fname) == false || fname == undefined){
                    console.log('fname : '+fname);
                    $( "#inputFname2" ).addClass( "slds-has-error" ); 
                }
                else {
                    $( "#inputFname2" ).removeClass( "slds-has-error" ); 
                }
                if(FLname.test(lname) == false || lname == undefined){
                    console.log('lname : '+lname);
                    $( "#inputLname2" ).addClass( "slds-has-error" ); 
                }
                else {
                    $( "#inputLname2" ).removeClass( "slds-has-error" ); 
                }
                if(discuss == 'None'){
                    console.log('discuss : '+discuss);
                    $( "#discussid" ).addClass( "slds-has-error" ); 
                }
                else {
                    $( "#discussid" ).removeClass( "slds-has-error" ); 
                }
               
                $( "#spnr" ).addClass( "showspr" );  
            }
            else{
                console.log('emailRegElse ----------->');
                var action = component.get("c.checkExistingLeadUnqualified");
                var phoneStr = component.get("v.newLead.Phone");             
                var emailStr = component.get("v.newLead.Email");              
              //  var leadCity = component.get("v.newLead.Appointment_Venue_Square__r.Property_City__c");
                var custId = component.get("v.newLead.Customer_ID__c");
                var appvenuesqr = component.get("v.newLead.Appointment_Venue_Square__c");
                var discuss1 = component.get("v.newLead.Why_we_didn_t_offer_design_discussion__c");
               // var existingLead = component.get("v.newLead");
                 console.log('emailRegElse ----------->'+phoneStr+'----email---'+emailStr+'----appvenuesqr---'+appvenuesqr);
            action.setParams({"leadObj": newLed});
            action.setCallback(this, function(a) {
                var state = a.getState();
               // alert(state);
                if (state === "SUCCESS") {
                    var objLead = a.getReturnValue();
                    console.log('------returndata---'+emailStr);
                    if(objLead != null){
						console.log('IF CONDITION');
                        /*if(objLead.Status == 'Appointment Confirmed' || objLead.Status == 'DP Assigned' || objLead.Status == 'Appointment Successful'){
                           component.set("v.errorMsg","Lead already exists with same email or phone."); 
                           $( "#pgDupalert" ).removeClass( "showdiv" ); 
                            console.log('IF INSIDE IF 1 CONDITION');
                        }
                        else*/ if(objLead.Phone != phoneStr){
                            component.set("v.errorMsg","A lead already exists with the same email or phone number with the following Customer ID: "+objLead.Customer_ID__c); 
                           $( "#pgDupalert" ).removeClass( "showdiv" );
                          //  $( "#pgalert" ).addClass( "showdiv" );
                            $( "#pgalert2" ).hide();
                            console.log('IF INSIDE IF 1 CONDITION');
                         }else{
                            console.log('IF INSIDE IF 2 CONDITION');
                            $( "#pgalert2" ).addClass( "showdiv2" );
                		
                         $( "#pgDupalert" ).addClass( "showdiv" );
                         component.set("v.existingLead",objLead);
                             location.reload();
                        }
                           
                            
                    } else{
                         $( "#pgalert2" ).addClass( "showdiv2" );
                		console.log('ELSE CONDITION');  
                    }
                    $( "#spnr" ).addClass( "showspr" );  
                }
                               

            }); 
        
        $A.enqueueAction(action);
                
            
                
            }
            // $( "#spnr" ).addClass( "showspr" );
				// $( "#pgalert2" ).removeClass( "showdiv" );
		//	$( "#mainmodalnc" ).removeClass( "slds-fade-in-open" );
      	 // $( "#mainmodalnc" ).removeClass( "slds-fade-in-close" );
        }
 
    }, 
    expenseNameChanged: function(component, event) {
        console.log('completed.....');
        var newValue = event.getParam("value");
        var oldValue = event.getParam("oldValue");
        // alert("Expense name changed from '" + oldValue + "' to '" + newValue + "'");
        if(newValue.indexOf(" ") !== -1){
            console.log('NULL....');
        }
        else{
            //change path complete and green
            // $( "#customdetails" ).removeClass( "slds-is-current" );
            //$( "#customdetails" ).addClass( "slds-is-complete" );
        }
    },
    closealert: function(component, event) {
        $( "#pgalert" ).addClass( "showdiv" );
    },
    closealert2: function(component, event) {
        $( "#pgalert2" ).addClass( "showdiv2" );
    },
    closealert3: function(component, event) {
        $( "#ChannelPartnerAlert" ).addClass( "showdiv" );
    },
})