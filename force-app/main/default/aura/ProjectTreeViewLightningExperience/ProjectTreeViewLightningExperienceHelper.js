({
    getProjectrec :function(component, proid) {
        
    	console.log('displaying first..........');
        var action = component.get("c.getProrec");
        action.setParams({ 
            "proid": proid
        });
        action.setCallback(this, function(a) {
            console.log('-----------return mile-----------',a.getReturnValue() );
            if(a.getReturnValue()==''){
                console.log('Null');
                component.set("v.count",0);
                console.log(component.get("v.count"));
            }
            else{
                console.log(' Not NULL');
                component.set("v.projectrec",a.getReturnValue());
                component.set("v.count",1);
                console.log(component.get("v.count"));
            }
            this.hideSpinner(component);
        });
        
        $A.enqueueAction(action);
    },
     getStatus: function(component) {
         var action = component.get("c.getstatusval");
         action.setCallback(this, function(a) {
             console.log('Status ------>',a.getReturnValue()[0]);
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
    getSubtask :function(component, taskiids) {
         var action = component.get("c.getsubTasks");
        action.setParams({ 
            "taskiids": taskiids
        });
        action.setCallback(this, function(a) {
            console.log('-----------return-----------',a.getReturnValue());
            if(a.getReturnValue()==''){
                console.log('empty');
            }
            else{
                console.log(' Not empty');
                component.set("v.subtasks",a.getReturnValue());
            }
            this.hideSpinner(component);
        });
          $A.enqueueAction(action);
    },
    editMilestone:function(component, prorecid) {
        
         var action = component.get("c.editmilestone");
        action.setParams({ 
            "prorecid": prorecid
        });
        action.setCallback(this, function(a) {
            console.log('-----------edit record-----------',a.getReturnValue());
            if(a.getReturnValue()==''){
                console.log('empty'); 
            }
            else{
                console.log(' Not empty');
                component.set("v.editrecord",a.getReturnValue());
                var s = component.get("v.statusval");
                var newstatusval = [];
                for(var i = 0;i<s.length;i++){
                    console.log(s[i]);
                    if(s[i] == component.get("v.editrecord[0].Status__c")){
                    }
                    else{
                        newstatusval.push(s[i]);
                    }
                }
                component.set("v.milestatusval",newstatusval)
        var cmpForm1 = component.find('form1');
        var cmpForm2 = component.find('form2');
        $A.util.removeClass(cmpForm1, 'slds-fade-in-close');
        $A.util.removeClass(cmpForm2, 'slds-backdrop--close');
        $A.util.addClass(cmpForm1, 'slds-fade-in-open');
        $A.util.addClass(cmpForm2, 'slds-backdrop--open');
            }
        });
        
          $A.enqueueAction(action);
    
    },
    editTasks :function(component, tasksrecid) {
    	 
        var action = component.get("c.edittask");
        action.setParams({ 
            "tasksrecid": tasksrecid
        });
        action.setCallback(this, function(a) {
            console.log('-----------edit task record-----------',a.getReturnValue());
            if(a.getReturnValue()==''){
                console.log('empty'); 
            }
            else{
                console.log(' Not empty');
                component.set("v.edittskrecord",a.getReturnValue());
                var s = component.get("v.statusvaltsk");
                var newstatusval = [];
                for(var i = 0;i<s.length;i++){
                    console.log(s[i]);
                    if(s[i] == component.get("v.edittskrecord[0].Status__c")){
                    }
                    else{
                        newstatusval.push(s[i]);
                    }
                }
                component.set("v.taskstatusval",newstatusval)
                var cmpForm1 = component.find('taskform1');
                var cmpForm2 = component.find('taskform2');
                $A.util.removeClass(cmpForm1, 'slds-fade-in-close');
                $A.util.removeClass(cmpForm2, 'slds-backdrop--close');
                $A.util.addClass(cmpForm1, 'slds-fade-in-open');
                $A.util.addClass(cmpForm2, 'slds-backdrop--open');
            }
        });
          $A.enqueueAction(action);
    },
    saveMilerec:function(cmp,obj,mileoldlist) {
        var cmpForm1 = cmp.find('form1');
        var cmpForm2 = cmp.find('form2');
        $A.util.removeClass(cmpForm1, 'slds-fade-in-open');
        $A.util.removeClass(cmpForm2, 'slds-backdrop--open');
        $A.util.addClass(cmpForm1, 'slds-fade-in-close');
        $A.util.addClass(cmpForm2, 'slds-backdrop--close');
        
        console.log('Saving milestone..........');
        console.log('obj..........',obj);
        console.log('mileoldlist..........',mileoldlist);
    	var action = cmp.get("c.savemilestonerec");
        console.log('updates list',JSON.stringify(obj));
        action.setParams({ 
            "mileobj": obj,
            "mileoldlist": mileoldlist
        });
         action.setCallback(this, function(a) {
            console.log('-----------return record-----------',a.getReturnValue());
            if(a.getReturnValue()==''){
                console.log('empty');
            }
            else{
                console.log(' Not empty');
                cmp.set("v.projectrec",a.getReturnValue());
               
                var cmpForm1 = cmp.find('form1');
        var cmpForm2 = cmp.find('form2');
        
        $A.util.removeClass(cmpForm1, 'slds-fade-in-open');
        $A.util.removeClass(cmpForm2, 'slds-backdrop--open');
        $A.util.addClass(cmpForm1, 'slds-fade-in-close');
        $A.util.addClass(cmpForm2, 'slds-backdrop--close');
       
            }
        });
          $A.enqueueAction(action);
    },
    savesubmilerec:function(cmp,obj,mileoldlist) {
         var action = cmp.get("c.savesubmilestonerec");
        console.log('updates list',JSON.stringify(obj));
        action.setParams({ 
            "mileobj": obj,
            "mileoldlist": mileoldlist
            
        });
         action.setCallback(this, function(a) {
            console.log('-----------return submilerecord-----------',a.getReturnValue());
            if(a.getReturnValue()==''){
                console.log('empty');
            }
            else{
                console.log(' Not return value');
                
                cmp.set("v.submilestone",a.getReturnValue());
                //update parent list
               
                var cmpForm1 = cmp.find('submileform1');
        var cmpForm2 = cmp.find('submileform2');
        
        $A.util.removeClass(cmpForm1, 'slds-fade-in-open');
        $A.util.removeClass(cmpForm2, 'slds-backdrop--open');
        $A.util.addClass(cmpForm1, 'slds-fade-in-close');
        $A.util.addClass(cmpForm2, 'slds-backdrop--close');
       
            }
        });
          $A.enqueueAction(action);
    },
    saveTaskrec:function(cmp,obj,tskoldlist) { 
        var action = cmp.get("c.savetaskrec");
        console.log('updates list',JSON.stringify(obj));
        action.setParams({ 
            "tskobj": obj,
            "tskoldlist": tskoldlist
        });
         action.setCallback(this, function(a) {
            console.log('-----------return task record-----------',a.getReturnValue());
            if(a.getReturnValue()==''){
                console.log('empty');
            }
            else{
                console.log(' Not empty');
                cmp.set("v.tasks",a.getReturnValue());
               console.log('after setting value');
                var cmpForm1 = cmp.find('taskform1');
        var cmpForm2 = cmp.find('taskform2');
        
        $A.util.removeClass(cmpForm1, 'slds-fade-in-open');
        $A.util.removeClass(cmpForm2, 'slds-backdrop--open');
        $A.util.addClass(cmpForm1, 'slds-fade-in-close');
        $A.util.addClass(cmpForm2, 'slds-backdrop--close');
          console.log('returneddddddd');      
       
            }
        });
          $A.enqueueAction(action);
        
    },
    
    showSpinner : function(component){
        
        var today = new Date();
 		var currentdate = today.getFullYear()+"-"+(today.getMonth()+ 1)+"-"+today.getDate();
        component.set("v.today");
        
        var spin = component.find("spinnerId");
        $A.util.removeClass(spin,"slds-backdrop--close");
        $A.util.addClass(spin, "slds-backdrop--open");
        
        
        var spinChild = component.find("spinnerIdChild");
        $A.util.removeClass(spinChild,"slds-fade-in-close");
        $A.util.addClass(spinChild, "slds-fade-in-open");
    },
     hideSpinner : function(component){
        var spin = component.find("spinnerId");
        $A.util.removeClass(spin,"slds-backdrop--open");
        $A.util.addClass(spin, "slds-backdrop--close");
        
        var spinChild = component.find("spinnerIdChild");
        $A.util.removeClass(spinChild,"slds-fade-in-open");
        $A.util.addClass(spinChild, "slds-fade-in-close");
         
         
    }
   
    
})