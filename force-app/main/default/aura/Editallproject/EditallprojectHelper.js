({
    showSpinner : function(component){
        var spin = component.find("spinnerIdChild");
        $A.util.removeClass(spin,"slds-backdrop--close");
        $A.util.addClass(spin, "slds-backdrop--open");
        var spinChild = component.find("spinnerIdChildCh");
        $A.util.removeClass(spinChild,"slds-fade-in-close");
        $A.util.addClass(spinChild, "slds-fade-in-open");
    },
    getProjectrec :function(component, proid) {
        
    	console.log('displaying first..........');
        var action = component.get("c.getProrec");
        console.log('debug2.....');
        action.setParams({ 
            "proid": proid
        });
        action.setCallback(this, function(a) {
            console.log('-----------return mile-----------',a.getReturnValue() );
            if(a.getReturnValue()==''){
                console.log('Null');
                //component.set("v.count",0);
                //console.log(component.get("v.count"));
            }
            else{
                console.log(' Not NULL');
                component.set("v.projectrec",a.getReturnValue());
                
                //component.set("v.count",1);
                //console.log(component.get("v.count"));
               
            }
           
            
            this.hideSpinner(component);
        });
        
        
        $A.enqueueAction(action);
    },
     hideSpinner : function(component){
        var spin = component.find("spinnerIdChild");
        $A.util.removeClass(spin,"slds-backdrop--open");
        $A.util.addClass(spin, "slds-backdrop--close");
        
        var spinChild = component.find("spinnerIdChildCh");
        $A.util.removeClass(spinChild,"slds-fade-in-open");
        $A.util.addClass(spinChild, "slds-fade-in-close");
    },
     getSubmiles:function(component, submileid) {
    	
        var action = component.get("c.getSubmile");
        action.setParams({ 
            "submileid": submileid
        });
        action.setCallback(this, function(a) {
            console.log('-----------return mile-----------',a.getReturnValue());
            console.log('-----------return state-----------',a.getState());
            if(a.getReturnValue()==''){
                console.log('empty');
                
            }
            else{
                console.log(' Not empty');
				console.log('submilestone-->bfer',component.get("v.submilestone"));
                component.set("v.submilestone",a.getReturnValue());
                console.log('submilestone-->after',component.get("v.submilestone"));
            }
            this.hideSpinner(component);
        });
          $A.enqueueAction(action);
        
    },
     getTask:function(component, submilesid) {
    	var action = component.get("c.getTasks");
        action.setParams({ 
            "submilesid": submilesid
        });
        action.setCallback(this, function(a) {
            console.log('-----------return-----------',a.getReturnValue());
            if(a.getReturnValue()==''){
                console.log('empty');
            }
            else{
                console.log(' Not empty');
                component.set("v.tasks",a.getReturnValue());
            }
            this.hideSpinner(component);
        });
          $A.enqueueAction(action);
        
    },
    savedata:function(component) {
        var milelist = component.get("v.projectrec");
        var submilelist = component.get("v.submilestone");
        var taskslist = component.get("v.tasks");
        console.log('********milelist********'+milelist);
        console.log('********milelist comma********',milelist);
        var action = component.get("c.saveEditdata");
        action.setParams({ 
            "milelist": milelist,
            "submilelist": submilelist,
            "taskslist": taskslist
        });
        action.setCallback(this, function(a) {
            
            
            
            // check response 
             var state = a.getState();
            if (state === "SUCCESS") {
                
				console.log('success');
                this.hideSpinner(component);
              
            }
            else if (state === "INCOMPLETE") {
                console.log('incomplete---------------');
            }
            else if (state === "ERROR") {
                this.hideSpinner(component);
                var errors = a.getError();
                console.log('errors',errors);
                if (errors) {
                    alert(errors[0].pageErrors[0].message);
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: ",errors[0].pageErrors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
            
            
        });
         $A.enqueueAction(action);
    },
    getStatus: function(component) {
         var action = component.get("c.getstatusval");
         action.setCallback(this, function(a) {
             console.log('Status edit ------>',a.getReturnValue()[0]);
             console.log('statusval----------->>>>>>>>>',a.getReturnValue());
             component.set("v.statusval",a.getReturnValue());
         });
         $A.enqueueAction(action); 
     },
    getTaskstatus: function(component) {
        var action = component.get("c.getstatusvaltsk");
        action.setCallback(this, function(a) {
            console.log('Status ------>',a.getReturnValue()[0]);
            component.set("v.statusvaltsk",a.getReturnValue());
        });
        $A.enqueueAction(action); 
    },
})