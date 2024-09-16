({
	 
    getProjectrecord : function(component){
        
        var inputCmp = component.find("inputBed");
        var value = inputCmp.get("v.value");
        console.log(value);
        if(value > 25){
            console.log('Error');
        }
        
        var oppid = component.get("v.oppId");
        var property = component.get("v.propertyname");
        var projectrec = component.get("v.projectrecord");
        
        projectrec.Opportunity_Project__c = oppid;
        projectrec.Name = property;
        var strSelectedTemplate = component.get("v.templatename");
        var action = component.get("c.saveProject");
        console.log('action-------',action);
        action.setParams({ 
            "projectrec": projectrec,
            "strSelectedTemplate" : strSelectedTemplate
             
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Success ID---------',response.getReturnValue().Id);
                component.set("v.projectID",response.getReturnValue().Id);
            }
        });
        $A.enqueueAction(action);
                
        var cmpForm1 = component.find('form1');
        var cmpForm2 = component.find('form2');
        $A.util.removeClass(cmpForm1, 'slds-fade-in-open');
        $A.util.removeClass(cmpForm2, 'slds-backdrop--open');
        $A.util.addClass(cmpForm1, 'slds-fade-in-close');
        $A.util.addClass(cmpForm2, 'slds-backdrop--close');
        
        
    },
     getTemplatep: function(cmp){
        
        console.log("RUN");
        var cmpForm1 = cmp.find('form1');
        var cmpForm2 = cmp.find('form2');
        $A.util.removeClass(cmpForm1, 'slds-fade-in-close');
        $A.util.removeClass(cmpForm2, 'slds-backdrop--close');
        $A.util.addClass(cmpForm1, 'slds-fade-in-open');
        $A.util.addClass(cmpForm2, 'slds-backdrop--open');
        
        var action = cmp.get("c.getTemplates");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Success',response.getReturnValue());
                cmp.set("v.tempname", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
     },
 
   
})