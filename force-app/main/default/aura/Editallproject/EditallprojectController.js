({
	 clickjs : function(component, event, helper) {
        
        helper.showSpinner(component);
        var proid = component.get("v.projectid");
        console.log("proid..........",proid);
        helper.getProjectrec(component, proid);
        
    },
    saveeditall : function(component, event, helper) {
        helper.showSpinner(component);
        helper.savedata(component);
        
    },
    getsubmilestone : function(component, event, helper) {
        helper.savedata(component);
        helper.showSpinner(component);
        console.log('submilestone------0',component.get('v.submilestone'))
        console.log('event id----------',event.target.getAttribute('id'));
        var submileid = event.target.getAttribute('id');
        component.set("v.parentid",submileid);
        helper.getSubmiles(component, submileid);
        
    },
    gettasks : function(component, event, helper) {
        
        helper.savedata(component);
        helper.showSpinner(component);
        var submilesid = event.target.getAttribute('id');
        console.log('submilesid',submilesid);
        component.set("v.submileparentid",submilesid);
        helper.getTask(component, submilesid);  
    },
    loadstatus : function(component, event, helper) {
        helper.getStatus(component);
        console.log('statusval - val ......',component.get("v.statusval"));
    },
    loadstatustsk : function(component, event, helper) {
        helper.getTaskstatus(component);
    } 

})